Return-Path: <SRS0=LUtr=UU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E3EC43613
	for <kvmarm@archiver.kernel.org>; Fri, 21 Jun 2019 09:40:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4BEA921530
	for <kvmarm@archiver.kernel.org>; Fri, 21 Jun 2019 09:40:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4BEA921530
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 545C34A418;
	Fri, 21 Jun 2019 05:40:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B2sRzZcuB-J9; Fri, 21 Jun 2019 05:40:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E20354A520;
	Fri, 21 Jun 2019 05:40:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C352C4A369
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jun 2019 05:40:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u2VOQKLQPICL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Jun 2019 05:40:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87F094A567
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jun 2019 05:40:40 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51752142F;
 Fri, 21 Jun 2019 02:40:40 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F176A3F246;
 Fri, 21 Jun 2019 02:40:38 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 56/59] arm64: KVM: nv: Honor SCTLR_EL2.SPAN on entering vEL2
Date: Fri, 21 Jun 2019 10:38:40 +0100
Message-Id: <20190621093843.220980-57-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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

On entering vEL2, we must honor the SCTLR_EL2.SPAN bit so that
PSTATE.PAN reflect the expected setting.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/emulate-nested.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index c406fd688b9f..e37af2749b38 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -127,9 +127,11 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 static void enter_el2_exception(struct kvm_vcpu *vcpu, u64 esr_el2,
 				enum exception_type type)
 {
+	u64 spsr = *vcpu_cpsr(vcpu);
+
 	trace_kvm_inject_nested_exception(vcpu, esr_el2, type);
 
-	vcpu_write_sys_reg(vcpu, *vcpu_cpsr(vcpu), SPSR_EL2);
+	vcpu_write_sys_reg(vcpu, spsr, SPSR_EL2);
 	vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
 	vcpu_write_sys_reg(vcpu, esr_el2, ESR_EL2);
 
@@ -137,6 +139,15 @@ static void enter_el2_exception(struct kvm_vcpu *vcpu, u64 esr_el2,
 	/* On an exception, PSTATE.SP becomes 1 */
 	*vcpu_cpsr(vcpu) = PSR_MODE_EL2h;
 	*vcpu_cpsr(vcpu) |= PSR_A_BIT | PSR_F_BIT | PSR_I_BIT | PSR_D_BIT;
+
+	/*
+	 * If SPAN is clear, set the PAN bit on exception entry
+	 * if SPAN is set, copy the PAN bit across
+	 */
+	if (!(vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_EL1_SPAN))
+		*vcpu_cpsr(vcpu) |= PSR_PAN_BIT;
+	else
+		*vcpu_cpsr(vcpu) |= (spsr & PSR_PAN_BIT);
 }
 
 /*
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
