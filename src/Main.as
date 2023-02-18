
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
    if (UI::MenuItem("\\$f00" + Icons::Ban + " \\$zDisable Animated Signs"))
    {
        StopSignsInGame();
    }
}
