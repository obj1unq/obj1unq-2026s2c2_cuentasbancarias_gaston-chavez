object casa {
    var cuentaPorDefecto = cuentaCorriente
    var totalGastado = 0
    var viveres = 30 //los viveres se expresan mediante un porcentaje
    var reparaciones = 0 //las reparaciones se expresan con un costo en pesos
    var estrategiaAhorro = estrategiaMinimoEDispensable

    method gastar(monto) {
      cuentaPorDefecto.extraer(monto)
      totalGastado = totalGastado + monto
    }

    method cambioDeMes() {
      totalGastado = 0
      estrategiaAhorro.mantener(self)
    }

    method cuentaPorDefecto(_cuentaPorDefecto) {
      cuentaPorDefecto = _cuentaPorDefecto
    }

    method totalGastado() {
      return totalGastado 
    }

    method comprarViveres(porcentajeAComprar,calidad) {
      self.validarViveres(porcentajeAComprar) //Valida si puede comprar viveres con un porcentaje menor al 100%
      viveres = viveres + porcentajeAComprar // al comprar viveres, sumo el porcentaje al porcentajde viveres que tengo actualmente
      self.gastar(porcentajeAComprar * calidad) //genera un gasto calculado como: `porcentajeAComprar * calidad`
    }

    method validarViveres(porcentajeAComprar) {
      if (viveres + porcentajeAComprar > 100){
        self.error("No se puede comprar mas viveres al superar 100%")
      }
    }

    method reparaciones(monto) {
      reparaciones = reparaciones + monto
    }

    method tieneViveresSuficientes() {
      return viveres >= 40
    }

    method hayQueHacerReparacion() {
      return reparaciones > 0
    }

    method estaEnOrden() {
      return reparaciones == 0 && self.tieneViveresSuficientes()
    }

    method hacerReparaciones() {
      self.gastar(reparaciones)
      reparaciones = 0
    }

    method viveres() {
      return viveres
    }

    method estrategiaAhorro(_estrategiaAhorro) {
      estrategiaAhorro = _estrategiaAhorro
    }

    /*method mantenimiento() {
      estrategiaAhorro.mantener(self)
    }*/

    method saldo() {
      return cuentaPorDefecto.saldo()
    }

    method reparaciones() {
      return reparaciones
    }
}

object cuentaCorriente {
    var saldo = 0

    method depositar(monto) {
      saldo = saldo + monto
    }

    method extraer(monto) {
      saldo = saldo - monto
    }

    method saldo() {
      return saldo
    }

    method saldo(_saldo) {
      saldo = _saldo
    }
}

object cuentaGastos {
    var saldo = 0
    var costoOperacion = 0

    method depositar(monto) {
      self.validarDepositar(monto) // Validacion porque el enunciado dice: 
                                   //no permite un depósito de un monto menor o igual al costo de operación.
      saldo = saldo + (monto - costoOperacion)
    }

    method validarDepositar(monto) {
      if (monto <= costoOperacion){
        self.error("Monto es insuficiente")
      }
    }

    method extraer(monto) {
      saldo = saldo - monto
    }

    method costoOperacion(_costoOperacion) {
      costoOperacion = _costoOperacion
    }

    method saldo(_saldo) {
      saldo = _saldo
    }

    method saldo() {
      return saldo
    }
}

object cuentaCombinada {
    var cuentaPrimaria = cuentaCorriente
    var cuentaSecundaria = cuentaGastos

    method depositar(monto) {
      cuentaPrimaria.depositar(monto)
    }

    method extraer(monto) {
        self.validarExtraer(monto)
        var dePrimaria = 0.max(cuentaPrimaria.saldo()).min(monto) //0.max(100).min(80) = el min entre 100 y 80 = 80

        cuentaPrimaria.extraer(dePrimaria) // extraigo 80
        cuentaSecundaria.extraer(monto - dePrimaria) //extraigo el resto 100-80 = 20
    }

    method validarExtraer(monto) { // no se puede realizar ninguna extracción que supere ese monto.
      if (monto > self.saldo()){
        self.error("No hay saldo suficiente")
      }
    }

    method saldo() {
      return 0.max(cuentaPrimaria.saldo()) + 0.max(cuentaSecundaria.saldo())
    }

    method cuentaPrimaria(_cuentaPrimaria) {
      cuentaPrimaria = _cuentaPrimaria
    }

    method cuentaSecundaria(_CuentaSecundaria) {
      cuentaSecundaria = _CuentaSecundaria
    }
}

object estrategiaMinimoEDispensable {
    var calidad = 0

    method calidad(_calidad) {
      calidad = _calidad
    }
    
    method mantener(casa) {
      if(not casa.tieneViveresSuficientes()){
        casa.comprarViveres(40 - casa.viveres(), calidad)
      }
    }
}

object estrategiaFull {
    const calidad = 5

    method mantener(casa) {
      if (casa.estaEnOrden()) {
        casa.comprarViveres(100 - casa.viveres(), calidad)
      } else {
        if (casa.viveres() < 40) {
          casa.comprarViveres(40 - casa.viveres(), calidad)
        }
        
      }

      if (casa.hayQueHacerReparacion() && casa.saldo() >= casa.reparaciones()) {
          casa.hacerReparaciones()
      }
    }
}

//- Que pasa si no se logró comprar víveres?.
//no hay problema si no logro comprar viveres, las cuentas bancarias me permiten saldo negativo