Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CD522EFC
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 17:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZdOCqQww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34441C433C7;
	Mon, 13 Nov 2023 17:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699897424;
	bh=2/jpT2ThMNpF5uIulka4/RucBPTS/TEVnwOufL80Y8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdOCqQwwdfTo6fqv9v+Yq1poDjjMXq0ivHQPPjntOi4C2hUzE76Tyjzi+ytIGD86E
	 0AZadXivOc7KbvJwuPcEhYWnx5inBOGpvaPwz0n27Zm+jUdU6l7AyrhIbo8GklJl7P
	 FH2hNngO75QJq2tmcBq15x3tmI7XV8/FlCnBNG9WuU19Esrycy/3M0LcHeL2rABh5K
	 b1VBa0aIx+l7k2Uhec5SMjgugWbWH9hTbtwcVTmM3s9LU9QW/52vmbNsw4wPInWNLh
	 c8ZeWKrcbzMHqo2zWebyUyDOJKfCiXwO/1Z8DAwhNHmDM6wscYltBlzG+YdU3U9Zhv
	 gamOP6op30sEQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r2ayL-00CkQ4-Oy;
	Mon, 13 Nov 2023 17:43:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 01/12] arm64: cpufeatures: Correctly handle signed values
Date: Mon, 13 Nov 2023 17:42:33 +0000
Message-Id: <20231113174244.3026520-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231113174244.3026520-1-maz@kernel.org>
References: <20231113174244.3026520-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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
 arch/arm64/kernel/cpufeature.c      | 66 +++++++++++++++++++++++++----
 2 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index f6d416fe49b0..5f3f62efebd5 100644
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
index 646591c67e7a..e52d2c2b757f 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -140,12 +140,43 @@ void dump_cpu_features(void)
 	pr_emerg("0x%*pb\n", ARM64_NCAPS, &system_cpucaps);
 }
 
+#define __ARM64_EXPAND_RFV(reg, field, val)	reg##_##field##_##val
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
+			     __ARM64_EXPAND_RFV(reg, field, min_value),	\
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
+			     __ARM64_EXPAND_RFV(reg, field, max_value))
 
 #define __ARM64_FTR_BITS(SIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) \
 	{						\
@@ -1470,11 +1501,28 @@ has_always(const struct arm64_cpu_capabilities *entry, int scope)
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

