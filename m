Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A0420CCF2
	for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 12:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736511588; cv=none; b=owL8zEgJR+T833p0q9EhoQg4TN4pqmnPoI9AtdmR5SpHaqQ8N+jRSJzpRHKZWGrB2uBriC3zDapWqbMNXCbSYgQIxNFHqQymTd9gCIVfEd1D/nK1ikpbL2KZMmDuru2qsmXJIfM3mFr4Qd6hvdMEvPhJtzQzF8lRzitWD0c+U9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736511588; c=relaxed/simple;
	bh=v5G/dSfVM12wKYwjPHRTDyoRRr7YsWw3VmmY/1u93as=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BcNAWEqqy8Cxx+9bclCc0QNOdaaGbLvbLuQ3dwx2EhAXCXCiUWsThB7cqypixv9LVYL+vU5nNV5TWcN1qYJ2tg5x0wntDLEs3/S/Q4R44nM8RKbXK2rEXGAFlDad3vsn+jDQnWRyl3u06JCiKL04ohcXJaPS+zZ1kwrk05Hi2AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kNpHzvT3; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kNpHzvT3"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5d3ec94ccbdso2217830a12.0
        for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 04:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736511585; x=1737116385; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DtU04MdUtaba/29cBZEvCyfcbZiq9/Rr2f3d3RSXEMM=;
        b=kNpHzvT3F4rm0tj7aJZgYjE1R5Y5Ys55Vbu/13Zp+r7h5/VHiKJrmtCs79vnikQNIV
         NbTxeYC/yNns5xNS2DGDc9mqjS1LEgN/Eebic6p6dPJL+imfHN9KWBWlUJTygtHX+qKu
         gsmUNrvGZHDFhKHbcQNnf8I5VfCEW7DdlJ1F++YDrulUFlwcp5eKd1xBoPsleqvGxsfv
         J31IpiiEHD25mNVJ3eLO5P9qHnTdGq4NN2jAnhZDFq4wD+t9qyveuCASftcw7epMRDAq
         vNaij5gRnSAfIqr1Se5pOz7bLlNHSM7722xJMh2WqwFmm5VthWqPqKd5I2gRbD6nbcHS
         GafQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736511585; x=1737116385;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DtU04MdUtaba/29cBZEvCyfcbZiq9/Rr2f3d3RSXEMM=;
        b=rkQG69aqZlEPjcUW9zZmOfj0kRU5fi5Cg9pzKQbYie3SRmz/mhsW2pDINRrqD8/fQC
         s+K2nOdC6I/fidoNwVua80IvPjFKmHonLq48LuEfM3uC9tOaxiDtMLJBnJDC5vW1Qo8V
         MLCSaqwWDpwJWq094C9U7kWKyQXeufqQbfWvlYP54iZgWdmz078HvowYYGuloVJw5yye
         /dXKT/5NZkZLxRzdJy/UGOLabylOjvdhISzI4K86+q7tIyjr84pGCRPwRVjxi6Q76LdH
         Rz+FOLWkDD3WLrgrrM6d794AJbpktZ2FCopfFmrIjQzU3RXRJhrWyp5yx85xNfjp54Sz
         wCqA==
X-Forwarded-Encrypted: i=1; AJvYcCX9QHu47Jz35eBNP+u4O5zE/j5Ug5qrgvGM8AjXyHWWlnXCHDCjXToC5gQ9NEoo7LuXDZTzaDU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzN4UrXCPZCx8jClMTB9ustPI7YUHK9XFkN7RccAnL3ghYUfsDl
	PBZ3J4i3t2KoQYG6GXQ+8t1OXqO9KA5FT3ykRwnSKNNSOv0UYF1zTbnPDxQ0UFMe/RlMvKzM7PZ
	pVtXhTA==
X-Google-Smtp-Source: AGHT+IE8pwm0WuzijwFJnnfkKAp3whvfOVqnR4Hnv/2il6Ym21FdKGzx1FIDYLM5L/rv1DqQUki8rJPPSNQ3
X-Received: from edbeh15.prod.google.com ([2002:a05:6402:f8f:b0:5d9:103a:855d])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:254d:b0:5d0:81dc:f20e
 with SMTP id 4fb4d7f45d1cf-5d972e1c5cfmr9641811a12.17.1736511585431; Fri, 10
 Jan 2025 04:19:45 -0800 (PST)
Date: Fri, 10 Jan 2025 12:19:36 +0000
In-Reply-To: <20250110121936.1559655-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250110121936.1559655-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250110121936.1559655-4-qperret@google.com>
Subject: [PATCH 3/3] KVM: arm64: Drop pkvm_mem_transition for host/hyp donations
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Simplify the __pkvm_host_donate_hyp() and pkvm_hyp_donate_host() paths
by not using the pkvm_mem_transition machinery. As the last users of
this, also remove all the now unused code.

No functional changes intended.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 285 +++-----------------------
 1 file changed, 32 insertions(+), 253 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index cd8d233b9527..7ad7b133b81a 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -583,39 +583,6 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 	BUG_ON(ret && ret != -EAGAIN);
 }
 
-struct pkvm_mem_transition {
-	u64				nr_pages;
-
-	struct {
-		enum pkvm_component_id	id;
-		/* Address in the initiator's address space */
-		u64			addr;
-
-		union {
-			struct {
-				/* Address in the completer's address space */
-				u64	completer_addr;
-			} host;
-			struct {
-				u64	completer_addr;
-			} hyp;
-		};
-	} initiator;
-
-	struct {
-		enum pkvm_component_id	id;
-	} completer;
-};
-
-struct pkvm_mem_share {
-	const struct pkvm_mem_transition	tx;
-	const enum kvm_pgtable_prot		completer_prot;
-};
-
-struct pkvm_mem_donation {
-	const struct pkvm_mem_transition	tx;
-};
-
 struct check_walk_data {
 	enum pkvm_page_state	desired;
 	enum pkvm_page_state	(*get_page_state)(kvm_pte_t pte, u64 addr);
@@ -675,56 +642,6 @@ static int __host_set_page_state_range(u64 addr, u64 size,
 	return 0;
 }
 
-static int host_request_owned_transition(u64 *completer_addr,
-					 const struct pkvm_mem_transition *tx)
-{
-	u64 size = tx->nr_pages * PAGE_SIZE;
-	u64 addr = tx->initiator.addr;
-
-	*completer_addr = tx->initiator.host.completer_addr;
-	return __host_check_page_state_range(addr, size, PKVM_PAGE_OWNED);
-}
-
-static int host_initiate_donation(u64 *completer_addr,
-				  const struct pkvm_mem_transition *tx)
-{
-	u8 owner_id = tx->completer.id;
-	u64 size = tx->nr_pages * PAGE_SIZE;
-
-	*completer_addr = tx->initiator.host.completer_addr;
-	return host_stage2_set_owner_locked(tx->initiator.addr, size, owner_id);
-}
-
-static bool __host_ack_skip_pgtable_check(const struct pkvm_mem_transition *tx)
-{
-	return !(IS_ENABLED(CONFIG_NVHE_EL2_DEBUG) ||
-		 tx->initiator.id != PKVM_ID_HYP);
-}
-
-static int __host_ack_transition(u64 addr, const struct pkvm_mem_transition *tx,
-				 enum pkvm_page_state state)
-{
-	u64 size = tx->nr_pages * PAGE_SIZE;
-
-	if (__host_ack_skip_pgtable_check(tx))
-		return 0;
-
-	return __host_check_page_state_range(addr, size, state);
-}
-
-static int host_ack_donation(u64 addr, const struct pkvm_mem_transition *tx)
-{
-	return __host_ack_transition(addr, tx, PKVM_NOPAGE);
-}
-
-static int host_complete_donation(u64 addr, const struct pkvm_mem_transition *tx)
-{
-	u64 size = tx->nr_pages * PAGE_SIZE;
-	u8 host_id = tx->completer.id;
-
-	return host_stage2_set_owner_locked(addr, size, host_id);
-}
-
 static enum pkvm_page_state hyp_get_page_state(kvm_pte_t pte, u64 addr)
 {
 	if (!kvm_pte_valid(pte))
@@ -745,52 +662,6 @@ static int __hyp_check_page_state_range(u64 addr, u64 size,
 	return check_page_state_range(&pkvm_pgtable, addr, size, &d);
 }
 
-static int hyp_request_donation(u64 *completer_addr,
-				const struct pkvm_mem_transition *tx)
-{
-	u64 size = tx->nr_pages * PAGE_SIZE;
-	u64 addr = tx->initiator.addr;
-
-	*completer_addr = tx->initiator.hyp.completer_addr;
-	return __hyp_check_page_state_range(addr, size, PKVM_PAGE_OWNED);
-}
-
-static int hyp_initiate_donation(u64 *completer_addr,
-				 const struct pkvm_mem_transition *tx)
-{
-	u64 size = tx->nr_pages * PAGE_SIZE;
-	int ret;
-
-	*completer_addr = tx->initiator.hyp.completer_addr;
-	ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, tx->initiator.addr, size);
-	return (ret != size) ? -EFAULT : 0;
-}
-
-static bool __hyp_ack_skip_pgtable_check(const struct pkvm_mem_transition *tx)
-{
-	return !(IS_ENABLED(CONFIG_NVHE_EL2_DEBUG) ||
-		 tx->initiator.id != PKVM_ID_HOST);
-}
-
-static int hyp_ack_donation(u64 addr, const struct pkvm_mem_transition *tx)
-{
-	u64 size = tx->nr_pages * PAGE_SIZE;
-
-	if (__hyp_ack_skip_pgtable_check(tx))
-		return 0;
-
-	return __hyp_check_page_state_range(addr, size, PKVM_NOPAGE);
-}
-
-static int hyp_complete_donation(u64 addr,
-				 const struct pkvm_mem_transition *tx)
-{
-	void *start = (void *)addr, *end = start + (tx->nr_pages * PAGE_SIZE);
-	enum kvm_pgtable_prot prot = pkvm_mkstate(PAGE_HYP, PKVM_PAGE_OWNED);
-
-	return pkvm_create_mappings_locked(start, end, prot);
-}
-
 static enum pkvm_page_state guest_get_page_state(kvm_pte_t pte, u64 addr)
 {
 	if (!kvm_pte_valid(pte))
@@ -812,94 +683,6 @@ static int __guest_check_page_state_range(struct pkvm_hyp_vcpu *vcpu, u64 addr,
 	return check_page_state_range(&vm->pgt, addr, size, &d);
 }
 
-static int check_donation(struct pkvm_mem_donation *donation)
-{
-	const struct pkvm_mem_transition *tx = &donation->tx;
-	u64 completer_addr;
-	int ret;
-
-	switch (tx->initiator.id) {
-	case PKVM_ID_HOST:
-		ret = host_request_owned_transition(&completer_addr, tx);
-		break;
-	case PKVM_ID_HYP:
-		ret = hyp_request_donation(&completer_addr, tx);
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	if (ret)
-		return ret;
-
-	switch (tx->completer.id) {
-	case PKVM_ID_HOST:
-		ret = host_ack_donation(completer_addr, tx);
-		break;
-	case PKVM_ID_HYP:
-		ret = hyp_ack_donation(completer_addr, tx);
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
-
-static int __do_donate(struct pkvm_mem_donation *donation)
-{
-	const struct pkvm_mem_transition *tx = &donation->tx;
-	u64 completer_addr;
-	int ret;
-
-	switch (tx->initiator.id) {
-	case PKVM_ID_HOST:
-		ret = host_initiate_donation(&completer_addr, tx);
-		break;
-	case PKVM_ID_HYP:
-		ret = hyp_initiate_donation(&completer_addr, tx);
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	if (ret)
-		return ret;
-
-	switch (tx->completer.id) {
-	case PKVM_ID_HOST:
-		ret = host_complete_donation(completer_addr, tx);
-		break;
-	case PKVM_ID_HYP:
-		ret = hyp_complete_donation(completer_addr, tx);
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
-
-/*
- * do_donate():
- *
- * The page owner transfers ownership to another component, losing access
- * as a consequence.
- *
- * Initiator: OWNED	=> NOPAGE
- * Completer: NOPAGE	=> OWNED
- */
-static int do_donate(struct pkvm_mem_donation *donation)
-{
-	int ret;
-
-	ret = check_donation(donation);
-	if (ret)
-		return ret;
-
-	return WARN_ON(__do_donate(donation));
-}
-
 int __pkvm_host_share_hyp(u64 pfn)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
@@ -964,30 +747,29 @@ int __pkvm_host_unshare_hyp(u64 pfn)
 
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
 {
+	u64 phys = hyp_pfn_to_phys(pfn);
+	u64 size = PAGE_SIZE * nr_pages;
+	void *virt = __hyp_va(phys);
+	enum kvm_pgtable_prot prot;
 	int ret;
-	u64 host_addr = hyp_pfn_to_phys(pfn);
-	u64 hyp_addr = (u64)__hyp_va(host_addr);
-	struct pkvm_mem_donation donation = {
-		.tx	= {
-			.nr_pages	= nr_pages,
-			.initiator	= {
-				.id	= PKVM_ID_HOST,
-				.addr	= host_addr,
-				.host	= {
-					.completer_addr = hyp_addr,
-				},
-			},
-			.completer	= {
-				.id	= PKVM_ID_HYP,
-			},
-		},
-	};
 
 	host_lock_component();
 	hyp_lock_component();
 
-	ret = do_donate(&donation);
+	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_OWNED);
+	if (ret)
+		goto unlock;
+	if (IS_ENABLED(CONFIG_NVHE_EL2_DEBUG)) {
+		ret = __hyp_check_page_state_range((u64)virt, size, PKVM_NOPAGE);
+		if (ret)
+			goto unlock;
+	}
 
+	prot = pkvm_mkstate(PAGE_HYP, PKVM_PAGE_OWNED);
+	WARN_ON(pkvm_create_mappings_locked(virt, virt + size, prot));
+	WARN_ON(host_stage2_set_owner_locked(phys, size, PKVM_ID_HYP));
+
+unlock:
 	hyp_unlock_component();
 	host_unlock_component();
 
@@ -996,30 +778,27 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
 
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 {
+	u64 phys = hyp_pfn_to_phys(pfn);
+	u64 size = PAGE_SIZE * nr_pages;
+	u64 virt = (u64)__hyp_va(phys);
 	int ret;
-	u64 host_addr = hyp_pfn_to_phys(pfn);
-	u64 hyp_addr = (u64)__hyp_va(host_addr);
-	struct pkvm_mem_donation donation = {
-		.tx	= {
-			.nr_pages	= nr_pages,
-			.initiator	= {
-				.id	= PKVM_ID_HYP,
-				.addr	= hyp_addr,
-				.hyp	= {
-					.completer_addr = host_addr,
-				},
-			},
-			.completer	= {
-				.id	= PKVM_ID_HOST,
-			},
-		},
-	};
 
 	host_lock_component();
 	hyp_lock_component();
 
-	ret = do_donate(&donation);
+	ret = __hyp_check_page_state_range(virt, size, PKVM_PAGE_OWNED);
+	if (ret)
+		goto unlock;
+	if (IS_ENABLED(CONFIG_NVHE_EL2_DEBUG)) {
+		ret = __host_check_page_state_range(phys, size, PKVM_NOPAGE);
+		if (ret)
+			goto unlock;
+	}
 
+	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, virt, size) != size);
+	WARN_ON(host_stage2_set_owner_locked(phys, size, PKVM_ID_HOST));
+
+unlock:
 	hyp_unlock_component();
 	host_unlock_component();
 
-- 
2.47.1.688.g23fc6f90ad-goog

