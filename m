Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937460;
	b=gvGmYqkaJgRXd17/TxDKRqwEARp/AALbjr5Mwu8UtE8iflYamigh5q83Udq8qTrghHuW
	 KsoYF3K4tf9wYknaoBapy6jQ8lBSsNeIwTUIfynI7PuyvibQ7XST5AuMEWp5sA/qGP3uW
	 0aHbsifPUX4FnHEcd/STH09BZ9IOIvWj5s1FU9421eKEH2JTBce9GEhFSb6gtxQzfgxVZ
	 MEp7WZ/RxVr3Y+pMXcmc7dflbz9x6LGB5UWt/Gve4cjOxlkyDSah6ot3r0quMn0yUaGQO
	 GGlesMhqlGw7MoaED2lZDbUc5aK1I61qLSQgYhEvPmHWkMUonOW05fJSWhA5uMeSVBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937460;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=IzLYVFDyopJUGl8kdEACRtkithMX+J6kXd06oGG1awU=;
	b=5CS78vIHyQnCVvE9yuFIBINJre8cX2O6wRQOVwlUz8ZUYt/XH714+YOR3hkVqlXbcBki
	 sgrE2hnW76BBXckMyqZCc4mwW+F9hA5GyocOlHXwxQZZxyAUwYLCdI8aGsGO4lC/eH6wK
	 +EOwhRRmtLixLe4lVki6B7a3Q7Fk94wyb1upQNXmoAjUimkwbP/c/JINUlXgPaYbN4oga
	 KucV63ho14O4tOCpaTkIQc3YeGCxuczDuykLIS4YjTcXPOcPYrr3HDSn5qbf2eWUiat8j
	 kilEVCgHVqwDnxbbqTY4/Eo9NVhSMyYHvGIRxACs2Q1apxDLHXWPHA5PgGGMzBnzKAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Dh1fQve0;
	arc=none smtp.remote-ip=209.85.221.71
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E316606A32A
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:44:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E316606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Dh1fQve0
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4925ef75fc4so17317f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937458; x=1795542258; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IzLYVFDyopJUGl8kdEACRtkithMX+J6kXd06oGG1awU=;
        b=Dh1fQve0K9if43gpnd9+1pWKqmjvdspX65d/fqB3/eXLbzTXTDhJMo1NWaLikmKt23
         igp6M4wn20FipsfIAlroR1zIpJE2mxh9Zyk37mhmbkPjLjAd6r8eDDobehUGOqbTMS/8
         k4zX4wseJ5bmiRRxYDLLkewE3MBOz3mLAcqeT2y6mcUzbAckg1HW79EZHydP6D+aAN2S
         gEw9W8Tf25CbrVC2QBaPhK8qRi+VDbuNYqHgSbK15peu3ZovDL6pM0lg2mN2SIPm5Xg9
         ECLjAQx2cqwntLxZcTGAuXT27F+56wzJLYExbbVul8CmTx1M3duI8Lau1Ow/KrQcMmjl
         HObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937458; x=1795542258;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IzLYVFDyopJUGl8kdEACRtkithMX+J6kXd06oGG1awU=;
        b=mJwmESGTQPYb4TctP0x5+ETpctUKsmHwMmXMPgPcDBjPiAbNswLc6iKNLONLyKK5BF
         NT4h1D5cWC5XEm/VE1lT7UPLNOeUHvzSz/UKvluqNPVuXD3xBFvvHXTR8I4HEK7tFXuh
         5LSHLGJtT0SPjy6kwB54vxm4fmv1bZj7q/QEHvyetj4CS7xvX2EgpX3HS96y6dO6dTu2
         QrJURLMWjxk5aVPPwaLlAKuvnAQz/LGXlJ3ivLriPTybZSl+XY4kq91fTPgKIfcQRqAN
         UF9fmpZSafgcRriBLRJWBRIa7Ah6g8ZlFw2VumbrAJUauGzKtcU7GTVRuilTTiV8thyY
         T0lg==
X-Forwarded-Encrypted: i=1; AL+hErG31ib9pV6txHa6+xQIxo++R/yFacfSA8ofMZJS5X+j15zS2ZqFKJGmRN1KcFI8V4Zoy+RPri8=@lists.linux.dev
X-Gm-Message-State: APuU4Z+NoawWIe6kvdxOt9a6c06LLiY06h3Ieo4UVe1o4v9QTjMYshTG
	Yh+pjjyOx7l3uAdtILmT8vjSixcZa3DQeI7TSlQUonsFaK8qDRyUivzdX+kDnfakkxAVvxYGh2+
	3bna8xOUihjot2zEQadMaQA==
X-Received: from wruk18.prod.google.com ([2002:a5d:6292:0:b0:48d:f8b9:6520])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1619:b0:48c:72fc:363e with SMTP id ffacd0b85a97d-4a63eac5b33mr251344f8f.44.1794937457640;
 Tue, 17 Nov 2026 09:44:17 -0800 (PST)
Date: Tue, 17 Nov 2026 17:43:40 +0000
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
Message-ID: <20261117174403.58762-2-vdonnefort@google.com>
Subject: [PATCH v4 01/23] KVM: arm64: Prefault host stage-2 entries on block split
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Keir Fraser <keirf@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Keir Fraser <keirf@google.com>

For the host stage-2 that is idmap, we can avoid lazy-mapping on block
splitting by propagating existing valid mappings to neighbouring entries
of the new table.

Signed-off-by: Keir Fraser <keirf@google.com>
Co-developed-by: Quentin Perret <qperret@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 45 ++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9c83837b184d..dfbcdd3d91a4 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1032,10 +1032,52 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
 	return 0;
 }
 
+static void stage2_map_prefault_idmap(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t *ptep)
+{
+	kvm_pte_t block_pte = ctx->old;
+	bool counted;
+	u64 pa;
+	int i;
+
+	if (!kvm_pte_valid(block_pte))
+		return;
+
+	counted = stage2_pte_is_counted(block_pte);
+
+	/*
+	 * Shared walks not supported: cannot rollback refcounts on break
+	 * failure.
+	 */
+	if (counted && WARN_ON_ONCE(kvm_pgtable_walk_shared(ctx)))
+		return;
+
+	pa = ALIGN_DOWN(ctx->addr, kvm_granule_size(ctx->level));
+	for (i = 0; i < PTRS_PER_PTE; ++i, ++ptep, pa += kvm_granule_size(ctx->level + 1)) {
+		kvm_pte_t pte = kvm_init_valid_leaf_pte(pa, block_pte, ctx->level + 1);
+
+		/*
+		 * Skip ptes in the range being modified by the caller if we're
+		 * installing last level entries. Otherwise, we need to
+		 * temporarily put in a valid mapping to make sure the
+		 * prefaulting logic is triggered on the next
+		 * stage2_map_walk_leaf(). This adds an unnecessary TLBI as
+		 * we'll presumably re-break the freshly installed block, but
+		 * that should happen very infrequently.
+		 */
+		if ((ctx->level < (KVM_PGTABLE_LAST_LEVEL - 1)) ||
+		    (pa < ctx->addr) || (pa >= ctx->end)) {
+			*ptep = pte;
+			if (counted)
+				ctx->mm_ops->get_page(ptep);
+		}
+	}
+}
+
 static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 				struct stage2_map_data *data)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
+	struct kvm_pgtable *pgt = data->mmu->pgt;
 	kvm_pte_t *childp, new;
 	int ret;
 
@@ -1053,6 +1095,9 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!childp)
 		return -ENOMEM;
 
+	if (pgt->flags & KVM_PGTABLE_S2_IDMAP)
+		stage2_map_prefault_idmap(ctx, childp);
+
 	if (!stage2_try_break_pte(ctx, data->mmu)) {
 		mm_ops->put_page(childp);
 		return -EAGAIN;
-- 
2.56.1.708.g77570a6a1d-goog

