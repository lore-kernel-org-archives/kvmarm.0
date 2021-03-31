Return-Path: <SRS0=odEw=I6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41931C433ED
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 09:28:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9271B60FE9
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 09:28:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9271B60FE9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE0E34B616;
	Thu,  1 Apr 2021 05:28:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id puwu2v0CR9lx; Thu,  1 Apr 2021 05:28:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 711CD4B61D;
	Thu,  1 Apr 2021 05:28:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55F9C4B48A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 12:20:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wg8CsbGNvx9P for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Mar 2021 12:20:26 -0400 (EDT)
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com
 [209.85.210.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D4364B486
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 12:20:26 -0400 (EDT)
Received: by mail-pf1-f175.google.com with SMTP id h3so14896400pfr.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Mar 2021 09:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=hbFgBS0tsmLZecdBb34MxnZHD2vsOnYlgFmBhEC+AGM=;
 b=W6gYHfyq+FLodOWhD9srXTh8aaio7ufLJGiEJEiMEepafRE4jD5CPt2u6zyCqNkmEf
 RBW97ptdPXvm5UekA+1t/rKsqmWK0oYE75ZvbG8qPcwUeH2CNY8N2JYzQdJbcC/FqLox
 DcD9DWu45srgtpcHvYUIYloa787DwMs9RQszqMJAGT7a/cdNDkSzvp8GETRb/h8dEjgP
 8s6cZSDU08hOz+njpFIAcEg7jI2UFPlQ/B0ogtWJ4tAdwpEoVAvBIo0c7kJY+qV4PKbI
 5JrEg5cZ6lg6SU1xy6TAmWN7lx027fNcjkiELq9jkPTEPVzyTbPPJIMZcf+zN1WRmx+V
 ubUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=hbFgBS0tsmLZecdBb34MxnZHD2vsOnYlgFmBhEC+AGM=;
 b=XX72Wf3AvTrTAB1TfasbHZs4pmwlfr43v2w3ViAaP38Y5gVRnB7ybdyoXe3yPH5WcP
 bWbB/SQZkCJk0wzUppToR115J7zLOsyauF1J8s0gNS85EkL3TJJ5biHJxgdKnlXAUHRj
 d7ev9sPHkdz1j+eKVHtdBQiG/h0jj/63mPVmRWIZzw/fZMJDOEGcDwyzJ0Hbtx2j2FKc
 +RbKX8T2l7iRy8xJ8uNnbI9tfchI/QZ5F9xgUk5NTtUANfHnxL6x2rNvBWjWESvdq2In
 26g5G7/+EvQQy7xVkc41TTH3+nCiY/4+Ug+m/SN6H5r+487nS3Tu0E7JjTaxmyLOQo5u
 yxPg==
X-Gm-Message-State: AOAM531bwTFb4FQLVjmQ0s/0A4qQIQshRxAt9fAHHtgiLsHIQ7DPadTz
 pAw9tveN5PheTdIZbiEOqm/KQw==
X-Google-Smtp-Source: ABdhPJyEnoIvLhWAi7NNGEWROpPtFz0kvkUm7Uq+sDDKk3AwLz6Jre1P4F3JOHb9hmWMRVWQ5USifw==
X-Received: by 2002:a65:428b:: with SMTP id j11mr3941343pgp.47.1617207624928; 
 Wed, 31 Mar 2021 09:20:24 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com.
 [35.247.111.240])
 by smtp.gmail.com with ESMTPSA id h19sm2862436pfc.172.2021.03.31.09.20.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 31 Mar 2021 09:20:24 -0700 (PDT)
Date: Wed, 31 Mar 2021 16:20:20 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 10/18] KVM: Move x86's MMU notifier memslot walkers to
 generic code
Message-ID: <YGShRP9E49p3vcos@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-11-seanjc@google.com>
 <ba3f7a9c-0b59-cbeb-5d46-4236cde2c51f@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ba3f7a9c-0b59-cbeb-5d46-4236cde2c51f@redhat.com>
X-Mailman-Approved-At: Thu, 01 Apr 2021 05:28:17 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 linux-arm-kernel@lists.infradead.org, Ben Gardon <bgardon@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Mar 31, 2021, Paolo Bonzini wrote:
> On 26/03/21 03:19, Sean Christopherson wrote:
> > +#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
> > +	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
> > +#else
> >   	struct kvm *kvm = mmu_notifier_to_kvm(mn);
> >   	int idx;
> >  	trace_kvm_set_spte_hva(address);
> > 	idx = srcu_read_lock(&kvm->srcu);
> > 
> > 	KVM_MMU_LOCK(kvm);
> > 
> > 	kvm->mmu_notifier_seq++;
> > 
> > 	if (kvm_set_spte_hva(kvm, address, pte))
> > 		kvm_flush_remote_tlbs(kvm);
> > 
> >   	KVM_MMU_UNLOCK(kvm);
> >   	srcu_read_unlock(&kvm->srcu, idx);
> > +#endif
> 
> The kvm->mmu_notifier_seq is missing in the new API side.  I guess you can
> add an argument to __kvm_handle_hva_range and handle it also in patch 15
> ("KVM: Take mmu_lock when handling MMU notifier iff the hva hits a
> memslot").

Yikes.  Superb eyes!

That does bring up an oddity I discovered when digging into this.  Every call
to .change_pte() is bookended by .invalidate_range_{start,end}(), i.e. the above
missing kvm->mmu_notifier_seq++ is benign because kvm->mmu_notifier_count is
guaranteed to be non-zero.

I'm also fairly certain it means kvm_set_spte_gfn() is effectively dead code on
_all_ architectures.  x86 and MIPS are clearcut nops if the old SPTE is
not-present, and that's guaranteed due to the prior invalidation.  PPC simply
unmaps the SPTE, which again should be a nop due to the invalidation.  arm64 is
a bit murky, but if I'm reading the code correctly, it's also a nop because
kvm_pgtable_stage2_map() is called without a cache pointer, which I think means
it will map an entry if and only if an existing PTE was found.

I haven't actually tested the above analysis, e.g. by asserting that
kvm->mmu_notifier_count is indeed non-zero.  I'll do that sooner than later.
But, given the shortlog of commit:

  6bdb913f0a70 ("mm: wrap calls to set_pte_at_notify with invalidate_range_start
                 and invalidate_range_end")

I'm fairly confident my analysis is correct.  And if so, it also means that the
whole point of adding .change_pte() in the first place (for KSM, commit
828502d30073, "ksm: add mmu_notifier set_pte_at_notify()"), has since been lost.

When it was originally added, .change_pte() was a pure alternative to
invalidating the entry.

  void __mmu_notifier_change_pte(struct mm_struct *mm, unsigned long address,
                               pte_t pte)
  {
        struct mmu_notifier *mn;
        struct hlist_node *n;

        rcu_read_lock();
        hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_mm->list, hlist) {
                if (mn->ops->change_pte)
                        mn->ops->change_pte(mn, mm, address, pte);
                /*
                 * Some drivers don't have change_pte,
                 * so we must call invalidate_page in that case.
                 */
                else if (mn->ops->invalidate_page)
                        mn->ops->invalidate_page(mn, mm, address);
        }
        rcu_read_unlock();
  }

The aforementioned commit 6bdb913f0a70 wrapped set_pte_at_notify() with
invalidate_range_{start,end}() so that .invalidate_page() implementations could
sleep.  But, no one noticed that in doing so, .change_pte() was completely
neutered.

Assuming all of the above is correct, I'm very tempted to rip out .change_pte()
entirely.  It's been dead weight for 8+ years and no one has complained about
KSM+KVM performance (I'd also be curious to know how much performance was gained
by shaving VM-Exits).  As KVM is the only user of .change_pte(), dropping it in
KVM would mean the entire MMU notifier could also go away.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
