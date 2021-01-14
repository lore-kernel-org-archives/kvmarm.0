Return-Path: <SRS0=BtxD=GR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E3FCC433E9
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 10:56:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B04C523A59
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 10:56:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B04C523A59
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51F424B117;
	Thu, 14 Jan 2021 05:56:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1OXEBs7SLpTz; Thu, 14 Jan 2021 05:56:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5388C4B1C8;
	Thu, 14 Jan 2021 05:56:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 745154B16F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 05:56:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r7wJwXySe-0y for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jan 2021 05:56:53 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 666744B08F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 05:56:53 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7BA6E23A52;
 Thu, 14 Jan 2021 10:56:52 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l00J8-007Tvz-Ny; Thu, 14 Jan 2021 10:56:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 3/6] KVM: arm64: Add handling of AArch32 PCMEID{2,
 3} PMUv3 registers
Date: Thu, 14 Jan 2021 10:56:30 +0000
Message-Id: <20210114105633.2558739-4-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210114105633.2558739-1-maz@kernel.org>
References: <20210114105633.2558739-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, eric.auger@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

Despite advertising support for AArch32 PMUv3p1, we fail to handle
the PMCEID{2,3} registers, which conveniently alias with with the top
bits of PMCEID{0,1}_EL1.

Implement these registers with the usual AA32(HI/LO) aliasing
mechanism.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ce08d28ab15c..2bea0494b81d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -685,14 +685,18 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 pmceid;
+	u64 pmceid, mask, shift;
 
 	BUG_ON(p->is_write);
 
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
+	get_access_mask(r, &mask, &shift);
+
 	pmceid = kvm_pmu_get_pmceid(vcpu, (p->Op2 & 1));
+	pmceid &= mask;
+	pmceid >>= shift;
 
 	p->regval = pmceid;
 
@@ -1895,8 +1899,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), access_pmovs },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 4), access_pmswinc },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmselr },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
+	{ AA32(LO), Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
+	{ AA32(LO), Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), access_pmu_evcntr },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_evtyper },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_evcntr },
@@ -1904,6 +1908,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), access_pminten },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), access_pminten },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 3), access_pmovs },
+	{ AA32(HI), Op1( 0), CRn( 9), CRm(14), Op2( 4), access_pmceid },
+	{ AA32(HI), Op1( 0), CRn( 9), CRm(14), Op2( 5), access_pmceid },
 
 	/* PRRR/MAIR0 */
 	{ AA32(LO), Op1( 0), CRn(10), CRm( 2), Op2( 0), access_vm_reg, NULL, MAIR_EL1 },
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
