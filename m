Return-Path: <SRS0=p2dm=M2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED24EC4338F
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 10:55:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6B31460FC2
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 10:55:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6B31460FC2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDE3040623;
	Tue,  3 Aug 2021 06:55:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5MPhtKjh+F9W; Tue,  3 Aug 2021 06:55:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A17140870;
	Tue,  3 Aug 2021 06:55:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D91E4086D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 06:55:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y4JFRdvMe48E for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Aug 2021 06:55:09 -0400 (EDT)
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com
 [209.85.167.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3C8A40623
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 06:55:09 -0400 (EDT)
Received: by mail-oi1-f177.google.com with SMTP id y18so27693239oiv.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Aug 2021 03:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=+WSoxwt2C8CYjlH9xHjQ+oboKdUtA9Rzp9ra0MKS0sc=;
 b=wM20ZIpUC2FBSnnZrCMauN6hWl7/tiPmQyuM3X7RY2OiF4DcfWAA2K9WP/8KiiIEcb
 dQVeVU/X0ukr8213stUsNNy617xD/83+c4SlsE4XlD770TEq4lro5WA9FRV9o7wOs3Ef
 8Uuki8kxrh6oIA2KUPMk9YsXcoYbI1HcYHjL4nGMntTWKirqZM+8LVJMxsFvaL5FQfr2
 sckZkQOCMlJVPa/xj4T04ySWt7wqy1HKXBYhPOBrzbSy8+przMwH0dWrwWa1XkNRjD/2
 LC7QS1RGoU0ZMwsBP+q19aKABLCS/wU/1xc+mOWMM5NinLyNOxClp0EdnNAX9TmlBpJ4
 1dAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=+WSoxwt2C8CYjlH9xHjQ+oboKdUtA9Rzp9ra0MKS0sc=;
 b=j7L7CW6RY+yF02iBBB3CJcHgY928kfc5byGa085J7ErcFT+tbAlFa6XK7UjbZ5oM8T
 U91Uu7o9HsPjxGggHxbn3oVwt2Sd97RZnPbANXOhr/PKxesQkDyAJXnjwqHdKZS2mZ66
 zvrZhTjv9pNTsor+lRf917He4kyWKQjca9tgobZq33wp0vqwbXxNkBEj+XmGBfjmZlI4
 T2uMuLvejvFQPkJxt4jJwVgxATxnJU9Hf19uvoXy8zYXL6LNP6TIRbcA/HFXtxOvRFi7
 9HvDLrEtFdumIfcBG/JZdEWfndpJsI6idrvN6NTht4x1660GnmH0OESDEZAjY2VqdJX1
 1Qfw==
X-Gm-Message-State: AOAM532RensPwXRlJWA4XaEIJMxKmMRoeV1wJvCVdA2GyhdQY0RN0wYN
 MYbJiOfiFX29OBQwO7Pp8X+kXdZHmXZZhtP6tXUK3g==
X-Google-Smtp-Source: ABdhPJwYlFcjoKB1AsgH5I1o+peqrhsWTuZXg6FQYN4DxDCoFu6YtiZbcpIvRedwV2a/4OLXMpfMsVv2ddav3MvA0Os=
X-Received: by 2002:a05:6808:1981:: with SMTP id
 bj1mr1110754oib.8.1627988109163; 
 Tue, 03 Aug 2021 03:55:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-18-qperret@google.com>
 <CA+EHjTwfsA8Z+_dJzqjsBXJ_SSC55Bcxc6HQ_Q4OJDrqmk0Unw@mail.gmail.com>
 <YQkboRdFP9oPVJgn@google.com>
In-Reply-To: <YQkboRdFP9oPVJgn@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 3 Aug 2021 12:54:32 +0200
Message-ID: <CA+EHjTym0agkuzuy1ZnxU7QbL4jP1xmW4sX2YixBCVo5cSKzog@mail.gmail.com>
Subject: Re: [PATCH v3 17/21] KVM: arm64: Mark host bss and rodata section as
 shared
To: Quentin Perret <qperret@google.com>
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

Hi Quentin,

> > > +       ret = pkvm_create_mappings(__hyp_bss_end, __bss_stop, prot);
> >
> > nit: for clarity, I wonder if it might be good to create an alias of
> > __hyp_bss_end as __bss_start or something. When it's been moved here,
> > it sticks out a bit more and makes the reader wonder about the
> > significance of __hyp_bss_end.
>
> I understand what you mean, but I'm not sure this aliasing is really
> going to clarify things much. We have a comment in arm.c (see
> init_hyp_mode()) to explain exactly why we're doing this, so maybe it
> would be worth adding it here too. WDYT?

Not sure to be honest. Comments are good, until they're stale, and
replicating the comment increases the odds of that happening. No
strong opinion either way.

> > > +       if (ret)
> > > +               return ret;
> > > +
> > >         return 0;
> > >  }
> > >
> > > @@ -148,6 +159,57 @@ static void hpool_put_page(void *addr)
> > >         hyp_put_page(&hpool, addr);
> > >  }
> > >
> > > +static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
> > > +                                        kvm_pte_t *ptep,
> > > +                                        enum kvm_pgtable_walk_flags flag,
> > > +                                        void * const arg)
> > > +{
> > > +       enum kvm_pgtable_prot prot;
> > > +       enum pkvm_page_state state;
> > > +       kvm_pte_t pte = *ptep;
> > > +       phys_addr_t phys;
> > > +
> > > +       if (!kvm_pte_valid(pte))
> > > +               return 0;
> > > +
> > > +       if (level != (KVM_PGTABLE_MAX_LEVELS - 1))
> > > +               return -EINVAL;
> >
> > I know that it's not in scope here, but I'm wondering whether we
> > should be checking for KVM_PTE_TYPE_PAGE instead of the level. Maybe
>
> Well these would check different things no?
>
> > it would be good to have a helper somewhere for all these checks both
> > for clarity and to ensure that nothing has gone wrong with the pte.
>
> The reason I need this check is just to make sure the call to
> host_stage2_idmap_locked() further down is correct with a hardcoded
> PAGE_SIZE size. The alternative would be to not be lazy and actually
> compute the current granule size based on the level and use that, as
> that would make this code robust to using block mappings at EL2 stage-1
> in the future.
>
> And I'll fix this up for v4.

I get it now. Thanks!
/fuad


> Cheers,
> Quentin
>
> > > +
> > > +       phys = kvm_pte_to_phys(pte);
> > > +       if (!addr_is_memory(phys))
> > > +               return 0;
> > > +
> > > +       /*
> > > +        * Adjust the host stage-2 mappings to match the ownership attributes
> > > +        * configured in the hypervisor stage-1.
> > > +        */
> > > +       state = pkvm_getstate(kvm_pgtable_hyp_pte_prot(pte));
> > > +       switch (state) {
> > > +       case PKVM_PAGE_OWNED:
> > > +               return host_stage2_set_owner_locked(phys, phys + PAGE_SIZE, pkvm_hyp_id);
> > > +       case PKVM_PAGE_SHARED_OWNED:
> > > +               prot = pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_BORROWED);
> > > +               break;
> > > +       case PKVM_PAGE_SHARED_BORROWED:
> > > +               prot = pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED);
> > > +               break;
> > > +       default:
> > > +               return -EINVAL;
> > > +       }
> > > +
> > > +       return host_stage2_idmap_locked(phys, phys + PAGE_SIZE, prot);
> > > +}
> > > +
> > > +static int finalize_host_mappings(void)
> > > +{
> > > +       struct kvm_pgtable_walker walker = {
> > > +               .cb     = finalize_host_mappings_walker,
> > > +               .flags  = KVM_PGTABLE_WALK_LEAF,
> > > +       };
> > > +
> > > +       return kvm_pgtable_walk(&pkvm_pgtable, 0, BIT(pkvm_pgtable.ia_bits), &walker);
> > > +}
> > > +
> > >  void __noreturn __pkvm_init_finalise(void)
> > >  {
> > >         struct kvm_host_data *host_data = this_cpu_ptr(&kvm_host_data);
> > > @@ -167,6 +229,10 @@ void __noreturn __pkvm_init_finalise(void)
> > >         if (ret)
> > >                 goto out;
> > >
> > > +       ret = finalize_host_mappings();
> > > +       if (ret)
> > > +               goto out;
> > > +
> > >         pkvm_pgtable_mm_ops = (struct kvm_pgtable_mm_ops) {
> > >                 .zalloc_page = hyp_zalloc_hyp_page,
> > >                 .phys_to_virt = hyp_phys_to_virt,
> > > --
> > > 2.32.0.432.gabb21c7263-goog
> > >
> >
> > Thanks,
> > /fuad
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
