Return-Path: <SRS0=OpMx=BP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369FAC433E1
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 18:26:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D909422D03
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 18:26:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="hFyLINeT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D909422D03
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96EDD4B431;
	Wed,  5 Aug 2020 14:26:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ty2E7h3mNUe0; Wed,  5 Aug 2020 14:26:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4634F4B58D;
	Wed,  5 Aug 2020 14:26:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB1544B4C6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 14:26:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lPENyBM4-n94 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2020 14:25:59 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D1754B4D3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 14:25:59 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5F06822CB3;
 Wed,  5 Aug 2020 18:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596651958;
 bh=kQqWB9nR8C721TvBKL/d/pl9SOM/oXtaAvToHBb4mtQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=hFyLINeTa3ODpWskXd3tK9TWPEwk94Gmw53gzZmMkotYkz93ocPZrFqn9lqaNt7Og
 jG26z0sWEvvSmROlZzij4WnmFbkce/8ja33vibXRDmaXD/U9yhClELKhaUnVBfxhiB
 7W2UwlStd1h9++sYXWw+F1fJ6I5N2Rfi4REhaWp8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k3NfE-0004w9-Lu; Wed, 05 Aug 2020 18:57:20 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 10/56] KVM: arm64: Move ACTLR_EL1 emulation to the
 sys_reg_descs array
Date: Wed,  5 Aug 2020 18:56:14 +0100
Message-Id: <20200805175700.62775-11-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com,
 alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com,
 christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com,
 gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com,
 richard.peng@oppo.com, qperret@google.com, will@kernel.org,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Peng Hao <richard.peng@oppo.com>, kernel-team@android.com,
 kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexander Graf <graf@amazon.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

From: James Morse <james.morse@arm.com>

The only entry in the genericv8_sys_regs arrays is for emulation of
ACTLR_EL1. As all targets emulate this in the same way, move it to
sys_reg_descs[].

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200622113317.20477-4-james.morse@arm.com
---
 arch/arm64/kvm/sys_regs.c            | 28 ++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs_generic_v8.c | 30 ----------------------------
 2 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fb448bfc83ec..f8407cfa9032 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -242,6 +242,25 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_actlr(struct kvm_vcpu *vcpu,
+			 struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return ignore_write(vcpu, p);
+
+	p->regval = vcpu_read_sys_reg(vcpu, ACTLR_EL1);
+
+	if (p->is_aarch32) {
+		if (r->Op2 & 2)
+			p->regval = upper_32_bits(p->regval);
+		else
+			p->regval = lower_32_bits(p->regval);
+	}
+
+	return true;
+}
+
 /*
  * Trap handler for the GICv3 SGI generation system register.
  * Forward the request to the VGIC emulation.
@@ -615,6 +634,12 @@ static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_write_sys_reg(vcpu, amair, AMAIR_EL1);
 }
 
+static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u64 actlr = read_sysreg(actlr_el1);
+	vcpu_write_sys_reg(vcpu, actlr, ACTLR_EL1);
+}
+
 static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 mpidr;
@@ -1518,6 +1543,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(7,7),
 
 	{ SYS_DESC(SYS_SCTLR_EL1), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
+	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
 	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
 	{ SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0, .visibility = sve_visibility },
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
@@ -1957,6 +1983,8 @@ static const struct sys_reg_desc cp14_64_regs[] = {
 static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 0), CRm( 0), Op2( 1), access_ctr },
 	{ Op1( 0), CRn( 1), CRm( 0), Op2( 0), access_vm_reg, NULL, c1_SCTLR },
+	{ Op1( 0), CRn( 1), CRm( 0), Op2( 1), access_actlr },
+	{ Op1( 0), CRn( 1), CRm( 0), Op2( 3), access_actlr },
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 0), access_vm_reg, NULL, c2_TTBR0 },
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 1), access_vm_reg, NULL, c2_TTBR1 },
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 2), access_vm_reg, NULL, c2_TTBCR },
diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
index a82cc2ccfd44..a7e21e61beea 100644
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
@@ -19,44 +19,14 @@
 
 #include "sys_regs.h"
 
-static bool access_actlr(struct kvm_vcpu *vcpu,
-			 struct sys_reg_params *p,
-			 const struct sys_reg_desc *r)
-{
-	if (p->is_write)
-		return ignore_write(vcpu, p);
-
-	p->regval = vcpu_read_sys_reg(vcpu, ACTLR_EL1);
-
-	if (p->is_aarch32) {
-		if (r->Op2 & 2)
-			p->regval = upper_32_bits(p->regval);
-		else
-			p->regval = lower_32_bits(p->regval);
-	}
-
-	return true;
-}
-
-static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
-{
-	__vcpu_sys_reg(vcpu, ACTLR_EL1) = read_sysreg(actlr_el1);
-}
-
 /*
  * Implementation specific sys-reg registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
  */
 static const struct sys_reg_desc genericv8_sys_regs[] = {
-	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
 };
 
 static const struct sys_reg_desc genericv8_cp15_regs[] = {
-	/* ACTLR */
-	{ Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b001),
-	  access_actlr },
-	{ Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b011),
-	  access_actlr },
 };
 
 struct kvm_sys_reg_target_table genericv8_target_table = {
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
