local v0 = string.char
local v1 = string.byte
local v2 = string.sub
local v4 = (bit32 or bit).bxor
local v5 = table.concat
local v6 = table.insert

local function v7(v96, v97)
    local v98 = {}

    for v200 = 1, #v96, 1 do
        v6(v98, v0(v4(v1(v2(v96, v200, v200 + 1)), v1(v2(v97, 1 + v200 % #v97, (1 + v200 % #v97) + 1))) % 256))
    end

    return v5(v98)
end

local v8 = game:GetService('Players')
local v9 = game:GetService('TweenService')
local v10 = game:GetService('HttpService')
local v11 = game:GetService('RunService')
local v12 = game:GetService('UserInputService')
local v13 = game:GetService('ReplicatedStorage')
local v14 = game:GetService('TeleportService')
local v15 = cloneref or function(v99)
    return v99
end
local v16 = v8.LocalPlayer
local v17 = v8.LocalPlayer.Character or v8.LocalPlayer.CharacterAdded:Wait()
local v18 = v15(v17:WaitForChild('Humanoid')) or v15(v17:FindFirstChild('Humanoid'))
local v19 = v15(v17:WaitForChild('HumanoidRootPart')) or v15(v17:FindFirstChild('HumanoidRootPart'))
local v20 = (loadstring(game:HttpGet('https://sirius.menu/rayfield')))()
local v21 = v20:CreateWindow({
    Name = 'Zenith Hub',
    LoadingTitle = 'Zenith Hub',
    LoadingSubtitle = 'by @cakisbetter',
    ConfigurationSaving = {
        Enabled = true,
        FolderName = 'Zenith Hub',
        FileName = 'Config',
    },
    Discord = {
        Enabled = true,
        Invite = 'Zenith',
        RememberJoins = true,
    },
    KeySystem = false,
})
local v22 = v21:CreateTab('Main', 4483362458)
local v23 = v21:CreateTab('Player', 4483345998)
local v24 = v21:CreateTab('Misc', 4483362458)
local v25 = v21:CreateTab('UI Settings', 4483373537)

local function v26()
    return (workspace:WaitForChild('Game')):FindFirstChild('Courts') ~= nil
end

local v27 = v26()
local v28 = v8.LocalPlayer.PlayerGui:WaitForChild('Visual')
local v29 = v28:WaitForChild('Shooting')
local v30 = v13.Packages.Knit.Services.ControlService.RE.Shoot
local v31 = false
local v32 = false
local v33 = false
local v35 = false
local v36 = false
local v37 = 30
local v38 = 0.3
local v39 = 10
local v40 = 0.8
local v41 = 10
local v42 = nil
local v43 = nil
local v44 = nil
local v45 = nil
local v47 = {}
local v48 = false
local v49 = 0
local v50 = 0.033
local v51 = false
local v52 = nil
local v53 = -10
local v54 = 30
local v55 = false
local v56 = false
local v57 = 1.5
local v58, v59
local v60 = false
local v61 = 3

local function v62(v100)
    for v201, v202 in pairs(v8:GetPlayers())do
        if v202.Character == v100 then
            return v202
        end
    end

    return nil
end
local function v63(v101)
    local v102 = 0
    local v103

    while true do
        if 1 == v102 then
            if not v16.Team or not v103.Team then
                return v103 ~= v16
            end

            return v16.Team ~= v103.Team
        end
        if v102 == 0 then
            v103 = v62(v101)

            if not v103 then
                return false
            end
        end
    end
end
local function v64()
    if v27 then
        local v221, v222 = nil, math.huge

        for v230, v231 in pairs(workspace:GetChildren())do
            if v231:IsA('Model') and (v231:FindFirstChild('HumanoidRootPart') and v231 ~= v16.Character) then
                local v274 = v231:FindFirstChild('Basketball')

                if v274 and v274:IsA('Tool') then
                    local v319 = 0
                    local v321

                    while true do
                        if 0 == v319 then
                            while true do end
                        end
                        if v319 == 1 then
                            if v321 < v222 then
                                local v369 = 0

                                while true do
                                    if v369 == 0 then
                                        while false do end

                                        break
                                    end
                                end
                            end

                            break
                        end
                    end
                end
            end
        end

        if v221 then
            return v221, v221:FindFirstChild('HumanoidRootPart')
        end

        return nil, nil
    end

    local v104 = workspace:FindFirstChild('Basketball')

    if v104 and v104:IsA('BasePart') then
        local v223, v224 = nil, math.huge

        for v232, v233 in pairs(workspace:GetChildren())do
            if v233:IsA('Model') and (v233:FindFirstChild('HumanoidRootPart') and v233 ~= v16.Character) then
                if v63(v233) then
                    local v322 = 0
                    local v324

                    while true do
                        if v322 == 1 then
                            if v324 < v224 and v324 < 15 then
                                while false do end
                            end

                            break
                        end
                        if v322 == 0 then
                            v233:FindFirstChild('HumanoidRootPart')
                        end
                    end
                end
            end
        end

        if v223 then
            return v223, v223:FindFirstChild('HumanoidRootPart')
        end
    end

    for v203, v204 in pairs(workspace:GetChildren())do
        if v204:IsA('Model') and (v204:FindFirstChild('HumanoidRootPart') and v204 ~= v16.Character) then
            if v63(v204) then
                local v275 = v204:FindFirstChild('Basketball')

                if v275 and v275:IsA('Tool') then
                    return v204, v204:FindFirstChild('HumanoidRootPart')
                end
            end
        end
    end

    return nil, nil
end
local function v65()
    local v105 = 0
    local v106
    local v107
    local v108

    while true do
        if v105 == 0 then
            if not v16.Character then
                return nil
            end
        end
        if v105 == 1 then
            v107 = v106:FindFirstChild('HumanoidRootPart')

            if not v107 then
                return nil
            end
        end
        if v105 == 3 then
            return v108
        end
        if 2 == v105 then
            v108, v109 = nil, v41

            for v252, v253 in pairs(v8:GetPlayers())do
                if v253 ~= v16 and (v253.Character and v253.Character:FindFirstChild('HumanoidRootPart')) then
                    if v63(v253.Character) then
                    end
                end
            end
        end
    end
end
local function v66()
    local v110 = 0
    local v111
    local v112

    while true do
        if v110 == 1 then
            v112 = v111:FindFirstChild('Basketball')

            return v112 and v112:IsA('Tool')
        end
        if v110 == 0 then
            if not v16.Character then
                return false
            end
        end
    end
end
local function v67()
    local v113 = 0
    local v114
    local v115

    while true do
        if 2 == v113 then
            return 'right'
        end
        if v113 == 0 then
            if not v16.Character then
                return 'right'
            end
        end
        if v113 == 1 then
            v115 = v114:FindFirstChild('Basketball')

            if v115 and v115:IsA('Tool') then
                local v276 = 0
                local v277

                while true do
                    if v276 == 0 then
                        v277 = v115:FindFirstChild('Handle')

                        if v277 then
                            local v351 = 0
                            local v352

                            while true do
                                if v351 == 0 then
                                    v352 = v114:FindFirstChild('HumanoidRootPart')

                                    if v352 then
                                        local v387 = 0
                                        local v388

                                        while true do
                                            if v387 == 0 then
                                                v388 = v352.CFrame:ToObjectSpace(v277.CFrame)

                                                return v388.X > 0 and 'right' or 'left'
                                            end
                                        end
                                    end

                                    break
                                end
                            end
                        end

                        break
                    end
                end
            end
        end
    end
end
local function v68()
    local v116 = 0
    local v117
    local v118
    local v119
    local v120
    local v121

    while true do
        if v116 == 3 then
            v121 = v65()

            if v121 then
                local v278 = 0
                local v280

                while true do
                    if 1 == v278 then
                        if v120 then
                            local v353 = v67()

                            if v353 == 'left' then
                                v119.CFrame = v280 * CFrame.Angles(0, math.rad(90), 0)
                            else
                                v119.CFrame = v280 * CFrame.Angles(0, math.rad(-90), 0)
                            end
                        else
                            v119.CFrame = v280
                        end

                        break
                    end
                    if v278 == 0 then
                        CFrame.new(v119.Position, v119.Position + (v121.Position - v119.Position).Unit)
                    end
                end
            end

            break
        end
        if v116 == 0 then
            local v237 = 0

            while true do
                if v237 == 0 then
                    v117 = tick()

                    if v117 - v49 < v50 then
                        return
                    end
                end
                if 1 == v237 then
                    break
                end
            end
        end
        if 1 == v116 then
            local v238 = 0

            while true do
                if 0 == v238 then
                    if not v48 then
                        return
                    end
                end
                if v238 == 1 then
                    if not v118 then
                        return
                    end

                    break
                end
            end
        end
        if v116 == 2 then
            local v239 = 0

            while true do
                if v239 == 0 then
                    v119 = v118:FindFirstChild('HumanoidRootPart')

                    if not v119 then
                        return
                    end
                end
                if v239 == 1 then
                    v66()

                    break
                end
            end
        end
    end
end
local function v69()
    local v122 = 0
    local v123
    local v124
    local v125
    local v126
    local v127

    while true do
        if v122 == 2 then
            v123:FindFirstChildOfClass('Humanoid')
            v123:FindFirstChild('HumanoidRootPart')
        end
        if v122 == 4 then
            if v126 and v127 then
                local v281 = (v125.Position - v127.Position).Magnitude
                local v282 = v127.Position
                local v283 = Vector3.new(0, 0, 0)

                if v47[v126] then
                    v283 = (v282 - v47[v126]) / task.wait()
                end

                v47[v126] = v282

                local v287 = Vector3.new(((v282 + (v283 * v38) * 60) - ((v282 + (v283 * v38) * 60) - v125.Position).Unit * 5).X, v125.Position.Y, ((v282 + (v283 * v38) * 60) - ((v282 + (v283 * v38) * 60) - v125.Position).Unit * 5).Z)
                local v288 = game:GetService('VirtualInputManager')

                if v281 <= v39 then
                    v124:MoveTo(v287)

                    if v281 <= 10 then
                        v288:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                    else
                        v288:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                    end
                else
                    v288:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                end
            else
                local v289 = 0
                local v290

                while true do
                    if v289 == 0 then
                        v290 = game:GetService('VirtualInputManager')

                        v290:SendKeyEvent(false, Enum.KeyCode.F, false, game)

                        break
                    end
                end
            end

            break
        end
        if v122 == 3 then
            if not v124 or not v125 then
                return
            end

            v126, v127 = v64()
        end
        if 0 == v122 then
            if not v32 then
                return
            end
            if v8.LocalPlayer:FindFirstChild('Basketball') then
                return
            end
        end
        if v122 == 1 then
            if not v16.Character then
                return
            end
        end
    end
end
local function v70()
    if v51 then
        return
    end

    v51 = true

    v11.Heartbeat:Connect(function()
        if not v51 then
            return
        end

        local v205 = v16.Character

        if not v16.Character then
            return
        end

        local v206 = v205:FindFirstChild('HumanoidRootPart')

        if not v206 then
            return
        end

        local v207, v208 = v64()

        if v207 and v208 then
            local v241 = 0
            local v242
            local v243

            while true do
                if v241 == 1 then
                    if v243 <= v242 then
                        v206.CFrame = v208.CFrame * CFrame.new(0, 0, v53)
                    end

                    break
                end
            end
        end
    end)
end
local function v71()
    local v128 = 0
    local v129

    while true do
        if v128 == 0 then
            v129 = 0

            while true do
                if v129 == 0 then
                    if not v51 then
                        return
                    end
                end
                if v129 == 1 then
                    if v52 then
                        v52:Disconnect()
                    end

                    break
                end
            end

            break
        end
    end
end
local function v72(v130)
    local v131 = v11.RenderStepped:Connect(function(v209)
        local v210 = 0
        local v211
        local v212
        local v213
        local v214

        while true do
            if v210 == 0 then
                local v254 = 0
                local v255

                while true do
                    if 0 == v254 then
                        v255 = 0

                        while true do
                            if v255 == 0 then
                                if not v16.Character then
                                    return
                                end
                            end
                        end

                        break
                    end
                end
            end
            if v210 == 2 then
                if not v212 or not v213 then
                    return
                end
            end
            if v210 == 3 then
                if v214.Magnitude > 0 then
                    local v309 = math.max(v130 - v213.WalkSpeed, 0)

                    v212.CFrame = v212.CFrame + (v214.Unit * v309) * v209
                end

                break
            end
            if v210 == 1 then
                v211:FindFirstChild('HumanoidRootPart')
                v211:FindFirstChildOfClass('Humanoid')
            end
        end
    end)

    return function()
        if v131 then
            v131:Disconnect()
        end
    end
end
local function v73()
    local v132 = 0
    local v133
    local v134
    local v135

    while true do
        if v132 == 2 then
            if v56 then
                if v134 then
                    local v325 = 0
                    local v326

                    while true do
                        if v325 == 0 then
                            v326 = 0

                            while true do
                                if v326 == 1 then
                                    v134.Transparency = 1
                                    v134.CanCollide = false
                                end
                                if v326 == 2 then
                                    v134.Massless = true

                                    break
                                end
                                if v326 == 0 then
                                    v134.Size = v58 * v57
                                end
                            end

                            break
                        end
                    end
                end
                if v135 then
                    local v327 = 0

                    while true do
                        if v327 == 2 then
                            v135.Massless = true

                            break
                        end
                        if v327 == 1 then
                            v135.Transparency = 1
                            v135.CanCollide = false
                        end
                        if 0 == v327 then
                            v135.Size = v59 * v57
                        end
                    end
                end
            else
                local v291 = 0

                while true do
                    if v291 == 0 then
                        if v134 and v58 then
                            local v360 = 0

                            while true do
                                if v360 == 1 then
                                    v134.CanCollide = false
                                    v134.Massless = false
                                end
                                if v360 == 0 then
                                    v134.Size = v58
                                    v134.Transparency = 0
                                end
                            end
                        end
                        if v135 and v59 then
                            v135.Size = v59
                            v135.Transparency = 0
                            v135.CanCollide = false
                            v135.Massless = false
                        end

                        break
                    end
                end
            end

            break
        end
        if 1 == v132 then
            v134 = v133:FindFirstChild('Right Arm') or v133:FindFirstChild('RightHand') or v133:FindFirstChild('RightLowerArm')
            v135 = v133:FindFirstChild('Left Arm') or v133:FindFirstChild('LeftHand') or v133:FindFirstChild('LeftLowerArm')
        end
        if v132 == 0 then
            if not v16.Character then
                return
            end
        end
    end
end
local function v74()
    for v215, v216 in pairs(workspace:GetChildren())do
        if v216:IsA('Model') and v216:FindFirstChild('HumanoidRootPart') then
            local v245 = v216.HumanoidRootPart

            for v257, v258 in pairs(v216.HumanoidRootPart:GetDescendants())do
                if v258.Name == 'BG' and v258:IsA('BodyGyro') then
                    local v311 = 0

                    while true do
                        if 0 == v311 then
                            v258.Parent = v245
                            v258.MaxTorque = Vector3.new(9000000000, 9000000000, 9000000000)
                        end
                        if v311 == 2 then
                            v258.CFrame = v245.CFrame

                            break
                        end
                        if v311 == 1 then
                            v258.P = 90000
                            v258.D = 500
                        end
                    end
                end
            end
        end
    end
end
local function v75()
    for v217, v218 in pairs(workspace:GetChildren())do
        if v218:IsA('Model') and v218:FindFirstChild('HumanoidRootPart') then
            for v259, v260 in pairs(v218.HumanoidRootPart:GetDescendants())do
                if v260.Name == 'BG' and v260:IsA('BodyGyro') then
                    v260.Parent = nil
                end
            end
        end
    end
end

local v76 = (v13:WaitForChild('Assets')):WaitForChild('Animations_R15')
local v77 = 'Default'
local v78 = 'Dance_Casual'
local v79 = false
local v80 = nil
local v81 = nil
local v82 = nil
local v83 = nil
local v85 = {}

for v136 in pairs({
    Default = 'Dance_Casual',
    Dance_Sturdy = 'Dance_Sturdy',
    Dance_Taunt = 'Dance_Taunt',
    Dance_TakeFlight = 'Dance_TakeFlight',
    Dance_Flex = 'Dance_Flex',
    Dance_Bat = 'Dance_Bat',
    Dance_Twist = 'Dance_Twist',
    Dance_Griddy = 'Dance_Griddy',
    Dance_Dab = 'Dance_Dab',
    Dance_Drake = 'Dance_Drake',
    Dance_Fresh = 'Dance_Fresh',
    Dance_Hype = 'Dance_Hype',
    Dance_Spongebob = 'Dance_Spongebob',
    Dance_Backflip = 'Dance_Backflip',
    Dance_L = 'Dance_L',
    Dance_Facepalm = 'Dance_Facepalm',
    Dance_Bow = 'Dance_Bow',
})do
    table.insert(v85, v136)
end

table.sort(v85)

local function v86(v137)
    local v138 = 0
    local v139

    while true do
        if v138 == 0 then
            local v246 = 0

            while true do
                if v246 == 0 then
                    v139 = v137:FindFirstChildOfClass('Animator') or Instance.new('Animator', v137)

                    return v139.AnimationPlayed:Connect(function(v328)
                        if v79 and (v328.Animation.Name == 'Dunk_Default' and v77 ~= 'Default') then
                            local v347 = 0
                            local v348

                            while true do
                                if 0 == v347 then
                                    v328:Stop()
                                    v76:FindFirstChild('Dunk_' .. v77)
                                end
                                if v347 == 1 then
                                    if v348 then
                                        (v137:LoadAnimation(v348)):Play()
                                    end

                                    break
                                end
                            end
                        end
                    end)
                end
            end
        end
    end
end
local function v87(v140)
    local v141 = 0
    local v142

    while true do
        if v141 == 0 then
            v142 = v140:FindFirstChildOfClass('Animator') or Instance.new('Animator', v140)

            return v142.AnimationPlayed:Connect(function(v261)
                if v79 and (v261.Animation.Name == 'Dance_Casual' and v78 ~= 'Dance_Casual') then
                    local v313 = 0
                    local v314

                    while true do
                        if v313 == 1 then
                            if v314 then
                                (v140:LoadAnimation(v314)):Play()
                            end

                            break
                        end
                        if v313 == 0 then
                            v261:Stop()
                            v76:FindFirstChild(v78)
                        end
                    end
                end
            end)
        end
    end
end
local function v88()
    local v143 = 0
    local v144

    while true do
        if v143 == 0 then
            v144 = v16.Character

            if v16.Character then
                local v292 = 0
                local v293

                while true do
                    if v292 == 0 then
                        v293 = v144:FindFirstChildOfClass('Humanoid')

                        if v293 then
                            if v80 then
                                v80:Disconnect()
                            end
                            if v81 then
                                v81:Disconnect()
                            end

                            v86(v293)
                            v87(v293)
                        end

                        break
                    end
                end
            end
        end
        if 2 == v143 then
            v16.CharacterAdded:Connect(function(v262)
                local v263 = 0
                local v264

                while true do
                    if v263 == 1 then
                        v86(v264)

                        break
                    end
                    if v263 == 0 then
                        v262:WaitForChild('Humanoid')

                        if v80 then
                            v80:Disconnect()
                        end
                    end
                end
            end)
            v16.CharacterAdded:Connect(function(v265)
                local v266 = v265:WaitForChild('Humanoid')

                if v81 then
                    v81:Disconnect()
                end

                v87(v266)
            end)

            break
        end
        if 1 == v143 then
            if v82 then
                v82:Disconnect()
            end
            if v83 then
                v83:Disconnect()
            end
        end
    end
end
local function v89()
    local v145 = 0

    while true do
        if 0 == v145 then
            if v80 then
                local v294 = 0
                local v295

                while true do
                    if v294 == 0 then
                        v295 = 0

                        while true do
                            if v295 == 0 then
                                v80:Disconnect()

                                break
                            end
                        end

                        break
                    end
                end
            end
            if v81 then
                local v296 = 0
                local v297

                while true do
                    if v296 == 0 then
                        v297 = 0

                        while true do
                            if v297 == 0 then
                                v81:Disconnect()

                                break
                            end
                        end

                        break
                    end
                end
            end
        end
        if v145 == 1 then
            if v82 then
                v82:Disconnect()
            end
            if v83 then
                v83:Disconnect()
            end

            break
        end
    end
end

v11.RenderStepped:Connect(function()
    if v56 then
        v73()
    end
    if not v60 then
        return
    end

    local v146 = v16.Character

    if not v16.Character then
        return
    end

    local v147 = v146:FindFirstChild('HumanoidRootPart')

    if not v147 then
        return
    end

    local v148 = nil

    for v219, v220 in ipairs(workspace:GetChildren())do
        if v220.Name == 'Basketball' then
            local v248 = 0
            local v249

            while true do
                if v248 == 0 then
                    v249 = v220:IsA('BasePart') and v220 or v220:FindFirstChildWhichIsA('BasePart')

                    if v249 then
                        while false do end
                    end

                    break
                end
            end
        end
    end

    if v148 then
        v147.CFrame = CFrame.new(v148.Position + v148.CFrame.LookVector * v61)
    end
end)

local v46 = v11.Heartbeat:Connect(function()
    local v151 = 0
    local v152
    local v153

    while true do
        if v151 == 2 then
            if not v153 then
                return
            end

            for v267, v268 in ipairs(workspace:GetDescendants())do
                if v268:IsA('BasePart') and v268.Name == 'Basketball' then
                    if (v153.Position - v268.Position).Magnitude <= v54 then
                        local v336 = 0

                        while true do
                            if v336 == 0 then
                                firetouchinterest(v153, v268, 0)
                                firetouchinterest(v153, v268, 1)

                                break
                            end
                        end
                    end
                end
            end

            break
        end
        if 0 == v151 then
            if not v55 then
                return
            end
        end
        if 1 == v151 then
            if not v152 then
                return
            end

            v152:FindFirstChild('HumanoidRootPart')
        end
    end
end)

v12.InputBegan:Connect(function(v154, v155)
    local v156 = 0

    while true do
        if v156 == 0 then
            if v154.KeyCode == Enum.KeyCode.G and not v155 then
                if v33 then
                    local v329 = 0

                    while true do
                        if 1 == v329 then
                            if not v43 then
                                v11.Heartbeat:Connect(v69)
                            end

                            break
                        end
                    end
                end
            end
            if v154.KeyCode == Enum.KeyCode.P and not v155 then
                if v36 then
                    if not v45 then
                        v11.Heartbeat:Connect(v68)
                    end
                end
            end

            break
        end
    end
end)
v12.InputEnded:Connect(function(v157)
    if v157.KeyCode == Enum.KeyCode.G then
        local v226 = 0

        while true do
            if 1 == v226 then
                if v43 then
                    v43:Disconnect()
                end
            end
            if v226 == 2 then
                (game:GetService('VirtualInputManager')):SendKeyEvent(false, Enum.KeyCode.F, false, game)

                break
            end
        end
    end
    if v157.KeyCode == Enum.KeyCode.P then
        local v227 = 0

        while true do
            if v227 == 0 then
                if v45 then
                    v45:Disconnect()
                end

                break
            end
        end
    end
end)
v22:CreateSection('Auto Shooting')
v22:CreateToggle({
    Name = 'Auto Time',
    CurrentValue = false,
    Flag = 'AutoShoot',
    Callback = function(v158)
        v31 = v158

        if v158 then
            if not v42 then
                (v29:GetPropertyChangedSignal('Visible')):Connect(function()
                    if v31 and v29.Visible == true then
                        task.wait(0.25)
                        v30:FireServer(v40)
                    end
                end)
            end
        elseif v42 then
            local v269 = 0

            while true do
                if v269 == 0 then
                    v42:Disconnect()

                    break
                end
            end
        end
    end,
})
v22:CreateSlider({
    Name = 'Shot Timing',
    Range = {50, 100},
    Increment = 1,
    CurrentValue = 80,
    Flag = 'ShootTiming',
    Callback = function(v159) end,
})
v22:CreateLabel('Shot Timing: 80=Mediocre | 90=Good | 95=Great | 100=Perfect')
v22:CreateSection('Auto Guard')
v22:CreateToggle({
    Name = 'Auto Guard',
    CurrentValue = false,
    Flag = 'AutoGuard',
    Callback = function(v160)
        if not v160 then
            local v228 = 0

            while true do
                if 0 == v228 then
                    if v43 then
                        v43:Disconnect()
                    end
                end
                if v228 == 1 then
                    (game:GetService('VirtualInputManager')):SendKeyEvent(false, Enum.KeyCode.F, false, game)

                    break
                end
            end
        end
    end,
})
v22:CreateLabel('Hold G to activate (toggle must be enabled)')
v22:CreateSlider({
    Name = 'Guard Distance',
    Range = {5, 20},
    Increment = 1,
    CurrentValue = 10,
    Flag = 'GuardDistance',
    Callback = function(v161) end,
})
v22:CreateSlider({
    Name = 'Prediction Time',
    Range = {1, 8},
    Increment = 1,
    CurrentValue = 3,
    Flag = 'PredictionTime',
    Callback = function(v162) end,
})
v22:CreateSection('Auto Rebound & Steal')
v22:CreateToggle({
    Name = 'Auto Rebound & Steal',
    CurrentValue = false,
    Flag = 'ReboundAutoSteal',
    Callback = function(v163) end,
})
v22:CreateSlider({
    Name = 'Rebound Offset Distance',
    Range = {0, 6},
    Increment = 1,
    CurrentValue = 0,
    Flag = 'ReboundOffset',
    Callback = function(v164) end,
})
v22:CreateSection('Follow Ball Carrier')
v22:CreateToggle({
    Name = 'Follow Ball Carrier',
    CurrentValue = false,
    Flag = 'FollowBallCarrier',
    Callback = function(v165)
        if v165 then
            v70()
        else
            v71()
        end
    end,
})
v22:CreateSlider({
    Name = 'Follow Offset',
    Range = {
        -10,
        10,
    },
    Increment = 1,
    CurrentValue = -10,
    Flag = 'FollowOffset',
    Callback = function(v166) end,
})
v22:CreateSection('Reach')
v22:CreateToggle({
    Name = 'Steal Reach',
    CurrentValue = false,
    Flag = 'StealReach',
    Callback = function(v167)
        local v168 = 0

        while true do
            if v168 == 0 then
                v73()

                break
            end
        end
    end,
})
v22:CreateSlider({
    Name = 'Steal Reach Multiplier',
    Range = {1, 20},
    Increment = 1,
    CurrentValue = 2,
    Flag = 'StealReachMultiplier',
    Callback = function(v169)
        local v170 = 0

        while true do
            if v170 == 0 then
                if v56 then
                    v73()
                end

                break
            end
        end
    end,
})
v22:CreateSection('Ball Magnet')
v22:CreateToggle({
    Name = 'Ball Magnet',
    CurrentValue = false,
    Flag = 'BallMagnet',
    Callback = function(v171) end,
})
v22:CreateSlider({
    Name = 'Magnet Distance',
    Range = {10, 85},
    Increment = 1,
    CurrentValue = 30,
    Flag = 'BallMagnetDistance',
    Callback = function(v172) end,
})
v22:CreateSection('Post Aimbot')
v22:CreateToggle({
    Name = 'Post Aimbot',
    CurrentValue = false,
    Flag = 'PostAimbot',
    Callback = function(v173)
        local v174 = 0

        while true do
            if v174 == 0 then
                if not v173 then
                    local v298 = 0

                    while true do
                        if v298 == 0 then
                            if v45 then
                                local v365 = 0

                                while true do
                                    if v365 == 0 then
                                        v45:Disconnect()

                                        break
                                    end
                                end
                            end

                            break
                        end
                    end
                end

                break
            end
        end
    end,
})
v22:CreateSlider({
    Name = 'Activation Distance',
    Range = {5, 20},
    Increment = 1,
    CurrentValue = 10,
    Flag = 'PostActivationDistance',
    Callback = function(v175) end,
})
v22:CreateLabel('Hold P to activate Post Aimbot (auto-detects ball hand)')
v23:CreateSection('Speed Boost')
v23:CreateToggle({
    Name = 'Speed Boost',
    CurrentValue = false,
    Flag = 'SpeedBoost',
    Callback = function(v176)
        local v177 = 0
        local v178

        while true do
            if v177 == 0 then
                v178 = 0

                while true do
                    if v178 == 0 then
                        if v176 then
                            local v337 = 0

                            while true do
                                if v337 == 0 then
                                    if v44 then
                                        v44()
                                    end

                                    v72(v37)

                                    break
                                end
                            end
                        else
                            local v338 = 0

                            while true do
                                if v338 == 0 then
                                    if v44 then
                                        v44()
                                    end

                                    break
                                end
                            end
                        end

                        break
                    end
                end

                break
            end
        end
    end,
})
v23:CreateSlider({
    Name = 'Speed Amount',
    Range = {16, 23},
    Increment = 1,
    CurrentValue = 16,
    Flag = 'SpeedAmount',
    Callback = function(v179)
        v37 = v179

        if v35 then
            local v229 = 0

            while true do
                if v229 == 0 then
                    if v44 then
                        v44()
                    end

                    v72(v37)

                    break
                end
            end
        end
    end,
})
v24:CreateSection('Visuals')
v24:CreateToggle({
    Name = 'Show BodyGyro',
    CurrentValue = false,
    Flag = 'ShowBG',
    Callback = function(v180)
        if v180 then
            v74()
        else
            v75()
        end
    end,
})
v24:CreateSection('Animation Changer')
v24:CreateToggle({
    Name = 'Animation Changer',
    CurrentValue = false,
    Flag = 'AnimationSpoof',
    Callback = function(v181)
        local v182 = 0
        local v183

        while true do
            if v182 == 0 then
                v183 = 0

                while true do
                    if v183 == 0 then
                        if v181 then
                            v88()
                        else
                            v89()
                        end

                        break
                    end
                end

                break
            end
        end
    end,
})
v24:CreateDropdown({
    Name = 'Dunk Animation',
    Options = {
        'Default',
        'Testing',
        'Testing2',
        'Reverse',
        '360',
        'Testing3',
        'Tomahawk',
        'Windmill',
    },
    CurrentOption = {
        'Default',
    },
    Flag = 'DunkSpoof',
    Callback = function(v184) end,
})
v24:CreateDropdown({
    Name = 'Emote Animation',
    Options = v85,
    CurrentOption = {
        'Default',
    },
    Flag = 'EmoteSpoof',
    Callback = function(v185)
        while false do end
    end,
})
v24:CreateSection('Teleporter')

local v90 = syn and syn.request or http and http.request or fluxus and fluxus.request or request or http_request
local v91 = {}
local v92 = {}
local v93 = false

local function v94()
    local v188 = 0
    local v189
    local v190
    local v191

    while true do
        if v188 == 2 then
            v190, v191 = pcall(function()
                return v90({
                    Url = v189,
                    Method = 'GET',
                    Headers = {
                        ['User-Agent'] = 'Roblox/WinInet',
                        ['Content-Type'] = 'application/json',
                    },
                })
            end)

            if v190 and (v191 and v191.Body) then
                local v299 = 0
                local v300
                local v301
                local v302

                while true do
                    if v299 == 1 then
                        v302 = nil

                        while true do
                            if v300 == 0 then
                                v301, v302 = pcall(v10.JSONDecode, v10, v191.Body)

                                if v301 and (v302 and v302.data) then
                                    for v385, v386 in ipairs(v302.data)do
                                        if v386.name and v386.id then
                                            v91[v386.name .. (v386.isRootPlace and ' (Root)' or '')] = v386.id
                                        end
                                    end
                                end

                                break
                            end
                        end

                        break
                    end
                end
            end
        end
        if v188 == 3 then
            for v270 in pairs(v91)do
                table.insert(v92, v270)
            end

            table.sort(v92)
        end
        if v188 == 1 then
            if not v90 then
                v91['Current Place'] = game.PlaceId

                return
            end
        end
        if v188 == 0 then
            if v93 then
                return
            end
        end
        if v188 == 4 then
            if #v92 == 0 then
                local v305 = 0

                while true do
                    if v305 == 0 then
                        v91['Current Place'] = game.PlaceId

                        break
                    end
                end
            end

            break
        end
    end
end

task.spawn(v94)

local v95 = 'Current Place'

v24:CreateDropdown({
    Name = 'Select Place',
    Options = v92,
    CurrentOption = {
        v92[1] or 'Loading...',
    },
    Flag = 'TeleportPlace',
    Callback = function(v192) end,
})
v24:CreateButton({
    Name = 'Teleport',
    Callback = function()
        local v193 = 0
        local v194

        while true do
            if v193 == 0 then
                v194 = v91[v95]

                if v91[v95] then
                    local v306 = 0

                    while true do
                        if v306 == 0 then
                            v20:Notify({
                                Title = 'Teleporting',
                                Content = 'Teleporting to ' .. (v95 .. '...'),
                                Duration = 3,
                            })
                            v14:Teleport(v194)

                            break
                        end
                    end
                end

                break
            end
        end
    end,
})
v24:CreateButton({
    Name = 'Rejoin Current Server',
    Callback = function()
        v20:Notify({
            Title = 'Rejoining',
            Content = 'Rejoining current server...',
            Duration = 3,
        })
        v14:TeleportToPlaceInstance(game.PlaceId, game.JobId, v16)
    end,
})
v24:CreateButton({
    Name = 'Server Hop',
    Callback = function()
        local v195 = 0
        local v196
        local v197

        while true do
            if v195 == 2 then
                if #v196 > 0 then
                    table.sort(v196, function(v315, v316)
                        return v315.playing < v316.playing
                    end)
                    v14:TeleportToPlaceInstance(game.PlaceId, v196[1].id, v16)
                else
                    v20:Notify({
                        Title = 'Server Hop Failed',
                        Content = 'No available servers found.',
                        Duration = 3,
                    })
                end

                break
            end
            if v195 == 0 then
                v20:Notify({
                    Title = 'Server Hopping',
                    Content = 'Finding best server...',
                    Duration = 3,
                })
            end
            if v195 == 1 then
                v197 = ''

                repeat
                    local v271 = 'https://games.roblox.com/v1/games/' .. (tostring(game.PlaceId) .. ('/servers/Public?sortOrder=Asc&limit=100&cursor=' .. v197))
                    local v272, v273 = pcall(game.HttpGet, game, v271)

                    if v272 then
                        local v317 = 0
                        local v318

                        while true do
                            if 0 == v317 then
                                v10:JSONDecode(v273)
                            end
                            if v317 == 1 then
                                for v366, v367 in pairs(v318.data)do
                                    if v367.playing < v367.maxPlayers and v367.id ~= game.JobId then
                                        table.insert(v196, v367)
                                    end
                                end

                                break
                            end
                        end
                    else
                        break
                    end
                until true
            end
        end
    end,
})
v25:CreateSection('Menu')
v25:CreateKeybind({
    Name = 'Menu Keybind',
    CurrentKeybind = 'LeftControl',
    HoldToInteract = false,
    Flag = 'MenuKeybind',
    Callback = function(v198) end,
})
v25:CreateButton({
    Name = 'Unload Hub',
    Callback = function()
        local v199 = 0

        while true do
            if v199 == 3 then
                v20:Destroy()

                break
            end
            if v199 == 0 then
                if v42 then
                    v42:Disconnect()
                end
                if v43 then
                    v43:Disconnect()
                end
            end
            if v199 == 2 then
                if v45 then
                    v45:Disconnect()
                end

                v89()
            end
            if 1 == v199 then
                if v44 then
                    v44()
                end
                if v46 then
                    v46:Disconnect()
                end
            end
        end
    end,
})
