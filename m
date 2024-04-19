Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19DA47F6C
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513648; cv=none; b=Etn1LZPIkcaMTHyFjd5jLqrhzwbFbQzrjfpWAfwSG7BXjnmEe7GztDFFCnJff/iQEmdsdrf17cnf4OG6F1+6QB//C0oqV6tayso0Mw3f3VnL6q/0VCAkOUchF3wzdalQcN1CA7YXPtqHNikY7bmB2rk/dBHc9xA9eIuaIgs57vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513648; c=relaxed/simple;
	bh=z4LE2wEv7zUCJRdONGSDMcB7+NNSFl7m8zaX9bfIzVU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qA4jOTvB5qzGuAUd7xFdnD5PdPKaj7NL4TYIRQEOQc8YEgd04MWC/oYFphcW0u2w5QTr/isR6jtTlfyZ+n0G4fxZwLKWhLofLa3i1cBOWMmwGjCbSlH/mKnJP+5SWKWMSmte5fI9qRdToKS+lWzDxou2MPVcOPwFgqYiCuLFkkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RW/7thD/; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RW/7thD/"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-347f92ab882so1075107f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513645; x=1714118445; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dQcfky2yMPis8pZt5ituuAAZ/c63qm6kqI30Xk0h8d0=;
        b=RW/7thD/1qmvRbpOpz/m688EaJfm5p78c91zwdf7yewy5Dl4f7YqqdCD5VWLB582cw
         OKweuBKzntKpkh2txFClzPkxRIqFzEzFEW/ZhBQN1u0Snt1qNoKYuQxqGUKE90+Zw+JE
         K064aFnT0XfeQyPi+Za1z7G/mA0w/Z7J/MuSZ/w2XWLJY9aIK4lDCktE+THzxoB5tgEJ
         8PcV8Lyc1icNXcJOex3WvkZQUUKcCO2ZIcaji2lRISCjKW9wLLjVM9jZn0s4/lMzsB1C
         s0R1adMJGHb/FWtPn4/FO70bNHabAeP5dPVb5Xf+R3rbVoBiIZrhmK+9iBkfB1SFofPm
         u/4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513645; x=1714118445;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dQcfky2yMPis8pZt5ituuAAZ/c63qm6kqI30Xk0h8d0=;
        b=kUESLsL0aWKhYVixP+Jak+JTrJkIWbZ0bJ3H9vrnLZFDvozDNsJDX1JD4tNPGh3s7R
         eS4x6K6oqSQLhVSZoXCAAtPKJO9RMpxBV9HArbNJp0LNjhb6v4UO35lrbtIC7/no8zzT
         dVOB89czvv2J8Bw/hfN/NJNSzCQRjsA11y/FkP8SogtJ2kQsf2clGEsfaGDZwM0UXx3K
         wSjKWDA6u76eUQsRCAlfiRs1oIcRV/rg34eVXEZUGvMc6SSsd69nhYEZwCqLJlC/cYzp
         o0iTb7o9HyMyj8bBX99kFJmyQuQAGF/lwyzrLwR/C3jne42AG76AzUuJRgSXv51QCO0a
         Y+Rw==
X-Gm-Message-State: AOJu0YxJ56jE4tvKTfL2rImv82leeH61cS+X8fjRiZfXQWuY74wqRLky
	C47sFz7+3BJa88Sf1JHpHDFqkz4QGLYcDXw4wA8XlzwPnMGY3InwHC6s9leQLcw9lnd+ZjFrxMx
	RsPiJhbbMqoiAriYIf94N8+6K542dhFlW7BDv06td6/Gm4Mv53XG9fGt2Gy9SqupR3xGrq79cAA
	/9qqjgHS43hLC8zJgwsKEBI7MnXA4=
X-Google-Smtp-Source: AGHT+IFUxbwUY9TWt3F7C9Gj7Hbdjkcz89xfYfNgMVAkWHQMlstMV7obHRAIF7WClDmfUxY2WAbXfyMtFA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:ed07:0:b0:347:9c81:754f with SMTP id
 a7-20020adfed07000000b003479c81754fmr3507wro.14.1713513644880; Fri, 19 Apr
 2024 01:00:44 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:37 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-28-tabba@google.com>
Subject: [PATCH v3 27/31] KVM: arm64: Use atomic refcount helpers for 'struct hyp_page::refcount'
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Will Deacon <will@kernel.org>

Convert the 'struct hyp_page' refcount manipulation functions over to
the new atomic refcount helpers. For now, this will make absolutely no
difference because the 'struct hyp_pool' locking is still serialising
everything. One step at a time...

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/memory.h | 18 +++++++-----------
 arch/arm64/kvm/hyp/nvhe/mem_protect.c    |  2 +-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c     |  5 ++++-
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index ab205c4d6774..74474c82667b 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -6,6 +6,7 @@
 #include <asm/page.h>
 
 #include <linux/types.h>
+#include <nvhe/refcount.h>
 
 struct hyp_page {
 	unsigned short refcount;
@@ -39,37 +40,32 @@ static inline phys_addr_t hyp_virt_to_phys(void *addr)
 #define hyp_page_to_pool(page)	(((struct hyp_page *)page)->pool)
 
 /*
- * Refcounting for 'struct hyp_page'.
- * hyp_pool::lock must be held if atomic access to the refcount is required.
+ * Refcounting wrappers for 'struct hyp_page'.
  */
 static inline int hyp_page_count(void *addr)
 {
 	struct hyp_page *p = hyp_virt_to_page(addr);
 
-	return p->refcount;
+	return hyp_refcount_get(p->refcount);
 }
 
 static inline void hyp_page_ref_inc(struct hyp_page *p)
 {
-	BUG_ON(p->refcount == USHRT_MAX);
-	p->refcount++;
+	hyp_refcount_inc(p->refcount);
 }
 
 static inline void hyp_page_ref_dec(struct hyp_page *p)
 {
-	BUG_ON(!p->refcount);
-	p->refcount--;
+	hyp_refcount_dec(p->refcount);
 }
 
 static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
 {
-	hyp_page_ref_dec(p);
-	return (p->refcount == 0);
+	return hyp_refcount_dec(p->refcount) == 0;
 }
 
 static inline void hyp_set_page_refcounted(struct hyp_page *p)
 {
-	BUG_ON(p->refcount);
-	p->refcount = 1;
+	hyp_refcount_set(p->refcount, 1);
 }
 #endif /* __KVM_HYP_MEMORY_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index caba3e4bd09e..ab5e73a82857 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -202,7 +202,7 @@ static void *guest_s2_zalloc_page(void *mc)
 	memset(addr, 0, PAGE_SIZE);
 	p = hyp_virt_to_page(addr);
 	memset(p, 0, sizeof(*p));
-	p->refcount = 1;
+	hyp_set_page_refcounted(p);
 
 	return addr;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index 73437f5c2616..96b52f545af0 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -55,7 +55,10 @@ static struct hyp_page *__find_buddy_avail(struct hyp_pool *pool,
 {
 	struct hyp_page *buddy = __find_buddy_nocheck(pool, p, order);
 
-	if (!buddy || buddy->order != order || buddy->refcount)
+	if (!buddy)
+		return NULL;
+
+	if (buddy->order != order || hyp_refcount_get(buddy->refcount))
 		return NULL;
 
 	return buddy;
-- 
2.44.0.769.g3c40516874-goog

