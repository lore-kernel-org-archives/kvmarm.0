Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B872A498A9
	for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 14:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C3wUGAlD"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3366bf4adbcso359898f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 06:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702908005; x=1703512805; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/DzJPItky+7MIXN0FJdMX89fRzHYJTFATAafmjRyPww=;
        b=C3wUGAlDh6B1C0LfS6cB5eR3xItbsYBwPq5QoJ2nxBmQlzMsNe6LrxHxqR1nogKrZ0
         1qfYbKiWk/S7JZ/LdGW1GuGgCWwXlLGjL+QIbZNKWGQ2fGqWc3BjkxRKnyQZdFccyhnU
         WGrxz8MMUQhFI8/FSz7cJzio63yi+Z4bcd/Qp7GvEoQyxx/H9cHReU/Qt+khCrWs4bLN
         spqCHYT9voC25ZYeV8og5cOXfGgMTmScDdNB3Q9z6LL2BG8zHN4b9icc0mxEsvu8asVH
         PRdhQqt2y2tybHomK7ragHaqmWIsFHu2DYNkzH8lFdmK5fYXm6u+ZaNFk38MOjgcCDPb
         5vkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702908005; x=1703512805;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/DzJPItky+7MIXN0FJdMX89fRzHYJTFATAafmjRyPww=;
        b=HWt97s+XgxgeQB1//8Q7suYfbr3KB3Fyce6ps92BZRiEIXqMti9KzMAT2SyzWKxAW4
         BTeuUBv74qJH6lrexDd3qIJf1+Q3QuYF3DJ29mQ2iNbtbQ0scxnZ8tAX+Yd6tM403C50
         5mnNMzjftWCFGwcNHrfyL7SsnOILOXE8CjhPEU/HcR9YFDirTZMDKUGtPQOiHD9FlV+1
         fbkYg9rriyNR3OxNwquv53wl+clnnzjZU2aWER6otImKTqnxe3JfOjfq4ZeQ9/WpgsNC
         4ZT8AeWtngZXmslODr1oN4y6x28vArH5i6c/FinioEgdFxtFglgP9bUroXp9odp2L1E0
         qR7w==
X-Gm-Message-State: AOJu0YwRO1UROW/y0PtIaMv061Np/P8x86bJMZnk8p+DFzs7xiNBCnmy
	iagkLMfHOUUyOL7gDEX71EOj8tZhvOWxurVi9v0=
X-Google-Smtp-Source: AGHT+IFva+9bduuuV31oR8xkc8BswjCQxwwMXxhfSUj0PJxjfOR04yw1jMSSd5Mf5dzNJ/J+K9OLoYJn4glXAxT7l0Q=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:adf:d1cf:0:b0:333:5232:d7f5 with SMTP
 id b15-20020adfd1cf000000b003335232d7f5mr91065wrd.8.1702908005046; Mon, 18
 Dec 2023 06:00:05 -0800 (PST)
Date: Mon, 18 Dec 2023 13:58:58 +0000
In-Reply-To: <20231218135859.2513568-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231218135859.2513568-2-sebastianene@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231218135859.2513568-10-sebastianene@google.com>
Subject: [PATCH v4 08/10] arm64: ptdump: Interpret memory attributes based on
 the runtime config
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

Introduce two callbacks that verify the current runtime configuration
before parsing the attribute fields. This is used to check when FWB is
enabled which changes the interpretation of the descriptor bits.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/ptdump.h |  7 +++++++
 arch/arm64/kvm/ptdump.c         | 32 ++++++++++++++++++++++++++++++++
 arch/arm64/mm/ptdump.c          |  6 ++++++
 3 files changed, 45 insertions(+)

diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
index 4e728d2a1..e150fc21f 100644
--- a/arch/arm64/include/asm/ptdump.h
+++ b/arch/arm64/include/asm/ptdump.h
@@ -23,11 +23,18 @@ struct ptdump_info {
 	unsigned long			base_addr;
 };
 
+/* Forward declaration */
+struct pg_state;
+
 struct prot_bits {
 	u64		mask;
 	u64		val;
 	const char	*set;
 	const char	*clear;
+	/* bit ignored if the callback returns false */
+	bool		(*feature_on)(const struct pg_state *ctxt);
+	/* bit ignored if the callback returns true */
+	bool		(*feature_off)(const struct pg_state *ctxt);
 };
 
 struct pg_level {
diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index 80c338e03..0ad7944e5 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -40,6 +40,18 @@ static struct kvm_pgtable_mm_ops ptdump_host_mmops = {
 	.virt_to_phys	= get_host_pa,
 };
 
+static bool is_fwb_enabled(const struct pg_state *m)
+{
+	struct kvm_pgtable_snapshot *snapshot = m->seq->private;
+	struct kvm_pgtable *pgtable = &snapshot->pgtable;
+	bool fwb_enabled = false;
+
+	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
+		fwb_enabled = !(pgtable->flags & KVM_PGTABLE_S2_NOFWB);
+
+	return fwb_enabled;
+}
+
 static const struct prot_bits stage2_pte_bits[] = {
 	{
 		.mask	= PTE_VALID,
@@ -81,6 +93,26 @@ static const struct prot_bits stage2_pte_bits[] = {
 		.val	= PTE_TABLE_BIT,
 		.set	= "   ",
 		.clear	= "BLK",
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
diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index 015ed65d3..6c7208f66 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -177,6 +177,12 @@ static void dump_prot(struct pg_state *st, const struct prot_bits *bits,
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
2.43.0.472.g3155946c3a-goog

