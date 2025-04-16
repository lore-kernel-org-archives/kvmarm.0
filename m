Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B362101AF
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 15:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744817223; cv=none; b=S+xFRjcWvg3UoOoh93Cy/qGvIAWCrootRBuLEwLWonGwIvaEkcEcNojRTPZqPMKy5X9hytPh8XVrIZp3tSAT/4Aj81m66PjAV4DujNNzdyzlNWGg5d1rgISqkmQALPpBrrGhg+WnDgnQ/Q8l3RAHW+H//5x/h8+UsHFlTAXpbk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744817223; c=relaxed/simple;
	bh=J9Yf6lxkoaWGjJfgEDe4MZh/KA3qtVyYK53UWzW0zEg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n0gJYXtOc9FNmjMqVeVCHohXe36E4TBpEdI+ui13SSqBRQyUfpXQtNLO+WpEdCZiCY6PJRhS+98kosMq+QrzycsNnqKN+OZajagoITA0QOg9aMuAOAWtLBi3SQGwYdWHRfQOskIItL2WVsZ7YCqF0vFDToZYlLCf+Ig9ydT3MSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OVDe1Yl5; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OVDe1Yl5"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-ac6caf952d7so672621266b.3
        for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 08:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744817220; x=1745422020; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UXTqFvc4opPwLmL9HAQrXX66kUt2kBii3Ie6HubIYaY=;
        b=OVDe1Yl52AT1TY7fnphM+S/l4EVp+J+QzU341c3V3q858wy1GfPClAyTmJA0HhSPAt
         dXVbkJIF8PawwKyBKAo3yAgz8klO0oegbrhbTN4gX5TpevFaghKmyMrraD3OvU2q+wNX
         MHVcEZRpu57fUUA5j6mMc3LjiOusx5ju+wa5rtHWlShk0us39KmOiNMelbsoEpFqbjD4
         5nWApfZDySZkj+nO6pwO7xxghZEeKpz7vV3q2pD+Xa5uD7kzHzEMeXtq2htlV34CVAaX
         CKIfgRYz5WxS9V6x7QTmqhe44N+giKPa+0hpJUwUiCgtxxK5BWbw6v6A45siTwLfI5KT
         //eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744817220; x=1745422020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UXTqFvc4opPwLmL9HAQrXX66kUt2kBii3Ie6HubIYaY=;
        b=EAa7utflK6jKBBKZbdOcaYmamxfZa15TAfV3GtGpuqpgFByVSR1pxj9bK9nOfwXSsk
         NHmRej4AFkL7vhjrv4YAGUhVtbCARacAVXB1kLTMcvHcrb1HtWVJOX8jJoOM89YPNTkO
         p1YPq6OGUH6KmM/EIfMse0kqfF1Q+1kSPWrXF1s4DC+1ZCWdqWelKBLT/RjnxuOWdE2u
         HKWxHE5diFxI+iuuV+xD7lYBardquOB/JkcM2TkwHlYyW7L3SgtOz4Ww7zpLAvOkrJc1
         NxdzJZCn+Yix4ZB7izmKJioW+0LnDq4t26gfFCBzD/Yj8gd4q8LUw+8HT3sATy4hNGtQ
         CMcw==
X-Forwarded-Encrypted: i=1; AJvYcCXbIl7jsQIQAOqFNeFYj5uKcQxv1AYEqqzo8vIQrbv+u0Q31swxAmWV+SddSpBFL8ulEkcPGN8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yya0U+2i6Cg3FJLj+7zUhcbkT5wVoKM3lny9pPvFgCum2z54B/J
	yEONq8AwlfSCGZ6qvuGk+8lOq63I+bYNc0aA/9G85/JdGiBBNPKlD7BmyxZJf7RwiuPX+7PM2dJ
	U3EwJdQ==
X-Google-Smtp-Source: AGHT+IEu+nQt3ZvaltJ8ile4BL4Mx8RMjIE5u1QNIcuD+qDhprPfJ5PQQJQVdc2cu/l2DfDtzKgEXuEQXODM
X-Received: from edod3.prod.google.com ([2002:a50:ea83:0:b0:5ec:289d:754b])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:9408:b0:abf:6ec7:65e9
 with SMTP id a640c23a62f3a-acb42b6cbddmr211529666b.43.1744817220022; Wed, 16
 Apr 2025 08:27:00 -0700 (PDT)
Date: Wed, 16 Apr 2025 15:26:44 +0000
In-Reply-To: <20250416152648.2982950-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250416152648.2982950-1-qperret@google.com>
X-Mailer: git-send-email 2.49.0.604.gff1f9ca942-goog
Message-ID: <20250416152648.2982950-5-qperret@google.com>
Subject: [PATCH v2 4/7] KVM: arm64: Introduce {get,set}_host_state() helpers
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <tabba@google.com>, 
	Quentin Perret <qperret@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Instead of directly accessing the host_state member in struct hyp_page,
introduce static inline accessors to do it. The future hyp_state member
will follow the same pattern as it will need some logic in the accessors.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/memory.h | 12 +++++++++++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c    | 14 +++++++-------
 arch/arm64/kvm/hyp/nvhe/setup.c          |  4 ++--
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index bf28f9f9de65..a1754aecf8f8 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -52,7 +52,7 @@ struct hyp_page {
 	u8 order;
 
 	/* Host state. Guarded by the host stage-2 lock. */
-	enum pkvm_page_state host_state : 8;
+	unsigned __host_state : 8;
 
 	u32 host_share_guest_count;
 };
@@ -89,6 +89,16 @@ static inline struct hyp_page *hyp_phys_to_page(phys_addr_t phys)
 #define hyp_page_to_virt(page)	__hyp_va(hyp_page_to_phys(page))
 #define hyp_page_to_pool(page)	(((struct hyp_page *)page)->pool)
 
+static inline enum pkvm_page_state get_host_state(phys_addr_t phys)
+{
+	return (enum pkvm_page_state)hyp_phys_to_page(phys)->__host_state;
+}
+
+static inline void set_host_state(phys_addr_t phys, enum pkvm_page_state state)
+{
+	hyp_phys_to_page(phys)->__host_state = state;
+}
+
 /*
  * Refcounting for 'struct hyp_page'.
  * hyp_pool::lock must be held if atomic access to the refcount is required.
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2a5284f749b4..e9060e6205cb 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -467,7 +467,7 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 		return -EAGAIN;
 
 	if (pte) {
-		WARN_ON(addr_is_memory(addr) && hyp_phys_to_page(addr)->host_state != PKVM_NOPAGE);
+		WARN_ON(addr_is_memory(addr) && get_host_state(addr) != PKVM_NOPAGE);
 		return -EPERM;
 	}
 
@@ -496,7 +496,7 @@ static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_
 	phys_addr_t end = addr + size;
 
 	for (; addr < end; addr += PAGE_SIZE)
-		hyp_phys_to_page(addr)->host_state = state;
+		set_host_state(addr, state);
 }
 
 int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
@@ -627,7 +627,7 @@ static int __host_check_page_state_range(u64 addr, u64 size,
 
 	hyp_assert_lock_held(&host_mmu.lock);
 	for (; addr < end; addr += PAGE_SIZE) {
-		if (hyp_phys_to_page(addr)->host_state != state)
+		if (get_host_state(addr) != state)
 			return -EPERM;
 	}
 
@@ -637,7 +637,7 @@ static int __host_check_page_state_range(u64 addr, u64 size,
 static int __host_set_page_state_range(u64 addr, u64 size,
 				       enum pkvm_page_state state)
 {
-	if (hyp_phys_to_page(addr)->host_state == PKVM_NOPAGE) {
+	if (get_host_state(addr) == PKVM_NOPAGE) {
 		int ret = host_stage2_idmap_locked(addr, size, PKVM_HOST_MEM_PROT);
 
 		if (ret)
@@ -911,7 +911,7 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu,
 		goto unlock;
 
 	page = hyp_phys_to_page(phys);
-	switch (page->host_state) {
+	switch (get_host_state(phys)) {
 	case PKVM_PAGE_OWNED:
 		WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_OWNED));
 		break;
@@ -964,9 +964,9 @@ static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ip
 	if (WARN_ON(ret))
 		return ret;
 
-	page = hyp_phys_to_page(phys);
-	if (page->host_state != PKVM_PAGE_SHARED_OWNED)
+	if (get_host_state(phys) != PKVM_PAGE_SHARED_OWNED)
 		return -EPERM;
+	page = hyp_phys_to_page(phys);
 	if (WARN_ON(!page->host_share_guest_count))
 		return -EINVAL;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index d62bcb5634a2..1a414288fe8c 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -201,10 +201,10 @@ static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	case PKVM_PAGE_OWNED:
 		return host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HYP);
 	case PKVM_PAGE_SHARED_OWNED:
-		hyp_phys_to_page(phys)->host_state = PKVM_PAGE_SHARED_BORROWED;
+		set_host_state(phys, PKVM_PAGE_SHARED_BORROWED);
 		break;
 	case PKVM_PAGE_SHARED_BORROWED:
-		hyp_phys_to_page(phys)->host_state = PKVM_PAGE_SHARED_OWNED;
+		set_host_state(phys, PKVM_PAGE_SHARED_OWNED);
 		break;
 	default:
 		return -EINVAL;
-- 
2.49.0.604.gff1f9ca942-goog

