Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E08F1C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 21:10:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 61F2561504
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 21:10:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 61F2561504
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE85F4B0D9;
	Wed, 29 Sep 2021 17:10:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fWt+Uu5RtGjn; Wed, 29 Sep 2021 17:10:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE6A54B090;
	Wed, 29 Sep 2021 17:10:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3EF94A5A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 17:10:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yZEoLltDJ0B9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Sep 2021 17:10:50 -0400 (EDT)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
 [209.85.216.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CFF524A3A5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 17:10:50 -0400 (EDT)
Received: by mail-pj1-f43.google.com with SMTP id
 oa12-20020a17090b1bcc00b0019f2d30c08fso3072362pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 14:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=eSi8jRqHCChCbRdByu+31RRuSb+xYsMKHrZgy6977k4=;
 b=qdfcMPpGzhf3bE3tkqdDAuk6qOvlx0ioEDswRc0v/ON2CoOSIN0QidqCNo5Ikwf/pl
 Q94+bOtcHV8wi+UslP2QhMR4URMwzzIHWGWr4DW1+vKJn0MPAUDcEh3T0bW+s6BWWbu3
 8akzG2wlbKhGSt4xoYoZMX1MfOSzmSm20mjgAZIIcRDXCeOp+lUtjYyXYCwA8sTzkg+Q
 9CaO7kCq2gVrGQcCtkq31MJU7DcXKlB+ZE/pDpJqluHW8guzlIG4PzaKIXHFAlc1Ixcj
 iRU6fOv3iH7P4Oieu811mJVU+EbZKBLTx/ouiVh48jR3CQ1GmRe3HKEazaSFpd7iTwr7
 J8Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=eSi8jRqHCChCbRdByu+31RRuSb+xYsMKHrZgy6977k4=;
 b=MeoxNplKlZb2ev5+rl61r8NYrqKuFTCeHHP2EBM0SJ5nLtdWIlom7UBz4OCoJt5z3F
 7cSkvdG4YO2zFqeC3j5go1znvCw9sObLkzP5h8wQCPOGhKVLjtYWtfbcrQs/dvy+L8Ko
 0p1bTANrC/Bqrq4efl0SDZ7YPisSGI1aWtwv8LYEMxFcJ7JjyY64RCObdE7Y99QdAV9B
 R11fJ7tCgYYBB1iVG/27mOp7EsvjKSXxWbroEbgo1wLwV8f7vv8Gxqql3dwNr7FO1DYU
 9w3PHdQULiq9pIFcSbmxsFMnQmIyplRLvC/XUjwOAiaFD/5Ce7BwkRY0nEttnQGtilfF
 dv4A==
X-Gm-Message-State: AOAM5316aJpAsxo4cDlzsPzzl/XbAjVAEmPWKy9OUfjMZs49C4TbLwDh
 MBbp89PsZ1oqkt4nuBIa9jjteQ==
X-Google-Smtp-Source: ABdhPJwXGd6YAz7NLKLEG9FaWIn3fO6ClLr2KS8DOXFDCqX+t+Q0Fl8tO14XGQ9yUacMtvRgVp7aew==
X-Received: by 2002:a17:902:dac4:b0:13d:acee:cacc with SMTP id
 q4-20020a170902dac400b0013daceecaccmr755277plx.0.1632949849474; 
 Wed, 29 Sep 2021 14:10:49 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id n26sm678894pfo.19.2021.09.29.14.10.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 29 Sep 2021 14:10:48 -0700 (PDT)
Date: Wed, 29 Sep 2021 14:10:45 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v3 02/10] KVM: arm64: vgic-v3: Check redist region is not
 above the VM IPA size
Message-ID: <YVTWVf26yYNUUx2L@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-3-ricarkol@google.com>
 <01a03d81-e98b-a504-f4b7-e4a56ffa78d5@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <01a03d81-e98b-a504-f4b7-e4a56ffa78d5@redhat.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, shuah@kernel.org, pshier@google.com,
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Eric,

On Wed, Sep 29, 2021 at 06:23:04PM +0200, Eric Auger wrote:
> Hi Ricardo,
> =

> On 9/28/21 8:47 PM, Ricardo Koller wrote:
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
> > diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/v=
gic-mmio-v3.c
> > index a09cdc0b953c..9be02bf7865e 100644
> > --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > @@ -796,7 +796,9 @@ static int vgic_v3_alloc_redist_region(struct kvm *=
kvm, uint32_t index,
> >  	struct vgic_dist *d =3D &kvm->arch.vgic;
> >  	struct vgic_redist_region *rdreg;
> >  	struct list_head *rd_regions =3D &d->rd_regions;
> > -	size_t size =3D count * KVM_VGIC_V3_REDIST_SIZE;
> > +	int nr_vcpus =3D atomic_read(&kvm->online_vcpus);
> > +	size_t size =3D count ? count * KVM_VGIC_V3_REDIST_SIZE
> > +			    : nr_vcpus * KVM_VGIC_V3_REDIST_SIZE;
> =

> This actually fixes the=A0 vgic_dist_overlap(kvm, base, size=3D0)
> =

> in case the number of online-vcpus at that time is less than the final
> one (1st run), if count=3D0 (legacy API) do we ever check that the RDIST
> (with accumulated vcpu rdists) does not overlap with dist.
> in other words shouldn't we call vgic_dist_overlap(kvm, base, size)
> again in vgic_v3_check_base().
> =


I think we're good; that's checked by vgic_v3_rdist_overlap(dist_base)
in vgic_v3_check_base(). This function uses the only region (legacy
case) using a size based on the online_vcpus (in
vgic_v3_rd_region_size()).  This exact situation is tested by
test_vgic_then_vcpus() in the vgic_init selftest.

Thanks,
Ricardo

> Thanks
> =

> Eric
> =

> >  	int ret;
> >  =

> >  	/* cross the end of memory ? */
> > @@ -840,7 +842,7 @@ static int vgic_v3_alloc_redist_region(struct kvm *=
kvm, uint32_t index,
> >  =

> >  	rdreg->base =3D VGIC_ADDR_UNDEF;
> >  =

> > -	ret =3D vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);
> > +	ret =3D vgic_check_iorange(kvm, &rdreg->base, base, SZ_64K, size);
> >  	if (ret)
> >  		goto free;
> >  =

> > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v=
3.c
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
> >  	}
> >  =

> >  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
> =

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
