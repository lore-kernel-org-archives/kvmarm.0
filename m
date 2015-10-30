From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 2/2] Makefile: consider LDFLAGS on feature tests and when
 linking executables
Date: Fri, 30 Oct 2015 17:20:50 +0000
Message-ID: <1446225650-19710-3-git-send-email-andre.przywara@arm.com>
References: <1446225650-19710-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3919A41294
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2015 13:17:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3bDk17OThxFb for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2015 13:17:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B69EF412DD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2015 13:17:16 -0400 (EDT)
In-Reply-To: <1446225650-19710-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: will.deacon@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

While we have an LDFLAGS variable in kvmtool's Makefile, it's not
really used when both doing the feature tests and when finally linking
the lkvm executable.
Add that variable to all the linking steps to allow the user to
specify custom library directories or linker options on the command
line.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 Makefile | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/Makefile b/Makefile
index 77a7c9f..eac1220 100644
--- a/Makefile
+++ b/Makefile
@@ -196,12 +196,12 @@ endif
 # On a given system, some libs may link statically, some may not; so, check
 # both and only build those that link!
 
-ifeq ($(call try-build,$(SOURCE_STRLCPY),$(CFLAGS),),y)
+ifeq ($(call try-build,$(SOURCE_STRLCPY),$(CFLAGS),$(LDFLAGS)),y)
 	CFLAGS_DYNOPT	+= -DHAVE_STRLCPY
 	CFLAGS_STATOPT	+= -DHAVE_STRLCPY
 endif
 
-ifeq ($(call try-build,$(SOURCE_BFD),$(CFLAGS),-lbfd -static),y)
+ifeq ($(call try-build,$(SOURCE_BFD),$(CFLAGS),$(LDFLAGS) -lbfd -static),y)
 	CFLAGS_STATOPT	+= -DCONFIG_HAS_BFD
 	OBJS_STATOPT	+= symbol.o
 	LIBS_STATOPT	+= -lbfd
@@ -212,7 +212,7 @@ endif
 ifeq (y,$(ARCH_HAS_FRAMEBUFFER))
 	CFLAGS_GTK3 := $(shell pkg-config --cflags gtk+-3.0 2>/dev/null)
 	LDFLAGS_GTK3 := $(shell pkg-config --libs gtk+-3.0 2>/dev/null)
-	ifeq ($(call try-build,$(SOURCE_GTK3),$(CFLAGS) $(CFLAGS_GTK3),$(LDFLAGS_GTK3)),y)
+	ifeq ($(call try-build,$(SOURCE_GTK3),$(CFLAGS) $(CFLAGS_GTK3),$(LDFLAGS) $(LDFLAGS_GTK3)),y)
 		OBJS_DYNOPT	+= ui/gtk3.o
 		CFLAGS_DYNOPT	+= -DCONFIG_HAS_GTK3 $(CFLAGS_GTK3)
 		LIBS_DYNOPT	+= $(LDFLAGS_GTK3)
@@ -220,63 +220,63 @@ ifeq (y,$(ARCH_HAS_FRAMEBUFFER))
 		NOTFOUND	+= GTK3
 	endif
 
-	ifeq ($(call try-build,$(SOURCE_VNCSERVER),$(CFLAGS),-lvncserver),y)
+	ifeq ($(call try-build,$(SOURCE_VNCSERVER),$(CFLAGS),$(LDFLAGS) -lvncserver),y)
 		OBJS_DYNOPT	+= ui/vnc.o
 		CFLAGS_DYNOPT	+= -DCONFIG_HAS_VNCSERVER
 		LIBS_DYNOPT	+= -lvncserver
 	else
 		NOTFOUND	+= vncserver
 	endif
-	ifeq ($(call try-build,$(SOURCE_VNCSERVER),$(CFLAGS),-lvncserver -static),y)
+	ifeq ($(call try-build,$(SOURCE_VNCSERVER),$(CFLAGS),$(LDFLAGS) -lvncserver -static),y)
 		OBJS_STATOPT	+= ui/vnc.o
 		CFLAGS_STATOPT	+= -DCONFIG_HAS_VNCSERVER
 		LIBS_STATOPT	+= -lvncserver
 	endif
 
-	ifeq ($(call try-build,$(SOURCE_SDL),$(CFLAGS),-lSDL),y)
+	ifeq ($(call try-build,$(SOURCE_SDL),$(CFLAGS),$(LDFLAGS) -lSDL),y)
 		OBJS_DYNOPT	+= ui/sdl.o
 		CFLAGS_DYNOPT	+= -DCONFIG_HAS_SDL
 		LIBS_DYNOPT	+= -lSDL
 	else
 		NOTFOUND	+= SDL
 	endif
-	ifeq ($(call try-build,$(SOURCE_SDL),$(CFLAGS),-lSDL -static), y)
+	ifeq ($(call try-build,$(SOURCE_SDL),$(CFLAGS),$(LDFLAGS) -lSDL -static), y)
 		OBJS_STATOPT	+= ui/sdl.o
 		CFLAGS_STATOPT	+= -DCONFIG_HAS_SDL
 		LIBS_STATOPT	+= -lSDL
 	endif
 endif
 
-ifeq ($(call try-build,$(SOURCE_ZLIB),$(CFLAGS),-lz),y)
+ifeq ($(call try-build,$(SOURCE_ZLIB),$(CFLAGS),$(LDFLAGS) -lz),y)
 	CFLAGS_DYNOPT	+= -DCONFIG_HAS_ZLIB
 	LIBS_DYNOPT	+= -lz
 else
 	NOTFOUND	+= zlib
 endif
-ifeq ($(call try-build,$(SOURCE_ZLIB),$(CFLAGS),-lz -static),y)
+ifeq ($(call try-build,$(SOURCE_ZLIB),$(CFLAGS),$(LDFLAGS) -lz -static),y)
 	CFLAGS_STATOPT	+= -DCONFIG_HAS_ZLIB
 	LIBS_STATOPT	+= -lz
 endif
 
-ifeq ($(call try-build,$(SOURCE_AIO),$(CFLAGS),-laio),y)
+ifeq ($(call try-build,$(SOURCE_AIO),$(CFLAGS),$(LDFLAGS) -laio),y)
 	CFLAGS_DYNOPT	+= -DCONFIG_HAS_AIO
 	LIBS_DYNOPT	+= -laio
 else
 	NOTFOUND	+= aio
 endif
-ifeq ($(call try-build,$(SOURCE_AIO),$(CFLAGS),-laio -static),y)
+ifeq ($(call try-build,$(SOURCE_AIO),$(CFLAGS),$(LDFLAGS) -laio -static),y)
 	CFLAGS_STATOPT	+= -DCONFIG_HAS_AIO
 	LIBS_STATOPT	+= -laio
 endif
 
 ifeq ($(LTO),1)
 	FLAGS_LTO := -flto
-	ifeq ($(call try-build,$(SOURCE_HELLO),$(CFLAGS),$(FLAGS_LTO)),y)
+	ifeq ($(call try-build,$(SOURCE_HELLO),$(CFLAGS),$(LDFLAGS) $(FLAGS_LTO)),y)
 		override CFLAGS	+= $(FLAGS_LTO)
 	endif
 endif
 
-ifeq ($(call try-build,$(SOURCE_STATIC),,-static),y)
+ifeq ($(call try-build,$(SOURCE_STATIC),$(CFLAGS),$(LDFLAGS) -static),y)
 	override CFLAGS	+= -DCONFIG_GUEST_INIT
 	GUEST_INIT	:= guest/init
 	GUEST_OBJS	= guest/guest_init.o
@@ -370,11 +370,11 @@ STATIC_OBJS = $(patsubst %.o,%.static.o,$(OBJS) $(OBJS_STATOPT))
 
 $(PROGRAM)-static:  $(STATIC_OBJS) $(OTHEROBJS) $(GUEST_INIT) $(GUEST_PRE_INIT)
 	$(E) "  LINK    " $@
-	$(Q) $(CC) -static $(CFLAGS) $(STATIC_OBJS) $(OTHEROBJS) $(GUEST_OBJS) $(LIBS) $(LIBS_STATOPT) -o $@
+	$(Q) $(CC) -static $(CFLAGS) $(STATIC_OBJS) $(OTHEROBJS) $(GUEST_OBJS) $(LDFLAGS) $(LIBS) $(LIBS_STATOPT) -o $@
 
 $(PROGRAM): $(OBJS) $(OBJS_DYNOPT) $(OTHEROBJS) $(GUEST_INIT) $(GUEST_PRE_INIT)
 	$(E) "  LINK    " $@
-	$(Q) $(CC) $(CFLAGS) $(OBJS) $(OBJS_DYNOPT) $(OTHEROBJS) $(GUEST_OBJS) $(LIBS) $(LIBS_DYNOPT) -o $@
+	$(Q) $(CC) $(CFLAGS) $(OBJS) $(OBJS_DYNOPT) $(OTHEROBJS) $(GUEST_OBJS) $(LDFLAGS) $(LIBS) $(LIBS_DYNOPT) -o $@
 
 $(PROGRAM_ALIAS): $(PROGRAM)
 	$(E) "  LN      " $@
-- 
2.5.1
