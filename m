Return-Path: <SRS0=E56M=ET=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2126C63699
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 18:26:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7D0E7206C0
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 18:26:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="DGxzwWtJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D0E7206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 058B54B8E0;
	Fri, 13 Nov 2020 13:26:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u8gm1xX7JzbG; Fri, 13 Nov 2020 13:26:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 194E24BA45;
	Fri, 13 Nov 2020 13:26:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 047A44B614
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 13:26:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3IKjNX1imU+V for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Nov 2020 13:26:21 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A42824B67A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 13:26:20 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id AAF79221EB;
 Fri, 13 Nov 2020 18:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605291979;
 bh=Yx51wI58JGRn62g2bGeRn1X2FHxnhVrydxNbB/q3eTY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=DGxzwWtJ+CxNByPhOsw469cld85JR3Mj5D0y9F7l1g8NM2SgEvDCze5dI+hDmElmc
 8C0OyrXehvZOkpSZomWuDXu2wNBqRUcFIFMzbGVdhajwXHLsw8dvcyhnv+v8nck+G+
 jza3//kuSlw8VKsia9tX76bI7uVtAVx6mC/r3pws=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kddm5-00APrY-TT; Fri, 13 Nov 2020 18:26:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 5/8] KVM: arm64: Remove PMU RAZ/WI handling
Date: Fri, 13 Nov 2020 18:25:59 +0000
Message-Id: <20201113182602.471776-6-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113182602.471776-1-maz@kernel.org>
References: <20201113182602.471776-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 kernel-team@android.com
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

There is no RAZ/WI handling allowed for the PMU registers in the
ARMv8 architecture. Nobody can remember how we cam to the conclusion
that we could do this, but the ARMv8 ARM is pretty clear that we cannot.

Remove the RAZ/WI handling of the PMU system registers when it is
not configured.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b098d667bb42..3bd4cc40536b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -643,9 +643,6 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u64 val;
 
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
@@ -672,9 +669,6 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	if (pmu_access_event_counter_el0_disabled(vcpu))
 		return false;
 
@@ -693,9 +687,6 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u64 pmceid;
 
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	BUG_ON(p->is_write);
 
 	if (pmu_access_el0_disabled(vcpu))
@@ -728,9 +719,6 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 {
 	u64 idx;
 
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	if (r->CRn == 9 && r->CRm == 13) {
 		if (r->Op2 == 2) {
 			/* PMXEVCNTR_EL0 */
@@ -784,9 +772,6 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u64 idx, reg;
 
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
@@ -824,9 +809,6 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u64 val, mask;
 
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
@@ -855,9 +837,6 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
 
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	if (check_pmu_access_disabled(vcpu, 0))
 		return false;
 
@@ -882,9 +861,6 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
 
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
@@ -907,9 +883,6 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u64 mask;
 
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	if (!p->is_write)
 		return read_from_write_only(vcpu, p, r);
 
@@ -924,9 +897,6 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			     const struct sys_reg_desc *r)
 {
-	if (!kvm_arm_pmu_v3_ready(vcpu))
-		return trap_raz_wi(vcpu, p, r);
-
 	if (!kvm_vcpu_has_pmu(vcpu)) {
 		kvm_inject_undefined(vcpu);
 		return false;
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
