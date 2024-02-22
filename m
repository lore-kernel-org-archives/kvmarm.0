Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1E8153BC8
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618270; cv=none; b=sVWZ0qYMJgwxTw6Y9tHfSaMakYFLJkmoGH2bZ0OxrCtoYif8AY/k5RPEV7yA4XTOwHL6TXB8uVZhb0n6twaEXdIGtJD26UABPKAhJpoLNSEeWCDTa5lJKbQpU5jloccbkPmvj6fciNXSyg1GWhJzyiHDicARYfrFheMvB3qG6qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618270; c=relaxed/simple;
	bh=307wRd3a0Gu+2jPkCXpx//8T+nAN9ErEfklgaiaAxPo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NJ7JE9hr1eqRh+gfm4xxiEU1MCe2RFhJOWyC7m0vBeeVHPu1cP9n1D3NB/WNeWvFuUoW8LW6cDGxadzqWA6khorBVhpIHhgd48gmbDNUlcviCW/rPQlyY7H6oLc20BLQ7FQ4a82Ng2hthDqHnLuZHuGUzeFgy8hw28sFpH3yVv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A2lkN/3A; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A2lkN/3A"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4102b934ba0so42433645e9.2
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618267; x=1709223067; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FNzzZH63lKYNBuTHaseubTbAwMOeT2CF2+7V/cVEfrs=;
        b=A2lkN/3AO3J8yBizKyyuXoYN7PP1aBznmI8d9G+XakcaWp6YryFdn8ogpW7D3T8x5W
         NViguTQrBsig4Hz0PIRLO5Kx/eEu2ftcoX1dihQ5JaCXrcsU50U0bQnef4bmdtmT3xbr
         VI598q88W5zwxNYU5J8CrOr8fcL3PTKUxamB/ARK0ByVPFL5FwuT4QMx8p+xyQYCmTuB
         kHlVvIGiSqHVcW3andOFdiehNXdn9k+tglKfazLh5IRUUiPplrLmJ4wp59uhpUO/qcci
         QMAVcJcu7q3SK2JPnCIRQa355csLn6TGkdMAJWFhxRS6ZvnAHEbUTWmDm6h0AH2WSFrk
         4v1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618267; x=1709223067;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FNzzZH63lKYNBuTHaseubTbAwMOeT2CF2+7V/cVEfrs=;
        b=fF5fzreJIPpCE7ZNLw5q0Jxa839PjGmX78ElYmkTTi/1dQE5uyEVIZSwSyAbYZn1tb
         ydKGVK5ivfYpH6wAFJqX1Eij8rCQljQiQt/It7MlokGBsF1DKTxGG7b5OhlF5TTbb0tk
         ZVf3gKnGt1AVb23lIIHkRRpv1PZbZIt5Gj8QbRRgR2NrSrbDi8lA0tAvaXm9is7w6Tkg
         EQVczdRZwvrQ3Oz3OsMqvaXRecjXJSKGaiSZ8UxlFKlCEmZDZEWdWXtOklF5L4G4cXz2
         8HroOmX7e4WXh1NfPCoCIxlLc9vVJecV/kD5gXYwqsyYvMgw94y/01B4MGGFnbCw9iwQ
         LpWA==
X-Forwarded-Encrypted: i=1; AJvYcCXSRtUZi4igx1uuZSp/oA5L+MHj7GI8h2UFwemR1e74+t6MfeDq8baHVdNz59VnLmPXo2pSWfHZFHFFRTa924SmEWAn3+mz
X-Gm-Message-State: AOJu0YxtcC3aw5J4dybiTEz9OK2S9dWSAfXp8GbEBo8Y/59y8ea9fLdY
	jDbcOPY1nrnIjf+AfkCHAI+AWTvmOgkcj4RO9Pgf4KY+zfaxPSovJq+tXK31Ycg7TFsOzefygQ=
	=
X-Google-Smtp-Source: AGHT+IF1jnkomd+1xe0eYCGjm0e0odW61OHzS3zTMn83kYMemPKodA3UWn5V1pKZgKWIx25dpZtQqBGvmw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:783:b0:33d:60c4:5f5f with SMTP id
 bu3-20020a056000078300b0033d60c45f5fmr29858wrb.7.1708618267415; Thu, 22 Feb
 2024 08:11:07 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:28 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-8-tabba@google.com>
Subject: [RFC PATCH v1 07/26] KVM: arm64: Turn llist of pinned pages into an rb-tree
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Quentin Perret <qperret@google.com>

Indexed by IPA, so we can efficiently lookup.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  5 +++--
 arch/arm64/kvm/mmu.c              | 30 ++++++++++++++++++++++++++----
 arch/arm64/kvm/pkvm.c             | 12 +++++++-----
 3 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2777b0fe1b12..55de71791233 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -207,8 +207,9 @@ struct kvm_smccc_features {
 };
 
 struct kvm_pinned_page {
-	struct list_head	link;
+	struct rb_node		node;
 	struct page		*page;
+	u64			ipa;
 };
 
 typedef unsigned int pkvm_handle_t;
@@ -216,7 +217,7 @@ typedef unsigned int pkvm_handle_t;
 struct kvm_protected_vm {
 	pkvm_handle_t handle;
 	struct kvm_hyp_memcache teardown_mc;
-	struct list_head pinned_pages;
+	struct rb_root pinned_pages;
 	bool enabled;
 };
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ac088dc198e6..f796e092a921 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -337,6 +337,7 @@ static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 si
 static void pkvm_stage2_flush(struct kvm *kvm)
 {
 	struct kvm_pinned_page *ppage;
+	struct rb_node *node;
 
 	/*
 	 * Contrary to stage2_apply_range(), we don't need to check
@@ -344,7 +345,8 @@ static void pkvm_stage2_flush(struct kvm *kvm)
 	 * from a vcpu thread, and the list is only ever freed on VM
 	 * destroy (which only occurs when all vcpu are gone).
 	 */
-	list_for_each_entry(ppage, &kvm->arch.pkvm.pinned_pages, link) {
+	for (node = rb_first(&kvm->arch.pkvm.pinned_pages); node; node = rb_next(node)) {
+		ppage = rb_entry(node, struct kvm_pinned_page, node);
 		__clean_dcache_guest_page(page_address(ppage->page), PAGE_SIZE);
 		cond_resched_rwlock_write(&kvm->mmu_lock);
 	}
@@ -913,7 +915,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	mmu->vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
-	INIT_LIST_HEAD(&kvm->arch.pkvm.pinned_pages);
+	kvm->arch.pkvm.pinned_pages = RB_ROOT;
 	mmu->arch = &kvm->arch;
 
 	if (is_protected_kvm_enabled())
@@ -1412,6 +1414,26 @@ static int pkvm_host_map_guest(u64 pfn, u64 gfn)
 	return (ret == -EPERM) ? -EAGAIN : ret;
 }
 
+static int cmp_ppages(struct rb_node *node, const struct rb_node *parent)
+{
+	struct kvm_pinned_page *a = container_of(node, struct kvm_pinned_page, node);
+	struct kvm_pinned_page *b = container_of(parent, struct kvm_pinned_page, node);
+
+	if (a->ipa < b->ipa)
+		return -1;
+	if (a->ipa > b->ipa)
+		return 1;
+	return 0;
+}
+
+static int insert_ppage(struct kvm *kvm, struct kvm_pinned_page *ppage)
+{
+	if (rb_find_add(&ppage->node, &kvm->arch.pkvm.pinned_pages, cmp_ppages))
+		return -EEXIST;
+
+	return 0;
+}
+
 static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot)
 {
@@ -1479,8 +1501,8 @@ static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	ppage->page = page;
-	INIT_LIST_HEAD(&ppage->link);
-	list_add(&ppage->link, &kvm->arch.pkvm.pinned_pages);
+	ppage->ipa = fault_ipa;
+	WARN_ON(insert_ppage(kvm, ppage));
 	write_unlock(&kvm->mmu_lock);
 
 	return 0;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 10a619b257c4..11355980e18d 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -246,9 +246,9 @@ static bool pkvm_teardown_vm(struct kvm *host_kvm)
 
 void pkvm_destroy_hyp_vm(struct kvm *host_kvm)
 {
-	struct kvm_pinned_page *ppage, *tmp;
+	struct kvm_pinned_page *ppage;
 	struct mm_struct *mm = current->mm;
-	struct list_head *ppages;
+	struct rb_node *node;
 	unsigned long pages = 0;
 
 	if (!pkvm_teardown_vm(host_kvm))
@@ -256,14 +256,16 @@ void pkvm_destroy_hyp_vm(struct kvm *host_kvm)
 
 	free_hyp_memcache(&host_kvm->arch.pkvm.teardown_mc);
 
-	ppages = &host_kvm->arch.pkvm.pinned_pages;
-	list_for_each_entry_safe(ppage, tmp, ppages, link) {
+	node = rb_first(&host_kvm->arch.pkvm.pinned_pages);
+	while (node) {
+		ppage = rb_entry(node, struct kvm_pinned_page, node);
 		WARN_ON(kvm_call_hyp_nvhe(__pkvm_host_reclaim_page,
 					  page_to_pfn(ppage->page)));
 		cond_resched();
 
 		unpin_user_pages_dirty_lock(&ppage->page, 1, true);
-		list_del(&ppage->link);
+		node = rb_next(node);
+		rb_erase(&ppage->node, &host_kvm->arch.pkvm.pinned_pages);
 		kfree(ppage);
 		pages++;
 	}
-- 
2.44.0.rc1.240.g4c46232300-goog

