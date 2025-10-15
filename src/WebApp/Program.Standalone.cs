using eShop.WebApp.Components;

var builder = WebApplication.CreateBuilder(args);

// Simple standalone configuration without external dependencies
builder.Services.AddRazorComponents().AddInteractiveServerComponents();

// Add basic services only
builder.Services.AddLogging();
builder.Services.AddHttpClient();

var app = builder.Build();

// Configure the HTTP request pipeline
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseAntiforgery();
app.UseStaticFiles();

app.MapRazorComponents<App>().AddInteractiveServerRenderMode();

// Simple health check endpoint
app.MapGet("/health", () => "Healthy");

app.Run();