local g = game
for i, v in pairs(g:GetDescendants()) do
    if v:IsA("Decal") then
        v:Destroy()
    end
end