# Example Project: Todo List API

A simple REST API for managing todo items.

## Requirements

- [ ] Set up Node.js project with Express
- [ ] Create Todo model with in-memory storage
- [ ] Implement GET /todos endpoint
- [ ] Implement POST /todos endpoint
- [ ] Implement PUT /todos/:id endpoint
- [ ] Implement DELETE /todos/:id endpoint
- [ ] Add input validation
- [ ] Add error handling
- [ ] Write unit tests
- [ ] Add API documentation

## Technical Specs

- Node.js 18+
- Express 4.x
- Jest for testing
- No database (use in-memory array for MVP)

## Todo Model

```javascript
{
  id: number,
  title: string,
  completed: boolean,
  createdAt: Date
}
```

## Success Criteria

- All endpoints working
- Tests passing with >80% coverage
- Clean commit history (one commit per feature)
