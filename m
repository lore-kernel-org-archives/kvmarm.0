Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DE61E1DEE
	for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 14:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753194747; cv=none; b=lhuetPua0nqiTr6DtbrN5DI7eztdFQN4nnaPKGVgxAOPCtjAjoAwMI1a4UJ9qcQTy1wbotrEWgiI/QDoP8qMfPdkCB1wySZMMWUUVv0UB+JIDbbbsz26QSkveEu1sjWNGR6oS74NhWmrUiKF53zWiNxoX3SSmc69eTEBY7APRm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753194747; c=relaxed/simple;
	bh=Dv6BrDzEnKemRZ1oJtfVg2+TPtO27uklV4NgxZkoI0M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hna2nGVRbXYKXFs0w7BduXvSjmdlqscFLYVyo9w86NulfFQ9vCHhIW2CzQlysDibuCYE40aGFTqn2wExRjjjSnguMuseO1cNd5kyZek3aI4E978KxfCshuHxExlQgblrDjmGshvzPS55wFJStyaSrRHOh3K9KGrhU01HT05DANA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aJb1B01D; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aJb1B01D"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3141f9ce4e2so8431938a91.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 07:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753194744; x=1753799544; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=se7GGG6+kEUdCY1BG7ucwwvP5WO24MC0HMwFM3DCv0c=;
        b=aJb1B01DubgDfPU5zY6PQzAfANi7oiHSxGS0jUFJS2yGyRrUDq8mEYtyehJuwHoD8K
         V1lCkgOc7g+nhgTYddgoZy05GMusLsVk7A2piDN+uytNr0zvMqWQfzMvE/pQkGNuNFXa
         1sjsndk9tcZ+b0ThXD+JlNjmVvtqhEAPQ0ASGcpWfWZ5QqGFvms4udTZZ13K6Yu+k1Fm
         xqE8nnx/45IXEoea5pN9qu3j93TI5IN77CqmNXo8NgXAZk0KaNwxI6DhxUBkipRMcG+6
         ao99lRx6a1nD5scMkuPqJjPhGXwLPX2irmWLyyu1lUqmNGeUZIPAuNVCnf6YjjRIezxO
         tNIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753194744; x=1753799544;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=se7GGG6+kEUdCY1BG7ucwwvP5WO24MC0HMwFM3DCv0c=;
        b=CGxTRltXQHQ/WSB/i282trlxRjRo3dU891U1Ksz5P0IKCpBcFYdIUwSbI4xsH3u2KJ
         w+s9YHRhteEWVa33rOI+l+7ziaF9zqketZ6LNfMvGqUu84qK51kuEvlZyLXaAFJPWivE
         xubsqo+swt9Ot87AH2LR1HEV3uuQZH4l4bg6KYJpLDFHnqKI5UPk4IVDux3s6Xhng2Ad
         OORYSYtWZkIAN/OHB7gQZl46IslkzwgAQhVubUKwPpdKw0kS7WP2oanLM1WNzVdWn101
         lJyGGwtg/DqpzpVD1Fzzb9b1y7eiZjo0511srZtkpGSNf6oFdB1pjyMEAUY8E/U9XrJp
         9cVw==
X-Forwarded-Encrypted: i=1; AJvYcCUa83dU+EyU7BNBTgX9g2xBR4O8wpnLvVqNw9hUssI1pkBczrgvbXUNt6KoqUBfe9ESoXKziUU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy94FUPPyMK+EPaYqpwiNLmenom1dQ6LoHjZH5iiAX4w6yqMl/q
	tWdgdw60EsIgiSIvgy0TpTxJ8HX2HJ+fL66+uW0hcqVxhR2VgAZ6MJTXoQkIiY/GjV5qodSUN3T
	9zhtlwg==
X-Google-Smtp-Source: AGHT+IFIvlEtw+vvXuklNdKzQemd9/qAa+tLiT5GFxA8ZHdhEreiJmuSQiQSjn9cwR/4RhPfN9d6Db/7dsE=
X-Received: from pjbqd16.prod.google.com ([2002:a17:90b:3cd0:b0:31c:15e1:d04])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:134f:b0:312:639:a064
 with SMTP id 98e67ed59e1d1-31c9f43748bmr36022174a91.28.1753194744117; Tue, 22
 Jul 2025 07:32:24 -0700 (PDT)
Date: Tue, 22 Jul 2025 07:32:22 -0700
In-Reply-To: <CA+EHjTzNDrwzdpoEuiqvzk3-A7LAsdJ-6y-Gcj7h7+dUTh=6pw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-12-tabba@google.com>
 <8340ec70-1c44-47a7-8c48-89e175501e89@intel.com> <aH7KghhsjaiIL3En@google.com>
 <c35b8c34-2736-45fe-8a97-bfedbf72537e@intel.com> <CA+EHjTzNDrwzdpoEuiqvzk3-A7LAsdJ-6y-Gcj7h7+dUTh=6pw@mail.gmail.com>
Message-ID: <aH-g9o5hSMvVRxAP@google.com>
Subject: Re: [PATCH v15 11/21] KVM: x86/mmu: Allow NULL-able fault in kvm_max_private_mapping_level
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 22, 2025, Fuad Tabba wrote:
> On Tue, 22 Jul 2025 at 06:36, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> > - In 0010-KVM-x86-mmu-Rename-.private_max_mapping_level-to-.gm.patch,
> > there is double gmem in the name of vmx/vt 's callback implementation:
> >
> >      vt_gmem_gmem_max_mapping_level
> >      tdx_gmem_gmem_max_mapping_level
> >      vt_op_tdx_only(gmem_gmem_max_mapping_level)
> 
> Sean's patches do that, then he fixes it in a later patch. I'll fix
> this at the source.

Dagnabbit.  I goofed a search+replace, caught it when re-reading things, and
fixed-up the wrong commit.  Sorry :-(

> > - In 0013-KVM-x86-mmu-Extend-guest_memfd-s-max-mapping-level-t.patch,
> >    kvm_x86_call(gmem_max_mapping_level)(...) returns 0 for !private case.
> >    It's not correct though it works without issue currently.
> >
> >    Because current gmem doesn't support hugepage so that the max_level
> >    gotten from gmem is always PG_LEVEL_4K and it returns early in
> >    kvm_gmem_max_mapping_level() on
> >
> >         if (max_level == PG_LEVEL_4K)
> >                 return max_level;
> >
> >    But just look at the following case:
> >
> >      return min(max_level,
> >         kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private));
> >
> >    For non-TDX case and non-SNP case, it will return 0, i.e.
> >    PG_LEVEL_NONE eventually.
> >
> >    so either 1) return PG_LEVEL_NUM/PG_LEVEL_1G for the cases where
> >    .gmem_max_mapping_level callback doesn't have specific restriction.
> >
> >    or 2)
> >
> >         tmp = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
> >         if (tmp)
> >                 return min(max_level, tmp);
> >
> >         return max-level;
> 
> Sean? What do you think?

#2, because KVM uses a "ret0" static call when TDX is disabled (and KVM should
do the same when SEV is disabled, but the SEV #ifdefs are still a bit messy).
Switching to any other value would require adding a VMX stubs for the !TDX case.

I think it makes sense to explicitly call that out as the "CoCo level", to help
unfamiliar readers understand why vendor code has any say in the max
mapping level.

And I would say we adjust max_level instead of having an early return, e.g. to
reduce the probability of future bugs due to adding code between the call to
.gmem_max_mapping_level() and the final return.

This as fixup? 

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index eead5dca6f72..a51013e0992a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3279,9 +3279,9 @@ static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fau
                                     const struct kvm_memory_slot *slot, gfn_t gfn,
                                     bool is_private)
 {
+       u8 max_level, coco_level;
        struct page *page;
        kvm_pfn_t pfn;
-       u8 max_level;
 
        /* For faults, use the gmem information that was resolved earlier. */
        if (fault) {
@@ -3305,8 +3305,16 @@ static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fau
        if (max_level == PG_LEVEL_4K)
                return max_level;
 
-       return min(max_level,
-                  kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private));
+       /*
+        * CoCo may influence the max mapping level, e.g. due to RMP or S-EPT
+        * restrictions.  A return of '0' means "no additional restrictions",
+        * to allow for using an optional "ret0" static call.
+        */
+       coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
+       if (coco_level)
+               max_level = min(max_level, coco_level);
+
+       return max_level;
 }
 
 int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
