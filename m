Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A19A8665A
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261469; cv=none; b=qJoHLERR5HOmV8ut10zuXBSrMV9q1QnMUSN180qKdkO5t6UfO41ZczOqmp9eMR+xJobNb5ZdWngAVZnmE5fe+21Gjm9hSzShrTIbzWS2FI7XBfwRN+vOqb2Y5sNwY9t1sMjCrbV79y+0ISyRwPoMcdbLgL3xzLQtLrCPRi2Fy+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261469; c=relaxed/simple;
	bh=rM+6CK35mrKzQVxy8BNr/Pn2a96G8vYHoRmPjxcyWTs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C6hGlsqThqF92RBo1SWlpJpm4EHAKhtFLYPDiw+75Uu0zWwHO7w030lRnnxdAIgxLQDtB2zcIgUyENWmBqJchPbYecp0FzX5khIohDYX9mzmWldNn1Du+WUZpNZ+pTpCd1MG8YkVUwyyoqTX3nVCoIy2GydNg80ALGwg0+k9Hkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XMKS0CdV; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XMKS0CdV"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61ac6bf7055so32130777b3.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261467; x=1713866267; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GNag6DAfGUiHQsxYOG9YuoocNkk4v504UMec/WTizs8=;
        b=XMKS0CdVRrJMpl1Q6NP6icMZhSHNR0ThgxbfOc5lVnqSsNr5clZHiTU7hdWrNfiQSa
         bGC0L4MYJ3eYPz7l5dELV/vWBHagIx/RNaarD9GUZCURHUAxX7ZSuwzPHCH+Mnl9nXCW
         TTZOcFjZ/Ktb8RpBxQTIuT6tucc07XPhER+gDbKZG0/OnK3Q4oWES/s+THSLV6/AXUDo
         Ib5ywXsMZPsHrQmFdi7LTaJ4mb0S71JoGM9QoGoyJmR49M4r2kRJsu1kUqY1fJ06lIbT
         +RsHMrgwxBIBnoctRTp3UnUG/JiBNF/32/0xA1cmlPWukMFcTLcSteaWSONj7W7+oTpS
         zpAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261467; x=1713866267;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GNag6DAfGUiHQsxYOG9YuoocNkk4v504UMec/WTizs8=;
        b=YYBcmsjlZ95W66fVc+gQ20vOgqU79ZuVkrJxirV+y9JAeWbZLtiZu9jTzBCqBjv500
         FG3Ct9lAxGVGNNGprn+8BKWm1fY84gPaDsXCwFpiB4cG5+gYxP+REcfqFn9lttkLBzkd
         wi0Du1AMvs5pO+vm9BhdS4sxYgoukG5StvvENpq0w2LYGLZ8HCGgVsASs98vIVGcEwZq
         K7LmCF+I0FwRbSJXTQIpQ5hfiH/4/c7YcG2fUxMHkLuCXC/su0+tmOt4/wR0aBWiA9eo
         jmpUwtADO40nn3pQhKFnm0ecbDmvZV6VArzPVnUXDdBiP7o9pgmHlMFzjEax0mnNu5QH
         7hEQ==
X-Gm-Message-State: AOJu0Yxb3otkE1hI78hBvuS/xdfIR+hdUtZd7BHVg0DPoGGsSrGvn2YJ
	oT6eQbN89ETHN7HOQsNIlHQx74bT8nxTW2NrfWc1cng4q12ZbdU4Oqm5KmDl7usdHt0TF0knq/x
	ErR17TCBQAziEFWFpW36NojzTim1rL0nMUPcvFD8XWf/0eBOywzUxGRYrJNDuO1miZDKgyilsq8
	Mgbvfk6QL+ccJ3WpiRTx8GSqB4fGc=
X-Google-Smtp-Source: AGHT+IHW9G0jQGTJtDh/TlETbbHkZ7Q3XCay6Z9UE9toVy7DL2fC5Bv4HgPGH3OMEp8niG6bytMq224zKw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1009:b0:de0:ecc6:139c with SMTP id
 w9-20020a056902100900b00de0ecc6139cmr3741808ybt.11.1713261467296; Tue, 16 Apr
 2024 02:57:47 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:20 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-30-tabba@google.com>
Subject: [PATCH v2 29/47] KVM: arm64: Use atomic refcount helpers for 'struct hyp_page::refcount'
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
2.44.0.683.g7961c838ac-goog

