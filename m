Return-Path: <SRS0=vHWX=7L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FAEC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 16:03:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D789207BC
	for <kvmarm@archiver.kernel.org>; Fri, 29 May 2020 16:03:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="zAVOOYYA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D789207BC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 271294B282;
	Fri, 29 May 2020 12:03:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vOphK8e10i-w; Fri, 29 May 2020 12:03:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B89044B2AE;
	Fri, 29 May 2020 12:03:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A4EF4B21E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 12:03:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o8z+77IRsQ26 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 May 2020 12:03:47 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C1574B2B2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2020 12:03:47 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 29F6A20C09;
 Fri, 29 May 2020 16:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1590768226;
 bh=rWnup0IH1825PzySVnOY4g/uJduuMESktYe3lmuCQC4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=zAVOOYYA8KUlpCoNWPrM1sWObbObksqJv1j1FQx+7DZRXy8cnZlW4tqTIkCcuBnPh
 lZ+3s64dAAPSfinsLhFXS30++QmQQw+aYgwf/QJIGwTRXUtDx6/TIuGZYFfdzSh5TX
 SMVbuiTz1J6w4DQLoeLJ82oh+EarRkaHbOmMijkc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jehSN-00GJKc-Or; Fri, 29 May 2020 17:02:03 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 22/24] KVM: arm64: Don't use empty structures as CPU reset
 state
Date: Fri, 29 May 2020 17:01:19 +0100
Message-Id: <20200529160121.899083-23-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529160121.899083-1-maz@kernel.org>
References: <20200529160121.899083-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 ascull@google.com, ardb@kernel.org, christoffer.dall@arm.com,
 dbrazdil@google.com, tabba@google.com, james.morse@arm.com, giangyi@amazon.com,
 zhukeqian1@huawei.com, mark.rutland@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Jiang Yi <giangyi@amazon.com>,
 Ard Biesheuvel <ardb@kernel.org>, linux-arm-kernel@lists.infradead.org
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

Keeping empty structure as the vcpu state initializer is slightly
wasteful: we only want to set pstate, and zero everything else.
Just do that.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/reset.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 658f3a79617b..865c8aa670bc 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -36,15 +36,11 @@ static u32 kvm_ipa_limit;
 /*
  * ARMv8 Reset Values
  */
-static const struct kvm_regs default_regs_reset = {
-	.regs.pstate = (PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT |
-			PSR_F_BIT | PSR_D_BIT),
-};
+#define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
+				 PSR_F_BIT | PSR_D_BIT)
 
-static const struct kvm_regs default_regs_reset32 = {
-	.regs.pstate = (PSR_AA32_MODE_SVC | PSR_AA32_A_BIT |
-			PSR_AA32_I_BIT | PSR_AA32_F_BIT),
-};
+#define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
+				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
 
 static bool cpu_has_32bit_el1(void)
 {
@@ -257,9 +253,9 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
  */
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
-	const struct kvm_regs *cpu_reset;
 	int ret = -EINVAL;
 	bool loaded;
+	u32 pstate;
 
 	/* Reset PMU outside of the non-preemptible section */
 	kvm_pmu_vcpu_reset(vcpu);
@@ -290,16 +286,17 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
 			if (!cpu_has_32bit_el1())
 				goto out;
-			cpu_reset = &default_regs_reset32;
+			pstate = VCPU_RESET_PSTATE_SVC;
 		} else {
-			cpu_reset = &default_regs_reset;
+			pstate = VCPU_RESET_PSTATE_EL1;
 		}
 
 		break;
 	}
 
 	/* Reset core registers */
-	memcpy(vcpu_gp_regs(vcpu), cpu_reset, sizeof(*cpu_reset));
+	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
+	vcpu_gp_regs(vcpu)->regs.pstate = pstate;
 
 	/* Reset system registers */
 	kvm_reset_sys_regs(vcpu);
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
