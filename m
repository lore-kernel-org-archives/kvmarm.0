Return-Path: <SRS0=mzoY=IG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 031CCC433E0
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 13:38:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5673F651CD
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 13:38:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5673F651CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF9D54B6F5;
	Mon,  8 Mar 2021 08:38:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AeG7OCE1mfKF; Mon,  8 Mar 2021 08:38:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4907E4B70F;
	Mon,  8 Mar 2021 08:38:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12F974B6F5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 08:38:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zpDcgOaDK3nJ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Mar 2021 08:38:11 -0500 (EST)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com
 [209.85.128.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78D064B6D7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 08:38:11 -0500 (EST)
Received: by mail-wm1-f53.google.com with SMTP id l22so6079158wme.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Mar 2021 05:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=PFBRtObdnApUzRvAuScTx2Kw0ULloMz5ElbqpQCVZ4E=;
 b=DlzGUTmvsB+sDC4hIi5gNvd6CbNk1Tz0/nBGg/8SbC9YimO5Z2Ao2m8EqeETEhTmXH
 gg+bIb953rzFbi0I9YjzrON8nRevQLzIIXHIY/U/AJqjF9kTvmKnuxwuYP8I3NECMxGR
 z6/82TezvDq1Q8Jl48hOqizM545OfysJc0nESM3s9mnWvUtMu1HITc9HAcFu9oiJAotR
 F/w3ueSVFouExv1E7EOGc9FkpX5HY0bZm2Thd14AVt36z4UwYHBYGV1QiJP1Dx3RUsx/
 1UVl+XdfNd9IiYbGp5p8mmvGj/ozNnOuee7lP3M9mD6k1Boi2AtckS0mhwbZ/0MmakvB
 1SFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=PFBRtObdnApUzRvAuScTx2Kw0ULloMz5ElbqpQCVZ4E=;
 b=mK9hYGm2j4jp0KHNOPfZb7m8n7Y7Q5XvEkiW9eUGDG+D/JVPGxPAAVQ5cH3ZpFBM0R
 JFadRZV2bQ+jAvhIpjpvtUhYZ8e8l0L2/fsn6cUCQUWFhEf835tdCb7JsXqawK2HNp3Q
 3PjEsLCGdOPOPwDr9beICSxBhmh9UK9v9LJa8FqLOl+WMQFTXD8rqYgfYs8Xm86i/Z1n
 kGTpABnWHYuM0fCOb7+KVvBS/UGMWLjmYqiM1aNxFp/rIrWeqgSZAr5OrWCYecezxXwh
 6UBeRjvCIfnk2Fl7Nm8yC9pFv896EwQxK5jgTCc/WK20oGFvTOpPonFXz3jUZ0TXncTd
 aIGQ==
X-Gm-Message-State: AOAM531vlmJlBh13jjp7bQCqjFAeT/wJA2KUqDnFLOqxitcK0f7GbIYI
 AbFNha6saUOfLqTaeg7fodOTmA==
X-Google-Smtp-Source: ABdhPJxdMgJt1UHBWtl36bgUKr2lFU/ztPx2Xm8qGG8vibyqeSTLpcrl/63fHe5uBl7JNr0lG8I+yg==
X-Received: by 2002:a1c:7905:: with SMTP id l5mr22576268wme.181.1615210690018; 
 Mon, 08 Mar 2021 05:38:10 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id a5sm18572985wrs.35.2021.03.08.05.38.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 08 Mar 2021 05:38:09 -0800 (PST)
Date: Mon, 8 Mar 2021 13:38:07 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 29/32] KVM: arm64: Wrap the host with a stage 2
Message-ID: <YEYov+r6A3uil1aU@google.com>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-30-qperret@google.com>
 <20210305192905.GE23633@willie-the-truck>
 <YEXs1cOlmhHg4u8x@google.com>
 <20210308124606.GA25879@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210308124606.GA25879@willie-the-truck>
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Monday 08 Mar 2021 at 12:46:07 (+0000), Will Deacon wrote:
> __load_stage2() _only_ has the ISB if ARM64_WORKAROUND_SPECULATIVE_AT is
> present, whereas I think you need one unconditionall here so that the
> system register write has taken effect before the TLB invalidation.
> 
> It's similar to the comment at the end of __tlb_switch_to_guest().
> 
> Having said that, I do worry that ARM64_WORKAROUND_SPECULATIVE_AT probably
> needs a closer look in the world of pKVM, since it currently special-cases
> the host.

Yes, I see that now. I'll start looking into this.

> > > > +	__tlbi(vmalls12e1is);
> > > > +	dsb(ish);
> > > 
> > > Given that the TLB is invalidated on the boot path, please can you add
> > > a comment here about the stale entries which you need to invalidate?
> > 
> > Sure -- that is for HCR bits cached in TLBs for VMID 0. Thinking about
> > it I could probably reduce the tlbi scope as well.
> > 
> > > Also, does this need to be inner-shareable? I thought this function ran on
> > > each CPU.
> > 
> > Hmm, correct, nsh should do.
> 
> Cool, then you can do that for both the TLBI and the DSB instructions (and
> please add a comment that the invalidation is due to the HCR bits).

Sure.

> > > > +static void host_stage2_unmap_dev_all(void)
> > > > +{
> > > > +	struct kvm_pgtable *pgt = &host_kvm.pgt;
> > > > +	struct memblock_region *reg;
> > > > +	u64 addr = 0;
> > > > +	int i;
> > > > +
> > > > +	/* Unmap all non-memory regions to recycle the pages */
> > > > +	for (i = 0; i < hyp_memblock_nr; i++, addr = reg->base + reg->size) {
> > > > +		reg = &hyp_memory[i];
> > > > +		kvm_pgtable_stage2_unmap(pgt, addr, reg->base - addr);
> > > > +	}
> > > > +	kvm_pgtable_stage2_unmap(pgt, addr, ULONG_MAX);
> > > 
> > > Is this just going to return -ERANGE?
> > 
> > Hrmpf, yes, that wants BIT(pgt->ia_bits) I think. And that wants testing
> > as well, clearly.
> 
> Agreed, maybe it's worth checking the return value.

Ack, and hyp_panic if != 0, but that is probably preferable anyway.

> > > > +static int host_stage2_idmap(u64 addr)
> > > > +{
> > > > +	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W;
> > > > +	struct kvm_mem_range range;
> > > > +	bool is_memory = find_mem_range(addr, &range);
> > > > +	struct hyp_pool *pool = is_memory ? &host_s2_mem : &host_s2_dev;
> > > > +	int ret;
> > > > +
> > > > +	if (is_memory)
> > > > +		prot |= KVM_PGTABLE_PROT_X;
> > > > +
> > > > +	hyp_spin_lock(&host_kvm.lock);
> > > > +	ret = kvm_pgtable_stage2_idmap_greedy(&host_kvm.pgt, addr, prot,
> > > > +					      &range, pool);
> > > > +	if (is_memory || ret != -ENOMEM)
> > > > +		goto unlock;
> > > > +	host_stage2_unmap_dev_all();
> > > > +	ret = kvm_pgtable_stage2_idmap_greedy(&host_kvm.pgt, addr, prot,
> > > > +					      &range, pool);
> > > 
> > > I find this _really_ hard to reason about, as range is passed by reference
> > > and we don't reset it after the first call returns -ENOMEM for an MMIO
> > > mapping. Maybe some commentary on why it's still valid here?
> > 
> > Sure, I'll add something. FWIW, that is intended -- -ENOMEM can only be
> > caused by the call to kvm_pgtable_stage2_map() which leaves the range
> > untouched. So, as long as we don't release the lock, the range returned
> > by the first call to kvm_pgtable_stage2_idmap_greedy() should still be
> > valid. I suppose I could call kvm_pgtable_stage2_map() directly the
> > second time to make it obvious but I thought this would expose the
> > internal of kvm_pgtable_stage2_idmap_greedy() a little bit too much.
> 
> I can see it both ways, but updating the kerneldoc for
> kvm_pgtable_stage2_idmap_greedy() to state in which cases the range is
> updated and how would be helpful. It just says "negative error code on
> failure" at the moment.

Alternatively I could expose the 'reduce' path (maybe with another name
e.g. stage2_find_compatible_range() or so) and remove the
kvm_pgtable_stage2_idmap_greedy() wrapper. So it'd be the caller's
responsibility to not release the lock in between
stage2_find_compatible_range() and kvm_pgtable_stage2_map() for
instance, but that sounds reasonable to me. And that would make it
explicit it's the _map() path that failed with -ENOMEM, and that the
range can be re-used the second time.

Thoughts?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
