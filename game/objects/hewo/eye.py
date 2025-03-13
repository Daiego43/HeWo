import copy
import pygame
from game.objects.hewo.eye_components import EyeLash, Pupil
from game.settings import create_logger

class Eye:
    # Here I should initialize all the elements that make up the eye
    def __init__(self, size, position, settings, object_name="Eye"):
        self.logger = create_logger(object_name)
        self.settings = copy.deepcopy(settings)
        self.size = size
        self.position = position
        self.BG_COLOR = self.settings['bg_color']

        # Sizes are in proportion to the eye size
        self.lash_size = [self.size[0], self.size[1] / 2]
        self.t_pos = [0, 0]
        self.b_pos = [0, self.size[1] / 2]

        # Declare the elements that make up the eye
        self.top_lash = EyeLash(
            size=self.lash_size,
            position=self.t_pos,
            settings=self.settings['top_lash'],
            object_name=f"{object_name} - Top Lash"
        )
        self.pupil = Pupil(
            size=self.size,
            position=self.position,
            settings=self.settings['pupil'],
            object_name=f"{object_name} - Pupil"
        )
        self.bot_lash = EyeLash(
            size=self.lash_size,
            position=self.b_pos,
            settings=self.settings['bot_lash'],
            object_name=f"{object_name} - Bottom Lash"
        )

        # And initialize the surface of it
        self.eye_surface = pygame.Surface(self.size)

    def handle_event(self, event):
        self.top_lash.handle_event(event)
        self.pupil.handle_event(event)
        self.bot_lash.handle_event(event)

    def draw(self, surface):
        self.eye_surface = pygame.surface.Surface(self.size)
        self.eye_surface.fill(self.BG_COLOR)
        self.pupil.draw(self.eye_surface)
        self.top_lash.draw(self.eye_surface)
        self.bot_lash.draw(self.eye_surface)
        surface.blit(self.eye_surface, self.position)

    def update(self):
        self.top_lash.update()
        self.pupil.update()
        self.bot_lash.update()

    def set_emotion(self, t_emotion, p_emotion, b_emotion):
        self.logger.debug(f"emotion set: {t_emotion}, {b_emotion}")
        self.top_lash.set_emotion(t_emotion)
        self.bot_lash.set_emotion(b_emotion)
        self.pupil.set_emotion(p_emotion)

    def get_emotion(self):
        top_emotion = self.top_lash.get_emotion()
        bot_emotion = self.bot_lash.get_emotion()
        pupil_emotion = self.pupil.get_emotion()
        self.logger.debug(f"current emotion: {top_emotion}, {bot_emotion}")
        return top_emotion, pupil_emotion, bot_emotion

    def set_size(self, size):
        self.size = size
        self.lash_size = [self.size[0], self.size[1] / 2]
        self.top_lash.set_size(self.lash_size)
        self.bot_lash.set_size(self.lash_size)
        self.pupil.size = self.size

    def set_position(self, position):
        self.position = position
        self.t_pos = [self.position[0], self.position[1]]
        self.b_pos = [self.position[0], self.position[1] + self.size[1] / 2]
        self.top_lash.set_position(self.t_pos)
        self.bot_lash.set_position(self.b_pos)
        self.pupil.position = position
