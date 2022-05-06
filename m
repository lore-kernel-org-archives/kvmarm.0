Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B0DC433FE
	for <kvmarm@archiver.kernel.org>; Sat,  7 May 2022 09:14:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D25E34B2BC;
	Sat,  7 May 2022 05:14:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1j+kEqqYkaMD; Sat,  7 May 2022 05:14:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 629E54B2DB;
	Sat,  7 May 2022 05:14:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 615784B177
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 10:09:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1acHksbSV6wW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2022 10:09:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B94224B1E9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 10:09:27 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F4D61570;
 Fri,  6 May 2022 07:09:27 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com
 [10.7.66.42])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8FC793F885;
 Fri,  6 May 2022 07:09:26 -0700 (PDT)
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH 22/23] arm64: Add support for efi in Makefile
Date: Fri,  6 May 2022 15:08:54 +0100
Message-Id: <20220506140855.353337-23-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220506140855.353337-1-nikos.nikoleris@arm.com>
References: <20220506140855.353337-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
X-Mailman-Approved-At: Sat, 07 May 2022 05:14:38 -0400
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, jade.alglave@arm.com
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

Users can now build kvm-unit-tests as efi apps by supplying an extra
argument when invoking configure:

$> ./configure --enable-efi

This patch is based on an earlier version by
Andrew Jones <drjones@redhat.com>

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 configure           | 15 ++++++++++++---
 arm/Makefile.arm    |  6 ++++++
 arm/Makefile.arm64  | 18 ++++++++++++++----
 arm/Makefile.common | 45 ++++++++++++++++++++++++++++++++++-----------
 4 files changed, 66 insertions(+), 18 deletions(-)

diff --git a/configure b/configure
index 86c3095..beef655 100755
--- a/configure
+++ b/configure
@@ -195,14 +195,19 @@ else
     fi
 fi
 
-if [ "$efi" ] && [ "$arch" != "x86_64" ]; then
+if [ "$efi" ] && [ "$arch" != "x86_64" ] && [ "$arch" != "arm64" ]; then
     echo "--[enable|disable]-efi is not supported for $arch"
     usage
 fi
 
 if [ -z "$page_size" ]; then
-    [ "$arch" = "arm64" ] && page_size="65536"
-    [ "$arch" = "arm" ] && page_size="4096"
+    if [ "$efi" = 'y' ] && [ "$arch" = "arm64" ]; then
+        page_size="4096"
+    elif [ "$arch" = "arm64" ]; then
+        page_size="65536"
+    elif [ "$arch" = "arm" ]; then
+        page_size="4096"
+    fi
 else
     if [ "$arch" != "arm64" ]; then
         echo "--page-size is not supported for $arch"
@@ -217,6 +222,10 @@ else
         echo "arm64 doesn't support page size of $page_size"
         usage
     fi
+    if [ "$efi" = 'y' ] && [ "$page_size" != "4096" ]; then
+        echo "efi must use 4K pages"
+        exit 1
+    fi
 fi
 
 [ -z "$processor" ] && processor="$arch"
diff --git a/arm/Makefile.arm b/arm/Makefile.arm
index 01fd4c7..2ce00f5 100644
--- a/arm/Makefile.arm
+++ b/arm/Makefile.arm
@@ -7,6 +7,10 @@ bits = 32
 ldarch = elf32-littlearm
 machine = -marm -mfpu=vfp
 
+ifeq ($(CONFIG_EFI),y)
+$(error Cannot build arm32 tests as EFI apps)
+endif
+
 # stack.o relies on frame pointers.
 KEEP_FRAME_POINTER := y
 
@@ -32,6 +36,8 @@ cflatobjs += lib/arm/stack.o
 cflatobjs += lib/ldiv32.o
 cflatobjs += lib/arm/ldivmod.o
 
+exe = flat
+
 # arm specific tests
 tests =
 
diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 6feac76..550e1b2 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -27,11 +27,21 @@ cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
 
 OBJDIRS += lib/arm64
 
+ifeq ($(CONFIG_EFI),y)
+# avoid jump tables before all relocations have been processed
+arm/efi/reloc_aarch64.o: CFLAGS += -fno-jump-tables
+cflatobjs += arm/efi/reloc_aarch64.o
+
+exe = efi
+else
+exe = flat
+endif
+
 # arm64 specific tests
-tests = $(TEST_DIR)/timer.flat
-tests += $(TEST_DIR)/micro-bench.flat
-tests += $(TEST_DIR)/cache.flat
-tests += $(TEST_DIR)/debug.flat
+tests = $(TEST_DIR)/timer.$(exe)
+tests += $(TEST_DIR)/micro-bench.$(exe)
+tests += $(TEST_DIR)/cache.$(exe)
+tests += $(TEST_DIR)/debug.$(exe)
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/arm/Makefile.common b/arm/Makefile.common
index 5be42c0..a8007f4 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -4,14 +4,14 @@
 # Authors: Andrew Jones <drjones@redhat.com>
 #
 
-tests-common  = $(TEST_DIR)/selftest.flat
-tests-common += $(TEST_DIR)/spinlock-test.flat
-tests-common += $(TEST_DIR)/pci-test.flat
-tests-common += $(TEST_DIR)/pmu.flat
-tests-common += $(TEST_DIR)/gic.flat
-tests-common += $(TEST_DIR)/psci.flat
-tests-common += $(TEST_DIR)/sieve.flat
-tests-common += $(TEST_DIR)/pl031.flat
+tests-common  = $(TEST_DIR)/selftest.$(exe)
+tests-common += $(TEST_DIR)/spinlock-test.$(exe)
+tests-common += $(TEST_DIR)/pci-test.$(exe)
+tests-common += $(TEST_DIR)/pmu.$(exe)
+tests-common += $(TEST_DIR)/gic.$(exe)
+tests-common += $(TEST_DIR)/psci.$(exe)
+tests-common += $(TEST_DIR)/sieve.$(exe)
+tests-common += $(TEST_DIR)/pl031.$(exe)
 
 tests-all = $(tests-common) $(tests)
 all: directories $(tests-all)
@@ -54,6 +54,9 @@ cflatobjs += lib/arm/smp.o
 cflatobjs += lib/arm/delay.o
 cflatobjs += lib/arm/gic.o lib/arm/gic-v2.o lib/arm/gic-v3.o
 cflatobjs += lib/arm/timer.o
+ifeq ($(CONFIG_EFI),y)
+cflatobjs += lib/efi.o
+endif
 
 OBJDIRS += lib/arm
 
@@ -61,6 +64,25 @@ libeabi = lib/arm/libeabi.a
 eabiobjs = lib/arm/eabi_compat.o
 
 FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
+
+ifeq ($(CONFIG_EFI),y)
+%.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
+%.so: %.o $(FLATLIBS) $(SRCDIR)/arm/efi/elf_aarch64_efi.lds $(cstart.o)
+	$(CC) $(CFLAGS) -c -o $(@:.so=.aux.o) $(SRCDIR)/lib/auxinfo.c \
+		-DPROGNAME=\"$(@:.so=.efi)\" -DAUXFLAGS=$(AUXFLAGS)
+	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/arm/efi/elf_aarch64_efi.lds \
+		$(filter %.o, $^) $(FLATLIBS) $(@:.so=.aux.o) \
+		$(EFI_LIBS)
+	$(RM) $(@:.so=.aux.o)
+
+%.efi: %.so
+	$(call arch_elf_check, $^)
+	$(OBJCOPY) \
+		-j .text -j .sdata -j .data -j .dynamic -j .dynsym \
+		-j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
+		-j .reloc \
+		-O binary $^ $@
+else
 %.elf: LDFLAGS = -nostdlib $(arch_LDFLAGS)
 %.elf: %.o $(FLATLIBS) $(SRCDIR)/arm/flat.lds $(cstart.o)
 	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c \
@@ -74,13 +96,14 @@ FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
 	$(call arch_elf_check, $^)
 	$(OBJCOPY) -O binary $^ $@
 	@chmod a-x $@
+endif
 
 $(libeabi): $(eabiobjs)
 	$(AR) rcs $@ $^
 
 arm_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,flat,elf} $(libeabi) $(eabiobjs) \
-	      $(TEST_DIR)/.*.d lib/arm/.*.d
+	$(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi} $(libeabi) $(eabiobjs) \
+	      $(TEST_DIR)/.*.d $(TEST_DIR)/efi/.*.d lib/arm/.*.d
 
 generated-files = $(asm-offsets)
-$(tests-all:.flat=.o) $(cstart.o) $(cflatobjs): $(generated-files)
+$(tests-all:.$(exe)=.o) $(cstart.o) $(cflatobjs): $(generated-files)
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
