Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B594375ADE
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785751859; cv=none; b=lihKQRgghhtXjfnYdecyHHXKf0wFlrBUx+fnJ6Vmxiy1hZeGb8iFDOXXk8toe8tM0TljVCZire2ujctVshJWiSh6AgcKl+Is7gdp98DFSagV/1W/DfhcEuiBR8/+YXg8G446iRmoJnABQOhkfxnhWLDTcgWBi6OK/s/P91m3Ji8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785751859; c=relaxed/simple;
	bh=jpIcPYkUR4a27SEvDfBTRSo8OPQFar/q460GbtL21hw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eEC8fQGlYwPbFtZfAI4p/4XQ84LMwtZWxSQ2NjJPCG4BOQwPI7Sllg4PqE4T1UsQnKw8waoHIhUcL6nue//15UQKy+hS5hDvTxXUZkwS8g8K6sHNjkIBZYosHwDlp9TWW/UHtoTs2gUaNGLuFSYtH0xxYHN17PndmRw3/UbpVdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=keFQXUVN; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="keFQXUVN"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4954dcd6131so21909735e9.3
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 03:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785751856; x=1786356656; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+iEAKLbto2A4V8SjNltJfT6Zw37CtGlO8SJPT3maqDw=;
        b=keFQXUVNqcKYmPXB8MNjPyXLrJ6igl48oMEsqykD5FpyiLJRjLTYGzFhJXNR+nNSKw
         bjqQtBDpATK2R3gjg/WCEusrKIvQaepJUQgd8KvpKBGQEvwZmq5UMBZPiFrRQlN2X8BX
         ZoPjHsSPQVI2TeV31UyH6v59VYD0HRhuMOK2L9F7Gy37ZBLi9xwW98l0DODoy/xIxUkX
         9tf+R/dRy97nnGGIkazJi3bpfJsRrvap0TEaq5Krnjr8wrG1MUGsUXkyE5MtivyfOR2v
         +wIWmD00q6BZRtzSRVD2WdVDJtsSoDck+XGjxa74LJzUz9OVvO3eQPSjxv4TZolm84km
         YwMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785751856; x=1786356656;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+iEAKLbto2A4V8SjNltJfT6Zw37CtGlO8SJPT3maqDw=;
        b=CItbTLPBEhm5FPmsmrCMByHwKejX3JZsqkgH08EIslTCSQnZ/kBrzTpSOYNq0MeTcD
         994Bk4K8UxDHh18ttqn7RT7CUhLsjZ0ZgjUu+Z084V33Rr/zNKni3O9bm7nJoTUW6Evy
         cmx39wy81aWu5rTDerljxzIVknCggP3N90rrAI/m90lbHnYQL47eb9/Cd8CY2aZM7yR+
         C4l6eeB2mFXdfaNRsfTJC6qMbXdSe4yNKDd//2vHS1wkwtvsyo6H2cD0WVQDjjLVI3pJ
         G31tCPbwElJ18tjTN+H/NCj1qK+GF/qH1HJCd4OogFG7G/jKrknmnfJTuo69Royp5/cI
         iTzQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrz6g2n5C27Jo4Vjh58Xnx5S32KPe5gTwqeLZOEpnRVa58AuQPDa2s1BjYalUiv4gUUCxzY378=@lists.linux.dev
X-Gm-Message-State: AOJu0YymDbzUy4cp77K+vfBpPge03jvSgFnX5hgzisOwYf8KEoE+0Zkj
	1A0zDVsTpsoEr2DyC13drPjJAcq7xTaSHNwSrUzdR0dcfwOuQuvZ4ApJGXxVPZkmoolhRJ7PN0a
	2DadNSqy3I//GlVWU9eJxyg==
X-Received: from wmga12.prod.google.com ([2002:a05:600c:2d4c:b0:493:bba5:775a])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f92:b0:495:7293:4fe2 with SMTP id 5b1f17b1804b1-4980c67af48mr151317035e9.17.1785751856061;
 Mon, 03 Aug 2026 03:10:56 -0700 (PDT)
Date: Mon,  3 Aug 2026 11:08:47 +0100
In-Reply-To: <20260803100904.3563942-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260803100904.3563942-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803100904.3563942-4-vdonnefort@google.com>
Subject: [PATCH 03/20] KVM: arm64: Allow block-level stage-2 annotation
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	keirf@google.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

On host to guest donation, pKVM annotates the host stage-2 invalid
entries with the GFN. Now that the host stage-2 preserves annotations on
block split, we can allow these annotations at block-level. This enables
safe support for guest stage-2 huge mappings.

Allowing block-level annotations also reduces stage-2 fragmentation when
unmapping a huge region, and reduces host stage-2 memory usage by
avoiding the allocation of intermediate page tables.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0ca157ecee64..c4ebae0544d4 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -947,9 +947,6 @@ static bool stage2_leaf_mapping_allowed(const struct kvm_pgtable_visit_ctx *ctx,
 	if (data->force_pte && ctx->level < KVM_PGTABLE_LAST_LEVEL)
 		return false;
 
-	if (data->annotation)
-		return true;
-
 	return kvm_block_mapping_supported(ctx, phys);
 }
 
@@ -1178,7 +1175,6 @@ int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	struct stage2_map_data map_data = {
 		.mmu		= pgt->mmu,
 		.memcache	= mc,
-		.force_pte	= true,
 		.annotation	= true,
 		.pte_annot	= pte_annot |
 				  FIELD_PREP(KVM_INVALID_PTE_TYPE_MASK, type),
-- 
2.55.0.508.g3f0d502094-goog

