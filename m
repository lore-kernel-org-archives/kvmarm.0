Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A88BC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 18:28:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 452A54B24A;
	Tue, 19 Apr 2022 14:28:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vLlhhPK38VRi; Tue, 19 Apr 2022 14:28:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 085BC4B273;
	Tue, 19 Apr 2022 14:28:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF6154B236
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 14:28:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FR-ioMXWSMsB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 14:28:11 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E5814B23D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 14:28:10 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 3E7C6B819B7;
 Tue, 19 Apr 2022 18:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37BDC385B5;
 Tue, 19 Apr 2022 18:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1650392887;
 bh=ozZe6zkm6YfsS4fpe1Qy1Aj7/ayH8KRXRzvRtrC6w+k=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=kTP4VTxnRyjesLreP9zt2LWso5nLeMYxYCmiOb6qDRNYZA5gdTyEJohmi8MaucHS3
 XAoTlEWwpZNOFblukDUrN+oRX2DjHrutsDuD0Ws6eIFklDLStAgqCLkSB3bCqwv3dH
 YZEIaRbWLiHJ2bqXMRwSYWEnj1vAwrolvcJxgLsua17fPgBa83jPbuVIiOlAaxjbre
 OIpAMiKWq5lUz+q4v0O4RhhKhn3ehJFJiKjfnremnvaOsThkPvLIHVoemEPCl1s+07
 29r6ogTwuY4Ul3RMcmMHKr2GoE770gH1J5L3l68cgc5vnbYEnAx2hLVGSN1I63QV8c
 iI4QFqOm+lY/w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1ngsa5-005QYF-Rn; Tue, 19 Apr 2022 19:28:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 07/10] KVM: arm64: Expose the WFXT feature to guests
Date: Tue, 19 Apr 2022 19:27:52 +0100
Message-Id: <20220419182755.601427-8-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419182755.601427-1-maz@kernel.org>
References: <20220419182755.601427-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com,
 will@kernel.org, mark.rutland@arm.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, joey.gouly@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Joey Gouly <joey.gouly@arm.com>, Will Deacon <will@kernel.org>
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

Plumb in the capability, and expose WFxT to guests when available.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 12 ++++++++++++
 arch/arm64/kvm/sys_regs.c      |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index d72c4b4d389c..db6d9ab685e5 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -237,6 +237,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_PTR_AUTH),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_GPA3_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_RPRES_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_WFXT_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
 
@@ -2442,6 +2443,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		.min_field_value = 1,
 	},
+	{
+		.desc = "WFx with timeout",
+		.capability = ARM64_HAS_WFXT,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.sys_reg = SYS_ID_AA64ISAR2_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64ISAR2_WFXT_SHIFT,
+		.field_width = 4,
+		.matches = has_cpuid_feature,
+		.min_field_value = ID_AA64ISAR2_WFXT_SUPPORTED,
+	},
 	{},
 };
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7b45c040cc27..cc9a77546cc0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1144,6 +1144,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		if (!vcpu_has_ptrauth(vcpu))
 			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR2_APA3) |
 				 ARM64_FEATURE_MASK(ID_AA64ISAR2_GPA3));
+		if (!cpus_have_final_cap(ARM64_HAS_WFXT))
+			val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_WFXT);
 		break;
 	case SYS_ID_AA64DFR0_EL1:
 		/* Limit debug to ARMv8.0 */
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
