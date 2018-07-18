From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v4 17/20] kvm: arm64: Set a limit on the IPA size
Date: Wed, 18 Jul 2018 10:19:00 +0100
Message-ID: <1531905547-25478-18-git-send-email-suzuki.poulose@arm.com>
References: <1531905547-25478-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C35FE49F94
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Jul 2018 05:07:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f-njRv9sJp7Y for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Jul 2018 05:07:07 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A448449FAC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Jul 2018 05:07:06 -0400 (EDT)
In-Reply-To: <1531905547-25478-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, dave.martin@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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
 arch/arm/include/asm/kvm_mmu.h   |  5 +++++
 arch/arm64/include/asm/kvm_mmu.h | 40 ++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/arm.c               |  3 +++
 3 files changed, 48 insertions(+)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 84f0de7..79fd338 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -366,6 +366,11 @@ static inline int hyp_map_aux_data(void)
 
 #define kvm_phys_to_vttbr(addr)		(addr)
 
+static inline u32 kvm_get_ipa_limit(void)
+{
+	return KVM_PHYS_SHIFT;
+}
+
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* __ARM_KVM_MMU_H__ */
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 4d1219b..f7406f8 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -524,5 +524,45 @@ static inline u64 kvm_vttbr_baddr_mask(struct kvm *kvm)
 	return vttbr_baddr_mask(kvm_phys_shift(kvm), kvm_stage2_levels(kvm));
 }
 
+static inline u32 kvm_get_ipa_limit(void)
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
+	return ipa_max;
+}
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 21272dc..135d789 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -66,6 +66,7 @@ static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
 static u32 kvm_next_vmid;
 static unsigned int kvm_vmid_bits __read_mostly;
 static DEFINE_RWLOCK(kvm_vmid_lock);
+static u32 kvm_ipa_limit;
 
 static bool vgic_present;
 
@@ -1364,6 +1365,8 @@ static int init_common_resources(void)
 	kvm_vmid_bits = kvm_get_vmid_bits();
 	kvm_info("%d-bit VMID\n", kvm_vmid_bits);
 
+	kvm_ipa_limit = kvm_get_ipa_limit();
+
 	return 0;
 }
 
-- 
2.7.4
