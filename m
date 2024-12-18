Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4151D45FC
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 19:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734550872; cv=none; b=Ql0vliC7VPvT5asreLDfiFTILxwowELPSMF1SQ6vDTi6yEOHf/9gHGnZCyVUu0hob10mMbu+1yMZJM3KjxomeQEI5KRH+10LUwD0X5FP/PKaOmp6BcLD4xDnhgemvi1kcCtbkFYfdPbL/1gvU4ENyTF4SDDR5pMAiLrV7UjhYOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734550872; c=relaxed/simple;
	bh=u+fOwnC5xDGJB5IIWpGGM8aw0GLdouoVAGKsTO7b8VI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i5WHK202U5wI29Ngh3ablZY9rGhGRXlLByzhh1svBJ7QLX04WIr42bosuAsfD7aRnpblK3uUvVTApZSI+//QCV0vs48SuVA/ntDT808b1FpehDGxcQ9MMjJVDvh6ltTYbnEhziPMfvSG1Bt9hyaBl8NS7ZdZjgXjdnOodnqyTAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f6QYYU0Q; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f6QYYU0Q"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-aa6a831f93cso723236266b.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 11:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734550869; x=1735155669; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PduJERFrled8xtlVt7hkNZd8foU0YkZ4d2iWPXC2aQE=;
        b=f6QYYU0QsnHY4wrrz90Pc0pMeQo87657LDKA+vqff7X8Rc6KMRR8oAOMPXJZeany0M
         XLKFYhUjYgDXyIwkWHyitCBz50AHBUOBpyxNZ+aAygy54niH36mk9349KyoZ7zbigt2l
         v6gpcylJnSwKBamMXz9lfh1V07BEmwFT/l4j3WeMaC+f6fWyibw8LgwhYi6WGV3uIM7t
         LOJ4wLEw5s+o4RtrR0OILbZ0Acg9XWZgPGVXKrqez7XgBuNqIeB4CfSWR+PFPiZogz3f
         HXhwWt1C9UmAObo/SrSPGRNAqFSYDxOZ+XxAJ+6nCWWXYwvkgwEQr/y7ycS5DAmcvWFP
         Y2hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734550869; x=1735155669;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PduJERFrled8xtlVt7hkNZd8foU0YkZ4d2iWPXC2aQE=;
        b=feNE26CZnz4UPzRRxU7CVP00sHNAD2Hh2JKLuGvmRnffNjKUjPPyeIMWBkg47NFiyK
         yQhi8/i+fqCVexaFPlRXpR3gTFs0v/pjyqpf2HvgmE6EZ9wk+EEE+IhKrRdjreum+qyK
         RDFqy2VLfEU3iPbzuS+8tXK2aDspTqe2K5XwCh2v7nchGA0AtaJOlvKLUsImJoJ1O+br
         6WyqxEYTPgxtuEFO5K14BuZbVwS6mdknRXK5iS8/uUm4PzaeEWuNk93xpfLqytHj1eiJ
         jkENYYcH9iQQlbSwSJTDklBbjTum4hNbuALAw5Xe5DFdUtGnWNTaKdpxIk3fDWDjBOsr
         rIfg==
X-Forwarded-Encrypted: i=1; AJvYcCVSNsj0xWOyUFOGNSF1AlNfXxClijN/2HVSRgwLnQm+1jMALT6EdFuJf+AfPsllcaXrisszuKc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+CGHVbKriyaKwsgCtKExeYGvA5TtgpqQtnGx6+Ui4RI+J5mWd
	WX4ueMobWftSwS4YsGcX+fBOlw9NSYSaxgBGQU+EuCwHFdcvcjdajaN9g3RLUxNEmjxM/I3ziQI
	JEiY2Sg==
X-Google-Smtp-Source: AGHT+IEzfg77HHE0CyOw+rv8bE4cFPV2J1IBhBkYsKjKqKS35RJU0YPOC+Z6JqMb76N1ZMGCOQXv2II72IZa
X-Received: from ejdq18.prod.google.com ([2002:a17:906:3892:b0:aa6:9198:7599])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:c10d:b0:aa6:66eb:9c06
 with SMTP id a640c23a62f3a-aabf471913emr432721066b.5.1734550869004; Wed, 18
 Dec 2024 11:41:09 -0800 (PST)
Date: Wed, 18 Dec 2024 19:40:44 +0000
In-Reply-To: <20241218194059.3670226-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241218194059.3670226-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241218194059.3670226-4-qperret@google.com>
Subject: [PATCH v4 03/18] KVM: arm64: Make hyp_page::order a u8
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

We don't need 16 bits to store the hyp page order, and we'll need some
bits to store page ownership data soon, so let's reduce the order
member.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/gfp.h    |  6 +++---
 arch/arm64/kvm/hyp/include/nvhe/memory.h |  5 +++--
 arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 14 +++++++-------
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
index 97c527ef53c2..3766333bace9 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
@@ -7,7 +7,7 @@
 #include <nvhe/memory.h>
 #include <nvhe/spinlock.h>
 
-#define HYP_NO_ORDER	USHRT_MAX
+#define HYP_NO_ORDER	((u8)(~0))
 
 struct hyp_pool {
 	/*
@@ -19,11 +19,11 @@ struct hyp_pool {
 	struct list_head free_area[NR_PAGE_ORDERS];
 	phys_addr_t range_start;
 	phys_addr_t range_end;
-	unsigned short max_order;
+	u8 max_order;
 };
 
 /* Allocation */
-void *hyp_alloc_pages(struct hyp_pool *pool, unsigned short order);
+void *hyp_alloc_pages(struct hyp_pool *pool, u8 order);
 void hyp_split_page(struct hyp_page *page);
 void hyp_get_page(struct hyp_pool *pool, void *addr);
 void hyp_put_page(struct hyp_pool *pool, void *addr);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 0964c461da92..8f2b42bcc8e1 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -41,8 +41,9 @@ static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
 }
 
 struct hyp_page {
-	unsigned short refcount;
-	unsigned short order;
+	u16 refcount;
+	u8 order;
+	u8 reserved;
 };
 
 extern u64 __hyp_vmemmap;
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index e691290d3765..a1eb27a1a747 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -32,7 +32,7 @@ u64 __hyp_vmemmap;
  */
 static struct hyp_page *__find_buddy_nocheck(struct hyp_pool *pool,
 					     struct hyp_page *p,
-					     unsigned short order)
+					     u8 order)
 {
 	phys_addr_t addr = hyp_page_to_phys(p);
 
@@ -51,7 +51,7 @@ static struct hyp_page *__find_buddy_nocheck(struct hyp_pool *pool,
 /* Find a buddy page currently available for allocation */
 static struct hyp_page *__find_buddy_avail(struct hyp_pool *pool,
 					   struct hyp_page *p,
-					   unsigned short order)
+					   u8 order)
 {
 	struct hyp_page *buddy = __find_buddy_nocheck(pool, p, order);
 
@@ -94,7 +94,7 @@ static void __hyp_attach_page(struct hyp_pool *pool,
 			      struct hyp_page *p)
 {
 	phys_addr_t phys = hyp_page_to_phys(p);
-	unsigned short order = p->order;
+	u8 order = p->order;
 	struct hyp_page *buddy;
 
 	memset(hyp_page_to_virt(p), 0, PAGE_SIZE << p->order);
@@ -129,7 +129,7 @@ static void __hyp_attach_page(struct hyp_pool *pool,
 
 static struct hyp_page *__hyp_extract_page(struct hyp_pool *pool,
 					   struct hyp_page *p,
-					   unsigned short order)
+					   u8 order)
 {
 	struct hyp_page *buddy;
 
@@ -183,7 +183,7 @@ void hyp_get_page(struct hyp_pool *pool, void *addr)
 
 void hyp_split_page(struct hyp_page *p)
 {
-	unsigned short order = p->order;
+	u8 order = p->order;
 	unsigned int i;
 
 	p->order = 0;
@@ -195,10 +195,10 @@ void hyp_split_page(struct hyp_page *p)
 	}
 }
 
-void *hyp_alloc_pages(struct hyp_pool *pool, unsigned short order)
+void *hyp_alloc_pages(struct hyp_pool *pool, u8 order)
 {
-	unsigned short i = order;
 	struct hyp_page *p;
+	u8 i = order;
 
 	hyp_spin_lock(&pool->lock);
 
-- 
2.47.1.613.gc27f4b7a9f-goog

