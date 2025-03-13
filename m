Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AB4266EE6
	for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 11:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741866054; cv=none; b=h7OuameXlQYkDpOjQCen1xyAMr4IIfJfkZWXY1Hr5k7PJh51ehbVwEtGAmhvdIbi2i1u9wvoy8ikk75QwXcs6fRws84YE0BBUL7Vvgit3NSi/G8Pfm3A2PeeAtWY8bCjLTurG8sp07yrWHiVtRKlGBE8X0HUJTFwP37H4429zNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741866054; c=relaxed/simple;
	bh=8L40uIOd9N+HOMn5n1S03oOWzS9Nj8POq5v8izGudb0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WNCujyDpm5YpvUSLOeOohYIocge6dS9B8kAT/m9XM7F6N2s/nAzs/PHCdreEWa4sp5V6EZ2ppC6GosbfW6qjhpwCAwBj73xowGtG/oNVEq2KQJRXjbYlxL9aHWclnx4baRIXqRYthUKXTtn3mAZrkHiTymJGAYDMR5zAdJwkRvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DCJpa9pq; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DCJpa9pq"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43943bd1409so6402895e9.3
        for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 04:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741866049; x=1742470849; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dVJVlv+KRiLMqpaJQOXgQktnx0DyjzlKOnB26dCdeT4=;
        b=DCJpa9pq3ULh5NdEZyePQVzcYJy52ylNCp2m61kYM2kPnpsb3Orakus6yFcy4AzyUc
         2+5ZilXHvjQ5XZaVyFbJA5MJ9+GKMyZ9F/NcLscOqNSu3D0/QliWn5++mCvREMSmfJXN
         ki8liSsEBJfz5VVIF/hTiNQyZ4qDtArO/Ojt2tBNN5vjn9Aa/1I6fLynkAnt0+axr0qI
         kFw9wB64T4k+7Pz9TmK+C6aSRnd2zzr4ailHYwMZy7Nuoig61w8Mmhvhe669knKt/o7O
         MWiDE1LhQiM0jK3wxt+je9yWGxw4nOPId9ZOr5ewrnVBS62K43W3B+je+yb6HqLhFm/h
         OQFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741866049; x=1742470849;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dVJVlv+KRiLMqpaJQOXgQktnx0DyjzlKOnB26dCdeT4=;
        b=uqC7jk6ebaNAR1YIU46QnidLeXsh9HPRusNWKuGOQTw25sEpK7K5Q6Fvod4GkLxt4y
         MmGXkZFf0oAnyeol3W9K9DEAyWghjs/uNLBHTgY5/CoOHa/Kf0Gk2rqVqe+jKv8TTVMo
         HWCZokdwfEP6nVVpn+kSKCT4yhUuBkgGjvanLMNgUgPyHsODDPy1KlAh9UkS0sv+ZjJu
         Y4e8w1yliJOtXtBfb3KyQSWj2G/Xc/MQ2/locpnYvHVmbziY5hqTiYwFJsCeoNlfd8dC
         4JfEGPAlzVUxKAJtTGrReHHrVr8fDh4LklQITISrYWAOzT9qiox0yKT40K/58nybhevv
         un9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWlgPXS4WAeFVvJdxSUA1mwZNAYxcjXQ5f7tzEPZQUM/A06mBmKB8vowQlqeIPAj7tA8DO5tgU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyCYpeXK9Bm+sncL/sgtNxCaLr2jZcChFcp5MgbG2ms0k6S6OXR
	SeG0ovW8ANbAJiqaT+HNZ0QXrAklHrRNYJsASiOABdhEkBfAr5StR5AMDUyKDJ9rIscp9INjo2i
	E3W//t23ZmiTpVRQaXA==
X-Google-Smtp-Source: AGHT+IEzRRTpq9BGThjAtTMnpcfpVggLzq2Mj7jsx/mhuvVJKFcSB7Gz6JGQE1qtaMHhWCec0Q9TXeSZjyRruCGb
X-Received: from wmqb15.prod.google.com ([2002:a05:600c:4e0f:b0:43c:faa1:bb58])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:524c:b0:43d:b32:40aa with SMTP id 5b1f17b1804b1-43d0b32419amr49874555e9.3.1741866049761;
 Thu, 13 Mar 2025 04:40:49 -0700 (PDT)
Date: Thu, 13 Mar 2025 11:40:36 +0000
In-Reply-To: <20250313114038.1502357-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250313114038.1502357-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.rc0.332.g42c0ae87b1-goog
Message-ID: <20250313114038.1502357-2-vdonnefort@google.com>
Subject: [PATCH v4 1/3] KVM: arm64: Add flags to kvm_hyp_memcache
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add flags to kvm_hyp_memcache and propagate the latter to the allocation
and free callbacks. This will later allow to account for memory, based
on the memcache configuration.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3a7ec98ef123..12691ae23d4c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -86,6 +86,7 @@ struct kvm_hyp_memcache {
 	phys_addr_t head;
 	unsigned long nr_pages;
 	struct pkvm_mapping *mapping; /* only used from EL1 */
+	unsigned long flags;
 };
 
 static inline void push_hyp_memcache(struct kvm_hyp_memcache *mc,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1f55b0c7b11d..6107a3c8ccf6 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1086,12 +1086,12 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	}
 }
 
-static void hyp_mc_free_fn(void *addr, void *unused)
+static void hyp_mc_free_fn(void *addr, void *mc)
 {
 	free_page((unsigned long)addr);
 }
 
-static void *hyp_mc_alloc_fn(void *unused)
+static void *hyp_mc_alloc_fn(void *mc)
 {
 	return (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
 }
@@ -1102,7 +1102,7 @@ void free_hyp_memcache(struct kvm_hyp_memcache *mc)
 		return;
 
 	kfree(mc->mapping);
-	__free_hyp_memcache(mc, hyp_mc_free_fn, kvm_host_va, NULL);
+	__free_hyp_memcache(mc, hyp_mc_free_fn, kvm_host_va, mc);
 }
 
 int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages)
@@ -1117,7 +1117,7 @@ int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages)
 	}
 
 	return __topup_hyp_memcache(mc, min_pages, hyp_mc_alloc_fn,
-				    kvm_host_pa, NULL);
+				    kvm_host_pa, mc);
 }
 
 /**
-- 
2.49.0.rc0.332.g42c0ae87b1-goog

