Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95F8204685
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 13:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741095836; cv=none; b=DyDq7dSG2nsP8srAkl3EVeoXQIsY0rD61qFm2uNBOQ5OitT+Xe581A0jTC5brdB3lqfoqrUEokyT8qoMhDgb8AJE1z9n48o1bDXLNW+U+jo8V4XOIyswZMJaOwSMVzXsnB1H1bQBLRhCdu4ZsY0E7mG0zzDUj189D0lzSghtgBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741095836; c=relaxed/simple;
	bh=Mgo4/DO8OD8GZn9j7UQxKW6LhjTLRQV1hFx41dH7LJM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QhIePQcUBESbwuNk2/eZeoPSVQn58cj/bywLKX9TDeFDHnzkKt5jAmF6EdJqpjp2sQDwoN8kWz3Eh4VWDtnQfP4B7aqufJ73MDXASJygNftIgePp0mk5rN3xz00A5NRPY0XfDAAD+JaEMHJ5CO3PhMUBj/M4ZlXiYtzmZnf+DdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PiyVEexy; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PiyVEexy"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4393e89e910so31194865e9.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Mar 2025 05:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741095833; x=1741700633; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3ciUEmziHwKoR8EZ15kFmNQQUeftjWJUBtJzEaxlx9Y=;
        b=PiyVEexyF3+U4HfpaTZDdclZB+yBugU+axD+72rASvwuu9VlGxbh0UlkTU5/Irdvaa
         TIC066YlUqaDb69K/hjjUOHsxPsymOAzM/3JQOLDqyqvZlRsSZZuWMwgsIWe06qNrrKJ
         WsGybz7oEelkHxBIGi1UGfrvpMGAZ8pJNbO0WCjXssZC2u3Eo/yBhPqsYEu+EgWYMVDB
         EgmhEh7j8zlzRdVY0uoeBwBfo7PGIDtwXkFB/i4epIttCy2FMAVdGurwN1j43q4Gm0St
         B9IEn3KOowvPJ0VdWRLU59W445XmexY9eJ5HsLE1a7pzd6TRjsfKKV1jg6KESQPtdI4Z
         aByw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741095833; x=1741700633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ciUEmziHwKoR8EZ15kFmNQQUeftjWJUBtJzEaxlx9Y=;
        b=bZlVgGjq3K5yH5HztTigcrpPlzGDHHIEKlB5NhDu5OUB+8jCGT3TOmOtT280NRJT6B
         RTurc5/ChNDUBE7R6ScwIQ08iTdLLi5fJ48raZ1UoKmfHQmnSv08XY+xCR3ZsbbFfvXk
         ZPKy0YY09mOMtOY11DcrbfBAFz1qhztJRHxNCYgDhxixYTqmH8FzPaOWihwTfj+lMiO5
         QSKBjb8uO1TKEOIQ5oo0RzJIZRi7asMZIfkZahw2+Ks1IemoHicdHSXn1cxsfyNaP57z
         mWGMmgFhof/PkFi0yUFuFCK5r8zZvBT8icpk4TIv5fpq/WZFsi0/GNMjMh+M1mTfwrIe
         18LQ==
X-Forwarded-Encrypted: i=1; AJvYcCWapUKLys580LXsK/QCpf3A9AswYW8iGLU7U/Um37UXSpvJBiLPVNH6sS7Q8atxxWaZqa6PhU0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyxj/366xHWJ8p3ZP2/gBj6o7LeSuzxU+Zd1I7uoS3Y5TEmF/fa
	xrq9/5KHpqXaTCywWk97CxHSr+hrlxsik0LDbFfRXA42aUhNCenoWj6Nid4CQqNvIfHItWeEJ/5
	tuTNCnhhOXacce+B62Q==
X-Google-Smtp-Source: AGHT+IFHZt3BnQxTnjrinSVy1JtKhEMHkRg+LEokGOtmOBZxYSPyEETqTBFJckhElghvkIX1hmSvWSCVF9ljT4k9
X-Received: from wmsp7.prod.google.com ([2002:a05:600c:1d87:b0:439:88bc:d27d])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4f86:b0:43b:ca39:6c7d with SMTP id 5b1f17b1804b1-43bca3972efmr32164545e9.3.1741095833346;
 Tue, 04 Mar 2025 05:43:53 -0800 (PST)
Date: Tue,  4 Mar 2025 13:43:44 +0000
In-Reply-To: <20250304134347.369854-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250304134347.369854-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304134347.369854-2-vdonnefort@google.com>
Subject: [PATCH v2 1/3] KVM: arm64: Add flags to kvm_hyp_memcache
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add flags to kvm_hyp_memcache and propagate them up to the allocation
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
index 1f55b0c7b11d..68d99baa76c2 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1086,12 +1086,12 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	}
 }
 
-static void hyp_mc_free_fn(void *addr, void *unused)
+static void hyp_mc_free_fn(void *addr, void *flags)
 {
 	free_page((unsigned long)addr);
 }
 
-static void *hyp_mc_alloc_fn(void *unused)
+static void *hyp_mc_alloc_fn(void *flags)
 {
 	return (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
 }
@@ -1102,7 +1102,7 @@ void free_hyp_memcache(struct kvm_hyp_memcache *mc)
 		return;
 
 	kfree(mc->mapping);
-	__free_hyp_memcache(mc, hyp_mc_free_fn, kvm_host_va, NULL);
+	__free_hyp_memcache(mc, hyp_mc_free_fn, kvm_host_va, (void *)mc->flags);
 }
 
 int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages)
@@ -1117,7 +1117,7 @@ int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages)
 	}
 
 	return __topup_hyp_memcache(mc, min_pages, hyp_mc_alloc_fn,
-				    kvm_host_pa, NULL);
+				    kvm_host_pa, (void *)mc->flags);
 }
 
 /**
-- 
2.48.1.711.g2feabab25a-goog

