
[Setting category="General" name="Automatically disable sign animation" description="If this setting is turned off you can still disable sign animations on demand from the Plugins menu"]
bool Settings_AutoDisable = false;

void StopFidAnimation(CSystemFid@ fid)
{
    if (fid !is null && fid.Nod !is null)
    {
        CPlugFileVideo@ video = cast<CPlugFileVideo>(fid.Nod);
        if (video !is null)
        {
            video.Stop();
        }
    }
}

void TraverseFidsAndStopAnimation(CSystemFids@ fids)
{
    CSystemFidsFolder@ fidsFolder = cast<CSystemFidsFolder>(fids);
    if (fidsFolder !is null)
    {
        for (uint i = 0; i < fidsFolder.Trees.Length; i++)
        {
            TraverseFidsAndStopAnimation(fidsFolder.Trees[i]);
        }
        for (uint i = 0; i < fidsFolder.Leaves.Length; i++)
        {
            StopFidAnimation(fidsFolder.Leaves[i]);
        }
    }
}

void StopSignsInGame()
{
    TraverseFidsAndStopAnimation(Fids::GetProgramDataFolder("Cache"));
    TraverseFidsAndStopAnimation(Fids::GetUserFolder("Skins"));
    TraverseFidsAndStopAnimation(Fids::GetUserFolder("Media"));
    TraverseFidsAndStopAnimation(Fids::GetGameFolder("GameData/Skins"));
    TraverseFidsAndStopAnimation(Fids::GetGameFolder("GameData/Media"));
}

void RenderMenu()
{
    if (UI::MenuItem("\\$f00" + Icons::Ban + " \\$zDisable Animated Signs", enabled: GetApp().CurrentPlayground !is null))
    {
        StopSignsInGame();
    }
}

void Main()
{
    CMwNod@ prevPlayground = null;

    while (true)
    {
        sleep(1000);

        if (Settings_AutoDisable)
        {
            CMwNod@ currPlayground = GetApp().CurrentPlayground;

            if (currPlayground !is prevPlayground && currPlayground !is null)
            {
                StopSignsInGame();
            }
            @prevPlayground = currPlayground;
        }
        else
        {
            @prevPlayground = null;
        }
    }
}
