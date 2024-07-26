Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8C91891DE
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038091; cv=none; b=UJiUHy969dd+bvxuFbRb2Z1tjpzQ5PtQmqB7Xxge/vsaqEPqiQgzKPPkj+GCci9A6zln0WvrNV/Dw3QoU/jgf5cihtv3m9QzV3ZNFGr7Ypru//yI6Ocqa+9+ZV9LFOtnjF0DrxMr+aVTsthe9M6N19Hxk5hDwcpQ1VtwO8nBVzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038091; c=relaxed/simple;
	bh=VcTQVGMORivsMQ0yF/03nVYlzx0sgRF9KY1Z997atYs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KKrcZZQakOHhlkrqV/PZ8I8N5Bx9KFsToJ/d32zzzsMqFenojdwp/EN9NN1YsChRFkPH3Lzy6QrGOFRDspXT4waB4X63FG4M1KWsM7K76xnfvb9Zau/3fETtoHXidcvXAnBjUfjCFSUpHaYev74xBnnKPowC3GqkRux+Mse3lFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4vozFaD4; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4vozFaD4"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb4bcd9671so1774658a91.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038089; x=1722642889; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4jqep9wI+WruRy0z2TZYbUEBq8RbIq5j1OfKKvbW4+Y=;
        b=4vozFaD46gAoYP1VIga0K8KRNDihweNkjrOqkuiKeEgnrqK1kejpmDKvreoY+FHzLW
         WCP7SEtJaM2xCdT/+b5vm3tYfWadXT1LICBU+ObKWVfRjBGqcr0oBMA5qzSnsPLCDHzv
         /Yd+Rctzl2Xb8lfP9ZUhZoSkeI8nWTdkbwuosS2vYwuuwnlVLUwM3f2Y7DwrGjuyJv44
         2JHx8JJ3/dj21HWaiG1gLx1aGUHPcm9qOjIv8qG2exnPqlWoMa2ZxXz4u+27NmYAeSbq
         d1+0B1JJyBkDTE9RRS/s31K7lA/Is7om2u/AlP7/vYNnoPO7xXeB6w7AQLFuNlWPblrh
         /1Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038089; x=1722642889;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4jqep9wI+WruRy0z2TZYbUEBq8RbIq5j1OfKKvbW4+Y=;
        b=tXpFdK+hC4BRfI9I1y7yHt2Ddu0Sw4fmGbJRfSVC2qJw1TCqZRFYmdN3oCMjUd4dSY
         1NrGB7aeeaaaT7EkqkWUqC3f5GQPqI9J0s4uxd3NzbJbLkx5/sv4/jk58Qd1Y9F8PgsD
         rXQv/tbJigMerGTOIVmZl3q/mC4wra10J4dNsNsk2zRe7Zsl5Iqt//k3ro79yPrBCphj
         Kz8KeJJw9abs86nlftfoyfmBtwPggtQaLUIiNHqpZ8nxVZJzbJ3wW3G6WSY94imT1Oaw
         NHY5MrRhLvsVRdICguJbIEItoIkTeHwG8PeCC+XrNAYso4yDY6LIb8zkXwNK83FMzfG0
         qHRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwplEZJ266nfBGEyynuwQ6v0+5cTcG2E+ZtNhVNo2fIxbdaQg6etN8b/fvbAGuMG9nB9TKhA1YFes2Lh1YDFKFunTmTOJE
X-Gm-Message-State: AOJu0Yy6JMft1O5JqOba6wxK0wPBa1sHw4nhd4h1wrRuBQxp4N7KKokm
	thcGVGIXzOvqFix/7CSXtGxjAboyW7sKFa4CqVfTod+dQV1ewfLxGy6W56mgQ2G1tf7wdAnpBwa
	0BA==
X-Google-Smtp-Source: AGHT+IFasJAr04PTZrf6XUkQxxUmiACppU16Z34UUuO+d3NYseQpUQCzHrJDN41FkLsUjVBlqZCxQJJvuE8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:6fe5:b0:2c9:98bc:3584 with SMTP id
 98e67ed59e1d1-2cf7e83a1famr42409a91.6.1722038088823; Fri, 26 Jul 2024
 16:54:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:12 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-64-seanjc@google.com>
Subject: [PATCH v12 63/84] KVM: PPC: Use kvm_faultin_pfn() to handle page
 faults on Book3s PR
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Convert Book3S PR to __kvm_faultin_pfn()+kvm_release_faultin_page(), which
are new APIs to consolidate arch code and provide consistent behavior
across all KVM architectures.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/include/asm/kvm_book3s.h |  2 +-
 arch/powerpc/kvm/book3s.c             |  7 ++++---
 arch/powerpc/kvm/book3s_32_mmu_host.c |  7 ++++---
 arch/powerpc/kvm/book3s_64_mmu_host.c | 10 +++++-----
 4 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 34e8f0b7b345..343c10dda80f 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -235,7 +235,7 @@ extern void kvmppc_set_bat(struct kvm_vcpu *vcpu, struct kvmppc_bat *bat,
 extern void kvmppc_giveup_ext(struct kvm_vcpu *vcpu, ulong msr);
 extern int kvmppc_emulate_paired_single(struct kvm_vcpu *vcpu);
 extern kvm_pfn_t kvmppc_gpa_to_pfn(struct kvm_vcpu *vcpu, gpa_t gpa,
-			bool writing, bool *writable);
+			bool writing, bool *writable, struct page **page);
 extern void kvmppc_add_revmap_chain(struct kvm *kvm, struct revmap_entry *rev,
 			unsigned long *rmap, long pte_index, int realmode);
 extern void kvmppc_update_dirty_map(const struct kvm_memory_slot *memslot,
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index ff6c38373957..d79c5d1098c0 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -422,7 +422,7 @@ int kvmppc_core_prepare_to_enter(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(kvmppc_core_prepare_to_enter);
 
 kvm_pfn_t kvmppc_gpa_to_pfn(struct kvm_vcpu *vcpu, gpa_t gpa, bool writing,
-			bool *writable)
+			    bool *writable, struct page **page)
 {
 	ulong mp_pa = vcpu->arch.magic_page_pa & KVM_PAM;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
@@ -437,13 +437,14 @@ kvm_pfn_t kvmppc_gpa_to_pfn(struct kvm_vcpu *vcpu, gpa_t gpa, bool writing,
 		kvm_pfn_t pfn;
 
 		pfn = (kvm_pfn_t)virt_to_phys((void*)shared_page) >> PAGE_SHIFT;
-		get_page(pfn_to_page(pfn));
+		*page = pfn_to_page(pfn);
+		get_page(*page);
 		if (writable)
 			*writable = true;
 		return pfn;
 	}
 
-	return gfn_to_pfn_prot(vcpu->kvm, gfn, writing, writable);
+	return kvm_faultin_pfn(vcpu, gfn, writing, writable, page);
 }
 EXPORT_SYMBOL_GPL(kvmppc_gpa_to_pfn);
 
diff --git a/arch/powerpc/kvm/book3s_32_mmu_host.c b/arch/powerpc/kvm/book3s_32_mmu_host.c
index 4b3a8d80cfa3..5b7212edbb13 100644
--- a/arch/powerpc/kvm/book3s_32_mmu_host.c
+++ b/arch/powerpc/kvm/book3s_32_mmu_host.c
@@ -130,6 +130,7 @@ extern char etext[];
 int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte,
 			bool iswrite)
 {
+	struct page *page;
 	kvm_pfn_t hpaddr;
 	u64 vpn;
 	u64 vsid;
@@ -145,7 +146,7 @@ int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte,
 	bool writable;
 
 	/* Get host physical address for gpa */
-	hpaddr = kvmppc_gpa_to_pfn(vcpu, orig_pte->raddr, iswrite, &writable);
+	hpaddr = kvmppc_gpa_to_pfn(vcpu, orig_pte->raddr, iswrite, &writable, &page);
 	if (is_error_noslot_pfn(hpaddr)) {
 		printk(KERN_INFO "Couldn't get guest page for gpa %lx!\n",
 				 orig_pte->raddr);
@@ -232,7 +233,7 @@ int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte,
 
 	pte = kvmppc_mmu_hpte_cache_next(vcpu);
 	if (!pte) {
-		kvm_release_pfn_clean(hpaddr >> PAGE_SHIFT);
+		kvm_release_page_unused(page);
 		r = -EAGAIN;
 		goto out;
 	}
@@ -250,7 +251,7 @@ int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte,
 
 	kvmppc_mmu_hpte_cache_map(vcpu, pte);
 
-	kvm_release_pfn_clean(hpaddr >> PAGE_SHIFT);
+	kvm_release_page_clean(page);
 out:
 	return r;
 }
diff --git a/arch/powerpc/kvm/book3s_64_mmu_host.c b/arch/powerpc/kvm/book3s_64_mmu_host.c
index d0e4f7bbdc3d..be20aee6fd7d 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_host.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_host.c
@@ -88,13 +88,14 @@ int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte,
 	struct hpte_cache *cpte;
 	unsigned long gfn = orig_pte->raddr >> PAGE_SHIFT;
 	unsigned long pfn;
+	struct page *page;
 
 	/* used to check for invalidations in progress */
 	mmu_seq = kvm->mmu_invalidate_seq;
 	smp_rmb();
 
 	/* Get host physical address for gpa */
-	pfn = kvmppc_gpa_to_pfn(vcpu, orig_pte->raddr, iswrite, &writable);
+	pfn = kvmppc_gpa_to_pfn(vcpu, orig_pte->raddr, iswrite, &writable, &page);
 	if (is_error_noslot_pfn(pfn)) {
 		printk(KERN_INFO "Couldn't get guest page for gpa %lx!\n",
 		       orig_pte->raddr);
@@ -199,10 +200,9 @@ int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte,
 	}
 
 out_unlock:
-	if (!orig_pte->may_write || !writable)
-		kvm_release_pfn_clean(pfn);
-	else
-		kvm_release_pfn_dirty(pfn);
+	/* FIXME: Don't unconditionally pass unused=false. */
+	kvm_release_faultin_page(kvm, page, false,
+				 orig_pte->may_write && writable);
 	spin_unlock(&kvm->mmu_lock);
 	if (cpte)
 		kvmppc_mmu_hpte_cache_free(cpte);
-- 
2.46.0.rc1.232.g9752f9e123-goog

