Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F2F1C433EF
	for <kvmarm@archiver.kernel.org>; Sat, 25 Jun 2022 08:53:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85A914B1CA;
	Sat, 25 Jun 2022 04:53:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nzgCZVkWvUsL; Sat, 25 Jun 2022 04:53:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 459284B1CB;
	Sat, 25 Jun 2022 04:53:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A071413E2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 18:36:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DfaUs-FjSTGL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jun 2022 18:36:45 -0400 (EDT)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23DC641175
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 18:36:45 -0400 (EDT)
Received: by mail-pj1-f47.google.com with SMTP id
 g16-20020a17090a7d1000b001ea9f820449so3965905pjl.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 15:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=JetDtHU3X+1B2pqv06q6XrBYV3K3bGShzpXgJBS5x0g=;
 b=dyEgVIex9SIwN8/Oyba1p0Nc/YJDQKTUUM+mY41FwvpygkyZzf0UtRzkKtS4EIBHHA
 Xck2+vMALl3GyO0YO8LzH+UzcYB+LWSq4wyqHpkd6GB7JHgdEgY4GmC2kYqywMW9wsls
 zHvDQWimUQ2Amyryb6JyWPUCRISy1yFQeB2SK1K2Q1zmns78u8LqMrF2dCe0rnOnEtOS
 s4EI3EPGuqp63XvDPn4eK8iO6Q9nl13rFabYy1ssU8BiQGN2cC5gYvW0Kh0SSQATdEo1
 YR4qTvqz2T8gAwdcHcKLG32P3KZmowtxSSGghozM+FEM9d62/53a/FQfUV/bBixZfntZ
 9BUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=JetDtHU3X+1B2pqv06q6XrBYV3K3bGShzpXgJBS5x0g=;
 b=zKBSKmGIUIa+26zml2WXIghMiMB9K9H1T2QeGKFXCSXA6/bXT6r4k8lIoXM9/MiFLg
 CC0yvWNJZycBxTDmdG2HxH/+ux25EBy4WE63kEbYkN95LkIqHUip1ZH2EcDa3CtiYU4p
 OCh0SRpus0qEOPWTsKBEO6+9YvGYvG52PxYd2hE7cS4DutaVPYe1hfiWdsreE18xFFWH
 b/LCZlE6W1bZGRfmQSmPAbB5Ct1BxapyJNBKpvZsOExmEtn+3JsKQmQkY4fNUS2KTy6x
 ++WCIg3YDEuTWisQN2GPgmp1LA7EnkK5ZBvKZTfTtWKB8w58/Wf4KsW+TciDZuK3gNG4
 EYoQ==
X-Gm-Message-State: AJIora8saqlb9ELBUs6+0ke00gxVax1DCkImGDZiKGCEWliaficGhdmA
 6zBab2Sr92ULjYCEZcDYV6sqdw==
X-Google-Smtp-Source: AGRyM1tvIami/If6+RQSfpCBjEgTqjpFW/6mqfqXNmMf74n8X2WXBnNOJEHAYhBFEwQGjNfyTfwJcg==
X-Received: by 2002:a17:903:10a:b0:16a:2762:88e2 with SMTP id
 y10-20020a170903010a00b0016a276288e2mr21456838plc.22.1656023803838; 
 Thu, 23 Jun 2022 15:36:43 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com.
 [34.125.103.223]) by smtp.gmail.com with ESMTPSA id
 ca27-20020a056a00419b00b00525133f98adsm154148pfb.146.2022.06.23.15.36.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 23 Jun 2022 15:36:42 -0700 (PDT)
Date: Thu, 23 Jun 2022 22:36:37 +0000
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v7 22/23] KVM: x86/mmu: Extend Eager Page Splitting to
 nested MMUs
Message-ID: <YrTq9RU7r05ud+tb@google.com>
References: <20220622192710.2547152-1-pbonzini@redhat.com>
 <20220622192710.2547152-23-pbonzini@redhat.com>
 <CALzav=fH_9_LKVE0_UCftwy2KZaB3nSBoWU07aPWALag4_mcHQ@mail.gmail.com>
 <YrTDcrsn0/+alpzf@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YrTDcrsn0/+alpzf@google.com>
X-Mailman-Approved-At: Sat, 25 Jun 2022 04:53:35 -0400
Cc: Marc Zyngier <maz@kernel.org>, kvm list <kvm@vger.kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
 LinuxMIPS <linux-mips@vger.kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Ben Gardon <bgardon@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 KVMARM <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Thu, Jun 23, 2022 at 07:48:02PM +0000, Sean Christopherson wrote:
> On Thu, Jun 23, 2022, David Matlack wrote:
> > On Wed, Jun 22, 2022 at 12:27 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> Please trim replies.
> 
> > > +static int topup_split_caches(struct kvm *kvm)
> > > +{
> > > +       int r;
> > > +
> > > +       lockdep_assert_held(&kvm->slots_lock);
> > > +
> > > +       /*
> > > +        * It's common to need all SPLIT_DESC_CACHE_MIN_NR_OBJECTS (513) objects
> > > +        * when splitting a page, but setting capacity == min would cause
> > > +        * KVM to drop mmu_lock even if just one object was consumed from the
> > > +        * cache.  So make capacity larger than min and handle two huge pages
> > > +        * without having to drop the lock.
> > 
> > I was going to do some testing this week to confirm, but IIUC KVM will
> > only allocate from split_desc_cache if the L1 hypervisor has aliased a
> > huge page in multiple {E,N}PT12 page table entries. i.e. L1 is mapping
> > a huge page into an L2 multiple times, or mapped into multiple L2s.
> > This should be common in traditional, process-level, shadow paging,
> > but I think will be quite rare for nested shadow paging.
> 
> Ooooh, right, I forgot that that pte_list_add() needs to allocate if and only if
> there are multiple rmap entries, otherwise rmap->val points that the one and only
> rmap directly.
> 
> Doubling the capacity is all but guaranteed to be pointless overhead.  What about
> buffering with the default capacity?  That way KVM doesn't have to topup if it
> happens to encounter an aliased gfn.  It's arbitrary, but so is the default capacity
> size.
> 
> E.g. as fixup

LGTM

> 
> ---
>  arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 22b87007efff..90d6195edcf3 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6125,19 +6125,23 @@ static bool need_topup_split_caches_or_resched(struct kvm *kvm)
> 
>  static int topup_split_caches(struct kvm *kvm)
>  {
> -	int r;
> -
> -	lockdep_assert_held(&kvm->slots_lock);
> -
>  	/*
> -	 * It's common to need all SPLIT_DESC_CACHE_MIN_NR_OBJECTS (513) objects
> -	 * when splitting a page, but setting capacity == min would cause
> -	 * KVM to drop mmu_lock even if just one object was consumed from the
> -	 * cache.  So make capacity larger than min and handle two huge pages
> -	 * without having to drop the lock.
> +	 * Allocating rmap list entries when splitting huge pages for nested
> +	 * MMUs is rare as KVM needs to allocate if and only if there is more
> +	 * than one rmap entry for the gfn, i.e. requires an L1 gfn to be
> +	 * aliased by multiple L2 gfns, which is very atypical for VMMs.  If
> +	 * there is only one rmap entry, rmap->val points directly at that one
> +	 * entry and doesn't need to allocate a list.  Buffer the cache by the
> +	 * default capacity so that KVM doesn't have to topup the cache if it
> +	 * encounters an aliased gfn or two.
>  	 */
> -	r = __kvm_mmu_topup_memory_cache(&kvm->arch.split_desc_cache,
> -					 2 * SPLIT_DESC_CACHE_MIN_NR_OBJECTS,
> +	const int capacity = SPLIT_DESC_CACHE_MIN_NR_OBJECTS +
> +			     KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
> +	int r;
> +
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	r = __kvm_mmu_topup_memory_cache(&kvm->arch.split_desc_cache, capacity,
>  					 SPLIT_DESC_CACHE_MIN_NR_OBJECTS);
>  	if (r)
>  		return r;
> 
> base-commit: 436b1c29f36ed3d4385058ba6f0d6266dbd2a882
> --
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
