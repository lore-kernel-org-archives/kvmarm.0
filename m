Return-Path: <SRS0=+U1N=EQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED38C388F7
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 14:13:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C20F21D7F
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 14:13:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="UIAntKxn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C20F21D7F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A31AC4B9DE;
	Tue, 10 Nov 2020 09:13:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R7aw+bfOalde; Tue, 10 Nov 2020 09:13:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0128B4B998;
	Tue, 10 Nov 2020 09:13:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82DDC4B97C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 09:13:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RwOSFAZngPNn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Nov 2020 09:13:16 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 517CE4B8F4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 09:13:16 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5715921D46;
 Tue, 10 Nov 2020 14:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605017595;
 bh=cNXTfvwpG+aoxpUkFDuVhvxJc3m77/xVwcMKZuUo5IA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=UIAntKxnHKCxpZ7ztVHgcWN6tHbK/dVmRUrIJtpXWm2WQhB/Umg4/6ZAUD7lP8LoI
 9Ph4uLgIHXcUdz6/YbpgFcUEaJZBQYi6fSj2i5yEeQsm06D+kORQc+SH7yNpyGTmaZ
 acD/KDfivDLXi/pIZ7QGwJm+a5LmjzMOYMHD9MkQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kcUOX-009T8Q-Gx; Tue, 10 Nov 2020 14:13:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 2/3] KVM: arm64: Unify trap handlers injecting an UNDEF
Date: Tue, 10 Nov 2020 14:13:07 +0000
Message-Id: <20201110141308.451654-3-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110141308.451654-1-maz@kernel.org>
References: <20201110141308.451654-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, liangpeng10@huawei.com, will@kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com
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
---
 arch/arm64/kvm/sys_regs.c | 65 +++++++++++++++------------------------
 1 file changed, 25 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 24fdb6b9b6d3..6155285b2f9b 100644
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
 	return vcpu_has_ptrauth(vcpu) ? 0 : REG_HIDDEN_USER | REG_HIDDEN_GUEST;
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
@@ -1417,13 +1409,6 @@ static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
@@ -1591,8 +1576,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
 	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
 
-	{ SYS_DESC(SYS_RGSR_EL1), access_mte_regs },
-	{ SYS_DESC(SYS_GCR_EL1), access_mte_regs },
+	{ SYS_DESC(SYS_RGSR_EL1), undef_access },
+	{ SYS_DESC(SYS_GCR_EL1), undef_access },
 
 	{ SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0, .visibility = sve_visibility },
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
@@ -1618,8 +1603,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_ERXMISC0_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_ERXMISC1_EL1), trap_raz_wi },
 
-	{ SYS_DESC(SYS_TFSR_EL1), access_mte_regs },
-	{ SYS_DESC(SYS_TFSRE0_EL1), access_mte_regs },
+	{ SYS_DESC(SYS_TFSR_EL1), undef_access },
+	{ SYS_DESC(SYS_TFSRE0_EL1), undef_access },
 
 	{ SYS_DESC(SYS_FAR_EL1), access_vm_reg, reset_unknown, FAR_EL1 },
 	{ SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },
@@ -1683,14 +1668,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
