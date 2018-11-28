From: Steven Price <steven.price@arm.com>
Subject: [PATCH 12/12] KVM: arm64: Provide a PV_TIME device to user space
Date: Wed, 28 Nov 2018 14:45:27 +0000
Message-ID: <20181128144527.44710-13-steven.price@arm.com>
References: <20181128144527.44710-1-steven.price@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D5B24A37A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Nov 2018 09:46:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f9YTdrEAJ0Vf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Nov 2018 09:46:49 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2EE34A388
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Nov 2018 09:46:49 -0500 (EST)
In-Reply-To: <20181128144527.44710-1-steven.price@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Price <steven.price@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Allow user space to inform the KVM host where in the physical memory
map the paravirtualized time structures should be located.

A single device is created which provides two base addresses. One
is the base of the Live Physical Time (LPT) structure shared with
the guest. This must be 64 bytes long.

The other is the base of an array of Stolen Time (ST) structures,
one for each VCPU. There must be (64 * total number of VCPUs) bytes
of memory available at this location.

The addresses are given in terms of the physical address visible to
the guest and must be 64 byte aligned. The memory should be marked as
reserved to the guest to stop it allocating it for other purposes.

A method is also provided to change the paravirtualized clock
frequency seen by a guest. This can only be changed before the guest
has been started, otherwise the guest will become confused.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h  |   2 +
 arch/arm64/include/uapi/asm/kvm.h |   8 +
 arch/arm64/kvm/Makefile           |   1 +
 include/uapi/linux/kvm.h          |   2 +
 virt/kvm/arm/mmu.c                |  44 ++++++
 virt/kvm/arm/pvtime.c             | 243 ++++++++++++++++++++++++++++++
 6 files changed, 300 insertions(+)
 create mode 100644 virt/kvm/arm/pvtime.c

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 658657367f2f..3c266521223a 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -167,6 +167,8 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm);
 void kvm_free_stage2_pgd(struct kvm *kvm);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
+int kvm_phys_addr_memremap(struct kvm *kvm, phys_addr_t guest_ipa,
+			  phys_addr_t pa, unsigned long size, bool writable);
 
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 97c3478ee6e7..157bd8d7ec82 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -307,6 +307,14 @@ struct kvm_vcpu_events {
 #define KVM_PSCI_RET_INVAL		PSCI_RET_INVALID_PARAMS
 #define KVM_PSCI_RET_DENIED		PSCI_RET_DENIED
 
+/* Device Control API: PV_TIME */
+#define KVM_DEV_ARM_PV_TIME_PADDR	0
+#define  KVM_DEV_ARM_PV_TIME_LPT	0
+#define  KVM_DEV_ARM_PV_TIME_ST		1
+#define KVM_DEV_ARM_PV_TIME_FREQUENCY	1
+#define KVM_DEV_ARM_PV_TIME_STATE_SIZE	2
+#define KVM_DEV_ARM_PV_TIME_STATE	3
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 45bb68f6c161..a3f064f0a51d 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -16,6 +16,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/e
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arm.o $(KVM)/arm/mmu.o $(KVM)/arm/mmio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hypercalls.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/pvtime.o
 
 kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o va_layout.o
 kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2b7a652c9fa4..494f7ad7987e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1198,6 +1198,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_ARM_VGIC_V3	KVM_DEV_TYPE_ARM_VGIC_V3
 	KVM_DEV_TYPE_ARM_VGIC_ITS,
 #define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
+	KVM_DEV_TYPE_ARM_PV_TIME,
+#define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
 	KVM_DEV_TYPE_MAX,
 };
 
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 5eca48bdb1a6..17ec31c40039 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1227,6 +1227,50 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	return ret;
 }
 
+/**
+ * kvm_phys_addr_memremap - map a memory range to guest IPA
+ *
+ * @kvm:	The KVM pointer
+ * @guest_ipa:	The IPA at which to insert the mapping
+ * @pa:		The physical address of the memory
+ * @size:	The size of the mapping
+ */
+int kvm_phys_addr_memremap(struct kvm *kvm, phys_addr_t guest_ipa,
+			  phys_addr_t pa, unsigned long size, bool writable)
+{
+	phys_addr_t addr, end;
+	int ret = 0;
+	unsigned long pfn;
+	struct kvm_mmu_memory_cache cache = { 0, };
+
+	end = (guest_ipa + size + PAGE_SIZE - 1) & PAGE_MASK;
+	pfn = __phys_to_pfn(pa);
+
+	for (addr = guest_ipa; addr < end; addr += PAGE_SIZE) {
+		pte_t pte = pfn_pte(pfn, PAGE_S2);
+
+		if (writable)
+			pte = kvm_s2pte_mkwrite(pte);
+
+		ret = mmu_topup_memory_cache(&cache,
+					     kvm_mmu_cache_min_pages(kvm),
+					     KVM_NR_MEM_OBJS);
+		if (ret)
+			goto out;
+		spin_lock(&kvm->mmu_lock);
+		ret = stage2_set_pte(kvm, &cache, addr, &pte, 0);
+		spin_unlock(&kvm->mmu_lock);
+		if (ret)
+			goto out;
+
+		pfn++;
+	}
+
+out:
+	mmu_free_memory_cache(&cache);
+	return ret;
+}
+
 static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
 {
 	kvm_pfn_t pfn = *pfnp;
diff --git a/virt/kvm/arm/pvtime.c b/virt/kvm/arm/pvtime.c
new file mode 100644
index 000000000000..16efa7e70424
--- /dev/null
+++ b/virt/kvm/arm/pvtime.c
@@ -0,0 +1,243 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2018 Arm Ltd.
+
+#include <linux/kvm_host.h>
+#include <asm/kvm_mmu.h>
+
+/* We currently only support PV time on ARM64 */
+#ifdef CONFIG_ARM64
+
+static int max_stolen_size(void)
+{
+	int size = KVM_MAX_VCPUS * sizeof(struct pvclock_vcpu_stolen_time_info);
+
+	return ALIGN(size, PAGE_SIZE);
+}
+
+static int kvm_arm_pvtime_create(struct kvm_device *dev, u32 type)
+{
+	int size_required;
+	struct kvm_arch_pvtime *pvtime = &dev->kvm->arch.pvtime;
+
+	/*
+	 * We require 1 page for LPT and a pvclock_vcpu_stolen_time_info
+	 * structure per VCPU.
+	 */
+	size_required = PAGE_SIZE + max_stolen_size();
+
+	pvtime->lpt_fpv = arch_timer_get_rate();
+	pvtime->pv_page = alloc_pages_exact(size_required,
+					    GFP_KERNEL | __GFP_ZERO);
+
+	if (!pvtime->pv_page)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void kvm_arm_pvtime_destroy(struct kvm_device *dev)
+{
+	struct kvm_arch_pvtime *pvtime = &dev->kvm->arch.pvtime;
+
+	pvtime->lpt_page = GPA_INVALID;
+	pvtime->st_base = GPA_INVALID;
+	free_pages_exact(pvtime->pv_page, PAGE_SIZE + max_stolen_size());
+}
+
+static int pvtime_map_pages(struct kvm *kvm, gpa_t guest_paddr,
+			    int offset, int size)
+{
+	struct kvm_arch_pvtime *pvtime = &kvm->arch.pvtime;
+
+	return kvm_phys_addr_memremap(kvm, guest_paddr,
+			virt_to_phys(pvtime->pv_page + offset),
+			size, false);
+}
+
+static int pvtime_save_state(struct kvm *kvm, u64 type, void __user *user)
+{
+	void *source;
+	size_t size;
+
+	switch (type) {
+	case KVM_DEV_ARM_PV_TIME_LPT:
+		source = kvm->arch.pvtime.pv_page;
+		size = sizeof(struct pvclock_vm_time_info);
+		break;
+	case KVM_DEV_ARM_PV_TIME_ST:
+		source = kvm->arch.pvtime.pv_page + PAGE_SIZE;
+		size = sizeof(struct pvclock_vcpu_stolen_time_info) *
+			atomic_read(&kvm->online_vcpus);
+		break;
+	default:
+		return -ENXIO;
+	}
+
+	if (copy_to_user(user, source, size))
+		return -EFAULT;
+	return 0;
+}
+
+static int pvtime_restore_state(struct kvm *kvm, u64 type, void __user *user)
+{
+	void *dest;
+	size_t size;
+
+	switch (type) {
+	case KVM_DEV_ARM_PV_TIME_LPT:
+		dest = kvm->arch.pvtime.pv_page;
+		size = sizeof(struct pvclock_vm_time_info);
+		break;
+	case KVM_DEV_ARM_PV_TIME_ST:
+		dest = kvm->arch.pvtime.pv_page + PAGE_SIZE;
+		size = sizeof(struct pvclock_vcpu_stolen_time_info) *
+			atomic_read(&kvm->online_vcpus);
+		break;
+	default:
+		return -ENXIO;
+	}
+
+	if (copy_from_user(dest, user, size))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_arm_pvtime_set_attr(struct kvm_device *dev,
+				   struct kvm_device_attr *attr)
+{
+	struct kvm_arch_pvtime *pvtime = &dev->kvm->arch.pvtime;
+	u64 __user *user = (u64 __user *)attr->addr;
+	u64 paddr;
+	u32 frequency;
+	int ret;
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_PV_TIME_PADDR:
+		if (get_user(paddr, user))
+			return -EFAULT;
+		if (paddr & 63)
+			return -EINVAL;
+		switch (attr->attr) {
+		case KVM_DEV_ARM_PV_TIME_LPT:
+			if (pvtime->lpt_page != GPA_INVALID)
+				return -EEXIST;
+			ret = pvtime_map_pages(dev->kvm, paddr, 0, PAGE_SIZE);
+			if (ret)
+				return ret;
+			pvtime->lpt_page = paddr;
+			return kvm_arm_update_lpt_sequence(dev->kvm);
+		case KVM_DEV_ARM_PV_TIME_ST:
+			if (pvtime->st_base != GPA_INVALID)
+				return -EEXIST;
+			ret = pvtime_map_pages(dev->kvm, paddr, PAGE_SIZE,
+					max_stolen_size());
+			if (ret)
+				return ret;
+			pvtime->st_base = paddr;
+			return 0;
+		}
+		break;
+	case KVM_DEV_ARM_PV_TIME_FREQUENCY:
+		if (attr->attr != KVM_DEV_ARM_PV_TIME_LPT)
+			break;
+		if (get_user(frequency, user))
+			return -EFAULT;
+		pvtime->lpt_fpv = frequency;
+		return kvm_arm_update_lpt_sequence(dev->kvm);
+	case KVM_DEV_ARM_PV_TIME_STATE_SIZE:
+		return -EPERM;
+	case KVM_DEV_ARM_PV_TIME_STATE:
+		return pvtime_restore_state(dev->kvm, attr->attr, user);
+	}
+	return -ENXIO;
+}
+
+static int kvm_arm_pvtime_get_attr(struct kvm_device *dev,
+				   struct kvm_device_attr *attr)
+{
+	u64 __user *user = (u64 __user *)attr->addr;
+	u32 size;
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_PV_TIME_PADDR:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_PV_TIME_LPT:
+			if (put_user(dev->kvm->arch.pvtime.lpt_page, user))
+				return -EFAULT;
+			return 0;
+		case KVM_DEV_ARM_PV_TIME_ST:
+			if (put_user(dev->kvm->arch.pvtime.st_base, user))
+				return -EFAULT;
+			return 0;
+		}
+		break;
+	case KVM_DEV_ARM_PV_TIME_FREQUENCY:
+		if (attr->attr != KVM_DEV_ARM_PV_TIME_LPT)
+			break;
+		if (put_user(dev->kvm->arch.pvtime.lpt_fpv, user))
+			return -EFAULT;
+		return 0;
+	case KVM_DEV_ARM_PV_TIME_STATE_SIZE:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_PV_TIME_LPT:
+			size = sizeof(struct pvclock_vm_time_info);
+			break;
+		case KVM_DEV_ARM_PV_TIME_ST:
+			size = sizeof(struct pvclock_vcpu_stolen_time_info);
+			size *= atomic_read(&dev->kvm->online_vcpus);
+			break;
+		default:
+			return -ENXIO;
+		}
+		if (put_user(size, user))
+			return -EFAULT;
+		return 0;
+	case KVM_DEV_ARM_PV_TIME_STATE:
+		return pvtime_save_state(dev->kvm, attr->attr, user);
+	}
+	return -ENXIO;
+}
+
+static int kvm_arm_pvtime_has_attr(struct kvm_device *dev,
+				   struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_PV_TIME_PADDR:
+	case KVM_DEV_ARM_PV_TIME_STATE_SIZE:
+	case KVM_DEV_ARM_PV_TIME_STATE:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_PV_TIME_LPT:
+		case KVM_DEV_ARM_PV_TIME_ST:
+			return 0;
+		}
+		break;
+	case KVM_DEV_ARM_PV_TIME_FREQUENCY:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_PV_TIME_LPT:
+			return 0;
+		}
+		break;
+	}
+	return -ENXIO;
+}
+
+static const struct kvm_device_ops pvtime_ops = {
+	"Arm PV time",
+	.create = kvm_arm_pvtime_create,
+	.destroy = kvm_arm_pvtime_destroy,
+	.set_attr = kvm_arm_pvtime_set_attr,
+	.get_attr = kvm_arm_pvtime_get_attr,
+	.has_attr = kvm_arm_pvtime_has_attr
+};
+
+static int __init kvm_pvtime_init(void)
+{
+	kvm_register_device_ops(&pvtime_ops, KVM_DEV_TYPE_ARM_PV_TIME);
+
+	return 0;
+}
+
+late_initcall(kvm_pvtime_init);
+
+#endif
-- 
2.19.2
