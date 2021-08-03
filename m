Return-Path: <SRS0=p2dm=M2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B87C9C432BE
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 10:37:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C1AF60F58
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 10:37:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2C1AF60F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5A9340874;
	Tue,  3 Aug 2021 06:37:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1lpNBj8pTiAf; Tue,  3 Aug 2021 06:37:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 602DB40895;
	Tue,  3 Aug 2021 06:37:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A3A04086F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 06:37:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ov2Hg5nqzw-b for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Aug 2021 06:37:10 -0400 (EDT)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03B3E40799
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 06:37:09 -0400 (EDT)
Received: by mail-wr1-f49.google.com with SMTP id z4so24807348wrv.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Aug 2021 03:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=OfCoiih4+kjHguXqFPDXzH6cgIOlyrxD4TS+l5ysvFk=;
 b=oK1JvaEldDcXbbl7XIpC2KQbuUB307XsvhZpKIw98fEC9HM3SeC2pQ3JMF0HUSBICg
 9R/Uc4FraONJ/tY44FUQcM4ppaXjUZ2Dwth2OZi/Lblhoe/T/Y5IZ3oR36WW7xqIMmc+
 vTKjnl6ElslWknLnGL9Nr4Of+7PNlOzZ6SSJU2GiCfw6Gp35Ul7EyZiTi+5uoKIM5pGs
 V3+Y/4Po+Odcy3c7s5D3G+nOrmVDjkqAcUuM+ofq7D9NTaRJQzxBEwip3+hlRMlUVTbn
 4x+TtKjws6Vpe6vw43bShnCMM7pTkw2Xsx7OkdIeGptyb/YT/1jXxJpnISXK77hONqn0
 eaLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=OfCoiih4+kjHguXqFPDXzH6cgIOlyrxD4TS+l5ysvFk=;
 b=UIa6/nUF9wEruyQ+d32fgwN4U6xWBqSS846C8w1e943ZvRxpUZnL+WhBL984LHtE9Z
 nHhb5m/saWrhABZOyjyDB5UHfwssqXzOMWsW+2F94Rrtc/I2+33FSYcYTYmZIc1taKFl
 eJ0Yb0kV9jPNgLT/L5d5rPIfThkxO4d3Rt+7HEs0AxmbhrLsB+pZAR8FrSgVAen+hE0d
 LQBUahNm++0YFddyfuc+J1/LLSNZATmc6ccOaarAhAa9aSeAlxzOsyG8a56Cn5gaR1Jm
 O9PuIe7Trpn3CwRvLR9djCN6K6suAkjGBv6tKz045DLjgZfKyA5Xoc7CgAap4QZA2ADq
 3hnQ==
X-Gm-Message-State: AOAM533OAsKaUQWYgEW+vBTGDcJM971nuAUmrEp4Olqbrlg6VLWRILcB
 976u8nVfHRNu7EN/aG+wFcfNsA==
X-Google-Smtp-Source: ABdhPJyuLJL7/6FQ1Dy0s9kzytBeGbU4gur4MVpvOZPD2oYaeKYjAL+sZll6yArFzRDkovagShzTCg==
X-Received: by 2002:a5d:6692:: with SMTP id l18mr21756760wru.85.1627987028707; 
 Tue, 03 Aug 2021 03:37:08 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:754:7d1b:7303:129a])
 by smtp.gmail.com with ESMTPSA id i7sm14652599wre.64.2021.08.03.03.37.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 03 Aug 2021 03:37:08 -0700 (PDT)
Date: Tue, 3 Aug 2021 11:37:05 +0100
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 19/21] KVM: arm64: Refactor protected nVHE stage-1
 locking
Message-ID: <YQkcUXnrqp7hsZZT@google.com>
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-20-qperret@google.com>
 <CA+EHjTwWt+jvRZsk5KEhQWzn+XqdV2gZSq7oCuOCVXRa1=JiWw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+EHjTwWt+jvRZsk5KEhQWzn+XqdV2gZSq7oCuOCVXRa1=JiWw@mail.gmail.com>
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

Hey Fuad,

On Tuesday 03 Aug 2021 at 07:31:03 (+0200), Fuad Tabba wrote:
> Hi Quentin,
> 
> On Thu, Jul 29, 2021 at 3:29 PM Quentin Perret <qperret@google.com> wrote:
> >
> > Refactor the hypervisor stage-1 locking in nVHE protected mode to expose
> > a new pkvm_create_mappings_locked() function. This will be used in later
> > patches to allow walking and changing the hypervisor stage-1 without
> > releasing the lock.
> >
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/mm.h |  1 +
> >  arch/arm64/kvm/hyp/nvhe/mm.c         | 18 ++++++++++++++++--
> >  2 files changed, 17 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> > index 8ec3a5a7744b..c76d7136ed9b 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> > @@ -23,6 +23,7 @@ int hyp_map_vectors(void);
> >  int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back);
> >  int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
> >  int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
> > +int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
> >  int __pkvm_create_mappings(unsigned long start, unsigned long size,
> >                            unsigned long phys, enum kvm_pgtable_prot prot);
> >  unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> > index a8efdf0f9003..6fbe8e8030f6 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> > @@ -67,13 +67,15 @@ unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
> >         return addr;
> >  }
> >
> > -int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
> > +int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot)
> >  {
> >         unsigned long start = (unsigned long)from;
> >         unsigned long end = (unsigned long)to;
> >         unsigned long virt_addr;
> >         phys_addr_t phys;
> >
> > +       hyp_assert_lock_held(&pkvm_pgd_lock);
> > +
> >         start = start & PAGE_MASK;
> >         end = PAGE_ALIGN(end);
> >
> > @@ -81,7 +83,8 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
> >                 int err;
> >
> >                 phys = hyp_virt_to_phys((void *)virt_addr);
> > -               err = __pkvm_create_mappings(virt_addr, PAGE_SIZE, phys, prot);
> > +               err = kvm_pgtable_hyp_map(&pkvm_pgtable, virt_addr, PAGE_SIZE,
> > +                                         phys, prot);
> >                 if (err)
> >                         return err;
> >         }
> > @@ -89,6 +92,17 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
> >         return 0;
> >  }
> >
> > +int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
> > +{
> > +       int ret;
> > +
> > +       hyp_spin_lock(&pkvm_pgd_lock);
> > +       ret = pkvm_create_mappings_locked(from, to, prot);
> > +       hyp_spin_unlock(&pkvm_pgd_lock);
> > +
> > +       return ret;
> > +}
> > +
> 
> I'm wondering whether this patch should also refactor
> __pkvm_create_mappings. It doesn't quite do the exact same thing and
> has different parameters.

Sorry, not sure I'm understanding your suggestion here. What do you
think should be done to __pkvm_create_mappings?

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
