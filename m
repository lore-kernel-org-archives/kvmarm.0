Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F3CC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 16 Mar 2022 05:39:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF1AE4086F;
	Wed, 16 Mar 2022 01:39:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qa7xm+Uy1qa3; Wed, 16 Mar 2022 01:39:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E1DC40BBF;
	Wed, 16 Mar 2022 01:39:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69BB24087B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 01:39:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Uo14tJwUW7PK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2022 01:39:08 -0400 (EDT)
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com
 [209.85.166.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F06E84086F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 01:39:07 -0400 (EDT)
Received: by mail-io1-f49.google.com with SMTP id r11so1176453ioh.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 22:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=tImL+KREVFx5Xe6VSgg3OLNSE1Nzb30bkyhv7yK3P2E=;
 b=c0Qa+kCUT05juhERZaJ09N8JBPmsIBDOhqJyK4z0UArHmQAXoOikmg6h2HmuQd0QSN
 gnLdnRLhTrXMoiHWu0DjzomTeJX316/Gp/dAz+t78lZkHsXoZXO5c3nu2j7NH93R6kfT
 lxbwdNrnDDK6NttcuXxrjbE2/gb/MAaNj7S6pggmbbnOrEZGytqr5B98BC9jXUkEWbRH
 mzbkkCcGO72gJsb6hHYPXUBguJxeVqiLA+u/tyoT3hunI3XCGvI0MgoCCDe0ckMH2ggM
 bQLg8qNjDiabq/SPvzDpTPROd6EqplYh6+JeN4L2/X/wunVa+L3K3ASWqyprkenNukB/
 tVZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=tImL+KREVFx5Xe6VSgg3OLNSE1Nzb30bkyhv7yK3P2E=;
 b=LbrQbyEyI3iN5Lsyf1bBeDo8Sp/GoYy5KG3JN0nnNVzU6B8FpF4wHDBZNnOkbR49L+
 TDYlMLhoWSx/iQa2zLwi8ivnsSLNeyX0qH5Cv4n9OeNox1RfsgYFa3ujr9mIgqOp7Usz
 6vBJ3o3DHAtcmU34dc+vNsAFHiTmKx7vfsrVtsS3ILPpBrp3Z0QDl2tM4V7vADV3HdOi
 0QAD5S2QpMORuMzm1nyKhGHYiB0T/9B99qtLuiYbse1SnIMG92+7A51Srq6p5NtOMAmd
 /XozjZhvXSDyABTk0Qr4YHDi43k+kOo/FhDeXZiGIzIX915D9+Rz8HB7ecBMLKOQQul8
 jaFA==
X-Gm-Message-State: AOAM530ve2YbxqwUbUvnsH5IzEZaXRfEaEjqYizrqtdAD1j3IK3a3aRX
 xSyv0bhpQgHvq26c1/C6z7jVLQ==
X-Google-Smtp-Source: ABdhPJzNNCTRz6wkXDlIyNwVOeZMt3x9n2le3+C7+5jACUiMVbr7LElbwPChd2ja+lhjU+6yqG/50g==
X-Received: by 2002:a05:6638:3828:b0:319:f272:1efa with SMTP id
 i40-20020a056638382800b00319f2721efamr13054794jav.282.1647409146929; 
 Tue, 15 Mar 2022 22:39:06 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 h22-20020a5d9716000000b00645e6e57d5dsm561201iol.1.2022.03.15.22.39.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 22:39:06 -0700 (PDT)
Date: Wed, 16 Mar 2022 05:39:03 +0000
From: Oliver Upton <oupton@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 3/4] KVM: arm64: vgic-v3: Expose GICR_CTLR.RWP when
 disabling LPIs
Message-ID: <YjF394i1+ZxJF7VQ@google.com>
References: <20220314164044.772709-1-maz@kernel.org>
 <20220314164044.772709-4-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220314164044.772709-4-maz@kernel.org>
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

On Mon, Mar 14, 2022 at 04:40:43PM +0000, Marc Zyngier wrote:
> When disabling LPIs, a guest needs to poll GICR_CTLR.RWP in order
> to be sure that the write has taken effect. We so far reported it
> as 0, as we didn't advertise that LPIs could be turned off the
> first place.
> 
> Start tracking this state during which LPIs are being disabled,
> and expose the 'in progress' state via the RWP bit.
> 
> We also take this opportunity to disallow enabling LPIs and programming
> GICR_{PEND,PROP}BASER while LPI disabling is in progress, as allowed by
> the architecture (UNPRED behaviour).
> 
> We don't advertise the feature to the guest yet (which is allowed by
> the architecture).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c     |  2 +-
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 44 ++++++++++++++++++++----------
>  arch/arm64/kvm/vgic/vgic.h         |  1 +
>  include/kvm/arm_vgic.h             |  4 +--
>  4 files changed, 34 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index cc62d8a8180f..9f51d624730f 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -683,7 +683,7 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
>  	if (!vcpu)
>  		return E_ITS_INT_UNMAPPED_INTERRUPT;
>  
> -	if (!vcpu->arch.vgic_cpu.lpis_enabled)
> +	if (!vgic_lpis_enabled(vcpu))
>  		return -EBUSY;
>  
>  	vgic_its_cache_translation(kvm, its, devid, eventid, ite->irq);
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index 186bf35078bf..a6be403996c6 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -221,6 +221,13 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
>  	vgic_put_irq(vcpu->kvm, irq);
>  }
>  
> +bool vgic_lpis_enabled(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +
> +	return atomic_read(&vgic_cpu->ctlr) == GICR_CTLR_ENABLE_LPIS;
> +}
> +
>  static unsigned long vgic_mmio_read_v3r_ctlr(struct kvm_vcpu *vcpu,
>  					     gpa_t addr, unsigned int len)
>  {
> @@ -229,26 +236,39 @@ static unsigned long vgic_mmio_read_v3r_ctlr(struct kvm_vcpu *vcpu,
>  	return vgic_cpu->lpis_enabled ? GICR_CTLR_ENABLE_LPIS : 0;
>  }
>  
> -
>  static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
>  				     gpa_t addr, unsigned int len,
>  				     unsigned long val)
>  {
>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> -	bool was_enabled = vgic_cpu->lpis_enabled;
> +	u32 ctlr;
>  
>  	if (!vgic_has_its(vcpu->kvm))
>  		return;
>  
> -	vgic_cpu->lpis_enabled = val & GICR_CTLR_ENABLE_LPIS;
> +	if (!(val & GICR_CTLR_ENABLE_LPIS)) {
> +		/*
> +		 * Don't disable if RWP is set, as there already an
> +		 * ongoing disable. Funky guest...
> +		 */
> +		ctlr = atomic_cmpxchg_acquire(&vgic_cpu->ctlr,
> +					      GICR_CTLR_ENABLE_LPIS,
> +					      GICR_CTLR_RWP);
> +		if (ctlr != GICR_CTLR_ENABLE_LPIS)
> +			return;
>  
> -	if (was_enabled && !vgic_cpu->lpis_enabled) {
>  		vgic_flush_pending_lpis(vcpu);
>  		vgic_its_invalidate_cache(vcpu->kvm);
> -	}
> +		smp_mb__before_atomic();
> +		atomic_set(&vgic_cpu->ctlr, 0);
> +	} else {
> +		ctlr = atomic_cmpxchg_acquire(&vgic_cpu->ctlr, 0,
> +					      GICR_CTLR_ENABLE_LPIS);
> +		if (ctlr != 0)
> +			return;
>  
> -	if (!was_enabled && vgic_cpu->lpis_enabled)
>  		vgic_enable_lpis(vcpu);
> +	}
>  }
>  
>  static bool vgic_mmio_vcpu_rdist_is_last(struct kvm_vcpu *vcpu)
> @@ -478,11 +498,10 @@ static void vgic_mmio_write_propbase(struct kvm_vcpu *vcpu,
>  				     unsigned long val)
>  {
>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> -	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>  	u64 old_propbaser, propbaser;
>  
>  	/* Storing a value with LPIs already enabled is undefined */
> -	if (vgic_cpu->lpis_enabled)
> +	if (vgic_lpis_enabled(vcpu))
>  		return;
>  
>  	do {
> @@ -513,7 +532,7 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
>  	u64 old_pendbaser, pendbaser;
>  
>  	/* Storing a value with LPIs already enabled is undefined */
> -	if (vgic_cpu->lpis_enabled)
> +	if (vgic_lpis_enabled(vcpu))
>  		return;
>  
>  	do {
> @@ -546,10 +565,9 @@ static void vgic_mmio_write_invlpi(struct kvm_vcpu *vcpu,
>  				   gpa_t addr, unsigned int len,
>  				   unsigned long val)
>  {
> -	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>  	struct vgic_irq *irq;
>  
> -	if (!vgic_cpu->lpis_enabled)
> +	if (!vgic_lpis_enabled(vcpu))
>  		return;
>  
>  	vgic_make_rdist_busy(vcpu, true);
> @@ -568,9 +586,7 @@ static void vgic_mmio_write_invall(struct kvm_vcpu *vcpu,
>  				   gpa_t addr, unsigned int len,
>  				   unsigned long val)
>  {
> -	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> -
> -	if (!vgic_cpu->lpis_enabled)
> +	if (!vgic_lpis_enabled(vcpu))
>  		return;
>  

nit: could you reorder the series to avoid rewriting parts of patch 2
again?


Otherwise:

Reviewed-by: Oliver Upton <oupton@google.com>

>  	vgic_make_rdist_busy(vcpu, true);
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index 53581e11f7c8..1d04a900f3e3 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -308,6 +308,7 @@ static inline bool vgic_dist_overlap(struct kvm *kvm, gpa_t base, size_t size)
>  		(base < d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE);
>  }
>  
> +bool vgic_lpis_enabled(struct kvm_vcpu *vcpu);
>  int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr);
>  int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
>  			 u32 devid, u32 eventid, struct vgic_irq **irq);
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index d54bb44d6d98..401236f97cf2 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -348,8 +348,8 @@ struct vgic_cpu {
>  
>  	/* Contains the attributes and gpa of the LPI pending tables. */
>  	u64 pendbaser;
> -
> -	bool lpis_enabled;
> +	/* GICR_CTLR.{ENABLE_LPIS,RWP} */
> +	atomic_t ctlr;
>  
>  	/* Cache guest priority bits */
>  	u32 num_pri_bits;
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
