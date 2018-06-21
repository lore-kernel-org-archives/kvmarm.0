From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 05/16] KVM: arm: Add arch init/uninit hooks
Date: Thu, 21 Jun 2018 15:57:29 +0100
Message-ID: <1529593060-542-6-git-send-email-Dave.Martin@arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 463E74A0DC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jun 2018 10:47:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7o44oL9udor0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jun 2018 10:46:48 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A8FB4A0EA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jun 2018 10:46:48 -0400 (EDT)
In-Reply-To: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
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

In preparation for adding support for SVE in guests on arm64, hooks
for allocating and freeing additional per-vcpu memory are needed.

kvm_arch_vcpu_setup() could be used for allocation, but this
function is not clearly balanced by un "unsetup" function, making
it unclear where memory allocated in this function should be freed.

To keep things simple, this patch defines backend hooks
kvm_arm_arch_vcpu_{,un}unint(), and plumbs them in appropriately.
The exusting kvm_arch_vcpu_init() function now calls
kvm_arm_arch_vcpu_init(), while an explicit kvm_arch_vcpu_uninit()
is added which current does nothing except to call
kvm_arm_arch_vcpu_uninit().

The backend functions are currently defined to do nothing.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm/include/asm/kvm_host.h   |  4 +++-
 arch/arm64/include/asm/kvm_host.h |  4 +++-
 virt/kvm/arm/arm.c                | 13 ++++++++++++-
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 1f1fe410..9b902b8 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -284,10 +284,12 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 static inline bool kvm_arch_check_sve_has_vhe(void) { return true; }
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
-static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
+static inline int kvm_arm_arch_vcpu_init(struct kvm_vcpu *vcpu) { return 0; }
+static inline void kvm_arm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
+
 static inline void kvm_arm_init_debug(void) {}
 static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 92d6e88..9671ddd 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -425,10 +425,12 @@ static inline bool kvm_arch_check_sve_has_vhe(void)
 
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
-static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
+static inline int kvm_arm_arch_vcpu_init(struct kvm_vcpu *vcpu) { return 0; }
+static inline void kvm_arm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
+
 void kvm_arm_init_debug(void);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 04e554c..66f15cc 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -345,6 +345,8 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
+	int ret;
+
 	/* Force users to call KVM_ARM_VCPU_INIT */
 	vcpu->arch.target = -1;
 	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
@@ -354,7 +356,16 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 	kvm_arm_reset_debug_ptr(vcpu);
 
-	return kvm_vgic_vcpu_init(vcpu);
+	ret = kvm_vgic_vcpu_init(vcpu);
+	if (ret)
+		return ret;
+
+	return kvm_arm_arch_vcpu_init(vcpu);
+}
+
+void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
+{
+	kvm_arm_arch_vcpu_uninit(vcpu);
 }
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
-- 
2.1.4
