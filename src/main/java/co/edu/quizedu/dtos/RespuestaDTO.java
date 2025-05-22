package co.edu.quizedu.dtos;


public class RespuestaDTO {
    private boolean ok;
    private String mensaje;

    public RespuestaDTO(boolean ok, String mensaje) {
        this.ok = ok;
        this.mensaje = mensaje;
    }

    public boolean isOk() {
        return ok;
    }

    public String getMensaje() {
        return mensaje;
    }
}
