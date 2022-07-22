Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71731C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jul 2022 14:14:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E60F24CDAF;
	Fri, 22 Jul 2022 10:14:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B23RS8wRANMs; Fri, 22 Jul 2022 10:14:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87F864CDE1;
	Fri, 22 Jul 2022 10:14:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC0234CCA8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2022 10:14:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4njnAMDZcSFg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2022 10:14:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45B974CCA0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2022 10:14:20 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 451D2106F;
 Fri, 22 Jul 2022 07:14:20 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0933E3F70D;
 Fri, 22 Jul 2022 07:14:17 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
 andre.przywara@arm.com, suzuki.poulose@arm.com, james.morse@arm.com,
 vladimir.murzin@arm.com, anup@brainfault.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH kvmtool 1/1] Makefile: Introduce LIBFDT_DIR to specify libfdt
 location
Date: Fri, 22 Jul 2022 15:14:48 +0100
Message-Id: <20220722141448.168252-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220722141448.168252-1-alexandru.elisei@arm.com>
References: <20220722141448.168252-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The arm, arm64, powerpc and riscv architectures require that libfdt is
installed on the system, however the library might not be available for
every architecture on the user's distro of choice. Or the static version of
the library, needed for the lkvm-static target, might be missing.
Fortunately, kvmtool has anticipated this situation and it includes
instructions to compile and install libfdt in the INSTALL file.
Unfortunately, those instructions do not always work (for example, because
the user is missing the needed permisssions), leaving the user unable to
compile kvmtool.

As an alternative to installing libfdt system-wide, provide the
LIBFDT_DIR variable when compiling kvmtool. For example, when compiling
with the command:

$ make ARCH=<arch> CROSS_COMPILE=<cross_compile> LIBFDT_DIR=<dir>

kvmtool will link the executable against the static version of the library
located in LIBFDT_DIR/libfdt.a.

LIBFDT_DIR takes precedence over the system library, as there are valid
reasons to prefer a self-compiled library over the one that the distro
provides (like the system library being older).

Note that this will slightly increase the size of the executable. For the
arm64 architecture, the increase has been measured to be about 100KB, or
about 5% of the total executable size.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 INSTALL  | 12 +++++++++++-
 Makefile | 29 ++++++++++++++++++++++-------
 2 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/INSTALL b/INSTALL
index 951b12339887..2a65735090a7 100644
--- a/INSTALL
+++ b/INSTALL
@@ -91,10 +91,20 @@ can cross-compile the libfdt library yourself:
 $ git clone git://git.kernel.org/pub/scm/utils/dtc/dtc.git
 $ cd dtc
 $ export CC=${CROSS_COMPILE}gcc
+$ make libfdt
+
+After compiling libfdt, the library can be installed system-wide:
+
 $ TRIPLET=$($CC -dumpmachine)
 $ SYSROOT=$($CC -print-sysroot)
-$ make libfdt
 $ sudo make DESTDIR=$SYSROOT PREFIX=/usr LIBDIR=/usr/lib/$TRIPLET install-lib install-includes
 
 This assumes a multiarch-enabled system, if there is no per-arch directory for
 libraries, replace the LIBDIR paths above with LIBDIR=/usr/lib or /usr/lib64.
+
+Alternatively, if installing the shared library is not desirable or possible,
+you can instruct kvmtool to use the static library when compiling by using the
+variable LIBFDT_DIR. LIBFDT_DIR should point to the dtc/libfdt directory.
+kvmtool will include the static library LIBFDT_DIR/libfdt.a in the executable,
+removing the need for the shared library to be present on the system.
+LIBFDT_DIR, when set, takes precedence over the system library.
diff --git a/Makefile b/Makefile
index 1f9903d81516..815400453438 100644
--- a/Makefile
+++ b/Makefile
@@ -353,13 +353,28 @@ $(warning No static libc found. Skipping guest init)
 endif
 
 ifeq (y,$(ARCH_WANT_LIBFDT))
-	ifneq ($(call try-build,$(SOURCE_LIBFDT),$(CFLAGS),-lfdt),y)
-          $(error No libfdt found. Please install libfdt-dev package)
-	else
+	ifneq ($(LIBFDT_DIR),)
+		ifeq ($(wildcard $(LIBFDT_DIR)),)
+                        $(error LIBFDT_DIR not found)
+		endif
+
+		LIBFDT_STATIC	:= $(LIBFDT_DIR)/libfdt.a
+
+		ifeq ($(wildcard $(LIBFDT_STATIC)),)
+                        $(error libfdt.a not found)
+		endif
+
+		CFLAGS_DYNOPT	+= -DCONFIG_HAS_LIBFDT
+		CFLAGS_STATOPT	+= -DCONFIG_HAS_LIBFDT
+		CFLAGS		+= -I $(LIBFDT_DIR)
+	else ifeq ($(call try-build,$(SOURCE_LIBFDT),$(CFLAGS),-lfdt),y)
+		LIBFDT_STATIC	:=
 		CFLAGS_DYNOPT	+= -DCONFIG_HAS_LIBFDT
 		CFLAGS_STATOPT	+= -DCONFIG_HAS_LIBFDT
 		LIBS_DYNOPT	+= -lfdt
 		LIBS_STATOPT	+= -lfdt
+	else
+                $(error No libfdt found. Please install libfdt-dev package or set LIBFDT_DIR)
 	endif
 endif
 
@@ -433,13 +448,13 @@ STATIC_OBJS = $(patsubst %.o,%.static.o,$(OBJS) $(OBJS_STATOPT))
 STATIC_DEPS	:= $(foreach obj,$(STATIC_OBJS),\
 		$(subst $(comma),_,$(dir $(obj)).$(notdir $(obj)).d))
 
-$(PROGRAM)-static:  $(STATIC_OBJS) $(OTHEROBJS) $(GUEST_OBJS)
+$(PROGRAM)-static:  $(STATIC_OBJS) $(OTHEROBJS) $(GUEST_OBJS) $(LIBFDT_STATIC)
 	$(E) "  LINK    " $@
-	$(Q) $(CC) -static $(CFLAGS) $(STATIC_OBJS) $(OTHEROBJS) $(GUEST_OBJS) $(LDFLAGS) $(LIBS) $(LIBS_STATOPT) -o $@
+	$(Q) $(CC) -static $(CFLAGS) $(STATIC_OBJS) $(OTHEROBJS) $(GUEST_OBJS) $(LDFLAGS) $(LIBS) $(LIBS_STATOPT) $(LIBFDT_STATIC) -o $@
 
-$(PROGRAM): $(OBJS) $(OBJS_DYNOPT) $(OTHEROBJS) $(GUEST_OBJS)
+$(PROGRAM): $(OBJS) $(OBJS_DYNOPT) $(OTHEROBJS) $(GUEST_OBJS) $(LIBFDT_STATIC)
 	$(E) "  LINK    " $@
-	$(Q) $(CC) $(CFLAGS) $(OBJS) $(OBJS_DYNOPT) $(OTHEROBJS) $(GUEST_OBJS) $(LDFLAGS) $(LIBS) $(LIBS_DYNOPT) -o $@
+	$(Q) $(CC) $(CFLAGS) $(OBJS) $(OBJS_DYNOPT) $(OTHEROBJS) $(GUEST_OBJS) $(LDFLAGS) $(LIBS) $(LIBS_DYNOPT) $(LIBFDT_STATIC) -o $@
 
 $(PROGRAM_ALIAS): $(PROGRAM)
 	$(E) "  LN      " $@
-- 
2.37.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
