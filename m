Return-Path: <SRS0=E56M=ET=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B236DC63777
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 18:26:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3992A2074B
	for <kvmarm@archiver.kernel.org>; Fri, 13 Nov 2020 18:26:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="vRjTGm0w"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3992A2074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA3074B6C2;
	Fri, 13 Nov 2020 13:26:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0QJIdnosOPBW; Fri, 13 Nov 2020 13:26:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD0174B8E9;
	Fri, 13 Nov 2020 13:26:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C6194B615
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 13:26:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v3KKZ3GM7O0T for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Nov 2020 13:26:20 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 205D84B5DB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2020 13:26:20 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2EE79206C0;
 Fri, 13 Nov 2020 18:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605291979;
 bh=gqeOpdKIC8c1SEOYJyLabRdrjbnRjjbH5FwGDpMWGOQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=vRjTGm0w5ksgiKWhpZPBk8Iw73UMo9F5KrhDM5pYdk8Pmvks5rvNp2dysyszem9FK
 w/lnb98UIssw09HKfC63Gq0xnCw16YlPNv4TJfyy4AlLLSdHscFkwG9ybD9LHCzAaI
 +RpoJre0QM00caLy/IcpWy4o+Mz7t/1o1Bn6bGRg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kddm5-00APrY-F5; Fri, 13 Nov 2020 18:26:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 4/8] KVM: arm64: Inject UNDEF on PMU access when no PMU
 configured
Date: Fri, 13 Nov 2020 18:25:58 +0000
Message-Id: <20201113182602.471776-5-maz@kernel.org>
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

The ARMv8 architecture says that in the absence of FEAT_PMUv3,
all the PMU-related register generate an UNDEF. Let's make
sure that all our PMU handers catch this case by hooking into
check_pmu_access_disabled(), and add checks in a couple of
other places.

Note that we still cannot deliver an exception into the guest
as the offending cases are already caught by the RAZ/WI handling.
But this puts us one step away to architectural compliance.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6629cfde2838..b098d667bb42 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -609,8 +609,9 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
 {
 	u64 reg = __vcpu_sys_reg(vcpu, PMUSERENR_EL0);
-	bool enabled = (reg & flags) || vcpu_mode_priv(vcpu);
+	bool enabled = kvm_vcpu_has_pmu(vcpu);
 
+	enabled &= (reg & flags) || vcpu_mode_priv(vcpu);
 	if (!enabled)
 		kvm_inject_undefined(vcpu);
 
@@ -857,10 +858,8 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!kvm_arm_pmu_v3_ready(vcpu))
 		return trap_raz_wi(vcpu, p, r);
 
-	if (!vcpu_mode_priv(vcpu)) {
-		kvm_inject_undefined(vcpu);
+	if (check_pmu_access_disabled(vcpu, 0))
 		return false;
-	}
 
 	if (p->is_write) {
 		u64 val = p->regval & mask;
@@ -928,6 +927,11 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!kvm_arm_pmu_v3_ready(vcpu))
 		return trap_raz_wi(vcpu, p, r);
 
+	if (!kvm_vcpu_has_pmu(vcpu)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
 	if (p->is_write) {
 		if (!vcpu_mode_priv(vcpu)) {
 			kvm_inject_undefined(vcpu);
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
