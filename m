From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 13/17] kvm: arm/arm64: Allow tuning the physical address size for VM
Date: Tue, 27 Mar 2018 14:15:23 +0100
Message-ID: <1522156531-28348-14-git-send-email-suzuki.poulose@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, cdall@kernel.org, marc.zyngier@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, ard.biesheuvel@linaro.org, peter.maydell@linaro.org, kristina.martsenko@arm.com, mark.rutland@arm.com, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Allow specifying the physical address size for a new VM via
the kvm_type argument for KVM_CREATE_VM ioctl. This allows
us to finalise the stage2 page table format as early as possible
and hence perform the right checks on the memory slots without
complication. The size is encoded as Log2(PA_Siz) in the bits[7:0]
of the type field and can encode more information in the future if
required.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Cc: Peter Maydel <peter.maydell@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   |  2 ++
 arch/arm64/include/asm/kvm_mmu.h |  2 ++
 include/uapi/linux/kvm.h         | 10 ++++++++++
 virt/kvm/arm/arm.c               | 24 ++++++++++++++++++++++--
 4 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 50896da..3f13827 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -323,6 +323,8 @@ static inline u32 kvm_get_ipa_limit(void)
 	return KVM_PHYS_SHIFT;
 }
 
+static inline void kvm_config_stage2(struct kvm *kvm, u32 ipa_shift) {}
+
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* __ARM_KVM_MMU_H__ */
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index a4c8c00..bb458bf 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -416,5 +416,7 @@ static inline u32 kvm_get_ipa_limit(void)
 	return KVM_PHYS_SHIFT;
 }
 
+static inline void kvm_config_stage2(struct kvm *kvm, u32 ipa_shift) {}
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b737ee1..67b09b0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -740,6 +740,16 @@ struct kvm_ppc_resize_hpt {
 #define KVM_S390_SIE_PAGE_OFFSET 1
 
 /*
+ * On arm/arm64, machine type can be used to request the physical
+ * address size for the VM. Bits [7-0] have been reserved for the
+ * PA size shift (i.e, log2(PA-Size)). For backward compatibility,
+ * value 0 implies the default IPA size, which is 40bits.
+ */
+#define KVM_VM_TYPE_ARM_PHYS_SHIFT_MASK	0xff
+#define KVM_VM_TYPE_ARM_PHYS_SHIFT(x)		\
+	((x) & KVM_VM_TYPE_ARM_PHYS_SHIFT_MASK)
+
+/*
  * ioctls for /dev/kvm fds:
  */
 #define KVM_GET_API_VERSION       _IO(KVMIO,   0x00)
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 53bb05c..13eb66f 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -110,6 +110,25 @@ void kvm_arch_check_processor_compat(void *rtn)
 }
 
 
+static int kvm_arch_config_vm(struct kvm *kvm, unsigned long type)
+{
+	u32 ipa_shift = (u32)type & KVM_VM_TYPE_ARM_PHYS_SHIFT_MASK;
+
+	/*
+	 * Make sure the size, if specified, is within the range of
+	 * default size and supported maximum limit.
+	 */
+	if (ipa_shift) {
+		if (ipa_shift < KVM_PHYS_SHIFT || ipa_shift > kvm_ipa_limit)
+			return -EINVAL;
+	} else {
+		ipa_shift = KVM_PHYS_SHIFT;
+	}
+
+	kvm_config_stage2(kvm, ipa_shift);
+	return 0;
+}
+
 /**
  * kvm_arch_init_vm - initializes a VM data structure
  * @kvm:	pointer to the KVM struct
@@ -118,8 +137,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int ret, cpu;
 
-	if (type)
-		return -EINVAL;
+	ret = kvm_arch_config_vm(kvm, type);
+	if (ret)
+		return ret;
 
 	kvm->arch.last_vcpu_ran = alloc_percpu(typeof(*kvm->arch.last_vcpu_ran));
 	if (!kvm->arch.last_vcpu_ran)
-- 
2.7.4
