const noteId = document.getElementById('noteId');
const title = document.getElementById('title');
const description = document.getElementById('description');
const section = document.getElementById('section');
const addBtn = document.getElementById('addBtn');
const updateBtn = document.getElementById('updateBtn');
const removeBtn = document.getElementById('removeBtn');

addBtn.addEventListener('click', e => {
    e.preventDefault();
    axios({
        method: 'post',
        url: '/save',
        data: {
            note_id: noteId.value,
            title: title.value,
            description: description.value,
        }
    });
});

updateBtn.addEventListener('click', e => {
    e.preventDefault();
    axios({
        method: 'put',
        url: '/update',
        data: {
            note_id: noteId.value,
            title: title.value,
            description: description.value,
        }
    });
});

removeBtn.addEventListener('click', e => {
    e.preventDefault();
    axios({
        method: 'delete',
        url: '/remove',
        data: {
            note_id: noteId.value
        }
    });
});