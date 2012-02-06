require 'formula'

class Dillo < Formula
  url 'http://www.dillo.org/download/dillo-3.0.2.tar.bz2'
  homepage 'http://www.dillo.org/'
  md5 '81b82112cefcc7d54fe2972a21f42930'

  depends_on 'fltk'
  depends_on 'jpeg'

  def patches
    # Fix build failure caused by hack to avoid linking in FLTK printer classes:
    #   ld: duplicate symbol Fl_Printer::class_id
    #       in  /usr/local/lib/libfltk.a(Fl_Printer.o)
    #       and ../dw/libDw-fltk.a(libDw_fltk_a-fltkplatform.o)
    #       for architecture x86_64
    DATA
  end

  def options
    [
      ['--disable-threaded-dns', 'use single-threaded DNS resolution'],
      ['--enable-ssl', 'enable SSL and HTTPS support'],
    ]
  end

  def install
    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--enable-ipv6",
    ] + (ARGV & options.keys)

    system "./autogen.sh" if ARGV.build_head?
    system "./configure", *args
    system "make install"
  end

  def caveats
    <<-EOS.undent
    Dillo's alpha-quality SSL support is disabled by default. To be able to
    browse HTTPS sites, install Dillo with the --enable-ssl option.
    EOS
  end
end

__END__
diff --git a/dw/fltkplatform.cc b/dw/fltkplatform.cc
index 099c449..271102a 100644
--- a/dw/fltkplatform.cc
+++ b/dw/fltkplatform.cc
@@ -32,6 +32,11 @@
  * Local data
  */
 
+#if 0
+/* OS X ld complains about duplicate symbols.
+ * The reason why this code was here in the first place is explained at:
+ *   http://lists.auriga.wearlab.de/pipermail/dillo-dev/2011-June/008447.html
+ */
 /* Use of Fl_Text_Display links in a lot of printer code that we don't have
  * any need for currently. This stub prevents that. */
 class FL_EXPORT Fl_Printer : public Fl_Paged_Device {
@@ -40,6 +45,7 @@ public:
    Fl_Printer(void) {};
 };
 const char *Fl_Printer::class_id = "Fl_Printer";
+#endif  /* 0 */
 
 /* Tooltips */
 static Fl_Menu_Window *tt_window = NULL;