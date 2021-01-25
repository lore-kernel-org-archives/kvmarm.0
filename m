Return-Path: <SRS0=+Nyp=G4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39800C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 10:54:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9CD1522DD6
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 10:53:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CD1522DD6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E8734B5E7;
	Mon, 25 Jan 2021 05:53:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B+gREC-0r0qo; Mon, 25 Jan 2021 05:53:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 148274B5AF;
	Mon, 25 Jan 2021 05:53:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 885294B5E6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 05:53:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7jTJE8dkyLWc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2021 05:53:55 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 742394B5C3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 05:53:55 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7429E22D58;
 Mon, 25 Jan 2021 10:53:54 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l3zS8-009rDe-CR; Mon, 25 Jan 2021 10:50:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
Subject: [PATCH v5 14/21] arm64: Honor VHE being disabled from the command-line
Date: Mon, 25 Jan 2021 10:50:12 +0000
Message-Id: <20210125105019.2946057-15-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210125105019.2946057-1-maz@kernel.org>
References: <20210125105019.2946057-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 dbrazdil@google.com, alexandru.elisei@arm.com, ardb@kernel.org,
 jingzhangos@google.com, pajay@qti.qualcomm.com, psodagud@codeaurora.org,
 sramana@codeaurora.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Ajay Patil <pajay@qti.qualcomm.com>,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>
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

Finally we can check whether VHE is disabled on the command line,
and not enable it if that's the user's wish.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kernel/asm-offsets.c |  3 +++
 arch/arm64/kernel/hyp-stub.S    | 11 +++++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index f42fd9e33981..1add0f21bffe 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -99,6 +99,9 @@ int main(void)
   DEFINE(CPU_BOOT_STACK,	offsetof(struct secondary_data, stack));
   DEFINE(CPU_BOOT_TASK,		offsetof(struct secondary_data, task));
   BLANK();
+  DEFINE(FTR_OVR_VAL_OFFSET,	offsetof(struct arm64_ftr_override, val));
+  DEFINE(FTR_OVR_MASK_OFFSET,	offsetof(struct arm64_ftr_override, mask));
+  BLANK();
 #ifdef CONFIG_KVM
   DEFINE(VCPU_CONTEXT,		offsetof(struct kvm_vcpu, arch.ctxt));
   DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 6b5c73cf9d52..aa7e8d592295 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -87,6 +87,17 @@ SYM_CODE_START_LOCAL(mutate_to_vhe)
 	ubfx	x1, x1, #ID_AA64MMFR1_VHE_SHIFT, #4
 	cbz	x1, 1f
 
+	// Check whether VHE is disabled from the command line
+	adr_l	x1, id_aa64mmfr1_override
+	ldr	x2, [x1, FTR_OVR_VAL_OFFSET]
+	ldr	x1, [x1, FTR_OVR_MASK_OFFSET]
+	ubfx	x2, x2, #ID_AA64MMFR1_VHE_SHIFT, #4
+	ubfx	x1, x1, #ID_AA64MMFR1_VHE_SHIFT, #4
+	cmp	x1, xzr
+	and	x2, x2, x1
+	csinv	x2, x2, xzr, ne
+	cbz	x2, 1f
+
 	// Engage the VHE magic!
 	mov_q	x0, HCR_HOST_VHE_FLAGS
 	msr	hcr_el2, x0
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
