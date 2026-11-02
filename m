Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652424;
	b=IgAybWVQaceCeBn/oaMHR+xJMIi4qb0FfaN1kt/C9mBP4y35VFtkBVtKjyTnIky9biQO
	 gwZgpgxpQfaq9Hk/kkDSMN+9jw4Dx6dR9voN5f3nMRgZZVkXdCsg3eAY+PiWSVcXo9mc5
	 go2qQlYUoncM4htI6NTgvHcRcWyDzDfQXROBojLJUiRo/A+vAMztEWSs+DlpS/NZXTGiG
	 QhbRn1AB6F/8Uws8X0TsbXL4jenxjKdHV5RumHjd6JF/M+DCJ6Ee0Yg65r091Ol+3ZpQS
	 K8MeyLRLM4CtxJbFCLD4+j00H31Ghq2YLZq32LhMo+X/20JIjhOfJnBjb0Fre5t67Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652424;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=N9/aAcI8tDrlGXTuOLbUQjQM2gmmk27o5OqCSTvv6zc=;
	b=XzpbJAdP3IlnonHoyUnEFiybTDp9YPe7R58a3cnLoD6qoEIVm2fT5T3xDwntacZmZDkb
	 /VYmGQKIQDUiYo+EHBezY2lnW7WEi21Z1IcpSblWQ9g0hlxPc+jiVrl92LIIvAvrHntBQ
	 msqmCdzT9oj/jNyaeHETGrJjQGeF39508a735ekDsn7cCqcXYxpmQclQf8TUgg5fosKhi
	 XGLgo2C/Aj0xKzHecn0eTRPfefZcZ4dQNvpDr2nPDO9h2BK19yPJ6Q6LcwetE7f7QHtyG
	 xfoDVugYtKYgxlqMup/Xiafc7PyiG8Cqta+Dap++xyrktJOd0A2wNi6ArKP6UB1Na5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=FzmbDXln;
	arc=none smtp.remote-ip=209.85.221.72
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ACA606A326
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:47:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07ACA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=FzmbDXln
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48e4d1e29f3so3082948f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 12:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793652422; x=1794257222; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N9/aAcI8tDrlGXTuOLbUQjQM2gmmk27o5OqCSTvv6zc=;
        b=FzmbDXlnPDn/Bj+vInHIzsaOoyupRv+OCfL1nqn261T5o7zMNSy46XEM19CcQDbaH9
         5X6GJODycztsEYAZNjJ1Qs4cbkXxh1EXHsSzPYW6QaluDacFIdl+ibyIlvY1ExVjjj0f
         99NV6J+ey0p+JsBhtLYD9LEl1Ra+oRPJBX9wptlqsoLi0ycDYM8LLtUDeoakcXskWTg4
         62JdzMIelG2/5/gv268W4imn0mbKfRr0SXTMWV99x92A84LGPXh4gI+h8HNGYGEnx2bd
         EWoekxILyGWkC+FQRH2wKzBLYTqU2HcMawOWCeRXWjIHW4m+CpHpQXSlwlvNO0DGoBdR
         lrbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652422; x=1794257222;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N9/aAcI8tDrlGXTuOLbUQjQM2gmmk27o5OqCSTvv6zc=;
        b=hs+BaVmcx/IqZQPJMKkXGlXAdXVTzVrABnGF9zpA1i4Loo1xHc5UhKZexwVhkTdNpf
         MWwYxFYYL9lB3W413lhFY0E26SbOlJ2VnC3S4AWcqXnjhnSTcmQipFzWbSavGQMtxjBp
         yRVyNO2pKMnikfgJln7M4u3afjAU7AY/gmLUQhNv3XmUwkpVpw2Qi3IP2VKLAPORbaND
         JFmOkb4hSTV+PunXO5FXriElpp6nqtufntvYtpl5mtA5LisYdKJSvu4NNbtsoQgecrwu
         NKaPK7wh2Qm+lZ2KYfTpw5GMsvPKJgUTantrLPKMLRFdSePg6mawPpO0XN7j8xqdEhG8
         wF3A==
X-Forwarded-Encrypted: i=1; AKwUvBwnwEbeRGONakNKlOYXVTP6r4pAeOLxLyRAfAehE8Bi/ezt5r++yFHIHDnlefY9A2bGnETydcg=@lists.linux.dev
X-Gm-Message-State: APuU4Z+jbS6oYAOwI8HVhjebfqYe94Qx/O71Lbi4RuJyBYxVBL+M9jw5
	4Lil6ZSoDLUda+e86UZh8IUQId4bW/+/+JOOeWhVHiuHROJdtOM/PWhWcC2InPZECvEAE4tKqZb
	qP3+wQiXTsGGVss4/6aHPnA==
X-Received: from wrna10.prod.google.com ([2002:adf:e5ca:0:b0:48d:f161:cdaf])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4810:b0:48e:f8d:8cab with SMTP id ffacd0b85a97d-48e6e2bcd79mr27169760f8f.4.1793652422051;
 Mon, 02 Nov 2026 12:47:02 -0800 (PST)
Date: Mon,  2 Nov 2026 20:46:06 +0000
In-Reply-To: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261102204628.401871-2-vdonnefort@google.com>
Subject: [PATCH v3 01/23] KVM: arm64: Prefault host stage-2 entries on block split
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, Keir Fraser <keirf@google.com>, 
	Quentin Perret <qperret@google.com>, Vincent Donnefort <vdonnefort@google.com>
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
2.56.0.385.gac671c819a-goog

