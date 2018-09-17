From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v5 16/18] kvm: arm64: Set a limit on the IPA size
Date: Mon, 17 Sep 2018 11:41:38 +0100
Message-ID: <20180917104144.19188-17-suzuki.poulose@arm.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180917104144.19188-1-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, cdall@kernel.org, eric.auger@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, catalin.marinas@arm.com, james.morse@arm.com, dave.martin@arm.com, julien.grall@arm.com, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

So far we have restricted the IPA size of the VM to the default
value (40bits). Now that we can manage the IPA size per VM and
support dynamic stage2 page tables, we can allow VMs to have
larger IPA. This patch introduces a the maximum IPA size
supported on the host. This is decided by the following factors :

 1) Maximum PARange supported by the CPUs - This can be inferred
    from the system wide safe value.
 2) Maximum PA size supported by the host kernel (48 vs 52)
 3) Number of levels in the host page table (as we base our
    stage2 tables on the host table helpers).

Since the stage2 page table code is dependent on the stage1
page table, we always ensure that :

  Number of Levels at Stage1 >= Number of Levels at Stage2

So we limit the IPA to make sure that the above condition
is satisfied. This will affect the following combinations
of VA_BITS and IPA for different page sizes.

  Host configuration | Unsupported IPA ranges
  39bit VA, 4K       | [44, 48]
  36bit VA, 16K      | [41, 48]
  42bit VA, 64K      | [47, 52]

Supporting the above combinations need independent stage2
page table manipulation code, which would need substantial
changes. We could purse the solution independently and
switch the page table code once we have it ready.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since V2:
 - Restrict the IPA size to limit the number of page table
   levels in stage2 to that of stage1 or less.
---
 arch/arm/include/asm/kvm_mmu.h    |  2 ++
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/reset.c            | 43 +++++++++++++++++++++++++++++++
 virt/kvm/arm/arm.c                |  2 ++
 4 files changed, 49 insertions(+)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 12ae5fbbcf01..5ad1a54f98dc 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -358,6 +358,8 @@ static inline int hyp_map_aux_data(void)
 
 #define kvm_phys_to_vttbr(addr)		(addr)
 
+static inline void kvm_set_ipa_limit(void) {}
+
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* __ARM_KVM_MMU_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5ecd457bce7d..f0474061851d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -513,6 +513,8 @@ static inline int kvm_arm_have_ssbd(void)
 void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu);
 void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu);
 
+void kvm_set_ipa_limit(void);
+
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
 void kvm_arch_free_vm(struct kvm *kvm);
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 51ecf0f7c912..76972b19bdd7 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -34,6 +34,9 @@
 #include <asm/kvm_coproc.h>
 #include <asm/kvm_mmu.h>
 
+/* Maximum phys_shift supported for any VM on this host */
+static u32 kvm_ipa_limit;
+
 /*
  * ARMv8 Reset Values
  */
@@ -135,6 +138,46 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	return kvm_timer_vcpu_reset(vcpu);
 }
 
+void kvm_set_ipa_limit(void)
+{
+	unsigned int ipa_max, va_max, parange;
+
+	parange = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1) & 0x7;
+	ipa_max = id_aa64mmfr0_parange_to_phys_shift(parange);
+
+	/* Raise the limit to the default size for backward compatibility */
+	if (ipa_max < KVM_PHYS_SHIFT) {
+		WARN_ONCE(1,
+			  "PARange is %d bits, unsupported configuration!",
+			  ipa_max);
+		ipa_max = KVM_PHYS_SHIFT;
+	}
+
+	/* Clamp it to the PA size supported by the kernel */
+	ipa_max = (ipa_max > PHYS_MASK_SHIFT) ? PHYS_MASK_SHIFT : ipa_max;
+	/*
+	 * Since our stage2 table is dependent on the stage1 page table code,
+	 * we must always honor the following condition:
+	 *
+	 *  Number of levels in Stage1 >= Number of levels in Stage2.
+	 *
+	 * So clamp the ipa limit further down to limit the number of levels.
+	 * Since we can concatenate upto 16 tables at entry level, we could
+	 * go upto 4bits above the maximum VA addressible with the current
+	 * number of levels.
+	 */
+	va_max = PGDIR_SHIFT + PAGE_SHIFT - 3;
+	va_max += 4;
+
+	if (va_max < ipa_max) {
+		kvm_info("Limiting IPA limit to %dbytes due to host VA bits limitation\n",
+			 va_max);
+		ipa_max = va_max;
+	}
+
+	kvm_ipa_limit = ipa_max;
+}
+
 /*
  * Configure the VTCR_EL2 for this VM. The VTCR value is common
  * across all the physical CPUs on the system. We use system wide
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 43e716bc3f08..631f9a3ad99a 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1413,6 +1413,8 @@ static int init_common_resources(void)
 	kvm_vmid_bits = kvm_get_vmid_bits();
 	kvm_info("%d-bit VMID\n", kvm_vmid_bits);
 
+	kvm_set_ipa_limit();
+
 	return 0;
 }
 
-- 
2.19.0
