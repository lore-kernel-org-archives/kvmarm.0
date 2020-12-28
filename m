Return-Path: <SRS0=gyiM=GA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5945AC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 28 Dec 2020 10:50:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 08B9022583
	for <kvmarm@archiver.kernel.org>; Mon, 28 Dec 2020 10:50:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08B9022583
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B47EB4B22C;
	Mon, 28 Dec 2020 05:50:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mKoX9wPt4g3t; Mon, 28 Dec 2020 05:50:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFC144B24C;
	Mon, 28 Dec 2020 05:50:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A7CE4B226
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Dec 2020 05:50:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3fgYa1SF+iyt for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Dec 2020 05:50:08 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BFE44B21F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Dec 2020 05:50:08 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id BD52E22A84;
 Mon, 28 Dec 2020 10:50:07 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1ktq6I-0048wX-0Z; Mon, 28 Dec 2020 10:50:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH 06/17] arm64: Move VHE-specific SPE setup to mutate_to_vhe()
Date: Mon, 28 Dec 2020 10:49:47 +0000
Message-Id: <20201228104958.1848833-7-maz@kernel.org>
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

There isn't much that a VHE kernel needs on top of whatever has
been done for nVHE, so let's move the little we need to the
VHE stub (the SPE setup), and drop the init_el2_state macro.

No expected functional change.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/hyp-stub.S | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index effa9c858014..5d19cba654c7 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -92,9 +92,6 @@ SYM_CODE_START_LOCAL(mutate_to_vhe)
 	msr	hcr_el2, x0
 	isb
 
-	// Doesn't do much on VHE, but still, worth a shot
-	init_el2_state vhe
-
 	// Use the EL1 allocated stack, per-cpu offset
 	mrs	x0, sp_el1
 	mov	sp, x0
@@ -107,6 +104,26 @@ SYM_CODE_START_LOCAL(mutate_to_vhe)
 	mrs_s	x0, SYS_VBAR_EL12
 	msr	vbar_el1, x0
 
+	// Fixup SPE configuration
+	mrs	x1, id_aa64dfr0_el1
+	ubfx	x1, x1, #ID_AA64DFR0_PMSVER_SHIFT, #4
+	mov	x2, #MDCR_EL2_TPMS
+	csel	x2, xzr, x2, eq
+	cbz	x1, skip_spe
+
+	// Let the SPE driver in control of the sampling
+	mrs_s	x0, SYS_PMSCR_EL1
+	bic	x0, x0, #(1 << SYS_PMSCR_EL2_PCT_SHIFT)
+	bic	x0, x0, #(1 << SYS_PMSCR_EL2_PA_SHIFT)
+	msr_s	SYS_PMSCR_EL1, x0
+
+skip_spe:
+	// For VHE, use EL2 translation and disable access from EL1
+	mrs	x0, mdcr_el2
+	bic	x0, x0, #(MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT)
+	orr	x0, x0, x2
+	msr	mdcr_el2, x0
+
 	// Transfert the MM state from EL1 to EL2
 	mrs_s	x0, SYS_TCR_EL12
 	msr	tcr_el1, x0
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
