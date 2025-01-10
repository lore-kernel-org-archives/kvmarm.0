Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF42F20CCD3
	for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 12:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736511586; cv=none; b=fTweXA8sCjf4oqsv4cK1DXxWqRxv+3I/0668njwAK404uaKlWw5BM1pmAJLlmtY6QlGRfVzAiTjnJYHTH29PqzEOiSpq19Rom+/NaaIZdMkTno2geWaFZRKqaRpQI2rF1CIycgtwM41VGJIkCLjjJjis53HxiiiU20xrOZagNOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736511586; c=relaxed/simple;
	bh=/AjbB0D8HuuFdMAeKr6pg4VmJFXo7KL4Z/FwiFTmWv8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YXn98BPcRnZ95FgziuOHkD/9T1dCkszFN5NZybPJYOUb/kizSPVFs2TuSbbMuA/4fde75zMs6VjXzFKJZubhGVTDo20hs1WW5yVpu3MU1btgET/pRrKywQD8GZDnq3ATHcMN6IYV/Eu5HpEidlKlOTvHlUNzxYRytF6sNkq2yxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g6tApkgF; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g6tApkgF"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5d821f9730aso2938828a12.1
        for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 04:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736511583; x=1737116383; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6ANa3bcMCpVaj0ud2ZO7rs6yyZikjf0Zmx2b5NDAqdI=;
        b=g6tApkgFwKOHp0XdSKyYj+e13b4AGjajgkEFsK8ATf8QfaPpGonlD56cfWpdtODC7H
         zAk9qsmEgKN6Pt4JUKM1F49cI16zOOlmmYBaTX0ykcJOuD3pp9n4Cy4SLSfwN2LYza36
         sQoVQsJualqQ4V/b68wY96n0C8HHb8S+POnYGxF95S6nBiFXWOC+UBbpcLt0MnXp3MzL
         QIapEFJXr8M6k01ZyxI4W8r370+5UZdYlNCCn8pJaYPhs9qLwh/YoF0vVvyyHQ00YNtQ
         E1OCnRPIoxe7ixpAWK3gl3BmKrEx3INSst/U56iR+STxSdrxjpgu5v1AdX4kGzcDN2Ba
         nhgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736511583; x=1737116383;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ANa3bcMCpVaj0ud2ZO7rs6yyZikjf0Zmx2b5NDAqdI=;
        b=SeHnHNAlvW5S+W2WTI+squDjiguez/SL+ArF52zMHUl6nKjOTUChlUvIVSNEDkc/4f
         uoxZ7FUMHCGH+lunuBG2df0nd03ZkIf1AP6xdnNJO1Uo2RlW0Xgg2cI4RH0Xh8Du3XnF
         EPQvcf0zwhD016uTUiBoD+YBznB+NqPZrJbIHPkjl+23dWbNFxEiUUYc8p1mzI5kxUbB
         pycSmQpN9w4hgzYSVm5cvHRo+42p9jQoJI+5i7rSwTdYqXCvDa8ich3VMeXOSZNcBFst
         7gXZbyCaJ3alUxLrLozRRXL8U/lX1w0K3L6RW0VNV2dgOlYMMgNLjtY9eL9ipNs73Bwu
         RG1g==
X-Forwarded-Encrypted: i=1; AJvYcCV++eIH4NH4rVqfbOUuhh/o1O/4dXkHMaVns1r/AifinIJSvL1gK4BTN1k0s/WwxblzoAg9soc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yylxu87lAPPWKCDoMGgQ7UePg6zsOErix+timYmPssaFDMl8Hd0
	gSUBzDaPo6X+bSyjXrpMJnhaqSb8P7U5CLXGju+/Pt0CfMf5W7xVdmBiTSh9YiP5EWiW8+VrmCe
	6R/WM7Q==
X-Google-Smtp-Source: AGHT+IEvkER4iwk0Rq80V2KJQRuC2I1AmaqZpwtSs7vKSCi0Z91CiB52u56N8FwCQ2DalePfEMorN0DwawR+
X-Received: from edqo13.prod.google.com ([2002:aa7:c50d:0:b0:5d9:87fb:9141])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:3585:b0:5d0:d845:2882
 with SMTP id 4fb4d7f45d1cf-5d98a50c432mr4752723a12.13.1736511583251; Fri, 10
 Jan 2025 04:19:43 -0800 (PST)
Date: Fri, 10 Jan 2025 12:19:35 +0000
In-Reply-To: <20250110121936.1559655-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250110121936.1559655-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250110121936.1559655-3-qperret@google.com>
Subject: [PATCH 2/3] KVM: arm64: Drop pkvm_mem_transition for host/hyp sharing
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Simplify the __pkvm_host_{un}share_hyp() paths by not using the
pkvm_mem_transition machinery. As there are the last users of the
do_share()/do_unshare(), remove all the now-unused code as well.

No functional changes intended.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 319 +++-----------------------
 1 file changed, 34 insertions(+), 285 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 3a3d9fcbc508..cd8d233b9527 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -685,36 +685,6 @@ static int host_request_owned_transition(u64 *completer_addr,
 	return __host_check_page_state_range(addr, size, PKVM_PAGE_OWNED);
 }
 
-static int host_request_unshare(u64 *completer_addr,
-				const struct pkvm_mem_transition *tx)
-{
-	u64 size = tx->nr_pages * PAGE_SIZE;
-	u64 addr = tx->initiator.addr;
-
-	*completer_addr = tx->initiator.host.completer_addr;
-	return __host_check_page_state_range(addr, size, PKVM_PAGE_SHARED_OWNED);
-}
-
-static int host_initiate_share(u64 *completer_addr,
-			       const struct pkvm_mem_transition *tx)
-{
-	u64 size = tx->nr_pages * PAGE_SIZE;
-	u64 addr = tx->initiator.addr;
-
-	*completer_addr = tx->initiator.host.completer_addr;
-	return __host_set_page_state_range(addr, size, PKVM_PAGE_SHARED_OWNED);
-}
-
-static int host_initiate_unshare(u64 *completer_addr,
-				 const struct pkvm_mem_transition *tx)
-{
-	u64 size = tx->nr_pages * PAGE_SIZE;
-	u64 addr = tx->initiator.addr;
-
-	*completer_addr = tx->initiator.host.completer_addr;
-	return __host_set_page_state_range(addr, size, PKVM_PAGE_OWNED);
-}
-
 static int host_initiate_donation(u64 *completer_addr,
 				  const struct pkvm_mem_transition *tx)
 {
@@ -802,31 +772,6 @@ static bool __hyp_ack_skip_pgtable_check(const struct pkvm_mem_transition *tx)
 		 tx->initiator.id != PKVM_ID_HOST);
 }
 
-static int hyp_ack_share(u64 addr, const struct pkvm_mem_transition *tx,
-			 enum kvm_pgtable_prot perms)
-{
-	u64 size = tx->nr_pages * PAGE_SIZE;
-
-	if (perms != PAGE_HYP)
-		return -EPERM;
-
-	if (__hyp_ack_skip_pgtable_check(tx))
-		return 0;
-
-	return __hyp_check_page_state_range(addr, size, PKVM_NOPAGE);
-}
-
-static int hyp_ack_unshare(u64 addr, const struct pkvm_mem_transition *tx)
-{
-	u64 size = tx->nr_pages * PAGE_SIZE;
-
-	if (tx->initiator.id == PKVM_ID_HOST && hyp_page_count((void *)addr))
-		return -EBUSY;
-
-	return __hyp_check_page_state_range(addr, size,
-					    PKVM_PAGE_SHARED_BORROWED);
-}
-
 static int hyp_ack_donation(u64 addr, const struct pkvm_mem_transition *tx)
 {
 	u64 size = tx->nr_pages * PAGE_SIZE;
@@ -837,24 +782,6 @@ static int hyp_ack_donation(u64 addr, const struct pkvm_mem_transition *tx)
 	return __hyp_check_page_state_range(addr, size, PKVM_NOPAGE);
 }
 
-static int hyp_complete_share(u64 addr, const struct pkvm_mem_transition *tx,
-			      enum kvm_pgtable_prot perms)
-{
-	void *start = (void *)addr, *end = start + (tx->nr_pages * PAGE_SIZE);
-	enum kvm_pgtable_prot prot;
-
-	prot = pkvm_mkstate(perms, PKVM_PAGE_SHARED_BORROWED);
-	return pkvm_create_mappings_locked(start, end, prot);
-}
-
-static int hyp_complete_unshare(u64 addr, const struct pkvm_mem_transition *tx)
-{
-	u64 size = tx->nr_pages * PAGE_SIZE;
-	int ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, addr, size);
-
-	return (ret != size) ? -EFAULT : 0;
-}
-
 static int hyp_complete_donation(u64 addr,
 				 const struct pkvm_mem_transition *tx)
 {
@@ -885,180 +812,6 @@ static int __guest_check_page_state_range(struct pkvm_hyp_vcpu *vcpu, u64 addr,
 	return check_page_state_range(&vm->pgt, addr, size, &d);
 }
 
-static int check_share(struct pkvm_mem_share *share)
-{
-	const struct pkvm_mem_transition *tx = &share->tx;
-	u64 completer_addr;
-	int ret;
-
-	switch (tx->initiator.id) {
-	case PKVM_ID_HOST:
-		ret = host_request_owned_transition(&completer_addr, tx);
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	if (ret)
-		return ret;
-
-	switch (tx->completer.id) {
-	case PKVM_ID_HYP:
-		ret = hyp_ack_share(completer_addr, tx, share->completer_prot);
-		break;
-	case PKVM_ID_FFA:
-		/*
-		 * We only check the host; the secure side will check the other
-		 * end when we forward the FFA call.
-		 */
-		ret = 0;
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
-
-static int __do_share(struct pkvm_mem_share *share)
-{
-	const struct pkvm_mem_transition *tx = &share->tx;
-	u64 completer_addr;
-	int ret;
-
-	switch (tx->initiator.id) {
-	case PKVM_ID_HOST:
-		ret = host_initiate_share(&completer_addr, tx);
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	if (ret)
-		return ret;
-
-	switch (tx->completer.id) {
-	case PKVM_ID_HYP:
-		ret = hyp_complete_share(completer_addr, tx, share->completer_prot);
-		break;
-	case PKVM_ID_FFA:
-		/*
-		 * We're not responsible for any secure page-tables, so there's
-		 * nothing to do here.
-		 */
-		ret = 0;
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
-
-/*
- * do_share():
- *
- * The page owner grants access to another component with a given set
- * of permissions.
- *
- * Initiator: OWNED	=> SHARED_OWNED
- * Completer: NOPAGE	=> SHARED_BORROWED
- */
-static int do_share(struct pkvm_mem_share *share)
-{
-	int ret;
-
-	ret = check_share(share);
-	if (ret)
-		return ret;
-
-	return WARN_ON(__do_share(share));
-}
-
-static int check_unshare(struct pkvm_mem_share *share)
-{
-	const struct pkvm_mem_transition *tx = &share->tx;
-	u64 completer_addr;
-	int ret;
-
-	switch (tx->initiator.id) {
-	case PKVM_ID_HOST:
-		ret = host_request_unshare(&completer_addr, tx);
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	if (ret)
-		return ret;
-
-	switch (tx->completer.id) {
-	case PKVM_ID_HYP:
-		ret = hyp_ack_unshare(completer_addr, tx);
-		break;
-	case PKVM_ID_FFA:
-		/* See check_share() */
-		ret = 0;
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
-
-static int __do_unshare(struct pkvm_mem_share *share)
-{
-	const struct pkvm_mem_transition *tx = &share->tx;
-	u64 completer_addr;
-	int ret;
-
-	switch (tx->initiator.id) {
-	case PKVM_ID_HOST:
-		ret = host_initiate_unshare(&completer_addr, tx);
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	if (ret)
-		return ret;
-
-	switch (tx->completer.id) {
-	case PKVM_ID_HYP:
-		ret = hyp_complete_unshare(completer_addr, tx);
-		break;
-	case PKVM_ID_FFA:
-		/* See __do_share() */
-		ret = 0;
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
-
-/*
- * do_unshare():
- *
- * The page owner revokes access from another component for a range of
- * pages which were previously shared using do_share().
- *
- * Initiator: SHARED_OWNED	=> OWNED
- * Completer: SHARED_BORROWED	=> NOPAGE
- */
-static int do_unshare(struct pkvm_mem_share *share)
-{
-	int ret;
-
-	ret = check_unshare(share);
-	if (ret)
-		return ret;
-
-	return WARN_ON(__do_unshare(share));
-}
-
 static int check_donation(struct pkvm_mem_donation *donation)
 {
 	const struct pkvm_mem_transition *tx = &donation->tx;
@@ -1149,31 +902,29 @@ static int do_donate(struct pkvm_mem_donation *donation)
 
 int __pkvm_host_share_hyp(u64 pfn)
 {
+	u64 phys = hyp_pfn_to_phys(pfn);
+	void *virt = __hyp_va(phys);
+	enum kvm_pgtable_prot prot;
+	u64 size = PAGE_SIZE;
 	int ret;
-	u64 host_addr = hyp_pfn_to_phys(pfn);
-	u64 hyp_addr = (u64)__hyp_va(host_addr);
-	struct pkvm_mem_share share = {
-		.tx	= {
-			.nr_pages	= 1,
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
-		.completer_prot	= PAGE_HYP,
-	};
 
 	host_lock_component();
 	hyp_lock_component();
 
-	ret = do_share(&share);
+	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_OWNED);
+	if (ret)
+		goto unlock;
+	if (IS_ENABLED(CONFIG_NVHE_EL2_DEBUG)) {
+		ret = __hyp_check_page_state_range((u64)virt, size, PKVM_NOPAGE);
+		if (ret)
+			goto unlock;
+	}
+
+	prot = pkvm_mkstate(PAGE_HYP, PKVM_PAGE_SHARED_BORROWED);
+	WARN_ON(pkvm_create_mappings_locked(virt, virt + size, prot));
+	WARN_ON(__host_set_page_state_range(phys, size, PKVM_PAGE_SHARED_OWNED));
 
+unlock:
 	hyp_unlock_component();
 	host_unlock_component();
 
@@ -1182,31 +933,29 @@ int __pkvm_host_share_hyp(u64 pfn)
 
 int __pkvm_host_unshare_hyp(u64 pfn)
 {
+	u64 phys = hyp_pfn_to_phys(pfn);
+	u64 virt = (u64)__hyp_va(phys);
+	u64 size = PAGE_SIZE;
 	int ret;
-	u64 host_addr = hyp_pfn_to_phys(pfn);
-	u64 hyp_addr = (u64)__hyp_va(host_addr);
-	struct pkvm_mem_share share = {
-		.tx	= {
-			.nr_pages	= 1,
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
-		.completer_prot	= PAGE_HYP,
-	};
 
 	host_lock_component();
 	hyp_lock_component();
 
-	ret = do_unshare(&share);
+	ret = __host_check_page_state_range(phys, size, PKVM_PAGE_SHARED_OWNED);
+	if (ret)
+		goto unlock;
+	ret = __hyp_check_page_state_range(virt, size, PKVM_PAGE_SHARED_BORROWED);
+	if (ret)
+		goto unlock;
+	if (hyp_page_count((void *)virt)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, virt, size) != size);
+	WARN_ON(__host_set_page_state_range(phys, size, PKVM_PAGE_OWNED));
 
+unlock:
 	hyp_unlock_component();
 	host_unlock_component();
 
-- 
2.47.1.688.g23fc6f90ad-goog

