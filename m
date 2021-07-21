Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1746CC636C9
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 13:35:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7B50961241
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 13:35:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B50961241
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED1D84B110;
	Wed, 21 Jul 2021 09:35:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tNKS947EZY5e; Wed, 21 Jul 2021 09:35:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF4184B0E9;
	Wed, 21 Jul 2021 09:35:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D8B74B0E9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 09:35:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ff7BOz-lUmU0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 09:35:35 -0400 (EDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C59454A483
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 09:35:35 -0400 (EDT)
Received: by mail-wm1-f47.google.com with SMTP id f190so1338261wmf.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 06:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=THtvL95+Wdg5XKa0Q6wjHIENl0Y9TZHt3CwdcuBkgF8=;
 b=dYzzqSbTcHoAKX52adHhFah33UAvJMaxB1AIimYVp8/ShQNJyvzpQuyW4v9H9wQS7C
 9oUflpJc11rRJeujwNJ/0OaIN7oOBEwVF7hMZpgJorzEtN81xw7UznEeWpFXOCMU+9Yf
 vvlCvBwEaXtKD+Mit2oA1qgc2x2cQOCvdQD8ad6Jmyx3IV+U1K1ht0zp7+FRoLComa9z
 7nyg//dnCxl4r1LGd2OmqdUp+AIhctUAyBKbvsw/8+fgpsxlsGVuOTjFWbitTHU3+qua
 iXTTZxxsP4ssGpvdcORzQIsJquYp1mYs6zK7WvpK/a82z1I5x6mBKwGwDf4o5qiqrpRR
 CN8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=THtvL95+Wdg5XKa0Q6wjHIENl0Y9TZHt3CwdcuBkgF8=;
 b=Rp9p0tw8D9vr5jYO4pEhqUuesQQvJwIKOKNlWrA98MX+nzNiEBdEqzb1gu3pZpehzN
 +rDIQ4Nq1B97IV7Gl+KpMUqWUy06+N6t+P5Ior7nPclkJrMPQc38z5ct1Swcm5BHl/Wm
 +ndICox+bm/bmjtuQUf9BAvF12Ah5oVTemG2aRSD3KNPkMnoXtAr6++sczP3L7al73xf
 2VikgLmn/tB3CJC1bWoPeAm2NtjNZjxM95IFUg9TXfghjknzUEHs3rhq+pozft49QvHY
 YEc82wI+Fgj3RxxYdrO9gcpcL1aVZ4p0K43lUlGqMmViEZcukIiEk5714gRWY9JyCjGG
 rfrg==
X-Gm-Message-State: AOAM532PvsI3hy94/4uSLpfN9D+3gtPL2uawrcJIQowRfKxHgquXp4lR
 Jks3fPtfGExfMKClD6eiJMjHyg==
X-Google-Smtp-Source: ABdhPJyciOXfOFa9KQ+iYzD+QsJY74g96fGc86hUOZHCThYzhTYjYByChhSiI5DH0qDjIx7s8PRrdA==
X-Received: by 2002:a1c:1bc3:: with SMTP id b186mr4197684wmb.27.1626874534544; 
 Wed, 21 Jul 2021 06:35:34 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:efb1:2fcc:e84:52ad])
 by smtp.gmail.com with ESMTPSA id e11sm33189602wrt.0.2021.07.21.06.35.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Jul 2021 06:35:34 -0700 (PDT)
Date: Wed, 21 Jul 2021 14:35:30 +0100
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 13/14] KVM: arm64: Restrict hyp stage-1 manipulation in
 protected mode
Message-ID: <YPgion9+okAtvkr4@google.com>
References: <20210719104735.3681732-1-qperret@google.com>
 <20210719104735.3681732-14-qperret@google.com>
 <CA+EHjTzpoX+rLQHwUbR3BVY_XJEWERiG4AGk7SW6GDtDFC_cuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+EHjTzpoX+rLQHwUbR3BVY_XJEWERiG4AGk7SW6GDtDFC_cuQ@mail.gmail.com>
Cc: kernel-team@android.com, qwandor@google.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Fuad,

On Wednesday 21 Jul 2021 at 11:45:53 (+0100), Fuad Tabba wrote:
> > +static int hyp_range_is_shared_walker(u64 addr, u64 end, u32 level,
> > +                                     kvm_pte_t *ptep,
> > +                                     enum kvm_pgtable_walk_flags flag,
> > +                                     void * const arg)
> > +{
> > +       enum kvm_pgtable_prot prot;
> > +       kvm_pte_t pte = *ptep;
> > +
> > +       if (!kvm_pte_valid(pte))
> > +               return -EPERM;
> > +
> > +       prot = kvm_pgtable_hyp_pte_prot(pte);
> > +       if (!prot)
> > +               return -EPERM;
> nit: is this check necessary?

I guess not, the next one should do, I'll remove :)

> > +       /* Check that the page has been shared with the hypervisor before */
> > +       if (prot != (PAGE_HYP | KVM_PGTABLE_STATE_SHARED | KVM_PGTABLE_STATE_BORROWED))
> > +               return -EPERM;
> > +
> > +       return 0;
> > +}
> > +
> > +static int hyp_range_is_shared(phys_addr_t start, phys_addr_t end)
> > +{
> > +       struct kvm_pgtable_walker walker = {
> > +               .cb = hyp_range_is_shared_walker,
> > +               .flags = KVM_PGTABLE_WALK_LEAF,
> > +       };
> > +
> > +       return kvm_pgtable_walk(&pkvm_pgtable, (u64)__hyp_va(start),
> > +                               end - start, &walker);
> > +}
> > +
> > +static int check_host_share_hyp_walker(u64 addr, u64 end, u32 level,
> 
> nit: It seems the convention is usually addr,size or start,end. Here
> you're using addr,end.

Well for some reason all the walkers in pgtable.c follow the addr,end
convention, so I followed that. But in fact, as per [1] I might actually
get rid of this walker in v2, so hopefully that'll make the issue go
away.

[1] https://lore.kernel.org/kvmarm/YPbwmVk1YD9+y7tr@google.com/

> > +                                      kvm_pte_t *ptep,
> > +                                      enum kvm_pgtable_walk_flags flag,
> > +                                      void * const arg)
> > +{
> > +       enum kvm_pgtable_prot prot;
> > +       kvm_pte_t pte = *ptep;
> > +
> > +       /* If invalid, only allow to share pristine pages */
> > +       if (!kvm_pte_valid(pte))
> > +               return pte ? -EPERM : 0;
> > +
> > +       prot = kvm_pgtable_stage2_pte_prot(pte);
> > +       if (!prot)
> > +               return -EPERM;
> > +
> > +       /* Cannot share a page that is not owned */
> > +       if (prot & KVM_PGTABLE_STATE_BORROWED)
> > +               return -EPERM;
> > +
> > +       /* Cannot share a page with restricted access */
> > +       if ((prot & KVM_PGTABLE_PROT_RWX) ^ KVM_PGTABLE_PROT_RWX)
> nit: isn't this clearer as
> 
> if ((prot & KVM_PGTABLE_PROT_RWX) != KVM_PGTABLE_PROT_RWX)

I guess it would be, I'll fix it up.

> > +               return -EPERM;
> > +
> > +       /* Allow double-sharing (requires cross-checking the hyp stage-1) */
> > +       if (prot & KVM_PGTABLE_STATE_SHARED)
> > +               return hyp_range_is_shared(addr, addr + 1);
> 
> Why addr+1, rather than end?

Because 'end' here is the 'end' that was passed to kvm_pgtable_walk()
IIRC. What I want to do here is check if the page I'm currently visiting
is already shared and if so, that it is shared with the hypervisor. But
it's possible that only one page in the range of pages passed to
__pkvm_host_share_hyp is already shared, so I need to check them one by
one.

Anyways, as per the discussion with Marc on [2], I'll probably switch to
only accept sharing one page at a time, so all these issues should just
go away as well!

[2] https://lore.kernel.org/kvmarm/YPa6BGuUFjw8do+o@google.com/

> > +
> > +       return 0;
> > +}
> > +
> > +static int check_host_share_hyp(phys_addr_t start, phys_addr_t end)
> > +{
> > +       struct kvm_pgtable_walker walker = {
> > +               .cb = check_host_share_hyp_walker,
> > +               .flags = KVM_PGTABLE_WALK_LEAF,
> > +       };
> > +
> > +       return kvm_pgtable_walk(&host_kvm.pgt, start, end - start, &walker);
> > +}
> > +
> > +int __pkvm_host_share_hyp(phys_addr_t start, phys_addr_t end)
> > +{
> > +       enum kvm_pgtable_prot prot;
> > +       int ret;
> > +
> > +       if (!range_is_memory(start, end))
> > +               return -EINVAL;
> > +
> > +       hyp_spin_lock(&host_kvm.lock);
> > +       hyp_spin_lock(&pkvm_pgd_lock);
> > +
> > +       ret = check_host_share_hyp(start, end);
> > +       if (ret)
> > +               goto unlock;
> > +
> > +       prot = KVM_PGTABLE_PROT_RWX | KVM_PGTABLE_STATE_SHARED;
> > +       ret = host_stage2_idmap_locked(start, end, prot);
> 
> Just for me to understand this better. The id mapping here, which
> wasn't taking place before this patch, is for tracking, right?

Yes, exactly, I want to make sure to mark the page as shared (and
borrowed) in the relevant page-tables to not forget about it :)

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
