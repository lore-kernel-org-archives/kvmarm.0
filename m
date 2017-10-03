From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 09/31] KVM: arm/arm64: Manage mmus for nested VMs
Date: Mon,  2 Oct 2017 22:10:51 -0500
Message-ID: <1507000273-3735-7-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E6AF41185
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m+KqB3StY2bt for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Oct 2017 23:11:31 -0400 (EDT)
Received: from mail-it0-f48.google.com (mail-it0-f48.google.com
 [209.85.214.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4433D49D14
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Oct 2017 23:11:28 -0400 (EDT)
Received: by mail-it0-f48.google.com with SMTP id y138so10005394itc.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Oct 2017 20:11:47 -0700 (PDT)
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

Now that a hypervisor can run in the virtual EL2, the guest hypervisor
can assign any VMID to its own VMs. To avoid conflicts between VMIDs
among a host and guest(s), the host hypervisor maps each VMID from a
guest hypervisor's view (i.e. virtual VMID) to an unique shadow VMID.
It also manages a set of shadow stage-2 page tables for each shadow
VMID. All this information is stored in kvm_nested_s2_mmu struct.

A host hypervisor manages a list of kvm_nested_s2_mmu objects per VM. On
a VM entry it searches an object in the list using a virtual VMID as a
key.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---

Notes:
    v1-->v2:
    - This is a merged commit of [RFC 39/55] and [RFC 40/55].
    - Updated the commit message and comments.
    - Defer creating a new nested mmu structure until we enter the VM with stage 2
      paging enabled, which was previously done on vttbr_el2 write operations.
    - Use the existing kvm->mmu_lock when iterating nested mmus instead of creating one.

 arch/arm/include/asm/kvm_host.h      |  12 ++++
 arch/arm64/include/asm/kvm_emulate.h |  13 ++---
 arch/arm64/include/asm/kvm_host.h    |  25 ++++++++
 arch/arm64/include/asm/kvm_mmu.h     |  21 +++++++
 arch/arm64/kvm/Makefile              |   1 +
 arch/arm64/kvm/context.c             |   2 +-
 arch/arm64/kvm/mmu-nested.c          | 108 +++++++++++++++++++++++++++++++++++
 virt/kvm/arm/arm.c                   |   1 +
 8 files changed, 174 insertions(+), 9 deletions(-)
 create mode 100644 arch/arm64/kvm/mmu-nested.c

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 33ccdbe..d84c1c1 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -67,6 +67,15 @@ struct kvm_s2_mmu {
 	pgd_t *pgd;
 };
 
+/* Per shadow VMID mmu structure. This is only for nested virtualization */
+struct kvm_nested_s2_mmu {
+	struct kvm_s2_mmu mmu;
+
+	u64 virtual_vttbr;
+
+	struct list_head list;
+};
+
 struct kvm_arch {
 	/* Stage 2 paging state for the VM */
 	struct kvm_s2_mmu mmu;
@@ -79,6 +88,9 @@ struct kvm_arch {
 	 * here.
 	 */
 
+	/* Never used on arm but added to be compatible with arm64 */
+	struct list_head nested_mmu_list;
+
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
 	int max_vcpus;
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 71a3a04..f476576 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -199,6 +199,11 @@ static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
 	return false;
 }
 
+static inline bool vcpu_nested_stage2_enabled(const struct kvm_vcpu *vcpu)
+{
+	return (vcpu_sys_reg(vcpu, HCR_EL2) & HCR_VM);
+}
+
 static inline u32 kvm_vcpu_get_hsr(const struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.fault.esr_el2;
@@ -385,12 +390,4 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 	return data;		/* Leave LE untouched */
 }
 
-static inline struct kvm_s2_vmid *vcpu_get_active_vmid(struct kvm_vcpu *vcpu)
-{
-	if (unlikely(is_hyp_ctxt(vcpu)))
-		return &vcpu->kvm->arch.mmu.el2_vmid;
-
-	return &vcpu->kvm->arch.mmu.vmid;
-}
-
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a7edf0e..0c37e49 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -65,6 +65,28 @@ struct kvm_s2_mmu {
 	pgd_t *pgd;
 };
 
+/* Per shadow VMID mmu structure */
+struct kvm_nested_s2_mmu {
+	struct kvm_s2_mmu mmu;
+
+	/*
+	 * virtual_vttbr contains vttbr_el2 value from the guest hypervisor.
+	 * We use vmid field as a key to search for this mmu object in the list,
+	 * and ignore baddr field.
+	 *
+	 * Note that we may use both of vmid field and baddr field respectively
+	 * to find a shadow VMID and a pointer to the shadow stage-2 page
+	 * table, then combine them to set up hw_vttbr. The only benefit of
+	 * doing that would be reusing shadow stage-2 page tables for different
+	 * VMIDs, which is not usual. So, we choose the current design for the
+	 * simplicity.
+	 *
+	 */
+	u64 virtual_vttbr;
+
+	struct list_head list;
+};
+
 struct kvm_arch {
 	/* Stage 2 paging state for the VM */
 	struct kvm_s2_mmu mmu;
@@ -77,6 +99,9 @@ struct kvm_arch {
 
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
+
+	/* Stage 2 shadow paging contexts for nested L2 VM */
+	struct list_head nested_mmu_list;
 };
 
 #define KVM_NR_MEM_OBJS     40
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index bceaec1..452912f 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -112,6 +112,7 @@
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
 #include <asm/pgtable.h>
+#include <asm/kvm_emulate.h>
 
 static inline unsigned long __kern_hyp_va(unsigned long v)
 {
@@ -321,6 +322,10 @@ static inline unsigned int kvm_get_vmid_bits(void)
 	return (cpuid_feature_extract_unsigned_field(reg, ID_AA64MMFR1_VMIDBITS_SHIFT) == 2) ? 16 : 8;
 }
 
+struct kvm_nested_s2_mmu *get_nested_mmu(struct kvm_vcpu *vcpu, u64 vttbr);
+struct kvm_s2_mmu *vcpu_get_active_s2_mmu(struct kvm_vcpu *vcpu);
+void update_nested_s2_mmu(struct kvm_vcpu *vcpu);
+
 static inline u64 kvm_get_vttbr(struct kvm_s2_vmid *vmid,
 				struct kvm_s2_mmu *mmu)
 {
@@ -332,5 +337,21 @@ static inline u64 kvm_get_vttbr(struct kvm_s2_vmid *vmid,
 	return baddr | vmid_field;
 }
 
+static inline u64 get_vmid(u64 vttbr)
+{
+	return (vttbr & VTTBR_VMID_MASK(get_kvm_vmid_bits())) >>
+	       VTTBR_VMID_SHIFT;
+}
+
+static inline struct kvm_s2_vmid *vcpu_get_active_vmid(struct kvm_vcpu *vcpu)
+{
+	struct kvm_s2_mmu *mmu = vcpu_get_active_s2_mmu(vcpu);
+
+	if (unlikely(is_hyp_ctxt(vcpu)))
+		return &mmu->el2_vmid;
+	else
+		return &mmu->vmid;
+}
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 0263ef0..5300db0 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -37,4 +37,5 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
 
 kvm-$(CONFIG_KVM_ARM_HOST) += nested.o
+kvm-$(CONFIG_KVM_ARM_HOST) += mmu-nested.o
 kvm-$(CONFIG_KVM_ARM_HOST) += emulate-nested.o
diff --git a/arch/arm64/kvm/context.c b/arch/arm64/kvm/context.c
index afd1702..762d4a5 100644
--- a/arch/arm64/kvm/context.c
+++ b/arch/arm64/kvm/context.c
@@ -177,7 +177,7 @@ static void flush_shadow_el1_sysregs(struct kvm_vcpu *vcpu)
 
 static void setup_s2_mmu(struct kvm_vcpu *vcpu)
 {
-	struct kvm_s2_mmu *mmu = &vcpu->kvm->arch.mmu;
+	struct kvm_s2_mmu *mmu = vcpu_get_active_s2_mmu(vcpu);
 	struct kvm_s2_vmid *vmid = vcpu_get_active_vmid(vcpu);
 
 	vcpu->arch.hw_vttbr = kvm_get_vttbr(vmid, mmu);
diff --git a/arch/arm64/kvm/mmu-nested.c b/arch/arm64/kvm/mmu-nested.c
new file mode 100644
index 0000000..c436daf
--- /dev/null
+++ b/arch/arm64/kvm/mmu-nested.c
@@ -0,0 +1,108 @@
+/*
+ * Copyright (C) 2017 - Columbia University and Linaro Ltd.
+ * Author: Jintack Lim <jintack.lim@linaro.org>
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
+
+static struct kvm_nested_s2_mmu *lookup_nested_mmu(struct kvm_vcpu *vcpu,
+						   u64 vttbr)
+{
+	struct kvm_nested_s2_mmu *mmu;
+	u64 virtual_vmid;
+	u64 target_vmid = get_vmid(vttbr);
+	struct list_head *nested_mmu_list = &vcpu->kvm->arch.nested_mmu_list;
+
+	/* Search a mmu in the list using the virtual VMID as a key */
+	list_for_each_entry_rcu(mmu, nested_mmu_list, list) {
+		virtual_vmid = get_vmid(mmu->virtual_vttbr);
+		if (target_vmid == virtual_vmid)
+			return mmu;
+	}
+	return NULL;
+}
+
+/**
+ * create_nested_mmu - create mmu for the given virtual VMID
+ *
+ * Called from setup_s2_mmu before entering the nested VM to ensure the shadow
+ * stage 2 page table is allocated and it is valid to use.
+ */
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
+	spin_lock(&vcpu->kvm->mmu_lock);
+	tmp_mmu = lookup_nested_mmu(vcpu, vttbr);
+	if (!tmp_mmu) {
+		list_add_rcu(&nested_mmu->list, nested_mmu_list);
+	} else {
+		/*
+		 * Somebody already put a new nested_mmu for this virtual VMID
+		 * to the list behind our back.
+		 */
+		need_free = true;
+	}
+	spin_unlock(&vcpu->kvm->mmu_lock);
+
+	if (need_free) {
+		__kvm_free_stage2_pgd(vcpu->kvm, &nested_mmu->mmu);
+		kfree(nested_mmu);
+		nested_mmu = tmp_mmu;
+	}
+
+	/* The virtual VMID will be used as a key when searching a mmu */
+	nested_mmu->virtual_vttbr = vttbr;
+
+	return nested_mmu;
+}
+
+static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
+{
+	u64 vttbr = vcpu_sys_reg(vcpu, VTTBR_EL2);
+	struct kvm_nested_s2_mmu *nested_mmu;
+
+	nested_mmu = lookup_nested_mmu(vcpu, vttbr);
+	if (!nested_mmu)
+		nested_mmu = create_nested_mmu(vcpu, vttbr);
+
+	return &nested_mmu->mmu;
+}
+
+struct kvm_s2_mmu *vcpu_get_active_s2_mmu(struct kvm_vcpu *vcpu)
+{
+	if (is_hyp_ctxt(vcpu) || !vcpu_nested_stage2_enabled(vcpu))
+		return &vcpu->kvm->arch.mmu;
+
+	return get_s2_mmu_nested(vcpu);
+}
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 63dd897..4548d77 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -145,6 +145,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	/* Mark the initial VMID generation invalid */
 	kvm->arch.mmu.vmid.vmid_gen = 0;
 	kvm->arch.mmu.el2_vmid.vmid_gen = 0;
+	INIT_LIST_HEAD(&kvm->arch.nested_mmu_list);
 
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->arch.max_vcpus = vgic_present ?
-- 
1.9.1
