From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 2/4] KVM: arm64: Allow implementations to be confined to using
 VHE
Date: Mon,  5 Nov 2018 14:36:14 +0000
Message-ID: <20181105143617.120602-3-marc.zyngier@arm.com>
References: <20181105143617.120602-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12BDF4A322
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Nov 2018 09:36:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LEkHP3YTVk7n for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Nov 2018 09:36:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDE074A31E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Nov 2018 09:36:52 -0500 (EST)
In-Reply-To: <20181105143617.120602-1-marc.zyngier@arm.com>
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

Some implementations may be forced to use VHE to work around HW
errata, for example. Let's introduce a helper that checks for
these cases.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 1 +
 arch/arm64/include/asm/kvm_host.h | 6 ++++++
 virt/kvm/arm/arm.c                | 5 +++++
 3 files changed, 12 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index c3469729f40c..0f2f782548cb 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -286,6 +286,7 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
 static inline bool kvm_arch_sve_requires_vhe(void) { return false; }
+static inline bool kvm_arch_impl_requires_vhe(void) { return false; }
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ca1714148400..7d6e974d024a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -432,6 +432,12 @@ static inline bool kvm_arch_sve_requires_vhe(void)
 	return system_supports_sve();
 }
 
+static inline bool kvm_arch_impl_requires_vhe(void)
+{
+	/* Some implementations have defects that confine them to VHE */
+	return false;
+}
+
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 66de2efddfca..bc90a1cdd27f 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1647,6 +1647,11 @@ int kvm_arch_init(void *opaque)
 			kvm_pr_unimpl("SVE system without VHE unsupported.  Broken cpu?");
 			return -ENODEV;
 		}
+
+		if (kvm_arch_impl_requires_vhe()) {
+			kvm_pr_unimpl("CPU requiring VHE in non-VHE mode");
+			return -ENODEV;
+		}
 	}
 
 	for_each_online_cpu(cpu) {
-- 
2.19.1
