Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D5E3FE5F
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 18:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705947241; cv=none; b=lqVL4Nnfqfn7BuEafBZHW2uLTxMZyKJjw6lsJfQ2ydx+m4E1g0B/J9JlNQr1XeXmfrZX8FgZl45HYnhNNQ6TcF8Kct5lMUv28RipGdqvm4IqDXM0DTWGjwLw6s/WAocGzqJeN5Bn8wR/QS4qBrF+wVuuhBE/UslHkfnkJAG4W6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705947241; c=relaxed/simple;
	bh=UJUVs1f7SdxbKhYXIn8XehU00EWM+MRvA1lbvV+XJN8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rEDNixKGLKqO+BxLEtvIpWZqhS5x9ygZGBJEK9PgRcUgdLNv38tg9FFsqJ52fvv/uGYz4Uj4x1TwZVhZwKCBfnQVP6z36T3Ej4Dz4rNYN+xRGG2OUoj7Y7J4C/Vi5aF3lhm6WBc+vMzQhYvw5t7EpLWLGXjBHMUzZEO3HIaHR1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n5Qgxc4a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n5Qgxc4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16D7C433A6;
	Mon, 22 Jan 2024 18:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705947241;
	bh=UJUVs1f7SdxbKhYXIn8XehU00EWM+MRvA1lbvV+XJN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5Qgxc4a3wMJ9s6IwN9D5fqfRs9mn9WxSQej/8pJIA/62ZL938y5th5J6XM6IT0Zx
	 iK1VTScrUYyhNpZdF1vPM+I6x8yWZk0VU+NqPIInZAsRovOzXmbo5Q569SslihOacZ
	 Lqsm/8qmSde8XO1ubqnnqKXIrZMN6r1rjunMMw5mymkB5YO/HutFQzE2sjqtPCMS7M
	 wm1xSqG81yhPlGUVASn7/meN/9jPrDVHYdV6xrdvJwNMnbuGwN0Iqm1C8FKZBxP1p9
	 rbkNfJAdTzXoVCfqx2pM+leSzKocLk47NsHihVo13SUdxbEzKwJK6I5sB2sGm+yECz
	 gobeuM3iCPVaQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rRyo2-00Dh6E-Q8;
	Mon, 22 Jan 2024 18:13:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v4 02/10] arm64: cpufeatures: Correctly handle signed values
Date: Mon, 22 Jan 2024 18:13:36 +0000
Message-Id: <20240122181344.258974-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122181344.258974-1-maz@kernel.org>
References: <20240122181344.258974-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, suzuki.poulose@arm.com, ardb@kernel.org, james.morse@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Although we've had signed values for some features such as PMUv3
and FP, the code that handles the comparaison with some limit
has a couple of annoying issues:

- the min_field_value is always unsigned, meaning that we cannot
  easily compare it with a negative value

- it is not possible to have a range of values, let alone a range
  of negative values

Fix this by:

- adding an upper limit to the comparison, defaulting to all bits
  being set to the maximum positive value

- ensuring that the signess of the min and max values are taken into
  account

A ARM64_CPUID_FIELDS_NEG() macro is provided for signed features, but
nothing is using it yet.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h |  1 +
 arch/arm64/kernel/cpufeature.c      | 65 +++++++++++++++++++++++++----
 2 files changed, 57 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 21c824edf8ce..a98d95f3492b 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -363,6 +363,7 @@ struct arm64_cpu_capabilities {
 			u8 field_pos;
 			u8 field_width;
 			u8 min_field_value;
+			u8 max_field_value;
 			u8 hwcap_type;
 			bool sign;
 			unsigned long hwcap;
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 8d1a634a403e..92b1546f2622 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -140,12 +140,42 @@ void dump_cpu_features(void)
 	pr_emerg("0x%*pb\n", ARM64_NCAPS, &system_cpucaps);
 }
 
+#define __ARM64_MAX_POSITIVE(reg, field)				\
+		((reg##_##field##_SIGNED ?				\
+		  BIT(reg##_##field##_WIDTH - 1) :			\
+		  BIT(reg##_##field##_WIDTH)) - 1)
+
+#define __ARM64_MIN_NEGATIVE(reg, field)  BIT(reg##_##field##_WIDTH - 1)
+
+#define __ARM64_CPUID_FIELDS(reg, field, min_value, max_value)		\
+		.sys_reg = SYS_##reg,					\
+		.field_pos = reg##_##field##_SHIFT,			\
+		.field_width = reg##_##field##_WIDTH,			\
+		.sign = reg##_##field##_SIGNED,				\
+		.min_field_value = min_value,				\
+		.max_field_value = max_value,
+
+/*
+ * ARM64_CPUID_FIELDS() encodes a field with a range from min_value to
+ * an implicit maximum that depends on the sign-ess of the field.
+ *
+ * An unsigned field will be capped at all ones, while a signed field
+ * will be limited to the positive half only.
+ */
 #define ARM64_CPUID_FIELDS(reg, field, min_value)			\
-		.sys_reg = SYS_##reg,							\
-		.field_pos = reg##_##field##_SHIFT,						\
-		.field_width = reg##_##field##_WIDTH,						\
-		.sign = reg##_##field##_SIGNED,							\
-		.min_field_value = reg##_##field##_##min_value,
+	__ARM64_CPUID_FIELDS(reg, field,				\
+			     SYS_FIELD_VALUE(reg, field, min_value),	\
+			     __ARM64_MAX_POSITIVE(reg, field))
+
+/*
+ * ARM64_CPUID_FIELDS_NEG() encodes a field with a range from an
+ * implicit minimal value to max_value. This should be used when
+ * matching a non-implemented property.
+ */
+#define ARM64_CPUID_FIELDS_NEG(reg, field, max_value)			\
+	__ARM64_CPUID_FIELDS(reg, field,				\
+			     __ARM64_MIN_NEGATIVE(reg, field),		\
+			     SYS_FIELD_VALUE(reg, field, max_value))
 
 #define __ARM64_FTR_BITS(SIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) \
 	{						\
@@ -1451,11 +1481,28 @@ has_always(const struct arm64_cpu_capabilities *entry, int scope)
 static bool
 feature_matches(u64 reg, const struct arm64_cpu_capabilities *entry)
 {
-	int val = cpuid_feature_extract_field_width(reg, entry->field_pos,
-						    entry->field_width,
-						    entry->sign);
+	int val, min, max;
+	u64 tmp;
+
+	val = cpuid_feature_extract_field_width(reg, entry->field_pos,
+						entry->field_width,
+						entry->sign);
+
+	tmp = entry->min_field_value;
+	tmp <<= entry->field_pos;
+
+	min = cpuid_feature_extract_field_width(tmp, entry->field_pos,
+						entry->field_width,
+						entry->sign);
+
+	tmp = entry->max_field_value;
+	tmp <<= entry->field_pos;
+
+	max = cpuid_feature_extract_field_width(tmp, entry->field_pos,
+						entry->field_width,
+						entry->sign);
 
-	return val >= entry->min_field_value;
+	return val >= min && val <= max;
 }
 
 static u64
-- 
2.39.2

