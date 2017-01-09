From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 40/55] KVM: arm/arm64: Handle vttbr_el2 write operation from the
 guest hypervisor
Date: Mon,  9 Jan 2017 01:24:36 -0500
Message-ID: <1483943091-1364-41-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84E6A404E7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uk0UsATFJoBz for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:41 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 888AD4019A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:41 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PWAO017317
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:23 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 2A13882
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:23 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id 1025182
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:23 -0500 (EST)
Received: from mail-qt0-f198.google.com (mail-qt0-f198.google.com
 [209.85.216.198])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QMue057645
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:22 -0500
Received: by mail-qt0-f198.google.com with SMTP id a29so74191379qtb.6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:22 -0800 (PST)
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

Each nested VM is supposed to have a mmu (i.e. shadow stage-2 page
table), and we create it when the guest hypervisor writes to vttbr_el2
with a new vmid.

In case the guest hypervisor writes to vttbr_el2 with existing vmid, we
check if the base address is changed. If so, then what we have in the
shadow page table is not valid any more. So ummap it.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/include/asm/kvm_host.h   |  1 +
 arch/arm/kvm/arm.c                |  1 +
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/include/asm/kvm_mmu.h  |  6 ++++
 arch/arm64/kvm/mmu-nested.c       | 71 +++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c         | 15 ++++++++-
 6 files changed, 94 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index fbde48d..ebf2810 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -84,6 +84,7 @@ struct kvm_arch {
 
 	/* Never used on arm but added to be compatible with arm64 */
 	struct list_head nested_mmu_list;
+	spinlock_t mmu_list_lock;
 
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 147df97..6fa5754 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -147,6 +147,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.mmu.vmid.vmid_gen = 0;
 	kvm->arch.mmu.el2_vmid.vmid_gen = 0;
 	INIT_LIST_HEAD(&kvm->arch.nested_mmu_list);
+	spin_lock_init(&kvm->arch.mmu_list_lock);
 
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->arch.max_vcpus = vgic_present ?
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 23e2267..52eea76 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -99,6 +99,7 @@ struct kvm_arch {
 
 	/* Stage 2 shadow paging contexts for nested L2 VM */
 	struct list_head nested_mmu_list;
+	spinlock_t mmu_list_lock;
 };
 
 #define KVM_NR_MEM_OBJS     40
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index d1ef650..fdc9327 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -327,6 +327,7 @@ static inline unsigned int kvm_get_vmid_bits(void)
 #ifdef CONFIG_KVM_ARM_NESTED_HYP
 struct kvm_nested_s2_mmu *get_nested_mmu(struct kvm_vcpu *vcpu, u64 vttbr);
 struct kvm_s2_mmu *vcpu_get_active_s2_mmu(struct kvm_vcpu *vcpu);
+bool handle_vttbr_update(struct kvm_vcpu *vcpu, u64 vttbr);
 #else
 static inline struct kvm_nested_s2_mmu *get_nested_mmu(struct kvm_vcpu *vcpu,
 						       u64 vttbr)
@@ -337,6 +338,11 @@ static inline struct kvm_s2_mmu *vcpu_get_active_s2_mmu(struct kvm_vcpu *vcpu)
 {
 	return &vcpu->kvm->arch.mmu;
 }
+
+static inline bool handle_vttbr_update(struct kvm_vcpu *vcpu, u64 vttbr)
+{
+	return false;
+}
 #endif
 
 static inline u64 kvm_get_vttbr(struct kvm_s2_vmid *vmid,
diff --git a/arch/arm64/kvm/mmu-nested.c b/arch/arm64/kvm/mmu-nested.c
index d52078f..0811d94 100644
--- a/arch/arm64/kvm/mmu-nested.c
+++ b/arch/arm64/kvm/mmu-nested.c
@@ -53,3 +53,74 @@ struct kvm_s2_mmu *vcpu_get_active_s2_mmu(struct kvm_vcpu *vcpu)
 
 	return &nested_mmu->mmu;
 }
+
+static struct kvm_nested_s2_mmu *create_nested_mmu(struct kvm_vcpu *vcpu,
+						   u64 vttbr)
+{
+	struct kvm_nested_s2_mmu *nested_mmu, *tmp_mmu;
+	struct list_head *nested_mmu_list = &vcpu->kvm->arch.nested_mmu_list;
+	bool need_free = false;
+	int ret;
+
+	nested_mmu = kzalloc(sizeof(struct kvm_nested_s2_mmu), GFP_KERNEL);
+	if (!nested_mmu)
+		return NULL;
+
+	ret = __kvm_alloc_stage2_pgd(&nested_mmu->mmu);
+	if (ret) {
+		kfree(nested_mmu);
+		return NULL;
+	}
+
+	spin_lock(&vcpu->kvm->arch.mmu_list_lock);
+	tmp_mmu = get_nested_mmu(vcpu, vttbr);
+	if (!tmp_mmu)
+		list_add_rcu(&nested_mmu->list, nested_mmu_list);
+	else /* Somebody already created and put a new nested_mmu to the list */
+		need_free = true;
+	spin_unlock(&vcpu->kvm->arch.mmu_list_lock);
+
+	if (need_free) {
+		__kvm_free_stage2_pgd(&nested_mmu->mmu);
+		kfree(nested_mmu);
+		nested_mmu = tmp_mmu;
+	}
+
+	return nested_mmu;
+}
+
+static void kvm_nested_s2_unmap(struct kvm_vcpu *vcpu)
+{
+	struct kvm_nested_s2_mmu *nested_mmu;
+	struct list_head *nested_mmu_list = &vcpu->kvm->arch.nested_mmu_list;
+
+	list_for_each_entry_rcu(nested_mmu, nested_mmu_list, list)
+		kvm_unmap_stage2_range(&nested_mmu->mmu, 0, KVM_PHYS_SIZE);
+}
+
+bool handle_vttbr_update(struct kvm_vcpu *vcpu, u64 vttbr)
+{
+	struct kvm_nested_s2_mmu *nested_mmu;
+
+	/* See if we can relax this */
+	if (!vttbr)
+		return true;
+
+	nested_mmu = (struct kvm_nested_s2_mmu *)get_nested_mmu(vcpu, vttbr);
+	if (!nested_mmu) {
+		nested_mmu = create_nested_mmu(vcpu, vttbr);
+		if (!nested_mmu)
+			return false;
+	} else {
+		/*
+		 * unmap the shadow page table if vttbr_el2 is
+		 * changed to different value
+		 */
+		if (vttbr != nested_mmu->virtual_vttbr)
+			kvm_nested_s2_unmap(vcpu);
+	}
+
+	nested_mmu->virtual_vttbr = vttbr;
+
+	return true;
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e66f40d..ddb641c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -960,6 +960,19 @@ static bool access_cpacr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_vttbr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
+{
+	u64 vttbr = p->regval;
+
+	if (!p->is_write) {
+		p->regval = vcpu_el2_reg(vcpu, r->reg);
+		return true;
+	}
+
+	return handle_vttbr_update(vcpu, vttbr);
+}
+
 static bool trap_el2_reg(struct kvm_vcpu *vcpu,
 			 struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
@@ -1306,7 +1319,7 @@ static bool trap_el2_reg(struct kvm_vcpu *vcpu,
 	  trap_el2_reg, reset_el2_val, TCR_EL2, 0 },
 	/* VTTBR_EL2 */
 	{ Op0(0b11), Op1(0b100), CRn(0b0010), CRm(0b0001), Op2(0b000),
-	  trap_el2_reg, reset_el2_val, VTTBR_EL2, 0 },
+	  access_vttbr, reset_el2_val, VTTBR_EL2, 0 },
 	/* VTCR_EL2 */
 	{ Op0(0b11), Op1(0b100), CRn(0b0010), CRm(0b0001), Op2(0b010),
 	  trap_el2_reg, reset_el2_val, VTCR_EL2, 0 },
-- 
1.9.1
