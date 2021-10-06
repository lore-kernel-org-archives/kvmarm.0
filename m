Return-Path: <SRS0=qtHs=O2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 550EEC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 11:22:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB1766117A
	for <kvmarm@archiver.kernel.org>; Wed,  6 Oct 2021 11:22:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CB1766117A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DB8B4B2B9;
	Wed,  6 Oct 2021 07:22:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iTZRu59Z0s0D; Wed,  6 Oct 2021 07:22:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D579E4B2B2;
	Wed,  6 Oct 2021 07:22:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AC534B2AA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 07:22:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F-JbGyfCcMAI for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Oct 2021 07:22:27 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 347AA4B2A6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Oct 2021 07:22:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633519347;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=jWX5sU8D1+Ly4mm1f35q3sYrq7WIwVRiVd8SgiHRgOs=;
 b=JJozpYtc+lht4K+GR9dJN5iVdGpxBjbKn7W+xoieRxxQ8phKA4tZS2P8GEffRp5wvYpdCU
 SxZhMU+0m/ogneH6G953wzBOFfdZS4zdZbfYmzmV+0y3bbjtJiuxBF6cAZTYXDdA26zSeS
 9AR6TvwvluTsM0a+vcwiYZgNpBinv8g=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-x03OyaDaNq60ALP5o6LIKg-1; Wed, 06 Oct 2021 07:22:26 -0400
X-MC-Unique: x03OyaDaNq60ALP5o6LIKg-1
Received: by mail-ed1-f71.google.com with SMTP id
 v2-20020a50f082000000b003db24e28d59so2345054edl.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Oct 2021 04:22:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=jWX5sU8D1+Ly4mm1f35q3sYrq7WIwVRiVd8SgiHRgOs=;
 b=DuPyoyJ5oih80v89kRA8KywizijLjtieHOJLCkAG2vNhVFRxolp3M5DunVCrHP1Gd4
 1iwBu3ntZw2cvoB8d/NHgkrS5BygB2tBhVfA8OhwVbNIpYlgHNpitSTw/wRhl9IXzs8J
 I+6zkeklOwC4Rz2vPFDqs+dk2X+kfzyHf2bg928lPzIKk0ri9WxFLRnMofpcnSijiR1q
 Aueb/IHYye1JJKUoTL7WApzR0ICpmb8czvj0UG37YliBcB3LXCQ8dd+ZT8rC/9tcd905
 vCVqt/jR1rUl6gjIWvzlfI5bPQ+uhcU6Af2UFCQAOTNLCpO48kUPoVEKvWD5uNlbWoV/
 AaCA==
X-Gm-Message-State: AOAM532jVktohXxo3+gBgK93CCptpIZwYwOKOOW3sioAfmRsp2TkoNjP
 xIhJ3xrdfPI0QShmjnL2h3Mz56Z7psIIZ8djGobGiXHgfhYRP7pbzhu/v4LzjFCMOQK+9jVXrfU
 FlwRZGHBYxzdXeAwqGhxC9nqB
X-Received: by 2002:a17:906:4f82:: with SMTP id
 o2mr31730782eju.10.1633519344866; 
 Wed, 06 Oct 2021 04:22:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIBjVZ1NUXsGTtniMInafdYKeFUjjcDRuQOp+LY5ONfLP3y1FH0sVTnhS2J3YnXmmsoLjhGg==
X-Received: by 2002:a17:906:4f82:: with SMTP id
 o2mr31730745eju.10.1633519344572; 
 Wed, 06 Oct 2021 04:22:24 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id u4sm1158745edj.33.2021.10.06.04.22.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Oct 2021 04:22:24 -0700 (PDT)
Date: Wed, 6 Oct 2021 13:22:22 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 03/16] KVM: arm64: Turn kvm_pgtable_stage2_set_owner
 into kvm_pgtable_stage2_annotate
Message-ID: <20211006112222.ahfhtkhamdi3svm5@gator.home>
References: <20211004174849.2831548-1-maz@kernel.org>
 <20211004174849.2831548-4-maz@kernel.org>
 <20211006110211.y6kzmjlzgardmwif@gator.home>
MIME-Version: 1.0
In-Reply-To: <20211006110211.y6kzmjlzgardmwif@gator.home>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Steven Price <steven.price@arm.com>,
 Shanker R Donthineni <sdonthineni@nvidia.com>, will@kernel.org,
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

On Wed, Oct 06, 2021 at 01:02:11PM +0200, Andrew Jones wrote:
> On Mon, Oct 04, 2021 at 06:48:36PM +0100, Marc Zyngier wrote:
> > kvm_pgtable_stage2_set_owner() could be generalised into a way
> > to store up to 63 bits in the page tables, as long as we don't
> > set bit 0.
> > 
> > Let's just do that.
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h          | 12 ++++++-----
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +-
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 11 ++++------
> >  arch/arm64/kvm/hyp/nvhe/setup.c               | 10 +++++++++-
> >  arch/arm64/kvm/hyp/pgtable.c                  | 20 ++++++-------------
> >  5 files changed, 27 insertions(+), 28 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 027783829584..d4d3ae0b5edb 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -329,14 +329,16 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >  			   void *mc);
> >  
> >  /**
> > - * kvm_pgtable_stage2_set_owner() - Unmap and annotate pages in the IPA space to
> > - *				    track ownership.
> > + * kvm_pgtable_stage2_annotate() - Unmap and annotate pages in the IPA space
> > + *				   to track ownership (and more).
> >   * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> >   * @addr:	Base intermediate physical address to annotate.
> >   * @size:	Size of the annotated range.
> >   * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
> >   *		page-table pages.
> > - * @owner_id:	Unique identifier for the owner of the page.
> > + * @annotation:	A 63 bit value that will be stored in the page tables.
> > + *		@annotation[0] must be 0, and @annotation[63:1] is stored
> > + *		in the page tables.
> >   *
> >   * By default, all page-tables are owned by identifier 0. This function can be
> >   * used to mark portions of the IPA space as owned by other entities. When a
> > @@ -345,8 +347,8 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >   *
> >   * Return: 0 on success, negative error code on failure.
> >   */
> > -int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > -				 void *mc, u8 owner_id);
> > +int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > +				void *mc, kvm_pte_t annotation);
> >  
> >  /**
> >   * kvm_pgtable_stage2_unmap() - Remove a mapping from a guest stage-2 page-table.
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > index b58c910babaf..9d2ca173ea9a 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > @@ -53,7 +53,7 @@ int __pkvm_host_share_hyp(u64 pfn);
> >  
> >  bool addr_is_memory(phys_addr_t phys);
> >  int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
> > -int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id);
> > +int host_stage2_annotate_locked(phys_addr_t addr, u64 size, kvm_pte_t owner_id);
> >  int kvm_host_prepare_stage2(void *pgt_pool_base);
> >  void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
> >  
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index bacd493a4eac..8cd0c3bdb911 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -286,17 +286,14 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
> >  int host_stage2_idmap_locked(phys_addr_t addr, u64 size,
> >  			     enum kvm_pgtable_prot prot)
> >  {
> > -	hyp_assert_lock_held(&host_kvm.lock);
> > -
> >  	return host_stage2_try(__host_stage2_idmap, addr, addr + size, prot);
> >  }
> >  
> > -int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
> > +int host_stage2_annotate_locked(phys_addr_t addr, u64 size,
> > +				kvm_pte_t annotation)
> >  {
> > -	hyp_assert_lock_held(&host_kvm.lock);
> 
> Hi Marc,
> 
> Why are the lock asserts getting dropped?

Ah, I see. host_stage2_try already has the same assert.

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
