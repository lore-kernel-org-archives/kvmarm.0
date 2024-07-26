Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A1F17F500
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038028; cv=none; b=pLBTXhWo1hfGbG1zjiyJTGeEvFkM4X7T1YX/YDnuucLWIWjjbxHOpUtr2zxJUbExQPXuro8BBa8w94fi30pnT1qz143/6DT4ZmqloQv1wHvzb/ZlRJWZIU/voU9JqJk26NCRW4r2yRUc5HWIZ4j9DlF55+30ms5/568diz62590=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038028; c=relaxed/simple;
	bh=8U41yEZkwmCC7j8hL2o/rtiKo/Y2IzaocSdWcXfAeko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=en9EF6CV9fVXwAM9qpgI2tUUwkKaqaMKRRIOJchIQxLavS/wIB40f7CDDCgAzwJRtgfJXFTXmAxAzdV/L9OonP0j/zaLNe9sgkssUKon+l2bzDNj3+HN7dM3hIxAIe8VCgUQkan5LYQ8HruF26tdjVx1YfpHcDfS7h425+EGJ6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ww70KDS+; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ww70KDS+"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-650b621f4cdso5694377b3.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038026; x=1722642826; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TLCx2qDCvkD9gyhhD5S2JLlOeuoeLAn7xH7FruJz3kQ=;
        b=ww70KDS+/eP2LH0MAFiljYF9pZbxcBRj7xRjaiH5ukG0U0nbAmYWrLZBeICOMCaAbK
         /N4bG7NYBRsl7m7fEKk6qAVLhekJlReHI+YYiddL3FUzLEe4Vvbm9vxU/Fi5Q7ah8lMt
         Gvvz44eA1uDx0abbulkXrGAVrJl8fEKx8Sp7oG9EYp3SLBythCmXmS6ykSn1OQYWeEvW
         IACmkkoI7gYpFelTYP5ruMoSpD0iMJOXzUGJbPbfNttE5hYbkfoqGcbMcZNVcJc8NZCp
         Sxdm+Iip5vuwVHXrIfBrujosMewv3bQxd0kMTgqXh1/HqgnLfXKA9MnePUHvwYKXVPS7
         wF1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038026; x=1722642826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TLCx2qDCvkD9gyhhD5S2JLlOeuoeLAn7xH7FruJz3kQ=;
        b=GjLkxJK9vUsPkMWDWuxdY37P2Hnef7DiNjgn2SDssR0rkGViNatm/KOk6kiCOxY7Z4
         ZdujSKHpMZcde5je60TIPOtsMy9amzWBHwO5Qxy1HMU3jnNxPouHSjsuYex1AUU6fYY2
         i4tZ3k7hT5c9gSPKo96lnYepQlK7q1QT8asaQuK5Txdqy4lcKcWSCoVqtaEMassZwe/n
         QOWwIYrCMDcJN5oiuu+k7cA9gkaKQ5H4yWEko7eD2XjbhYvjDw2oWS8VhoOZASJTxiNI
         hVXtq29HjLPg2Vxk5ydPkOKYYTtfqk0WkUs9hC1sx6prkeKvf4vIbM803F5FSiJtMalr
         GhuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVV55ndtlz2fFV1kc2lMGrp93mae72I9L0aUik4lXni41BKZcocQHJOJnM+jRarUWVdNfubAswZvVo00vqM1HaYtwi49cP4
X-Gm-Message-State: AOJu0YyLlNsrdJnqlftxnjssLZ7bFCjArqAgTjgCQcXri/l2NPNpsIlx
	Cdbv3GwCCtR0NdpHm8d+cdnmkU+HNlz/zbuw3MHB55wkaF0iw0JmYf8ZtW7bh0pQY1KmQgGEW/4
	zYg==
X-Google-Smtp-Source: AGHT+IFuGqnDYAUSJ5FmVd85CGAsbS7YYsLTPQN/3Ul7QhkRMd8+dVyQHeeD8wiMpZyrbrthnX4Q+b9wtNM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1005:b0:e0b:f93:fe8c with SMTP id
 3f1490d57ef6-e0b5427fa67mr79832276.0.1722038025699; Fri, 26 Jul 2024 16:53:45
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:42 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-34-seanjc@google.com>
Subject: [PATCH v12 33/84] KVM: Disallow direct access (w/o mmu_notifier) to
 unpinned pfn by default
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

Add an off-by-default module param to control whether or not KVM is allowed
to map memory that isn't pinned, i.e. that KVM can't guarantee won't be
freed while it is mapped into KVM and/or the guest.  Don't remove the
functionality entirely, as there are use cases where mapping unpinned
memory is safe (as defined by the platform owner), e.g. when memory is
hidden from the kernel and managed by userspace, in which case userspace
is already fully trusted to not muck with guest memory mappings.

But for more typical setups, mapping unpinned memory is wildly unsafe, and
unnecessary.  The APIs are used exclusively by x86's nested virtualization
support, and there is no known (or sane) use case for mapping PFN-mapped
memory a KVM guest _and_ letting the guest use it for virtualization
structures.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a28479629488..0b3c0bddaa07 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -94,6 +94,13 @@ unsigned int halt_poll_ns_shrink = 2;
 module_param(halt_poll_ns_shrink, uint, 0644);
 EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
 
+/*
+ * Allow direct access (from KVM or the CPU) without MMU notifier protection
+ * to unpinned pages.
+ */
+static bool allow_unsafe_mappings;
+module_param(allow_unsafe_mappings, bool, 0444);
+
 /*
  * Ordering of locks:
  *
@@ -2821,6 +2828,9 @@ static kvm_pfn_t kvm_resolve_pfn(struct kvm_follow_pfn *kfp, struct page *page,
 	 * reference to such pages would cause KVM to prematurely free a page
 	 * it doesn't own (KVM gets and puts the one and only reference).
 	 * Don't allow those pages until the FIXME is resolved.
+	 *
+	 * Don't grab a reference for pins, callers that pin pages are required
+	 * to check refcounted_page, i.e. must not blindly release the pfn.
 	 */
 	if (pte) {
 		pfn = pte_pfn(*pte);
@@ -2942,6 +2952,14 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	bool write_fault = kfp->flags & FOLL_WRITE;
 	int r;
 
+	/*
+	 * Remapped memory cannot be pinned in any meaningful sense.  Bail if
+	 * the caller wants to pin the page, i.e. access the page outside of
+	 * MMU notifier protection, and unsafe umappings are disallowed.
+	 */
+	if (kfp->pin && !allow_unsafe_mappings)
+		return -EINVAL;
+
 	r = follow_pte(vma, kfp->hva, &ptep, &ptl);
 	if (r) {
 		/*
-- 
2.46.0.rc1.232.g9752f9e123-goog

