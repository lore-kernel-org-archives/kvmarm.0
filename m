Received: from esa9.hc1455-7.c3s2.iphmx.com (esa9.hc1455-7.c3s2.iphmx.com [139.138.36.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9184B237180
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 01:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778809772; cv=none; b=Y7xhJVx8NlglIgzgDNu+JM3cuv4dyuaKOMvqsaRMEs9l+kPflle79tXHfBphkT1Zciw11nZv1J/27fQcFsvPxA/3tbHaU2ZmtwVbITy/5nAaXDhi3cHdqUe4UNm69Szsd+sNlPAy54dMWd5z+qHwBaI1z7n9BKxYjJkP+Jhw/IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778809772; c=relaxed/simple;
	bh=j0dgi6mqkVZNV7ocMNHlFqrMjp1EX9ypNbxVmKH1VvM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=YvMXI+29g7s2htbPONTEYKA8n/eBrNn9FhkVAo5Vrep+KBMO3BpBmNvp9cBPeEHjZPzAP2qtI/IWUNzH43PLXqZPTnig7bti8p3eFwBiIlMTx/aB91ZQsKeEsgBqr++UhmEng5qyuI9bqs6+0OKaiXS5GbOVAa2wy0L7RTWGv8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=oPv3Ea5h; arc=none smtp.client-ip=139.138.36.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="oPv3Ea5h"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1778809770; x=1810345770;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:to:cc;
  bh=j0dgi6mqkVZNV7ocMNHlFqrMjp1EX9ypNbxVmKH1VvM=;
  b=oPv3Ea5hhOzRZC5IL61TSnxl1JUmZC1bfAl4lh1ZvDbgeAlYCkt86oF/
   BokGJftLblykHEkHgkeKAlnsulxEZg+PmbeOiLDz3hvClGinFoBTha90u
   se35wCK3yqY9D8AndBmqT+d6IYZQjYnyAJCQmMw1xyf3zj2e3rp5L1Blo
   Tao1vGN7m4piKpaRXNT/YrmCKat1nuh+mC6w7Wh6bx0zMGb+QQKB6b/pU
   TOLLGNT7ukeSUZVDIFw4csoiw9IBlPYxtMC1JQDt8cAx495a9pIWg4U5L
   9h2nj+VPwQ9B0zcACAGOqlCobGmx+te3T/Pv6xEJeWRRRi1k4F1RKaSqX
   A==;
X-CSE-ConnectionGUID: bWLGk9etSNafa5L3h2E+uA==
X-CSE-MsgGUID: kAavQ1B4SAO7pojDWcEoiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="227970617"
X-IronPort-AV: E=Sophos;i="6.23,235,1770562800"; 
   d="scan'208";a="227970617"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa9.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 10:48:19 +0900
Received: from az2uksmgm3.o.css.fujitsu.com (unknown [10.151.22.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id A512F1C01690
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 01:48:19 +0000 (UTC)
Received: from az2nlsmom1.o.css.fujitsu.com (az2nlsmom1.o.css.fujitsu.com [10.150.26.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm3.o.css.fujitsu.com (Postfix) with ESMTPS id 58A06C07360
	for <kvmarm@lists.linux.dev>; Fri, 15 May 2026 01:48:19 +0000 (UTC)
Received: from [127.0.1.1] (sm-x86-stp01.soft.fujitsu.com [10.124.178.20])
	by az2nlsmom1.o.css.fujitsu.com (Postfix) with ESMTP id E611082DDC6;
	Fri, 15 May 2026 01:48:13 +0000 (UTC)
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Date: Fri, 15 May 2026 10:48:05 +0900
Subject: [PATCH] Enable stage 2 translation in L2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260515-enable-s2-hello_nested-v1-1-41f3faca1a08@fujitsu.com>
X-B4-Tracking: v=1; b=H4sIAFR7BmoC/x3MQQqDMBBG4avIrDsQI2rrVUqRRH91IETJFBHEu
 xtcfov3TlIkgVJXnJSwi8oaM8pXQcPi4gyWMZussY2py5oRnQ9gtbwghLWP0D9G9lVjnMXH+3d
 LOd4SJjme8fd3XTf65LLxaAAAAA==
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>
X-Mailer: b4 0.13.0

IPA size and start level are configurable at build time.

Signed-off-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
---
Enable stage 2 translation in L2, but keep stage 1 remain off
as Wei Lin prefers. Types are changed accordingly due to the
recent selftest-wide changes.
---
 tools/testing/selftests/kvm/arm64/hello_nested.c   |  11 +-
 tools/testing/selftests/kvm/include/arm64/nested.h |  38 ++-
 tools/testing/selftests/kvm/lib/arm64/hyp-entry.S  |   5 +
 tools/testing/selftests/kvm/lib/arm64/nested.c     | 279 ++++++++++++++++++++-
 4 files changed, 322 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/hello_nested.c b/tools/testing/selftests/kvm/arm64/hello_nested.c
index 69f4d8e750e2..1ac045894b89 100644
--- a/tools/testing/selftests/kvm/arm64/hello_nested.c
+++ b/tools/testing/selftests/kvm/arm64/hello_nested.c
@@ -18,9 +18,9 @@
 /*
  * TPIDR_EL2 is used to store vcpu id, so save and restore it.
  */
-static vm_paddr_t ucall_translate_to_gpa(void *gva)
+static gpa_t ucall_translate_to_gpa(void *gva)
 {
-	vm_paddr_t gpa;
+	gpa_t gpa;
 	u64 vcpu_id = read_sysreg(tpidr_el2);
 
 	GUEST_SYNC2(XLATE2GPA, gva);
@@ -50,7 +50,7 @@ static void guest_code(void)
 	struct vcpu vcpu;
 	struct hyp_data hyp_data;
 	int ret;
-	vm_paddr_t l2_pc, l2_stack_top;
+	gpa_t l2_pc, l2_stack_top;
 	/* force 16-byte alignment for the stack pointer */
 	u8 l2_stack[L2STACKSZ] __attribute__((aligned(16)));
 	u64 arg1, arg2;
@@ -92,7 +92,7 @@ int main(void)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
-	vm_paddr_t gpa;
+	gpa_t gpa;
 
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_EL2));
 	vm = vm_create(1);
@@ -102,13 +102,14 @@ int main(void)
 	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
 	kvm_arch_vm_finalize_vcpus(vm);
 
+	prepare_hyp_state(vm, vcpu);
 	while (true) {
 		vcpu_run(vcpu);
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_SYNC:
 			if (uc.args[0] == XLATE2GPA) {
-				gpa = addr_gva2gpa(vm, (vm_vaddr_t)uc.args[1]);
+				gpa = addr_gva2gpa(vm, (gva_t)uc.args[1]);
 				vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TPIDR_EL2), gpa);
 			}
 			break;
diff --git a/tools/testing/selftests/kvm/include/arm64/nested.h b/tools/testing/selftests/kvm/include/arm64/nested.h
index b16a72488858..b4ccca3593db 100644
--- a/tools/testing/selftests/kvm/include/arm64/nested.h
+++ b/tools/testing/selftests/kvm/include/arm64/nested.h
@@ -18,14 +18,44 @@
 
 #include <asm/ptrace.h>
 #include "kvm_util.h"
+#include "processor.h"
 
 extern char hyp_vectors[];
 
+#ifdef CONFIG_ARM64_64K_PAGES
+
+#define VTCR_EL2_TGRAN                  64K
+#define VTCR_EL2_TGRAN_SL0_BASE         3UL
+
+#elif defined(CONFIG_ARM64_16K_PAGES)
+
+#define VTCR_EL2_TGRAN                  16K
+#define VTCR_EL2_TGRAN_SL0_BASE         3UL
+
+#else   /* 4K */
+
+#define VTCR_EL2_TGRAN                  4K
+#define VTCR_EL2_TGRAN_SL0_BASE         2UL
+
+#endif
+
+struct s2_config {
+	u64 granule;
+	u8 ia_bits;
+	u8 oa_bits;
+	u8 start_level;
+};
+
+u64 get_l1_vtcr(const struct s2_config *cfg);
+
+void nested_map(struct kvm_vm *vm, const struct s2_config *cfg, gpa_t guest_pgd, uint64_t nested_paddr, uint64_t paddr, uint64_t size);
+void nested_map_memslot(struct kvm_vm *vm, const struct s2_config *cfg, gpa_t guest_pgd, u32 memslot);
+
 enum vcpu_sysreg {
 	__INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
 
 	SP_EL1,
-
+	ESR_EL2,
 	NR_SYS_REGS
 };
 
@@ -47,12 +77,14 @@ struct hyp_data {
 };
 
 void prepare_hyp(void);
-void init_vcpu(struct vcpu *vcpu, vm_paddr_t l2_pc, vm_paddr_t l2_stack_top);
+void init_vcpu(struct vcpu *vcpu, gpa_t l2_pc, gpa_t l2_stack_top);
 int run_l2(struct vcpu *vcpu, struct hyp_data *hyp_data);
 
 u64 do_hvc(u64 action, u64 arg1, u64 arg2);
+u64 vcpu_get_esr_el2(struct vcpu *vcpu);
+
 u64 __guest_enter(struct vcpu *vcpu, struct cpu_context *hyp_context);
-void __hyp_exception(u64 type);
+void __hyp_exception(u64 type, u64 esr, u64 elr, u64 far, u64 hpfar, u64 spsr);
 
 void __sysreg_save_el1_state(struct cpu_context *ctxt);
 void __sysreg_restore_el1_state(struct cpu_context *ctxt);
diff --git a/tools/testing/selftests/kvm/lib/arm64/hyp-entry.S b/tools/testing/selftests/kvm/lib/arm64/hyp-entry.S
index 6341f6e05c90..fcf7bb303b77 100644
--- a/tools/testing/selftests/kvm/lib/arm64/hyp-entry.S
+++ b/tools/testing/selftests/kvm/lib/arm64/hyp-entry.S
@@ -30,6 +30,11 @@ el1_error:
 	b	__guest_exit
 
 el2_sync:
+	mrs	x1, esr_el2
+	mrs	x2, elr_el2
+	mrs	x3, far_el2
+	mrs	x4, hpfar_el2
+	mrs	x5, spsr_el2
 	mov	x0, #ARM_EXCEPTION_EL2_TRAP
 	b	__hyp_exception
 
diff --git a/tools/testing/selftests/kvm/lib/arm64/nested.c b/tools/testing/selftests/kvm/lib/arm64/nested.c
index b30d20b101c4..104c98d29eb9 100644
--- a/tools/testing/selftests/kvm/lib/arm64/nested.c
+++ b/tools/testing/selftests/kvm/lib/arm64/nested.c
@@ -7,15 +7,269 @@
 #include "processor.h"
 #include "test_util.h"
 #include <asm/sysreg.h>
+#include <linux/sizes.h>
+
+static const struct s2_config default_s2_cfg = {
+        .granule        = SZ_4K,
+        .ia_bits        = 40,
+        .oa_bits        = 40,
+        .start_level    = 0,
+};
+
+static u64 s2_alloc_page_table(struct kvm_vm *vm, const struct s2_config *cfg)
+{
+        u64 nr_pages = cfg->granule >> vm->page_shift;
+
+        TEST_ASSERT(!(cfg->granule & (vm->page_size - 1)),
+                    "S2 granule 0x%lx smaller/not aligned to VM page size 0x%x",
+                    cfg->granule, vm->page_size);
+
+        return vm_phy_pages_alloc(vm, nr_pages,
+                                  KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+                                  vm->memslots[MEM_REGION_PT]);
+}
 
 void prepare_hyp(void)
 {
-	write_sysreg(HCR_EL2_E2H | HCR_EL2_RW, hcr_el2);
+	write_sysreg(HCR_EL2_E2H | HCR_EL2_RW | HCR_EL2_VM, hcr_el2);
 	write_sysreg(hyp_vectors, vbar_el2);
 	isb();
 }
 
-void init_vcpu(struct vcpu *vcpu, vm_paddr_t l2_pc, vm_paddr_t l2_stack_top)
+static unsigned int s2_granule_shift(const struct s2_config *cfg)
+{
+	switch (cfg->granule) {
+	case SZ_4K:
+		return 12;
+	case SZ_16K:
+		return 14;
+	case SZ_64K:
+		return 16;
+	default:
+		TEST_FAIL("Unsupported stage-2 granule %u", cfg->granule);
+	}
+}
+
+static unsigned int s2_level_stride(const struct s2_config *cfg)
+{
+	return s2_granule_shift(cfg) - 3;
+}
+
+static unsigned int s2_ptrs_per_table(const struct s2_config *cfg)
+{
+	return 1U << s2_level_stride(cfg);
+}
+
+static u64 s2_index_mask(const struct s2_config *cfg)
+{
+	return s2_ptrs_per_table(cfg) - 1;
+}
+
+static unsigned int s2_last_level(const struct s2_config *cfg)
+{
+	return 3;
+}
+
+static unsigned int s2_level_shift(const struct s2_config *cfg,
+				   unsigned int level)
+{
+	return s2_granule_shift(cfg) +
+	       (s2_last_level(cfg) - level) * s2_level_stride(cfg);
+}
+
+static u64 s2_table_mask(const struct s2_config *cfg)
+{
+	return GENMASK_ULL(cfg->ia_bits - 1, s2_granule_shift(cfg));
+}
+
+static u64 s2_output_mask(const struct s2_config *cfg)
+{
+	return GENMASK_ULL(cfg->oa_bits - 1, s2_granule_shift(cfg));
+}
+
+static u64 s2_desc_table(u64 paddr, const struct s2_config *cfg)
+{
+	return (paddr & s2_table_mask(cfg)) | 0x3;
+}
+
+#define S2_MEMATTR_NORMAL_WB		0xfUL
+#define S2_MEMATTR_SHIFT		2
+
+#define S2_S2AP_R			BIT(6)
+#define S2_S2AP_W			BIT(7)
+
+#define S2_SH_INNER			(3UL << 8)
+
+
+static u64 s2_desc_page(u64 paddr, u64 flags, const struct s2_config *cfg)
+{
+	u64 desc;
+
+	desc = paddr & s2_output_mask(cfg);
+
+	/* Stage-2 lower attrs */
+	desc |= S2_MEMATTR_NORMAL_WB << S2_MEMATTR_SHIFT;
+	desc |= S2_S2AP_R | S2_S2AP_W;
+	desc |= S2_SH_INNER;
+	desc |= PTE_AF;
+
+	/* L3 page descriptor: bits[1:0] = 0b11 */
+	desc |= PTE_TYPE_PAGE;
+	desc |= PTE_VALID;
+
+	return desc;
+}
+
+static inline int ipa_bits_to_ps(unsigned int ipa_bits)
+{
+	switch (ipa_bits) {
+	case 32:
+		return 0b000;
+	case 36:
+		return 0b001;
+	case 40:
+		return 0b010;
+	case 42:
+		return 0b011;
+	case 44:
+		return 0b100;
+	case 48:
+		return 0b101;
+	case 52:
+		return 0b110;
+	default:
+		return -EINVAL;
+	}
+}
+
+u64 get_l1_vtcr(const struct s2_config *cfg)
+{
+	if (!cfg)
+		cfg = &default_s2_cfg;
+
+	return  FIELD_PREP(VTCR_EL2_PS, ipa_bits_to_ps(cfg->ia_bits)) |
+		FIELD_PREP(VTCR_EL2_TG0, VTCR_EL2_TG0_4K) |
+		FIELD_PREP(VTCR_EL2_ORGN0_MASK, VTCR_EL2_ORGN0_WBWA) |
+		FIELD_PREP(VTCR_EL2_IRGN0_MASK, VTCR_EL2_IRGN0_WBWA) |
+		FIELD_PREP(VTCR_EL2_SH0_MASK, VTCR_EL2_SH0_INNER) |
+		FIELD_PREP(VTCR_EL2_SL0, VTCR_EL2_TGRAN_SL0_BASE - cfg->start_level) |
+		FIELD_PREP(VTCR_EL2_T0SZ_MASK, 64 - cfg->ia_bits);
+}
+
+void prepare_hyp_state(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+        const struct s2_config *cfg = &default_s2_cfg;
+        u64 guest_pgd;
+
+        vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_VTCR_EL2), get_l1_vtcr(cfg));
+
+        guest_pgd = s2_alloc_page_table(vm, cfg);
+        nested_map_memslot(vm, cfg, guest_pgd, 0);
+
+	pr_debug("cfg=%p ia_bits=%u oa_bits=%u granule=%u\n",
+	cfg, cfg->ia_bits, cfg->oa_bits, cfg->granule);
+
+        vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_VTTBR_EL2), guest_pgd);
+}
+
+static void __nested_pg_map(struct kvm_vm *vm,
+			    const struct s2_config *cfg,
+			    u64 guest_pgd,
+			    u64 nested_paddr,
+			    u64 paddr,
+			    u64 flags)
+{
+	u64 granule = 1ULL << s2_granule_shift(cfg);
+	u64 *ptep;
+	unsigned int level;
+
+	TEST_ASSERT(!(nested_paddr & (granule - 1)),
+		    "L2 IPA not granule aligned: 0x%lx granule 0x%lx",
+		    nested_paddr, granule);
+
+	TEST_ASSERT(!(paddr & (granule - 1)),
+		    "PA not granule aligned: 0x%lx granule 0x%lx",
+		    paddr, granule);
+
+	ptep = addr_gpa2hva(vm, guest_pgd);
+
+	for (level = cfg->start_level; level < s2_last_level(cfg); level++) {
+		u64 idx;
+		u64 desc;
+
+		idx = (nested_paddr >> s2_level_shift(cfg, level)) &
+		      s2_index_mask(cfg);
+
+		ptep += idx;
+		desc = *ptep;
+
+		if (!desc) {
+			u64 table = s2_alloc_page_table(vm, cfg);
+
+			desc = s2_desc_table(table, cfg);
+			*ptep = desc;
+		}
+
+		ptep = addr_gpa2hva(vm, desc & s2_table_mask(cfg));
+	}
+
+	ptep += (nested_paddr >> s2_granule_shift(cfg)) & s2_index_mask(cfg);
+	*ptep = s2_desc_page(paddr, flags, cfg);
+}
+
+void nested_map(struct kvm_vm *vm,
+		const struct s2_config *cfg,
+		gpa_t guest_pgd,
+		u64 nested_paddr,
+		u64 paddr,
+		u64 size)
+{
+	u64 granule;
+	size_t npages;
+
+	if (!cfg)
+		cfg = &default_s2_cfg;
+
+	granule = 1ULL << s2_granule_shift(cfg);
+
+	TEST_ASSERT(!(size & (granule - 1)),
+		    "Mapping size 0x%lx not aligned to granule 0x%lx",
+		    size, granule);
+
+	TEST_ASSERT(nested_paddr + size > nested_paddr, "IPA overflow");
+	TEST_ASSERT(paddr + size > paddr, "PA overflow");
+
+	npages = size / granule;
+
+	while (npages--) {
+		__nested_pg_map(vm, cfg, guest_pgd, nested_paddr, paddr,
+				MT_NORMAL);
+
+		nested_paddr += granule;
+		paddr += granule;
+	}
+}
+
+void nested_map_memslot(struct kvm_vm *vm,
+			const struct s2_config *cfg,
+			gpa_t guest_pgd,
+			u32 memslot)
+{
+	struct userspace_mem_region *region;
+	u64 gpa, end;
+
+	region = memslot2region(vm, memslot);
+
+	gpa = region->region.guest_phys_addr;
+	end = gpa + region->region.memory_size;
+
+	pr_debug("nested S2 map slot %u: GPA %#lx-%#lx\n", memslot, gpa, end);
+
+	for (; gpa < end; gpa += cfg->granule)
+		nested_map(vm, cfg, guest_pgd, gpa, gpa, cfg->granule);
+}
+
+void init_vcpu(struct vcpu *vcpu, gpa_t l2_pc, gpa_t l2_stack_top)
 {
 	memset(vcpu, 0, sizeof(*vcpu));
 	vcpu->context.regs.pc = l2_pc;
@@ -46,13 +300,32 @@ int run_l2(struct vcpu *vcpu, struct hyp_data *hyp_data)
 
 	vcpu->context.regs.pc = read_sysreg(elr_el2);
 	vcpu->context.regs.pstate = read_sysreg(spsr_el2);
+	vcpu->context.sys_regs[ESR_EL2] = read_sysreg(esr_el2);
 
 	__sysreg_save_el1_state(&vcpu->context);
 
 	return ret;
 }
 
-void __hyp_exception(u64 type)
+u64 vcpu_get_esr_el2(struct vcpu *vcpu)
 {
+	return vcpu->context.sys_regs[ESR_EL2];
+
+}
+
+void __hyp_exception(u64 type, u64 esr, u64 elr, u64 far, u64 hpfar, u64 spsr)
+{
+	u64 ec = esr >> 26;
+	u64 iss = esr & GENMASK_ULL(24, 0);
+	u64 ipa = ((hpfar & GENMASK_ULL(39, 4)) << 8) |
+		  (far & GENMASK_ULL(11, 0));
+
+	GUEST_FAIL("Unexpected hyp exception: type=%lu "
+		   "ESR_EL2=%#lx EC=%#lx ISS=%#lx "
+		   "ELR_EL2=%#lx FAR_EL2=%#lx HPFAR_EL2=%#lx IPA=%#lx "
+		   "SPSR_EL2=%#lx",
+		   type, esr, ec, iss, elr, far, hpfar, ipa, spsr);
 	GUEST_FAIL("Unexpected hyp exception! type: %lx\n", type);
+
+
 }

---
base-commit: eb656a0272c639d43be7a9bdd1c5f31eff3afe86
change-id: 20260515-enable-s2-hello_nested-b360a2e9bb87

Best regards,
-- 
Itaru Kitayama <itaru.kitayama@fujitsu.com>

