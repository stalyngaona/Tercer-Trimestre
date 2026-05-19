<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HUD Distancia PRO</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap');

        /* Variables CSS para cambiar todo el tema con JavaScript */
        :root {
            --theme-color: #00f3ff;
            --theme-glow: rgba(0, 243, 255, 0.5);
            --theme-bg: rgba(0, 243, 255, 0.05);
        }

        body {
            font-family: 'Share Tech Mono', monospace;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: transparent;
            color: var(--theme-color);
            transition: all 0.5s ease;
        }

        .hud-container {
            background: #0a0a12;
            background-image: 
                linear-gradient(var(--theme-bg) 1px, transparent 1px),
                linear-gradient(90deg, var(--theme-bg) 1px, transparent 1px);
            background-size: 20px 20px;
            padding: 25px;
            border-radius: 15px;
            border: 2px solid var(--theme-color);
            box-shadow: 0 0 20px var(--theme-glow), inset 0 0 30px var(--theme-bg);
            width: 100%;
            max-width: 280px;
            position: relative;
            overflow: hidden;
            text-align: center;
            transition: all 0.5s ease;
        }

        /* Efecto de escaneo láser que baja y sube */
        .scanline {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: var(--theme-color);
            opacity: 0.6;
            box-shadow: 0 0 15px var(--theme-color);
            animation: scan 3s infinite linear;
            z-index: 10;
        }

        @keyframes scan {
            0% { top: -10%; opacity: 0; }
            10% { opacity: 0.6; }
            90% { opacity: 0.6; }
            100% { top: 110%; opacity: 0; }
        }

        .header {
            font-size: 1em;
            letter-spacing: 2px;
            margin-bottom: 10px;
            border-bottom: 1px solid var(--theme-color);
            padding-bottom: 5px;
            text-shadow: 0 0 5px var(--theme-color);
        }

        .value-box {
            display: flex;
            justify-content: center;
            align-items: baseline;
            margin: 20px 0;
        }

        .value {
            font-size: 4.5em;
            font-weight: normal;
            text-shadow: 0 0 15px var(--theme-color);
            transition: all 0.2s ease;
        }

        .unit {
            font-size: 1.5em;
            margin-left: 8px;
            opacity: 0.8;
        }

        /* Barra gráfica */
        .bar-container {
            width: 100%;
            height: 15px;
            background: rgba(255,255,255,0.1);
            border: 1px solid var(--theme-color);
            border-radius: 10px;
            overflow: hidden;
            margin-bottom: 15px;
        }

        .bar-fill {
            height: 100%;
            width: 0%;
            background: var(--theme-color);
            box-shadow: 0 0 10px var(--theme-color);
            transition: width 0.5s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .status-msg {
            font-size: 0.9em;
            letter-spacing: 1px;
            height: 20px;
            text-shadow: 0 0 8px var(--theme-color);
        }

        /* Clases de estado que inyectará JS */
        .mode-safe {
            --theme-color: #00ffaa;
            --theme-glow: rgba(0, 255, 170, 0.5);
            --theme-bg: rgba(0, 255, 170, 0.05);
        }
        .mode-warning {
            --theme-color: #ffaa00;
            --theme-glow: rgba(255, 170, 0, 0.5);
            --theme-bg: rgba(255, 170, 0, 0.05);
        }
        .mode-danger {
            --theme-color: #ff0044;
            --theme-glow: rgba(255, 0, 68, 0.6);
            --theme-bg: rgba(255, 0, 68, 0.1);
            animation: shake 0.5s infinite;
        }

        /* Temblor para cuando está muy cerca (Peligro) */
        @keyframes shake {
            0% { transform: translate(1px, 1px) rotate(0deg); }
            10% { transform: translate(-1px, -2px) rotate(-1deg); }
            20% { transform: translate(-3px, 0px) rotate(1deg); }
            30% { transform: translate(3px, 2px) rotate(0deg); }
            40% { transform: translate(1px, -1px) rotate(1deg); }
            50% { transform: translate(-1px, 2px) rotate(-1deg); }
            60% { transform: translate(-3px, 1px) rotate(0deg); }
            70% { transform: translate(3px, 1px) rotate(-1deg); }
            80% { transform: translate(-1px, -1px) rotate(1deg); }
            90% { transform: translate(1px, 2px) rotate(0deg); }
            100% { transform: translate(1px, -2px) rotate(-1deg); }
        }
    </style>
</head>
<body>

    <div id="hud" class="hud-container mode-safe">
        <div class="scanline"></div>
        <div class="header">RADAR ULTRASÓNICO</div>
        
        <div class="value-box">
            <div id="distance-value" class="value">0.0</div>
            <div class="unit">cm</div>
        </div>

        <div class="bar-container">
            <div id="distance-bar" class="bar-fill"></div>
        </div>

        <div id="status-msg" class="status-msg">ESPERANDO DATOS...</div>
    </div>

    <!-- Script oficial de TagoIO -->
    <script type="text/javascript" src="https://admin.tago.io/dist/custom-widget.js"></script>
    
    <script>
        window.TagoIO.ready({ autoMargin: false });

        function actualizarPantalla(datos) {
            if (!datos || datos.length === 0) return;

            let valor = null;

            // Extraer el dato (Usando tu lógica probada y exitosa)
            if (datos[0] && datos[0].value !== undefined) {
                valor = parseFloat(datos[0].value);
            } else if (datos[0] && datos[0].result && datos[0].result.length > 0 && datos[0].result[0].value !== undefined) {
                valor = parseFloat(datos[0].result[0].value);
            }

            if (valor !== null) {
                // 1. Mostrar número con 1 decimal
                document.getElementById('distance-value').innerText = valor.toFixed(1);

                // 2. Llenar la barra (calculamos % sobre un máximo visual de 100cm)
                let visualMax = 100; 
                let porcentaje = (valor / visualMax) * 100;
                if (porcentaje > 100) porcentaje = 100;
                if (porcentaje < 0) porcentaje = 0;
                // La barra se llena al revés (más cerca = barra más llena)
                document.getElementById('distance-bar').style.width = (100 - porcentaje) + '%';

                // 3. Lógica Inteligente para el Profesor (Cambio de Colores y Textos)
                const hud = document.getElementById('hud');
                const msg = document.getElementById('status-msg');

                if (valor < 15) {
                    // PELIGRO (< 15 cm)
                    hud.className = 'hud-container mode-danger';
                    msg.innerText = '¡ALERTA DE IMPACTO!';
                } else if (valor >= 15 && valor < 40) {
                    // PRECAUCIÓN (15 cm - 40 cm)
                    hud.className = 'hud-container mode-warning';
                    msg.innerText = 'PRECAUCIÓN: OBJETO CERCANO';
                } else {
                    // SEGURO (> 40 cm)
                    hud.className = 'hud-container mode-safe';
                    msg.innerText = 'ZONA DESPEJADA - RASTREANDO';
                }
            }
        }

        // Ejecutar al abrir
        window.TagoIO.onStart((widget) => {
            if(widget && widget.data) actualizarPantalla(widget.data);
        });

        // Ejecutar al recibir nuevo dato
        window.TagoIO.onRealtime((data) => {
            actualizarPantalla(data);
        });
    </script>

</body>
</html>
