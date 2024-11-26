Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B36D299
	for <kvmarm@lists.linux.dev>; Tue, 26 Nov 2024 09:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732614936; cv=none; b=UcgXhUY+axDz6wE9sjWAFNRKv0OEtv4HxO8kjovdf5euenRQhoZmtnJz3AP+dlUK2gvpnBsNQHGqlB3p0n4HVGJPzxsLuNBqbip24VFG17Lphy31I7Owx6jRiH6Z8Qac57Kc8tmb7yquimBJk8l4dVgb43zZ4cmcHWvI5+HQ9c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732614936; c=relaxed/simple;
	bh=FlXgw3F+cbl1cYiN4A/r64/k3GaAA4FmYh8F9QDNB3s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EjJ+8j/c3CaTkbOIOl1AhvjKxhnZLWuAWzwBa+TQLuOKMn/F87DG4ORA6FrfNCbU3nplC2Bb8FaCver7AXbOO+ud25EAtJAolEjqYG30J5bA8ejjEkwhRCLEJgUaR2GizU37Yx9wdlIaA1uYSiMtCuCJ/Zcpz5EnekYnTFDuFC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9935B1682;
	Tue, 26 Nov 2024 01:56:02 -0800 (PST)
Received: from login2.euhpc.arm.com (login2.euhpc.arm.com [10.6.38.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 10AE53F5A1;
	Tue, 26 Nov 2024 01:55:31 -0800 (PST)
From: Vladimir Murzin <vladimir.murzin@arm.com>
To: kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	nikos.nikoleris@arm.com
Subject: [kvm-unit-tests PATCH] arm64: Add basic MTE test
Date: Tue, 26 Nov 2024 09:55:13 +0000
Message-Id: <20241126095513.129737-1-vladimir.murzin@arm.com>
X-Mailer: git-send-email 2.24.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test tag storage access and tag mismatch for different MTE modes.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arm/Makefile.arm64            |   9 ++
 arm/cstart64.S                |   4 +-
 arm/mte.c                     | 266 ++++++++++++++++++++++++++++++++++
 arm/run                       |   3 +-
 arm/unittests.cfg             |  19 +++
 lib/arm64/asm/mmu.h           |   1 +
 lib/arm64/asm/pgtable-hwdef.h |   2 +
 lib/arm64/asm/sysreg.h        |  12 ++
 8 files changed, 314 insertions(+), 2 deletions(-)
 create mode 100644 arm/mte.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 3b9034e3..30df4e56 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -17,6 +17,14 @@ ifneq ($(strip $(sve_flag)),)
 CFLAGS += -DCC_HAS_SVE
 endif
 
+mte_flag := $(call cc-option, -march=armv8.5-a+memtag, "")
+ifneq ($(strip $(mte_flag)),)
+# Don't pass the option to the compiler, we don't
+# want the compiler to generate MTE instructions.
+CFLAGS += -DCC_HAS_MTE
+endif
+
+
 mno_outline_atomics := $(call cc-option, -mno-outline-atomics, "")
 CFLAGS += $(mno_outline_atomics)
 CFLAGS += -DCONFIG_RELOC
@@ -57,6 +65,7 @@ tests += $(TEST_DIR)/micro-bench.$(exe)
 tests += $(TEST_DIR)/cache.$(exe)
 tests += $(TEST_DIR)/debug.$(exe)
 tests += $(TEST_DIR)/fpu.$(exe)
+tests += $(TEST_DIR)/mte.$(exe)
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/arm/cstart64.S b/arm/cstart64.S
index b480a552..b9d7a446 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -242,6 +242,7 @@ halt:
  *   NORMAL             100     11111111
  *   NORMAL_WT          101     10111011
  *   DEVICE_nGRE        110     00001000
+ *   NORMAL_TAGGED      111     11110000
  */
 #define MAIR(attr, mt) ((attr) << ((mt) * 8))
 
@@ -275,7 +276,8 @@ asm_mmu_enable:
 		     MAIR(0x44, MT_NORMAL_NC) |		\
 		     MAIR(0xff, MT_NORMAL) |	        \
 		     MAIR(0xbb, MT_NORMAL_WT) |         \
-		     MAIR(0x08, MT_DEVICE_nGRE)
+		     MAIR(0x08, MT_DEVICE_nGRE) |       \
+		     MAIR(0xf0, MT_NORMAL_TAGGED)
 	msr	mair_el1, x1
 
 	/* TTBR0 */
diff --git a/arm/mte.c b/arm/mte.c
new file mode 100644
index 00000000..ae8d8b75
--- /dev/null
+++ b/arm/mte.c
@@ -0,0 +1,266 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2024 Arm Limited.
+ * All rights reserved.
+ */
+
+#include <libcflat.h>
+#include <alloc_page.h>
+#include <stdlib.h>
+#include <asm/mmu.h>
+#include <asm/sysreg.h>
+#include <asm/pgtable-hwdef.h>
+#include <asm/processor.h>
+#include <asm/thread_info.h>
+
+
+#define MTE_TCF_SYNC		0b01
+#define MTE_TCF_ASYNC		0b10
+#define MTE_TCF_ASYMM		0b11
+
+#define MTE_GRANULE_SIZE        UL(16)
+#define MTE_GRANULE_MASK        (~(MTE_GRANULE_SIZE - 1))
+#define MTE_TAG_SHIFT           56
+
+#define untagged(p)                                             		\
+({                                                              		\
+    unsigned long __in = (unsigned long)(p);                    		\
+    typeof(p) __out = (typeof(p))(__in & ~(MTE_GRANULE_MASK << MTE_TAG_SHIFT));	\
+    __out;                                                      		\
+})
+
+#define tagged(p,t)                                     	\
+({                                                      	\
+    unsigned long __in = (unsigned long)(untagged(p));  	\
+    unsigned long __tag = (unsigned long)(t) << MTE_TAG_SHIFT;	\
+    typeof(p) __out = (typeof(p))(__in | __tag);        	\
+    __out;                                              	\
+})
+
+
+static inline void mem_read(unsigned int *addr, unsigned int tag, unsigned int *res)
+{
+	unsigned int r;
+	asm volatile ("ldr %0,[%1]\n"
+		      "str %0,[%2]\n"
+		      : "=r" (r)
+		      : "r" (tagged(addr, tag)), "r" (res));
+}
+
+static inline void mem_write(unsigned int *addr, unsigned int tag, unsigned int val)
+{
+	asm volatile ("str %0,[%1]\n"
+		      "nop\n"
+		      :
+		      : "r" (val), "r" (tagged(addr, tag))
+		      : "memory");
+}
+
+static volatile bool mte_exception;
+
+static void mte_fault_handler(struct pt_regs *regs, unsigned int esr)
+{
+	unsigned int dfsc = esr & 0b111111;
+
+	if (dfsc == 0b010001)
+		mte_exception = true;
+
+        regs->pc += 8;
+}
+
+static inline void mmu_set_tagged(pgd_t *pgtable, unsigned long vaddr)
+{
+	pteval_t *p_pte = follow_pte(pgtable, vaddr);
+        if (p_pte) {
+                pteval_t entry = *p_pte;
+
+		entry &= ~PTE_ATTRINDX_MASK;
+		entry |= PTE_ATTRINDX(MT_NORMAL_TAGGED);
+
+                WRITE_ONCE(*p_pte, entry);
+                flush_tlb_page(vaddr);
+        }
+}
+
+static void mte_init(void)
+{
+	unsigned long sctlr = read_sysreg(sctlr_el1);
+	unsigned long tcr = read_sysreg(tcr_el1);
+
+	sctlr &= ~(SCTLR_EL1_ATA | SCTLR_EL1_ATA0);
+	sctlr &= ~(SCTLR_EL1_TCF_MASK | SCTLR_EL1_TCF0_MASK);
+	sctlr |= SCTLR_EL1_ATA | SCTLR_EL1_ATA0;
+
+	tcr |= TCR_TBI1 | TCR_TBI0;
+
+	write_sysreg(sctlr, sctlr_el1);
+	write_sysreg(tcr, tcr_el1);
+
+	isb();
+        flush_tlb_all();
+}
+
+static inline void mte_set_tcf(unsigned long tcf)
+{
+	unsigned long sctlr = read_sysreg(sctlr_el1);
+
+	sctlr &= ~(SCTLR_EL1_TCF_MASK | SCTLR_EL1_TCF0_MASK);
+	sctlr |= (tcf << SCTLR_EL1_TCF_SHIFT) & SCTLR_EL1_TCF_MASK ;
+	sctlr |= (tcf << SCTLR_EL1_TCF0_SHIFT) & SCTLR_EL1_TCF0_MASK ;
+
+	write_sysreg(sctlr, sctlr_el1);
+	isb();
+}
+
+
+static inline void mte_set_tag(void *addr, size_t size, unsigned int tag)
+{
+#ifdef CC_HAS_MTE
+	unsigned long in = (unsigned long)untagged(addr);
+	unsigned long start = ALIGN_DOWN(in, 16);
+	unsigned long end = ALIGN(in + size , 16);
+	for (unsigned long ptr = start; ptr < end; ptr += 16)
+            asm volatile(".arch   armv8.5-a+memtag\n"
+			 "stg %0, [%1]"
+                         :
+                         : "r"(tagged(ptr, tag)), "r"(ptr)
+                         : "memory");
+#endif
+}
+
+static inline unsigned long tfsr(void)
+{
+	unsigned long r;
+
+	dsb(nsh);
+
+	r = read_sysreg_s(TFSR_EL1);
+	write_sysreg_s(0, TFSR_EL1);
+
+	isb();
+
+	return r;
+}
+
+static void mte_sync_test(void)
+{
+	unsigned int *mem = alloc_page();
+	unsigned int val = 0;
+
+	memset(mem, 0xff, PAGE_SIZE);
+	mte_init();
+	mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
+	mte_set_tag(mem, PAGE_SIZE, 0);
+	mte_set_tcf(MTE_TCF_SYNC);
+
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);
+
+	mem_read(mem, 1, &val);
+
+	report((val == 0) && mte_exception, "read");
+
+	mte_exception = false;
+
+	mem_write(mem, 2, 0xbbbbbbbb);
+
+	report((*mem == 0xffffffff) && mte_exception, "write");
+}
+
+static void mte_asymm_test(void)
+{
+	unsigned int *mem = alloc_page();
+	unsigned int val = 0;
+
+	memset(mem, 0xff, PAGE_SIZE);
+	mte_init();
+	mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
+	mte_set_tag(mem, PAGE_SIZE, 0);
+	mte_set_tcf(MTE_TCF_ASYMM);
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);
+
+	mem_read(mem, 3, &val);
+	report((val == 0) && mte_exception, "read");
+
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, NULL);
+
+	mem_write(mem, 4, 0xaaaaaaaa);
+	report((*mem == 0xaaaaaaaa) && (tfsr() != 0), "write");
+}
+
+static void mte_async_test(void)
+{
+	unsigned int *mem = alloc_page();
+	unsigned int val = 0;
+
+
+	memset(mem, 0xff, PAGE_SIZE);
+	mte_init();
+	mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
+	mte_set_tag(mem, PAGE_SIZE, 0);
+	mte_set_tcf(MTE_TCF_ASYNC);
+
+	mem_read(mem, 5, &val);
+	report((val == 0xffffffff) && (tfsr() != 0), "read");
+
+	mem_write(mem, 6, 0xcccccccc);
+	report((*mem == 0xcccccccc) && (tfsr() != 0), "write");
+}
+
+
+static unsigned int mte_version(void)
+{
+#ifdef CC_HAS_MTE
+	uint64_t r;
+
+	asm volatile("mrs %x0, id_aa64pfr1_el1" : "=r"(r));
+
+	return (r >> 8) & 0b1111;
+#else
+	report_info("Compiler lack MTE support");
+	return 0;
+#endif
+}
+
+int main(int argc, char *argv[])
+{
+
+	unsigned int version = mte_version();
+
+        if (version < 2) {
+                report_skip("No MTE support, skip...\n");
+                return -1;
+        }
+
+        if (argc < 2)
+                report_abort("no test specified");
+
+	report_prefix_pushf("mte");
+
+	if (strcmp(argv[1], "sync") == 0) {
+                report_prefix_push(argv[1]);
+                mte_sync_test();
+                report_prefix_pop();
+        } else if (strcmp(argv[1], "async") == 0) {
+                report_prefix_push(argv[1]);
+		if (version < 3) {
+			report_skip("No MTE async, skip...\n");
+			return -1;
+		}
+                mte_async_test();
+                report_prefix_pop();
+
+        } else if (strcmp(argv[1], "asymm") == 0) {
+                report_prefix_push(argv[1]);
+		if (version < 3) {
+			report_skip("No MTE asymm, skip...\n");
+			return -1;
+		}
+                mte_asymm_test();
+                report_prefix_pop();
+
+        } else {
+                report_abort("Unknown sub-test '%s'", argv[1]);
+	}
+
+        return report_summary();
+}
diff --git a/arm/run b/arm/run
index efdd44ce..b129e4e0 100755
--- a/arm/run
+++ b/arm/run
@@ -29,7 +29,8 @@ if ! $qemu -machine '?' | grep -q 'ARM Virtual Machine'; then
 	exit 2
 fi
 
-M='-machine virt'
+MACHINE="virt"
+M="-machine $MACHINE$MACHINE_PROPS"
 
 if [ "$ACCEL" = "kvm" ]; then
 	if $qemu $M,\? | grep -q gic-version; then
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 2bdad67d..9b428c02 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -271,3 +271,22 @@ smp = 2
 groups = nodefault
 accel = kvm
 arch = arm64
+
+# MTE tests
+[mte-sync]
+file = mte.flat
+groups = nodefault
+extra_params = -append 'sync'
+arch = arm64
+
+[mte-async]
+file = mte.flat
+groups = nodefault
+extra_params = -append 'async'
+arch = arm64
+
+[mte-asymm]
+file = mte.flat
+groups = nodefault
+extra_params = -append 'asymm'
+arch = arm64
diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
index 5c27edb2..9aedd09a 100644
--- a/lib/arm64/asm/mmu.h
+++ b/lib/arm64/asm/mmu.h
@@ -10,6 +10,7 @@
 #define PMD_SECT_UNCACHED	PMD_ATTRINDX(MT_DEVICE_nGnRE)
 #define PTE_UNCACHED		PTE_ATTRINDX(MT_DEVICE_nGnRE)
 #define PTE_WBWA		PTE_ATTRINDX(MT_NORMAL)
+#define PTE_TAGGED		PTE_ATTRINDX(MT_NORMAL_TAGGED)
 
 static inline void flush_tlb_all(void)
 {
diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
index 8c41fe12..b66b62da 100644
--- a/lib/arm64/asm/pgtable-hwdef.h
+++ b/lib/arm64/asm/pgtable-hwdef.h
@@ -145,6 +145,7 @@
 #define TCR_TG1_64K		(UL(3) << 30)
 #define TCR_ASID16		(UL(1) << 36)
 #define TCR_TBI0		(UL(1) << 37)
+#define TCR_TBI1		(UL(1) << 38)
 
 /*
  * Memory types available.
@@ -156,5 +157,6 @@
 #define MT_NORMAL		4
 #define MT_NORMAL_WT		5
 #define MT_DEVICE_nGRE		6
+#define MT_NORMAL_TAGGED	7
 
 #endif /* _ASMARM64_PGTABLE_HWDEF_H_ */
diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index f214a4f0..60f51dad 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -28,6 +28,7 @@
 	.endm
 #else
 #include <libcflat.h>
+#include <bitops.h>
 
 #define read_sysreg(r) ({					\
 	u64 __val;						\
@@ -81,7 +82,12 @@ asm(
 #define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
 #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
 
+#define TFSR_EL1			sys_reg(3, 0, 5, 6, 0)
+
+
 /* System Control Register (SCTLR_EL1) bits */
+#define SCTLR_EL1_ATA		_BITULL(43)
+#define SCTLR_EL1_ATA0		_BITULL(42)
 #define SCTLR_EL1_LSMAOE	_BITULL(29)
 #define SCTLR_EL1_NTLSMD	_BITULL(28)
 #define SCTLR_EL1_EE		_BITULL(25)
@@ -99,6 +105,12 @@ asm(
 #define SCTLR_EL1_A		_BITULL(1)
 #define SCTLR_EL1_M		_BITULL(0)
 
+#define SCTLR_EL1_TCF_SHIFT	40
+#define SCTLR_EL1_TCF_MASK	GENMASK_ULL(41, 40)
+
+#define SCTLR_EL1_TCF0_SHIFT	38
+#define SCTLR_EL1_TCF0_MASK	GENMASK_ULL(39, 38)
+
 #define INIT_SCTLR_EL1_MMU_OFF	\
 			(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
 			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
-- 
2.25.1

