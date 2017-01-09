From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 42/55] KVM: arm64: Implement nested Stage-2 page table walk logic
Date: Mon,  9 Jan 2017 01:24:38 -0500
Message-ID: <1483943091-1364-43-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 152EB4027C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z6NW+qEXqJrE for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:47 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3CAB040187
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:44 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q9vA018089
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:25 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id D006187
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:25 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id AEB227E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:25 -0500 (EST)
Received: from mail-qk0-f197.google.com (mail-qk0-f197.google.com
 [209.85.220.197])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QP2d042859
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:25 -0500
Received: by mail-qk0-f197.google.com with SMTP id a16so37636891qkc.6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:25 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Based on the pseudo-code in the ARM ARM, implement a stage 2 software
page table walker.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/include/asm/kvm_mmu.h   |  11 ++
 arch/arm64/include/asm/kvm_arm.h |   1 +
 arch/arm64/include/asm/kvm_mmu.h |  13 +++
 arch/arm64/kvm/mmu-nested.c      | 223 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 248 insertions(+)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index ae3aa39..ab41a10 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -230,6 +230,17 @@ static inline unsigned int kvm_get_vmid_bits(void)
 	return 8;
 }
 
+struct kvm_s2_trans {
+	phys_addr_t output;
+	phys_addr_t block_size;
+};
+
+static inline int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
+				     struct kvm_s2_trans *result)
+{
+	return 0;
+}
+
 static inline void kvm_nested_s2_unmap(struct kvm_vcpu *vcpu) { }
 static inline int kvm_nested_s2_init(struct kvm_vcpu *vcpu) { return 0; }
 static inline void kvm_nested_s2_teardown(struct kvm_vcpu *vcpu) { }
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index feded61..f9addf3 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -103,6 +103,7 @@
 #define VTCR_EL2_RES1		(1 << 31)
 #define VTCR_EL2_HD		(1 << 22)
 #define VTCR_EL2_HA		(1 << 21)
+#define VTCR_EL2_PS_SHIFT	TCR_EL2_PS_SHIFT
 #define VTCR_EL2_PS_MASK	TCR_EL2_PS_MASK
 #define VTCR_EL2_TG0_MASK	TCR_TG0_MASK
 #define VTCR_EL2_TG0_4K		TCR_TG0_4K
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e4d5d54..bf94f0c 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -324,10 +324,17 @@ static inline unsigned int kvm_get_vmid_bits(void)
 	return (cpuid_feature_extract_unsigned_field(reg, ID_AA64MMFR1_VMIDBITS_SHIFT) == 2) ? 16 : 8;
 }
 
+struct kvm_s2_trans {
+	phys_addr_t output;
+	phys_addr_t block_size;
+};
+
 #ifdef CONFIG_KVM_ARM_NESTED_HYP
 struct kvm_nested_s2_mmu *get_nested_mmu(struct kvm_vcpu *vcpu, u64 vttbr);
 struct kvm_s2_mmu *vcpu_get_active_s2_mmu(struct kvm_vcpu *vcpu);
 bool handle_vttbr_update(struct kvm_vcpu *vcpu, u64 vttbr);
+int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
+		       struct kvm_s2_trans *result);
 void kvm_nested_s2_unmap(struct kvm_vcpu *vcpu);
 int kvm_nested_s2_init(struct kvm_vcpu *vcpu);
 void kvm_nested_s2_teardown(struct kvm_vcpu *vcpu);
@@ -350,6 +357,12 @@ static inline bool handle_vttbr_update(struct kvm_vcpu *vcpu, u64 vttbr)
 	return false;
 }
 
+static inline int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
+				     struct kvm_s2_trans *result)
+{
+	return 0;
+}
+
 static inline void kvm_nested_s2_unmap(struct kvm_vcpu *vcpu) { }
 static inline int kvm_nested_s2_init(struct kvm_vcpu *vcpu) { return 0; }
 static inline void kvm_nested_s2_teardown(struct kvm_vcpu *vcpu) { }
diff --git a/arch/arm64/kvm/mmu-nested.c b/arch/arm64/kvm/mmu-nested.c
index b22b78c..a2fab41 100644
--- a/arch/arm64/kvm/mmu-nested.c
+++ b/arch/arm64/kvm/mmu-nested.c
@@ -23,6 +23,229 @@
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_nested.h>
 
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
+	u64 parange = read_sysreg(id_aa64mmfr0_el1) & 7;
+
+	return ps_to_output_size(parange);
+}
+
+static int vcpu_inject_s2_trans_fault(struct kvm_vcpu *vcpu, gpa_t ipa,
+				      int level)
+{
+	/* TODO: Implement */
+	return -EFAULT;
+}
+
+static int vcpu_inject_s2_addr_sz_fault(struct kvm_vcpu *vcpu, gpa_t ipa,
+					int level)
+{
+	/* TODO: Implement */
+	return -EFAULT;
+}
+
+static int vcpu_inject_s2_access_flag_fault(struct kvm_vcpu *vcpu, gpa_t ipa,
+					    int level)
+{
+	/* TODO: Implement */
+	return -EFAULT;
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
+	u64 vttbr = vcpu->arch.ctxt.el2_regs[VTTBR_EL2];
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
+	if (check_output_size(vcpu, wi, vttbr))
+		return vcpu_inject_s2_addr_sz_fault(vcpu, ipa, level);
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
+		/* Check for valid descriptor at this point */
+		if (!(desc & 1) || ((desc & 3) == 1 && level == 3))
+			return vcpu_inject_s2_trans_fault(vcpu, ipa, level);
+
+		/* We're at the final level or block translation level */
+		if ((desc & 3) == 1 || level == 3)
+			break;
+
+		if (check_output_size(vcpu, wi, desc))
+			return vcpu_inject_s2_addr_sz_fault(vcpu, ipa, level);
+
+		base_addr = desc & GENMASK_ULL(47, wi->pgshift);
+
+		level += 1;
+		addr_top = addr_bottom - 1;
+	}
+
+	if (level < first_block_level)
+		return vcpu_inject_s2_trans_fault(vcpu, ipa, level);
+
+	/* TODO: Consider checking contiguous bit setting */
+
+	if (check_output_size(vcpu, wi, desc))
+		return vcpu_inject_s2_addr_sz_fault(vcpu, ipa, level);
+
+	if (!(desc & BIT(10)))
+		return vcpu_inject_s2_access_flag_fault(vcpu, ipa, level);
+
+	/* Calculate and return the result */
+	paddr = (desc & GENMASK_ULL(47, addr_bottom)) |
+		(ipa & GENMASK_ULL(addr_bottom - 1, 0));
+	out->output = paddr;
+	out->block_size = 1UL << ((3 - level) * stride + wi->pgshift);
+	return 0;
+}
+
+int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
+		       struct kvm_s2_trans *result)
+{
+	u64 vtcr = vcpu->arch.ctxt.el2_regs[VTCR_EL2];
+	struct s2_walk_info wi;
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
+	/* TODO: Reversedescriptor if SCTLR_EL2.EE == 1 */
+
+	return walk_nested_s2_pgd(vcpu, gipa, &wi, result);
+}
 
 /* expects kvm->mmu_lock to be held */
 void kvm_nested_s2_all_vcpus_wp(struct kvm *kvm)
-- 
1.9.1
