Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937478;
	b=zoTQHZVvfeGTcIuPIvx+RcjnZ2XytHjk46TwLfiPIn/kdy5ek1BtbaCZ9a9PJzYBfWQx
	 qyQbhXU7EpIL9pAyYvZNGDWKxnYnZkaqajrQd87lKTom2+qFGXcI03n5z7VYnW/xQI2ou
	 WMeLLg0w1y3/E66rv3noQci1hfBhiPyfG7gtJ31bGB/BLgdBhX348m5SOlmFI5vaF6kup
	 fYZansTC1E53MAUjSMTmS5mtNu/aUHA/A6bvSMp4ZpWMhq7zpFIcZv8mOJdseZyi4o1RA
	 l61GrjXWVYZzH9Rs1ysh+U6rvnDIaXdHvpOwpCWaK/Q8C3MHKtOoM84ByG2KrP6b1RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937478;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=77KTT6cZRuUNbEJIodQuWC6IG6JmRZH/uyPXy4jlweQ=;
	b=HaJ+GJnHEiV3ocf3ODtQh1vePgm1VU2Pkq34QcvIAReWSna4GCSI/xoTGud8t0C0UonH
	 rrtut/JWlaN4x1BpODmpORfh07jsqDBoucMLSp/vOtCjA2Oyz/JnFiyViMGs78AZ4a+Jc
	 6WNZV7tRyGDJGSXRkteVrY/RvxnlHbzKL3j3jo5l3zlC89J48SlfdMcSar3PYkEXETLHb
	 bp42buywpMELLUPBRTdEgD7lC5Kl1iWcuonF0Lvmrv+0S7+C2rm/r9g5Cmv2obD531OGM
	 66MXQqueRce/8MT0IjYM3UDNI+iD+KumP9/Hluub21T7t5wa4WR1pzsah4g36sFg+qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Yaz8mVUI;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F459606A32C
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:44:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F459606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Yaz8mVUI
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a20e41008cso1011285e9.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937477; x=1795542277; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=77KTT6cZRuUNbEJIodQuWC6IG6JmRZH/uyPXy4jlweQ=;
        b=Yaz8mVUIaeO8mvNmpUatNnbDl2whgnHf3PSX7dCpkVlheC5L+4PWaxFLv5ZSRuqKGc
         8JZzaph6q3SJhq9PTz5eOIzDi0TFr+kT6iDj96qDLYuGCPEbH312wKK4GLCW/hqgLTj/
         WTj+We5BKsWwtEV7PzA9AlXy0XNfWGMHVfEh1Fh975HvgDJOjU/1SaJPVdFa5WaSlrBp
         G4hH+8HfZDUN/fHA7WhbELfSRe6GZaYbVhSZyFSc41i000PLWRyk+sjU2pvHGlaW7SFc
         8Gz2AFQ+YXezLCdXU3eo9yDWZDgddyXLGiYKhC2BnTDylHZuAaxCuRWYMmLyR0kk03I/
         J5Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937477; x=1795542277;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=77KTT6cZRuUNbEJIodQuWC6IG6JmRZH/uyPXy4jlweQ=;
        b=vbLmsIRjD9JPujNV2MbKbjnFB6lM8jbazT1aXfvA/ekMJdrb3xrUXvSw7KBcGr7ut6
         ro1J0v3lI0a+qCJELKN+rsmEij/Hw9nlNp3Irg2BeuLTJ2lM02L5Xo6Zfz1pz1h07uUM
         q8sIdiMjvin9bGqmVE9mqncd0RRwsFe742pGJd5o13ct+xBkdJ+rsjqTbWmTya59Mmjl
         AWScdzKcm5BkNMhk67/LFjQb7Py0fYYFxsgpWD0++pr/aGMa9dSQDN/CPt/FpUX2+aks
         0aSNjrMNz04wpMPv38Bzt7idq2lmCS/ZUn210gGTIj6tKuJYrCuZdaA3AiRrWXx61uWj
         /Gqg==
X-Forwarded-Encrypted: i=1; AL+hErGfeZRMqViAgQWyWS4rVDikmvhv5D3NsejkFtxE9L48yXLOsvmvt1FHdcOuiMvxsptGvSgnQN8=@lists.linux.dev
X-Gm-Message-State: APuU4Z8hO1DfNxCnivQVD9P+0VdDU627irvNj1gidgd0X7n2E+Obe+aT
	eXP54Fz8+Hl/9kZyxjuJauksM3zUAXqoHN5Ur00qa0mGeDueuNe3PiCCiaXbnWg9H8BoNIZY1BU
	uoVJ7lsvWHQaiH2971GLS4A==
X-Received: from wrvi15.prod.google.com ([2002:a5d:558f:0:b0:49e:3982:e207])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:428c:b0:4a1:9661:14b5 with SMTP id 5b1f17b1804b1-4bb55aabd53mr199317825e9.29.1794937476762;
 Tue, 17 Nov 2026 09:44:36 -0800 (PST)
Date: Tue, 17 Nov 2026 17:43:57 +0000
In-Reply-To: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261117174403.58762-19-vdonnefort@google.com>
Subject: [PATCH v4 18/23] KVM: arm64: Introduce kvm_pgtable_stage2_table_install()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The existing kvm_pgtable_stage2_split() is unfit for pKVM: it relies on
kvm_mmu_memory_cache which pKVM doesn't use and has no easy way to
handle pKVM-specific annotations.

Add the pgtable helper kvm_pgtable_stage2_table_install() so pKVM can
handle block splitting in mem_protect.c. That helper can take a table
either populated with kvm_pgtable_stage2_create_unlinked() or one filled
with annotations.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 13 +++++
 arch/arm64/kvm/hyp/pgtable.c         | 86 ++++++++++++++++++++++++----
 2 files changed, 88 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 1c9c57cd6ae4..5d5d2165dbec 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -835,6 +835,19 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
 int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			     struct kvm_mmu_memory_cache *mc);
 
+/**
+ * kvm_pgtable_stage2_table_install() - Replace a stage-2 leaf entry with a table.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
+ * @table:	Unlinked stage-2 paging structure to install, such as one
+ *		created by kvm_pgtable_stage2_create_unlinked().
+ * @addr:	Address identifying the leaf entry to replace.
+ * @level:	Level of the leaf entry to replace.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kvm_pgtable_stage2_table_install(struct kvm_pgtable *pgt, kvm_pte_t *table,
+				     u64 addr, s8 level);
+
 /**
  * kvm_pgtable_walk() - Walk a page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index abd32e94f6ff..1ad4f854c442 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1537,18 +1537,38 @@ static int stage2_block_get_nr_page_tables(s8 level)
 	};
 }
 
+static int stage2_table_install(const struct kvm_pgtable_visit_ctx *ctx,
+				struct kvm_s2_mmu *mmu,
+				kvm_pte_t *table)
+{
+	kvm_pte_t new;
+
+	if (!stage2_try_break_pte(ctx, mmu))
+		return -EAGAIN;
+
+	/*
+	 * Note, the contents of the page table are guaranteed to be made
+	 * visible before the new PTE is assigned because stage2_make_pte()
+	 * writes the PTE using smp_store_release().
+	 */
+	new = kvm_init_table_pte(table, ctx->mm_ops);
+	stage2_make_pte(ctx, new);
+	return 0;
+}
+
 static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
 			       enum kvm_pgtable_walk_flags visit)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
 	struct kvm_mmu_memory_cache *mc = ctx->arg;
-	struct kvm_s2_mmu *mmu;
-	kvm_pte_t pte = ctx->old, new, *childp;
+	kvm_pte_t pte = ctx->old, *childp;
 	enum kvm_pgtable_prot prot;
+	struct kvm_s2_mmu *mmu;
 	s8 level = ctx->level;
 	bool force_pte;
 	int nr_pages;
 	u64 phys;
+	int ret;
 
 	/* No huge-pages exist at the last level */
 	if (level == KVM_PGTABLE_LAST_LEVEL)
@@ -1590,18 +1610,12 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	if (IS_ERR(childp))
 		return PTR_ERR(childp);
 
-	if (!stage2_try_break_pte(ctx, mmu)) {
+	ret = stage2_table_install(ctx, mmu, childp);
+	if (ret) {
 		kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
-		return -EAGAIN;
+		return ret;
 	}
 
-	/*
-	 * Note, the contents of the page table are guaranteed to be made
-	 * visible before the new PTE is assigned because stage2_make_pte()
-	 * writes the PTE using smp_store_release().
-	 */
-	new = kvm_init_table_pte(childp, mm_ops);
-	stage2_make_pte(ctx, new);
 	return 0;
 }
 
@@ -1620,6 +1634,56 @@ int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return ret;
 }
 
+struct stage2_table_install_data {
+	struct kvm_s2_mmu	*mmu;
+	kvm_pte_t		*table;
+	s8			level;
+};
+
+static int stage2_table_install_walker(const struct kvm_pgtable_visit_ctx *ctx,
+				       enum kvm_pgtable_walk_flags visit)
+{
+	struct stage2_table_install_data *data = ctx->arg;
+
+	if (ctx->level != data->level)
+		return -EINVAL;
+
+	/*
+	 * On success, return a positive value to prevent descending into the
+	 * new table.
+	 */
+	return stage2_table_install(ctx, data->mmu, data->table) ?: 1;
+}
+
+int kvm_pgtable_stage2_table_install(struct kvm_pgtable *pgt, kvm_pte_t *table,
+				     u64 addr, s8 level)
+{
+	struct stage2_table_install_data data = {
+		.mmu	= pgt->mmu,
+		.table	= table,
+		.level	= level,
+	};
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_table_install_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.arg	= &data,
+	};
+	int ret;
+
+	if (level < pgt->start_level || level >= KVM_PGTABLE_LAST_LEVEL)
+		return -EINVAL;
+
+	if (!IS_ALIGNED(addr, kvm_granule_size(level)))
+		return -EINVAL;
+
+	ret = kvm_pgtable_walk(pgt, addr, kvm_granule_size(level), &walker);
+	if (ret < 0)
+		return ret;
+
+	dsb(ishst);
+	return 0;
+}
+
 int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			      struct kvm_pgtable_mm_ops *mm_ops,
 			      enum kvm_pgtable_stage2_flags flags,
-- 
2.56.1.708.g77570a6a1d-goog

