Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A480FC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 13:41:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 181EC60698
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 13:41:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 181EC60698
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 824DD4B0F7;
	Wed, 13 Oct 2021 09:41:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KDV7MSFzqhLa; Wed, 13 Oct 2021 09:41:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B34D94B101;
	Wed, 13 Oct 2021 09:41:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14AEE4B0EC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 23:29:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kyf6McBvEnnR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Oct 2021 23:29:47 -0400 (EDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com
 [209.85.219.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E575D405EE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 23:29:47 -0400 (EDT)
Received: by mail-yb1-f171.google.com with SMTP id w10so3054046ybt.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 20:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=K1V9NDATmu17pUoF4QdYlG/zF1QvhHmXa48+FoG1Ebg=;
 b=V4hO+e2bD1JKo+Av7J5TFNJ1Ayzjepp5lrSlnAALB4jkPnPZEm3JE2msYawjx0E+JD
 tymz1KVCEPIHc7Lb1cN8BmImJcbDMIBN1FhakghcvYzmLRFwru1SX8emTJ2jfivukZrU
 17T4/dOBCe4YOLTSInLOyPaslkb0C1DApR82U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=K1V9NDATmu17pUoF4QdYlG/zF1QvhHmXa48+FoG1Ebg=;
 b=ktEGpHsGhswY7fbdDjxJEE+l9wiItO63S+/yK9MNN5y6FxhfofH3o2Nq2rJ3yfCvYe
 y4j9lNFr0+HdNM+V+deAk4/Ki9He9Iix9tODDWWdpGQr9KkHT0yggMj7sE/gMqwzwVUh
 02+hR38tZS4fYYIQovNyAtsJNcJEgZGrW4Ssi9kmol33xuOVX8/9rSkeV7MCjIETayFG
 0tUyGdAz5C/0oBTJdsnCMR8fssBNe0zl6Sjn0CJ7bBlGBwf33ZaxdIP8S6NlW4yZyai2
 iUppkz76L8Jsux80iBxCGMKb16QN6nf1rsk0cxkXgSlT95TnGRjtwY77vniDZ1y2VRMI
 qQcA==
X-Gm-Message-State: AOAM530wil0EKnGcKNxyCdHkrWuKALYtmAuTAhj5ANk/+rPELrh0asqw
 Bo96Xp1qWLyQDPsYjv9ixxuOsU5Xxm1twxutxM7D0g==
X-Google-Smtp-Source: ABdhPJxq87bgca01rLjYkuSh5HTdIgTMzvRne9NDRirxkvsd38A826PPWMoXsd9Iv9DztgPg8Lkfu/gUc5455msojX4=
X-Received: by 2002:a25:22d7:: with SMTP id
 i206mr34357892ybi.355.1634095787342; 
 Tue, 12 Oct 2021 20:29:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210929042908.1313874-1-stevensd@google.com>
 <20210929042908.1313874-5-stevensd@google.com>
 <YWYiJy1Z7VZ0SxAd@google.com>
In-Reply-To: <YWYiJy1Z7VZ0SxAd@google.com>
From: David Stevens <stevensd@chromium.org>
Date: Wed, 13 Oct 2021 12:29:36 +0900
Message-ID: <CAD=HUj5HCdBBU2z=yJCCiAhTj0ARj-8XpLqdVbam7Kt9af+SSA@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] KVM: mmu: remove over-aggressive warnings
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Wed, 13 Oct 2021 09:41:27 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 open list <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Wed, Oct 13, 2021 at 9:02 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Sep 29, 2021, David Stevens wrote:
> > From: David Stevens <stevensd@chromium.org>
> >
> > Remove two warnings that require ref counts for pages to be non-zero, as
> > mapped pfns from follow_pfn may not have an initialized ref count.
> >
> > Signed-off-by: David Stevens <stevensd@chromium.org>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 7 -------
> >  virt/kvm/kvm_main.c    | 2 +-
> >  2 files changed, 1 insertion(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 5a1adcc9cfbc..3b469df63bcf 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -617,13 +617,6 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
> >
> >       pfn = spte_to_pfn(old_spte);
> >
> > -     /*
> > -      * KVM does not hold the refcount of the page used by
> > -      * kvm mmu, before reclaiming the page, we should
> > -      * unmap it from mmu first.
> > -      */
> > -     WARN_ON(!kvm_is_reserved_pfn(pfn) && !page_count(pfn_to_page(pfn)));
>
> Have you actually observed false positives with this WARN?  I would expect anything
> without a struct page to get filtered out by !kvm_is_reserved_pfn(pfn).

Those are the type of pfns that were responsible for CVE-2021-22543
[1]. One specific example is that amdgpu uses ttm_pool, which makes
higher order, non-compound allocation. Without the head/tail metadata,
only the first base page in such an allocation has non-zero
page_count.

[1] https://github.com/google/security-research/security/advisories/GHSA-7wq5-phmq-m584

> If you have observed false positives, I would strongly prefer we find a way to
> keep the page_count() sanity check, it has proven very helpful in the past in
> finding/debugging bugs during MMU development.

When we see a refcount of zero, I think we can look up spte->(gfn,
slot)->hva->vma and determine whether or not the zero refcount is
okay, based on vm_flags. That's kind of heavy for a debug check,
although at least we'd only pay the cost for unusual mappings. But it
still might make sense to switch to a MMU_WARN_ON, in that case. Or we
could just ignore the cost, since at least from a superficial reading
and some basic tests, tdp_mmu doesn't seem to execute this code path.

Thoughts? I'd lean towards MMU_WARN_ON, but I'd like to know what the
maintainers' preferences are before sending an updated patch series.

-David

>
> > -
> >       if (is_accessed_spte(old_spte))
> >               kvm_set_pfn_accessed(pfn);
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
