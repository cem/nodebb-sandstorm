@0xa131cff64d2ba5e2;

using Spk = import "/sandstorm/package.capnp";
# This imports:
#   $SANDSTORM_HOME/latest/usr/include/sandstorm/package.capnp
# Check out that file to see the full, documented package definition format.

const pkgdef :Spk.PackageDefinition = (
  # The package definition. Note that the spk tool looks specifically for the
  # "pkgdef" constant.

  id = "zt4j87mc54jkgaehgfqyq2a0qeytm15pcskazvxfkh10yqg4rsrh",
  # Your app ID is actually its public key. The private key was placed in
  # your keyring. All updates must be signed with the same key.

  manifest = (
    # This manifest is included in your app package to tell Sandstorm
    # about your app.

    appTitle = (defaultText = "NodeBB"),

    appVersion = 0,  # Increment this for every release.

    appMarketingVersion = (defaultText = "0.8.2"),
    # Human-readable representation of appVersion. Should match the way you
    # identify versions of your app in documentation and marketing.

    actions = [
      # Define your "new document" handlers here.
      ( title = (defaultText = "New Board"),
        command = .myCommand
        # The command to run when starting for the first time. (".myCommand"
        # is just a constant defined at the bottom of the file.)
      )
    ],

    continueCommand = .myCommand,
    # This is the command called to start your app back up after it has been
    # shut down for inactivity. Here we're using the same command as for
    # starting a new instance, but you could use different commands for each
    # case.

    metadata = (
      icons = (
        appGrid = (png = (dpi1x = embed "app-graphics/appGrid.png")),
        grain = (png = (dpi1x = embed "app-graphics/grain.png")),
        market = (png = (dpi1x = embed "app-graphics/market.png")),
      ),

      website = "https://nodebb.org",
      codeUrl = "https://github.com/cem/nodebb-sandstorm",
      license = (openSource = gpl3),
      categories = [communications],

      author = (
        contactEmail = "cem@soda9.co",
        pgpSignature = embed "pgp-signature",
        upstreamAuthor = "NodeBB Inc.",
      ),
      pgpKeyring = embed "pgp-keyring",

      description = (defaultText = embed "description.md"),
      shortDescription = (defaultText = "Forum"),

      screenshots = [
        (width = 1056, height = 680, png = embed "screenshot.png")
      ],

      #changeLog = (defaultText = embed "CHANGELOG.md"),
    ),
 
  ),

  sourceMap = (
    # Here we defined where to look for files to copy into your package. The
    # `spk dev` command actually figures out what files your app needs
    # automatically by running it on a FUSE filesystem. So, the mappings
    # here are only to tell it where to find files that the app wants.
    searchPath = [
      ( sourcePath = "." ),  # Search this directory first.
      ( sourcePath = "/",    # Then search the system root directory.
        hidePaths = [ "home", "proc", "sys",
                      "etc/passwd", "etc/hosts", "etc/host.conf",
                      "etc/nsswitch.conf", "etc/resolv.conf" ]
        # You probably don't want the app pulling files from these places,
        # so we hide them. Note that /dev, /var, and /tmp are implicitly
        # hidden because Sandstorm itself provides them.
      )
    ]
  ),

  fileList = "sandstorm-files.list",
  # `spk dev` will write a list of all the files your app uses to this file.
  # You should review it later, before shipping your app.

  alwaysInclude = [],
  # Fill this list with more names of files or directories that should be
  # included in your package, even if not listed in sandstorm-files.list.
  # Use this to force-include stuff that you know you need but which may
  # not have been detected as a dependency during `spk dev`. If you list
  # a directory here, its entire contents will be included recursively.


  bridgeConfig = (
    viewInfo = (
      permissions = [(name = "post", title = (defaultText = "post"),
                      description = (defaultText = "allows posting on the forum")),
                     (name = "moderate", title = (defaultText = "moderate"),
                      description = (defaultText = "allows moderating the forum"))],
      roles = [(title = (defaultText = "poster"),
                permissions = [true, false],
                verbPhrase = (defaultText = "can post"),
                default = true),
               (title = (defaultText = "viewer"),
                permissions = [false, false],
                verbPhrase = (defaultText = "can view")),
               (title = (defaultText = "moderator"),
                permissions = [true, true],
                verbPhrase = (defaultText = "can moderate"))]
    )
  )
);

const myCommand :Spk.Manifest.Command = (
  # Here we define the command used to start up your server.
  argv = ["/sandstorm-http-bridge", "8000", "--", "/opt/app/.sandstorm/launcher.sh"],
  environ = [
    # Note that this defines the *entire* environment seen by your app.
    (key = "PATH", value = "/usr/local/bin:/usr/bin:/bin")
  ]
);
