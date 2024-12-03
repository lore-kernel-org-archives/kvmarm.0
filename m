Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369BE1E25E5
	for <kvmarm@lists.linux.dev>; Tue,  3 Dec 2024 10:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733222266; cv=none; b=acgch0UkL5bTj1us773+SBYa3LQK3SmxTh6Hz/xa+tO5ik+Lsl/+fT2C+TtN0auTCEEjwJuQln2E9cw6Nn8z22tSq3vwaADRfeBx1F7VRrqZhxJKxiCnoD1KzjFMJbCx0fRskyHyTAPlEO4pGy+pbBVz+J1cW2c05d39LoHRRRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733222266; c=relaxed/simple;
	bh=xJhsEPialpMSQVCnlCgLVWaAFxIPGZNZJG2yIthGfFY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ozVj3sepZ60BuGEfUuDX15mRwIEqZjIpwvIRaNEh9U1RSsHAz7P48hFfxvYw5iQcJVVHDai3A3lYaI2w75il9vRItlMK1pqVeHuWlIAYwjZ+ouQBlPaqYf2wB15Ih9EKwJRB7Idbk5R13kirMeOSEDBvihw4+OC8AGUIh3a0/B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M4+V8BKd; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M4+V8BKd"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-aa5202c5a34so170037966b.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Dec 2024 02:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733222264; x=1733827064; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h2InjsufEFntOTn6gngou7a+5/1DcqO5mqDCh0ChGiQ=;
        b=M4+V8BKdW3S0z3ne7rETcs08nKvs5YsYvhGYbFfdAd4xk/JIOSmQOb8OQyB4MsD6gw
         ov1YBIGK+9P9KWHH/Cz+M7iJPldt8d/BPJrVNx4RFVRWMospdcFcCfToA0EkAqU3vA+5
         PQZ8KtkO0eUZv2yGSFEYAjrNK4qp2LhpMU0EsMG4LKiC7+jaL3bPMpfZd1g1X2M5Ui1N
         4tt0Uxd4p393Nel0wwq04dJ0QiJ4lx7qMObXzZEe8QtZa+ty1xqQdfioRfamxMcqMat6
         4jASQFm89JHBtppL3vvJUFh35gj70+OwWQzwbPVbRHW5GkfWK0e3sMxj+ypauQ/ZPqgW
         2dBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733222264; x=1733827064;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h2InjsufEFntOTn6gngou7a+5/1DcqO5mqDCh0ChGiQ=;
        b=hYjTp/Nsfn05Jgh/TdHjND7K/WS9UtRsdoZ5E5hcYFlxRJS/ohTwEo/AuedXxShtx/
         WnfsN47TjZresKuDyzV3Wgp7oqeiQuVzZVu5heaiXmoNrl3jhp2CdExPBwZO/YELK7GU
         ut7iouiJ8kAG+LS3rfn008+Xc3vYqgQ8IAyDy1rrYZ6qiW5HK5qys7ecsYlnG60GWaRO
         0x4aS4g4r1NIodU9MENBi40LAtmohP5psFNWwFA3NynQB64ODw+OeM7BLwcjUu4duEbg
         coeRloT/IksQyxutAdIcl7JVkxJFbM/PGfflwiw9QzX8htYB+hT1Xw2yn62QkBZEuvzl
         ASGA==
X-Forwarded-Encrypted: i=1; AJvYcCV8ZBB1r3dCIuAssyZwIN1Uzq6dC1tDek23fu4ytTQ19q0lQ7GovnPmuKv/HdSjxhDOuzyZKWg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxoJsl3i0p6tHGpiAx0hLcgr/2zbqcekiAUhzv++RnLQ2Gfof2/
	XKhpmFSETKBFEQr7xcUwBgdKp6asHF+30negUTIVARCrcxSAdt4BCkpY0x+eEU25lk9b5ObgY6N
	nG/trrw==
X-Google-Smtp-Source: AGHT+IHSSZV41AorJLfo/1p2l1Qb/DDlm6YrY9d8yFrAzAEDYWvvckpC9yFrYjhtgszoT38Flr2x4P1q4kIY
X-Received: from edty16.prod.google.com ([2002:aa7:ccd0:0:b0:5d0:adc6:6843])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:274d:b0:5d0:e73c:b7f0
 with SMTP id 4fb4d7f45d1cf-5d10cb99c5dmr1943009a12.28.1733222263766; Tue, 03
 Dec 2024 02:37:43 -0800 (PST)
Date: Tue,  3 Dec 2024 10:37:20 +0000
In-Reply-To: <20241203103735.2267589-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241203103735.2267589-4-qperret@google.com>
Subject: [PATCH v2 03/18] KVM: arm64: Make hyp_page::order a u8
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
index 6dfeb000371c..88cb8ff9e769 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -42,8 +42,9 @@ static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
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
2.47.0.338.g60cca15819-goog

