from unittest import mock

import pytest

from src import app


@pytest.mark.asyncio
async def test_app_saves_page():
    # Arrange
    q = mock.AsyncMock()

    # Act
    await app.serve(q)

    # Assert
    q.page.save.assert_called_once()
