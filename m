Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01CD38423B
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 08:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779351190; cv=none; b=aVG1xByfNKRqkwJpscJmOS+dj+sv9q+9nEgBfuoAjK+mgVk/Lncb/H3QeOK2xQp6vRFnJN0ENTdWGUXRi+5S3gHIVGaVwDNvnuTduMokBp55ZhgwPNYzKxvS/PlTplYKL5pZ+xApMAafYxzI0f96hh+9waD2xtTtituYzV4NjAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779351190; c=relaxed/simple;
	bh=BiG1Lhtcx9KdxCto4uzFz6eSubhFxtNmLyMawjD1cxk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H66/pMaDjpHvy3C44SND99adkYxE/bryBd+e0Z7O9eZrjJX2JP1QgMhMo1cJG5C7dCkvFqRmMj/If0WpWV/+m+ON1Dai8asrbYmAz+niZxIFwQbaFYgZdbFv6hFUPGE2Ja67Dvdq+ocmQorYnuqmECAedCxvCneoeAVlkYGw4ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qh9lFrx5; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qh9lFrx5"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-45e73a4f1dfso4100430f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 01:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779351187; x=1779955987; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v8+gJYyIyK3axLW34gTWDjC1SWf3crUEw1rSRechVWc=;
        b=Qh9lFrx5G8g7jTa0DOumF1oDpU37Knf4ebONv3NL/2H5GzIGcbbpu6VqcSFMBTOiE/
         zMTOXbZ4BMElCSQYQLlWzhx0p9yYuDZzCHoGSIH0CkikIaPi7Nh49dQiVZ/DjxdFXWdg
         23ClQouGUR2PvOwbBVZAx6NqaeJAlGIjSInZbs66l+HCmI9F067Q6s/3sHLknrRLgoOe
         PRGD2s4Ucu70OuI9mCsazPZK01FwRw8gPRo+b98/WlUbhucLppcxgflIFXJ68BiJuXXz
         bYWbsETHgyTPUg9SOaXAgBI6Lhey8d+FsMiBdlzI/ksuA4ZvYPuD50+j3YTehgI3pLj9
         Cz0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779351187; x=1779955987;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v8+gJYyIyK3axLW34gTWDjC1SWf3crUEw1rSRechVWc=;
        b=hdo8ZI54jRBZdXEKiZrniQA2UjmtIn9Dy7e3NTVLhqr7+BxFEJ6VMY96QWpepBeOiK
         WPBbVnFkweALHwiQI5YmUFTZd8O7NmWhvFWz7xFhj6P2Ym9k/B6ullISGvQa6zjOORBP
         OQLGeP9Qx65dE9aZjsOJAB1MuZBMlO150BXKFpzlVdCBt+5mfs5YI865J56HbZZ6a6tW
         JjWTjR1zSjuosJBy49Dwkr11KkVfuVeKOm8gRYg0uT1N+Jbj1kzG3b8Ts7fq5Wm8yoOZ
         5puFT+yf5r4E1vhpNutf2Id8t5tuPWt7nyUfIjIaZlzvGNTZZlrVs6mf6DcAMBIyiT1Z
         ZujA==
X-Forwarded-Encrypted: i=1; AFNElJ8kloiHYAGkhoqlI/J4nyv7c+aTLVjcCSp7igHgSelLKVEsFVO7gaYAKeWQEBHF1Vc2pbQ8u7c=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQH7ndbhX5epGHOhbLNSjenM7FFmSGXwm3et/CwN4xL1p2Xs0s
	kjO85FHcMH+CFPdG2oGDaToMHMbHxqr52gnZmIUy5xelmGQ/fs25PmL8F0uaNIYtBCPqmgFoNIl
	vlMNQP5n6QSRdEy1EHzFfyQ==
X-Received: from wrpb17.prod.google.com ([2002:adf:f251:0:b0:44c:f0d4:a61c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2582:b0:441:3144:efc5 with SMTP id ffacd0b85a97d-45ea416bbebmr2906383f8f.42.1779351186950;
 Thu, 21 May 2026 01:13:06 -0700 (PDT)
Date: Thu, 21 May 2026 09:12:50 +0100
In-Reply-To: <20260521081250.655226-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260521081250.655226-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521081250.655226-3-vdonnefort@google.com>
Subject: [PATCH 2/2] KVM: arm64: Add fail-safe for refcounted pages in __pkvm_hyp_donate_host
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

A previous bug in __pkvm_init_vm error path showed that the hypervisor
could leak refcounted pages, (i.e. losing access to a page while its
refcount is still elevated). This poses a threat to the pKVM state
machine.

Address this by introducing a fail-safe in n __pkvm_hyp_donate_host.
Transitions are not a hot path so added security is worth the extra
check.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 1e17973f24bb..dd168879431f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -856,6 +856,16 @@ static int __hyp_check_page_state_range(phys_addr_t phys, u64 size, enum pkvm_pa
 	return 0;
 }
 
+static int __hyp_check_page_count_range(phys_addr_t phys, u64 size)
+{
+	for_each_hyp_page(page, phys, size) {
+		if (page->refcount)
+			return -EBUSY;
+	}
+
+	return 0;
+}
+
 static bool guest_pte_is_poisoned(kvm_pte_t pte)
 {
 	if (kvm_pte_valid(pte))
@@ -1054,7 +1064,6 @@ int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
 int __pkvm_host_unshare_hyp(u64 pfn)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
-	u64 virt = (u64)__hyp_va(phys);
 	u64 size = PAGE_SIZE;
 	int ret;
 
@@ -1067,10 +1076,9 @@ int __pkvm_host_unshare_hyp(u64 pfn)
 	ret = __hyp_check_page_state_range(phys, size, PKVM_PAGE_SHARED_BORROWED);
 	if (ret)
 		goto unlock;
-	if (hyp_page_count((void *)virt)) {
-		ret = -EBUSY;
+	ret = __hyp_check_page_count_range(phys, size);
+	if (ret)
 		goto unlock;
-	}
 
 	__hyp_set_page_state_range(phys, size, PKVM_NOPAGE);
 	WARN_ON(__host_set_page_state_range(phys, size, PKVM_PAGE_OWNED));
@@ -1133,6 +1141,10 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 	if (ret)
 		goto unlock;
 
+	ret = __hyp_check_page_count_range(phys, size);
+	if (ret)
+		goto unlock;
+
 	__hyp_set_page_state_range(phys, size, PKVM_NOPAGE);
 	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, virt, size) != size);
 	WARN_ON(host_stage2_set_owner_locked(phys, size, PKVM_ID_HOST));
-- 
2.54.0.746.g67dd491aae-goog

