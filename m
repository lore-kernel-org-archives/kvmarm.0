Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com [209.85.167.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D43A367F5E
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785751859; cv=none; b=Ds9WbpGCL/PfE5EN5Mnvi8nA75xi1CwfjOmgeYuJldYf5wAwH7xqdpc8xpRQaGhiXB/wK/msopFiwrNZ4t1bKtTAMMHB8/i5lCfj8OMc9W4KqNp5XlsNnsTMNXheKsaH/LaCiH7oSnwpSEfcCgeyZfOFgRCiQdXBdv/k51I3vR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785751859; c=relaxed/simple;
	bh=eoEoT0ldlbmIKCnXlnnoXWUWnnQKL0Ssqw7o/2BmgLY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TQeqE1e1Qb/cFo2r57Klsi2jkoGTN5mYXPeTBbg3XQmkNqk7eP9UoNbZpZFvQmB63HKOWPGF488quBEcBREf96FhgC6d/DJapfVck1eNzuHknExHc7y0xysQIcHfWrkjl0YQhKHL5jY7VoJJ+AKpHzjDXRtHZImtxNK2fgHIWbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=semnurW7; arc=none smtp.client-ip=209.85.167.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="semnurW7"
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5b2d766b255so2549171e87.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 03:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785751855; x=1786356655; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HiJzzJADjveCPh12e/Ztx0Pt2Ia4qulsBujpLhp70Zo=;
        b=semnurW7aLbF/Da/YCHENVMhyxT8qeE3f9aFHMQ7uU3KTdRov8HJjyfoYI0BGjbSuA
         DgklBtxIgE335BzZxuJWU4KpsbqR/hOgqsY3p2XiN6xuTGdxrVusbqojIzkQBfCX6mGL
         xWb+kQme1KTTU/F31KU0NSEIghba9/xBcrY42LBdAo4reOOk2qEZ9keQC63cNBVgEReS
         cBzm5wQoYpvPAnzDf98ozkhwWSduMz/+UHzK5XkZZA034uATnJGm8fuCehKdZR+PBdgo
         45Tb0TMbO7pR9d4GyFPaMunZjkPJhWq94PU4aag8f/nOoct9ykL7g3eCrGhLK0F8WI4n
         y34g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785751855; x=1786356655;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HiJzzJADjveCPh12e/Ztx0Pt2Ia4qulsBujpLhp70Zo=;
        b=J4Vqmd4QEO7E0Vjrdy5xvy2kexcKWXeEkif6x2YUubMXo80hQmTFZJm/utfqttEfID
         GCN/d1ORk5XnEbz0p+73L1zLzLf4KTk8Z5uOSiquHf0YOZ3023MhOdS0QIzY6f2xDgZU
         E+7Z4X4T2qXdzxyYTp5+1svbTpjV6lKFhnSxGQrLtDD4FNpW/GAYU9xj7nttrAOs8e1I
         ZCtgQDmRE75Vy1taFLsoo9TfF8yzNfEC0rtYJSFudubAjTn9nzhhdhfKOLb+Igtu+3uy
         1ewCgZ83gw266kuM1jpXF0K4Fk8PpxU/rL+TQRl0DY3qtEcgzCrwKV7CaXobAVOPb/Mx
         /dEA==
X-Forwarded-Encrypted: i=1; AHgh+RqGWARv6RoRLpHqTaFtCq2GHR8+0/7ptOg8q9zHA8HWV9G6Qi3tvoCqjeCkEXvrJJKBk90ORQA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNHYamIFRIqNwOaLkaQQXh3DVMW8IqEepISgIvSJA0EverARqw
	/yCrRU2ty4c1soGEIQNidtTbtxjXRVp+D9AbYHvk6O8jNNVBbcuU2DjMGs+AC1Fno5ICsnyKtHd
	tN4Yvpjde9ArAUxa5SbbbOA==
X-Received: from lfbbp27.prod.google.com ([2002:a05:6512:159b:b0:5b1:5972:ebc4])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6512:1083:b0:5ae:a4a4:b6ca with SMTP id 2adb3069b0e04-5b2e4f16ddamr1441640e87.14.1785751854334;
 Mon, 03 Aug 2026 03:10:54 -0700 (PDT)
Date: Mon,  3 Aug 2026 11:08:46 +0100
In-Reply-To: <20260803100904.3563942-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260803100904.3563942-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803100904.3563942-3-vdonnefort@google.com>
Subject: [PATCH 02/20] KVM: arm64: Propagate host stage-2 annotated entries on
 block split
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	keirf@google.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Propagate ownership refcounts for invalid stage-2 entries mapped on
block split. This intends to allow splitting host stage-2 blocks while
keeping existing page ownership and metadata annotations.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 34f78a58cded..0ca157ecee64 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1033,15 +1033,28 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
 static void stage2_map_prefault_idmap(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t *ptep)
 {
 	kvm_pte_t block_pte = ctx->old;
+	bool counted, valid;
 	u64 pa;
 	int i;
 
-	if (!kvm_pte_valid(block_pte))
+	counted = stage2_pte_is_counted(block_pte);
+	valid = kvm_pte_valid(block_pte);
+
+	if (!valid && !counted)
+		return;
+
+	/*
+	 * Shared walks not supported: cannot rollback refcounts on break
+	 * failure.
+	 */
+	if (counted && WARN_ON_ONCE(kvm_pgtable_walk_shared(ctx)))
 		return;
 
 	pa = ALIGN_DOWN(ctx->addr, kvm_granule_size(ctx->level));
 	for (i = 0; i < PTRS_PER_PTE; ++i, ++ptep, pa += kvm_granule_size(ctx->level + 1)) {
-		kvm_pte_t pte = kvm_init_valid_leaf_pte(pa, block_pte, ctx->level + 1);
+		kvm_pte_t pte = valid ?
+			kvm_init_valid_leaf_pte(pa, block_pte, ctx->level + 1) :
+			block_pte;
 
 		/*
 		 * Skip ptes in the range being modified by the caller if we're
@@ -1053,8 +1066,11 @@ static void stage2_map_prefault_idmap(const struct kvm_pgtable_visit_ctx *ctx, k
 		 * that should happen very infrequently.
 		 */
 		if ((ctx->level < (KVM_PGTABLE_LAST_LEVEL - 1)) ||
-		    (pa < ctx->addr) || (pa >= ctx->end))
+		    (pa < ctx->addr) || (pa >= ctx->end)) {
 			*ptep = pte;
+			if (counted)
+				ctx->mm_ops->get_page(ptep);
+		}
 	}
 }
 
-- 
2.55.0.508.g3f0d502094-goog

