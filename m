From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 05/14] KVM: arm64/sve: Clean up UAPI register ID definitions
Date: Fri, 12 Apr 2019 17:28:09 +0100
Message-ID: <1555086498-26691-6-git-send-email-Dave.Martin@arm.com>
References: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C1B54A4BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Apr 2019 12:29:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6v989SMIQLi1 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Apr 2019 12:29:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81D974A4BC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Apr 2019 12:29:17 -0400 (EDT)
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

Currently, the SVE register ID macros are not all defined in the
same way, and advertise the fact that FFR maps onto the nonexistent
predicate register P16.  This is really just for kernel
convenience, and may lead userspace into bad habits.

Instead, this patch masks the ID macro arguments so that
architecturally invalid register numbers will not be passed through
any more, and uses a literal KVM_REG_ARM64_SVE_FFR_BASE macro to
define KVM_REG_ARM64_SVE_FFR(), similarly to the way the _ZREG()
and _PREG() macros are defined.

Rather than plugging in magic numbers for the number of Z- and P-
registers and the maximum possible number of register slices, this
patch provides definitions for those too.  Userspace is going to
need them in any case, and it makes sense for them to come from
<uapi/asm/kvm.h>.

sve_reg_to_region() uses convenience constants that are defined in
a different way, and also makes use of the fact that the FFR IDs
are really contiguous with the P15 IDs, so this patch retains the
existing convenience constants in guest.c, supplemented with a
couple of sanity checks to check for consistency with with the UAPI
header.

Fixes: e1c9c98345b3 ("KVM: arm64/sve: Add SVE support to register access ioctl interface")
Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h | 32 +++++++++++++++++++++++---------
 arch/arm64/kvm/guest.c            |  9 +++++++++
 2 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 6963b7e..2a04ef0 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -35,6 +35,7 @@
 #include <linux/psci.h>
 #include <linux/types.h>
 #include <asm/ptrace.h>
+#include <asm/sve_context.h>
 
 #define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_IRQ_LINE
@@ -233,16 +234,29 @@ struct kvm_vcpu_events {
 /* Z- and P-regs occupy blocks at the following offsets within this range: */
 #define KVM_REG_ARM64_SVE_ZREG_BASE	0
 #define KVM_REG_ARM64_SVE_PREG_BASE	0x400
+#define KVM_REG_ARM64_SVE_FFR_BASE	0x600
 
-#define KVM_REG_ARM64_SVE_ZREG(n, i)	(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
-					 KVM_REG_ARM64_SVE_ZREG_BASE |	\
-					 KVM_REG_SIZE_U2048 |		\
-					 ((n) << 5) | (i))
-#define KVM_REG_ARM64_SVE_PREG(n, i)	(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
-					 KVM_REG_ARM64_SVE_PREG_BASE |	\
-					 KVM_REG_SIZE_U256 |		\
-					 ((n) << 5) | (i))
-#define KVM_REG_ARM64_SVE_FFR(i)	KVM_REG_ARM64_SVE_PREG(16, i)
+#define KVM_ARM64_SVE_NUM_ZREGS		__SVE_NUM_ZREGS
+#define KVM_ARM64_SVE_NUM_PREGS		__SVE_NUM_PREGS
+
+#define KVM_ARM64_SVE_MAX_SLICES	32
+
+#define KVM_REG_ARM64_SVE_ZREG(n, i)					\
+	(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | KVM_REG_ARM64_SVE_ZREG_BASE | \
+	 KVM_REG_SIZE_U2048 |						\
+	 (((n) & (KVM_ARM64_SVE_NUM_ZREGS - 1)) << 5) |			\
+	 ((i) & (KVM_ARM64_SVE_MAX_SLICES - 1)))
+
+#define KVM_REG_ARM64_SVE_PREG(n, i)					\
+	(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | KVM_REG_ARM64_SVE_PREG_BASE | \
+	 KVM_REG_SIZE_U256 |						\
+	 (((n) & (KVM_ARM64_SVE_NUM_PREGS - 1)) << 5) |			\
+	 ((i) & (KVM_ARM64_SVE_MAX_SLICES - 1)))
+
+#define KVM_REG_ARM64_SVE_FFR(i)					\
+	(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | KVM_REG_ARM64_SVE_FFR_BASE | \
+	 KVM_REG_SIZE_U256 |						\
+	 ((i) & (KVM_ARM64_SVE_MAX_SLICES - 1)))
 
 /* Vector lengths pseudo-register: */
 #define KVM_REG_ARM64_SVE_VLS		(KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 4f7b26b..2e449e1 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -325,6 +325,15 @@ static int sve_reg_to_region(struct sve_state_reg_region *region,
 
 	size_t sve_state_size;
 
+	const u64 last_preg_id = KVM_REG_ARM64_SVE_PREG(SVE_NUM_PREGS - 1,
+							SVE_NUM_SLICES - 1);
+
+	/* Verify that the P-regs and FFR really do have contiguous IDs: */
+	BUILD_BUG_ON(KVM_REG_ARM64_SVE_FFR(0) != last_preg_id + 1);
+
+	/* Verify that we match the UAPI header: */
+	BUILD_BUG_ON(SVE_NUM_SLICES != KVM_ARM64_SVE_MAX_SLICES);
+
 	/* Only the first slice ever exists, for now: */
 	if ((reg->id & SVE_REG_SLICE_MASK) != 0)
 		return -ENOENT;
-- 
2.1.4
