var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddOpenApi();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseAuthorization();
app.MapControllers();

// Maps the root URL (http://localhost:xxxx/) directly to weatherforecast
// Maps the root URL directly to weatherforecast and returns the Pod Name
app.MapGet("/", () => Results.Ok(new
{
    Message = "Hello from Kubernetes!", 
    ServedByPod = Environment.MachineName
}));

app.Run();