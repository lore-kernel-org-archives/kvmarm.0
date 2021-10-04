Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BDC0C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 15:51:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9C99E6137C
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 15:51:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9C99E6137C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18C0E4B27B;
	Mon,  4 Oct 2021 11:51:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lMXkb8ym5-IZ; Mon,  4 Oct 2021 11:51:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43F4A4B27E;
	Mon,  4 Oct 2021 11:51:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D5694B27A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 11:51:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EUyRb4Xh+h3Y for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 11:51:14 -0400 (EDT)
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com
 [209.85.210.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B20B24B276
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 11:51:14 -0400 (EDT)
Received: by mail-pf1-f182.google.com with SMTP id h1so4173617pfv.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 08:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=xUHxcFcyLxlbEOzo0/4y2u7gqH4zbLfEbPVenn/dP48=;
 b=Vfp46Kuwavj/NMt2Qg9t7k4RyZbxRURDyGDpz7aAdeKzY2h5om7qWhdP8UtSMxnga2
 e9cuSjRGMR+mHKRJh/IUaMCHudDOu5Td3bYJ8xVrW+0G0ab/3taDA9xrfbngobjQ30rH
 uLgiWs41UV7bDpFnnUWLQdCD9eUV5Sl33zSUfLaqrH1uunSfyooJJed2taMSmC+B9nZ+
 IFKRFpB+EllKnb0UeyzeyaCW+p+1Wu5i3jNrrDLzhWxoFNtHAtcMY5LJjJsUd0yx34G2
 gIfefmc1thscr9AQamZYcakBaGPjX/+UzXcuDGoPhG2i26t220Cv/4R1ASXQivBuDo4f
 aAHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xUHxcFcyLxlbEOzo0/4y2u7gqH4zbLfEbPVenn/dP48=;
 b=H+dPA0OVu+HtZBNeoaoZ+msnJZC9YQiuRYtVW0Ut+XPUB/1lb3HBFtqthTAaF6mCL4
 o7uAtEjNvulH7hwG9MnPXAkYfwgMDLYhWz+ppIUKkRZEDQjKAwfF/BfC70cSsi/32ekp
 7NyihBFj6g64Q837SmG/AkSOBY7V8oLcoXVQ9sjmtnMrB3zCJGfZARxnTEb1YKffmk4F
 x/jsoBfOPETtN64/iEDxhY4EIenpEahe6dWi44KlCc7iO36SK8K3rzWJiAqWF7qyGhjJ
 0FkGmnK1UN88YXSUkkPrkfKWcLsHpHqsCLsySvHUDchnXg2KPlo869whtgTXVXlfomwB
 zLzw==
X-Gm-Message-State: AOAM5322n8Z9tKtRGVzPZVdq36/omxoLbDJsfxbIRzuI9znsLJeobIqc
 v8zTYZvRcL9VTWrYP8e+fotklA==
X-Google-Smtp-Source: ABdhPJyC+5fhEKyG5XQpAML44RdjCbH4hWjl23Jf1ce6Vi2z9vI9fP3aC3o/6cQ93sYpsLIaRYkC4A==
X-Received: by 2002:a62:4ec6:0:b0:44c:7488:e593 with SMTP id
 c189-20020a624ec6000000b0044c7488e593mr879676pfb.59.1633362673514; 
 Mon, 04 Oct 2021 08:51:13 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id v13sm2828697pjr.3.2021.10.04.08.51.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Oct 2021 08:51:12 -0700 (PDT)
Date: Mon, 4 Oct 2021 08:51:09 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 02/10] KVM: arm64: vgic-v3: Check redist region is not
 above the VM IPA size
Message-ID: <YVsi7d4v7WLRRR6c@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-3-ricarkol@google.com>
 <87ilygsx8q.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87ilygsx8q.wl-maz@kernel.org>
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

On Fri, Oct 01, 2021 at 02:14:29PM +0100, Marc Zyngier wrote:
> On Tue, 28 Sep 2021 19:47:56 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > Verify that the redistributor regions do not extend beyond the
> > VM-specified IPA range (phys_size). This can happen when using
> > KVM_VGIC_V3_ADDR_TYPE_REDIST or KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS
> > with:
> > 
> >   base + size > phys_size AND base < phys_size
> > 
> > Add the missing check into vgic_v3_alloc_redist_region() which is called
> > when setting the regions, and into vgic_v3_check_base() which is called
> > when attempting the first vcpu-run. The vcpu-run check does not apply to
> > KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS because the regions size is known
> > before the first vcpu-run. Note that using the REDIST_REGIONS API
> > results in a different check, which already exists, at first vcpu run:
> > that the number of redist regions is enough for all vcpus.
> > 
> > Finally, this patch also enables some extra tests in
> > vgic_v3_alloc_redist_region() by calculating "size" early for the legacy
> > redist api: like checking that the REDIST region can fit all the already
> > created vcpus.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 6 ++++--
> >  arch/arm64/kvm/vgic/vgic-v3.c      | 4 ++++
> >  2 files changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > index a09cdc0b953c..9be02bf7865e 100644
> > --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > @@ -796,7 +796,9 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
> >  	struct vgic_dist *d = &kvm->arch.vgic;
> >  	struct vgic_redist_region *rdreg;
> >  	struct list_head *rd_regions = &d->rd_regions;
> > -	size_t size = count * KVM_VGIC_V3_REDIST_SIZE;
> > +	int nr_vcpus = atomic_read(&kvm->online_vcpus);
> > +	size_t size = count ? count * KVM_VGIC_V3_REDIST_SIZE
> > +			    : nr_vcpus * KVM_VGIC_V3_REDIST_SIZE;
> >  	int ret;
> >  
> >  	/* cross the end of memory ? */
> > @@ -840,7 +842,7 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
> >  
> >  	rdreg->base = VGIC_ADDR_UNDEF;
> >  
> > -	ret = vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);
> > +	ret = vgic_check_iorange(kvm, &rdreg->base, base, SZ_64K, size);
> >  	if (ret)
> >  		goto free;
> >  
> > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> > index 21a6207fb2ee..27ee674631b3 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> > @@ -486,6 +486,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
> >  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
> >  			rdreg->base)
> >  			return false;
> > +
> > +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
> > +			kvm_phys_size(kvm))
> > +			return false;
> 
> Why can't we replace these two checks with a single call to your new
> fancy helper?

ACK using the new helper (on rdreg base and size).

Thanks,
Ricardo

> 
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
