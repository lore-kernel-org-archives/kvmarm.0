Return-Path: <SRS0=SY58=OK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B0FC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 21:06:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 551096115B
	for <kvmarm@archiver.kernel.org>; Mon, 20 Sep 2021 21:06:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 551096115B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD3874057F;
	Mon, 20 Sep 2021 17:06:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BPqIVhRnEiuc; Mon, 20 Sep 2021 17:06:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9723040667;
	Mon, 20 Sep 2021 17:06:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3C014057F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 17:06:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tPAuC3XveyEP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Sep 2021 17:06:20 -0400 (EDT)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7BB9E4024F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 17:06:20 -0400 (EDT)
Received: by mail-pj1-f52.google.com with SMTP id
 p12-20020a17090adf8c00b0019c959bc795so931374pjv.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 14:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=XcdvaCng9FOAEUwEM752oQTsKp7wO8UtsrtvTvd7Atk=;
 b=LhcKmSl3aTohEmXgs+IQB2/khzXdhw5WBw6BcvXK38HLHoblakIFGnzW8dngvn9nak
 6mYmlKAwnSJv16pX7LS+P7vuE3Zvl9FPz+4sULh0X2zeKjQTGcBpivIDfE92IChwzPEF
 K1lYp11kCQsNtTVAiaMUocKnfDZVXgiUSTjjxiiZru8t7a3zPbyDjMOydtwTuLTto1tC
 cLP7nrnWHIgDVrGAtSBTe+1xnzkOG1h7MLwUsZPcTllo02oX3w+JQYAW3eh/FApxy0Rg
 mfswXHW1SeAVoUadPALWA22S8zR9tDqW4pFuuYV4vgjcJawYKiCeoP3dtzlFbBpEDM0a
 LdhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=XcdvaCng9FOAEUwEM752oQTsKp7wO8UtsrtvTvd7Atk=;
 b=m/BJKS+c99nfugiogmjhq8XRirKMwGlHm6r2DUvAlAT/XBZy+w07b9ZvortJKo4n8t
 fuslDBkoRGZXxEx8DXYgvWNrJJF08+tbVslUyn14b8l77SqMWleBaIhtFivOajhMKULk
 j7URhyX9ldKj4IW1mCXZ9WRMCTGhxEOrdswWwgGRgUokV63LmzRwawbhpr0+6S9tu+9Y
 8ChZYBUmb6n12muJKvSD2JVptWcZhDP/VpJByfK/oP+DyA7FS98CTXFLVoqjsEPlYulS
 vR7LBkm2D6P/ckrrQoanHTWpt/xsIw7eEydt0hlJ79sus7vp8nxKkFAWaNMc4TTZH+nP
 lVoQ==
X-Gm-Message-State: AOAM533xwNvGlj6eEgwhulJBikqLmxXzq3Gx4wdUL1EOsk34rFdAM5Wh
 c8/hx/78R8PiM5SnLdk5a9VA5A==
X-Google-Smtp-Source: ABdhPJyYH1s2i3HfOPJIZRH+RtyJJg78EOVtkM9t65i+UYvvNqVRCpzCrAaiE1+8/6orpJR1Jr5NBQ==
X-Received: by 2002:a17:90b:1644:: with SMTP id
 il4mr1119135pjb.43.1632171979407; 
 Mon, 20 Sep 2021 14:06:19 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id w5sm16032561pgp.79.2021.09.20.14.06.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Sep 2021 14:06:18 -0700 (PDT)
Date: Mon, 20 Sep 2021 14:06:15 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 1/2] KVM: arm64: vgic: check redist region is not
 above the VM IPA size
Message-ID: <YUj3x61sT+TlxBd3@google.com>
References: <20210910004919.1610709-1-ricarkol@google.com>
 <20210910004919.1610709-2-ricarkol@google.com>
 <87sfxzv37z.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87sfxzv37z.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, shuah@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

On Mon, Sep 20, 2021 at 01:30:40PM +0100, Marc Zyngier wrote:
> Hi Ricardo,
> 
> On Fri, 10 Sep 2021 01:49:18 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > Verify that the redistributor regions do not extend beyond the
> > VM-specified IPA size (phys_size). This can happen when using
> > KVM_VGIC_V3_ADDR_TYPE_REDIST or KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS
> > with:
> > 
> >   base + size > phys_size AND base < phys_size
> > 
> > Add the missing check into vgic_v3_alloc_redist_region() which is called
> > when setting the regions, and into vgic_v3_check_base() which is called
> > when attempting the first vcpu-run. The vcpu-run check does not apply to
> > KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS because the regions size is known
> > before the first vcpu-run. Finally, this patch also enables some extra
> > tests in vgic_v3_alloc_redist_region() by calculating "size" early for
> > the legacy redist api.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 7 ++++++-
> >  arch/arm64/kvm/vgic/vgic-v3.c      | 4 ++++
> >  2 files changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > index a09cdc0b953c..055671bede85 100644
> > --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > @@ -796,7 +796,9 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
> >  	struct vgic_dist *d = &kvm->arch.vgic;
> >  	struct vgic_redist_region *rdreg;
> >  	struct list_head *rd_regions = &d->rd_regions;
> > -	size_t size = count * KVM_VGIC_V3_REDIST_SIZE;
> > +	int nr_vcpus = atomic_read(&kvm->online_vcpus);
> > +	size_t size = count ? count * KVM_VGIC_V3_REDIST_SIZE :
> > +			nr_vcpus * KVM_VGIC_V3_REDIST_SIZE;
> >  	int ret;
> >  
> >  	/* cross the end of memory ? */
> > @@ -834,6 +836,9 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
> >  	if (vgic_v3_rdist_overlap(kvm, base, size))
> >  		return -EINVAL;
> >  
> > +	if (base + size > kvm_phys_size(kvm))
> > +		return -E2BIG;
> > +
> >  	rdreg = kzalloc(sizeof(*rdreg), GFP_KERNEL);
> >  	if (!rdreg)
> >  		return -ENOMEM;
> > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> > index 66004f61cd83..5afd9f6f68f6 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> > @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
> >  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
> >  			rdreg->base)
> >  			return false;
> > +
> > +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
> > +			kvm_phys_size(kvm))
> > +			return false;
> >  	}
> >  
> >  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
> 
> How about vgic-v2? From what I can see, the placement of the
> distributor and CPU interface should be subjected to the same checks
> (see vgic_v2_check_base()).
> 

Yes, gic-v2 has the same problem. Alexandru first mentioned it here:

  https://lore.kernel.org/kvmarm/5eb41efd-2ff2-d25b-5801-f4a56457a09f@arm.com/

I'm now working on the next version of the patch which applies to gic-v2
as well.

Thanks,
Ricardo

> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
