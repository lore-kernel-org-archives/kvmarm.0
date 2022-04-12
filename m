Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600C6C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 12 Apr 2022 13:14:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF2CC4B28A;
	Tue, 12 Apr 2022 09:14:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tYG3z7SshBCN; Tue, 12 Apr 2022 09:14:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EA554B2C3;
	Tue, 12 Apr 2022 09:14:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38E434B2B2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:13:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cGVZBFQZy3px for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2022 09:13:56 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1BA624B285
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:13:56 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 931ED61A00;
 Tue, 12 Apr 2022 13:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9483C385B4;
 Tue, 12 Apr 2022 13:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649769234;
 bh=ozZe6zkm6YfsS4fpe1Qy1Aj7/ayH8KRXRzvRtrC6w+k=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=oXYLZkstBh33GfSwm9DEU+pUMhOXKXPhotiYqdVYuCwdlETC7yhAXdPLTE87DT04N
 0YglHLB8fDlnSvK10sfSiZGlnh5XujW1RkALw5L0ccivKuNuK7BbsoW5mFgMtyNvb4
 CvpwSMn9R7OLAcXObFss/dVbTTgGFT+DjoWEwZUIWVj/ZQrw5NZPw+QqYsUW2BY5TV
 U7O3YGMmEYZ76OUQBPC41oTtbMwONa+fDzKb9q2Rzs5P8H6+h0pIGaDwe1amsdXux+
 DTjHOqlzPTrlDLz6+4ywKbIwN8KPBwphn8/TPS8eaUm8ZLodkvL0m1N0se5PMgmiNf
 kKL5RKV5VE1hw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1neGLA-003mvX-KP; Tue, 12 Apr 2022 14:13:52 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 07/10] KVM: arm64: Expose the WFXT feature to guests
Date: Tue, 12 Apr 2022 14:13:00 +0100
Message-Id: <20220412131303.504690-8-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220412131303.504690-1-maz@kernel.org>
References: <20220412131303.504690-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com,
 will@kernel.org, mark.rutland@arm.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
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
