Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24FB224B06
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 15:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758208468; cv=none; b=dWMecFYGyPQtE5saoK9pybtQ10pA7Tx/jKpC0potfI1iq5u3KUo630JFnppGRC7RCL3p7p328S3rVj15RJd5DQ03f0AtSC43jIzNB+TT6nbxhVOEcQWBPoVeZl1WHLeWAR2A/W6sq+JWe8YXBNxn6Z4zY5V3t1Pr4j5WMACM6qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758208468; c=relaxed/simple;
	bh=VnXTaODZ9KKv1VyS6psdOf4AON93ty2oTWMW5jw3b9A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nzV9TDz3uha+PN0HXklGFEhrJRBs8E5P79dTd10s7/LHe57oKSjhDvQgMzKjj2P/14LSUSsstuKN6D0U4ys2TG7zBi1LV/Z5RAHnMuKjoFlgf3hdvHc5tRgEfgFb6X6Uhmdnz98HHHyN8DBgc+rtMIPC1y4+oq+c9DKsgbrSqeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=trR2pFQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="trR2pFQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FA7C4CEEB;
	Thu, 18 Sep 2025 15:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758208468;
	bh=VnXTaODZ9KKv1VyS6psdOf4AON93ty2oTWMW5jw3b9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trR2pFQ+PpnboBbUG2K2IIDifqZQi3df1p1KBz5NbwBWUlp0GVNShGjlDy/lZu3C/
	 Gj6LhZ6PgeAQCrsVoZexTy7ccdxeDfi6051JEEYxwHgwk4cmknM2np8yEuXd4he8Az
	 xyXc4mV1ke6Sw3Yuyi67TU42MR4uQPztk8RnWxf7POvmWYM3ZeoWLvS/Y3GFlboz6T
	 YQmjNiKU7FDWaFAOXEKFZ3aCYl8cGefJIXcuYiBnXVDihsf47EFHZ9FAPstTTLG1zQ
	 F540u+AY+r5Bd8GKxtwZkaWgx7RU0CH9G9x24eSIayywEMwAt9HmGRdKJ+ZBGRJcCe
	 ya3nMG9AKR2mQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uzGL4-00000007TmF-2WSt;
	Thu, 18 Sep 2025 15:14:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: [PATCH v2 02/10] KVM: arm64: Add reg_feat_map_desc to describe full register dependency
Date: Thu, 18 Sep 2025 16:13:54 +0100
Message-Id: <20250918151402.1665315-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250918151402.1665315-1-maz@kernel.org>
References: <20250918151402.1665315-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, yangjinqian1@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

struct reg_bits_to_feat_map is great to describe bit-to-feature
dependency, but not so much to describe register-to-feature
dependency. Yet both need to exist.

Add a new reg_feat_map_desc structure to describe this.

Extra complexity is added by the need to source the RES0 bits from
the runtime-computed FGT masks, for which we need an extra flag
and extra complexity. Oh well.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 81 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 72 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index d85dd05c00b0e..c2bfffe660bca 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -7,12 +7,22 @@
 #include <linux/kvm_host.h>
 #include <asm/sysreg.h>
 
+/*
+ * Describes the dependencies between a set of bits (or the negation
+ * of a set of RES0 bits) and a feature. The flags indicate how the
+ * data is interpreted.
+ */
 struct reg_bits_to_feat_map {
-	u64		bits;
+	union {
+		u64	bits;
+		u64	*res0p;
+	};
 
 #define	NEVER_FGU	BIT(0)	/* Can trap, but never UNDEF */
 #define	CALL_FUNC	BIT(1)	/* Needs to evaluate tons of crap */
 #define	FIXED_VALUE	BIT(2)	/* RAZ/WI or RAO/WI in KVM */
+#define	RES0_POINTER	BIT(3)	/* Pointer to RES0 value instead of bits */
+
 	unsigned long	flags;
 
 	union {
@@ -28,9 +38,27 @@ struct reg_bits_to_feat_map {
 	};
 };
 
-#define __NEEDS_FEAT_3(m, f, id, fld, lim)		\
+/*
+ * Describes the dependencies for a given register:
+ *
+ * @feat_map describes the dependency for the whole register. If the
+ * features the register depends on are not present, the whole
+ * register is effectively RES0.
+ *
+ * @bit_feat_map describes the dependencies for a set of bits in that
+ * register. If the features these bits depend on are not present, the
+ * bits are effectively RES0.
+ */
+struct reg_feat_map_desc {
+	const char			  *name;
+	const struct reg_bits_to_feat_map feat_map;
+	const struct reg_bits_to_feat_map *bit_feat_map;
+	const unsigned int		  bit_feat_map_sz;
+};
+
+#define __NEEDS_FEAT_3(m, f, w, id, fld, lim)		\
 	{						\
-		.bits	= (m),				\
+		.w	= (m),				\
 		.flags = (f),				\
 		.regidx	= IDREG_IDX(SYS_ ## id),	\
 		.shift	= id ##_## fld ## _SHIFT,	\
@@ -39,28 +67,63 @@ struct reg_bits_to_feat_map {
 		.lo_lim	= id ##_## fld ##_## lim	\
 	}
 
-#define __NEEDS_FEAT_2(m, f, fun, dummy)		\
+#define __NEEDS_FEAT_2(m, f, w, fun, dummy)		\
 	{						\
-		.bits	= (m),				\
+		.w	= (m),				\
 		.flags = (f) | CALL_FUNC,		\
 		.fval = (fun),				\
 	}
 
-#define __NEEDS_FEAT_1(m, f, fun)			\
+#define __NEEDS_FEAT_1(m, f, w, fun)			\
 	{						\
-		.bits	= (m),				\
+		.w	= (m),				\
 		.flags = (f) | CALL_FUNC,		\
 		.match = (fun),				\
 	}
 
+#define __NEEDS_FEAT_FLAG(m, f, w, ...)			\
+	CONCATENATE(__NEEDS_FEAT_, COUNT_ARGS(__VA_ARGS__))(m, f, w, __VA_ARGS__)
+
 #define NEEDS_FEAT_FLAG(m, f, ...)			\
-	CONCATENATE(__NEEDS_FEAT_, COUNT_ARGS(__VA_ARGS__))(m, f, __VA_ARGS__)
+	__NEEDS_FEAT_FLAG(m, f, bits, __VA_ARGS__)
 
 #define NEEDS_FEAT_FIXED(m, ...)			\
-	NEEDS_FEAT_FLAG(m, FIXED_VALUE, __VA_ARGS__, 0)
+	__NEEDS_FEAT_FLAG(m, FIXED_VALUE, bits, __VA_ARGS__, 0)
+
+#define NEEDS_FEAT_RES0(p, ...)				\
+	__NEEDS_FEAT_FLAG(p, RES0_POINTER, res0p, __VA_ARGS__)
 
+/*
+ * Declare the dependency between a set of bits and a set of features,
+ * generating a struct reg_bit_to_feat_map.
+ */
 #define NEEDS_FEAT(m, ...)	NEEDS_FEAT_FLAG(m, 0, __VA_ARGS__)
 
+/*
+ * Declare the dependency between a non-FGT register, a set of
+ * feature, and the set of individual bits it contains. This generates
+ * a struct reg_feat_map_desc.
+ */
+#define DECLARE_FEAT_MAP(n, r, m, f)					\
+	struct reg_feat_map_desc n = {					\
+		.name			= #r,				\
+		.feat_map		= NEEDS_FEAT(~r##_RES0, f), 	\
+		.bit_feat_map		= m,				\
+		.bit_feat_map_sz	= ARRAY_SIZE(m),		\
+	}
+
+/*
+ * Specialised version of the above for FGT registers that have their
+ * RES0 masks described as struct fgt_masks.
+ */
+#define DECLARE_FEAT_MAP_FGT(n, msk, m, f)				\
+	struct reg_feat_map_desc n = {					\
+		.name			= #msk,				\
+		.feat_map		= NEEDS_FEAT_RES0(&msk.res0, f),\
+		.bit_feat_map		= m,				\
+		.bit_feat_map_sz	= ARRAY_SIZE(m),		\
+	}
+
 #define FEAT_SPE		ID_AA64DFR0_EL1, PMSVer, IMP
 #define FEAT_SPE_FnE		ID_AA64DFR0_EL1, PMSVer, V1P2
 #define FEAT_BRBE		ID_AA64DFR0_EL1, BRBE, IMP
-- 
2.39.2

