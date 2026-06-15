Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AA818CBE1
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 18:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781546965; cv=none; b=NogWBm3o8iizznusuicheWSHk07nW4Th7Ofqn2VF/Ce9VEQxVWb3MsleCZP0prIqB/XuYRZNeL7Xu5Klq4Hr61mQau83x6f2poXfnxp0zSruZx2zChnzw08Xu/OFP9ZuKE41hD+RZMqfwrccbOAgfWvCla5MLWnJmqFPClmJVdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781546965; c=relaxed/simple;
	bh=cIcn2xttQ5klb0NyKZZ5C7CekwHC9plrngiBWprQ1W8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CBOfvyAzYOglEfiOCY0bzy1Q98DeJ6h4xK+++YKRL0YluzhpiOowTN/8sUXhaAdS5Akp1a0tdL0bauCr67H4+XriNkpuGBQ6Cv0xjkz1qBBGHAyHFkuRw67fD5xW0nyR/ZPlGq9CsjDNEvHYTOaXkZg2IowMQGzXBj7br8QHflQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eUU01Ycv; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eUU01Ycv"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c85dc345ac8so2040326a12.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 11:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781546962; x=1782151762; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nnv7BB4g0plBk06nDCaqvSeCAkEy9nM4C7RFf19+vk4=;
        b=eUU01YcvZtKiBGknKCF3JEb1E/AwPtpkdpOUJLyAtuBRdTI6FFuM3IHbpTc+x9NtPz
         IcR3mRTUCHAov+v7G99XIdn8mbV0OCSV1ZoLkEb27evf27nnaU6DK2qPG1tjghb1rEzj
         7kfu7EDIfCgUb6U+hm0UArMiS0N/9wPAbk+GqZ5ZnvBGlkM50OSajVuwiq5BaqX26TJC
         hjpuohfZWoNKrYUQ/zsraxUXw08rlT9WFBGQXYlpvASJUmJ+SPfD8Qa5pJbcVZo3Akwp
         3j6Nwx3nKZPPZ8CC+2OKSoQ/9nmkyVifHwI7U/qDNW4b8Z/rJMqlB/EWkxrHorKcq183
         vPmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781546962; x=1782151762;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nnv7BB4g0plBk06nDCaqvSeCAkEy9nM4C7RFf19+vk4=;
        b=LslCgYlL+/QHZmPEn8dcd0DRgYu41no2xVsxONuA3jf661LEhYkA1dRk01IYCZHvfX
         aV2YGw78PEkaJkCMTYzY+I8LzrrKlx9RPxuSC3eCBxLmBkSKB2WMjxKOJqpUyr4+iBbZ
         WdighAMrXq01UIN2iiFzWJiwgWcYud5RlXPjV7qSfPhuPF1AoJHT6T7xiju3pdfsW2tN
         tE0AkmsR5VWgfPXD1E7UWD7OFeRPLANfuWy9z2roZaCMoiCmbdPvBY/pSmF+kBN/ydSK
         GsmV9uYWsjQPNIxcaGv8d6xmW5f+f5jncWyASwD/WJbjoRI9oG/0fBpM9DoTTJ6g4QiZ
         foxQ==
X-Forwarded-Encrypted: i=1; AFNElJ/NUrlAd4FmvjM9mlxe+FPjQhalgdHUJ/au0Rjg7+UxAboSClRhOLdIAujGXCFLdihdAYr06X8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyby9QR8lnm5snS3gnqBcWrZnr52YqODXRizeSTayOW4i2v+vvG
	o0pAiKmeBhBEI6QKjAnih3OBRQIiC6duEBf4dM+TXs6H2KapKitbDj0VYgPkzW9hRLmXCRGeinK
	5+zebOA==
X-Received: from pgy34.prod.google.com ([2002:a63:1862:0:b0:c85:88eb:3619])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:2986:b0:3b4:b276:c5dc
 with SMTP id adf61e73a8af0-3b79624ea92mr13440922637.3.1781546962414; Mon, 15
 Jun 2026 11:09:22 -0700 (PDT)
Date: Mon, 15 Jun 2026 11:09:21 -0700
In-Reply-To: <ajA6ogaNiI3KDv5i@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260615155244.183044-1-alexandru.elisei@arm.com>
 <20260615160901.9A1A61F000E9@smtp.kernel.org> <ajA6ogaNiI3KDv5i@google.com>
Message-ID: <ajA_0TQCQLSz7qcU@google.com>
Subject: Re: [RFC PATCH] KVM: Ignore MMU notifiers for guest_memfd-only memslots
From: Sean Christopherson <seanjc@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 15, 2026, Sean Christopherson wrote:
> On Mon, Jun 15, 2026, sashiko-bot@kernel.org wrote:
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > [ ... ]
> > > @@ -592,6 +592,10 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
> > >  			unsigned long hva_start, hva_end;
> > >  
> > >  			slot = container_of(node, struct kvm_memory_slot, hva_node[slots->node_idx]);
> > > +
> > > +			if (kvm_slot_has_gmem(slot) && kvm_memslot_is_gmem_only(slot))
> > > +				continue;
> > > +
> > 
> > [Severity: Critical]
> > Does this change inadvertently introduce a regression in the pfncache retry
> > protocol?
> > 
> > Looking at the pfncache framework, it maps guest memory into kernel space and
> > explicitly drops the page reference after mapping it:
> > 
> > virt/kvm/pfncache.c:hva_to_pfn_retry() {
> >     ...
> >     kvm_release_page_clean(page);
> >     ...
> > }
> > 
> > It appears to rely entirely on KVM's MMU notifiers (kvm->mmu_invalidate_seq)
> > to invalidate the cache when the page is unmapped by the host.
> > 
> > If a VMM defines a guest_memfd-backed memslot with KVM_MEMSLOT_GMEM_ONLY
> > but still provides a valid anonymous user mapping as its userspace_addr,
> > could this regression lead to a use-after-free?
> 
> Sadly, yes.  To land this, we would need to first teach the gfn_to_pfn_cache code
> to be able to pull directly from guest_memfd.  I forget if anyone is working on
> that.

Actually, we just need to ensure the invalidation tracking is updated, the MMU
itself can be left as-is.

Compile tested only, but this?

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 27498e990dff..690ab707816b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -260,6 +260,7 @@ union kvm_mmu_notifier_arg {
 enum kvm_gfn_range_filter {
        KVM_FILTER_SHARED               = BIT(0),
        KVM_FILTER_PRIVATE              = BIT(1),
+       KVM_FILTER_USERSPACE_MAPPINGS   = BIT(2),
 };
 
 struct kvm_gfn_range {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e44c20c04961..84b693de7e35 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -608,7 +608,8 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
                         * HVA-based notifications aren't relevant to private
                         * mappings as they don't have a userspace mapping.
                         */
-                       gfn_range.attr_filter = KVM_FILTER_SHARED;
+                       gfn_range.attr_filter = KVM_FILTER_SHARED |
+                                               KVM_FILTER_USERSPACE_MAPPINGS;
 
                        /*
                         * {gfn(page) | page intersects with [hva_start, hva_end)} =
@@ -715,6 +716,21 @@ void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end)
 bool kvm_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
        kvm_mmu_invalidate_range_add(kvm, range->start, range->end);
+
+       /*
+        * When reacting to changes in userspace mappings, don't unmap memslots
+        * that are guest_memfd-only, in which case KVM's MMU mappings are
+        * pulled directly from guest_memfd, i.e. don't depend on the userspace
+        * mappings.
+        *
+        * TODO: Skip gmem-only memslots on mmu_notifier events entirely, once
+        * gfn_to_pfn_cache is also wired up to directly pull from guest_memfd.
+        */
+       if (range->attr_filter & KVM_FILTER_USERSPACE_MAPPINGS &&
+           kvm_slot_has_gmem(range->slot) &&
+           kvm_memslot_is_gmem_only(range->slot))
+               return false;
+
        return kvm_unmap_gfn_range(kvm, range);
 }
