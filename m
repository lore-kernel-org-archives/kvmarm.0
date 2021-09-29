Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E399C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 21:17:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B6F1561278
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 21:17:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B6F1561278
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1B674B091;
	Wed, 29 Sep 2021 17:17:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9mepZ5VRPSvU; Wed, 29 Sep 2021 17:17:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A35614B09C;
	Wed, 29 Sep 2021 17:17:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1C244B08A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 17:17:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zYHluYHieuR2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Sep 2021 17:17:13 -0400 (EDT)
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com
 [209.85.215.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D16874A98B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 17:17:13 -0400 (EDT)
Received: by mail-pg1-f172.google.com with SMTP id 133so4052220pgb.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 14:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=33MJea1whoLNtrMC9eiHI/diRhmiXqXXdKlxLsoaF+0=;
 b=eGI4XVSq3HIPvlsyLN06O8MDA2W61KnG2XZhVXTLSIBo+pmbUFhUiMp/1S+37juyLO
 YO0ULnTTdXXVwSRvCyr4tkVDpjrOJnBARtVzvzrEIFPscfeI4L+w5kMCiQserweIpDlm
 LFOSrZsPTV19Ceofilnf3MuRnRlQKHwgfd03Ihq3WyOkVLw9KcucJZsNrjsWD8RWvSNR
 E0lTVl1x+wVF91qv0PuHHt8cPMkz8WTWKakxFio6snzZ39c5ELi1lQEGLgHktt3ynnKM
 x6KzzuM7sRAp/eja6lcl7LuyNldFSU91V2QrjeUZyDWBakO7skvZ6p3qhEB3qG/YtHN9
 B4Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=33MJea1whoLNtrMC9eiHI/diRhmiXqXXdKlxLsoaF+0=;
 b=qpb9upIJEyJUUx4hX/FGt84cxGoDC4h3D7UBPgmvHcC+ZXOEMYhxgeYUBL0lkgXQcM
 a06d+A68P8dlBN3mQ72R5zWTJTwv+4jSYKQ6+amLVBnITzI1o01KqOMwqXellvhd3QxJ
 kwS2iWtlWmRtm8jfbHoFVIIE1pXFrQ8P/aTAm6azxj2reMBagGYovJnsmoKH5+Iahnz1
 2aD5aMlhttbcsMgjVFPGDFATVrYdGmc2xiQJqpc2Jysw/V8D6UK6n660BgaC2UKc2C6J
 pk9JU2+/12x+wLcHJ7n8FeVnA4A6Jyuh3nG7dDdhEW40Dhkwf0PfIn8MmHy0JL9DNN75
 24/g==
X-Gm-Message-State: AOAM53095KgVnoYFvzcmBZu8pXXwwu/jCQiacP0J+gG9nBcSYZlGduTT
 J3fXeSmcHZhAix8AHECtFFhkog==
X-Google-Smtp-Source: ABdhPJwigR/CWqCj7YE1ZL9tAzR7+KJ0P+RsA3KXHWpL8Gic6pWADyWuuyfLP/thXtjXkEOqgMIWEg==
X-Received: by 2002:a63:1444:: with SMTP id 4mr1669742pgu.381.1632950232579;
 Wed, 29 Sep 2021 14:17:12 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id r29sm624305pfq.74.2021.09.29.14.17.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 29 Sep 2021 14:17:11 -0700 (PDT)
Date: Wed, 29 Sep 2021 14:17:08 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v3 01/10] kvm: arm64: vgic: Introduce vgic_check_iorange
Message-ID: <YVTX1L8u8NMxHAyE@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-2-ricarkol@google.com>
 <4ab60884-e006-723a-c026-b3e8c0ccb349@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ab60884-e006-723a-c026-b3e8c0ccb349@redhat.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Sep 29, 2021 at 06:29:21PM +0200, Eric Auger wrote:
> Hi Ricardo,
> 
> On 9/28/21 8:47 PM, Ricardo Koller wrote:
> > Add the new vgic_check_iorange helper that checks that an iorange is
> > sane: the start address and size have valid alignments, the range is
> > within the addressable PA range, start+size doesn't overflow, and the
> > start wasn't already defined.
> >
> > No functional change.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-kvm-device.c | 22 ++++++++++++++++++++++
> >  arch/arm64/kvm/vgic/vgic.h            |  4 ++++
> >  2 files changed, 26 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > index 7740995de982..f714aded67b2 100644
> > --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > @@ -29,6 +29,28 @@ int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
> >  	return 0;
> >  }
> >  
> > +int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
> > +		       phys_addr_t addr, phys_addr_t alignment,
> > +		       phys_addr_t size)
> > +{
> > +	int ret;
> > +
> > +	ret = vgic_check_ioaddr(kvm, ioaddr, addr, alignment);
> nit: not related to this patch but I am just wondering why we are
> passing phys_addr_t *ioaddr downto vgic_check_ioaddr and thus to
> 
> vgic_check_iorange()? This must be a leftover of some old code?
> 

It's used to check that the base of a region is not already set.
kvm_vgic_addr() uses it to make that check;
vgic_v3_alloc_redist_region() does not:

  rdreg->base = VGIC_ADDR_UNDEF; // so the "not already defined" check passes
  ret = vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);

Thanks,
Ricardo

> > +	if (ret)
> > +		return ret;
> > +
> > +	if (!IS_ALIGNED(size, alignment))
> > +		return -EINVAL;
> > +
> > +	if (addr + size < addr)
> > +		return -EINVAL;
> > +
> > +	if (addr + size > kvm_phys_size(kvm))
> > +		return -E2BIG;
> > +
> > +	return 0;
> > +}
> > +
> >  static int vgic_check_type(struct kvm *kvm, int type_needed)
> >  {
> >  	if (kvm->arch.vgic.vgic_model != type_needed)
> > diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> > index 14a9218641f5..c4df4dcef31f 100644
> > --- a/arch/arm64/kvm/vgic/vgic.h
> > +++ b/arch/arm64/kvm/vgic/vgic.h
> > @@ -175,6 +175,10 @@ void vgic_irq_handle_resampling(struct vgic_irq *irq,
> >  int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
> >  		      phys_addr_t addr, phys_addr_t alignment);
> >  
> > +int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
> > +		       phys_addr_t addr, phys_addr_t alignment,
> > +		       phys_addr_t size);
> > +
> >  void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
> >  void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
> >  void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
> Besides
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Eric
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
