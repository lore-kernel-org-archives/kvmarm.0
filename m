Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3251A1552E9
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618289; cv=none; b=AIlQQ+LPTYZE4fLFKalj17ilgcRLwErDF8gfbtcytX/FyZAuR9tqeSBFDi3aS6TgyG2v+SuNX8geyQialMXLOdGURrPkO90AMxsHjRL3zn9CYuEo37MAkRhQmNxIg/LN9VRvtbOJhuvtDd42l0B//bwalNdVd5MEU5ed4hdJgpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618289; c=relaxed/simple;
	bh=P+1my6e2EG6HqBtPBiSnqhQm5OOKzgoow6fE2thqWbo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NSWbQG3s9xv/6tpcnMT1hh2Kx5T1O/dBgdOfMCl1U0xNyGJzUUL2g8jbpawVJM2Owdf+feeZk4D7r04/d6hluu9IeUNs3y6IDp/zR5vPSUX0AnFmQjbvuGmp295URbM2a5xQmAmVQfnM0lqLGBNLd00dmtKmaC5t2tOFHqFXGjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4VS5xDLr; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4VS5xDLr"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4128defb707so1753795e9.0
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618286; x=1709223086; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=96SE5IhMsTsl22EMELmM2IDBXvJyu3bsEOUXPZdKK5k=;
        b=4VS5xDLre77iq2MXHo2YKcmXNRjGL0KKek94LYX/YzdMus5cmwfaOGxIal7mJNwi4i
         O3uUty+j4MACHa1bv19FIecJiQcMKWNcXelzZkYiQr+E4akGXdwHmfWZFmHFm7f+7Ea0
         bopvnAG3UY7cOsC2tJ794tticM1cUExwTeA4mzBGQuOAERsEbpML/6caqhPy39oQJX8A
         voghErIbqyU5hHdpThexMAG5fJEG2m8kxMbyuuwz9sVd23X47ayix0ZPxy2ht2YL/SAl
         ao0fhLeP09qa6fT6+p/ipDoa3VncEkP0uToEj7ATyyWWvFnXDXiR3t7kzY8IjyLLZM+6
         /sCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618286; x=1709223086;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=96SE5IhMsTsl22EMELmM2IDBXvJyu3bsEOUXPZdKK5k=;
        b=GMgmbsau+fQDfm/R5Ei5p/VRmcDiOkg9fjU+45N/5/yR33AOr3LCGBGF+9vecmfYu3
         M//bi/IVTvTHz6Xpw3krTXdNoWVHCDgA0+BD+MbejDOAECeesw2+CveXf5nTNnJOhtm4
         Nl8PV+H9Z19POVW6OcdgDsuDP/032smG+JhPUm0OH4v5ulzxl3bd8G1gG7se7tMRk1po
         rkw4deo9Fu8i9NyQ9Vm36NmE64K7sa/N0BcvWscLcfHw2SjZPWAmRX+DGQSh1CIg9Kzj
         ajHVB1T9akNYs7fIR3h6FyZzTtW1WAk1lb7ofSKpQ8bvGNGCjFqQkjLyp5605IZPui8V
         DjYA==
X-Forwarded-Encrypted: i=1; AJvYcCWF6nwBz1l6E9Oab0Aa+8A2VyIL9W3rWXHWmeCPTewWA/RLq7u08b4Y2dYJTXDQreZ0qzjjl58foYNNlg11Ea0CTlZIhbtk
X-Gm-Message-State: AOJu0YzGKaeMeRBCkmTnAl/BJEU1enNIjvL1OWyXtcmCzFwn1RmleIWB
	giM7Qv3c/9JqnkVx6s6IhIXcbvR1rHl/bDED34+e0wEzZ2QMCI0CauXr8kLTbDH7S7MAg2WY/A=
	=
X-Google-Smtp-Source: AGHT+IFO+MZ28lvn87oBvUTv577Hp/Qx1nvk/NnBuEl1cGPhPZ7VvvhD7dqbRVhIzgyH4/gvei3q/b0ENA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:1f8b:b0:33d:9e15:126b with SMTP id
 bw11-20020a0560001f8b00b0033d9e15126bmr960wrb.3.1708618286668; Thu, 22 Feb
 2024 08:11:26 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:36 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-16-tabba@google.com>
Subject: [RFC PATCH v1 15/26] KVM: arm64: Rename kvm_pinned_page to kvm_guest_page
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

With guestmem, pages won't be pinned. Change the name of the
structure to reflect that.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/mmu.c              | 12 ++++++------
 arch/arm64/kvm/pkvm.c             | 10 +++++-----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fb7aff14fd1a..99bf2b534ff8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -206,7 +206,7 @@ struct kvm_smccc_features {
 	unsigned long vendor_hyp_bmap;
 };
 
-struct kvm_pinned_page {
+struct kvm_guest_page {
 	struct rb_node		node;
 	struct page		*page;
 	u64			ipa;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f796e092a921..ae6f65717178 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -336,7 +336,7 @@ static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 si
 
 static void pkvm_stage2_flush(struct kvm *kvm)
 {
-	struct kvm_pinned_page *ppage;
+	struct kvm_guest_page *ppage;
 	struct rb_node *node;
 
 	/*
@@ -346,7 +346,7 @@ static void pkvm_stage2_flush(struct kvm *kvm)
 	 * destroy (which only occurs when all vcpu are gone).
 	 */
 	for (node = rb_first(&kvm->arch.pkvm.pinned_pages); node; node = rb_next(node)) {
-		ppage = rb_entry(node, struct kvm_pinned_page, node);
+		ppage = rb_entry(node, struct kvm_guest_page, node);
 		__clean_dcache_guest_page(page_address(ppage->page), PAGE_SIZE);
 		cond_resched_rwlock_write(&kvm->mmu_lock);
 	}
@@ -1416,8 +1416,8 @@ static int pkvm_host_map_guest(u64 pfn, u64 gfn)
 
 static int cmp_ppages(struct rb_node *node, const struct rb_node *parent)
 {
-	struct kvm_pinned_page *a = container_of(node, struct kvm_pinned_page, node);
-	struct kvm_pinned_page *b = container_of(parent, struct kvm_pinned_page, node);
+	struct kvm_guest_page *a = container_of(node, struct kvm_guest_page, node);
+	struct kvm_guest_page *b = container_of(parent, struct kvm_guest_page, node);
 
 	if (a->ipa < b->ipa)
 		return -1;
@@ -1426,7 +1426,7 @@ static int cmp_ppages(struct rb_node *node, const struct rb_node *parent)
 	return 0;
 }
 
-static int insert_ppage(struct kvm *kvm, struct kvm_pinned_page *ppage)
+static int insert_ppage(struct kvm *kvm, struct kvm_guest_page *ppage)
 {
 	if (rb_find_add(&ppage->node, &kvm->arch.pkvm.pinned_pages, cmp_ppages))
 		return -EEXIST;
@@ -1440,7 +1440,7 @@ static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	struct kvm_hyp_memcache *hyp_memcache = &vcpu->arch.pkvm_memcache;
 	struct mm_struct *mm = current->mm;
 	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
-	struct kvm_pinned_page *ppage;
+	struct kvm_guest_page *ppage;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_s2_mmu *mmu =  &kvm->arch.mmu;
 	struct page *page;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 713bbb023177..0dbde37d21d0 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -26,7 +26,7 @@ phys_addr_t hyp_mem_size;
 
 static int rb_ppage_cmp(const void *key, const struct rb_node *node)
 {
-       struct kvm_pinned_page *p = container_of(node, struct kvm_pinned_page, node);
+       struct kvm_guest_page *p = container_of(node, struct kvm_guest_page, node);
        phys_addr_t ipa = (phys_addr_t)key;
 
        return (ipa < p->ipa) ? -1 : (ipa > p->ipa);
@@ -254,7 +254,7 @@ static bool pkvm_teardown_vm(struct kvm *host_kvm)
 
 void pkvm_destroy_hyp_vm(struct kvm *host_kvm)
 {
-	struct kvm_pinned_page *ppage;
+	struct kvm_guest_page *ppage;
 	struct mm_struct *mm = current->mm;
 	struct rb_node *node;
 	unsigned long pages = 0;
@@ -266,7 +266,7 @@ void pkvm_destroy_hyp_vm(struct kvm *host_kvm)
 
 	node = rb_first(&host_kvm->arch.pkvm.pinned_pages);
 	while (node) {
-		ppage = rb_entry(node, struct kvm_pinned_page, node);
+		ppage = rb_entry(node, struct kvm_guest_page, node);
 		WARN_ON(kvm_call_hyp_nvhe(__pkvm_host_reclaim_page,
 					  page_to_pfn(ppage->page)));
 		cond_resched();
@@ -341,7 +341,7 @@ device_initcall_sync(finalize_pkvm);
 
 void pkvm_host_reclaim_page(struct kvm *host_kvm, phys_addr_t ipa)
 {
-	struct kvm_pinned_page *ppage;
+	struct kvm_guest_page *ppage;
 	struct mm_struct *mm = current->mm;
 	struct rb_node *node;
 
@@ -356,7 +356,7 @@ void pkvm_host_reclaim_page(struct kvm *host_kvm, phys_addr_t ipa)
 	if (!node)
 		return;
 
-	ppage = container_of(node, struct kvm_pinned_page, node);
+	ppage = container_of(node, struct kvm_guest_page, node);
 
 	WARN_ON(kvm_call_hyp_nvhe(__pkvm_host_reclaim_page,
 				  page_to_pfn(ppage->page)));
-- 
2.44.0.rc1.240.g4c46232300-goog

