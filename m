From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v2 05/23] KVM: arm: Add arch vcpu uninit hook
Date: Fri, 28 Sep 2018 14:39:09 +0100
Message-ID: <1538141967-15375-6-git-send-email-Dave.Martin@arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0316C4A20C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:40:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lw96B-5y+3ys for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Sep 2018 09:40:26 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 117A14A2AF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:40:25 -0400 (EDT)
In-Reply-To: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In preparation for adding support for SVE in guests on arm64, a
hook is needed for freeing additional per-vcpu memory when a vcpu
is freed.

x86 already uses the kvm_arch_vcpu_uninit() hook for a similar
purpose, so this patch populates the same hook for arm.  Since SVE
is specific to arm64, a subsidiary hook kvm_arm_arch_vcpu_uninit()
is added (with trivial implementations for now) to enable separate
specialisation for arm and arm64.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---

Changes since RFCv1:

 * The vcpu _init_ hook that was added by the former version of this
   patch was never used for anything, so it is gone from this version.
---
 arch/arm/include/asm/kvm_host.h   | 3 ++-
 arch/arm64/include/asm/kvm_host.h | 3 ++-
 virt/kvm/arm/arm.c                | 5 +++++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 3ad482d..c36760b 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -288,10 +288,11 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 static inline bool kvm_arch_check_sve_has_vhe(void) { return true; }
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
-static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
+static inline void kvm_arm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
+
 static inline void kvm_arm_init_debug(void) {}
 static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6316a57..d4b65414 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -425,10 +425,11 @@ static inline bool kvm_arch_check_sve_has_vhe(void)
 
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
-static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
+static inline void kvm_arm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
+
 void kvm_arm_init_debug(void);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index c92053b..1418af9 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -358,6 +358,11 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	return kvm_vgic_vcpu_init(vcpu);
 }
 
+void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
+{
+	kvm_arm_arch_vcpu_uninit(vcpu);
+}
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	int *last_ran;
-- 
2.1.4
