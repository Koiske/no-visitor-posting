# Plugin: `no-visitor-posting`

Prevent trust level 0 users from replying to posts in certain categories.

---

## Features

- When enabled, it prevents any trust level 0 user from creating a new topic or replying to a post in any forum category, despite of any category settings and permissions.

  - There is an exception for private messages: trust level 0 users are able to reply to existing private messages that they have access to. (They cannot create new private messages.)

---

## Impact

### Community

This plugin is to help bring alive our international categories. It'll prevent trust level 0 users from replying to posts in the international categories but still allow them to reply to PMs (so we don't break the tutorial).

The problem was that we could not make the groups publicly visible, joinable, and allow the groups specifically to have Create / Reply / See permissions in the categories or we would be allowing TL0 to post freely in those categories. This plugin prevents them from posting.

By using this plugin, we can keep the language categories hidden, but still allow anyone to see the categories without letting trust level 0 users create posts, flag content, etc.

### Internal

International community categories are easier to manage and no additional cost caused by trust level 0 users.

### Resources

A highly negligible overhead is added whenever a topic, category or profile is loaded, because this plugin makes the logic for determining where a user can post and whether they can start new private messages a bit more complex.

### Maintenance

No manual maintenance needed.

---

## Technical Scope

The plugin intervenes in the guardians that decide whether a post, topic or private message can be created.

The prepend mechanism that is used to intervene in these checks is a standard one, and so is unlikely to break throughout Discourse updates, with the exception of the case where the names or parameter lists of `Guardian.can_send_private_message?`, `PostGuardian.skip_validations?` or `TopicGuardian.can_create_topic?` change. Even if that happens, the forum will continue to function properly, only the plugin functionality will be broken.
