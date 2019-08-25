Return-Path: <SRS0=WQoh=WV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06111C3A5A1
	for <kvmarm@archiver.kernel.org>; Sun, 25 Aug 2019 17:30:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 72B2D206BA
	for <kvmarm@archiver.kernel.org>; Sun, 25 Aug 2019 17:30:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="z/jVUTMr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72B2D206BA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=socionext.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AFB8C4A64B;
	Sun, 25 Aug 2019 13:30:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@nifty.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Gc9a-gbPCOHp; Sun, 25 Aug 2019 13:30:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48E744A5C4;
	Sun, 25 Aug 2019 13:30:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBEE84A5C4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 25 Aug 2019 13:30:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hJ+2oJAu2l7l for <kvmarm@lists.cs.columbia.edu>;
 Sun, 25 Aug 2019 13:30:34 -0400 (EDT)
Received: from conuserg-11.nifty.com (conuserg-11.nifty.com [210.131.2.78])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CB664A5C3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 25 Aug 2019 13:30:34 -0400 (EDT)
Received: from grover.flets-west.jp (softbank126125143222.bbtec.net
 [126.125.143.222]) (authenticated)
 by conuserg-11.nifty.com with ESMTP id x7PHSb7O010019;
 Mon, 26 Aug 2019 02:28:37 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com x7PHSb7O010019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
 s=dec2015msa; t=1566754118;
 bh=O8rVg1SxjWnsiBqfyChLy0jNlbeiFProErHAOQpA2Mo=;
 h=From:To:Cc:Subject:Date:From;
 b=z/jVUTMrEkyDDPZkmEQd2+urd8daK8IpIY1QBUGfpE718vIjykWHonuzimvizeyeZ
 IdFkT0v6FNX5pDQg5MmUnhGQ6Q1LdcjolG3E2rLgotthLHKMdi3V4ZUgdCKWm1TI8l
 KbpJJtIeq7hqmkAN4QFqzyjK9GpswiZ+sS3vjovXmXYKZgwa+Sgidl6jFvA8Bl5jD2
 YhVWU7aOianmGiV3S0rX+sGuf8dONVyX7gLex5yXHZbk25GyYYQc9yzDAeG66pxDyq
 XqNG9O2xKt/FIQDw3L5YcqjKYAwgeaUom5z9b6mUozIZVlOp112GOVjzEJpjyTTEz/
 LUoSsVVi8hZjw==
X-Nifty-SrcIP: [126.125.143.222]
From: Masahiro Yamada <yamada.masahiro@socionext.com>
To: linux-kbuild@vger.kernel.org
Subject: [PATCH 1/2] kbuild: change *FLAGS_<basetarget>.o to take the path
 relative to $(obj)
Date: Mon, 26 Aug 2019 02:28:32 +0900
Message-Id: <20190825172833.5708-1-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
Cc: Michal Marek <michal.lkml@markovi.net>, Marc Zyngier <maz@kernel.org>,
 x86@kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, Masahiro Yamada <yamada.masahiro@socionext.com>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 linux-arm-kernel@lists.infradead.org, Andy Lutomirski <luto@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Kbuild provides per-file compiler flag addition/removal:

  CFLAGS_<basetarget>.o
  CFLAGS_REMOVE_<basetarget>.o
  AFLAGS_<basetarget>.o
  AFLAGS_REMOVE_<basetarget>.o
  CPPFLAGS_<basetarget>
  HOSTCFLAGS_<basetarget>.o
  HOSTCXXFLAGS_<basetarget>.o

The <basetarget> is the filename of the target without its suffix.

This syntax comes into a trouble when two files with the same name
appear in one Makefile, for example:

  obj-y += foo.o
  obj-y += dir/foo.o
  CFLAGS_foo.o := <some-flags>

Here, the <some-flags> applies to both foo.o and dir/foo.o

The real world problem is:

  scripts/kconfig/util.c
  scripts/kconfig/lxdialog/util.c

Both files are compiled into scripts/kconfig/mconf, but only the
latter should be given with additional flags for ncurses.

It is more sensible to use the relative path to the Makefile, like this:

  obj-y += foo.o
  CFLAGS_foo.o := <some-flags>
  obj-y += dir/foo.o
  CFLAGS_dir/foo.o := <other-flags>

The $* variable is replaced with the stem ('%') part in a pattern rule.
In other words, this only works for pattern rules.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 arch/arm/kvm/Makefile        |  5 +++--
 arch/x86/entry/vdso/Makefile |  3 ++-
 scripts/Makefile.host        | 30 +++++++++++++++---------------
 scripts/Makefile.lib         | 10 +++++-----
 scripts/kconfig/Makefile     |  8 ++++----
 5 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index 531e59f5be9c..b76b75bd9e00 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -8,13 +8,14 @@ ifeq ($(plus_virt),+virt)
 	plus_virt_def := -DREQUIRES_VIRT=1
 endif
 
+KVM := ../../../virt/kvm
+
 ccflags-y += -I $(srctree)/$(src) -I $(srctree)/virt/kvm/arm/vgic
-CFLAGS_arm.o := $(plus_virt_def)
+CFLAGS_$(KVM)/arm/arm.o := $(plus_virt_def)
 
 AFLAGS_init.o := -Wa,-march=armv7-a$(plus_virt)
 AFLAGS_interrupts.o := -Wa,-march=armv7-a$(plus_virt)
 
-KVM := ../../../virt/kvm
 kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o
 
 obj-$(CONFIG_KVM_ARM_HOST) += hyp/
diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 8df549138193..0f2154106d01 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -89,6 +89,7 @@ $(vobjs): KBUILD_CFLAGS := $(filter-out $(GCC_PLUGINS_CFLAGS) $(RETPOLINE_CFLAGS
 #
 CFLAGS_REMOVE_vdso-note.o = -pg
 CFLAGS_REMOVE_vclock_gettime.o = -pg
+CFLAGS_REMOVE_vdso32/vclock_gettime.o = -pg
 CFLAGS_REMOVE_vgetcpu.o = -pg
 CFLAGS_REMOVE_vvar.o = -pg
 
@@ -128,7 +129,7 @@ $(obj)/%.so: $(obj)/%.so.dbg FORCE
 $(obj)/vdsox32.so.dbg: $(obj)/vdsox32.lds $(vobjx32s) FORCE
 	$(call if_changed,vdso_and_check)
 
-CPPFLAGS_vdso32.lds = $(CPPFLAGS_vdso.lds)
+CPPFLAGS_vdso32/vdso32.lds = $(CPPFLAGS_vdso.lds)
 VDSO_LDFLAGS_vdso32.lds = -m elf_i386 -soname linux-gate.so.1
 
 targets += vdso32/vdso32.lds
diff --git a/scripts/Makefile.host b/scripts/Makefile.host
index b402c619147d..cd2b98e2f727 100644
--- a/scripts/Makefile.host
+++ b/scripts/Makefile.host
@@ -80,9 +80,9 @@ host-cxxshobjs	:= $(addprefix $(obj)/,$(host-cxxshobjs))
 # Handle options to gcc. Support building with separate output directory
 
 _hostc_flags   = $(KBUILD_HOSTCFLAGS)   $(HOST_EXTRACFLAGS)   \
-                 $(HOSTCFLAGS_$(basetarget).o)
+                 $(HOSTCFLAGS_$*.o)
 _hostcxx_flags = $(KBUILD_HOSTCXXFLAGS) $(HOST_EXTRACXXFLAGS) \
-                 $(HOSTCXXFLAGS_$(basetarget).o)
+                 $(HOSTCXXFLAGS_$*.o)
 
 # $(objtree)/$(obj) for including generated headers from checkin source files
 ifeq ($(KBUILD_EXTMOD),)
@@ -102,7 +102,7 @@ hostcxx_flags  = -Wp,-MD,$(depfile) $(_hostcxx_flags)
 # host-csingle -> Executable
 quiet_cmd_host-csingle 	= HOSTCC  $@
       cmd_host-csingle	= $(HOSTCC) $(hostc_flags) $(KBUILD_HOSTLDFLAGS) -o $@ $< \
-		$(KBUILD_HOSTLDLIBS) $(HOSTLDLIBS_$(@F))
+		$(KBUILD_HOSTLDLIBS) $(HOSTLDLIBS_$*)
 $(host-csingle): $(obj)/%: $(src)/%.c FORCE
 	$(call if_changed_dep,host-csingle)
 
@@ -110,9 +110,9 @@ $(host-csingle): $(obj)/%: $(src)/%.c FORCE
 # host-cmulti -> executable
 quiet_cmd_host-cmulti	= HOSTLD  $@
       cmd_host-cmulti	= $(HOSTCC) $(KBUILD_HOSTLDFLAGS) -o $@ \
-			  $(addprefix $(obj)/,$($(@F)-objs)) \
-			  $(KBUILD_HOSTLDLIBS) $(HOSTLDLIBS_$(@F))
-$(host-cmulti): FORCE
+			  $(addprefix $(obj)/, $($*-objs)) \
+			  $(KBUILD_HOSTLDLIBS) $(HOSTLDLIBS_$*)
+$(host-cmulti): $(obj)/%: FORCE
 	$(call if_changed,host-cmulti)
 $(call multi_depend, $(host-cmulti), , -objs)
 
@@ -128,9 +128,9 @@ $(host-cobjs): $(obj)/%.o: $(src)/%.c FORCE
 quiet_cmd_host-cxxmulti	= HOSTLD  $@
       cmd_host-cxxmulti	= $(HOSTCXX) $(KBUILD_HOSTLDFLAGS) -o $@ \
 			  $(foreach o,objs cxxobjs,\
-			  $(addprefix $(obj)/,$($(@F)-$(o)))) \
-			  $(KBUILD_HOSTLDLIBS) $(HOSTLDLIBS_$(@F))
-$(host-cxxmulti): FORCE
+			  $(addprefix $(obj)/, $($*-$(o)))) \
+			  $(KBUILD_HOSTLDLIBS) $(HOSTLDLIBS_$*)
+$(host-cxxmulti): $(obj)/%: FORCE
 	$(call if_changed,host-cxxmulti)
 $(call multi_depend, $(host-cxxmulti), , -objs -cxxobjs)
 
@@ -161,9 +161,9 @@ $(host-cxxshobjs): $(obj)/%.o: $(src)/%.c FORCE
 # *.o -> .so shared library (host-cshlib)
 quiet_cmd_host-cshlib	= HOSTLLD -shared $@
       cmd_host-cshlib	= $(HOSTCC) $(KBUILD_HOSTLDFLAGS) -shared -o $@ \
-			  $(addprefix $(obj)/,$($(@F:.so=-objs))) \
-			  $(KBUILD_HOSTLDLIBS) $(HOSTLDLIBS_$(@F))
-$(host-cshlib): FORCE
+			  $(addprefix $(obj)/, $($*-objs)) \
+			  $(KBUILD_HOSTLDLIBS) $(HOSTLDLIBS_$*.so)
+$(host-cshlib): $(obj)/%.so: FORCE
 	$(call if_changed,host-cshlib)
 $(call multi_depend, $(host-cshlib), .so, -objs)
 
@@ -171,9 +171,9 @@ $(call multi_depend, $(host-cshlib), .so, -objs)
 # *.o -> .so shared library (host-cxxshlib)
 quiet_cmd_host-cxxshlib	= HOSTLLD -shared $@
       cmd_host-cxxshlib	= $(HOSTCXX) $(KBUILD_HOSTLDFLAGS) -shared -o $@ \
-			  $(addprefix $(obj)/,$($(@F:.so=-objs))) \
-			  $(KBUILD_HOSTLDLIBS) $(HOSTLDLIBS_$(@F))
-$(host-cxxshlib): FORCE
+			  $(addprefix $(obj)/, $($*-objs)) \
+			  $(KBUILD_HOSTLDLIBS) $(HOSTLDLIBS_$*.so)
+$(host-cxxshlib): $(obj)/%.so: FORCE
 	$(call if_changed,host-cxxshlib)
 $(call multi_depend, $(host-cxxshlib), .so, -objs)
 
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 264611972c4a..0d48e17bfb07 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -109,12 +109,12 @@ basename_flags = -DKBUILD_BASENAME=$(call name-fix,$(basetarget))
 modname_flags  = -DKBUILD_MODNAME=$(call name-fix,$(modname))
 
 orig_c_flags   = $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) \
-                 $(ccflags-y) $(CFLAGS_$(basetarget).o)
-_c_flags       = $(filter-out $(CFLAGS_REMOVE_$(basetarget).o), $(orig_c_flags))
+                 $(ccflags-y) $(CFLAGS_$*.o)
+_c_flags       = $(filter-out $(CFLAGS_REMOVE_$*.o), $(orig_c_flags))
 orig_a_flags   = $(KBUILD_CPPFLAGS) $(KBUILD_AFLAGS) \
-                 $(asflags-y) $(AFLAGS_$(basetarget).o)
-_a_flags       = $(filter-out $(AFLAGS_REMOVE_$(basetarget).o), $(orig_a_flags))
-_cpp_flags     = $(KBUILD_CPPFLAGS) $(cppflags-y) $(CPPFLAGS_$(@F))
+                 $(asflags-y) $(AFLAGS_$*.o)
+_a_flags       = $(filter-out $(AFLAGS_REMOVE_$*.o), $(orig_a_flags))
+_cpp_flags     = $(KBUILD_CPPFLAGS) $(cppflags-y) $(CPPFLAGS_$*.lds)
 
 #
 # Enable gcov profiling flags for a file, directory or for all files depending
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index bed7a5a2fbe9..ef2f2336c469 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -166,15 +166,15 @@ $(obj)/nconf.o $(obj)/nconf.gui.o: $(obj)/nconf-cfg
 
 # mconf: Used for the menuconfig target based on lxdialog
 hostprogs-y	+= mconf
-lxdialog	:= checklist.o inputbox.o menubox.o textbox.o util.o yesno.o
-mconf-objs	:= mconf.o $(addprefix lxdialog/, $(lxdialog)) $(common-objs)
+lxdialog	:= $(addprefix lxdialog/, \
+		     checklist.o inputbox.o menubox.o textbox.o util.o yesno.o)
+mconf-objs	:= mconf.o $(lxdialog) $(common-objs)
 
 HOSTLDLIBS_mconf = $(shell . $(obj)/mconf-cfg && echo $$libs)
 $(foreach f, mconf.o $(lxdialog), \
   $(eval HOSTCFLAGS_$f = $$(shell . $(obj)/mconf-cfg && echo $$$$cflags)))
 
-$(obj)/mconf.o: $(obj)/mconf-cfg
-$(addprefix $(obj)/lxdialog/, $(lxdialog)): $(obj)/mconf-cfg
+$(addprefix $(obj)/, mconf.o $(lxdialog)): $(obj)/mconf-cfg
 
 # qconf: Used for the xconfig target based on Qt
 hostprogs-y	+= qconf
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
