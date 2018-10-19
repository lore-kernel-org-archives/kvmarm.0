From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 16/26] kvm: arm64: Set a limit on the IPA size
Date: Fri, 19 Oct 2018 13:58:51 +0100
Message-ID: <20181019125901.185478-17-marc.zyngier@arm.com>
References: <20181019125901.185478-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C67B44A1FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 09:00:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9Aj6eZXaGxFE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Oct 2018 09:00:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6FAD4A0C9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 09:00:05 -0400 (EDT)
In-Reply-To: <20181019125901.185478-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: zhong jiang <zhongjiang@huawei.com>, kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Suzuki K Poulose <suzuki.poulose@arm.com>

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
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h    |  2 ++
 arch/arm64/include/asm/kvm_host.h | 12 +++------
 arch/arm64/kvm/reset.c            | 43 +++++++++++++++++++++++++++++++
 virt/kvm/arm/arm.c                |  2 ++
 4 files changed, 50 insertions(+), 9 deletions(-)

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
index 5ecd457bce7d..f008f8866b2a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -442,15 +442,7 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 			       struct kvm_device_attr *attr);
 
-static inline void __cpu_init_stage2(void)
-{
-	u32 ps;
-
-	/* Sanity check for minimum IPA size support */
-	ps = id_aa64mmfr0_parange_to_phys_shift(read_sysreg(id_aa64mmfr0_el1) & 0x7);
-	WARN_ONCE(ps < 40,
-		  "PARange is %d bits, unsupported configuration!", ps);
-}
+static inline void __cpu_init_stage2(void) {}
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
@@ -513,6 +505,8 @@ static inline int kvm_arm_have_ssbd(void)
 void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu);
 void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu);
 
+void kvm_set_ipa_limit(void);
+
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
 void kvm_arch_free_vm(struct kvm *kvm);
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 2bf41e007390..96b3f50101bc 100644
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
+	unsigned int ipa_max, pa_max, va_max, parange;
+
+	parange = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1) & 0x7;
+	pa_max = id_aa64mmfr0_parange_to_phys_shift(parange);
+
+	/* Clamp the IPA limit to the PA size supported by the kernel */
+	ipa_max = (pa_max > PHYS_MASK_SHIFT) ? PHYS_MASK_SHIFT : pa_max;
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
+	if (va_max < ipa_max)
+		ipa_max = va_max;
+
+	/*
+	 * If the final limit is lower than the real physical address
+	 * limit of the CPUs, report the reason.
+	 */
+	if (ipa_max < pa_max)
+		pr_info("kvm: Limiting the IPA size due to kernel %s Address limit\n",
+			(va_max < pa_max) ? "Virtual" : "Physical");
+
+	WARN(ipa_max < KVM_PHYS_SHIFT,
+	     "KVM IPA limit (%d bit) is smaller than default size\n", ipa_max);
+	kvm_ipa_limit = ipa_max;
+	kvm_info("IPA Size Limit: %dbits\n", kvm_ipa_limit);
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
2.19.1
