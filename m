Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9C519049E
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038122; cv=none; b=ioVNAN/bXS6a7Ew5cRkf1aUnnkMm4+4vBTbjtbZJdIR+shPdxY4bL5YWVZr5A2Kpe7rVCCJus8DIO1swRa8ecj4G/ICodiCJ9iywQsJfSmbnKmeB7cRPWbHlFj6T9sbdsaYDHV45mDR5uB+O/syNw0iib1uh3ehgmUMAyR8YGyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038122; c=relaxed/simple;
	bh=/5ISP65ZKB4aAJCrgFo/a/dmCj6FCUM4/FLOnd814Lo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tUSXME9gbTn3AMDuuH2UxUh4ckvN0lc9CROtYC5LcE53FiNh84sbaEDBOrjWoMJl4CK8Yd4HdkHXYV4K4czXsBV0Tu8ekJIkSrdYVO3O3wUJzbZ9ILVRbArHqYuqlOVt+AUXjTCoEUMroWs9muyJNf1niprQSkQzFHx8ww4PLW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T2TF9Bit; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T2TF9Bit"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e035f7b5976so760916276.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038120; x=1722642920; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=B5cS3fQCyroPznI2D76vYSWht1aEO90tb+OiOa938C4=;
        b=T2TF9Bit+MinYEdf43qyJH8Rqphbsk/IQOFyDjpL4Qftt/KPnmSqoBUzd4e5ZOvs57
         BJz4hgRjFAX4dsGL0IE1GoLLLA5lDMSAadwEhAC9oCIE+FcWjtyB6Db/xTJVp1jFJwfS
         ouX7mVa+J5myxE7xuQHB71ctT0nBqCpLMdbA9F/2YYN6rHrYPfOZ08M7nVashZolF/Te
         7ng5jCjN9ceReVFbQ3qRuHMpFjJksAEqrUlIcelj7+8aGeu3gFL5rMUxtU4ST8fxEQ6J
         7gtyyVRJYhz2i6XPNMMCPDQklNq4D7anGBmak4VmxdRp1oCFx/Q//bQd/6zG73P81J1u
         nKDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038120; x=1722642920;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B5cS3fQCyroPznI2D76vYSWht1aEO90tb+OiOa938C4=;
        b=KXxZ0V3tvnBoLm2OKxWyISBANvH17Q1LcdhoLwt/LmBqNZRyloZ9N/VoaYYMEUR8Mi
         dOloFwTFR20A+kewi0qbrXIYQEqo6sSw4lmG1xqlMg0bfP6451trKlSquGUgvB5GXfuo
         cBI+N8E05U2eGwGGzoyE9I+3bECvFMbE4/xBgB4wIaEJJyN/4cE2P2qTz8jA9dQ3/0+W
         0vcS9+Sxzd1ZCZRrO9fGHmxPgY6yuSMYW7EuLPV+A46nfiTpQlwQ5Q4MAq6EO3ZxT0IJ
         +5TxnlM+Of5JuLxQ1uFVdQti26WokfuffzdoVUjRXl4kNr4rsJkXSxPHAuMQmsXN+eAs
         eZUg==
X-Forwarded-Encrypted: i=1; AJvYcCUzGeU0Jn0cPnuHVdGEDmSwaAc3JlXY+2s/EW+pO80BlKxL00ZGhAbB4wcXaHlgugVcSCDITfZF0Y9sqC+GfFDqlM3ntydF
X-Gm-Message-State: AOJu0YxurMVOt45tzvRXHCwgg0Dz8QOwxTEXIE91q7+f+mlZ4V/eGnFX
	6/GjmooolAB5t4fVNwksiPZxxDbcZpz4Q/3UovPHgJSFaUGZJHnpVXNMR8eRKCHNxeZY7GIVuZn
	D/Q==
X-Google-Smtp-Source: AGHT+IFMnVGgr4kpL4f9GKaKFvGezuIshpJ8eZPypNhpoA7Mjxc5gf+mvj1jThnEcafAjrCOymr+lPlnWyQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:606:0:b0:e0b:3139:7ce5 with SMTP id
 3f1490d57ef6-e0b55d079camr27265276.5.1722038119814; Fri, 26 Jul 2024 16:55:19
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:27 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-79-seanjc@google.com>
Subject: [PATCH v12 78/84] KVM: Drop gfn_to_pfn() APIs now that all users are gone
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

Drop gfn_to_pfn() and all its variants now that all users are gone.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 11 --------
 virt/kvm/kvm_main.c      | 59 ----------------------------------------
 2 files changed, 70 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f2d3c3c436cc..34a1cadb1b80 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1260,14 +1260,6 @@ static inline kvm_pfn_t kvm_faultin_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
 				 write ? FOLL_WRITE : 0, writable, refcounted_page);
 }
 
-kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
-kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
-		      bool *writable);
-kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn);
-kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
-			       bool interruptible, bool no_wait,
-			       bool write_fault, bool *writable);
-
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
 void kvm_release_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_dirty(kvm_pfn_t pfn);
@@ -1342,9 +1334,6 @@ unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
 void mark_page_dirty_in_slot(struct kvm *kvm, const struct kvm_memory_slot *memslot, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
-
-kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
-
 int __kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map,
 		   bool writable);
 void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 16bc3ac3ff84..5dcf3561b829 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3059,65 +3059,6 @@ static kvm_pfn_t kvm_follow_pfn(struct kvm_follow_pfn *kfp)
 	return hva_to_pfn(kfp);
 }
 
-kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
-			       bool interruptible, bool no_wait,
-			       bool write_fault, bool *writable)
-{
-	struct kvm_follow_pfn kfp = {
-		.slot = slot,
-		.gfn = gfn,
-		.map_writable = writable,
-	};
-
-	if (write_fault)
-		kfp.flags |= FOLL_WRITE;
-	if (no_wait)
-		kfp.flags |= FOLL_NOWAIT;
-	if (interruptible)
-		kfp.flags |= FOLL_INTERRUPTIBLE;
-
-	return kvm_follow_pfn(&kfp);
-}
-EXPORT_SYMBOL_GPL(__gfn_to_pfn_memslot);
-
-kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
-		      bool *writable)
-{
-	struct kvm_follow_pfn kfp = {
-		.slot = gfn_to_memslot(kvm, gfn),
-		.gfn = gfn,
-		.flags = write_fault ? FOLL_WRITE : 0,
-		.map_writable = writable,
-	};
-
-	return kvm_follow_pfn(&kfp);
-}
-EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
-
-kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
-{
-	struct kvm_follow_pfn kfp = {
-		.slot = slot,
-		.gfn = gfn,
-		.flags = FOLL_WRITE,
-	};
-
-	return kvm_follow_pfn(&kfp);
-}
-EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
-
-kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
-{
-	return gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn);
-}
-EXPORT_SYMBOL_GPL(gfn_to_pfn);
-
-kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn)
-{
-	return gfn_to_pfn_memslot(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn);
-}
-EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_pfn);
-
 kvm_pfn_t kvm_lookup_pfn(struct kvm *kvm, gfn_t gfn)
 {
 	struct page *refcounted_page = NULL;
-- 
2.46.0.rc1.232.g9752f9e123-goog

