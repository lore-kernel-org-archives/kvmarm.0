From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 11/31] KVM: arm64: Implement nested Stage-2 page table
 walk logic
Date: Mon,  2 Oct 2017 22:10:53 -0500
Message-ID: <1507000273-3735-9-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75B0949D29
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IijxKnyfRU9T for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:32 -0400 (EDT)
Received: from mail-it0-f44.google.com (mail-it0-f44.google.com
 [209.85.214.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD84340638
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:30 -0400 (EDT)
Received: by mail-it0-f44.google.com with SMTP id d192so7403403itd.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:11:50 -0700 (PDT)
In-Reply-To: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Based on the pseudo-code in the ARM ARM, implement a stage 2 software
page table walker.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---

Notes:
    v1-->v2:
    - Handled different endianness between the host and the guest hypervisor
    - Decoupled the stage-2 PTW from injecting exceptions. This will come in handy
      when we just want to walk the page table.
    - Added esr and upper_attr fields in kvm_s2_trans struct
    - Reworked pa_max() to have KVM_PHYS_SHIFT
    - Updated comment about the continuous bits

 arch/arm/include/asm/kvm_mmu.h   |  16 +++
 arch/arm64/include/asm/esr.h     |   1 +
 arch/arm64/include/asm/kvm_arm.h |   3 +
 arch/arm64/include/asm/kvm_mmu.h |  12 ++
 arch/arm64/kvm/mmu-nested.c      | 241 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 273 insertions(+)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index d3eafc5..5fab21a 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -221,6 +221,22 @@ static inline unsigned int kvm_get_vmid_bits(void)
 	return 8;
 }
 
+struct kvm_s2_trans {
+	phys_addr_t output;
+	phys_addr_t block_size;
+	bool writable;
+	bool readable;
+	int level;
+	u32 esr;
+	u64 upper_attr;
+};
+
+static inline int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
+				     struct kvm_s2_trans *result)
+{
+	return 0;
+}
+
 static inline void kvm_nested_s2_unmap(struct kvm_vcpu *vcpu) { }
 static inline void kvm_nested_s2_free(struct kvm *kvm) { }
 static inline void kvm_nested_s2_wp(struct kvm *kvm) { }
diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 210fde6..bc6610b 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -108,6 +108,7 @@
 #define ESR_ELx_CM 		(UL(1) << 8)
 
 /* ISS field definitions for exceptions taken in to Hyp */
+#define ESR_ELx_FSC_ADDRSZ	(0x00)
 #define ESR_ELx_CV		(UL(1) << 24)
 #define ESR_ELx_COND_SHIFT	(20)
 #define ESR_ELx_COND_MASK	(UL(0xF) << ESR_ELx_COND_SHIFT)
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index a1274b7..3993703 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -104,6 +104,7 @@
 #define VTCR_EL2_RES1		(1 << 31)
 #define VTCR_EL2_HD		(1 << 22)
 #define VTCR_EL2_HA		(1 << 21)
+#define VTCR_EL2_PS_SHIFT	TCR_EL2_PS_SHIFT
 #define VTCR_EL2_PS_MASK	TCR_EL2_PS_MASK
 #define VTCR_EL2_TG0_MASK	TCR_TG0_MASK
 #define VTCR_EL2_TG0_4K		TCR_TG0_4K
@@ -177,6 +178,8 @@
 #define VTTBR_VMID_SHIFT  (UL(48))
 #define VTTBR_VMID_MASK(size) (_AT(u64, (1 << size) - 1) << VTTBR_VMID_SHIFT)
 
+#define SCTLR_EE	(UL(1) << 25)
+
 /* Hyp System Trap Register */
 #define HSTR_EL2_T(x)	(1 << x)
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 7fc7a83..c4efcd5 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -322,9 +322,21 @@ static inline unsigned int kvm_get_vmid_bits(void)
 	return (cpuid_feature_extract_unsigned_field(reg, ID_AA64MMFR1_VMIDBITS_SHIFT) == 2) ? 16 : 8;
 }
 
+struct kvm_s2_trans {
+	phys_addr_t output;
+	phys_addr_t block_size;
+	bool writable;
+	bool readable;
+	int level;
+	u32 esr;
+	u64 upper_attr;
+};
+
 struct kvm_nested_s2_mmu *get_nested_mmu(struct kvm_vcpu *vcpu, u64 vttbr);
 struct kvm_s2_mmu *vcpu_get_active_s2_mmu(struct kvm_vcpu *vcpu);
 void update_nested_s2_mmu(struct kvm_vcpu *vcpu);
+int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
+		       struct kvm_s2_trans *result);
 void kvm_nested_s2_unmap(struct kvm_vcpu *vcpu);
 void kvm_nested_s2_free(struct kvm *kvm);
 void kvm_nested_s2_wp(struct kvm *kvm);
diff --git a/arch/arm64/kvm/mmu-nested.c b/arch/arm64/kvm/mmu-nested.c
index 3ee20f2..fb694b7 100644
--- a/arch/arm64/kvm/mmu-nested.c
+++ b/arch/arm64/kvm/mmu-nested.c
@@ -22,6 +22,247 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 
+struct s2_walk_info {
+	unsigned int pgshift;
+	unsigned int pgsize;
+	unsigned int ps;
+	unsigned int sl;
+	unsigned int t0sz;
+};
+
+static unsigned int ps_to_output_size(unsigned int ps)
+{
+	switch (ps) {
+	case 0: return 32;
+	case 1: return 36;
+	case 2: return 40;
+	case 3: return 42;
+	case 4: return 44;
+	case 5:
+	default:
+		return 48;
+	}
+}
+
+static unsigned int pa_max(void)
+{
+	 /* We always emulate a VM with maximum PA size of KVM_PHYS_SIZE. */
+	return KVM_PHYS_SHIFT;
+}
+
+static int esr_s2_fault(struct kvm_vcpu *vcpu, int level, u32 fsc)
+{
+	u32 esr;
+
+	esr = kvm_vcpu_get_hsr(vcpu) & ~ESR_ELx_FSC;
+	esr |= fsc;
+	esr |= level & 0x3;
+	return esr;
+}
+
+static int check_base_s2_limits(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
+				int level, int input_size, int stride)
+{
+	int start_size;
+
+	/* Check translation limits */
+	switch (wi->pgsize) {
+	case SZ_64K:
+		if (level == 0 || (level == 1 && pa_max() <= 42))
+			return -EFAULT;
+		break;
+	case SZ_16K:
+		if (level == 0 || (level == 1 && pa_max() <= 40))
+			return -EFAULT;
+		break;
+	case SZ_4K:
+		if (level < 0 || (level == 0 && pa_max() <= 42))
+			return -EFAULT;
+		break;
+	}
+
+	/* Check input size limits */
+	if (input_size > pa_max() &&
+	    (!vcpu_mode_is_32bit(vcpu) || input_size > 40))
+		return -EFAULT;
+
+	/* Check number of entries in starting level table */
+	start_size = input_size - ((3 - level) * stride + wi->pgshift);
+	if (start_size < 1 || start_size > stride + 4)
+		return -EFAULT;
+
+	return 0;
+}
+
+/* Check if output is within boundaries */
+static int check_output_size(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
+			     phys_addr_t output)
+{
+	unsigned int output_size = ps_to_output_size(wi->ps);
+
+	if (output_size > pa_max())
+		output_size = pa_max();
+
+	if (output_size != 48 && (output & GENMASK_ULL(47, output_size)))
+		return -1;
+
+	return 0;
+}
+
+/*
+ * This is essentially a C-version of the pseudo code from the ARM ARM
+ * AArch64.TranslationTableWalk  function.  I strongly recommend looking at
+ * that pseudocode in trying to understand this.
+ *
+ * Must be called with the kvm->srcy read lock held
+ */
+static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
+			      struct s2_walk_info *wi, struct kvm_s2_trans *out)
+{
+	u64 vttbr = vcpu->arch.ctxt.sys_regs[VTTBR_EL2];
+	int first_block_level, level, stride, input_size, base_lower_bound;
+	phys_addr_t base_addr;
+	unsigned int addr_top, addr_bottom;
+	u64 desc;  /* page table entry */
+	int ret;
+	phys_addr_t paddr;
+
+	switch (wi->pgsize) {
+	case SZ_64K:
+	case SZ_16K:
+		level = 3 - wi->sl;
+		first_block_level = 2;
+		break;
+	case SZ_4K:
+		level = 2 - wi->sl;
+		first_block_level = 1;
+		break;
+	default:
+		/* GCC is braindead */
+		WARN(1, "Page size is none of 4K, 16K or 64K");
+	}
+
+	stride = wi->pgshift - 3;
+	input_size = 64 - wi->t0sz;
+	if (input_size > 48 || input_size < 25)
+		return -EFAULT;
+
+	ret = check_base_s2_limits(vcpu, wi, level, input_size, stride);
+	if (WARN_ON(ret))
+		return ret;
+
+	if (check_output_size(vcpu, wi, vttbr)) {
+		out->esr = esr_s2_fault(vcpu, level, ESR_ELx_FSC_ADDRSZ);
+		return 1;
+	}
+
+	base_lower_bound = 3 + input_size - ((3 - level) * stride +
+			   wi->pgshift);
+	base_addr = vttbr & GENMASK_ULL(47, base_lower_bound);
+
+	addr_top = input_size - 1;
+
+	while (1) {
+		phys_addr_t index;
+
+		addr_bottom = (3 - level) * stride + wi->pgshift;
+		index = (ipa & GENMASK_ULL(addr_top, addr_bottom))
+			>> (addr_bottom - 3);
+
+		paddr = base_addr | index;
+		ret = kvm_read_guest(vcpu->kvm, paddr, &desc, sizeof(desc));
+		if (ret < 0)
+			return ret;
+
+		/*
+		 * Handle reversedescriptors if endianness differs between the
+		 * host and the guest hypervisor.
+		 */
+		if (vcpu_sys_reg(vcpu, SCTLR_EL2) & SCTLR_EE)
+			desc = be64_to_cpu(desc);
+		else
+			desc = le64_to_cpu(desc);
+
+		/* Check for valid descriptor at this point */
+		if (!(desc & 1) || ((desc & 3) == 1 && level == 3)) {
+			out->esr = esr_s2_fault(vcpu, level, ESR_ELx_FSC_FAULT);
+			return 1;
+		}
+
+		/* We're at the final level or block translation level */
+		if ((desc & 3) == 1 || level == 3)
+			break;
+
+		if (check_output_size(vcpu, wi, desc)) {
+			out->esr = esr_s2_fault(vcpu, level, ESR_ELx_FSC_ADDRSZ);
+			return 1;
+		}
+
+		base_addr = desc & GENMASK_ULL(47, wi->pgshift);
+
+		level += 1;
+		addr_top = addr_bottom - 1;
+	}
+
+	if (level < first_block_level) {
+		out->esr = esr_s2_fault(vcpu, level, ESR_ELx_FSC_FAULT);
+		return 1;
+	}
+
+	/*
+	 * We don't use the contiguous bit in the stage-2 ptes, so skip check
+	 * for misprogramming of the contiguous bit.
+	 */
+
+	if (check_output_size(vcpu, wi, desc)) {
+		out->esr = esr_s2_fault(vcpu, level, ESR_ELx_FSC_ADDRSZ);
+		return 1;
+	}
+
+	if (!(desc & BIT(10))) {
+		out->esr = esr_s2_fault(vcpu, level, ESR_ELx_FSC_ACCESS);
+		return 1;
+	}
+
+	/* Calculate and return the result */
+	paddr = (desc & GENMASK_ULL(47, addr_bottom)) |
+		(ipa & GENMASK_ULL(addr_bottom - 1, 0));
+	out->output = paddr;
+	out->block_size = 1UL << ((3 - level) * stride + wi->pgshift);
+	out->readable = desc & (0b01 << 6);
+	out->writable = desc & (0b10 << 6);
+	out->level = level;
+	out->upper_attr = desc & GENMASK_ULL(63, 52);
+	return 0;
+}
+
+int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
+		       struct kvm_s2_trans *result)
+{
+	u64 vtcr = vcpu->arch.ctxt.sys_regs[VTCR_EL2];
+	struct s2_walk_info wi;
+
+	if (!nested_virt_in_use(vcpu))
+		return 0;
+
+	wi.t0sz = vtcr & TCR_EL2_T0SZ_MASK;
+
+	switch (vtcr & VTCR_EL2_TG0_MASK) {
+	case VTCR_EL2_TG0_4K:
+		wi.pgshift = 12;	 break;
+	case VTCR_EL2_TG0_16K:
+		wi.pgshift = 14;	 break;
+	case VTCR_EL2_TG0_64K:
+	default:
+		wi.pgshift = 16;	 break;
+	}
+	wi.pgsize = 1UL << wi.pgshift;
+	wi.ps = (vtcr & VTCR_EL2_PS_MASK) >> VTCR_EL2_PS_SHIFT;
+	wi.sl = (vtcr & VTCR_EL2_SL0_MASK) >> VTCR_EL2_SL0_SHIFT;
+
+	return walk_nested_s2_pgd(vcpu, gipa, &wi, result);
+}
+
 /* expects kvm->mmu_lock to be held */
 void kvm_nested_s2_wp(struct kvm *kvm)
 {
-- 
1.9.1
