Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A53C2BA4C
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 15:32:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C07E4A5A0;
	Wed, 26 Jan 2022 10:32:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IHBi8DStV00r; Wed, 26 Jan 2022 10:32:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2EEB49F58;
	Wed, 26 Jan 2022 10:32:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E6AC49EC1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:32:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eId0FkKAHxq7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 10:32:00 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F57049F2E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 10:32:00 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 26CDA618D8;
 Wed, 26 Jan 2022 15:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C774C340EC;
 Wed, 26 Jan 2022 15:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643211119;
 bh=DtugFpthaiK0xEHP2NQTQkSOyUac+uhH3/vXGpUUR8E=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=n//gJjLOsmFNi2To+yLMmgWs8QKtngNAOlbBAZHkS3y32PpNfw/j6c699QuYQJ60j
 bF4nP6UyGhOS49IVY7fWW6Yv/NnCSMO2kjKkgjiOAaC3Pk8VS3SpNxxtQsHaDBpXfu
 F2lI8SbS2Rc+VwYKlMiZn8cuSV/x8LVkCewm4lH/68A5Vl3JvVCqFwMv85M6L6tWDu
 HxlVzDHhDJZPZH6C0w455i7s9HwvnzImZH691YvgiWkgZaohSWzS0eqrt+JBQLh/Vn
 gm/5zHw/AzBNNUU1t0mIRYXpOdqRBLfsXhcr3y01+ufbkqOqk9VEg+F9Q5l3dEFP2G
 9Rg4YwESFtz8A==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v10 25/39] KVM: arm64: Hide SME system registers from guests
Date: Wed, 26 Jan 2022 15:27:35 +0000
Message-Id: <20220126152749.233712-26-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220126152749.233712-1-broonie@kernel.org>
References: <20220126152749.233712-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2580; h=from:subject;
 bh=DtugFpthaiK0xEHP2NQTQkSOyUac+uhH3/vXGpUUR8E=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh8WhphVjgkrdByxSLKuspmwEp1Ss1KXA83wWthUlS
 vnIER7eJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYfFoaQAKCRAk1otyXVSH0AwkB/
 98TGUSb1n+wRtHLqsLr6qFSF6WxoMdnwRv/YiyMgiPtmVUqEl9LuxPfBXitg0XHHsR0Mqd902XtLlx
 GKdDgQBd4zJuMtSaIhT9UEBcxJSdHcyPsava5NRGE8QNYWoo4PWQVY3xkX2w1RC1IJzFd7xmMXyS0f
 Of0M06eZBTYrCB5wNjGduK9ZuAhFTOWlm+8r+NtBXQmpMaqV0eF2rOpXLPA0j66dQqyUxXfmnvBluX
 yGTPhUHMSaaqeQMPAD8OoBXVGRAhfw8PHlGcyq9ELoEkFqiNtKpDz7JwrDuZSCVFXFjiYj2OHdOKnL
 QAUDXx8ON7d8FoH7LvfHlBaMz3F00T
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>
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

For the time being we do not support use of SME by KVM guests, support for
this will be enabled in future. In order to prevent any side effects or
side channels via the new system registers, including the EL0 read/write
register TPIDR2, explicitly undefine all the system registers added by
SME and mask out the SME bitfield in SYS_ID_AA64PFR1.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4dc2fba316ff..43516eda9143 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1089,6 +1089,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	case SYS_ID_AA64PFR1_EL1:
 		if (!kvm_has_mte(vcpu->kvm))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
+
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_SME);
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
@@ -1508,7 +1510,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
 	ID_SANITISED(ID_AA64ZFR0_EL1),
-	ID_UNALLOCATED(4,5),
+	ID_HIDDEN(ID_AA64SMFR0_EL1),
 	ID_UNALLOCATED(4,6),
 	ID_UNALLOCATED(4,7),
 
@@ -1551,6 +1553,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0, .visibility = sve_visibility },
 	{ SYS_DESC(SYS_TRFCR_EL1), undef_access },
+	{ SYS_DESC(SYS_SMPRI_EL1), undef_access },
+	{ SYS_DESC(SYS_SMCR_EL1), undef_access },
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
 	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
 	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
@@ -1633,8 +1637,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
 	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr },
+	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
 	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
+	{ SYS_DESC(SYS_SVCR_EL0), undef_access },
 
 	{ PMU_SYS_REG(SYS_PMCR_EL0), .access = access_pmcr,
 	  .reset = reset_pmcr, .reg = PMCR_EL0 },
@@ -1674,6 +1680,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_TPIDR_EL0), NULL, reset_unknown, TPIDR_EL0 },
 	{ SYS_DESC(SYS_TPIDRRO_EL0), NULL, reset_unknown, TPIDRRO_EL0 },
+	{ SYS_DESC(SYS_TPIDR2_EL0), undef_access },
 
 	{ SYS_DESC(SYS_SCXTNUM_EL0), undef_access },
 
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
