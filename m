Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AB413D886
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134666; cv=none; b=AdThe5FCc6wERsazi4mcrTKpO+WovyTOUMdyHtH9RMNuOS+37u87b3hYVB/WvXBpCJ6mrkCmvtdlC7tkthA99QKVk+rELhGmCVzqhPozmDptQXvo9V8x12BfVL/WEmsOZG1pvHz9LM8xPJnWWud5cz5vLyEEa8t0iyjMaAtgE4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134666; c=relaxed/simple;
	bh=d+q+AS+3iOBQ/OxRiCMXKPX9N2qg+/mCaSx2bwznTyU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AHGrI72zWfYGyIF9ovNievvvuI7sJ4XJH6xcJ4eFo8HnRk7W1vxqHSb0h8CC61TttkP8IXcJt7HEnA752B/RgtwhMwZSec6EdIlzSwSdo++tWo/spnl5nVnrb/9Uw1JH6i4b46rjNKwTQ1y+XcFRhuVPegulR8IOTYwq2WUw9dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X7sO2N6y; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X7sO2N6y"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49cd55ee2f7so8892935e9.0
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134663; x=1789739463; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oUDp2ADO9uV45okQui7zd34Tg8bbsC1Ja6jK0tQWU04=;
        b=X7sO2N6yP0Rz8sFozCbXtyu/iKAfHDLs2tQeQuK5fTCcMYxh1w3dpoIXQNduiTLwU/
         e/SLHcZ1Y39HjO7cR4hXmRd8GNUUGGWyJ6eGUDsbIGNrdIGzqAPk0deCCbxwJQJoXGOX
         SO7q291Xo7QPiSpXWZ7a3lpUVBsMklne572iIApKRnYHuKINOFJRk/enC48Drge9T9d6
         9l+VrHMlPd7GC7iC0Covt/ZLbWZAf5XUQGMnxq6vt5y8PVCbbQurHUwHWyw6dvs1Y4JB
         pdZd7xVCnyGIz9MI8Rm8KB5ry6TZOuA9bKFgOZ9gxddJlpeuEb6F5FFqbVg6Q3Qu7aEB
         1afQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134663; x=1789739463;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oUDp2ADO9uV45okQui7zd34Tg8bbsC1Ja6jK0tQWU04=;
        b=gR0+IxNkSJ37gdX48Gjrre5/2BUuOKl5kUZCtx5mz9tlJnA/z7Pk/gPlXWbWFfKtGM
         Jv/TWTlTqIeaUqeL9FCxfZfZ0NSPosRyIkO1QLiayBYEdypJsbVYW3ZFN3zvQdg6bZYK
         GAFhcHEemaSX0h2PXCzEd5CoKxdchcayo5vISCyLN3RxAIMyNQ293jJxbC6dtpbifo4m
         3HcGM9WPZcUjjk86uYYuxYMTF5sdq23KgS7leBf5mGbVLUnLMfYwi/zfAvxjfS2F4WsF
         I2AiNFkgbYFiPnCRUrLJZ66WDXz8Yxur8plf7LlWMGx2aOdP2/CgGMCw3J1xDq32haLD
         v5wA==
X-Forwarded-Encrypted: i=1; AKwUvBxA1UR6vwTzg7qezBV+u0Xxw+base4VYOBiPUy9Rq0DTIe2O9NnRyGG0xf1VkOstri4OW9V5HM=@lists.linux.dev
X-Gm-Message-State: AFuF++m2aKe+3LlXbXppOhIpSvTlCNZ1hqf4kNgkoOyPVcn8WfQUoLiU
	qF8jI/HcHbymUZXKychAbSQbg3+jSnMFLywC/GzPvsNBT46cVHAXcIO0CJ+ufiEIE3BOVJwM/nD
	Dk9iRVTHl0wKTyxC65Uf8dQ==
X-Received: from wmfq21.prod.google.com ([2002:a05:600c:2e55:b0:493:b636:4ee9])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c16b:b0:49e:69ff:c6b1 with SMTP id 5b1f17b1804b1-49e69ffc730mr5158065e9.31.1789134662716;
 Fri, 11 Sep 2026 06:51:02 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:50:32 +0100
In-Reply-To: <20260911135053.146435-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260911135053.146435-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911135053.146435-2-vdonnefort@google.com>
Subject: [PATCH v2 01/22] KVM: arm64: Prefault host stage-2 entries on block split
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
 arch/arm64/kvm/hyp/pgtable.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b74dd5ce1efd..34f78a58cded 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1030,10 +1030,39 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
 	return 0;
 }
 
+static void stage2_map_prefault_idmap(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t *ptep)
+{
+	kvm_pte_t block_pte = ctx->old;
+	u64 pa;
+	int i;
+
+	if (!kvm_pte_valid(block_pte))
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
+		    (pa < ctx->addr) || (pa >= ctx->end))
+			*ptep = pte;
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
 
@@ -1051,6 +1080,9 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!childp)
 		return -ENOMEM;
 
+	if (pgt->flags & KVM_PGTABLE_S2_IDMAP)
+		stage2_map_prefault_idmap(ctx, childp);
+
 	if (!stage2_try_break_pte(ctx, data->mmu)) {
 		mm_ops->put_page(childp);
 		return -EAGAIN;
-- 
2.55.0.1007.g17ff1f9808-goog

