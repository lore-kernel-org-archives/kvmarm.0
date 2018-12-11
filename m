From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v3 20/24] KVM: arm: Add support for early vcpu
 configuration ioctls
Date: Tue, 11 Dec 2018 23:28:57 +0000
Message-ID: <1544570941-7377-21-git-send-email-Dave.Martin@arm.com>
References: <1544570941-7377-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EF904A1DE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 18:30:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id stXHX4-9Xz9x for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 18:30:29 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A9BE4A1DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 18:30:29 -0500 (EST)
In-Reply-To: <1544570941-7377-1-git-send-email-Dave.Martin@arm.com>
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

SVE will require the KVM_ARM_SVE_CONFIG ioctl to be used early to
configure a vcpu before other arch vcpu ioctls will behave in a
consistent way.

To hide these effects from userspace while minimising mess in the
generic code, this patch splits arch vcpu ioctls into two phases:
early configuration ioctls, and normal ioctls.  A new arch helper
vcpu_needs_configuration() reports whether any arch vcpu ioctls
other than early configuration ioctls are allowed.

This entire behaviour will be need to be opt-in for userspace.

There are currently no early configuration ioctls; one will be
added for SVE in a subsequent patch, along with a suitable opt-in
mechanism.

It is assumed that no core vcpu ioctls are affected by any of the
early configuration we want to do.  In any case, most "generic"
vcpu ioctls are stubbed out for arm/arm64 and return -EINVAL.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

Changes since RFC v2:

 * New patch.

   **Discussion required**

   This patch splits arch vcpu ioctls into two phases.  We will
   almost certainly need to do something like this for SVE, since
   until the vector lengths are configured we will be in some kind
   of half-initialised state where most ioctls (in particular
   KVM_GET_REG_LIST, KVM_RUN etc.) cannot be used.

   This is a bit inelegant, and does not interact nicely with
   the core KVM core: we have to assume that all the core vcpu
   ioctls are "harmless" while a vcpu is half-initialised, or
   stubbed out (which seems to be the case for many of the core
   vcpu ioctls on arm/arm64).

   The choice of error codes here may not be ideal.  We should
   try to avoid picking anything that could be confused with other
   error situations.
---
 arch/arm/include/asm/kvm_host.h   | 3 +++
 arch/arm64/include/asm/kvm_host.h | 3 +++
 virt/kvm/arm/arm.c                | 6 ++++++
 3 files changed, 12 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 8d385ec..d61077c 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -365,4 +365,7 @@ static inline int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long *type)
 	return 0;
 }
 
+/* Forbid "ordinary" vcpu ioctls if this returns true: */
+#define vcpu_needs_configuration(vcpu) false
+
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9fd8729..7599c70 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -536,4 +536,7 @@ void kvm_arch_free_vm(struct kvm *kvm);
 
 int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long *type);
 
+/* Forbid "ordinary" vcpu ioctls if this returns true: */
+#define vcpu_needs_configuration(vcpu) false
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index f7bf43a..7bfc06d 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1090,6 +1090,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	struct kvm_device_attr attr;
 	long r;
 
+	/* Early configuration ioctls will be handled here */
+
+	/* Other ioctls require configuration to have been done first: */
+	if (vcpu_needs_configuration(vcpu))
+		return -EBADFD;
+
 	switch (ioctl) {
 	case KVM_ARM_VCPU_INIT: {
 		struct kvm_vcpu_init init;
-- 
2.1.4
