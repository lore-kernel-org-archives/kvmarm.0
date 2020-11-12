Return-Path: <SRS0=fMed=ES=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50688C56202
	for <kvmarm@archiver.kernel.org>; Thu, 12 Nov 2020 22:22:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B78E322201
	for <kvmarm@archiver.kernel.org>; Thu, 12 Nov 2020 22:22:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="PjMzCRkS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B78E322201
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45F234BCA3;
	Thu, 12 Nov 2020 17:22:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8xWUbspAEMmE; Thu, 12 Nov 2020 17:22:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24DA04BCB1;
	Thu, 12 Nov 2020 17:22:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E18164BCA0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Nov 2020 17:22:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FCRbNlPjvlp2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Nov 2020 17:22:39 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 930344BC9C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Nov 2020 17:22:39 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7F5012223F;
 Thu, 12 Nov 2020 22:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605219758;
 bh=yIyNzYSp3FSlBe1Z//Aks6DMYHCMzTJBN1m7gam8U40=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=PjMzCRkShuq1Dv4vUT7oqzgV0jiyKIE7lfDVaT4TyAuVvxdjoD29px7MLPhEXMN9w
 NrTn8SRK9EZR20dBph2oJFEuIU2urIUnq9BfPLFJ4gdk1bExZGvudOcWZxREXLlzhJ
 XDqUlh+eWGNgwHZoMEMCYXC2dtUd8tkg0WBLcfwo=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kdKzE-00ABHn-OE; Thu, 12 Nov 2020 22:22:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 2/3] KVM: arm64: Unify trap handlers injecting an UNDEF
Date: Thu, 12 Nov 2020 22:21:38 +0000
Message-Id: <20201112222139.466204-3-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201112222139.466204-1-maz@kernel.org>
References: <20201112222139.466204-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, liangpeng10@huawei.com, will@kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
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

A large number of system register trap handlers only inject an
UNDEF exeption, and yet each class of sysreg seems to provide its
own, identical function.

Let's unify them all, saving us introducing yet another one later.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20201110141308.451654-3-maz@kernel.org
---
 arch/arm64/kvm/sys_regs.c | 65 +++++++++++++++------------------------
 1 file changed, 25 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0aa86250e354..b0022f37c8f1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1038,8 +1038,8 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	{ SYS_DESC(SYS_PMEVTYPERn_EL0(n)),					\
 	  access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
 
-static bool access_amu(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
-			     const struct sys_reg_desc *r)
+static bool undef_access(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
 {
 	kvm_inject_undefined(vcpu);
 
@@ -1047,24 +1047,10 @@ static bool access_amu(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 }
 
 /* Macro to expand the AMU counter and type registers*/
-#define AMU_AMEVCNTR0_EL0(n) { SYS_DESC(SYS_AMEVCNTR0_EL0(n)), access_amu }
-#define AMU_AMEVTYPER0_EL0(n) { SYS_DESC(SYS_AMEVTYPER0_EL0(n)), access_amu }
-#define AMU_AMEVCNTR1_EL0(n) { SYS_DESC(SYS_AMEVCNTR1_EL0(n)), access_amu }
-#define AMU_AMEVTYPER1_EL0(n) { SYS_DESC(SYS_AMEVTYPER1_EL0(n)), access_amu }
-
-static bool trap_ptrauth(struct kvm_vcpu *vcpu,
-			 struct sys_reg_params *p,
-			 const struct sys_reg_desc *rd)
-{
-	/*
-	 * If we land here, that is because we didn't fixup the access on exit
-	 * by allowing the PtrAuth sysregs. The only way this happens is when
-	 * the guest does not have PtrAuth support enabled.
-	 */
-	kvm_inject_undefined(vcpu);
-
-	return false;
-}
+#define AMU_AMEVCNTR0_EL0(n) { SYS_DESC(SYS_AMEVCNTR0_EL0(n)), undef_access }
+#define AMU_AMEVTYPER0_EL0(n) { SYS_DESC(SYS_AMEVTYPER0_EL0(n)), undef_access }
+#define AMU_AMEVCNTR1_EL0(n) { SYS_DESC(SYS_AMEVCNTR1_EL0(n)), undef_access }
+#define AMU_AMEVTYPER1_EL0(n) { SYS_DESC(SYS_AMEVTYPER1_EL0(n)), undef_access }
 
 static unsigned int ptrauth_visibility(const struct kvm_vcpu *vcpu,
 			const struct sys_reg_desc *rd)
@@ -1072,8 +1058,14 @@ static unsigned int ptrauth_visibility(const struct kvm_vcpu *vcpu,
 	return vcpu_has_ptrauth(vcpu) ? 0 : REG_HIDDEN;
 }
 
+/*
+ * If we land here on a PtrAuth access, that is because we didn't
+ * fixup the access on exit by allowing the PtrAuth sysregs. The only
+ * way this happens is when the guest does not have PtrAuth support
+ * enabled.
+ */
 #define __PTRAUTH_KEY(k)						\
-	{ SYS_DESC(SYS_## k), trap_ptrauth, reset_unknown, k,		\
+	{ SYS_DESC(SYS_## k), undef_access, reset_unknown, k,		\
 	.visibility = ptrauth_visibility}
 
 #define PTRAUTH_KEY(k)							\
@@ -1374,13 +1366,6 @@ static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
-static bool access_mte_regs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
-			    const struct sys_reg_desc *r)
-{
-	kvm_inject_undefined(vcpu);
-	return false;
-}
-
 /* sys_reg_desc initialiser for known cpufeature ID registers */
 #define ID_SANITISED(name) {			\
 	SYS_DESC(SYS_##name),			\
@@ -1549,8 +1534,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
 	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
 
-	{ SYS_DESC(SYS_RGSR_EL1), access_mte_regs },
-	{ SYS_DESC(SYS_GCR_EL1), access_mte_regs },
+	{ SYS_DESC(SYS_RGSR_EL1), undef_access },
+	{ SYS_DESC(SYS_GCR_EL1), undef_access },
 
 	{ SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0, .visibility = sve_visibility },
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
@@ -1576,8 +1561,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_ERXMISC0_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_ERXMISC1_EL1), trap_raz_wi },
 
-	{ SYS_DESC(SYS_TFSR_EL1), access_mte_regs },
-	{ SYS_DESC(SYS_TFSRE0_EL1), access_mte_regs },
+	{ SYS_DESC(SYS_TFSR_EL1), undef_access },
+	{ SYS_DESC(SYS_TFSRE0_EL1), undef_access },
 
 	{ SYS_DESC(SYS_FAR_EL1), access_vm_reg, reset_unknown, FAR_EL1 },
 	{ SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },
@@ -1641,14 +1626,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_TPIDR_EL0), NULL, reset_unknown, TPIDR_EL0 },
 	{ SYS_DESC(SYS_TPIDRRO_EL0), NULL, reset_unknown, TPIDRRO_EL0 },
 
-	{ SYS_DESC(SYS_AMCR_EL0), access_amu },
-	{ SYS_DESC(SYS_AMCFGR_EL0), access_amu },
-	{ SYS_DESC(SYS_AMCGCR_EL0), access_amu },
-	{ SYS_DESC(SYS_AMUSERENR_EL0), access_amu },
-	{ SYS_DESC(SYS_AMCNTENCLR0_EL0), access_amu },
-	{ SYS_DESC(SYS_AMCNTENSET0_EL0), access_amu },
-	{ SYS_DESC(SYS_AMCNTENCLR1_EL0), access_amu },
-	{ SYS_DESC(SYS_AMCNTENSET1_EL0), access_amu },
+	{ SYS_DESC(SYS_AMCR_EL0), undef_access },
+	{ SYS_DESC(SYS_AMCFGR_EL0), undef_access },
+	{ SYS_DESC(SYS_AMCGCR_EL0), undef_access },
+	{ SYS_DESC(SYS_AMUSERENR_EL0), undef_access },
+	{ SYS_DESC(SYS_AMCNTENCLR0_EL0), undef_access },
+	{ SYS_DESC(SYS_AMCNTENSET0_EL0), undef_access },
+	{ SYS_DESC(SYS_AMCNTENCLR1_EL0), undef_access },
+	{ SYS_DESC(SYS_AMCNTENSET1_EL0), undef_access },
 	AMU_AMEVCNTR0_EL0(0),
 	AMU_AMEVCNTR0_EL0(1),
 	AMU_AMEVCNTR0_EL0(2),
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
