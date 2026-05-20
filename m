Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF943F1AA7
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 15:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779290849; cv=none; b=R0a+xdjqd/IgoeoWIwKG8aTQ4F+TE1u5eHQgTnGyk2ljxSjJ4pmO4L4cUIpMDJBbeLfHgfaKpfKZq0gJ97bFoTRc3iO3fWNCYqmBqVHC4xqOA8AGnuIcEowO37Pmv/tKef8TuzOui2f0qdct31VPn4XNNPkr60kUFvv7jx+LxWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779290849; c=relaxed/simple;
	bh=aBR9PmJk6Pkpn8V3tnUSsB+jP0lwpZ49OdgP6PxZXmc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j9+VFZIuRACyV7vx/Xmss6g4tRUZCv96GadAyIEqmCIDBcNV22DWAqYJR0NqmVYLolZc3sybsGJVtEDb79Tpn6QjKSTz0hmoYjoakrki4hKsjMU7aRJxnBL9qquH/SDef9qAYqfTpL0LKwQBc3O0LT7FaIZwJr0tOFN38Mp1SCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jPdh8Wxu; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jPdh8Wxu"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43d789cebcfso4035536f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 08:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779290846; x=1779895646; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4BeUgYoR/kz4RmvWlSaqpx7UbEQvpm7Z+waUKWX+x6Y=;
        b=jPdh8WxudvyyLVgbJRBQYkDR+PZZ8UDkBGYB/4s3ZpUsOrVduyWI3bhsjGd9WTzpYc
         Wsj6cbfW+pHqvrqckOrxuIsFzHPTLLwhCqkU4AUbeWLEKVzTavwE794eTQ48crof3Z28
         HekavkyugpvRGYC1kVWAkWjUBCTw/rrrmXszMjvFh3iNxd9QA19NFw80ZUogwq5qn79H
         zux84mEb5K7Y2y6FZe8Z5kFmPOjzEUy22gqiC3mXS6JSNmodlfUFDDYv+yCX6SfpwOx9
         1dGMRpjfS0P4Y5IyQVuGh8iE0bakLG6wvj+Jacn32sqMnFU9KvgpCtlISkJ2MoQX5O70
         A8WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290846; x=1779895646;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4BeUgYoR/kz4RmvWlSaqpx7UbEQvpm7Z+waUKWX+x6Y=;
        b=Opog9J5pIXklKrREPqau/u3jzjuni1K2BcxBdGvyxILvlfZrqnErwLYl7Z8TVkVyKT
         SoH/i9FPtjpwRSRtd8a3e5uhBNXtSJ8sLkC5qLxBqW19oZhN8PZy8H1DrEILX1xxwZMM
         ZIuvCVSyalQlUZkYR7Wd+HT+EaugPFEuw+kWSabw/uEKiaZaYrGAh75mz3dZkg68xaWK
         LCP3lAjtpn3aDqI68nfK5BCJKpaQ83RYhngsa5f8bQf7UYHERfsRsXugcLH+ZrLFGZGH
         gMTPtHw5CiKgUqlJ9zNqNsU9DB1rsbgsHSd8POtDS1ascpJpAsCCqNNFeUyv1W1Gey4p
         gP0A==
X-Forwarded-Encrypted: i=1; AFNElJ8lYCScFcB/LGSFwHvZ18s92maodz2ZZqpZgEkR/mvtFVLxsju3Liq4YSXtxbzT1yumTiI0ClU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwYkVSjSxyugf8tbjIateMniu3Ib9HJWRRQgIoSMOPVv44JbmwP
	Fry2ZzsHoVxHtTZwfIivFoWNVu2k/y0paYzMP0tgrWq7EViwvKfFdRrtV73ZWDCfitLKxfgxgew
	tIy5Ltp3Ih1EgO6anhaVfxQ==
X-Received: from wmot15.prod.google.com ([2002:a05:600c:450f:b0:48d:1bc8:5961])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c0d0:b0:48a:761:5816 with SMTP id 5b1f17b1804b1-48fe53774b4mr288092735e9.8.1779290845797;
 Wed, 20 May 2026 08:27:25 -0700 (PDT)
Date: Wed, 20 May 2026 16:26:44 +0100
In-Reply-To: <20260520152650.4107895-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520152650.4107895-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
Message-ID: <20260520152650.4107895-12-vdonnefort@google.com>
Subject: [PATCH 11/17] KVM: arm64: Add a shrinker for pKVM
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Integrate the pKVM memory reclaim interface with the host's memory
management subsystem.

This allows the host to automatically recover unused memory fom the
hypervisor's heap allocator when the host is under memory pressure.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8bb2c7422cc8..34e6fab29210 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2677,6 +2677,18 @@ static void pkvm_hyp_init_ptrauth(void)
 	}
 }
 
+static unsigned long
+pkvm_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
+{
+	return pkvm_hyp_reclaimable(PKVM_TOPUP_HYP_ALLOC) ?: SHRINK_EMPTY;
+}
+
+static unsigned long
+pkvm_shrinker_scan(struct shrinker *shrink, struct shrink_control *sc)
+{
+	return pkvm_hyp_reclaim(PKVM_TOPUP_HYP_ALLOC, sc->nr_to_scan);
+}
+
 /* Inits Hyp-mode on all online CPUs */
 static int __init init_hyp_mode(void)
 {
@@ -2823,6 +2835,8 @@ static int __init init_hyp_mode(void)
 	kvm_hyp_init_symbols();
 
 	if (is_protected_kvm_enabled()) {
+		struct shrinker *shrinker;
+
 		if (IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL) &&
 		    cpus_have_final_cap(ARM64_HAS_ADDRESS_AUTH))
 			pkvm_hyp_init_ptrauth();
@@ -2843,6 +2857,16 @@ static int __init init_hyp_mode(void)
 			kvm_err("Failed to init hyp memory protection\n");
 			goto out_err;
 		}
+
+		shrinker = shrinker_alloc(0, "pkvm");
+		if (shrinker) {
+			shrinker->count_objects = pkvm_shrinker_count;
+			shrinker->scan_objects = pkvm_shrinker_scan;
+			shrinker_register(shrinker);
+		} else {
+			kvm_err("Failed to register shrinker for pKVM\n");
+		}
+
 	}
 
 	return 0;
-- 
2.54.0.631.ge1b05301d1-goog

