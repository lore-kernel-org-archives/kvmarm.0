Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795461923;
	b=1QkXFkQ8stIXabDbMHCdAavHZZvgMe210BZR4FOoX0fAMc8zcXEAKRuMuwhUgalyBvef
	 zo1U2AFtx4X2UTc8LHBS7g+AYg6hMMHsTb2zGiFwRdRdMioJ/D4Ov6+9RoLQdfm/1Rr6b
	 sAwpJVrmDb+Iicy09QKYJ6ySm/OyoBikiNLs1inLw1tHxZzcFZd7USGEySUS0irr+pxCl
	 c2+P0gZJRrLEt9VV1PUEpN4oN9vxMqUpQIVUIvieN89Y5vo8noz2AP0LruYIvOfGJwHTL
	 I2Zr+uuhCWxfHOMN7XtHYG9GuXQl2wrGoE1J5mag9UKfONyemt+SahJKQzthL+Y4fjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795461923;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=zmVxPhrkR14QOKBOA497ooAnDetAusOCP6ZoyvLD3sA=;
	b=oCjLjaFWwFoY9cf2SUaqJCz/siBHydRxWd2JUYgJCFsIe8RgbedO1FA9PJziQqQqd5qX
	 Zg6Tj1vzIkQu0L6QsDTd8DW1vgWQaFpkOUb7lfUyrJjo2jCHOnfmgSWbzHb1slP2esF8M
	 yl9OZHgzJTUtcL2oi7N2GGHmLMj3dLXlwVJpk2anGob0p61xI3bpxNnqOF2fcKkcUHexK
	 zYuxSeIxxjduo/7D7C7ySsaCNZHMIn2cd4N/FPhB6MTR/XYvJt3xrQhL1LRXePzlZs5W1
	 O6IbQ6St4iDW0uPYgdurOZAJc+VP1ca209veiU3qx7S9sx6nknXcXLDbCpsmrQRLflw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cVg6EEUp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD38F606A31F;
	Mon, 23 Nov 2026 19:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cVg6EEUp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8AC1F000C6;
	Mon, 23 Nov 2026 19:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795461923;
	bh=zmVxPhrkR14QOKBOA497ooAnDetAusOCP6ZoyvLD3sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cVg6EEUptzy0VPQfFFH3wrWrJySAXz3x/yCfSGxOC80cTQqikrZdsGgFCN515Sbb5
	 48gXBGuP7Fi2fsP75+ON6U/+9PZmSy+QNvaSSSplZC1Y1zGMxEkpXXRhPJSMMTPXZJ
	 rvidbeasmP+6vp1XwiLGEAJY6zrkrpxvxZz95jbPw2tpahNN3cgwcuoGSYVnuPMV7n
	 pPrHcyFn8Cij4OyE5jxhhoM4OR2uwE8ocjPVzS4IixvlB52+VJIPEWQvwrbg3MLWU9
	 nT3TWwuIJsulxtOAdPaBU1wKEAV35oxy9eq3lYk6L91sXwUX+TN24emHjlt3i/vELL
	 jT/7/fPzv7d+Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=localhost.localdomain)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xVZfF-00000002A6V-16Dm;
	Mon, 23 Nov 2026 19:25:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH 1/3] KVM: arm64: Add enum support to idreg sanitisation
Date: Mon, 23 Nov 2026 19:24:55 +0000
Message-ID: <20261123192457.8700-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123192457.8700-1-maz@kernel.org>
References: <20261123192457.8700-1-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

While a good deal of ID register fields are simple booleans, simply
indicating whether a feature is supported, a number of them are more
structured and indicate a level of support.

Reuse the existing framework in a nested way to expose which level
applies for the current configuration. This relies on the levels
being ordered from the most to the least capable, and the fallback
to have a NULL callback.

Yes, this is pretty obscure, but the following patches will make
this clearer (at least one hopes...).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/config.c | 44 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index cfdb6c7133204..40965513ebacf 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -28,6 +28,7 @@ struct reg_bits_to_feat_map {
 #define	REQUIRES_E2H1	BIT(5)	/* Add HCR_EL2.E2H RES1 as a pre-condition */
 #define	RES1_WHEN_E2H0	BIT(6)	/* RES1 when E2H=0 and not supported */
 #define	RES1_WHEN_E2H1	BIT(7)	/* RES1 when E2H=1 and not supported */
+#define	IDREG_FIELDS	BIT(8)	/* idreg fields */
 
 	unsigned long	flags;
 
@@ -40,6 +41,7 @@ struct reg_bits_to_feat_map {
 			s8	lo_lim;
 		};
 		bool	(*match)(struct kvm *);
+		const struct reg_bits_to_feat_map *idreg_field_deps;
 	};
 };
 
@@ -73,6 +75,13 @@ struct reg_feat_map_desc {
 		.lo_lim	= id ##_## fld ##_## lim	\
 	}
 
+#define __NEEDS_FEAT_2(m, f, w, dummy, deps)		\
+	{						\
+		.w	= (m),				\
+		.flags = (f),				\
+		.idreg_field_deps = (deps),		\
+	}
+
 #define __NEEDS_FEAT_1(m, f, w, fun)			\
 	{						\
 		.w	= (m),				\
@@ -95,6 +104,11 @@ struct reg_feat_map_desc {
 #define NEEDS_FEAT_MASKS(p, ...)				\
 	__NEEDS_FEAT_FLAG(p, MASKS_POINTER, masks, __VA_ARGS__)
 
+#define NEEDS_FEAT_FIELD(m, ...)				\
+	__NEEDS_FEAT_FLAG(m, IDREG_FIELDS, bits, blah, __VA_ARGS__)
+
+#define ENUM_FEAT(e, f)	{ .bits = e, .match = f }
+
 /*
  * Declare the dependency between a set of bits and a set of features,
  * generating a struct reg_bit_to_feat_map.
@@ -1456,6 +1470,27 @@ static const struct reg_feat_map_desc *idreg_feat_maps[] = {
 	&id_aa64mmfr3_el1_desc,
 };
 
+static struct resx compute_idreg_field_deps(struct kvm *kvm,
+					    const struct reg_bits_to_feat_map *map)
+{
+	const struct reg_bits_to_feat_map *tmp;
+	struct resx resx;
+
+	/*
+	 * Assume the enum values are ordered in reverse order of
+	 * capability (from most to least capable). A NULL callback
+	 * value indicates the ultimate fallback (not implemented).
+	 */
+	for (tmp = map->idreg_field_deps; tmp->match; tmp++)
+		if (tmp->match(kvm))
+			break;
+
+	resx.res0 = field_prep(map->bits, ~(tmp->bits));
+	resx.res1 = field_prep(map->bits, tmp->bits);
+
+	return resx;
+}
+
 static bool idreg_apply_deps(struct kvm *kvm, const struct reg_feat_map_desc *r)
 {
 	struct resx resx = {};
@@ -1463,8 +1498,15 @@ static bool idreg_apply_deps(struct kvm *kvm, const struct reg_feat_map_desc *r)
 
 	for (int i = 0; i < r->bit_feat_map_sz; i++) {
 		if ((r->bit_feat_map[i].flags & CALL_FUNC) &&
-		    !r->bit_feat_map[i].match(kvm))
+		    !r->bit_feat_map[i].match(kvm)) {
 			resx.res0 |= reg_feat_map_bits(&r->bit_feat_map[i]);
+		} else if (r->bit_feat_map[i].flags & IDREG_FIELDS) {
+			struct resx tmp;
+
+			tmp = compute_idreg_field_deps(kvm, &r->bit_feat_map[i]);
+			resx.res0 |= tmp.res0;
+			resx.res1 |= tmp.res1;
+		}
 	}
 
 	val = kvm->arch.id_regs[r->idreg_idx];
-- 
2.47.3

