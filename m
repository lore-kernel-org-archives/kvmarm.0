From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 03/14] KVM: arm: Make vcpu finalization stubs into inline
 functions
Date: Fri, 12 Apr 2019 17:28:07 +0100
Message-ID: <1555086498-26691-4-git-send-email-Dave.Martin@arm.com>
References: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 056C94A4B9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Apr 2019 12:29:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RSZK5gS3riqa for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Apr 2019 12:29:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91B814A4C1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Apr 2019 12:29:12 -0400 (EDT)
In-Reply-To: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The vcpu finalization stubs kvm_arm_vcpu_finalize() and
kvm_arm_vcpu_is_finalized() are currently #defines for ARM, which
limits the type-checking that the compiler can do at runtime.

The only reason for them to be #defines was to avoid reliance on
the definition of struct kvm_vcpu, which is not available here due
to circular #include problems.  However, because these are stubs
containing no code, they don't need the definition of struct
kvm_vcpu after all; only a declaration is needed (which is
available already).

So in the interests of cleanliness, this patch converts them to
inline functions.

No functional change.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm/include/asm/kvm_host.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index d956273..7feddac 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -412,7 +412,14 @@ static inline int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
 	return 0;
 }
 
-#define kvm_arm_vcpu_finalize(vcpu, what) (-EINVAL)
-#define kvm_arm_vcpu_is_finalized(vcpu) true
+static inline int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int what)
+{
+	return -EINVAL;
+}
+
+static inline bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
+{
+	return true;
+}
 
 #endif /* __ARM_KVM_HOST_H__ */
-- 
2.1.4
