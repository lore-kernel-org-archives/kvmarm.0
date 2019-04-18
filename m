From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v2 09/14] KVM: arm64/sve: Simplify KVM_REG_ARM64_SVE_VLS array
 sizing
Date: Thu, 18 Apr 2019 17:07:06 +0100
Message-ID: <1555603631-8107-10-git-send-email-Dave.Martin@arm.com>
References: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CF954A51F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Apr 2019 12:08:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m94lwL9uTfKC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Apr 2019 12:08:19 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70C9F4A540
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Apr 2019 12:08:19 -0400 (EDT)
In-Reply-To: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
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

A complicated DIV_ROUND_UP() expression is currently written out
explicitly in multiple places in order to specify the size of the
bitmap exchanged with userspace to represent the value of the
KVM_REG_ARM64_SVE_VLS pseudo-register.

Userspace currently has no direct way to work this out either: for
documentation purposes, the size is just quoted as 8 u64s.

To make this more intuitive, this patch replaces these with a
single define, which is also exported to userspace as
KVM_ARM64_SVE_VLS_WORDS.

Since the number of words in a bitmap is just the index of the last
word used + 1, this patch expresses the bound that way instead.
This should make it clearer what is being expressed.

For userspace convenience, the minimum and maximum possible vector
lengths relevant to the KVM ABI are exposed to UAPI as
KVM_ARM64_SVE_VQ_MIN, KVM_ARM64_SVE_VQ_MAX.  Since the only direct
use for these at present is manipulation of KVM_REG_ARM64_SVE_VLS,
no corresponding _VL_ macros are defined.  They could be added
later if a need arises.

Since use of DIV_ROUND_UP() was the only reason for including
<linux/kernel.h> in guest.c, this patch also removes that #include.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 Documentation/virtual/kvm/api.txt | 10 ++++++----
 arch/arm64/include/uapi/asm/kvm.h |  5 +++++
 arch/arm64/kvm/guest.c            |  7 +++----
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 68509de..03df379 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2171,13 +2171,15 @@ and KVM_ARM_VCPU_FINALIZE for more information about this procedure.
 KVM_REG_ARM64_SVE_VLS is a pseudo-register that allows the set of vector
 lengths supported by the vcpu to be discovered and configured by
 userspace.  When transferred to or from user memory via KVM_GET_ONE_REG
-or KVM_SET_ONE_REG, the value of this register is of type __u64[8], and
-encodes the set of vector lengths as follows:
+or KVM_SET_ONE_REG, the value of this register is of type
+__u64[KVM_ARM64_SVE_VLS_WORDS], and encodes the set of vector lengths as
+follows:
 
-__u64 vector_lengths[8];
+__u64 vector_lengths[KVM_ARM64_SVE_VLS_WORDS];
 
 if (vq >= SVE_VQ_MIN && vq <= SVE_VQ_MAX &&
-    ((vector_lengths[(vq - 1) / 64] >> ((vq - 1) % 64)) & 1))
+    ((vector_lengths[(vq - KVM_ARM64_SVE_VQ_MIN) / 64] >>
+		((vq - KVM_ARM64_SVE_VQ_MIN) % 64)) & 1))
 	/* Vector length vq * 16 bytes supported */
 else
 	/* Vector length vq * 16 bytes not supported */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 2a04ef0..edd2db8 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -258,9 +258,14 @@ struct kvm_vcpu_events {
 	 KVM_REG_SIZE_U256 |						\
 	 ((i) & (KVM_ARM64_SVE_MAX_SLICES - 1)))
 
+#define KVM_ARM64_SVE_VQ_MIN __SVE_VQ_MIN
+#define KVM_ARM64_SVE_VQ_MAX __SVE_VQ_MAX
+
 /* Vector lengths pseudo-register: */
 #define KVM_REG_ARM64_SVE_VLS		(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
 					 KVM_REG_SIZE_U512 | 0xffff)
+#define KVM_ARM64_SVE_VLS_WORDS	\
+	((KVM_ARM64_SVE_VQ_MAX - KVM_ARM64_SVE_VQ_MIN) / 64 + 1)
 
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 73044e3..5bb909c 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -23,7 +23,6 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/nospec.h>
-#include <linux/kernel.h>
 #include <linux/kvm_host.h>
 #include <linux/module.h>
 #include <linux/stddef.h>
@@ -210,7 +209,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 #define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
 
 static bool vq_present(
-	const u64 (*const vqs)[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)],
+	const u64 (*const vqs)[KVM_ARM64_SVE_VLS_WORDS],
 	unsigned int vq)
 {
 	return (*vqs)[vq_word(vq)] & vq_mask(vq);
@@ -219,7 +218,7 @@ static bool vq_present(
 static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	unsigned int max_vq, vq;
-	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
+	u64 vqs[KVM_ARM64_SVE_VLS_WORDS];
 
 	if (!vcpu_has_sve(vcpu))
 		return -ENOENT;
@@ -243,7 +242,7 @@ static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	unsigned int max_vq, vq;
-	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
+	u64 vqs[KVM_ARM64_SVE_VLS_WORDS];
 
 	if (!vcpu_has_sve(vcpu))
 		return -ENOENT;
-- 
2.1.4
