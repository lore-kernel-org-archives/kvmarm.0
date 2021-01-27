Return-Path: <SRS0=cUgw=G6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B26F3C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jan 2021 19:34:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3541C64DA3
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jan 2021 19:34:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3541C64DA3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A5784B38D;
	Wed, 27 Jan 2021 14:34:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id md2522RvFS6Y; Wed, 27 Jan 2021 14:34:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D9B84B2B2;
	Wed, 27 Jan 2021 14:34:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40EB24B310
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2021 13:23:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JLbYg-WiC9sG for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jan 2021 13:23:23 -0500 (EST)
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com
 [209.85.210.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F2F184B240
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2021 13:23:22 -0500 (EST)
Received: by mail-pf1-f178.google.com with SMTP id j12so1722160pfj.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2021 10:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=jJRPrAWF7MFclOHB2Lr1Il6UnBQA+yMSwpuT+dr3FeE=;
 b=p+JOm0MaAq0DKLuPmm62TKPoLEb63Ivgqxil78dFCdEx4sz1UgEhA/sr1202i1f6fO
 gP7dBosWqWE8SEl5Q9bXMvRttmO8MBkch9w74sMo3b4uL32ehzuvDUOBIATwr0R0jhK0
 wGRAbqIP9ZOtS4RGRPo2nOos/oPULUsm4x6AllyAgIBAyWdz6upYM6KonsT6v1VM7h02
 rCbHzpgKaZvHxKNM2a0EAofk1HjicEqG+hgMq7srXFKGVCqhp+ey+fC+nLuHf0PTADwe
 rQtWBV+yPvFIpO4pNyMKRoWlZirWQrvsMnCt7yvFN3uXHS8Umhyg+bkawtJCTQvJHdiF
 ARtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=jJRPrAWF7MFclOHB2Lr1Il6UnBQA+yMSwpuT+dr3FeE=;
 b=ZsS1eT/pVsXlbEhto/d0sL81VJ/3szdY+USD4UPQxKDviHWacwKsJaaQYWtrivuDOd
 8AJAK9jP33L1L/0WaAioha9qgKMkd7SFzZXCtJMSVJrqLClIjuINqGkxtS0mczVqK3p5
 t015DJtlvFgztOEqc/dn7aOcr6MYKgS9jTS5JJdv+SOHKGeMoyXuQZHiJvELjTSeVNGm
 6/EIjPE7ygk7PwDsd3O90+iNlJSMvxwWLxsfDLhMlYMvad6yjkKmrunl1O9xFbnCsyWx
 4jI5o54ZxowX1DkD6iRjU1MznWCdxqQEmqorur7EvX78ZQ0ytx8fXGUJvm2JEvN0TIJ8
 CeJg==
X-Gm-Message-State: AOAM531aqw+FQ1M1zsSpxbV5a6r4dKFNTSGQtzK0ApI9WgFkx9TnuGmd
 VgMn0rciBvZOw6Yw1LZXXXVuAQ==
X-Google-Smtp-Source: ABdhPJwSTnTQ18ANJPAv6GUZl6bhKkOAA3IiPI3vNrcPn/QyI7/VnJlki21EIEAx7yZmuM3T0cOiNg==
X-Received: by 2002:a63:5459:: with SMTP id e25mr1610122pgm.403.1611771801851; 
 Wed, 27 Jan 2021 10:23:21 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 by smtp.gmail.com with ESMTPSA id m73sm3022198pga.25.2021.01.27.10.23.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 27 Jan 2021 10:23:21 -0800 (PST)
Date: Wed, 27 Jan 2021 10:23:14 -0800
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v2] KVM: x86/mmu: consider the hva in mmu_notifier retry
Message-ID: <YBGvku1KUUk6LPAj@google.com>
References: <20210127024504.613844-1-stevensd@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MkeFThl52DvUx8zi"
Content-Disposition: inline
In-Reply-To: <20210127024504.613844-1-stevensd@google.com>
X-Mailman-Approved-At: Wed, 27 Jan 2021 14:34:27 -0500
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--MkeFThl52DvUx8zi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 27, 2021, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Track the range being invalidated by mmu_notifier and skip page fault
> retries if the fault address is not affected by the in-progress
> invalidation. Handle concurrent invalidations by finding the minimal
> range which includes all ranges being invalidated. Although the combined
> range may include unrelated addresses and cannot be shrunk as individual
> invalidation operations complete, it is unlikely the marginal gains of
> proper range tracking are worth the additional complexity.
> 
> The primary benefit of this change is the reduction in the likelihood of
> extreme latency when handing a page fault due to another thread having
> been preempted while modifying host virtual addresses.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
> v1 -> v2:
>  - improve handling of concurrent invalidation requests by unioning
>    ranges, instead of just giving up and using [0, ULONG_MAX).

Ooh, even better.

>  - add lockdep check
>  - code comments and formatting
> 
>  arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
>  arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
>  arch/x86/kvm/mmu/mmu.c                 | 16 ++++++++------
>  arch/x86/kvm/mmu/paging_tmpl.h         |  7 ++++---
>  include/linux/kvm_host.h               | 27 +++++++++++++++++++++++-
>  virt/kvm/kvm_main.c                    | 29 ++++++++++++++++++++++----
>  6 files changed, 67 insertions(+), 16 deletions(-)
> 

...

> @@ -3717,7 +3720,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
>  
> -	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
> +	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, &hva,
> +			 write, &map_writable))
>  		return RET_PF_RETRY;
>  
>  	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
> @@ -3725,7 +3729,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>  
>  	r = RET_PF_RETRY;
>  	spin_lock(&vcpu->kvm->mmu_lock);
> -	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
> +	if (mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))

'hva' will be uninitialized at this point if the gfn did not resolve to a
memslot, i.e. when handling an MMIO page fault.  On the plus side, that's an
opportunity for another optimization as there is no need to retry MMIO page
faults on mmu_notifier invalidations.  Including the attached patch as a preqreq
to this will avoid consuming an uninitialized 'hva'.


>  		goto out_unlock;
>  	r = make_mmu_pages_available(vcpu);
>  	if (r)

...

>  void kvm_release_pfn_clean(kvm_pfn_t pfn);
>  void kvm_release_pfn_dirty(kvm_pfn_t pfn);
> @@ -1203,6 +1206,28 @@ static inline int mmu_notifier_retry(struct kvm *kvm, unsigned long mmu_seq)
>  		return 1;
>  	return 0;
>  }
> +
> +static inline int mmu_notifier_retry_hva(struct kvm *kvm,
> +					 unsigned long mmu_seq,
> +					 unsigned long hva)
> +{
> +#ifdef CONFIG_LOCKDEP
> +	lockdep_is_held(&kvm->mmu_lock);

No need to manually do the #ifdef, just use lockdep_assert_held instead of
lockdep_is_held.

> +#endif
> +	/*
> +	 * If mmu_notifier_count is non-zero, then the range maintained by
> +	 * kvm_mmu_notifier_invalidate_range_start contains all addresses that
> +	 * might be being invalidated. Note that it may include some false
> +	 * positives, due to shortcuts when handing concurrent invalidations.
> +	 */
> +	if (unlikely(kvm->mmu_notifier_count) &&
> +	    kvm->mmu_notifier_range_start <= hva &&
> +	    hva < kvm->mmu_notifier_range_end)

Uber nit: I find this easier to read if 'hva' is on the left-hand side for both
checks, i.e.

	if (unlikely(kvm->mmu_notifier_count) &&
	    hva >= kvm->mmu_notifier_range_start &&
	    hva < kvm->mmu_notifier_range_end)

> +		return 1;
> +	if (kvm->mmu_notifier_seq != mmu_seq)
> +		return 1;
> +	return 0;
> +}
>  #endif
>  
>  #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING

--MkeFThl52DvUx8zi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-x86-mmu-Skip-mmu_notifier-check-when-handling-MM.patch"

From a1bfdc6fe16582440815cfecc656313dff993003 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Jan 2021 10:04:45 -0800
Subject: [PATCH] KVM: x86/mmu: Skip mmu_notifier check when handling MMIO page
 fault

Don't retry a page fault due to an mmu_notifier invalidation when
handling a page fault for a GPA that did not resolve to a memslot, i.e.
an MMIO page fault.  Invalidations from the mmu_notifier signal a change
in a host virtual address (HVA) mapping; without a memslot, there is no
HVA and thus no possibility that the invalidation is relevant to the
page fault being handled.

Note, the MMIO vs. memslot generation checks handle the case where a
pending memslot will create a memslot overlapping the faulting GPA.  The
mmu_notifier checks are orthogonal to memslot updates.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 2 +-
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6d16481aa29d..9ac0a727015d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3725,7 +3725,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
+	if (!is_noslot_pfn(pfn) && mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
 	r = make_mmu_pages_available(vcpu);
 	if (r)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 50e268eb8e1a..ab54263d857c 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -869,7 +869,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 
 	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
+	if (!is_noslot_pfn(pfn) && mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
 
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
-- 
2.30.0.280.ga3ce27912f-goog


--MkeFThl52DvUx8zi
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--MkeFThl52DvUx8zi--
