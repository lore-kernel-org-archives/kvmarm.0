From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 2/8] KVM: arm64: Rework detection of SVE, !VHE systems
Date: Fri, 23 Nov 2018 18:41:01 +0000
Message-ID: <20181123184107.39334-3-marc.zyngier@arm.com>
References: <20181123184107.39334-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BEAE4A2AC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Nov 2018 13:41:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WsUgkzNKIwkb for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Nov 2018 13:41:20 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F1834A300
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Nov 2018 13:41:20 -0500 (EST)
In-Reply-To: <20181123184107.39334-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

An SVE system is so far the only case where we mandate VHE. As we're
starting to grow this requirements, let's slightly rework the way we
deal with that situation, allowing for easy extension of this check.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 2 +-
 arch/arm64/include/asm/kvm_host.h | 6 +++---
 virt/kvm/arm/arm.c                | 8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 5ca5d9af0c26..2184d9ddb418 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -285,7 +285,7 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
-static inline bool kvm_arch_check_sve_has_vhe(void) { return true; }
+static inline bool kvm_arch_requires_vhe(void) { return false; }
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 52fbc823ff8c..d6d9aa76a943 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -422,7 +422,7 @@ static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 	}
 }
 
-static inline bool kvm_arch_check_sve_has_vhe(void)
+static inline bool kvm_arch_requires_vhe(void)
 {
 	/*
 	 * The Arm architecture specifies that implementation of SVE
@@ -430,9 +430,9 @@ static inline bool kvm_arch_check_sve_has_vhe(void)
 	 * relies on this when SVE is present:
 	 */
 	if (system_supports_sve())
-		return has_vhe();
-	else
 		return true;
+
+	return false;
 }
 
 static inline void kvm_arch_hardware_unsetup(void) {}
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 23774970c9df..1db4c15edcdd 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1640,8 +1640,10 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
 
-	if (!kvm_arch_check_sve_has_vhe()) {
-		kvm_pr_unimpl("SVE system without VHE unsupported.  Broken cpu?");
+	in_hyp_mode = is_kernel_in_hyp_mode();
+
+	if (!in_hyp_mode && kvm_arch_requires_vhe()) {
+		kvm_pr_unimpl("CPU requiring VHE was booted in non-VHE mode");
 		return -ENODEV;
 	}
 
@@ -1657,8 +1659,6 @@ int kvm_arch_init(void *opaque)
 	if (err)
 		return err;
 
-	in_hyp_mode = is_kernel_in_hyp_mode();
-
 	if (!in_hyp_mode) {
 		err = init_hyp_mode();
 		if (err)
-- 
2.19.1
