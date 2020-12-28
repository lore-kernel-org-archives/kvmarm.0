Return-Path: <SRS0=gyiM=GA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B55C433E6
	for <kvmarm@archiver.kernel.org>; Mon, 28 Dec 2020 10:50:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 22BA722AAA
	for <kvmarm@archiver.kernel.org>; Mon, 28 Dec 2020 10:50:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22BA722AAA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8E2E4B1FE;
	Mon, 28 Dec 2020 05:50:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G7PTA8g+jufI; Mon, 28 Dec 2020 05:50:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C2624B238;
	Mon, 28 Dec 2020 05:50:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A72A84B21E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Dec 2020 05:50:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EM3uvkCeWPuR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Dec 2020 05:50:07 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D99B4B203
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Dec 2020 05:50:07 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 768EB229EF;
 Mon, 28 Dec 2020 10:50:06 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1ktq6G-0048wX-OI; Mon, 28 Dec 2020 10:50:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH 04/17] arm64: Provide an 'upgrade to VHE' stub hypercall
Date: Mon, 28 Dec 2020 10:49:45 +0000
Message-Id: <20201228104958.1848833-5-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228104958.1848833-1-maz@kernel.org>
References: <20201228104958.1848833-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com, will@kernel.org,
 mark.rutland@arm.com, dbrazdil@google.com, alexandru.elisei@arm.com,
 ardb@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

As we are about to change the way a VHE system boots, let's
provide the core helper, in the form of a stub hypercall that
enables VHE and replicates the full EL1 context at EL2, thanks
to EL1 and VHE-EL2 being extremely similar.

On exception return, the kernel carries on at EL2. Fancy!

Nothing calls this new hypercall yet, so no functional change.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/virt.h |  7 +++-
 arch/arm64/kernel/hyp-stub.S  | 70 ++++++++++++++++++++++++++++++++++-
 2 files changed, 74 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index ee6a48df89d9..7379f35ae2c6 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -35,8 +35,13 @@
  */
 #define HVC_RESET_VECTORS 2
 
+/*
+ * HVC_VHE_RESTART - Upgrade the CPU from EL1 to EL2, if possible
+ */
+#define HVC_VHE_RESTART	3
+
 /* Max number of HYP stub hypercalls */
-#define HVC_STUB_HCALL_NR 3
+#define HVC_STUB_HCALL_NR 4
 
 /* Error returned when an invalid stub number is passed into x0 */
 #define HVC_STUB_ERR	0xbadca11
diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 160f5881a0b7..6ffdc1f7778b 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -8,9 +8,9 @@
 
 #include <linux/init.h>
 #include <linux/linkage.h>
-#include <linux/irqchip/arm-gic-v3.h>
 
 #include <asm/assembler.h>
+#include <asm/el2_setup.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/ptrace.h>
@@ -47,10 +47,16 @@ SYM_CODE_END(__hyp_stub_vectors)
 
 SYM_CODE_START_LOCAL(el1_sync)
 	cmp	x0, #HVC_SET_VECTORS
-	b.ne	2f
+	b.ne	1f
 	msr	vbar_el2, x1
 	b	9f
 
+1:	cmp	x0, #HVC_VHE_RESTART
+	b.ne	2f
+	mov	x0, #HVC_SOFT_RESTART
+	adr	x1, mutate_to_vhe
+	// fall through...
+
 2:	cmp	x0, #HVC_SOFT_RESTART
 	b.ne	3f
 	mov	x0, x2
@@ -70,6 +76,66 @@ SYM_CODE_START_LOCAL(el1_sync)
 	eret
 SYM_CODE_END(el1_sync)
 
+// nVHE? No way! Give me the real thing!
+SYM_CODE_START_LOCAL(mutate_to_vhe)
+	// Sanity check: MMU *must* be off
+	mrs	x0, sctlr_el2
+	tbnz	x0, #0, 1f
+
+	// Needs to be VHE capable, obviously
+	mrs	x0, id_aa64mmfr1_el1
+	ubfx	x0, x0, #ID_AA64MMFR1_VHE_SHIFT, #4
+	cbz	x0, 1f
+
+	// Engage the VHE magic!
+	mov_q	x0, HCR_HOST_VHE_FLAGS
+	msr	hcr_el2, x0
+	isb
+
+	// Doesn't do much on VHE, but still, worth a shot
+	init_el2_state vhe
+
+	// Use the EL1 allocated stack, per-cpu offset
+	mrs	x0, sp_el1
+	mov	sp, x0
+	mrs	x0, tpidr_el1
+	msr	tpidr_el2, x0
+
+	// FP configuration, vectors
+	mrs_s	x0, SYS_CPACR_EL12
+	msr	cpacr_el1, x0
+	mrs_s	x0, SYS_VBAR_EL12
+	msr	vbar_el1, x0
+
+	// Transfert the MM state from EL1 to EL2
+	mrs_s	x0, SYS_TCR_EL12
+	msr	tcr_el1, x0
+	mrs_s	x0, SYS_TTBR0_EL12
+	msr	ttbr0_el1, x0
+	mrs_s	x0, SYS_TTBR1_EL12
+	msr	ttbr1_el1, x0
+	mrs_s	x0, SYS_MAIR_EL12
+	msr	mair_el1, x0
+	isb
+
+	// Invalidate TLBs before enabling the MMU
+	tlbi	vmalle1
+	dsb	nsh
+
+	// Enable the EL2 S1 MMU, as set up from EL1
+	mrs_s	x0, SYS_SCTLR_EL12
+	set_sctlr_el1	x0
+
+	// Hack the exception return to stay at EL2
+	mrs	x0, spsr_el1
+	and	x0, x0, #~PSR_MODE_MASK
+	mov	x1, #PSR_MODE_EL2h
+	orr	x0, x0, x1
+	msr	spsr_el1, x0
+
+1:	eret
+SYM_CODE_END(mutate_to_vhe)
+
 .macro invalid_vector	label
 SYM_CODE_START_LOCAL(\label)
 	b \label
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
