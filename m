Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D78D14D6EA
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560998; cv=none; b=pwSNaAVICtzGIMbxUbgja6/k+vDjZHZKilwIH9gkbkNL/338ENOqFXvaAg8ORaLxnGyOwYTwiiOnLLRdvf8TZrCQAIqPy2Zv9Dcn3e6hHOgtSgt2AQmzTM+vfLlf/KUEKxIik+yKLzpUpCQd1ZfxtMgNWb2G5s5EQ3JGsdVnbVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560998; c=relaxed/simple;
	bh=P9IKXyO6rkyXeaSXI9dKnXDXpizkiFdwg0At6L7lD28=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N6WJUVzh7a4YzsfmwFbFp31ZcFXv2XN0JlQo4xvsqEoxuawtYmDdjnVIRiTIhPe5uNd3xpmOg8+7ovHu7vtDSBnEcqkdpXuYOei5IeqUc6cf14Dub0xy9zShekag8z8i7V4WQdTl9XVdMUatLT5DOgqlW8SV+kSWQGme+VP8aSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dIniaXjq; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dIniaXjq"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b269686aso57583276.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560996; x=1712165796; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ts6R12WsLFfWMAbvD8rwF80LsLTc6S4wMUX9wsxsdjI=;
        b=dIniaXjqw2fAGaPVLEJ2MXB0AyEzNHDgUgWmVtH5AV7EZH3AeFc9RAGnFzjHUdU0am
         KvS8lblPZQ8H3fvTjN7fL/CWHdE1YHy3eEkJkb/tIglN47/qi5ZXaJGk4ApYPfzNA0q5
         PZd4TdX9RwE6svcXUsIkFYD8JgaQSRnnqnmhduXo2aqJP5OncfMAc0cq9A06I2glbGE5
         dvuHBjVXDpN5m9kwztsUhKad8DvgaScLpt8UmE5dmsWSOqOAdkf7CcHktljX2ahwXTd4
         CwWUc7zknHR9I8vYcDCHBg0McugDPo9yWUCvq6mxoDpOHA5HImcxhLtTSu+5rZ7BNgTU
         zMkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560996; x=1712165796;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ts6R12WsLFfWMAbvD8rwF80LsLTc6S4wMUX9wsxsdjI=;
        b=aA7vGOjh6RNNpjH2TN8MXcE1+2PTCQKWP+CJQ55B7Qke3X1aqSqJsA2jd2mLyyH53C
         Q27ehXSavSw9/a2qF7OaObqfrS81HVxcGQOoG4aSXpv9y9llrOMG7yCHA48RzK8vysX8
         L/nRqxUi87VHA4/5H6Z3ogHALXJ7xOeEXrid3iU5EEujOAy6GGsxNYiN3BX212a49+BZ
         ykTpyVy9l7d1rjbVG7kf4xa5KFLBuz+lrw8Ml26GMw+oyES5w+RdwKXdXoGrM4gq5DHa
         /bZiw3+O/qAUbba/X7jk30HVequHOJYSHlAZ3Aaq+z/SS6lwF84Zd1yziwrbRolpTAzd
         SYtg==
X-Gm-Message-State: AOJu0Yzo4U+LrqzEQFdKPz6yIbV1fjzexpCgi0ImnMLoJOpZtxZpz0xt
	J3nQV3l4io0vWU+bvuoZMJ7urHCw0aFkHg5gPKOKd6FZvur8k9K0fJ69GRMJx/73sHwTv7E7DfV
	Pr+WUt0iYX6/5fNfLoukSSzc10osS2AYnzxFiQvwZE5E/+wU+0405cgz5SDCinNEUivrFkZ2MTJ
	gtgv7indog3JiRk8Oz/XxeGasc4RU=
X-Google-Smtp-Source: AGHT+IF4TnjjAff2u1Dn04QuhY8OJz9ZUpZR3MBL//vlMW2IHCorNHwY6XV26wdzPRE66/lq75ROQO5nLA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:2206:b0:dcb:fb69:eadc with SMTP id
 dm6-20020a056902220600b00dcbfb69eadcmr63701ybb.6.1711560996195; Wed, 27 Mar
 2024 10:36:36 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:14 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-28-tabba@google.com>
Subject: [PATCH v1 27/44] KVM: arm64: Use atomic refcount helpers for 'struct hyp_page::refcount'
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
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
index d48990eae1ef..4b20bf553312 100644
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
index e691290d3765..169cdb43b4b8 100644
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
2.44.0.478.gd926399ef9-goog

