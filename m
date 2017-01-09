From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 39/55] KVM: arm/arm64: Add mmu context for the nesting
Date: Mon,  9 Jan 2017 01:24:35 -0500
Message-ID: <1483943091-1364-40-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EC9240296
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RSo0LoXXfvno for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:40 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E5AD4066D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:40 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q5CT017975
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:22 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 023E98F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:22 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id DA5C98C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:21 -0500 (EST)
Received: from mail-qt0-f197.google.com (mail-qt0-f197.google.com
 [209.85.216.197])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QL4f057619
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:21 -0500
Received: by mail-qt0-f197.google.com with SMTP id g49so26223054qta.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:21 -0800 (PST)
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

Add the shadow stage-2 MMU context to be used for the nesting, but don't
do anything with it yet.

The host hypervisor maintains mmu structures for each nested VM. When
entering a nested VM, the host hypervisor searches for the nested VM's
mmu using vmid as a key. Note that this vmid is from the guest
hypervisor's point of view.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/include/asm/kvm_host.h      |  3 ++
 arch/arm/kvm/arm.c                   |  1 +
 arch/arm64/include/asm/kvm_emulate.h | 13 ++++-----
 arch/arm64/include/asm/kvm_host.h    | 19 +++++++++++++
 arch/arm64/include/asm/kvm_mmu.h     | 31 ++++++++++++++++++++
 arch/arm64/kvm/Makefile              |  1 +
 arch/arm64/kvm/context.c             |  2 +-
 arch/arm64/kvm/mmu-nested.c          | 55 ++++++++++++++++++++++++++++++++++++
 8 files changed, 116 insertions(+), 9 deletions(-)
 create mode 100644 arch/arm64/kvm/mmu-nested.c

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index da45394..fbde48d 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -82,6 +82,9 @@ struct kvm_arch {
 	 * here.
 	 */
 
+	/* Never used on arm but added to be compatible with arm64 */
+	struct list_head nested_mmu_list;
+
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
 	int max_vcpus;
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 371b38e7..147df97 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -146,6 +146,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	/* Mark the initial VMID generation invalid */
 	kvm->arch.mmu.vmid.vmid_gen = 0;
 	kvm->arch.mmu.el2_vmid.vmid_gen = 0;
+	INIT_LIST_HEAD(&kvm->arch.nested_mmu_list);
 
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->arch.max_vcpus = vgic_present ?
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 94068e7..abad676 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -183,6 +183,11 @@ static inline bool vcpu_el2_imo_is_set(const struct kvm_vcpu *vcpu)
 	return (vcpu_el2_reg(vcpu, HCR_EL2) & HCR_IMO);
 }
 
+static inline bool vcpu_nested_stage2_enabled(const struct kvm_vcpu *vcpu)
+{
+	return (vcpu_el2_reg(vcpu, HCR_EL2) & HCR_VM);
+}
+
 static inline u32 kvm_vcpu_get_hsr(const struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.fault.esr_el2;
@@ -363,12 +368,4 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 	return data;		/* Leave LE untouched */
 }
 
-static inline struct kvm_s2_vmid *vcpu_get_active_vmid(struct kvm_vcpu *vcpu)
-{
-	if (unlikely(vcpu_mode_el2(vcpu)))
-		return &vcpu->kvm->arch.mmu.el2_vmid;
-
-	return &vcpu->kvm->arch.mmu.vmid;
-}
-
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b33d35d..23e2267 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -65,6 +65,22 @@ struct kvm_s2_mmu {
 	pgd_t *pgd;
 };
 
+/* Per nested VM mmu structure */
+struct kvm_nested_s2_mmu {
+	struct kvm_s2_mmu mmu;
+
+	/*
+	 * The vttbr value set by the guest hypervisor for this nested VM.
+	 * vmid field is used as a key to search for this mmu structure among
+	 * all nested VM mmu structures by the host hypervisor.
+	 * baddr field is used to determine if we need to unmap stage 2
+	 * shadow page tables.
+	 */
+	u64 virtual_vttbr;
+
+	struct list_head list;
+};
+
 struct kvm_arch {
 	/* Stage 2 paging state for the VM */
 	struct kvm_s2_mmu mmu;
@@ -80,6 +96,9 @@ struct kvm_arch {
 
 	/* Timer */
 	struct arch_timer_kvm	timer;
+
+	/* Stage 2 shadow paging contexts for nested L2 VM */
+	struct list_head nested_mmu_list;
 };
 
 #define KVM_NR_MEM_OBJS     40
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index a504162..d1ef650 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -112,6 +112,7 @@
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
 #include <asm/pgtable.h>
+#include <asm/kvm_emulate.h>
 
 static inline unsigned long __kern_hyp_va(unsigned long v)
 {
@@ -323,6 +324,21 @@ static inline unsigned int kvm_get_vmid_bits(void)
 	return (cpuid_feature_extract_unsigned_field(reg, ID_AA64MMFR1_VMIDBITS_SHIFT) == 2) ? 16 : 8;
 }
 
+#ifdef CONFIG_KVM_ARM_NESTED_HYP
+struct kvm_nested_s2_mmu *get_nested_mmu(struct kvm_vcpu *vcpu, u64 vttbr);
+struct kvm_s2_mmu *vcpu_get_active_s2_mmu(struct kvm_vcpu *vcpu);
+#else
+static inline struct kvm_nested_s2_mmu *get_nested_mmu(struct kvm_vcpu *vcpu,
+						       u64 vttbr)
+{
+	return NULL;
+}
+static inline struct kvm_s2_mmu *vcpu_get_active_s2_mmu(struct kvm_vcpu *vcpu)
+{
+	return &vcpu->kvm->arch.mmu;
+}
+#endif
+
 static inline u64 kvm_get_vttbr(struct kvm_s2_vmid *vmid,
 				struct kvm_s2_mmu *mmu)
 {
@@ -334,5 +350,20 @@ static inline u64 kvm_get_vttbr(struct kvm_s2_vmid *vmid,
 	return baddr | vmid_field;
 }
 
+static inline u64 get_vmid(u64 vttbr)
+{
+	return (vttbr & VTTBR_VMID_MASK(get_kvm_vmid_bits()))>>VTTBR_VMID_SHIFT;
+}
+
+static inline struct kvm_s2_vmid *vcpu_get_active_vmid(struct kvm_vcpu *vcpu)
+{
+	struct kvm_s2_mmu *mmu = vcpu_get_active_s2_mmu(vcpu);
+
+	if (unlikely(vcpu_mode_el2(vcpu)))
+		return &mmu->el2_vmid;
+	else
+		return &mmu->vmid;
+}
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 8573faf..b0b1074 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -36,5 +36,6 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
 
 kvm-$(CONFIG_KVM_ARM_NESTED_HYP) += handle_exit_nested.o
+kvm-$(CONFIG_KVM_ARM_NESTED_HYP) += mmu-nested.o
 kvm-$(CONFIG_KVM_ARM_NESTED_HYP) += emulate-nested.o
 kvm-$(CONFIG_KVM_ARM_NESTED_HYP) += $(KVM)/arm/vgic/vgic-v2-nested.o
diff --git a/arch/arm64/kvm/context.c b/arch/arm64/kvm/context.c
index b2c0220..9ebc38f 100644
--- a/arch/arm64/kvm/context.c
+++ b/arch/arm64/kvm/context.c
@@ -91,7 +91,7 @@ static void create_shadow_el1_sysregs(struct kvm_vcpu *vcpu)
 
 static void setup_s2_mmu(struct kvm_vcpu *vcpu)
 {
-	struct kvm_s2_mmu *mmu = &vcpu->kvm->arch.mmu;
+	struct kvm_s2_mmu *mmu = vcpu_get_active_s2_mmu(vcpu);
 	struct kvm_s2_vmid *vmid = vcpu_get_active_vmid(vcpu);
 
 	vcpu->arch.hw_vttbr = kvm_get_vttbr(vmid, mmu);
diff --git a/arch/arm64/kvm/mmu-nested.c b/arch/arm64/kvm/mmu-nested.c
new file mode 100644
index 0000000..d52078f
--- /dev/null
+++ b/arch/arm64/kvm/mmu-nested.c
@@ -0,0 +1,55 @@
+/*
+ * Copyright (C) 2016 - Columbia University
+ * Author: Jintack Lim <jintack@cs.columbia.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_arm.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
+
+struct kvm_nested_s2_mmu *get_nested_mmu(struct kvm_vcpu *vcpu, u64 vttbr)
+{
+	struct kvm_nested_s2_mmu *mmu;
+	u64 target_vmid = get_vmid(vttbr);
+	struct list_head *nested_mmu_list = &vcpu->kvm->arch.nested_mmu_list;
+
+	list_for_each_entry_rcu(mmu, nested_mmu_list, list) {
+		u64 vmid = get_vmid(mmu->virtual_vttbr);
+
+		if (target_vmid == vmid)
+			return mmu;
+	}
+	return NULL;
+}
+
+struct kvm_s2_mmu *vcpu_get_active_s2_mmu(struct kvm_vcpu *vcpu)
+{
+	struct kvm_nested_s2_mmu *nested_mmu;
+
+	/* If we are NOT entering the nested VM, return mmu in kvm_arch */
+	if (vcpu_mode_el2(vcpu) || !vcpu_nested_stage2_enabled(vcpu))
+		return &vcpu->kvm->arch.mmu;
+
+	/* Otherwise, search for nested_mmu in the list */
+	nested_mmu = get_nested_mmu(vcpu, vcpu_el2_reg(vcpu, VTTBR_EL2));
+
+	/* When this function is called, nested_mmu should be in the list */
+	BUG_ON(!nested_mmu);
+
+	return &nested_mmu->mmu;
+}
-- 
1.9.1
