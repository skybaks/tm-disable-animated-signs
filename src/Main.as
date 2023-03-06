
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

void TraverseFidsAndStopAnimation(CSystemFidsFolder@ fidsFolder)
{
    if (fidsFolder !is null)
    {
        for (uint i = 0; i < fidsFolder.Trees.Length; i++)
        {
            TraverseFidsAndStopAnimation(cast<CSystemFidsFolder>(fidsFolder.Trees[i]));
        }
        for (uint i = 0; i < fidsFolder.Leaves.Length; i++)
        {
            StopFidAnimation(fidsFolder.Leaves[i]);
        }
    }
}

void StopSignsInGame()
{
    TraverseFidsAndStopAnimation(cast<CSystemFidsFolder>(Fids::GetProgramDataFolder("Cache")));
    TraverseFidsAndStopAnimation(cast<CSystemFidsFolder>(Fids::GetUserFolder("Skins")));
    TraverseFidsAndStopAnimation(cast<CSystemFidsFolder>(Fids::GetUserFolder("Media")));
    TraverseFidsAndStopAnimation(cast<CSystemFidsFolder>(Fids::GetGameFolder("GameData/Skins")));
    TraverseFidsAndStopAnimation(cast<CSystemFidsFolder>(Fids::GetGameFolder("GameData/Media")));
    TraverseFidsAndStopAnimation(cast<CSystemFidsFolder>(Fids::GetFakeFolder("MemoryTemp/PackDescContents/_shared__Cache")));
    TraverseFidsAndStopAnimation(cast<CSystemFidsFolder>(Fids::GetFakeFolder("MemoryTemp/PackDescContents/_user__Skins_Stadium_Mod")));
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
