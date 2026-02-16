# Blog - GitHub Pages + Supabase

Modern blog powered by GitHub Pages (frontend) and Supabase PostgreSQL (backend).

## 🚀 Features

- ✅ Static site hosting on GitHub Pages
- ✅ PostgreSQL database with Supabase
- ✅ Real-time content updates
- ✅ No server management needed
- ✅ Completely free hosting
- ✅ n8n automation ready

## 📋 Setup Instructions

### 1. Supabase Setup

1. Go to [supabase.com](https://supabase.com)
2. Create a new project
   - Name: `blog`
   - Database Password: (choose a strong password)
   - Region: Northeast Asia (Seoul)

3. Once project is created, go to **SQL Editor**
4. Copy the contents of `supabase-schema.sql`
5. Paste and run the SQL script
6. This will create the `posts` table with sample data

### 2. Get Supabase Credentials

1. Go to **Settings** → **API**
2. Copy these values:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon/public key**: The public API key

### 3. Update index.html

Open `index.html` and replace:

```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
```

With your actual values:

```javascript
const SUPABASE_URL = 'https://xxxxx.supabase.co';
const SUPABASE_ANON_KEY = 'your-anon-key-here';
```

### 4. Deploy to GitHub Pages

```bash
git add .
git commit -m "Add blog with Supabase integration"
git push origin main
```

Then enable GitHub Pages:
1. Go to repository **Settings**
2. Click **Pages** in sidebar
3. Source: Deploy from branch `main`
4. Folder: `/ (root)`
5. Click **Save**

Your site will be live at: `https://daily2translate.github.io/workspace-domain-repo/`

## 📝 Database Schema

### posts table

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| title | TEXT | Post title |
| content | TEXT | Post content |
| author | TEXT | Author name |
| slug | TEXT | URL-friendly slug |
| tags | TEXT[] | Array of tags |
| status | TEXT | draft/published/archived |
| created_at | TIMESTAMP | Creation date |
| updated_at | TIMESTAMP | Last update date |

## 🔄 n8n Integration

### Creating Posts via n8n

Use the **Supabase** node in n8n:

1. Add **Supabase** node
2. Configure:
   - Host: Your Supabase URL
   - Service API Key: Your anon key
3. Operation: Insert
4. Table: `posts`
5. Data:
   ```json
   {
     "title": "Post Title",
     "content": "Post content here",
     "author": "Author Name",
     "tags": ["tag1", "tag2"],
     "status": "published"
   }
   ```

### Example n8n Workflow

1. **Webhook Trigger** → Receive post data
2. **Supabase Insert** → Create post in database
3. **Done!** → Post appears on website automatically

## 🛠️ Development

### Local Testing

Simply open `index.html` in a browser. Make sure you've configured Supabase credentials.

### Adding New Posts Manually

Go to Supabase Dashboard → Table Editor → posts → Insert row

## 📚 API Usage

### Fetch Posts (JavaScript)

```javascript
const { data, error } = await supabase
  .from('posts')
  .select('*')
  .eq('status', 'published')
  .order('created_at', { ascending: false });
```

### Create Post (JavaScript)

```javascript
const { data, error } = await supabase
  .from('posts')
  .insert([
    {
      title: 'New Post',
      content: 'Content here',
      author: 'Author',
      tags: ['tag1'],
      status: 'published'
    }
  ]);
```

## 🔐 Security

- Row Level Security (RLS) enabled
- Public read access to published posts only
- Authenticated users can create/update posts
- Draft posts are not publicly visible

## 🎨 Customization

Edit `index.html` to customize:
- Colors and styling
- Layout
- Fonts
- Post card design

## 📖 Resources

- [Supabase Documentation](https://supabase.com/docs)
- [GitHub Pages Guide](https://pages.github.com/)
- [n8n Documentation](https://docs.n8n.io/)
