package co.edu.quizedu.config;

import org.springframework.context.ApplicationContextInitializer;
import org.springframework.context.ConfigurableApplicationContext;

import io.github.cdimascio.dotenv.Dotenv;

public class EnvLoader implements ApplicationContextInitializer<ConfigurableApplicationContext> {

    @Override
    public void initialize(ConfigurableApplicationContext applicationContext) {
        Dotenv dotenv = Dotenv.configure()
                .directory(System.getProperty("user.dir")) // Cargar desde la raíz del proyecto
                .ignoreIfMissing() // No fallar si no existe el archivo
                .load();

        dotenv.entries().forEach(entry ->
                System.setProperty(entry.getKey(), entry.getValue()) // Pasar variables a System.setProperty
        );
    }
}