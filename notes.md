# Cecile Notes

Open Visual Studio Code (VSC)

In VSC Explorer, open svplume (under admin-cecile/source/svplume)

In VSC Source Control, Pull the latest version

(Only if new packages were installed) update packages:
## Jekyll toochain (CP: if new package) From INSTALL
    cd svplume
    bundle install

To enable local testing (copy the address when done, like http://127.0.0.1:4000/):
### Serve locally (CP: to test locally) FROM INSTALL
    bundle exec jekyll serve

Make and save changes to the files
In VSC Source Control:
- Stage the content changes
- Document your commit
- Commit
- Synchronive to deploy at https://plume.flupes.org/