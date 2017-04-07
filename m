From: Thomas Huth <thuth@redhat.com>
Subject: [RFC kvm-unit-tests PATCH 9/8] Makefiles: Fix up the powerpc build include and link paths
Date: Fri,  7 Apr 2017 08:58:10 +0200
Message-ID: <1491548290-11401-1-git-send-email-thuth@redhat.com>
References: <20170406190727.5624-9-alex.bennee@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170406190727.5624-9-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: alex.bennee@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com
Cc: drjones@redhat.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

The changes for out-of-tree builds are here pretty much the same
as for the ARM Makefile.common.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 powerpc/Makefile.common | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index e536ffe..1fbcafb 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -12,7 +12,10 @@ tests-common = \
 	$(TEST_DIR)/tm.elf \
 	$(TEST_DIR)/sprs.elf
 
-tests-all = $(tests-common) $(tests)
+scripts-common += $(TEST_DIR)/run
+scripts-common += $(TEST_DIR)/unittests.cfg
+
+tests-all = $(tests-common) $(tests) $(scripts_common)
 all: $(TEST_DIR)/boot_rom.bin $(tests-all)
 
 ##################################################################
@@ -21,14 +24,14 @@ CFLAGS += -std=gnu99
 CFLAGS += -ffreestanding
 CFLAGS += -Wextra
 CFLAGS += -O2
-CFLAGS += -I lib -I lib/libfdt
+CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
 CFLAGS += -Wa,-mregnames
 
 # We want to keep intermediate files
 .PRECIOUS: %.o
 
 asm-offsets = lib/$(ARCH)/asm-offsets.h
-include scripts/asm-offsets.mak
+include $(SRCDIR)/scripts/asm-offsets.mak
 
 cflatobjs += lib/util.o
 cflatobjs += lib/alloc.o
@@ -44,10 +47,11 @@ cflatobjs += lib/powerpc/smp.o
 FLATLIBS = $(libcflat) $(LIBFDT_archive)
 %.elf: CFLAGS += $(arch_CFLAGS)
 %.elf: LDFLAGS = $(arch_LDFLAGS) -nostdlib -pie -n
-%.elf: %.o $(FLATLIBS) powerpc/flat.lds $(cstart.o) $(reloc.o)
-	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) lib/auxinfo.c -DPROGNAME=\"$@\"
+%.elf: %.o $(FLATLIBS) $(SRCDIR)/powerpc/flat.lds $(cstart.o) $(reloc.o)
+	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c \
+		-DPROGNAME=\"$@\"
 	$(LD) $(LDFLAGS) -o $@ \
-		-T powerpc/flat.lds --build-id=none \
+		-T $(SRCDIR)/powerpc/flat.lds --build-id=none \
 		$(filter %.o, $^) $(FLATLIBS) $(@:.elf=.aux.o)
 	$(RM) $(@:.elf=.aux.o)
 	@echo -n Checking $@ for unsupported reloc types...
-- 
1.8.3.1
