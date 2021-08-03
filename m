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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D47E2C4338F
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 10:24:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 62DD960F58
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 10:24:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 62DD960F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 044DA40799;
	Tue,  3 Aug 2021 06:24:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rLDy4r+INt9C; Tue,  3 Aug 2021 06:24:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0162406AD;
	Tue,  3 Aug 2021 06:24:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6E624064F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 06:24:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0RoNfujwOcUB for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Aug 2021 06:24:18 -0400 (EDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
 [209.85.221.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 827AC40629
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 06:24:18 -0400 (EDT)
Received: by mail-wr1-f46.google.com with SMTP id z4so24768868wrv.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Aug 2021 03:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=d6Nsv/xNSHs2Om+wxrSlYuqNQWvEFvnUhoy5ThkMx0Q=;
 b=FP0D12uUpP5OBvBJhAyl2dhq/xIpjHa4hZWkq4WRNfgxNtiPI5C6WPYX+SGVeC3ukl
 ZWEGnBrN5n6lwuVMkQyX0O7o8hsbO7aJ8dYH1ye3Tpp7c4cGB/2sVFrXYy12qm5rGvds
 hkTc+cakkXC9bcPjo4laVstTV0GDVZrfNNWrsIMRP+Tau4jPgy2iP2jvKkZiDWjfFrFy
 cP6Sozo7M0T5i08TOHBQfZd/TJI5Es/WHVej0aFyjpVZQZC9d2Fe7bnTPaB8Gy3tB//n
 ETrsOto9MjuxzgoSsMaWII+VfYTMe60WGl3u0yO5efg66bp2CHBuitvheec6vOCRi9JF
 UI9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=d6Nsv/xNSHs2Om+wxrSlYuqNQWvEFvnUhoy5ThkMx0Q=;
 b=BeakNtRn+CJw/m8h6o6J9frmt6QYsWlGz+lsPhxMYeh/S62ep/YJM1pIx2fO6aXGqF
 1L69DGbD+8e8vxwN16LrnIj7nUObGPDKsrbdzSdf9itfB9twSyhOUDRSxcdkCZ+kDNRG
 erIDm7uy2hbleLVqKYZsCFqgL02YRYjx6sqzGf6suBYWi6WsL60DYlf0aoZpfhuc39xi
 jnbbmDgxF310pR/bjJyuxhduxdK3jkoXnDnNkxtSGBwgxaIQCQ30KtLM9lyMsQm1TACd
 2cSbWLQx1c7OOYjCMnvck0AopebFET18tOOtzLofr4nZrXY0OnRJ9I0cMWOJNnbFBbrZ
 xz2A==
X-Gm-Message-State: AOAM5322BhXxT5CMVCIqVv5gsV2lKrnBnHhYCNIrxgtVGff31g2GIeoZ
 iyVwiQDLOONAVa3wpOoGbh7XsA==
X-Google-Smtp-Source: ABdhPJwblvZME7yKQlNor7Ndnl8b41R6jAh8T6Km7UHNqfvDgBQx1oplfzKTG7fCFMoS/YBxs1eocA==
X-Received: by 2002:adf:f2cd:: with SMTP id d13mr22244889wrp.315.1627986257474; 
 Tue, 03 Aug 2021 03:24:17 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:754:7d1b:7303:129a])
 by smtp.gmail.com with ESMTPSA id v15sm2179876wmj.39.2021.08.03.03.24.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 03 Aug 2021 03:24:17 -0700 (PDT)
Date: Tue, 3 Aug 2021 11:24:14 +0100
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 16/21] KVM: arm64: Enable retrieving protections
 attributes of PTEs
Message-ID: <YQkZTnVLwVYDFvoA@google.com>
References: <20210729132818.4091769-1-qperret@google.com>
 <20210729132818.4091769-17-qperret@google.com>
 <CA+EHjTwL+grX__03SfeDdxeppjSovEZhKRvqjmA_4kSBwsjswg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+EHjTwL+grX__03SfeDdxeppjSovEZhKRvqjmA_4kSBwsjswg@mail.gmail.com>
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

On Monday 02 Aug 2021 at 16:52:49 (+0200), Fuad Tabba wrote:
> Hi Quentin,
> 
> On Thu, Jul 29, 2021 at 3:29 PM Quentin Perret <qperret@google.com> wrote:
> >
> > Introduce helper functions in the KVM stage-2 and stage-1 page-table
> > manipulation library allowing to retrieve the enum kvm_pgtable_prot of a
> > PTE. This will be useful to implement custom walkers outside of
> > pgtable.c.
> >
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 20 +++++++++++++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 37 ++++++++++++++++++++++++++++
> >  2 files changed, 57 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index d5ca9b6ce241..7ff9f52239ba 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -505,4 +505,24 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >   */
> >  int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
> >                          kvm_pte_t *ptep, u32 *level);
> > +
> > +/**
> > + * kvm_pgtable_stage2_pte_prot() - Retrieve the protection attributes of a
> > + *                                stage-2 Page-Table Entry.
> > + * @pte:       Page-table entry
> > + *
> > + * Return: protection attributes of the page-table entry in the enum
> > + *        kvm_pgtable_prot format.
> > + */
> > +enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
> > +
> > +/**
> > + * kvm_pgtable_hyp_pte_prot() - Retrieve the protection attributes of a stage-1
> > + *                             Page-Table Entry.
> > + * @pte:       Page-table entry
> > + *
> > + * Return: protection attributes of the page-table entry in the enum
> > + *        kvm_pgtable_prot format.
> > + */
> > +enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
> >  #endif /* __ARM64_KVM_PGTABLE_H__ */
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 1915489bb127..a6eda8f23cb6 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -363,6 +363,26 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
> >         return 0;
> >  }
> >
> > +enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte)
> > +{
> > +       enum kvm_pgtable_prot prot = pte & KVM_PTE_LEAF_ATTR_HI_SW;
> > +       u32 ap;
> > +
> > +       if (!kvm_pte_valid(pte))
> > +               return prot;
> > +
> > +       if (!(pte & KVM_PTE_LEAF_ATTR_HI_S1_XN))
> > +               prot |= KVM_PGTABLE_PROT_X;
> > +
> > +       ap = FIELD_GET(KVM_PTE_LEAF_ATTR_LO_S1_AP, pte);
> > +       if (ap == KVM_PTE_LEAF_ATTR_LO_S1_AP_RO)
> > +               prot |= KVM_PGTABLE_PROT_R;
> > +       else if (ap == KVM_PTE_LEAF_ATTR_LO_S1_AP_RW)
> > +               prot |= KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W;
> 
> nit: why not use the freshly minted KVM_PGTABLE_PROT_RW?

No good reason, I'll fix that up, thanks!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
