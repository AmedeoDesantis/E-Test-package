from pydantic import BaseModel
from typing import Literal

class Answer(BaseModel):
    Q1: Literal["YES", "NO"]
    Q2: Literal["YES", "NO"]
    Q3: Literal["YES", "NO"]
    Q4: Literal["YES", "NO"]
    Q5: Literal["YES", "NO"]
