Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06C81A70F
	for <kvmarm@lists.linux.dev>; Mon, 27 Nov 2023 11:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ixNwChtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A657CC43397;
	Mon, 27 Nov 2023 11:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701085567;
	bh=cHcIEvwJnfbxO3mM5IzqDX9TDoySi9hJJrcEVWKZ/jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixNwChtAwL9zoIx0DQ3g8DL6RCOsnVYWy7PCgFycmx4au9CKPgVocgBuUCcmnOdzg
	 7zowsOZPkiuG4giY2QLY+IKebpdex3btJ1viUpZsJkhVpzXNdaI4FC1d6E3g0EkxUO
	 5adpFUQ1VC4kXsgA4R6fupbNThBgqkU7sakArHxT+9KQNcLEe53GGz943tPl9//h5U
	 yefv7eP03dZFrG+HYzci7poBX9abenb/e1FWlLIphOty+HbICPrL21aP9fxZJVgyDF
	 gn0IyV/1R8i9AFnw29LH7ZH6BVz+iG2BrsKn8ZHKU/yE0dvdmSPtSxiXL/J6d3Tdlu
	 RH9ReSDmjU7EA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r7a3x-00GleL-QL;
	Mon, 27 Nov 2023 11:46:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 09/13] arm64: Add override for ID_AA64MMFR4_EL1.E2H0
Date: Mon, 27 Nov 2023 11:45:55 +0000
Message-Id: <20231127114559.990314-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231127114559.990314-1-maz@kernel.org>
References: <20231127114559.990314-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, ardb@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Allow ID_AA64MMFR4_EL1.E2H0 to be overriden from the command-line.
This will subsequently be of use for non-compliant CPUs.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h |  1 +
 arch/arm64/kernel/cpufeature.c      |  4 +++-
 arch/arm64/kernel/idreg-override.c  | 10 ++++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 5f3f62efebd5..d465db251939 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -901,6 +901,7 @@ s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new, s64 cur);
 struct arm64_ftr_reg *get_arm64_ftr_reg(u32 sys_id);
 
 extern struct arm64_ftr_override id_aa64mmfr1_override;
+extern struct arm64_ftr_override id_aa64mmfr4_override;
 extern struct arm64_ftr_override id_aa64pfr0_override;
 extern struct arm64_ftr_override id_aa64pfr1_override;
 extern struct arm64_ftr_override id_aa64zfr0_override;
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 64a026cc5cec..7dcda39537f8 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -691,6 +691,7 @@ static const struct arm64_ftr_bits ftr_raz[] = {
 	__ARM64_FTR_REG_OVERRIDE(#id, id, table, &no_override)
 
 struct arm64_ftr_override __ro_after_init id_aa64mmfr1_override;
+struct arm64_ftr_override __ro_after_init id_aa64mmfr4_override;
 struct arm64_ftr_override __ro_after_init id_aa64pfr0_override;
 struct arm64_ftr_override __ro_after_init id_aa64pfr1_override;
 struct arm64_ftr_override __ro_after_init id_aa64zfr0_override;
@@ -759,7 +760,8 @@ static const struct __ftr_reg_entry {
 			       &id_aa64mmfr1_override),
 	ARM64_FTR_REG(SYS_ID_AA64MMFR2_EL1, ftr_id_aa64mmfr2),
 	ARM64_FTR_REG(SYS_ID_AA64MMFR3_EL1, ftr_id_aa64mmfr3),
-	ARM64_FTR_REG(SYS_ID_AA64MMFR4_EL1, ftr_id_aa64mmfr4),
+	ARM64_FTR_REG_OVERRIDE(SYS_ID_AA64MMFR4_EL1, ftr_id_aa64mmfr4,
+			       &id_aa64mmfr4_override),
 
 	/* Op1 = 1, CRn = 0, CRm = 0 */
 	ARM64_FTR_REG(SYS_GMID_EL1, ftr_gmid),
diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
index 3addc09f8746..7b5b9dc20e6b 100644
--- a/arch/arm64/kernel/idreg-override.c
+++ b/arch/arm64/kernel/idreg-override.c
@@ -55,6 +55,15 @@ static const struct ftr_set_desc mmfr1 __initconst = {
 	},
 };
 
+static const struct ftr_set_desc mmfr4 __initconst = {
+	.name		= "id_aa64mmfr4",
+	.override	= &id_aa64mmfr4_override,
+	.fields		= {
+		FIELD("e2h0", ID_AA64MMFR4_EL1_E2H0_SHIFT, NULL ),
+		{}
+	},
+};
+
 static bool __init pfr0_sve_filter(u64 val)
 {
 	/*
@@ -161,6 +170,7 @@ static const struct ftr_set_desc sw_features __initconst = {
 
 static const struct ftr_set_desc * const regs[] __initconst = {
 	&mmfr1,
+	&mmfr4,
 	&pfr0,
 	&pfr1,
 	&isar1,
-- 
2.39.2

