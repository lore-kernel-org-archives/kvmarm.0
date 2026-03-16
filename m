Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C787C1A9FAF
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773682533; cv=none; b=SRyUI4MX5LiTHZaDYisFQy3mA3vI2ag/yqQGNwZrVDpG/M11icr8xVZz6gCAKqBoX7csxrErJhQTR/AbeuaDLgPXIRoADA6ZRO9jtVfxmIsY6EMmwI7pxZzchJQGuNj4H/bH1pCadMua3DyW2/Dh+gRHdK/IeZpKljmvkf2gUTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773682533; c=relaxed/simple;
	bh=mascMBHyMxL7+rhIsZVuyrQ1poIA8jNmRxptuWKdwlo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C+V3FX1uum1xsLRrjb2/orTW/J0OKBq+JUuRQTqJkAXfwIZYpb1qNZ1ViZIOL/05eKEHwMnETWIElUNkRv7p/pTJjbzxI3vwawzOT2FkkXIhbFmH8WDVojzIvXdtawILlqJVj86V50K65K8xq5UfQusTRYQEptVpC3SV+1tp+Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hqDi9QJf; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hqDi9QJf"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-439f5c57c52so3429459f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 10:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773682530; x=1774287330; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V0ORKdqRW0mEfmd4VRP/igA0BU9vYKKtq0fYCFbuf90=;
        b=hqDi9QJfPbl/hs3q2Joos5Raeg9Y/yP8wJJjEfgIc1Q037Rpr0R6zJQUB1x6fUsP6j
         QnWZAJwzEb2/JQYM78vS5+/Ve9nQWYBFP3x/h+LUR6sFro5KQOWJDUl98E+XdK4UdR6+
         kbJzoLkszT0yN9XyGz1LaNCgXhOPAt2k4nQJ8gN/okuW2PSpbuhGW/5y7tJS40QnzDai
         88rGGMe0RQE6cyTPt2Aog1B9ME3n8sdcWjgXJA96L/HEVMef94zJsSmGEtqi7cw4RWv0
         3jCA2Vb+wNKYtWzG5Rw6AVOxqtFzqy685PLmdWj6GYlxEPFzUt5yO346xrNvFqdhF6aF
         VIqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773682530; x=1774287330;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V0ORKdqRW0mEfmd4VRP/igA0BU9vYKKtq0fYCFbuf90=;
        b=bCPXZHZUIKKDJH0lta/bsTuu+3KDMoIvkJkaVRJgupFFKzyAbjcGTjOEjGCucn2Bus
         wWrxXlqbKcuqNVnAtHKJV8H1/zw7k2KKjHyu8dZIFnC7nx4rgSFzITykoltW/TtJfjva
         TvqvhfGRBEtvKyIsPEur4dS0F2cevPOdxVrm2NQ+GtxP4rwz7/nhK+fModwbKxCXYwwB
         Cj+8AVpOBUlMb8sE4rgfPF1lM5PqcNp0MCpdcO5+jz3Dsyv83vGlzEbzSyTqUhVDRmNk
         NQC/6swHFLtoO3fRpVrp6+QpyZWEsJpUu0Y1pdGRMySrah8yMe23u4cCKtQsUAPyd31N
         My8g==
X-Forwarded-Encrypted: i=1; AJvYcCWgV+e1TrF2K14sfazvmyeB1KAmHNmUj7LzaU1THntDUHSF1Z2SkzJmLKkXizW0nrBWcZ12a20=@lists.linux.dev
X-Gm-Message-State: AOJu0YzmKDSEKTlMJQ0zrOA95PPsr/aiflG/QV2IpfY5WmG1eJddqSDB
	LtbIdZnnlWUZmrjByFTADplM4Qzz9o2XInuAB6tKnLo/u0AACDFUTB7tVMhc/4EcwXWpJVYlT/k
	rHA==
X-Received: from wmtf12.prod.google.com ([2002:a05:600c:8b4c:b0:483:6fe1:c054])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:46d2:b0:485:3a03:ced1
 with SMTP id 5b1f17b1804b1-4855672737fmr240611635e9.28.1773682530109; Mon, 16
 Mar 2026 10:35:30 -0700 (PDT)
Date: Mon, 16 Mar 2026 17:35:23 +0000
In-Reply-To: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260316-tabba-el2_guard-v1-2-456875a2c6db@google.com>
Subject: [PATCH 02/10] KVM: arm64: Use guard(hyp_spinlock) in page_alloc.c
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <linux-arm-kernel@lists.infradead.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <kvmarm@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Cc: Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="utf-8"

Migrate the manual hyp_spin_lock() and hyp_spin_unlock() calls in
hyp_put_page, hyp_get_page, and hyp_alloc_pages to use the new
guard(hyp_spinlock) macro.

This eliminates the need for manual unlock calls on return paths.
Specifically, in hyp_alloc_pages, this simplifies the early return
error path by removing the manual unlock and resolving single-line
curly brace styling, reducing the potential for future lock-leak
regressions.

Change-Id: I37bb8236dbfff9b58bda0937a78d2057036599b4
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/page_alloc.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index a1eb27a1a747..f43d8ad507e9 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -167,18 +167,16 @@ void hyp_put_page(struct hyp_pool *pool, void *addr)
 {
 	struct hyp_page *p = hyp_virt_to_page(addr);
 
-	hyp_spin_lock(&pool->lock);
+	guard(hyp_spinlock)(&pool->lock);
 	__hyp_put_page(pool, p);
-	hyp_spin_unlock(&pool->lock);
 }
 
 void hyp_get_page(struct hyp_pool *pool, void *addr)
 {
 	struct hyp_page *p = hyp_virt_to_page(addr);
 
-	hyp_spin_lock(&pool->lock);
+	guard(hyp_spinlock)(&pool->lock);
 	hyp_page_ref_inc(p);
-	hyp_spin_unlock(&pool->lock);
 }
 
 void hyp_split_page(struct hyp_page *p)
@@ -200,22 +198,19 @@ void *hyp_alloc_pages(struct hyp_pool *pool, u8 order)
 	struct hyp_page *p;
 	u8 i = order;
 
-	hyp_spin_lock(&pool->lock);
+	guard(hyp_spinlock)(&pool->lock);
 
 	/* Look for a high-enough-order page */
 	while (i <= pool->max_order && list_empty(&pool->free_area[i]))
 		i++;
-	if (i > pool->max_order) {
-		hyp_spin_unlock(&pool->lock);
+	if (i > pool->max_order)
 		return NULL;
-	}
 
 	/* Extract it from the tree at the right order */
 	p = node_to_page(pool->free_area[i].next);
 	p = __hyp_extract_page(pool, p, order);
 
 	hyp_set_page_refcounted(p);
-	hyp_spin_unlock(&pool->lock);
 
 	return hyp_page_to_virt(p);
 }

-- 
2.53.0.851.ga537e3e6e9-goog

