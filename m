Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98AD7C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 23:13:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20DE349E3A;
	Tue, 15 Mar 2022 19:13:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0jS2m+CIBs3B; Tue, 15 Mar 2022 19:13:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADE6249F04;
	Tue, 15 Mar 2022 19:13:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 831AE49F04
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 19:13:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hQcFUPHA-bzL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 19:13:14 -0400 (EDT)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com
 [209.85.166.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 05C7549E3A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 19:13:13 -0400 (EDT)
Received: by mail-io1-f52.google.com with SMTP id h63so523227iof.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 16:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=mkSBqRczsdqseUzQVQ803PyalOUpJRNV22LE07GLzWA=;
 b=cJo1bjGbiKF7Q5JqUvCkE6Nkf4qZnP/YXbmZOuztmCDD8HTumQE7ewaddRkVQCR83P
 pQeSg8FS5hZk/OuVGcQAhKbB0YbVu4SApnVfjSXlfNhG1GRgHF9ryCJubxZtADrtURnx
 hM72J8DBoRlcO1tc8gu5fYAvW8R6HnbUij0JcjRajM5N40lT4/UUZjUF7ZP9nKljLC8A
 Gwecz7bHnWc5drxz0l/NIO14mo8tFmdzJcF0chQBspFakimTULUWCpgRU3fZsoOVTgrE
 II6/7rDMV66kRqVq4qA+tJM2m0hqYNL8kRwBKx1jQ+kf3EsIgzjc0GxCyDFZ4JUm5yhK
 fLag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=mkSBqRczsdqseUzQVQ803PyalOUpJRNV22LE07GLzWA=;
 b=7HoUEe4pbEGBgpsB8VSK24GNVdzcO3bwqFI1HASSYp5YaTbs3fXUs+Wqc8+nd507b9
 4RCZ+0cyshXlPH2VV0YA7dIl0ho1EDIFDpZvlPxCzps+zKImGj/djudvR472dkxVeoFZ
 ctvWsQp8zJJIUvAdy8wx4978NW7bEtfrARBP+ylLeKym0w6fkFkZ2CToqk70DlW+RO2x
 mnGbeVNcGqcs20G31lYQtPnjvPj7em+6jbkQYE52OBqEhvTL6luUW765U24n6clcxoaY
 X6kyBpndsd5lKK8FDRABizbbakmpxdoMrQw1H4XyL10Nr30cgInVm21pbJg5DRc193A2
 D33Q==
X-Gm-Message-State: AOAM533V5nLisoxnSIB4oC1Ed2YJ8Jz7lG2Cpwq+BE32sIlGg7KEedUG
 5UkT+oiuwTX//x9frjTmtQJ0Aw==
X-Google-Smtp-Source: ABdhPJxnLYPt8PSylbYInqqM86gCog/y/X9+CUSlxw7r1ZOrECfYR/o23iyqho8xxThyel1VGO6tjQ==
X-Received: by 2002:a05:6638:d01:b0:31a:23d7:85d1 with SMTP id
 q1-20020a0566380d0100b0031a23d785d1mr1890548jaj.269.1647385992860; 
 Tue, 15 Mar 2022 16:13:12 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 f1-20020a056e020b4100b002c68e176293sm247658ilu.87.2022.03.15.16.13.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 16:13:12 -0700 (PDT)
Date: Tue, 15 Mar 2022 23:13:09 +0000
From: Oliver Upton <oupton@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 4/4] KVM: arm64: vgic-v3: Advertise GICR_CTLR.{IR, CES}
 as a new GICD_IIDR revision
Message-ID: <YjEdhVFKTkS4GiIS@google.com>
References: <20220314164044.772709-1-maz@kernel.org>
 <20220314164044.772709-5-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220314164044.772709-5-maz@kernel.org>
Cc: Andre Przywara <andre.przywara@arm.com>, kernel-team@android.com,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

Hi Marc,

On Mon, Mar 14, 2022 at 04:40:44PM +0000, Marc Zyngier wrote:
> Since adversising GICR_CTLR.{IC,CES} is directly observable from
> a guest, we need to make it selectable from userspace.
> 
> For that, bump the default GICD_IIDR revision and let userspace
> downgrade it to the previous default. For GICv2, the two distributor
> revisions are strictly equivalent.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c    |  7 ++++++-
>  arch/arm64/kvm/vgic/vgic-mmio-v2.c | 18 +++++++++++++++---
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 23 +++++++++++++++++++++--
>  include/kvm/arm_vgic.h             |  3 +++
>  4 files changed, 45 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index fc00304fe7d8..f84e04f334c6 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -319,7 +319,12 @@ int vgic_init(struct kvm *kvm)
>  
>  	vgic_debug_init(kvm);
>  
> -	dist->implementation_rev = 2;
> +	/*
> +	 * If userspace didn't set the GIC implementation revision,
> +	 * default to the latest and greatest. You know want it.
> +	 */
> +	if (!dist->implementation_rev)
> +		dist->implementation_rev = KVM_VGIC_IMP_REV_LATEST;
>  	dist->initialized = true;
>  
>  out:
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
> index 12e4c223e6b8..f2246c4ca812 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
> @@ -73,9 +73,13 @@ static int vgic_mmio_uaccess_write_v2_misc(struct kvm_vcpu *vcpu,
>  					   gpa_t addr, unsigned int len,
>  					   unsigned long val)
>  {
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +	u32 reg;
> +
>  	switch (addr & 0x0c) {
>  	case GIC_DIST_IIDR:
> -		if (val != vgic_mmio_read_v2_misc(vcpu, addr, len))
> +		reg = vgic_mmio_read_v2_misc(vcpu, addr, len);
> +		if ((reg ^ val) & ~GICD_IIDR_REVISION_MASK)
>  			return -EINVAL;
>  
>  		/*
> @@ -87,8 +91,16 @@ static int vgic_mmio_uaccess_write_v2_misc(struct kvm_vcpu *vcpu,
>  		 * migration from old kernels to new kernels with legacy
>  		 * userspace.
>  		 */
> -		vcpu->kvm->arch.vgic.v2_groups_user_writable = true;
> -		return 0;
> +		reg = FIELD_GET(GICD_IIDR_REVISION_MASK, reg);
> +		switch (reg) {
> +		case KVM_VGIC_IMP_REV_2:
> +		case KVM_VGIC_IMP_REV_3:
> +			dist->v2_groups_user_writable = true;

Could you eliminate this bool and just pivot off of the implementation
version?

> +			dist->implementation_rev = reg;
> +			return 0;
> +		default:
> +			return -EINVAL;
> +		}
>  	}
>  
>  	vgic_mmio_write_v2_misc(vcpu, addr, len, val);
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index a6be403996c6..4c8e4f83e3d1 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -155,13 +155,27 @@ static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
>  					   unsigned long val)
>  {
>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +	u32 reg;
>  
>  	switch (addr & 0x0c) {
>  	case GICD_TYPER2:
> -	case GICD_IIDR:
>  		if (val != vgic_mmio_read_v3_misc(vcpu, addr, len))
>  			return -EINVAL;
>  		return 0;
> +	case GICD_IIDR:
> +		reg = vgic_mmio_read_v3_misc(vcpu, addr, len);
> +		if ((reg ^ val) & ~GICD_IIDR_REVISION_MASK)
> +			return -EINVAL;
> +
> +		reg = FIELD_GET(GICD_IIDR_REVISION_MASK, reg);
> +		switch (reg) {
> +		case KVM_VGIC_IMP_REV_2:
> +		case KVM_VGIC_IMP_REV_3:
> +			dist->implementation_rev = reg;
> +			return 0;
> +		default:
> +			return -EINVAL;
> +		}
>  	case GICD_CTLR:
>  		/* Not a GICv4.1? No HW SGIs */
>  		if (!kvm_vgic_global_state.has_gicv4_1)
> @@ -232,8 +246,13 @@ static unsigned long vgic_mmio_read_v3r_ctlr(struct kvm_vcpu *vcpu,
>  					     gpa_t addr, unsigned int len)
>  {
>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +	unsigned long val;
> +
> +	val = atomic_read(&vgic_cpu->ctlr);
> +	if (vcpu->kvm->arch.vgic.implementation_rev >= KVM_VGIC_IMP_REV_3)

That's a lot of indirection :) Could you make a helper for getting at
the implementation revision from a vCPU pointer?

> +		val |= GICR_CTLR_IR | GICR_CTLR_CES;
>  
> -	return vgic_cpu->lpis_enabled ? GICR_CTLR_ENABLE_LPIS : 0;
> +	return val;
>  }
>  
>  static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 401236f97cf2..2d8f2e90edc2 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -231,6 +231,9 @@ struct vgic_dist {
>  
>  	/* Implementation revision as reported in the GICD_IIDR */
>  	u32			implementation_rev;
> +#define KVM_VGIC_IMP_REV_2	2 /* GICv2 restorable groups */
> +#define KVM_VGIC_IMP_REV_3	3 /* GICv3 GICR_CTLR.{IW,CES,RWP} */
> +#define KVM_VGIC_IMP_REV_LATEST	KVM_VGIC_IMP_REV_3
>  
>  	/* Userspace can write to GICv2 IGROUPR */
>  	bool			v2_groups_user_writable;
> -- 
> 2.34.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
