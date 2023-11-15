Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B162EAE6
	for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 17:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q0nRQb1U"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5bc3be6a91bso8956357b3.1
        for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 09:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700068630; x=1700673430; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zCmrW40F76i5JztVQV1SbSI81TwYB1s24Z+PnC9WnV4=;
        b=q0nRQb1UNRG48rDx1B0yurrD2dH99qzBkW33jicR4ssEfnda75hvafjrmoNxk6sC5t
         bGtPFqxGwbQnahQImEW5elxXDZok8F3uu+g0TbTTswMEXGO30F1jXeDFTQ1Qg8UmL8Jp
         pOj4c3ZNMHOsGX9PfYV5bHyzH2jV0iVeoEZMK47OfQKUzH67R7qBBOf8r22N34NIb8QV
         8jYy0gF3exod+0c8c0becPd6YjE16l+DiVjfs1YVtsGRNWmO49ApiiKTxsEF7OM0CuWM
         p/wn1Yv3SXPac/uW6VF8zDKaCzGt0YhMyKY7+KzCZcPj+RqCZt5O3UiS1CxobEm/xW9S
         Z1Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700068630; x=1700673430;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zCmrW40F76i5JztVQV1SbSI81TwYB1s24Z+PnC9WnV4=;
        b=B+s63QYf+3JzC3IgUrswYKdUvOX5YnceM0zYHifXZkCU6A2zqjmchqQol1vx7I6AIQ
         ZiaBOQCdv+z4Ifu+BPX5tOE9xA9EORHGj32YNltNW5jJ1Vkv3fNAdb97uAB5nYYW9dU1
         p5z4OP7zhmAREEJrTNXM/vB9mV7TBjr20/LyH3W4l2B8fQ+iWm3+1EosDgjvhpuBlJrp
         eLW0DjJ3IAmtADpuieY1QyuhayDi3MMU2S5K/HnkjK09cCJLjQOeoY3Dz5zsRnpUGuCX
         UXzzfyje7dCIAI009SJbvSoCjYopCA1JlgsXazF5mbM7CfS7vLX76hTCPiAV73ZGCL9f
         ckVw==
X-Gm-Message-State: AOJu0Yz7RsPZzLUJM+LQmtkKB5eRFrAOpENYnp1wjZDg/lUxxb3nUMHx
	hatpKWRj10ldO9VoJKHL6fdxmx9Fnon9AIDqc/0=
X-Google-Smtp-Source: AGHT+IELfUQoq3/g4kbIGiBRU7VsMlUAs35EiaE420fomxFsRN5Mm1Zx4hWdYOb+MaGSa4SgHhjdvgBzYWcJ8schaZk=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a0d:c046:0:b0:5be:9742:cc3e with SMTP
 id b67-20020a0dc046000000b005be9742cc3emr200344ywd.2.1700068630474; Wed, 15
 Nov 2023 09:17:10 -0800 (PST)
Date: Wed, 15 Nov 2023 17:16:37 +0000
In-Reply-To: <20231115171639.2852644-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231115171639.2852644-2-sebastianene@google.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
Message-ID: <20231115171639.2852644-9-sebastianene@google.com>
Subject: [PATCH v3 07/10] arm64: ptdump: Parse the host stage-2 page-tables
 from the snapshot
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

Add a walker function which configures ptdump to parse the page-tables
from the snapshot. Define the attributes used by the stage-2 parser and
build a description of an array which holds the name of the level.
Walk the entire address space configured in the pagetable and parse the
attribute descriptors.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/mm/ptdump.c | 157 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 157 insertions(+)

diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index 0b4cb54e43ff..9f88542d5312 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -86,6 +86,7 @@ struct pg_state {
 	bool check_wx;
 	unsigned long wx_pages;
 	unsigned long uxn_pages;
+	struct ptdump_info_file_priv *f_priv;
 };
 
 struct prot_bits {
@@ -174,6 +175,66 @@ static const struct prot_bits pte_bits[] = {
 	}
 };
 
+static const struct prot_bits stage2_pte_bits[] = {
+	{
+		.mask	= PTE_VALID,
+		.val	= PTE_VALID,
+		.set	= " ",
+		.clear	= "F",
+	}, {
+		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
+		.val	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
+		.set	= "XN",
+		.clear	= "  ",
+	}, {
+		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R,
+		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R,
+		.set	= "R",
+		.clear	= " ",
+	}, {
+		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
+		.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
+		.set	= "W",
+		.clear	= " ",
+	}, {
+		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_AF,
+		.val	= KVM_PTE_LEAF_ATTR_LO_S2_AF,
+		.set	= "AF",
+		.clear	= "  ",
+	}, {
+		.mask	= PTE_NG,
+		.val	= PTE_NG,
+		.set	= "FnXS",
+		.clear	= "  ",
+	}, {
+		.mask	= PTE_CONT,
+		.val	= PTE_CONT,
+		.set	= "CON",
+		.clear	= "   ",
+	}, {
+		.mask	= PTE_TABLE_BIT,
+		.val	= PTE_TABLE_BIT,
+		.set	= "   ",
+		.clear	= "BLK",
+	}, {
+		.mask	= KVM_PGTABLE_PROT_SW0,
+		.val	= KVM_PGTABLE_PROT_SW0,
+		.set	= "SW0", /* PKVM_PAGE_SHARED_OWNED */
+	}, {
+		.mask   = KVM_PGTABLE_PROT_SW1,
+		.val	= KVM_PGTABLE_PROT_SW1,
+		.set	= "SW1", /* PKVM_PAGE_SHARED_BORROWED */
+	}, {
+		.mask	= KVM_PGTABLE_PROT_SW2,
+		.val	= KVM_PGTABLE_PROT_SW2,
+		.set	= "SW2",
+	}, {
+		.mask   = KVM_PGTABLE_PROT_SW3,
+		.val	= KVM_PGTABLE_PROT_SW3,
+		.set	= "SW3",
+	},
+};
+
 struct pg_level {
 	const struct prot_bits *bits;
 	const char *name;
@@ -286,6 +347,7 @@ static void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
 			delta >>= 10;
 			unit++;
 		}
+
 		pt_dump_seq_printf(st->seq, "%9lu%c %s", delta, *unit,
 				   pg_info[st->level].name);
 		if (st->current_prot && pg_info[st->level].bits)
@@ -394,6 +456,11 @@ static void *ptdump_host_va(phys_addr_t phys)
 	return __va(phys);
 }
 
+static struct kvm_pgtable_mm_ops host_mmops = {
+	.phys_to_virt	=	ptdump_host_va,
+	.virt_to_phys	=	ptdump_host_pa,
+};
+
 static size_t stage2_get_pgd_len(void)
 {
 	u64 mmfr0, mmfr1, vtcr;
@@ -528,6 +595,95 @@ static void stage2_ptdump_end_walk(void *file_priv)
 	f_priv->file_priv = NULL;
 }
 
+static int stage2_ptdump_visitor(const struct kvm_pgtable_visit_ctx *ctx,
+				 enum kvm_pgtable_walk_flags visit)
+{
+	struct pg_state *st = ctx->arg;
+	struct ptdump_state *pt_st = &st->ptdump;
+
+	pt_st->note_page(pt_st, ctx->addr, ctx->level, ctx->old);
+
+	return 0;
+}
+
+static void stage2_ptdump_build_levels(struct pg_level *level,
+				       size_t num_levels,
+				       unsigned int start_level)
+{
+	static const char * const lvl_names[] = {"PGD", "PUD", "PMD", "PTE"};
+	int i, j, name_index;
+
+	if (num_levels > KVM_PGTABLE_MAX_LEVELS && start_level > 2) {
+		pr_warn("invalid configuration %lu levels start_lvl %u\n",
+			num_levels, start_level);
+		return;
+	}
+
+	for (i = start_level; i < num_levels; i++) {
+		name_index = i - start_level;
+		name_index = name_index * start_level + name_index;
+
+		level[i].name	= lvl_names[name_index];
+		level[i].num	= ARRAY_SIZE(stage2_pte_bits);
+		level[i].bits	= stage2_pte_bits;
+
+		for (j = 0; j < level[i].num; j++)
+			level[i].mask |= level[i].bits[j].mask;
+	}
+}
+
+static void stage2_ptdump_walk(struct seq_file *s, struct ptdump_info *info)
+{
+	struct ptdump_info_file_priv *f_priv =
+		container_of(info, struct ptdump_info_file_priv, info);
+	struct kvm_pgtable_snapshot *snapshot = f_priv->file_priv;
+	struct pg_state st;
+	struct kvm_pgtable *pgtable;
+	u64 start_ipa = 0, end_ipa;
+	struct addr_marker ipa_address_markers[3];
+	struct pg_level stage2_pg_level[KVM_PGTABLE_MAX_LEVELS] = {0};
+	struct kvm_pgtable_walker walker = (struct kvm_pgtable_walker) {
+		.cb	= stage2_ptdump_visitor,
+		.arg	= &st,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+	};
+
+	if (snapshot == NULL || !snapshot->pgtable.pgd)
+		return;
+
+	pgtable = &snapshot->pgtable;
+	pgtable->mm_ops = &host_mmops;
+	end_ipa = BIT(pgtable->ia_bits) - 1;
+
+	memset(&ipa_address_markers[0], 0, sizeof(ipa_address_markers));
+
+	ipa_address_markers[0].start_address = start_ipa;
+	ipa_address_markers[0].name = "IPA start";
+
+	ipa_address_markers[1].start_address = end_ipa;
+	ipa_address_markers[1].name = "IPA end";
+
+	stage2_ptdump_build_levels(stage2_pg_level, KVM_PGTABLE_MAX_LEVELS,
+				   pgtable->start_level);
+
+	st = (struct pg_state) {
+		.seq		= s,
+		.marker		= &ipa_address_markers[0],
+		.level		= -1,
+		.pg_level	= &stage2_pg_level[0],
+		.f_priv		= f_priv,
+		.ptdump		= {
+			.note_page	= note_page,
+			.range		= (struct ptdump_range[]) {
+				{start_ipa,	end_ipa},
+				{0,		0},
+			},
+		},
+	};
+
+	kvm_pgtable_walk(pgtable, start_ipa, end_ipa, &walker);
+}
+
 void ptdump_register_host_stage2(void)
 {
 	if (!is_protected_kvm_enabled())
@@ -537,6 +693,7 @@ void ptdump_register_host_stage2(void)
 		.mc_len			= host_s2_pgtable_pages(),
 		.ptdump_prepare_walk	= stage2_ptdump_prepare_walk,
 		.ptdump_end_walk	= stage2_ptdump_end_walk,
+		.ptdump_walk		= stage2_ptdump_walk,
 	};
 
 	ptdump_debugfs_kvm_register(&stage2_kernel_ptdump_info,
-- 
2.43.0.rc0.421.g78406f8d94-goog

