Return-Path: <SRS0=+Nyp=G4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F19ECC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 12:26:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7864D2310C
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 12:26:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7864D2310C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 261294B62C;
	Mon, 25 Jan 2021 07:26:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FxRVGIJgvQl1; Mon, 25 Jan 2021 07:26:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 144DF4B615;
	Mon, 25 Jan 2021 07:26:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D1D34B611
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 07:26:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ScoQSQX4pJhL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2021 07:26:46 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F0E1A4B61C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 07:26:45 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1C8BD230FF;
 Mon, 25 Jan 2021 12:26:45 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l40x9-009sBu-Bd; Mon, 25 Jan 2021 12:26:43 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 4/7] KVM: arm64: Refactor filtering of ID registers
Date: Mon, 25 Jan 2021 12:26:35 +0000
Message-Id: <20210125122638.2947058-5-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210125122638.2947058-1-maz@kernel.org>
References: <20210125122638.2947058-1-maz@kernel.org>
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

Our current ID register filtering is starting to be a mess of if()
statements, and isn't going to get any saner.

Let's turn it into a switch(), which has a chance of being more
readable, and introduce a FEATURE() macro that allows easy generation
of feature masks.

No functionnal change intended.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 51 +++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2bea0494b81d..dda16d60197b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -9,6 +9,7 @@
  *          Christoffer Dall <c.dall@virtualopensystems.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/bsearch.h>
 #include <linux/kvm_host.h>
 #include <linux/mm.h>
@@ -1016,6 +1017,8 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
+
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
 static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		struct sys_reg_desc const *r, bool raz)
@@ -1024,36 +1027,38 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
 	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
 
-	if (id == SYS_ID_AA64PFR0_EL1) {
+	switch (id) {
+	case SYS_ID_AA64PFR0_EL1:
 		if (!vcpu_has_sve(vcpu))
-			val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
-		val &= ~(0xfUL << ID_AA64PFR0_AMU_SHIFT);
-		val &= ~(0xfUL << ID_AA64PFR0_CSV2_SHIFT);
-		val |= ((u64)vcpu->kvm->arch.pfr0_csv2 << ID_AA64PFR0_CSV2_SHIFT);
-		val &= ~(0xfUL << ID_AA64PFR0_CSV3_SHIFT);
-		val |= ((u64)vcpu->kvm->arch.pfr0_csv3 << ID_AA64PFR0_CSV3_SHIFT);
-	} else if (id == SYS_ID_AA64PFR1_EL1) {
-		val &= ~(0xfUL << ID_AA64PFR1_MTE_SHIFT);
-	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
-		val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
-			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
-			 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
-			 (0xfUL << ID_AA64ISAR1_GPI_SHIFT));
-	} else if (id == SYS_ID_AA64DFR0_EL1) {
-		u64 cap = 0;
-
+			val &= ~FEATURE(ID_AA64PFR0_SVE);
+		val &= ~FEATURE(ID_AA64PFR0_AMU);
+		val &= ~FEATURE(ID_AA64PFR0_CSV2);
+		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
+		val &= ~FEATURE(ID_AA64PFR0_CSV3);
+		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
+		break;
+	case SYS_ID_AA64PFR1_EL1:
+		val &= ~FEATURE(ID_AA64PFR1_MTE);
+		break;
+	case SYS_ID_AA64ISAR1_EL1:
+		if (!vcpu_has_ptrauth(vcpu))
+			val &= ~(FEATURE(ID_AA64ISAR1_APA) |
+				 FEATURE(ID_AA64ISAR1_API) |
+				 FEATURE(ID_AA64ISAR1_GPA) |
+				 FEATURE(ID_AA64ISAR1_GPI));
+		break;
+	case SYS_ID_AA64DFR0_EL1:
 		/* Limit guests to PMUv3 for ARMv8.1 */
-		if (kvm_vcpu_has_pmu(vcpu))
-			cap = ID_AA64DFR0_PMUVER_8_1;
-
 		val = cpuid_feature_cap_perfmon_field(val,
-						ID_AA64DFR0_PMUVER_SHIFT,
-						cap);
-	} else if (id == SYS_ID_DFR0_EL1) {
+						      ID_AA64DFR0_PMUVER_SHIFT,
+						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_1 : 0);
+		break;
+	case SYS_ID_DFR0_EL1:
 		/* Limit guests to PMUv3 for ARMv8.1 */
 		val = cpuid_feature_cap_perfmon_field(val,
 						      ID_DFR0_PERFMON_SHIFT,
 						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_1 : 0);
+		break;
 	}
 
 	return val;
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
