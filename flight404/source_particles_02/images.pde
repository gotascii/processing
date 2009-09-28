class Images{
  Texture particle;
  Texture emitter;
  Texture corona;
  Texture reflection;

  Images(){
    try {
      particle = TextureIO.newTexture(new File(dataPath("particle.png")), true);
      emitter = TextureIO.newTexture(new File(dataPath("emitter.png")), true);
      corona = TextureIO.newTexture(new File(dataPath("corona.png")), true);
      reflection = TextureIO.newTexture(new File(dataPath("reflection.png")), true);
    } catch (IOException e) {
      println("Texture file is missing");
    }
  }
}
