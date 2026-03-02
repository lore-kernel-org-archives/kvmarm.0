Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C055E23BD1D
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 11:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772452635; cv=none; b=Y+nT2EsQYIEkKuXsk8MHxTkIYhnvOEqSnPWN7tWT+Y6IWgwXvcb0jbwuc174PbeU9iGqMrCwTKYS2nOSHEjG4UrGCJD0J3FXaK4Js86hVySBR1MRGk7up7ePCVOoEJ25XUImPCTAuFbdN8ekdz2jgVKnRAeDlmMkhU+o+A9fzJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772452635; c=relaxed/simple;
	bh=4BWIaove3Gt4mRqnBRiYa4EXad2vYRKWzbMoXG6iXAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCGBrs/YsXtnr7MF0Mwd8ZyPseyJZZS8iOxnVhgqUsRUQ7Bx0siQ6zx4RZDjEvvKySVsQ5mGSWwkr5x6UocXCGjafjTmBA89sOfSUlt7R2MLT7eFg2Fe16S8+CsPfnngk07mew6OeOE0OcNWfSheoiL5ILAdjHXwHc7Gl+NaXPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pJbhqqyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pJbhqqyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DE4C2BC87;
	Mon,  2 Mar 2026 11:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772452635;
	bh=4BWIaove3Gt4mRqnBRiYa4EXad2vYRKWzbMoXG6iXAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pJbhqqyfTq1lGiOpt+5xwRuFRwuOP+KYqJW0B7rNaeDXYsikHo1t5k1Gt1sUvx2be
	 /Hf8OUXrcqmPC0rYJRIMKvLdZNc7UD8B0TYq6CJ8T2a4b5Tk+LRTWu5Q+fMN4ry8aN
	 /PEyBn7K8pl3tB/bq73Cuo9ko3YQmTVGL98SPb8yI2R1YwhImAbDaJ9CJoKWVDQqvP
	 +lF+hWhXyKFT3RqboXtSA40ChLBqljXsdpSbNtBIoV+t6kRHw29QqY9G/IbHT08E8y
	 lWQVOD9sEZarwqFhFEp02VT8mC3U0njsl5s6Hf/YBKUH16k/IwoKS66VlxiCRNGeUh
	 Mi20pw8ruRN+A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vx1th-0000000FDFJ-2CmD;
	Mon, 02 Mar 2026 11:57:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 03/11] arm64: Add logic to fully remove features from sanitised id registers
Date: Mon,  2 Mar 2026 11:56:44 +0000
Message-ID: <20260302115653.1517326-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260302115653.1517326-1-maz@kernel.org>
References: <20260302115653.1517326-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We currently make support for some features such as Pointer Auth,
SVE or S1POE a compile time decision.

However, while we hide that feature from userspace when such support
is disabled, we still leave the value provided by the HW visible to
the rest of the kernel, including KVM.

This has the potential to result in ugly state leakage, as half of
the kernel knows about the feature, and the other doesn't.

Short of completely banning such compilation options and restore
universal knowledge, introduce the possibility to fully remove such
knowledge from the sanitised id registers.

This has more or less the same effect as the idreg override that
a user can pass on the command-line, only defined at build-time.

For that purpose, we provide a new macro (FTR_CONFIG()) that defines
the behaviour of a feature, both when enabled and disabled.

At this stage, nothing is making use of this anti-feature.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h | 17 +++++++++------
 arch/arm64/kernel/cpufeature.c      | 32 ++++++++++++++++++++++-------
 2 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 4de51f8d92cba..e853a0ac7db38 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -53,17 +53,22 @@ enum ftr_type {
 #define FTR_SIGNED	true	/* Value should be treated as signed */
 #define FTR_UNSIGNED	false	/* Value should be treated as unsigned */
 
-#define FTR_VISIBLE	true	/* Feature visible to the user space */
-#define FTR_HIDDEN	false	/* Feature is hidden from the user */
+enum ftr_visibility {
+	FTR_HIDDEN,		/* Feature hidden from the user */
+	FTR_ALL_HIDDEN,		/* Feature hidden from kernel, user and KVM */
+	FTR_VISIBLE,		/* Feature visible to all observers */
+};
+
+#define FTR_CONFIG(c, e, d)				\
+	(IS_ENABLED(c) ? FTR_ ## e : FTR_ ## d)
 
-#define FTR_VISIBLE_IF_IS_ENABLED(config)		\
-	(IS_ENABLED(config) ? FTR_VISIBLE : FTR_HIDDEN)
+#define FTR_VISIBLE_IF_IS_ENABLED(c)	FTR_CONFIG(c, VISIBLE, HIDDEN)
 
 struct arm64_ftr_bits {
 	bool		sign;	/* Value is signed ? */
-	bool		visible;
+	enum ftr_visibility visibility:8;
 	bool		strict;	/* CPU Sanity check: strict matching required ? */
-	enum ftr_type	type;
+	enum ftr_type	type:8;
 	u8		shift;
 	u8		width;
 	s64		safe_val; /* safe value for FTR_EXACT features */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 102c5bac4d502..965dd2acf0640 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -192,7 +192,7 @@ void dump_cpu_features(void)
 #define __ARM64_FTR_BITS(SIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) \
 	{						\
 		.sign = SIGNED,				\
-		.visible = VISIBLE,			\
+		.visibility = VISIBLE,			\
 		.strict = STRICT,			\
 		.type = TYPE,				\
 		.shift = SHIFT,				\
@@ -1063,16 +1063,33 @@ static void init_cpu_ftr_reg(u32 sys_reg, u64 new)
 				ftrp->shift);
 		}
 
-		val = arm64_ftr_set_value(ftrp, val, ftr_new);
-
 		valid_mask |= ftr_mask;
 		if (!ftrp->strict)
 			strict_mask &= ~ftr_mask;
-		if (ftrp->visible)
+
+		switch (ftrp->visibility) {
+		case FTR_VISIBLE:
+			val = arm64_ftr_set_value(ftrp, val, ftr_new);
 			user_mask |= ftr_mask;
-		else
+			break;
+		case FTR_ALL_HIDDEN:
+			/*
+			 * ALL_HIDDEN and HIGHER_SAFE are incompatible.
+			 * Only hide from userspace, and log the oddity.
+			 */
+			if (WARN_ON(ftrp->type == FTR_HIGHER_SAFE))
+				val = arm64_ftr_set_value(ftrp, val, ftr_new);
+			else
+				val = arm64_ftr_set_safe_value(ftrp, val);
 			reg->user_val = arm64_ftr_set_safe_value(ftrp,
 								 reg->user_val);
+			break;
+		case FTR_HIDDEN:
+			val = arm64_ftr_set_value(ftrp, val, ftr_new);
+			reg->user_val = arm64_ftr_set_safe_value(ftrp,
+								 reg->user_val);
+			break;
+		}
 	}
 
 	val &= valid_mask;
@@ -1230,9 +1247,10 @@ static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
 
 		/*
 		 * Don't alter the initial value that has been forced
-		 * by an override.
+		 * by an override or a disabled feature.
 		 */
-		if ((reg->override->mask & arm64_ftr_mask(ftrp)) == arm64_ftr_mask(ftrp))
+		if (ftrp->visibility == FTR_ALL_HIDDEN ||
+		    (reg->override->mask & arm64_ftr_mask(ftrp)) == arm64_ftr_mask(ftrp))
 			continue;
 
 		if (ftr_cur == ftr_new)
-- 
2.47.3

