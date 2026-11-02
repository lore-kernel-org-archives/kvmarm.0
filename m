Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652425;
	b=nHYJHPWBjfTIPtEJUmKJrIF3JyJ3hGQA+rDJz/ytEEPrINDyBVF11VAuNXEwZNiVXYLX
	 WnHFj4mowCza3TNpwFrcpdsLReV4LovbLwFvVessslH9Teqqs6mMcKu7oqQ7WCAccc4vT
	 Ei6Cc6t0wiA23/dUSvlqqtA9/gfpBuO9MmbkdsdEA6IQDXR8/TqJwUcTG1RLcP7X392ja
	 ytEEEtSJhRB1nuNuK+lGGB4mL5eyt8B3THH7n/ZtC/bd1VV3V4zXRJ/OmlDJjxUHxskqm
	 bcNSmQko3CSRKRMdYNrJ4r8wVzYWl9aii13KvYMm6/VPVuElJ6iXa6D0694OwbtkJDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652425;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=DdPclGcz/C8ziGiUWCbTieOEXG2PqBiYeYgzWvSzdrs=;
	b=O23hZWArG3LR/2/CzikAsvQQrp7Uq1wOiRA28fcTTIUyYb8W0a27/BP4Unnbaj3Zuik0
	 PnlE/4O0g4i7OPFT53dEzOo59RrnQ1Khyms2KsL1Y76XBLsq5aJWSXbI/YmbrlJNurMIE
	 gJ1OvgNSpVUuTI0zN7UbB9vfw/EK+eCFutdxS8q/iRWYmfSaa6MX6XNHk5QpZCtuzfZtM
	 yolYVvRhaR7ldWr1r7d25eYj/Qn/UZbFunTJQhdGwyRHd2SdZyXtxrmVlCtY/0mhy1e4I
	 KUyjDe4WyecNyGWvcgsNvqZTL4ChNQmIL4IHEa+VETJh6hJiSBb2ip7+wNX11N3XQcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=GyxeC3DY;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CA6606A329
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:47:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39CA6606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=GyxeC3DY
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a1fa972b4fso17344995e9.2
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 12:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793652423; x=1794257223; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DdPclGcz/C8ziGiUWCbTieOEXG2PqBiYeYgzWvSzdrs=;
        b=GyxeC3DYtPgukq79mMz445Mr4pSYPGQbaZiZlZDL3IVXsa39FOYiUpVYZiAXIJP/8E
         7mtrJUUwWJvSOvZY1IAkXVwLw0lrtqgyu1ald/rxovneES/tsYJAY+1zg48n47XinWLu
         xDnDpxUY8fzFaBfVYwDOqjKvKcJWOs7KwoZoiDMYVwz47tRnJFCalkmVTQ5+aRxI8uD+
         AD9RMdmwTUxKivtRo4mCmv7iwYpt3QA3cLwFra2JcH2A20TvJkJUyMWPds/C7RxE41bz
         +fMWTzBSu6IX5YqXntMlAfaVMAKkjYXJMfxY8yoUYpSr93zkQ+2H2OqMi6ZsYdHa/XPg
         DD/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652423; x=1794257223;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DdPclGcz/C8ziGiUWCbTieOEXG2PqBiYeYgzWvSzdrs=;
        b=abEO0lJINTWyma9pp6U9VW4/0rQIBg0pKyWKX4LbHezMmRTjTsjepSg2BjOBNRaYzV
         MrjLhDQGTGMrMRw53MVC1F0odM69lW5qfIf/g4HnwYOeMgKaJcTBXLNt1JSfqPhjoU9H
         pFPzhMT+U7M02Lo6s3fKxvOApfd3nzDXxq+5f9Sm5Y5fTN1ohq6KWRfxu8OfG2e1vATh
         gOIRyKITPyUOBhzVvCKAaE23yYruPLmLdsONsjVvhaAK3iYibw0ZvuRLclk8ihTpkcSQ
         B6VlLT7SW98vuBbuTnzzYkCHSVmQJ1St8epv6s83qKufjtnlqvtcWuFNGvQEenpeQygN
         R18Q==
X-Forwarded-Encrypted: i=1; AKwUvBxm69+/zS3k+s+qcdVDKG79YDduD0bQrSW4A2zRlhryTBsyNaqKSaiKYrsuIqQiVS8UMdhTFZY=@lists.linux.dev
X-Gm-Message-State: AFq9FYJ1aaQN9M5K1nfSG/yf0x6LN9ti8l/jjLcJGL1dF4PvPT0jYXKO
	fZ4K4yc5bWl08wSLtJroedk1t2XZLpWgpMOikAUtzOQzsWNMLwuJ3GIIoma7Dur8h2JSOEvMXDd
	uKWSt2D7l0bB6ANGaJ9Ixwg==
X-Received: from wmco7.prod.google.com ([2002:a05:600c:a307:b0:4b2:2ec5:89f8])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6992:b0:4a1:a2c0:7b73 with SMTP id 5b1f17b1804b1-4ac18992c01mr253389695e9.30.1793652423340;
 Mon, 02 Nov 2026 12:47:03 -0800 (PST)
Date: Mon,  2 Nov 2026 20:46:07 +0000
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
Message-ID: <20261102204628.401871-3-vdonnefort@google.com>
Subject: [PATCH v3 02/23] KVM: arm64: Propagate host stage-2 annotated entries
 on block split
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
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
2.56.0.385.gac671c819a-goog

