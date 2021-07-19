Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14BB3C12002
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 12:39:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B7D6161164
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 12:39:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7D6161164
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AF234B090;
	Mon, 19 Jul 2021 08:39:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MCQ3qn2-5EoV; Mon, 19 Jul 2021 08:39:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F8D74B0C5;
	Mon, 19 Jul 2021 08:39:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C96584A4A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 08:39:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uqKf3wwCUeM7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 08:39:41 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C1E54A193
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 08:39:41 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id BA2806115B;
 Mon, 19 Jul 2021 12:39:40 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1m5SYd-00ED65-6Q; Mon, 19 Jul 2021 13:39:39 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 2/4] KVM: arm64: Drop unnecessary masking of PMU registers
Date: Mon, 19 Jul 2021 13:39:00 +0100
Message-Id: <20210719123902.1493805-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210719123902.1493805-1-maz@kernel.org>
References: <20210719123902.1493805-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, alexandre.chartre@oracle.com, robin.murphy@arm.com,
 drjones@redhat.com, linux@arm.linux.org.uk, kernel-team@android.com,
 rmk+kernel@armlinux.org.uk
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Robin Murphy <robin.murphy@arm.com>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Russell King <linux@arm.linux.org.uk>
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

We always sanitise our PMU sysreg on the write side, so there
is no need to do it on the read side as well.

Drop the unnecessary masking.

Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 3 +--
 arch/arm64/kvm/sys_regs.c | 6 +++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index f33825c995cb..fae4e95b586c 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -373,7 +373,6 @@ static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
 		reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
 		reg &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 		reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
-		reg &= kvm_pmu_valid_counter_mask(vcpu);
 	}
 
 	return reg;
@@ -569,7 +568,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 
 	if (val & ARMV8_PMU_PMCR_E) {
 		kvm_pmu_enable_counter_mask(vcpu,
-		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask);
+		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
 	} else {
 		kvm_pmu_disable_counter_mask(vcpu, mask);
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 96bdfa0e68b2..f22139658e48 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -880,7 +880,7 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			kvm_pmu_disable_counter_mask(vcpu, val);
 		}
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
+		p->regval = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 	}
 
 	return true;
@@ -904,7 +904,7 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			/* accessing PMINTENCLR_EL1 */
 			__vcpu_sys_reg(vcpu, PMINTENSET_EL1) &= ~val;
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMINTENSET_EL1) & mask;
+		p->regval = __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
 	}
 
 	return true;
@@ -926,7 +926,7 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			/* accessing PMOVSCLR_EL0 */
 			__vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= ~(p->regval & mask);
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMOVSSET_EL0) & mask;
+		p->regval = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
 	}
 
 	return true;
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
