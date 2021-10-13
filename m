Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E07EC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 12:04:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0CA2A610D0
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 12:04:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0CA2A610D0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B61B04B121;
	Wed, 13 Oct 2021 08:04:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8eI3MRD7UwHy; Wed, 13 Oct 2021 08:04:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AAB44B153;
	Wed, 13 Oct 2021 08:04:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAF2A4B0D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:04:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3z7Cy01GO8uJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 08:04:02 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CCE444B11B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:04:01 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1FBDA610E5;
 Wed, 13 Oct 2021 12:04:01 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1maczH-00GTgY-D0; Wed, 13 Oct 2021 13:03:59 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v9 16/22] KVM: arm64: pkvm: Drop sysregs that should never be
 routed to the host
Date: Wed, 13 Oct 2021 13:03:40 +0100
Message-Id: <20211013120346.2926621-6-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211013120346.2926621-1-maz@kernel.org>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, will@kernel.org, james.morse@arm.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com,
 pbonzini@redhat.com, drjones@redhat.com, oupton@google.com, qperret@google.com,
 kernel-team@android.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, pbonzini@redhat.com, will@kernel.org
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

A bunch of system registers (most of them MM related) should never
trap to the host under any circumstance. Keep them close to our chest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 50 ------------------------------
 1 file changed, 50 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index e2b3a9e167da..eb4ee2589316 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -371,34 +371,8 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	AARCH64(SYS_ID_AA64MMFR1_EL1),
 	AARCH64(SYS_ID_AA64MMFR2_EL1),
 
-	HOST_HANDLED(SYS_SCTLR_EL1),
-	HOST_HANDLED(SYS_ACTLR_EL1),
-	HOST_HANDLED(SYS_CPACR_EL1),
-
-	HOST_HANDLED(SYS_RGSR_EL1),
-	HOST_HANDLED(SYS_GCR_EL1),
-
 	/* Scalable Vector Registers are restricted. */
 
-	HOST_HANDLED(SYS_TTBR0_EL1),
-	HOST_HANDLED(SYS_TTBR1_EL1),
-	HOST_HANDLED(SYS_TCR_EL1),
-
-	HOST_HANDLED(SYS_APIAKEYLO_EL1),
-	HOST_HANDLED(SYS_APIAKEYHI_EL1),
-	HOST_HANDLED(SYS_APIBKEYLO_EL1),
-	HOST_HANDLED(SYS_APIBKEYHI_EL1),
-	HOST_HANDLED(SYS_APDAKEYLO_EL1),
-	HOST_HANDLED(SYS_APDAKEYHI_EL1),
-	HOST_HANDLED(SYS_APDBKEYLO_EL1),
-	HOST_HANDLED(SYS_APDBKEYHI_EL1),
-	HOST_HANDLED(SYS_APGAKEYLO_EL1),
-	HOST_HANDLED(SYS_APGAKEYHI_EL1),
-
-	HOST_HANDLED(SYS_AFSR0_EL1),
-	HOST_HANDLED(SYS_AFSR1_EL1),
-	HOST_HANDLED(SYS_ESR_EL1),
-
 	RAZ_WI(SYS_ERRIDR_EL1),
 	RAZ_WI(SYS_ERRSELR_EL1),
 	RAZ_WI(SYS_ERXFR_EL1),
@@ -408,31 +382,12 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	RAZ_WI(SYS_ERXMISC0_EL1),
 	RAZ_WI(SYS_ERXMISC1_EL1),
 
-	HOST_HANDLED(SYS_TFSR_EL1),
-	HOST_HANDLED(SYS_TFSRE0_EL1),
-
-	HOST_HANDLED(SYS_FAR_EL1),
-	HOST_HANDLED(SYS_PAR_EL1),
-
 	/* Performance Monitoring Registers are restricted. */
 
-	HOST_HANDLED(SYS_MAIR_EL1),
-	HOST_HANDLED(SYS_AMAIR_EL1),
-
 	/* Limited Ordering Regions Registers are restricted. */
 
-	HOST_HANDLED(SYS_VBAR_EL1),
-	HOST_HANDLED(SYS_DISR_EL1),
-
 	/* GIC CPU Interface registers are restricted. */
 
-	HOST_HANDLED(SYS_CONTEXTIDR_EL1),
-	HOST_HANDLED(SYS_TPIDR_EL1),
-
-	HOST_HANDLED(SYS_SCXTNUM_EL1),
-
-	HOST_HANDLED(SYS_CNTKCTL_EL1),
-
 	HOST_HANDLED(SYS_CCSIDR_EL1),
 	HOST_HANDLED(SYS_CLIDR_EL1),
 	HOST_HANDLED(SYS_CSSELR_EL1),
@@ -440,11 +395,6 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 
 	/* Performance Monitoring Registers are restricted. */
 
-	HOST_HANDLED(SYS_TPIDR_EL0),
-	HOST_HANDLED(SYS_TPIDRRO_EL0),
-
-	HOST_HANDLED(SYS_SCXTNUM_EL0),
-
 	/* Activity Monitoring Registers are restricted. */
 
 	HOST_HANDLED(SYS_CNTP_TVAL_EL0),
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
