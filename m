Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9F618FDD9
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038116; cv=none; b=K1uHw0VZhzlo/dvFdY0c8JcarvcGzo4G4mVsBYDZ6gD+9FP97eXY5s/+oX7086BkXxKz5AgH9Dkcwf3CPIqPSpVK36XoSGKO1z0s2GIOdJxFGzSrJeZ0xPm7xS/JEX6nhgVe9D88eOCVWfEoKHWqzPNbI9626UJv8RAYneH8G+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038116; c=relaxed/simple;
	bh=p0sbScV9KYWrdS1YnUq9iP3jaGBNbAWZ6v3m97jnfrM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jJQqxyn1jmT5TG/MrNg9IBPkf5YAOjMyiKuQayGsfZoTX5JR8+w3LErND58iInhHRzWpUC86i5RFWhlaCvvQua3Bzb9gM/ZoMSESuIBz/wQtzT9Cnov/VnTIH35Xq5/u4YX7ouQPx+O3Tp6REL+fU6K5I1rmMRs4RlPp2dGNVV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MKC1TujR; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MKC1TujR"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e02b5792baaso429160276.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038114; x=1722642914; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zSysp7FPh6wn+DolRHFxx8ZAZJRhLuISfWWp3RFo0OA=;
        b=MKC1TujRGsBwX2QuENyWPle/9S22LArp8p3hyq5czR0HqiHb434rfkVB5tLIsOZiNG
         Td9hMBn/Gsh0KPyNGBPaWLXdpIRaBHX6fLkCqr06ErZRdeY7gUMUonZkNExiCMNFwSEy
         WPlE1zhABGsxHqZnItTnz5GgHC/cS+7LxUW2qTnkB5TsWzadGHyJ9FxaiByxUsWI7jpM
         5ki7gYGNEQXTJlnoezxADkN/2+JBiEv25I4BGiBSzOpSgh+4177+8+umJAT+y5T29wdJ
         Zga4LvlU9k/g+D48lX0mvztkX5Knb6r4Wf73UQbCNjYSndzFHRuTkikzce+Ca609rGLa
         W+jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038114; x=1722642914;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zSysp7FPh6wn+DolRHFxx8ZAZJRhLuISfWWp3RFo0OA=;
        b=KBB52T1hGjBeNk/jQhFNiCcfotmwkCg3B3uEqPNCIEl5SipDPYoc8NQyInx5d5JxHC
         8S4mkU8J8isT3WjlgcktpZWHNk3frQFl2JqFYyG5OY4rwrN9A6uCNDL43eP8FbG+tebA
         6NxUGtNS68qQtcnib3gxNazE+Mxx9CkYS7lSMNIDgxMd0aaP6n4+JWZvtBco46JrL/UJ
         BkVhu+aSb0D7m5ljd4cxGwpUeZqfR7EaW0AauvNh9OSwWC3aFQyM0EvnpSY6c1RtvphS
         0eXdKgl28p7yDxc9KH/nVDaJkUz+AUWh2ACDUUs3LS5de/RLWmuS+jCuCqNghtARd7UT
         pr3g==
X-Forwarded-Encrypted: i=1; AJvYcCWgamTaQpFuCuGy2HXFXQPrUfDE87wheUAGcCQDmuEgxYn1vbjVIwUNtkdfNT0hcBoVlGoMChVDaNPCOhh28oHI+DOdF/cg
X-Gm-Message-State: AOJu0YxmaNwG8otfLKeaNPOy6aM95ODkq1Sb99aCvG96wqr4qcz3RbUZ
	wLq9mIn9Bbx17ON9FD8ZWrzVRLB9a6LMZLdu1xrZ0JZiR37/ZiNcrEmgcu6547RZs64ZbMoul8c
	eXg==
X-Google-Smtp-Source: AGHT+IHtdYLzf8VxCow9ze9t5PB7b90MwNFbCURT1XZzWgwcWEIftZd8Pqph9MK+hSFYPsX4JKQKNB1AEe8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1889:b0:dfb:1147:cbaa with SMTP id
 3f1490d57ef6-e0b5459b0b9mr34694276.10.1722038113838; Fri, 26 Jul 2024
 16:55:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:24 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-76-seanjc@google.com>
Subject: [PATCH v12 75/84] KVM: Add support for read-only usage of gfn_to_page()
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

Rework gfn_to_page() to support read-only accesses so that it can be used
by arm64 to get MTE tags out of guest memory.

Opportunistically rewrite the comment to be even more stern about using
gfn_to_page(), as there are very few scenarios where requiring a struct
page is actually the right thing to do (though there are such scenarios).
Add a FIXME to call out that KVM probably should be pinning pages, not
just getting pages.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  7 ++++++-
 virt/kvm/kvm_main.c      | 15 ++++++++-------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 91341cdc6562..f2d3c3c436cc 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1198,7 +1198,12 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
 		       struct page **pages, int nr_pages);
 
-struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
+struct page *__gfn_to_page(struct kvm *kvm, gfn_t gfn, bool write);
+static inline struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
+{
+	return __gfn_to_page(kvm, gfn, true);
+}
+
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva_prot(struct kvm *kvm, gfn_t gfn, bool *writable);
 unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d0f55a6ecb31..16bc3ac3ff84 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3174,25 +3174,26 @@ int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
 EXPORT_SYMBOL_GPL(kvm_prefetch_pages);
 
 /*
- * Do not use this helper unless you are absolutely certain the gfn _must_ be
- * backed by 'struct page'.  A valid example is if the backing memslot is
- * controlled by KVM.  Note, if the returned page is valid, it's refcount has
- * been elevated by gfn_to_pfn().
+ * Don't use this API unless you are absolutely, positively certain that KVM
+ * needs to get a struct page, e.g. to pin the page for firmware DMA.
+ *
+ * FIXME: Users of this API likely need to FOLL_PIN the page, not just elevate
+ *	  its refcount.
  */
-struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
+struct page *__gfn_to_page(struct kvm *kvm, gfn_t gfn, bool write)
 {
 	struct page *refcounted_page = NULL;
 	struct kvm_follow_pfn kfp = {
 		.slot = gfn_to_memslot(kvm, gfn),
 		.gfn = gfn,
-		.flags = FOLL_WRITE,
+		.flags = write ? FOLL_WRITE : 0,
 		.refcounted_page = &refcounted_page,
 	};
 
 	(void)kvm_follow_pfn(&kfp);
 	return refcounted_page;
 }
-EXPORT_SYMBOL_GPL(gfn_to_page);
+EXPORT_SYMBOL_GPL(__gfn_to_page);
 
 int __kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
 		   bool writable)
-- 
2.46.0.rc1.232.g9752f9e123-goog

