Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B10A20ADD3
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 17:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734371895; cv=none; b=KDphaLKqGpNfe27M12JX43cetEoEU3QQECb6U0x9Cb87lzHWkL3+9D0S/sKDc4cvnrFrULvkzviIe+fIHpJnQAzxEyhMEwRZssbeKTGGAnX7m1CEv2J552ORzkQQuuXXlCoozodKH+MemEhXg+xGF5yniNGeAXx/go6yitq9fkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734371895; c=relaxed/simple;
	bh=5rIXTy5TPuGoLMiV0oXvNDVO3dkl9RGtMRlZct7bt+g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Id38R9bNfsOmx6lFGJrXVFGp4uDlXWwbN7vPA+iPfy3g8Iyxxbza/bPwFZKuPVhgMmXk76ek/QBohb23iaOGNlmW8I0kUXqR+HVbPDSBnN0xU45TFVM45FH270xVbB/M33N4aSVL0k/FmWZo00f5+BQjSfOeHcfpEQ7XHwNLrxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RRq/UolY; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RRq/UolY"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5d3dbddb891so6337642a12.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 09:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734371891; x=1734976691; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9U+p93j/YN41MEZx68FsDZhowuKIrUGiMwA9+JFupUA=;
        b=RRq/UolYESRLLh/maeV8cGYIka05D+M33GxYdTdwNWIgtuaYiKx8E/3GchhWKDcv5s
         gSpV9d0dOwUTYCtr7mXjw0e5zQXLTRGr3JTI6qxfevhHjjs0V97cZzURbvOhrIKqAzfG
         I3I615YP3EQMDqR9rjwb+ifhGnHS7Hy4a7Z4B5+zDpIGNayAMVxv6cN58uwTyTzajaIA
         vgRcgUibLbjn9QaY0KMr96ZY0lP/XJUnVI4OlzVBZRu+w0sGB9CcmwOv9JmkSA9UxG5s
         5Qg6nqGRbti8YgqXYaoKhHznsBSqWTygtI99zZW5hinNhy5pCPzRko6i1gNH3yVRrUmI
         I6bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734371891; x=1734976691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9U+p93j/YN41MEZx68FsDZhowuKIrUGiMwA9+JFupUA=;
        b=MzouAAhxA7L+mIyI/2eMvp2UMUgoY+2aaLicOh3r7G1Di8vZKSRfub/RE6NDJtUAMv
         rkdmUU8U5KKa9YK66Kl0rj7haD6ojrv4bO6bkQm+CfVmMHhSKWcvmaNAYUfvbNCfQxHt
         jKx/bMEw1VfmASMBizPUTLwfFM6Jl6J8d0++pJu4TraWrS9q7/GwgUwLJ0WUq69Wdi6F
         E+gGYDK9oWJeP0c/4JXYBn2UOGB5z6RlxvPoLR75SsGUlsyE0nJpvu/QP6+B+QT7R6jV
         pnl6pJkG4z6Vynp1j4Vx4fxXYMXqov5yh2D04cSfCNSVMVT53REw9zY+mnivDBKNgmlV
         KRJA==
X-Forwarded-Encrypted: i=1; AJvYcCVw8ebbaLTM6Owyvbow2I0xrsRl4pVIeF+TxgaBzsiMyIWmqFdrKXFDVWOIittZvmgb4HHZvDA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxzDvYL/Ru3q0B+fbcbPw1hTG6zRULnjWTcptxNy8+2sO6AcORD
	1OdzVmQYtpX6HH0n+sAsPdMGYvnNLxoGXiS1OJhv2U5uxn0OIjO2LBaorlvsoQVX/vC5kjnvrZm
	RJnOD4Q==
X-Google-Smtp-Source: AGHT+IG7st/yyJqIhpv2xQBIuWlDy4uU3mEKGGddfO0WV9zfYHQl4j73x0bTTMfU7vqe5be5/q+MEgxQCPxJ
X-Received: from edbet14.prod.google.com ([2002:a05:6402:378e:b0:5d0:a9a6:5abc])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:354d:b0:5d0:7282:6f22
 with SMTP id 4fb4d7f45d1cf-5d7d56175c1mr253568a12.14.1734371891718; Mon, 16
 Dec 2024 09:58:11 -0800 (PST)
Date: Mon, 16 Dec 2024 17:57:48 +0000
In-Reply-To: <20241216175803.2716565-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216175803.2716565-4-qperret@google.com>
Subject: [PATCH v3 03/18] KVM: arm64: Make hyp_page::order a u8
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

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/gfp.h    |  6 +++---
 arch/arm64/kvm/hyp/include/nvhe/memory.h |  5 +++--
 arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 14 +++++++-------
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
index 97c527ef53c2..f1725bad6331 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
@@ -7,7 +7,7 @@
 #include <nvhe/memory.h>
 #include <nvhe/spinlock.h>
 
-#define HYP_NO_ORDER	USHRT_MAX
+#define HYP_NO_ORDER	0xff
 
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
index c84b24234ac7..45b8d1840aa4 100644
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

