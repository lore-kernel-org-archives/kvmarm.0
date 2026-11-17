Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937461;
	b=QSZpuwpAZDxBubwtpZHYfbcybi0WsUyElp4QrXqe3D2+G9gSOOUms6vCJFf4muvuoOe+
	 6v1LJtf7lcEBYUF51fSLAHsyJ5auQFQOTgy3S25781oMEt39GuzaK0Fb44S5s873Z/Dwy
	 PArVfa2JZeVyutwAWhdF5HLe0yiNBJSoxFGfjivlqV0McZLnCXMDeeFLLvxVFomDNCBL7
	 qvWSdLDu+MPTwrH1D/PalDCTHutqgIy6Wblm+uKkjwnVAUdCKCO8qdougj6ZDX7GIytjl
	 Mf+cZWP8wp/51ZiCgG7rho5HeyGFmDPfYMQCz3awuf10R0qynwBZA2UjuY82sJYg41g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937461;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=rm5FnpdbPcxusVeuCcX3zKz7f38fZpOGuIKrvxpxFrk=;
	b=RhHTiCAwk/JcKlapbeqiYa/Cjb7IZQt9i4m1m3XfgaSc8d4d+1kKG2U3XI556t6Nx3I/
	 0rokE+LLOuz8bRkXArAiMfSvfB4eUydpc6mFYy7yDauDZTBvTXMTKpkZy/VgTT4rkz2yd
	 kMJahjewlRkv40KKpUbtxA6UoRlnfh9ITyZKLAk9ZGNDlrBwIZYF3FrtQ60E1VfkpGHYe
	 S6HhHTpekpMkbr4GeX3pKXKmbEUXEqFgLMMSgXINYtsFurl7sgvUAznJl+b1ULFDuKto3
	 4I97ot/q38E2UpCsGZNF+zkoiYaugVqY6e96De8Mqp5Ya9G4MP9zOns/cVbFNzL5nEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WVioNf70;
	arc=none smtp.remote-ip=209.85.208.69
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A69606A32C
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:44:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3A69606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WVioNf70
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b87d964b3fso104881a12.2
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937459; x=1795542259; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rm5FnpdbPcxusVeuCcX3zKz7f38fZpOGuIKrvxpxFrk=;
        b=WVioNf701bqsnDS/k+vGyVTbSuD71n+4NFIqMRFQYHEHUI1rNFQzxd6oM6XMtraYQ+
         al2jA1HEmjd46L6f7X/YEzGb4kw/WV6jwtUS+pZRerHtwkiYW7JLB2JQyv/EHEllBerp
         coWppLloDZdmiyTsVnQKKg4UH2TUBVr2KBvu7jjScFDH61rdDA8W5PdbfgWPs90Lk/4A
         bkzBl+hQYgumrS4kJz/nzz8BLxksKonZ0Vjr/ZuJp8RoUFGMxzEk6zua8wlLvkHQTWbF
         ORjNdBSsZYPIhQRkbKWQuy67KOf5MVhjBn/Y/VteTRETqr2lz1ABByNcJGMFtb2Ok/C5
         8LRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937459; x=1795542259;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rm5FnpdbPcxusVeuCcX3zKz7f38fZpOGuIKrvxpxFrk=;
        b=eLwpeUqN1K2vkRZRjKdXZLfVk+dVB/4jaacJKv8uyV+a6ivIBWGbr3woFGdm0PqcfS
         b3o/Mo3iA3wKIpo+7bIBnbdVKsuNlaNuZLXPjrtXK9xsi3gsfaaNgXY1BTCaasfcwCKw
         nDu1MlcojF7Tn27zIEY6ueKZwnWhJZBQrpHe93hrNfZJs7yobf7fWAk9EuE1G71D3gNC
         gQGe8dlivoCJzPszUYwSwI9clNtOzgy0qv/A7OzwNclQz4CzwKdyOhzP4G+1/khLUrC0
         cU+pQsf5lRgguBgY8LhInXpCXLjma7jXMNWR5sOyj5qoVY1p8FnhNWTbOGWKJcqpcFE3
         aRDw==
X-Forwarded-Encrypted: i=1; AL+hErF3XUbTbUa0NeIAun6/2oLkwrO4XPeoDBn+6WIBgwNBAIgGYIDlWMSsfUPtyboKe6pLaT3svtM=@lists.linux.dev
X-Gm-Message-State: APuU4Z+5I4B3mCitGAxdIXg35sjkqKyQFd7J5+dNxQ0oOShIrpg5sYym
	77wXFEkFDz9OqF7NYk7y7FPff3y5B9a3w9C1SsS7vdtaQZxKnaSG98WERzk09gWZ1XNLjcwtGqS
	eYaPlGKMnkZ3ekJOuPZahfg==
X-Received: from edad29.prod.google.com ([2002:a05:6402:401d:b0:6b5:5e16:5062])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2113:b0:6b7:221c:beb with SMTP id 4fb4d7f45d1cf-6b8877e3a49mr59953a12.0.1794937458926;
 Tue, 17 Nov 2026 09:44:18 -0800 (PST)
Date: Tue, 17 Nov 2026 17:43:41 +0000
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
Message-ID: <20261117174403.58762-3-vdonnefort@google.com>
Subject: [PATCH v4 02/23] KVM: arm64: Propagate host stage-2 annotated entries
 on block split
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Propagate ownership refcounts for invalid stage-2 entries mapped on
block split. This intends to allow splitting host stage-2 blocks while
keeping existing page ownership and metadata annotations.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index dfbcdd3d91a4..bf5c8e75dd52 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1035,14 +1035,15 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
 static void stage2_map_prefault_idmap(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t *ptep)
 {
 	kvm_pte_t block_pte = ctx->old;
-	bool counted;
+	bool counted, valid;
 	u64 pa;
 	int i;
 
-	if (!kvm_pte_valid(block_pte))
-		return;
-
 	counted = stage2_pte_is_counted(block_pte);
+	valid = kvm_pte_valid(block_pte);
+
+	if (!valid && !counted)
+		return;
 
 	/*
 	 * Shared walks not supported: cannot rollback refcounts on break
@@ -1053,7 +1054,9 @@ static void stage2_map_prefault_idmap(const struct kvm_pgtable_visit_ctx *ctx, k
 
 	pa = ALIGN_DOWN(ctx->addr, kvm_granule_size(ctx->level));
 	for (i = 0; i < PTRS_PER_PTE; ++i, ++ptep, pa += kvm_granule_size(ctx->level + 1)) {
-		kvm_pte_t pte = kvm_init_valid_leaf_pte(pa, block_pte, ctx->level + 1);
+		kvm_pte_t pte = valid ?
+			kvm_init_valid_leaf_pte(pa, block_pte, ctx->level + 1) :
+			block_pte;
 
 		/*
 		 * Skip ptes in the range being modified by the caller if we're
-- 
2.56.1.708.g77570a6a1d-goog

