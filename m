Return-Path: <SRS0=yTkG=SO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79ACC10F0E
	for <kvmarm@archiver.kernel.org>; Fri, 12 Apr 2019 16:29:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 74885218CD
	for <kvmarm@archiver.kernel.org>; Fri, 12 Apr 2019 16:29:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 74885218CD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AF764A4BC;
	Fri, 12 Apr 2019 12:29:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AnUqIZ1ZAuT6; Fri, 12 Apr 2019 12:29:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C3A74A4CD;
	Fri, 12 Apr 2019 12:29:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C1B54A4BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Apr 2019 12:29:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6v989SMIQLi1 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Apr 2019 12:29:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81D974A4BC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Apr 2019 12:29:17 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E7CDF15AB;
 Fri, 12 Apr 2019 09:29:16 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D0A413F718;
 Fri, 12 Apr 2019 09:29:14 -0700 (PDT)
From: Dave Martin <Dave.Martin@arm.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 05/14] KVM: arm64/sve: Clean up UAPI register ID definitions
Date: Fri, 12 Apr 2019 17:28:09 +0100
Message-Id: <1555086498-26691-6-git-send-email-Dave.Martin@arm.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
References: <1555086498-26691-1-git-send-email-Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>,
 Christoffer Dall <cdall@kernel.org>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190412162809.EdQdqY7ZvTBJH5-5nVJeDOigZ1uiuxMMyqfUVB73IKg@z>

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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
