Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290BA3173E
	for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 17:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tScfZPZ8"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5a839b31a0dso149300427b3.0
        for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 09:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700068633; x=1700673433; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qy3zX0s6ALtK+DaG4wUXBjQ8F6aHRpWpiFcWV1cr/U0=;
        b=tScfZPZ8gLrJn0FBDXBasduSMVg9Xm5kQFFG3eYCFAFS34Nu5vQEJR0YGlD+Z+NIFv
         s2Taofrhs6rGIA0qV+WL5LUQVfVZ9TR3l5RXpyIbm8VQFfKHQSNTa68TvxjN1alXAwev
         D6r9wrDl1OTwxx8OXYLO8hkXNR2KT1OLaWW8WEmPLzHUn2LAayZogqJmHifg8tEQRunI
         LRgSoBAFjnoor3hudFU9ChmQ2KKxZf/Yp4r5JD0SecYkHIlDQ7CC3CWhtRMKrCo8gMKR
         +YmlvoneMF9b8KgwDAH+u06s++n0Z4e+wx3HB/WrTLO/IP2/4kudjl2f0o9JZ9Iao1Dg
         YAhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700068633; x=1700673433;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qy3zX0s6ALtK+DaG4wUXBjQ8F6aHRpWpiFcWV1cr/U0=;
        b=ejDWHg18qJNn/Fzv1QYmzY29vglE18RB2QY1Tjr42HiLVDl8L2c1EhwjNpX4Nu05vo
         ri4wOkID8pEGeTm0sJbveGen/+A1Yeilax+Iu5EdPRK7GwSD2Xk5q0wpAc56ySBSebzi
         BxwEWWALGcjqxj6oyMkNfqQbuzZ/IyrqLVtdG4Db8/gLqVYIfvrTM62PzBUN+ZKREAc3
         GZbDxFw8+HlMvoDNfff1bSENVOTJpiWCFhoGGsPza/VpyHUvgVsb5qLm/OrZF58Fg3hk
         esmLGcVwmxP/DwEsq0fVqZUWo8RhQzPX/NOC88VcjhFnxiOjGgEaQHraiRHohs7cDnWl
         +OoQ==
X-Gm-Message-State: AOJu0YysxIp+2gp916t91OYGbS+8XZxU0cRy33kJel/ihuPAxzUkKxOJ
	Yc8/7Nh9dLPor5fOHySUDgp9mLHHTtpzJApbi8A=
X-Google-Smtp-Source: AGHT+IH15zotRvXqa3gGL+erJN8kJ8qtR4AedLWdqyhduoqwJwWiS5LNpUVQnjgpQUblW7SZJCRmmCsMHRZC6boVABk=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a0d:d7c3:0:b0:5a7:b672:4d88 with SMTP
 id z186-20020a0dd7c3000000b005a7b6724d88mr356731ywd.0.1700068633096; Wed, 15
 Nov 2023 09:17:13 -0800 (PST)
Date: Wed, 15 Nov 2023 17:16:38 +0000
In-Reply-To: <20231115171639.2852644-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231115171639.2852644-2-sebastianene@google.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
Message-ID: <20231115171639.2852644-10-sebastianene@google.com>
Subject: [PATCH v3 08/10] arm64: ptdump: Interpret memory attributes based on
 runtime configuration
From: Sebastian Ene <sebastianene@google.com>
To: will@kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, catalin.marinas@arm.com, mark.rutland@arm.com, 
	akpm@linux-foundation.org, maz@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, vdonnefort@google.com, 
	qperret@google.com, smostafa@google.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

When FWB is used the memory attributes stored in the descriptors have a
different bitfield layout. Introduce two callbacks that verify the current
runtime configuration before parsing the attribute fields.
Add support for parsing the memory attribute fields from the page table
descriptors.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/mm/ptdump.c | 65 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 64 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index 9f88542d5312..ec7f6430f6d7 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -89,11 +89,19 @@ struct pg_state {
 	struct ptdump_info_file_priv *f_priv;
 };
 
+/*
+ * This callback checks the runtime configuration before interpreting the
+ * attributes defined in the prot_bits.
+ */
+typedef bool (*is_feature_cb)(const void *ctx);
+
 struct prot_bits {
 	u64		mask;
 	u64		val;
 	const char	*set;
 	const char	*clear;
+	is_feature_cb   feature_on;  /* bit ignored if the callback returns false */
+	is_feature_cb   feature_off; /* bit ignored if the callback returns true */
 };
 
 static const struct prot_bits pte_bits[] = {
@@ -175,6 +183,34 @@ static const struct prot_bits pte_bits[] = {
 	}
 };
 
+static bool is_fwb_enabled(const void *ctx)
+{
+	const struct pg_state *st = ctx;
+	struct ptdump_info_file_priv *f_priv = st->f_priv;
+	struct kvm_pgtable_snapshot *snapshot = f_priv->file_priv;
+	struct kvm_pgtable *pgtable = &snapshot->pgtable;
+
+	bool fwb_enabled = false;
+
+	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
+		fwb_enabled = !(pgtable->flags & KVM_PGTABLE_S2_NOFWB);
+
+	return fwb_enabled;
+}
+
+static bool is_table_bit_ignored(const void *ctx)
+{
+	const struct pg_state *st = ctx;
+
+	if (!(st->current_prot & PTE_VALID))
+		return true;
+
+	if (st->level == CONFIG_PGTABLE_LEVELS)
+		return true;
+
+	return false;
+}
+
 static const struct prot_bits stage2_pte_bits[] = {
 	{
 		.mask	= PTE_VALID,
@@ -216,6 +252,27 @@ static const struct prot_bits stage2_pte_bits[] = {
 		.val	= PTE_TABLE_BIT,
 		.set	= "   ",
 		.clear	= "BLK",
+		.feature_off	= is_table_bit_ignored,
+	}, {
+		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR | PTE_VALID,
+		.val	= PTE_S2_MEMATTR(MT_S2_DEVICE_nGnRE) | PTE_VALID,
+		.set	= "DEVICE/nGnRE",
+		.feature_off	= is_fwb_enabled,
+	}, {
+		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR | PTE_VALID,
+		.val	= PTE_S2_MEMATTR(MT_S2_FWB_DEVICE_nGnRE) | PTE_VALID,
+		.set	= "DEVICE/nGnRE FWB",
+		.feature_on	= is_fwb_enabled,
+	}, {
+		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR | PTE_VALID,
+		.val	= PTE_S2_MEMATTR(MT_S2_NORMAL) | PTE_VALID,
+		.set	= "MEM/NORMAL",
+		.feature_off	= is_fwb_enabled,
+	}, {
+		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR | PTE_VALID,
+		.val	= PTE_S2_MEMATTR(MT_S2_FWB_NORMAL) | PTE_VALID,
+		.set	= "MEM/NORMAL FWB",
+		.feature_on	= is_fwb_enabled,
 	}, {
 		.mask	= KVM_PGTABLE_PROT_SW0,
 		.val	= KVM_PGTABLE_PROT_SW0,
@@ -267,13 +324,19 @@ static struct pg_level pg_level[] = {
 };
 
 static void dump_prot(struct pg_state *st, const struct prot_bits *bits,
-			size_t num)
+		      size_t num)
 {
 	unsigned i;
 
 	for (i = 0; i < num; i++, bits++) {
 		const char *s;
 
+		if (bits->feature_on && !bits->feature_on(st))
+			continue;
+
+		if (bits->feature_off && bits->feature_off(st))
+			continue;
+
 		if ((st->current_prot & bits->mask) == bits->val)
 			s = bits->set;
 		else
-- 
2.43.0.rc0.421.g78406f8d94-goog

