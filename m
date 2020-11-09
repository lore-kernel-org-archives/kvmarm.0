Return-Path: <SRS0=1ake=EP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11174C5517A
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 17:59:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 734DE20665
	for <kvmarm@archiver.kernel.org>; Mon,  9 Nov 2020 17:59:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="PO3krMRa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 734DE20665
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1835C4B911;
	Mon,  9 Nov 2020 12:59:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nI+zAUEtQhRK; Mon,  9 Nov 2020 12:59:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C43274B97E;
	Mon,  9 Nov 2020 12:59:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCD494B905
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 12:59:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ns24u2ApaOgd for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Nov 2020 12:59:32 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B27454B975
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Nov 2020 12:59:32 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id BAC4C21D7F;
 Mon,  9 Nov 2020 17:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604944771;
 bh=wJ6/BUTOMZrzU8+ZiMi/w3DAO5no+Zm2kiKxUJBo+Ko=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=PO3krMRa3GlFGVqRfOGFGuNXPncdCDVj544IUEu/Erc/J79RXgEvUrJ1XJ0Xv1Dql
 AKUKH6IN2aOIBe07mcnJNhH64gr2kmcpO2chVIGZMw0h8QqKI1qRMeICH+QuGoeCVc
 RiCOc9djjHrrB87RJC/uZe4Jav6XwKOnRfkOew50=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kcBRx-009BQs-Tx; Mon, 09 Nov 2020 17:59:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 4/5] KVM: arm64: Simplify __kvm_enable_ssbs()
Date: Mon,  9 Nov 2020 17:59:22 +0000
Message-Id: <20201109175923.445945-5-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201109175923.445945-1-maz@kernel.org>
References: <20201109175923.445945-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, ascull@google.com, will@kernel.org,
 qperret@google.com, ndesaulniers@google.com, dbrazdil@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 ndesaulniers@google.com
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

Move the setting of SSBS directly into the HVC handler, using
the C helpers rather than the inline asssembly code.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h    |  2 --
 arch/arm64/include/asm/sysreg.h     |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c  |  6 +++++-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c | 11 -----------
 4 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 54387ccd1ab2..a542c422a036 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -189,8 +189,6 @@ extern void __kvm_timer_set_cntvoff(u64 cntvoff);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
-extern void __kvm_enable_ssbs(void);
-
 extern u64 __vgic_v3_get_ich_vtr_el2(void);
 extern u64 __vgic_v3_read_vmcr(void);
 extern void __vgic_v3_write_vmcr(u32 vmcr);
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 174817ba119c..153faa15d490 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -461,6 +461,7 @@
 
 #define SYS_PMCCFILTR_EL0		sys_reg(3, 3, 14, 15, 7)
 
+#define SYS_SCTLR_EL2			sys_reg(3, 4, 1, 0, 0)
 #define SYS_ZCR_EL2			sys_reg(3, 4, 1, 2, 0)
 #define SYS_DACR32_EL2			sys_reg(3, 4, 3, 0, 0)
 #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index c0543b2e760e..82df7fc24760 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -58,7 +58,11 @@ static void handle___kvm_timer_set_cntvoff(struct kvm_cpu_context *host_ctxt)
 
 static void handle___kvm_enable_ssbs(struct kvm_cpu_context *host_ctxt)
 {
-	__kvm_enable_ssbs();
+	u64 tmp;
+
+	tmp = read_sysreg_el2(SYS_SCTLR);
+	tmp |= SCTLR_ELx_DSSBS;
+	write_sysreg_el2(tmp, SYS_SCTLR);
 }
 
 static void handle___vgic_v3_get_ich_vtr_el2(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
index 88a25fc8fcd3..29305022bc04 100644
--- a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
@@ -33,14 +33,3 @@ void __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
 	__sysreg_restore_user_state(ctxt);
 	__sysreg_restore_el2_return_state(ctxt);
 }
-
-void __kvm_enable_ssbs(void)
-{
-	u64 tmp;
-
-	asm volatile(
-	"mrs	%0, sctlr_el2\n"
-	"orr	%0, %0, %1\n"
-	"msr	sctlr_el2, %0"
-	: "=&r" (tmp) : "L" (SCTLR_ELx_DSSBS));
-}
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
