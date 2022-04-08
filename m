Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B7CEC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 11:56:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 488544B278;
	Fri,  8 Apr 2022 07:56:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6ur6XNtyTsG8; Fri,  8 Apr 2022 07:56:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF33B4B24D;
	Fri,  8 Apr 2022 07:56:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC2114B0B3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:56:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KW9yyFsjbN5F for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 07:56:52 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 821424B1FD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:56:52 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id B8642B82A88;
 Fri,  8 Apr 2022 11:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E463EC385A1;
 Fri,  8 Apr 2022 11:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649419011;
 bh=mpyVrfoj3Ha303zuZjG3RtyooXrFp3K4QGVZ/xNcyCk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=QB67v2bZQMtGaOcvFxUqMD7uRuMSxCIoZmdfhy8h6jhlUUPa0staCkBssM3cusTP5
 dywnTl6ColVhxpsgyoMiV4jm3r1LZ4K3t5ubPgw5xo0S/CmfKUIDiYxbvQiK7axaPT
 pC/OHFVkLIYwzf47hQQZCsRzHtcnrx1A10fHZ4lFMZ+f9eaLlck1HXSa6LEyqdxctr
 FvkL6MGXOwqYGYeislWxXXt/gwdIWlSW85zySMMKYObxS2YpK9a0kc4MzL0fKJEtDY
 RLMFC3qe3GKoNY3HFkTIOht1ludAabBw0hTg7WvilY3SDXrc4OOslkVIkncUgfDLqL
 CGIWI6ej8JBbg==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v13 24/39] KVM: arm64: Hide SME system registers from guests
Date: Fri,  8 Apr 2022 12:43:13 +0100
Message-Id: <20220408114328.1401034-25-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220408114328.1401034-1-broonie@kernel.org>
References: <20220408114328.1401034-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2636; h=from:subject;
 bh=mpyVrfoj3Ha303zuZjG3RtyooXrFp3K4QGVZ/xNcyCk=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiUB/SRWYJuMOUyhoG4RrOSW+FXVga+MXNZsFprhc0
 IjsenR2JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYlAf0gAKCRAk1otyXVSH0AqTB/
 9b0dzf1mObZw8ZekaWF6v59M4AGsTGiY9r3D/7RJFfGf7+IUzBjO/WM0Xr3Sg0WXQq0+q8HNxC6eVv
 072ANolPqSWNOUdlDiIXS4LZYCTuVWy+/P5mkxns0Ah2RjXUZ3Wsd4c5fsgKSp2j/ysMXIUJ4TRlYD
 js9+vNyw00if0vNqNWAEil/gJO8/wlKmmNCTTYdqkULrGQ71A7F5r3IfIRgPDul1lChsXH+ejXmZY8
 GwWVrpGJ+812ySVJxW9Kkhiht2/YUTo5q4ZoGjw+vNSbZcdjIibSSQ0Z6HsbK5FrF9W51IEI/R9E7J
 jPSs0W7v52VNfUwJqvBT18IOSlH5hC
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>,
 Luca Salabrino <luca.scalabrino@arm.com>
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
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7b45c040cc27..689e53dd4cb1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1132,6 +1132,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 	case SYS_ID_AA64PFR1_EL1:
 		if (!kvm_has_mte(vcpu->kvm))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
+
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_SME);
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
@@ -1553,7 +1555,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_UNALLOCATED(4,2),
 	ID_UNALLOCATED(4,3),
 	ID_SANITISED(ID_AA64ZFR0_EL1),
-	ID_UNALLOCATED(4,5),
+	ID_HIDDEN(ID_AA64SMFR0_EL1),
 	ID_UNALLOCATED(4,6),
 	ID_UNALLOCATED(4,7),
 
@@ -1596,6 +1598,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0, .visibility = sve_visibility },
 	{ SYS_DESC(SYS_TRFCR_EL1), undef_access },
+	{ SYS_DESC(SYS_SMPRI_EL1), undef_access },
+	{ SYS_DESC(SYS_SMCR_EL1), undef_access },
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
 	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
 	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
@@ -1678,8 +1682,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
 	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr },
+	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
 	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
+	{ SYS_DESC(SYS_SVCR_EL0), undef_access },
 
 	{ PMU_SYS_REG(SYS_PMCR_EL0), .access = access_pmcr,
 	  .reset = reset_pmcr, .reg = PMCR_EL0 },
@@ -1719,6 +1725,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
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
