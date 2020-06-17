import { Selector } from 'testcafe';

fixture`Initial test`.page('http://localhost:3000');

test('page loades', async (t) => {
  await t
    .expect(Selector('h1').textContent)
    .contains('Hello Next.js')
    .click(Selector('a').withText('About'))
    .expect(Selector('p').textContent)
    .eql('This is the about page')
    .click(Selector('a').withText('Go home'));
});
