Return-Path: <SRS0=KNUW=MM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F9DC07E95
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 11:48:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4BA456113C
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 11:48:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4BA456113C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1C794B0EF;
	Tue, 20 Jul 2021 07:48:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yHT4uiFBlBCz; Tue, 20 Jul 2021 07:48:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D6FA4B0CA;
	Tue, 20 Jul 2021 07:48:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67D864B0A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 07:48:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kyGZ-6QZXn4H for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 07:48:14 -0400 (EDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
 [209.85.128.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 25EDD4B098
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 07:48:14 -0400 (EDT)
Received: by mail-wm1-f50.google.com with SMTP id
 f10-20020a05600c4e8ab029023e8d74d693so1860023wmq.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 04:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=hPwJ/dW4a4srx9+XIlue+N7D+kVuX+NIds9OwYkD43Q=;
 b=mBdzbgaenC7gw/D5SPsG8J5mVx29jdxJjOG69xzNWqWQ59jZH8+dwFjiHFAC4y7J6b
 O8HDkokQ0DBw6OgdxtF03SO9ByK3Ouv6ElQjH4LR226D4AEqlFJVzfeLLHbffjt5AIGX
 8JI9avw34kLztnnCLckx+KEbJbM7VhaNE+D8KGBzvIH8FQGDZ+MVSKf/bkbauI7/Eosq
 L1LKGhI/I9tTP50jA3h2kMY2OL7HstTogPdeCWqd5accPN1r48o7/uCw6U3XhokT3/lm
 Ct4lKUir7xGXoqJMWipfrEtVVSZ48Xwqj2FdZpFO5gCElxAAtMpJEKkLfCoh50XrzH28
 +XJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=hPwJ/dW4a4srx9+XIlue+N7D+kVuX+NIds9OwYkD43Q=;
 b=VDhQ5/mHto7JW/RkDg+ptDTHRVz5vH/0i8EC4T2Us3udC8s6fWKKx3OTrBmVPgjzo2
 e1lvMR6WJVeNzQQtwl2eC3z+NerMCWcdOdylu7QSji2Me918NzCk8pRdj7oxwWxFWPkK
 FN15QxitP/9n/XFi0xr+4/N8YH+RD6ett7kx0tZgu0NWBEgY7qnpX+CA1fGlwpasCssE
 PIHTE9JalSx35Q/NaJKEsKC7F+6kY/M8/R85NLQbzQJre67M1cYgzkILHjZa0nE3HcmN
 3vcW9n/B1lV3YiyBp/1NiGaHhr4+yZwLePFVJfZssxDNGReE3F/8NGYF34ySwmwDWhnP
 MmeQ==
X-Gm-Message-State: AOAM53238gEnOgBlvTtjNGF6N+e6Vqba6+nDKK6/vGloZhkQR6KsM+iI
 wgipYZS3IHUlPwYpVpasgHVAdw==
X-Google-Smtp-Source: ABdhPJx/vBaJQh6J/RNVt3vHGViwFJuVjJNenDo+nnp215LT08auAySOacQLtTrv1SeKkE+/sTjUtg==
X-Received: by 2002:a05:600c:4841:: with SMTP id
 j1mr31229342wmo.88.1626781692919; 
 Tue, 20 Jul 2021 04:48:12 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:83e0:11ac:c870:2b97])
 by smtp.gmail.com with ESMTPSA id d8sm24217158wrv.20.2021.07.20.04.48.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 20 Jul 2021 04:48:12 -0700 (PDT)
Date: Tue, 20 Jul 2021 12:48:08 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 08/14] KVM: arm64: Add support for tagging shared pages
 in page-table
Message-ID: <YPa3+NHt08zz5a1C@google.com>
References: <20210719104735.3681732-1-qperret@google.com>
 <20210719104735.3681732-9-qperret@google.com>
 <87fswajre1.wl-maz@kernel.org> <YPWe+W3QmeYHqre/@google.com>
 <8735s99ttg.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8735s99ttg.wl-maz@kernel.org>
Cc: kernel-team@android.com, qwandor@google.com, will@kernel.org,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
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

On Tuesday 20 Jul 2021 at 11:13:31 (+0100), Marc Zyngier wrote:
> On Mon, 19 Jul 2021 16:49:13 +0100,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > On Monday 19 Jul 2021 at 15:43:34 (+0100), Marc Zyngier wrote:
> > > On Mon, 19 Jul 2021 11:47:29 +0100,
> > > Quentin Perret <qperret@google.com> wrote:
> > > > 
> > > > The hypervisor will soon be in charge of tracking ownership of all
> > > > memory pages in the system. The current page-tracking infrastructure at
> > > > EL2 only allows binary states: a page is either owned or not by an
> > > > entity. But a number of use-cases will require more complex states for
> > > > pages that are shared between two entities (host, hypervisor, or guests).
> > > > 
> > > > In preparation for supporting these use-cases, introduce in the KVM
> > > > page-table library some infrastructure allowing to tag shared pages
> > > > using ignored bits (a.k.a. software bits) in PTEs.
> > > > 
> > > > Signed-off-by: Quentin Perret <qperret@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_pgtable.h |  5 +++++
> > > >  arch/arm64/kvm/hyp/pgtable.c         | 25 +++++++++++++++++++++++++
> > > >  2 files changed, 30 insertions(+)
> > > > 
> > > > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > > > index dd72653314c7..f6d3d5c8910d 100644
> > > > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > > > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > > > @@ -81,6 +81,8 @@ enum kvm_pgtable_stage2_flags {
> > > >   * @KVM_PGTABLE_PROT_W:		Write permission.
> > > >   * @KVM_PGTABLE_PROT_R:		Read permission.
> > > >   * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
> > > > + * @KVM_PGTABLE_STATE_SHARED:	Page shared with another entity.
> > > > + * @KVM_PGTABLE_STATE_BORROWED:	Page borrowed from another entity.
> > > >   */
> > > >  enum kvm_pgtable_prot {
> > > >  	KVM_PGTABLE_PROT_X			= BIT(0),
> > > > @@ -88,6 +90,9 @@ enum kvm_pgtable_prot {
> > > >  	KVM_PGTABLE_PROT_R			= BIT(2),
> > > >  
> > > >  	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
> > > > +
> > > > +	KVM_PGTABLE_STATE_SHARED		= BIT(4),
> > > > +	KVM_PGTABLE_STATE_BORROWED		= BIT(5),
> > > 
> > > I'd rather have some indirection here, as we have other potential
> > > users for the SW bits outside of pKVM (see the NV series, which uses
> > > some of these SW bits as the backend for TTL-based TLB invalidation).
> > > 
> > > Can we instead only describe the SW bit states in this enum, and let
> > > the users map the semantic they require onto that state? See [1] for
> > > what I carry in the NV branch.
> > 
> > Works for me -- I just wanted to make sure we don't have users in
> > different places that use the same bits without knowing, but no strong
> > opinions, so happy to change.
> > 
> > > >  };
> > > >  
> > > >  #define KVM_PGTABLE_PROT_RW	(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
> > > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > > > index 5bdbe7a31551..51598b79dafc 100644
> > > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > > @@ -211,6 +211,29 @@ static kvm_pte_t kvm_init_invalid_leaf_owner(u8 owner_id)
> > > >  	return FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id);
> > > >  }
> > > >  
> > > > +static kvm_pte_t pte_ignored_bit_prot(enum kvm_pgtable_prot prot)
> > > 
> > > Can we call these sw rather than ignored?
> > 
> > Sure.
> > 
> > > > +{
> > > > +	kvm_pte_t ignored_bits = 0;
> > > > +
> > > > +	/*
> > > > +	 * Ignored bits 0 and 1 are reserved to track the memory ownership
> > > > +	 * state of each page:
> > > > +	 *   00: The page is owned solely by the page-table owner.
> > > > +	 *   01: The page is owned by the page-table owner, but is shared
> > > > +	 *       with another entity.
> > > > +	 *   10: The page is shared with, but not owned by the page-table owner.
> > > > +	 *   11: Reserved for future use (lending).
> > > > +	 */
> > > > +	if (prot & KVM_PGTABLE_STATE_SHARED) {
> > > > +		if (prot & KVM_PGTABLE_STATE_BORROWED)
> > > > +			ignored_bits |= BIT(1);
> > > > +		else
> > > > +			ignored_bits |= BIT(0);
> > > > +	}
> > > > +
> > > > +	return FIELD_PREP(KVM_PTE_LEAF_ATTR_IGNORED, ignored_bits);
> > > > +}
> > > > +
> > > >  static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
> > > >  				  u32 level, kvm_pte_t *ptep,
> > > >  				  enum kvm_pgtable_walk_flags flag)
> > > > @@ -357,6 +380,7 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
> > > >  	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
> > > >  	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
> > > >  	attr |= KVM_PTE_LEAF_ATTR_LO_S1_AF;
> > > > +	attr |= pte_ignored_bit_prot(prot);
> > > >  	*ptep = attr;
> > > >  
> > > >  	return 0;
> > > > @@ -558,6 +582,7 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
> > > >  
> > > >  	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
> > > >  	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
> > > > +	attr |= pte_ignored_bit_prot(prot);
> > > >  	*ptep = attr;
> > > >  
> > > >  	return 0;
> > > 
> > > How about kvm_pgtable_stage2_relax_perms()?
> > 
> > It should leave SW bits untouched, and it really felt like a path were
> > we want to change permissions and nothing else. What did you have in
> > mind?
> 
> It isn't clear to me that it would not (cannot?) be used to change
> other bits, given that it takes an arbitrary 'prot' set.

Sure, though it already ignores KVM_PGTABLE_PROT_DEVICE.

I guess the thing I find hard to reason about is that
kvm_pgtable_stage2_relax_perms() is 'additive'. E.g. it can make a
mapping RW if it was RO, but not the other way around. With the current
patch-set it wasn't really clear how that should translate to
KVM_PGTABLE_STATE_SHARED and such.

> If there is
> such an intended restriction, we definitely should document it.

Ack, that's definitely missing. And in fact I should probably make
kvm_pgtable_stage2_relax_perms() return -EINVAL if we're passing prot
values it can't handle.

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
