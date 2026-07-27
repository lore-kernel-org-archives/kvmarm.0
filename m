Received: from confino.investici.org (confino.investici.org [93.190.126.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A1B426693
	for <kvmarm@lists.linux.dev>; Mon, 27 Jul 2026 18:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.190.126.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785177018; cv=none; b=mxfh2Nc8cWVZPXvS6Hipi8zGKs5snMi1Gad6S33beumC1WcxRE5S0gMQekT1E19Mz3b2oBtaVPMbFHxW8GSN59UJtCtyBiumTA+I1aUiNO3zR5y69u8iELSBqrMy7kwvBBhk4r7hkFLjVJIZZfiT6Z9rkCqXe541KbsO3/px28M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785177018; c=relaxed/simple;
	bh=zwsTwXhJLzTMQWbR+sHBlsltUH2XuVunZTcIcAi5uZo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sdVWbdxjyBC2C6EzTjukFobGJ4srbi4Fmwy98VaI7sOklwl3w+qfY27IV6cXMGMKWl7+u4GV939NyPCAUEYYipM5s1Nj8yWHveRxTZxzaPZK85N5F4C1meT+2tIEtk9s49sLxWgLwna1VynByWzz0V3MOY9NTtL3NMBrwKJNFY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net; spf=pass smtp.mailfrom=grrlz.net; dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b=hR/lQT8O; arc=none smtp.client-ip=93.190.126.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grrlz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b="hR/lQT8O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1785177006;
	bh=JlQNF4yHtnpvNhFrRalK9y5HMb8J8DOXcYWlwHyoEec=;
	h=From:To:Cc:Subject:Date:From;
	b=hR/lQT8OIYsdwwJTh1Tc4/tj85NxrmWd7eaXU4w/JLKYiyRn10JCmUVC45h7Mys2w
	 IXsV8/7fgzfjOtSTSprSr4gJM7QQVZXJqgiUx067tdAyTjeIosRza//9dfL0sQNOdH
	 7c3DuKVaQPTK6iFTY0fFX+K69Af3/gjMsOOcffTw=
Received: from mx1.investici.org (unknown [127.0.0.1])
	by confino.investici.org (Postfix) with ESMTP id 4h86b26bllz1142;
	Mon, 27 Jul 2026 18:30:06 +0000 (UTC)
Received: by mx1.investici.org (Postfix) id 4h86b161rtz10xk;
	Mon, 27 Jul 2026 18:30:05 +0000 (UTC)
From: Bradley Morgan <include@grrlz.net>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org,
	Bradley Morgan <include@grrlz.net>
Subject: [RFC PATCH] KVM: arm64: Add KUnit tests for stage 2 walker memcache consumption
Date: Mon, 27 Jul 2026 18:30:05 +0000
Message-ID: <20260727183005.10377-1-include@grrlz.net>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The stage 2 walker in hyp/pgtable.c takes every dependency through
struct kvm_pgtable_mm_ops, so it can be exercised against a mock
allocator with a bounded page budget: the same shape as the memcache a
fault handler stages before calling kvm_pgtable_stage2_map().

Granularity changes that dirty logging forces at fault time (collapse
of pages into a block when logging stops, block splits when it starts)
consume that budget in ways that today only surface under a running
guest on arm64 hardware. Pin the walker allocation contract down at
unit level instead: a fresh page mapping must succeed with a stocked
cache and fail cleanly with ENOMEM on an empty one, and coalescing
pages back into a block must consume no cache pages at all.

All map calls pass KVM_PGTABLE_WALK_SKIP_BBM_TLBI and SKIP_CMO since
no hardware walker can ever observe the tables under test.

Run with:

  tools/testing/kunit/kunit.py run --arch=arm64 'kvm-stage2-pgtable.*'

Assisted-by: Claude:fable-5 # Told me about this, also helped with writing
Signed-off-by: Bradley Morgan <include@grrlz.net>
---
Hey, I tested these tests, they work, Feel free to review in your own time! 
This series was inspired by Fuads selftests [1]

[1] https://lore.kernel.org/all/20260717130317.1953574-8-fuad.tabba@linux.dev/

 arch/arm64/kvm/Kconfig        |  11 ++
 arch/arm64/kvm/Makefile       |   2 +
 arch/arm64/kvm/pgtable_test.c | 252 ++++++++++++++++++++++++++++++++++
 3 files changed, 265 insertions(+)
 create mode 100644 arch/arm64/kvm/pgtable_test.c

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 449154f9a485..07d681c886ad 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -44,6 +44,17 @@ menuconfig KVM
 
 if KVM
 
+config KVM_PGTABLE_KUNIT_TEST
+	bool "KUnit tests for the stage 2 page table walker" if !KUNIT_ALL_TESTS
+	depends on KUNIT=y
+	default KUNIT_ALL_TESTS
+	help
+	  Say Y here to run unit tests for the stage 2 page table walker
+	  in hyp/pgtable.c against a mock allocator, covering how map and
+	  collapse operations consume the fault handler memcache.
+
+	  If unsure, say N.
+
 config PTDUMP_STAGE2_DEBUGFS
 	bool "Present the stage-2 pagetables to debugfs"
 	depends on DEBUG_KERNEL
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 59612d2f277c..d4b506e3389b 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -32,6 +32,8 @@ kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
 
 kvm-$(CONFIG_NVHE_EL2_TRACING) += hyp_trace.o
 
+kvm-$(CONFIG_KVM_PGTABLE_KUNIT_TEST) += pgtable_test.o
+
 always-y := hyp_constants.h hyp-constants.s
 
 define rule_gen_hyp_constants
diff --git a/arch/arm64/kvm/pgtable_test.c b/arch/arm64/kvm/pgtable_test.c
new file mode 100644
index 000000000000..f2585a646c07
--- /dev/null
+++ b/arch/arm64/kvm/pgtable_test.c
@@ -0,0 +1,252 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KUnit tests for the KVM stage 2 page table walker (hyp/pgtable.c).
+ *
+ * The walker takes all of its dependencies through kvm_pgtable_mm_ops,
+ * so these tests plug in a mock allocator with a bounded page budget
+ * and assert exactly how map and collapse operations consume it. A
+ * fault path that fails to stage enough memory for a stage 2 update
+ * shows up here as a clean ENOMEM at unit level, rather than as a
+ * WARN or worse under a running guest on arm64 hardware.
+ *
+ * All map calls pass KVM_PGTABLE_WALK_SKIP_BBM_TLBI and SKIP_CMO
+ * since no hardware walker can ever observe these tables.
+ */
+#include <kunit/test.h>
+
+#include <linux/kvm_host.h>
+#include <linux/sizes.h>
+
+#include <asm/cpufeature.h>
+#include <asm/kvm_pgtable.h>
+#include <asm/sysreg.h>
+
+#define TEST_PHYS_SHIFT		40
+#define TEST_IPA		SZ_1G
+/* Never dereferenced: CMOs are skipped and leaf PAs are never followed. */
+#define TEST_PA			(4UL * SZ_1G)
+#define TEST_WALK_FLAGS		(KVM_PGTABLE_WALK_SKIP_BBM_TLBI | \
+				 KVM_PGTABLE_WALK_SKIP_CMO)
+
+/* Stands in for the fault handler memcache: a bounded page budget. */
+struct test_memcache {
+	int avail;
+	int allocated;
+};
+
+static void *test_zalloc_page(void *arg)
+{
+	struct test_memcache *mc = arg;
+
+	if (!mc || mc->avail <= 0)
+		return NULL;
+
+	mc->avail--;
+	mc->allocated++;
+	return (void *)get_zeroed_page(GFP_KERNEL);
+}
+
+static void *test_zalloc_pages_exact(size_t size)
+{
+	return alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO);
+}
+
+static void test_free_pages_exact(void *addr, size_t size)
+{
+	free_pages_exact(addr, size);
+}
+
+static void test_get_page(void *addr)
+{
+	get_page(virt_to_page(addr));
+}
+
+static void test_put_page(void *addr)
+{
+	put_page(virt_to_page(addr));
+}
+
+static int test_page_count(void *addr)
+{
+	return page_count(virt_to_page(addr));
+}
+
+static void *test_phys_to_virt(phys_addr_t phys)
+{
+	return __va(phys);
+}
+
+static phys_addr_t test_virt_to_phys(void *addr)
+{
+	return __pa(addr);
+}
+
+static void test_cmo_nop(void *addr, size_t size)
+{
+}
+
+static struct kvm_pgtable_mm_ops test_mm_ops;
+
+static void test_free_unlinked_table(void *addr, s8 level)
+{
+	kvm_pgtable_stage2_free_unlinked(&test_mm_ops, addr, level);
+}
+
+static struct kvm_pgtable_mm_ops test_mm_ops = {
+	.zalloc_page		= test_zalloc_page,
+	.zalloc_pages_exact	= test_zalloc_pages_exact,
+	.free_pages_exact	= test_free_pages_exact,
+	.free_unlinked_table	= test_free_unlinked_table,
+	.get_page		= test_get_page,
+	.put_page		= test_put_page,
+	.page_count		= test_page_count,
+	.phys_to_virt		= test_phys_to_virt,
+	.virt_to_phys		= test_virt_to_phys,
+	.dcache_clean_inval_poc	= test_cmo_nop,
+	.icache_inval_pou	= test_cmo_nop,
+};
+
+struct pgtable_test_ctx {
+	struct kvm *kvm;
+	struct kvm_pgtable pgt;
+	struct test_memcache mc;
+};
+
+static void pgtable_test_init_ctx(struct kunit *test,
+				  struct pgtable_test_ctx *ctx)
+{
+	u64 mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
+	u64 mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	struct kvm_s2_mmu *mmu;
+
+	if (PAGE_SIZE != SZ_4K)
+		kunit_skip(test, "test expects 4K pages");
+
+	ctx->kvm = kunit_kzalloc(test, sizeof(*ctx->kvm), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->kvm);
+
+	mmu = &ctx->kvm->arch.mmu;
+	mmu->arch = &ctx->kvm->arch;
+	mmu->vtcr = kvm_get_vtcr(mmfr0, mmfr1, TEST_PHYS_SHIFT);
+
+	KUNIT_ASSERT_EQ(test,
+			kvm_pgtable_stage2_init(&ctx->pgt, mmu, &test_mm_ops),
+			0);
+}
+
+/* Table pages needed to take one page mapping from the PGD to a leaf. */
+static int pgtable_test_max_tables(struct pgtable_test_ctx *ctx)
+{
+	return KVM_PGTABLE_LAST_LEVEL - ctx->pgt.start_level;
+}
+
+static void stage2_map_page_stocked_memcache(struct kunit *test)
+{
+	struct pgtable_test_ctx ctx = {};
+	kvm_pte_t pte = 0;
+	s8 level = 0;
+	int ret;
+
+	pgtable_test_init_ctx(test, &ctx);
+
+	ctx.mc.avail = pgtable_test_max_tables(&ctx);
+	ret = kvm_pgtable_stage2_map(&ctx.pgt, TEST_IPA, PAGE_SIZE, TEST_PA,
+				     KVM_PGTABLE_PROT_RW, &ctx.mc,
+				     TEST_WALK_FLAGS);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_GT(test, ctx.mc.allocated, 0);
+
+	KUNIT_EXPECT_EQ(test,
+			kvm_pgtable_get_leaf(&ctx.pgt, TEST_IPA, &pte, &level),
+			0);
+	KUNIT_EXPECT_TRUE(test, kvm_pte_valid(pte));
+	KUNIT_EXPECT_EQ(test, level, (s8)KVM_PGTABLE_LAST_LEVEL);
+	KUNIT_EXPECT_EQ(test,
+			kvm_pgtable_stage2_pte_prot(pte) & KVM_PGTABLE_PROT_RW,
+			KVM_PGTABLE_PROT_RW);
+
+	kvm_pgtable_stage2_destroy(&ctx.pgt);
+}
+
+static void stage2_map_page_empty_memcache(struct kunit *test)
+{
+	struct pgtable_test_ctx ctx = {};
+	int ret;
+
+	pgtable_test_init_ctx(test, &ctx);
+
+	/*
+	 * A fault path that reaches the walker without staging memory
+	 * must fail cleanly instead of installing a partial mapping.
+	 */
+	ctx.mc.avail = 0;
+	ret = kvm_pgtable_stage2_map(&ctx.pgt, TEST_IPA, PAGE_SIZE, TEST_PA,
+				     KVM_PGTABLE_PROT_RW, &ctx.mc,
+				     TEST_WALK_FLAGS);
+	KUNIT_EXPECT_EQ(test, ret, -ENOMEM);
+	KUNIT_EXPECT_EQ(test, ctx.mc.allocated, 0);
+
+	kvm_pgtable_stage2_destroy(&ctx.pgt);
+}
+
+static void stage2_collapse_pages_into_block(struct kunit *test)
+{
+	struct pgtable_test_ctx ctx = {};
+	int ret, before, i;
+	kvm_pte_t pte = 0;
+	s8 level = 0;
+	u64 off;
+
+	pgtable_test_init_ctx(test, &ctx);
+
+	/* Fault the whole block range in at page granularity. */
+	ctx.mc.avail = pgtable_test_max_tables(&ctx) + 1;
+	for (i = 0; i < SZ_2M / PAGE_SIZE; i++) {
+		off = (u64)i * PAGE_SIZE;
+		ret = kvm_pgtable_stage2_map(&ctx.pgt, TEST_IPA + off,
+					     PAGE_SIZE, TEST_PA + off,
+					     KVM_PGTABLE_PROT_RW, &ctx.mc,
+					     TEST_WALK_FLAGS);
+		KUNIT_ASSERT_EQ(test, ret, 0);
+	}
+
+	KUNIT_ASSERT_EQ(test,
+			kvm_pgtable_get_leaf(&ctx.pgt, TEST_IPA, &pte, &level),
+			0);
+	KUNIT_ASSERT_EQ(test, level, (s8)KVM_PGTABLE_LAST_LEVEL);
+
+	/*
+	 * Coalescing the pages back into a block replaces a table with
+	 * a leaf, so it must consume nothing from the memcache. This is
+	 * the transition that disabling dirty logging forces at fault
+	 * time.
+	 */
+	before = ctx.mc.avail;
+	ret = kvm_pgtable_stage2_map(&ctx.pgt, TEST_IPA, SZ_2M, TEST_PA,
+				     KVM_PGTABLE_PROT_RW, &ctx.mc,
+				     TEST_WALK_FLAGS);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, ctx.mc.avail, before);
+
+	KUNIT_EXPECT_EQ(test,
+			kvm_pgtable_get_leaf(&ctx.pgt, TEST_IPA, &pte, &level),
+			0);
+	KUNIT_EXPECT_TRUE(test, kvm_pte_valid(pte));
+	KUNIT_EXPECT_EQ(test, level, (s8)(KVM_PGTABLE_LAST_LEVEL - 1));
+
+	kvm_pgtable_stage2_destroy(&ctx.pgt);
+}
+
+static struct kunit_case stage2_pgtable_test_cases[] = {
+	KUNIT_CASE(stage2_map_page_stocked_memcache),
+	KUNIT_CASE(stage2_map_page_empty_memcache),
+	KUNIT_CASE(stage2_collapse_pages_into_block),
+	{}
+};
+
+static struct kunit_suite stage2_pgtable_suite = {
+	.name = "kvm-stage2-pgtable",
+	.test_cases = stage2_pgtable_test_cases,
+};
+
+kunit_test_suite(stage2_pgtable_suite);
-- 
2.47.3

