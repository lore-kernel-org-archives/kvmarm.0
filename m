Return-Path: <SRS0=p2dm=M2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B15FC4338F
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 10:34:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E23FA6023B
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 10:34:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E23FA6023B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CDEE40799;
	Tue,  3 Aug 2021 06:34:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NfLqT0238U3c; Tue,  3 Aug 2021 06:34:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0319940874;
	Tue,  3 Aug 2021 06:34:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D5AA4086F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 06:34:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PpfkKpKdk4kl for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Aug 2021 06:34:14 -0400 (EDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DB9440799
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 06:34:14 -0400 (EDT)
Received: by mail-wm1-f47.google.com with SMTP id
 d131-20020a1c1d890000b02902516717f562so1806671wmd.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Aug 2021 03:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=P/REJEjetsZEwwVkX2C20MU8u3V3e/RveGtnLMYVQrU=;
 b=hYrbaXf/3SsijIhBUNfVPg/kqf4Zl1+oFP5dFVTQmfU/Z+NGnwtkEwEG7xY/rQiBta
 ABukb7373Au6nGEQcxtC9cXgZqtpEYtPlPBf4ENZeN+hh6imq9qyIyYOYzoLgseescIy
 t+DJ1J7Hk5457B2R1/GCKkWxAKxQJY+u5pLRsR9tP5+f2lf0cA2YVb3imValWyk+Z87t
 VtuIefzKGygz7LPofKbtYMz/0TDGc5OOHJjSO5reMEfhkzmBRd5wmep7T2DzFrjlAAuY
 VFYW5bMV3/6x/ec7a4eTmIiGv7kw+Y+f/3MYQlho+TLQyzAVew2OPLrvtnKqX+Ix8sph
 yERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=P/REJEjetsZEwwVkX2C20MU8u3V3e/RveGtnLMYVQrU=;
 b=k1lU1PRC0Vov2V98dLUNCYaLItkeOiBNlg13G/y/cpvXH9Q12S83vw8caFWx81+g+x
 ZrFHlZvlaUJdGa0XrZ400jNSY1fIjgzl9xGYqhjc2GGywT/g4BVTA3K3E2r2OPhGt2Ej
 awTqNF4LWGKMy3o5uP+rt2lkHs5FqkXoTK5hz1dGAoy9/VzqcJ6YqsrIos1KKWRVcUQw
 L4LTlu6YASSSKyzD7IlpagECVXWlON1l82e8TWXAINKbOe5mYEk8XQI+X+1VXT2i60BP
 IeADDWdNwTMZ+496vILCYDMm7LTLgmc+0NXigdmx37/SvOCa3fOs2lF/eugeaBOnSvbt
 RPyw==
X-Gm-Message-State: AOAM531ARb8JYVeQo7iV4CUfg276YaoRcs7dFLglLuNQN0ql9iUWp6FN
 Jtntjz51jXyLamKZpeXbQ/zS+A==
X-Google-Smtp-Source: ABdhPJyNSUOpD9YPYa1ks1LyBQbBgi59E15Rq3yqrsRb+HwvS1PPW0tD/4DXVPJau42sjQpLuaonWA==
X-Received: by 2002:a7b:c00a:: with SMTP id c10mr3578344wmb.100.1627986852769; 
 Tue, 03 Aug 2021 03:34:12 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:754:7d1b:7303:129a])
 by smtp.gmail.com with ESMTPSA id g198sm2621322wme.0.2021.08.03.03.34.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 03 Aug 2021 03:34:12 -0700 (PDT)
Date: Tue, 3 Aug 2021 11:34:09 +0100
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 17/21] KVM: arm64: Mark host bss and rodata section as
 shared
Message-ID: <YQkboRdFP9oPVJgn@google.com>
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-18-qperret@google.com>
 <CA+EHjTwfsA8Z+_dJzqjsBXJ_SSC55Bcxc6HQ_Q4OJDrqmk0Unw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+EHjTwfsA8Z+_dJzqjsBXJ_SSC55Bcxc6HQ_Q4OJDrqmk0Unw@mail.gmail.com>
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

On Tuesday 03 Aug 2021 at 07:02:42 (+0200), Fuad Tabba wrote:
> Hi Quentin,
> 
> On Thu, Jul 29, 2021 at 3:29 PM Quentin Perret <qperret@google.com> wrote:
> >
> > As the hypervisor maps the host's .bss and .rodata sections in its
> > stage-1, make sure to tag them as shared in hyp and host page-tables.
> >
> > But since the hypervisor relies on the presence of these mappings, we
> > cannot let the host in complete control of the memory regions -- it
> > must not unshare or donate them to another entity for example. To
> > prevent this, let's transfer the ownership of those ranges to the
> > hypervisor itself, and share the pages back with the host.
> >
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/setup.c | 82 +++++++++++++++++++++++++++++----
> >  1 file changed, 74 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> > index 0b574d106519..7f557b264f62 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> > @@ -58,6 +58,7 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
> >  {
> >         void *start, *end, *virt = hyp_phys_to_virt(phys);
> >         unsigned long pgt_size = hyp_s1_pgtable_pages() << PAGE_SHIFT;
> > +       enum kvm_pgtable_prot prot;
> >         int ret, i;
> >
> >         /* Recreate the hyp page-table using the early page allocator */
> > @@ -83,10 +84,6 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
> >         if (ret)
> >                 return ret;
> >
> > -       ret = pkvm_create_mappings(__start_rodata, __end_rodata, PAGE_HYP_RO);
> > -       if (ret)
> > -               return ret;
> > -
> >         ret = pkvm_create_mappings(__hyp_rodata_start, __hyp_rodata_end, PAGE_HYP_RO);
> >         if (ret)
> >                 return ret;
> > @@ -95,10 +92,6 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
> >         if (ret)
> >                 return ret;
> >
> > -       ret = pkvm_create_mappings(__hyp_bss_end, __bss_stop, PAGE_HYP_RO);
> > -       if (ret)
> > -               return ret;
> > -
> >         ret = pkvm_create_mappings(virt, virt + size, PAGE_HYP);
> >         if (ret)
> >                 return ret;
> > @@ -117,6 +110,24 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
> >                         return ret;
> >         }
> >
> > +       /*
> > +        * Map the host's .bss and .rodata sections RO in the hypervisor, but
> > +        * transfer the ownerhsip from the host to the hypervisor itself to
> > +        * make sure it can't be donated or shared with another entity.
> 
> nit: ownerhsip -> ownership
> 
> > +        *
> > +        * The ownership transtion requires matching changes in the host
> 
> nit: transtion -> transition
> 
> > +        * stage-2. This will done later (see finalize_host_mappings()) once the
> 
> nit: will done -> will be done

Urgh, I clearly went too fast writing this, thanks!

> > +        * hyp_vmemmap is addressable.
> > +        */
> > +       prot = pkvm_mkstate(PAGE_HYP_RO, PKVM_PAGE_SHARED_OWNED);
> > +       ret = pkvm_create_mappings(__start_rodata, __end_rodata, prot);
> > +       if (ret)
> > +               return ret;
> > +
> > +       ret = pkvm_create_mappings(__hyp_bss_end, __bss_stop, prot);
> 
> nit: for clarity, I wonder if it might be good to create an alias of
> __hyp_bss_end as __bss_start or something. When it's been moved here,
> it sticks out a bit more and makes the reader wonder about the
> significance of __hyp_bss_end.

I understand what you mean, but I'm not sure this aliasing is really
going to clarify things much. We have a comment in arm.c (see
init_hyp_mode()) to explain exactly why we're doing this, so maybe it
would be worth adding it here too. WDYT?

> > +       if (ret)
> > +               return ret;
> > +
> >         return 0;
> >  }
> >
> > @@ -148,6 +159,57 @@ static void hpool_put_page(void *addr)
> >         hyp_put_page(&hpool, addr);
> >  }
> >
> > +static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
> > +                                        kvm_pte_t *ptep,
> > +                                        enum kvm_pgtable_walk_flags flag,
> > +                                        void * const arg)
> > +{
> > +       enum kvm_pgtable_prot prot;
> > +       enum pkvm_page_state state;
> > +       kvm_pte_t pte = *ptep;
> > +       phys_addr_t phys;
> > +
> > +       if (!kvm_pte_valid(pte))
> > +               return 0;
> > +
> > +       if (level != (KVM_PGTABLE_MAX_LEVELS - 1))
> > +               return -EINVAL;
> 
> I know that it's not in scope here, but I'm wondering whether we
> should be checking for KVM_PTE_TYPE_PAGE instead of the level. Maybe

Well these would check different things no?

> it would be good to have a helper somewhere for all these checks both
> for clarity and to ensure that nothing has gone wrong with the pte.

The reason I need this check is just to make sure the call to
host_stage2_idmap_locked() further down is correct with a hardcoded
PAGE_SIZE size. The alternative would be to not be lazy and actually
compute the current granule size based on the level and use that, as
that would make this code robust to using block mappings at EL2 stage-1
in the future.

And I'll fix this up for v4.

Cheers,
Quentin

> > +
> > +       phys = kvm_pte_to_phys(pte);
> > +       if (!addr_is_memory(phys))
> > +               return 0;
> > +
> > +       /*
> > +        * Adjust the host stage-2 mappings to match the ownership attributes
> > +        * configured in the hypervisor stage-1.
> > +        */
> > +       state = pkvm_getstate(kvm_pgtable_hyp_pte_prot(pte));
> > +       switch (state) {
> > +       case PKVM_PAGE_OWNED:
> > +               return host_stage2_set_owner_locked(phys, phys + PAGE_SIZE, pkvm_hyp_id);
> > +       case PKVM_PAGE_SHARED_OWNED:
> > +               prot = pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_BORROWED);
> > +               break;
> > +       case PKVM_PAGE_SHARED_BORROWED:
> > +               prot = pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED);
> > +               break;
> > +       default:
> > +               return -EINVAL;
> > +       }
> > +
> > +       return host_stage2_idmap_locked(phys, phys + PAGE_SIZE, prot);
> > +}
> > +
> > +static int finalize_host_mappings(void)
> > +{
> > +       struct kvm_pgtable_walker walker = {
> > +               .cb     = finalize_host_mappings_walker,
> > +               .flags  = KVM_PGTABLE_WALK_LEAF,
> > +       };
> > +
> > +       return kvm_pgtable_walk(&pkvm_pgtable, 0, BIT(pkvm_pgtable.ia_bits), &walker);
> > +}
> > +
> >  void __noreturn __pkvm_init_finalise(void)
> >  {
> >         struct kvm_host_data *host_data = this_cpu_ptr(&kvm_host_data);
> > @@ -167,6 +229,10 @@ void __noreturn __pkvm_init_finalise(void)
> >         if (ret)
> >                 goto out;
> >
> > +       ret = finalize_host_mappings();
> > +       if (ret)
> > +               goto out;
> > +
> >         pkvm_pgtable_mm_ops = (struct kvm_pgtable_mm_ops) {
> >                 .zalloc_page = hyp_zalloc_hyp_page,
> >                 .phys_to_virt = hyp_phys_to_virt,
> > --
> > 2.32.0.432.gabb21c7263-goog
> >
> 
> Thanks,
> /fuad
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
