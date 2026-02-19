Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EF42FD7DA
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 19:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771530948; cv=none; b=WGquCyLfL9/c4sWv6n8j9oP+pbTUWAQ+EOomiRsZBi7jJQtp8xQUaHnFGsXU6O3ssastiF3v4+Nc8wJzbROJn3Bnq24otTOf2fEl3L4Ewnei75E8pBI+JjcLVR8ptr38qRGmOo+UgVbsGq9lav/Rm4YkAxWCGWo1g0e7ExVb7tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771530948; c=relaxed/simple;
	bh=B/4MfKsHXqUtL+fq2XHySry95IjfcX/fGLKxwEHXGX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m80XS216v1aVD9vOGrqDn0d6vBgYcke5kHxrXTZfDMhWKB+3ZCIFzT8+GYkFN7KgzcylsViD98Vps7nCXnr7xwzdlCIGWXngoTqtXvlohdT4wAxT6F4VfySDM9q3nEmhVA3E5XoNFSbvBv/brJKw/izJgQVAhSWLENdNxJK/NL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MCfQGXLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MCfQGXLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3A1C4CEF7;
	Thu, 19 Feb 2026 19:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771530948;
	bh=B/4MfKsHXqUtL+fq2XHySry95IjfcX/fGLKxwEHXGX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCfQGXLVR5iE1NEpxF+q+9EBEF4Aps8IRGjF8KhBux0x+C9VyoPwG1IDtcObuS3CC
	 9ecMVjjc8qGJNJmnibSIayKrtWdyaGRkdxOoviLa/FOmrduudeN9Zqfkb6m2vFDIYN
	 ydifopW7+JhuvvhckFflvOnFT++6Pz5JaAo6e6uvA3mBMPNwm0Baecb9TzUZaK3KiD
	 o4kavT9ZpCyymZeO8gaxXLHX0CHoze3xU7xvhJkKGvLCUBPCg5xOqs3mYjWJSwaW+B
	 pdhAHnusaqIovGhQZnb8MchH3qqTpTz42cBwL0+F7ABT7DTzhSR8oZcm1n2Ipwe4aK
	 pE8yG8YyjkOgw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vtA7l-0000000CGHL-25VV;
	Thu, 19 Feb 2026 19:55:45 +0000
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
Subject: [PATCH 1/9] arm64: Add logic to fully remove features from sanitised id registers
Date: Thu, 19 Feb 2026 19:55:24 +0000
Message-ID: <20260219195533.2455736-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260219195533.2455736-1-maz@kernel.org>
References: <20260219195533.2455736-1-maz@kernel.org>
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
 arch/arm64/include/asm/cpufeature.h | 15 ++++++++++-----
 arch/arm64/kernel/cpufeature.c      | 21 ++++++++++++++++-----
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 4de51f8d92cba..2731ea13c2c86 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -53,15 +53,20 @@ enum ftr_type {
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
+	enum ftr_visibility visibility;
 	bool		strict;	/* CPU Sanity check: strict matching required ? */
 	enum ftr_type	type;
 	u8		shift;
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c840a93b9ef95..b34a39967d111 100644
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
@@ -1057,17 +1057,28 @@ static void init_cpu_ftr_reg(u32 sys_reg, u64 new)
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
+			val = arm64_ftr_set_value(ftrp, val, ftrp->safe_val);
+			reg->user_val = arm64_ftr_set_value(ftrp,
+							    reg->user_val,
+							    ftrp->safe_val);
+			break;
+		case FTR_HIDDEN:
+			val = arm64_ftr_set_value(ftrp, val, ftr_new);
 			reg->user_val = arm64_ftr_set_value(ftrp,
 							    reg->user_val,
 							    ftrp->safe_val);
+			break;
+		}
 	}
 
 	val &= valid_mask;
-- 
2.47.3

