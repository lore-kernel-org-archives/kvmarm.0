From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 12/17] kvm: arm/arm64: Expose supported physical address limit for VM
Date: Tue, 27 Mar 2018 14:15:22 +0100
Message-ID: <1522156531-28348-13-git-send-email-suzuki.poulose@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, cdall@kernel.org, marc.zyngier@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, ard.biesheuvel@linaro.org, peter.maydell@linaro.org, kristina.martsenko@arm.com, mark.rutland@arm.com, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Expose the maximum physical address size supported by the host
for a VM. This could be later used by the userspace to choose the
appropriate size for a given VM. The limit is determined as the
minimum of actual CPU limit, the kernel limit (i.e, either 48 or 52)
and the stage2 page table support limit (which is 40bits at the moment).
For backward compatibility, we support a minimum of 40bits. The limit
will be lifted as we add support for the stage2 to support the host
kernel PA limit.

This value may be different from what is exposed to the VM via
CPU ID registers. The limit only applies to the stage2 page table.

Cc: Christoffer Dall <cdall@kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Peter Maydel <peter.maydell@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 Documentation/virtual/kvm/api.txt | 14 ++++++++++++++
 arch/arm/include/asm/kvm_mmu.h    |  5 +++++
 arch/arm64/include/asm/kvm_mmu.h  |  5 +++++
 include/uapi/linux/kvm.h          |  6 ++++++
 virt/kvm/arm/arm.c                |  6 ++++++
 5 files changed, 36 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 792fa87..55908a8 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -3500,6 +3500,20 @@ Returns: 0 on success; -1 on error
 This ioctl can be used to unregister the guest memory region registered
 with KVM_MEMORY_ENCRYPT_REG_REGION ioctl above.
 
+4.113 KVM_ARM_GET_MAX_VM_PHYS_SHIFT
+Capability: basic
+Architectures: arm, arm64
+Type: system ioctl
+Parameters: none
+Returns: log2(Maximum physical address space size) supported by the
+hyperviosr.
+
+This ioctl can be used to identify the maximum physical address space size
+supported by the hypervisor. The returned value indicates the maximum size
+of the address that can be resolved by the stage2 translation table on
+arm/arm64. On arm64, the value is decided based on the host kernel
+configuration and the system wide safe value of ID_AA64MMFR0_EL1:PARange.
+This may not match the value exposed to the VM in CPU ID registers.
 
 5. The kvm_run structure
 ------------------------
diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 305aa40..50896da 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -318,6 +318,11 @@ static inline int kvm_map_vectors(void)
 
 #define kvm_phys_to_vttbr(addr)		(addr)
 
+static inline u32 kvm_get_ipa_limit(void)
+{
+	return KVM_PHYS_SHIFT;
+}
+
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* __ARM_KVM_MMU_H__ */
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 447bc10..a4c8c00 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -411,5 +411,10 @@ static inline u64 kvm_vttbr_baddr_mask(struct kvm *kvm)
 	return GENMASK_ULL(PHYS_MASK_SHIFT - 1, x);
 }
 
+static inline u32 kvm_get_ipa_limit(void)
+{
+	return KVM_PHYS_SHIFT;
+}
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0fb5ef9..b737ee1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -763,6 +763,12 @@ struct kvm_ppc_resize_hpt {
 #define KVM_GET_EMULATED_CPUID	  _IOWR(KVMIO, 0x09, struct kvm_cpuid2)
 
 /*
+ * Get the maximum physical address size supported by the host.
+ * Returns log2(Max-Physical-Address-Size)
+ */
+#define KVM_ARM_GET_MAX_VM_PHYS_SHIFT	_IO(KVMIO, 0x0a)
+
+/*
  * Extension capability list.
  */
 #define KVM_CAP_IRQCHIP	  0
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 8b35a47..53bb05c 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -64,6 +64,7 @@ static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
 static u32 kvm_next_vmid;
 static unsigned int kvm_vmid_bits __read_mostly;
 static DEFINE_SPINLOCK(kvm_vmid_lock);
+static u32 kvm_ipa_limit;
 
 static bool vgic_present;
 
@@ -246,6 +247,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
 {
+	if (ioctl == KVM_ARM_GET_MAX_VM_PHYS_SHIFT)
+		return kvm_ipa_limit;
+
 	return -EINVAL;
 }
 
@@ -1348,6 +1352,8 @@ static int init_common_resources(void)
 	kvm_vmid_bits = kvm_get_vmid_bits();
 	kvm_info("%d-bit VMID\n", kvm_vmid_bits);
 
+	kvm_ipa_limit = kvm_get_ipa_limit();
+
 	return 0;
 }
 
-- 
2.7.4
