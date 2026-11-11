{ config, ... }:
let
  amo = slug: "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
in {
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableProfileImport = true;
      DontCheckDefaultBrowser = true;
      PasswordManagerEnabled = false;
      OfferToSaveLogins = false;
      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        Stories = false;
        SponsoredPocket = false;
        SponsoredStories = false;
        Snippets = false;
        Locked = true;
      };
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        MoreFromMozilla = false;
        SkipOnboarding = true;
        UrlbarInterventions = false;
      };
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = amo "ublock-origin";
          installation_mode = "force_installed";
        };
        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
          install_url = amo "1password-x-password-manager";
          installation_mode = "force_installed";
        };
        # "Dark" theme
        "{7cbdf3df-936d-4b13-811f-320bf981f801}" = {
          install_url = amo "nicedarktheme";
          installation_mode = "force_installed";
        };
      };
    };

    profiles.default = {
      isDefault = true;

      search = {
        force = true;
        default = "google";
        order = [ "google" "ddg" ];
        engines = builtins.listToAttrs (map (id: {
          name = id;
          value.metaData.hidden = true;
        }) [ "bing" "amazondotcom-us" "ebay" "wikipedia" "perplexity" ]);
      };

      settings = {
        # dark
        "extensions.activeThemeID" = "{7cbdf3df-936d-4b13-811f-320bf981f801}";
        "layout.css.prefers-color-scheme.content-override" = 0;

        # vertical tabs, collapsed until hover
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
        "sidebar.visibility" = "expand-on-hover";

        # declutter
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;
        "browser.tabs.inTitlebar" = 0;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.tabs.firefox-view" = false;
        "browser.aboutwelcome.enabled" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;

        # startup: restore session, blank new tab
        "browser.startup.page" = 3;
        "browser.newtabpage.enabled" = false;
        "browser.startup.homepage" = "about:blank";
        "browser.newtabpage.activity-stream.showWeather" = false;
        "browser.newtabpage.activity-stream.system.showWeather" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;

        # privacy
        "browser.contentblocking.category" = "strict";
        "dom.security.https_only_mode" = true;
        "dom.private-attribution.submission.enabled" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        "breakpad.reportURL" = "";

        # passwords handled by 1password
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "signon.generation.enabled" = false;
      };
    };
  };
}
