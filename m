Return-Path: <SRS0=+U1N=EQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 696E3C56201
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 13:36:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC4C421D40
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 13:36:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="dvyQyJF4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC4C421D40
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7FFE4B9B4;
	Tue, 10 Nov 2020 08:36:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wvx4p0PsjX+I; Tue, 10 Nov 2020 08:36:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B59EC4B993;
	Tue, 10 Nov 2020 08:36:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 175934B989
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 08:36:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HfB-R3PXCskP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Nov 2020 08:36:31 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2511B4B869
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 08:36:31 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E209220797;
 Tue, 10 Nov 2020 13:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605015390;
 bh=UGunF+n2Tlt0+f7UsAUfC3s0o6hjEqARAiJkLJ6vA5U=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=dvyQyJF4QHUvQA1NA6ddifwbuuMbIM41NuMC4GA1RwtS9VUVTWmryxQPloi0VySPY
 76T85oHrChx5xAXgQlEIWH6XPhY5nlIAGpA21K3l26SacvLh+dKcUUF64dWSdylj2/
 e6JoiG6B4uhGtKmHGASsU67NFOMAJvJivAVfFVYI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kcToy-009SZy-1d; Tue, 10 Nov 2020 13:36:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 1/9] KVM: arm64: Introduce handling of AArch32 TTBCR2 traps
Date: Tue, 10 Nov 2020 13:36:11 +0000
Message-Id: <20201110133619.451157-2-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110133619.451157-1-maz@kernel.org>
References: <20201110133619.451157-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com,
 stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, stable@vger.kernel.org
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

ARMv8.2 introduced TTBCR2, which shares TCR_EL1 with TTBCR.
Gracefully handle traps to this register when HCR_EL2.TVM is set.

Cc: stable@vger.kernel.org
Reported-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/sys_regs.c         | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7a1faf917f3c..803cb2427b54 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -212,6 +212,7 @@ enum vcpu_sysreg {
 #define c2_TTBR1	(TTBR1_EL1 * 2)	/* Translation Table Base Register 1 */
 #define c2_TTBR1_high	(c2_TTBR1 + 1)	/* TTBR1 top 32 bits */
 #define c2_TTBCR	(TCR_EL1 * 2)	/* Translation Table Base Control R. */
+#define c2_TTBCR2	(c2_TTBCR + 1)	/* Translation Table Base Control R. 2 */
 #define c3_DACR		(DACR32_EL2 * 2)/* Domain Access Control Register */
 #define c5_DFSR		(ESR_EL1 * 2)	/* Data Fault Status Register */
 #define c5_IFSR		(IFSR32_EL2 * 2)/* Instruction Fault Status Register */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 26c7c25f8a6d..afdf18d694cb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1925,6 +1925,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 0), access_vm_reg, NULL, c2_TTBR0 },
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 1), access_vm_reg, NULL, c2_TTBR1 },
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 2), access_vm_reg, NULL, c2_TTBCR },
+	{ Op1( 0), CRn( 2), CRm( 0), Op2( 3), access_vm_reg, NULL, c2_TTBCR2 },
 	{ Op1( 0), CRn( 3), CRm( 0), Op2( 0), access_vm_reg, NULL, c3_DACR },
 	{ Op1( 0), CRn( 5), CRm( 0), Op2( 0), access_vm_reg, NULL, c5_DFSR },
 	{ Op1( 0), CRn( 5), CRm( 0), Op2( 1), access_vm_reg, NULL, c5_IFSR },
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
