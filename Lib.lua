-- Carregando as bibliotecas
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Criando a janela
local Window = Fluent:CreateWindow({
    Title = "Fluent " .. Fluent.Version,
    SubTitle = "by dawid",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- O desfoque pode ser detectado, desabilite se necessário
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Usado quando não há MinimizeKeybind
})

-- Adicionando abas
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Adicionando componentes da interface (botões, sliders, etc)
local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "Notification",
        Content = "This is a notification",
        SubContent = "SubContent", -- Opcional
        Duration = 5 -- Defina para nil se não quiser que a notificação desapareça
    })

    Tabs.Main:AddParagraph({
        Title = "Paragraph",
        Content = "This is a paragraph.\nSecond line!"
    })

    Tabs.Main:AddButton({
        Title = "Button",
        Description = "Very important button",
        Callback = function()
            Window:Dialog({
                Title = "Title",
                Content = "This is a dialog",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            print("Confirmed the dialog.")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Cancelled the dialog.")
                        end
                    }
                }
            })
        end
    })

    -- Adicionando outros componentes (Toggle, Slider, Dropdown, etc)
    -- (Mantive o código existente dos componentes, pois não houve mudança aqui)
end

-- Adicionando o botão flutuante para minimizar/mostrar o hub
local floatingButton = Instance.new("TextButton")
floatingButton.Size = UDim2.new(0, 50, 0, 50)  -- Tamanho do botão
floatingButton.Position = UDim2.new(0, 100, 0, 100)  -- Inicialmente posicionado (ajustar conforme necessário)
floatingButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)  -- Cor do botão
floatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Cor do texto
floatingButton.Text = "Min"  -- Texto inicial
floatingButton.AnchorPoint = Vector2.new(0.5, 0.5)  -- Centralizando o texto no botão
floatingButton.Parent = game.Players.LocalPlayer.PlayerGui:WaitForChild("ScreenGui")  -- Adicionando o botão à interface

-- Variável de controle para o estado da janela
local windowVisible = true

-- Função para alternar a visibilidade do hub
local function toggleWindowVisibility()
    windowVisible = not windowVisible
    if windowVisible then
        Window:Show()  -- Mostra a janela (hub)
        floatingButton.Text = "Min"  -- Atualiza o texto do botão
    else
        Window:Hide()  -- Esconde a janela (hub)
        floatingButton.Text = "Max"  -- Atualiza o texto do botão
    end
end

-- Conectar a função de alternância ao clique do botão flutuante
floatingButton.MouseButton1Click:Connect(toggleWindowVisibility)

-- Função para arrastar o botão flutuante
local dragStartPos, dragStartButtonPos
local dragging = false

floatingButton.MouseButton1Down:Connect(function(input)
    dragging = true
    dragStartPos = input.Position
    dragStartButtonPos = floatingButton.Position
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStartPos
        floatingButton.Position = UDim2.new(
            dragStartButtonPos.X.Scale, dragStartButtonPos.X.Offset + delta.X,
            dragStartButtonPos.Y.Scale, dragStartButtonPos.Y.Offset + delta.Y
        )
    end
end)

floatingButton.MouseButton1Up:Connect(function()
    dragging = false
end)

-- Handing a biblioteca para os gerenciadores
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

-- Carregar configuração automática
SaveManager:LoadAutoloadConfig()
