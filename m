Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AAEF4ED
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 14:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750084351; cv=none; b=LKi6dTJdls/fHtuAwy7wYVOoNbVW3hjrTW6FQHKIdoKSgf3S5gKTOaspVbCrALHojYPqGnuHg2HY4e4c0YJyG1S9XVBnvP7y0lqjYefVb7gIL03/sMSEZOf/a6Vvm4yl8XFmKXVSF0YKbN54COVaV2LL9o/WmNNDfhJ6rAcxhsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750084351; c=relaxed/simple;
	bh=mXtnEzO/AQsXD5F9xbtyvPg4mcL6gsQJ5aFsJnDhKKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UXpBha0st7R/1Ffra6PkwuROUzLqoDfRnI+oTKAlIbiuQKfvEu6+41Xj2004CmKVvLNiCceuGWqOW8C1j84MIFi2gajNmBwMOxQ7YbNUlWQlcomnVZ0ydxxrvSkPLjHOPtqEcRiHfTRs8pN5bZ1Xm3U/sA7KnhAGcIL3PKNIZT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=O0zXE9hV; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="O0zXE9hV"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b2f645eba5dso3909146a12.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 07:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1750084347; x=1750689147; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AwRGa0XFsqqIwrjVkk74Q1qsmmr8uiY3g/0R4Yfi5MQ=;
        b=O0zXE9hV98unMnoXoHRDyeGN8ilzM7PQY/jaFvUbE/6sFkANMqaOOTWPhPxKu8X3Ix
         ncdBKM6dXzoFvqiNlAGNy2MEymIWCeiRsj8JASI5kd+qYhbUoN8P9DjokZTaeGnckd28
         IHQp9A11gt3+F6e/vH41u7eZ6yQOMwnqy9omaKrTt+vzVFeoAMZjo8oWEWUlP4kErLaA
         mUyQz2XNQZyzLGOchOoVstYRDeULa3c9FYs97ysDAjor5RgWdq28k2g7WYf5Tx0xe/3s
         2AfDkC8lEM4+5CnQFsMSzkQSM7bdPzyHVWdJyc76KTwr8ZZzp9HL6lYtOEedt+N8nSnq
         tOdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750084347; x=1750689147;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AwRGa0XFsqqIwrjVkk74Q1qsmmr8uiY3g/0R4Yfi5MQ=;
        b=Rnr6N99F1pOC1a5xVFbldAqKW2bL8c2HZDd9ESZqDlBM8pRbq0zH+dnM5bDDEPtvvt
         uuvJbxLRejJneQz2FcOlcNUA0mnzJznaBye135zuk9Tbv5mc3HNj/aEQcCPOZsKZSRHh
         QgZsidfPDI85K5YiL+fwscPuGRfy336yWNzTH/vWahcXdREEoN5DyjilOB/BFkmoVax1
         sl1doe8cOE5XwoElDg5r/q/uPYUAxQaGBudm06/0V8VY7e6O1JVwUqcgPvgbe9xHGSHI
         yQfo581hpfze6AMPRYP3SZrHJm2wjqxCR0D8gdKIE1SijommuHH4gbVi1jmhm3XlkBhO
         6yZA==
X-Forwarded-Encrypted: i=1; AJvYcCV6H6iAuWQnofxQy0WPojg2f3rxaz9ObJHKdRwxBzZ/7ASFjZRIEjPNre/l3YVV4WcVWikS4Ic=@lists.linux.dev
X-Gm-Message-State: AOJu0YzuUZyVo/Jza5zmF2bUSH0NUXz0zaRr6qoWZz6iRlzdJGEl1tii
	LTOfDmq9dRTo1Qy5OHKhF8uQNxbSEobraWCLof5NdUGyYdHVDAemM2yAirXieD6TFzaaxFw0Aae
	H+vwhqfiWcMHT+z6nW8Mw0rLYxubVunr6i2HTyJbwh71vGrt78lE=
X-Gm-Gg: ASbGncu/vbCdFVS9TqTDxIfSLnpc2w5bjeeF+wl+KYW/TtNIEA7qFzm3PdylVIfn1Q1
	PG+UDUf90eSWxzX+N5Gkg/EzBz5o2hHgaZfgSLC1kqkyhyNNeIWqrsWLVOyl0omIXCnrbwoMtZO
	2WQ95ZTNQ2OtbktElF8H+dUFhWE01qppYViJfCSOcNkHQQIU7ZaRGZa+hk8sGo3jun7dUMY73Hc
	8eP86IgTN36xNnurpSgRUXtTQhx/Tq+83gcjWQ0htiqcx5+OusNasoIUtEXftrY9y3y4brRAZLE
	St0V3FY9XW7Ai7BZ4MTw7UMA+9xh/dLjCmum3mqaL8XyxIYPDooNLBYynKTQPXJTOk6FoK5vybq
	0dsMMQMCQpyHfdaVClcF1wG3r
X-Google-Smtp-Source: AGHT+IEtkJExy6WPafNCco+WTYoFOLE/6qqMQggbf4cftPJzDAhAGmjRrQdyLE0tM9+TfIxVnZRz4w==
X-Received: by 2002:a17:903:2ac7:b0:235:278c:7d06 with SMTP id d9443c01a7336-2366ae00e80mr158071555ad.8.1750084346886;
        Mon, 16 Jun 2025 07:32:26 -0700 (PDT)
Received: from zenbook (36-228-20-239.dynamic-ip.hinet.net. [36.228.20.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365dea8d1asm61456935ad.162.2025.06.16.07.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 07:32:26 -0700 (PDT)
Date: Mon, 16 Jun 2025 22:34:58 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Jintack Lim <jintack@cs.columbia.edu>, 
	Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] KVM: arm64: nv: Fix s_cpu_if->vgic_lr[] indexing in
 vgic_v3_put_nested()
Message-ID: <2p4urq6ij5zq77c7viydmqqaj2doeyja43khvcjgn5pkpe7saz@eyfvuykscn22>
References: <20250614145721.2504524-1-r09922117@csie.ntu.edu.tw>
 <86qzzkc5xa.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86qzzkc5xa.wl-maz@kernel.org>
X-Gm-Spam: 0
X-Gm-Phishy: 0

On Mon, Jun 16, 2025 at 11:54:57AM +0100, Marc Zyngier wrote:
> On Sat, 14 Jun 2025 15:57:21 +0100,
> Wei-Lin Chang <r09922117@csie.ntu.edu.tw> wrote:
> > 
> > s_cpu_if->vgic_lr[] is filled continuously from index 0 to
> > s_cpu_if->used_lrs - 1, but vgic_v3_put_nested() is indexing it using
> > the positions of the set bits in shadow_if->lr_map. So correct it.
> > 
> > Signed-off-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
> > ---
> >  arch/arm64/kvm/vgic/vgic-v3-nested.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> > index 4f6954c30674..29741e3f077b 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> > @@ -343,7 +343,7 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
> >  	struct shadow_if *shadow_if = get_shadow_if();
> >  	struct vgic_v3_cpu_if *s_cpu_if = &shadow_if->cpuif;
> >  	u64 val;
> > -	int i;
> > +	int i, index = 0;
> >  
> >  	__vgic_v3_save_vmcr_aprs(s_cpu_if);
> >  	__vgic_v3_deactivate_traps(s_cpu_if);
> > @@ -368,10 +368,11 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
> >  		val = __vcpu_sys_reg(vcpu, ICH_LRN(i));
> >  
> >  		val &= ~ICH_LR_STATE;
> > -		val |= s_cpu_if->vgic_lr[i] & ICH_LR_STATE;
> > +		val |= s_cpu_if->vgic_lr[index] & ICH_LR_STATE;
> >  
> >  		__vcpu_sys_reg(vcpu, ICH_LRN(i)) = val;
> > -		s_cpu_if->vgic_lr[i] = 0;
> > +		s_cpu_if->vgic_lr[index] = 0;
> > +		index++;
> >  	}
> >  
> >  	shadow_if->lr_map = 0;
> 
> Nice catch, thanks a lot for tracking it down.
> 
> However, I think we should get rid of this double-indexing altogether,
> or at least make it less error-prone. This thing is extremely fragile,
> and it isn't the first time we are getting bitten with it.

Hi Marc,

Yes agreed, making this more robust is better than just the bug fix.
Thanks for the effort.

> 
> Looking at the code, it becomes pretty obvious that the shadow index
> is always the number of bits set in lr_map, and that we could
> completely drop the 'index' thing if we simply counted these bits
> (which isn't that expensive).
> 
> I came up with the (admittedly much bigger) following fix.
> 
> Thoughts?

Just one nit below:

> 
> 	M.
> 
> From 2484950b8fc3b36cca32bf5e86ffe7975a43e0e7 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Sun, 15 Jun 2025 16:11:38 +0100
> Subject: [PATCH] KVM: arm64: nv: Fix tracking of shadow list registers
> 
> Wei-Lin reports that the tracking of shadow list registers is
> majorly broken when resync'ing the L2 state after a run, as
> we confuse the guest's LR index with the host's, potentially
> losing the interrupt state.
> 
> While this could be fixed by adding yet another side index to
> track it (Wei-Lin's fix), it may be better to refactor this
> code to avoid having a side index altogether, limiting the
> risk to introduce this class of bugs.
> 
> A key observation is that the shadow index is always the number
> of bits in the lr_map bitmap. With that, the parallel indexing
> scheme can be completely dropped.
> 
> While doing this, introduce a couple of helpers that abstract
> the index conversion and some of the LR repainting, making the
> whole exercise much simpler.
> 
> Reported-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20250614145721.2504524-1-r09922117@csie.ntu.edu.tw
> ---
>  arch/arm64/kvm/vgic/vgic-v3-nested.c | 81 ++++++++++++++--------------
>  1 file changed, 42 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> index d22a8ad7bcc51..bd22e42ce9112 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> @@ -36,6 +36,11 @@ struct shadow_if {
>  
>  static DEFINE_PER_CPU(struct shadow_if, shadow_if);
>  
> +static int lr_map_idx_to_shadow_idx(struct shadow_if *shadow_if, int idx)
> +{
> +	return hweight64(shadow_if->lr_map & (BIT(idx) - 1));
> +}
> +
>  /*
>   * Nesting GICv3 support
>   *
> @@ -209,6 +214,29 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu)
>  	return reg;
>  }
>  
> +static u64 translate_lr_hw_bit(struct kvm_vcpu *vcpu, u64 lr)

I believe translate_lr_pintid() better describes what this function is
doing.

For everything else, I don't spot any issues after review.

Reviewed-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>

> +{
> +	struct vgic_irq *irq;
> +
> +	if (!(lr & ICH_LR_HW))
> +		return lr;
> +
> +	/* We have the HW bit set, check for validity of pINTID */
> +	irq = vgic_get_vcpu_irq(vcpu, FIELD_GET(ICH_LR_PHYS_ID_MASK, lr));
> +	/* If there was no real mapping, nuke the HW bit */
> +	if (!irq || !irq->hw || irq->intid > VGIC_MAX_SPI)
> +		lr &= ~ICH_LR_HW;
> +
> +	/* Translate the virtual mapping to the real one, even if invalid */
> +	if (irq) {
> +		lr &= ~ICH_LR_PHYS_ID_MASK;
> +		lr |= FIELD_PREP(ICH_LR_PHYS_ID_MASK, (u64)irq->hwintid);
> +		vgic_put_irq(vcpu->kvm, irq);
> +	}
> +
> +	return lr;
> +}
> +
>  /*
>   * For LRs which have HW bit set such as timer interrupts, we modify them to
>   * have the host hardware interrupt number instead of the virtual one programmed
> @@ -217,58 +245,37 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu)
>  static void vgic_v3_create_shadow_lr(struct kvm_vcpu *vcpu,
>  				     struct vgic_v3_cpu_if *s_cpu_if)
>  {
> -	unsigned long lr_map = 0;
> -	int index = 0;
> +	struct shadow_if *shadow_if;
> +
> +	shadow_if = container_of(s_cpu_if, struct shadow_if, cpuif);
> +	shadow_if->lr_map = 0;
>  
>  	for (int i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
>  		u64 lr = __vcpu_sys_reg(vcpu, ICH_LRN(i));
> -		struct vgic_irq *irq;
>  
>  		if (!(lr & ICH_LR_STATE))
> -			lr = 0;
> -
> -		if (!(lr & ICH_LR_HW))
> -			goto next;
> -
> -		/* We have the HW bit set, check for validity of pINTID */
> -		irq = vgic_get_vcpu_irq(vcpu, FIELD_GET(ICH_LR_PHYS_ID_MASK, lr));
> -		if (!irq || !irq->hw || irq->intid > VGIC_MAX_SPI ) {
> -			/* There was no real mapping, so nuke the HW bit */
> -			lr &= ~ICH_LR_HW;
> -			if (irq)
> -				vgic_put_irq(vcpu->kvm, irq);
> -			goto next;
> -		}
> -
> -		/* Translate the virtual mapping to the real one */
> -		lr &= ~ICH_LR_PHYS_ID_MASK;
> -		lr |= FIELD_PREP(ICH_LR_PHYS_ID_MASK, (u64)irq->hwintid);
> +			continue;
>  
> -		vgic_put_irq(vcpu->kvm, irq);
> +		lr = translate_lr_hw_bit(vcpu, lr);
>  
> -next:
> -		s_cpu_if->vgic_lr[index] = lr;
> -		if (lr) {
> -			lr_map |= BIT(i);
> -			index++;
> -		}
> +		s_cpu_if->vgic_lr[hweight64(shadow_if->lr_map)] = lr;
> +		shadow_if->lr_map |= BIT(i);
>  	}
>  
> -	container_of(s_cpu_if, struct shadow_if, cpuif)->lr_map = lr_map;
> -	s_cpu_if->used_lrs = index;
> +	s_cpu_if->used_lrs = hweight64(shadow_if->lr_map);
>  }
>  
>  void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
>  {
>  	struct shadow_if *shadow_if = get_shadow_if();
> -	int i, index = 0;
> +	int i;
>  
>  	for_each_set_bit(i, &shadow_if->lr_map, kvm_vgic_global_state.nr_lr) {
>  		u64 lr = __vcpu_sys_reg(vcpu, ICH_LRN(i));
>  		struct vgic_irq *irq;
>  
>  		if (!(lr & ICH_LR_HW) || !(lr & ICH_LR_STATE))
> -			goto next;
> +			continue;
>  
>  		/*
>  		 * If we had a HW lr programmed by the guest hypervisor, we
> @@ -277,15 +284,13 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
>  		 */
>  		irq = vgic_get_vcpu_irq(vcpu, FIELD_GET(ICH_LR_PHYS_ID_MASK, lr));
>  		if (WARN_ON(!irq)) /* Shouldn't happen as we check on load */
> -			goto next;
> +			continue;
>  
> -		lr = __gic_v3_get_lr(index);
> +		lr = __gic_v3_get_lr(lr_map_idx_to_shadow_idx(shadow_if, i));
>  		if (!(lr & ICH_LR_STATE))
>  			irq->active = false;
>  
>  		vgic_put_irq(vcpu->kvm, irq);
> -	next:
> -		index++;
>  	}
>  }
>  
> @@ -368,13 +373,11 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
>  		val = __vcpu_sys_reg(vcpu, ICH_LRN(i));
>  
>  		val &= ~ICH_LR_STATE;
> -		val |= s_cpu_if->vgic_lr[i] & ICH_LR_STATE;
> +		val |= s_cpu_if->vgic_lr[lr_map_idx_to_shadow_idx(shadow_if, i)] & ICH_LR_STATE;
>  
>  		__vcpu_assign_sys_reg(vcpu, ICH_LRN(i), val);
> -		s_cpu_if->vgic_lr[i] = 0;
>  	}
>  
> -	shadow_if->lr_map = 0;
>  	vcpu->arch.vgic_cpu.vgic_v3.used_lrs = 0;
>  }
>  
> -- 
> 2.39.2
> 
> 
> -- 
> Without deviation from the norm, progress is not possible.
