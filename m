Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4674C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 16 Mar 2022 05:26:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED28F49F1E;
	Wed, 16 Mar 2022 01:26:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wu86OabfNoX2; Wed, 16 Mar 2022 01:26:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8998B49F10;
	Wed, 16 Mar 2022 01:26:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1698F49F09
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 01:26:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r-VbeES5hiwa for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2022 01:26:11 -0400 (EDT)
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com
 [209.85.166.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C9E949F02
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 01:26:11 -0400 (EDT)
Received: by mail-io1-f51.google.com with SMTP id q11so1176355iod.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 22:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=MDmfm0yq5QKaDGuWZ2WJN7inSGu4ilYlUPUq2PHc548=;
 b=hHmsqzpGvsS9Y1ZB5I42lsFXIKnQQyu25GTdr7JTz2IX4sIM4v1uC/a3/wypnsUwFG
 Qr38t8WeJE2gHlcSCv1OJ/5nNHmLsCPx1n3pmb2sqH9O3PsGNg9LcM0QZfInPkO5YPaC
 OGNBVqFQlA1k6BmXkyFQRxEh6+u/WrJUMrIap09cPLCJTHe/6odByfDCS8zdp8g6PxFZ
 NxhYQiDVlU5pYF8vc6GQUxKikjB8QupM1ZKIHBWIjjNPrTD6FH46Wv93MFYE5YzWIXmA
 MukHBRZaCbdiypc/pDPeeWwcX6cKvv9JMfojWsGCVqSfUh/VbYSWHPdtpCg3/VA7j3fA
 jlqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=MDmfm0yq5QKaDGuWZ2WJN7inSGu4ilYlUPUq2PHc548=;
 b=k4psoxnRynCxFvs/+FOJDxSpnyQICdA1BAwvut8P+/vxDNuD0G7nFpTVJS+KtpZBmS
 rhkwOo4ezvoZcr+f0Q6zZvjOZkmUV57KCywx/iQ7BshQpBHCviMGT3OiNka6lR5TvUeP
 TLFB5JCajgj07takyKTnAfV82OCrKQTljqYoiUFP6dwGSPYuXtltaIGe6a4DI/Nkg3MW
 LnhAVlxVDLqf+lvMzIZF7SqZclT+gP7RrJiVDEjRo5Se60F+bXbDDMWjJczEfJJvxi4+
 OjYYMToN4yToB8U/4N4f+dRoutxqy/AuDobwntU9ISBZYLkJHKwiMbXnIErWK/V8qXkY
 gnyg==
X-Gm-Message-State: AOAM530fUfIuaua+P6IfVq37hnwXhvkeKmnVGMa2PoV7PiPoO21BYxO8
 JM+I5ljrT06DrX+F/oEbbSXA2Q==
X-Google-Smtp-Source: ABdhPJwCyzug0+FN/43Z6CGII1/g9j/8aDBetLwF31/ychamqjfYJ3Tp9QN56BXbl0azt5JLkjVlmQ==
X-Received: by 2002:a05:6602:2c0c:b0:5f0:793f:cb9e with SMTP id
 w12-20020a0566022c0c00b005f0793fcb9emr23184429iov.122.1647408370619; 
 Tue, 15 Mar 2022 22:26:10 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 y74-20020a6bc84d000000b00645dfdd8a4csm532962iof.38.2022.03.15.22.26.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 22:26:09 -0700 (PDT)
Date: Wed, 16 Mar 2022 05:26:06 +0000
From: Oliver Upton <oupton@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/4] KVM: arm64: vgic-v3: Implement MMIO-based LPI
 invalidation
Message-ID: <YjF07lltAEn6X22V@google.com>
References: <20220314164044.772709-1-maz@kernel.org>
 <20220314164044.772709-3-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220314164044.772709-3-maz@kernel.org>
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

On Mon, Mar 14, 2022 at 04:40:42PM +0000, Marc Zyngier wrote:
> Since GICv4.1, it has become legal for an implementation to advertise
> GICR_{INVLPIR,INVALLR,SYNCR} while having an ITS, allowing for a more
> efficient invalidation scheme (no guest command queue contention when
> multiple CPUs are generating invalidations).
> 
> Provide the invalidation registers as a primitive to their ITS
> counterpart. Note that we don't advertise them to the guest yet
> (the architecture allows an implementation to do this).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c     | 62 ++++++++++++++++++++----------
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 62 ++++++++++++++++++++++++++++++
>  arch/arm64/kvm/vgic/vgic.h         |  4 ++
>  include/kvm/arm_vgic.h             |  1 +
>  4 files changed, 108 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 089fc2ffcb43..cc62d8a8180f 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -1272,6 +1272,11 @@ static int vgic_its_cmd_handle_clear(struct kvm *kvm, struct vgic_its *its,
>  	return 0;
>  }
>  
> +int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq)
> +{
> +	return update_lpi_config(kvm, irq, NULL, true);
> +}
> +
>  /*
>   * The INV command syncs the configuration bits from the memory table.
>   * Must be called with the its_lock mutex held.
> @@ -1288,7 +1293,41 @@ static int vgic_its_cmd_handle_inv(struct kvm *kvm, struct vgic_its *its,
>  	if (!ite)
>  		return E_ITS_INV_UNMAPPED_INTERRUPT;
>  
> -	return update_lpi_config(kvm, ite->irq, NULL, true);
> +	return vgic_its_inv_lpi(kvm, ite->irq);
> +}
> +
> +/**
> + * vgic_its_invall - invalidate all LPIs targetting a given vcpu
> + * @vcpu: the vcpu for which the RD is targetted by an invalidation
> + *
> + * Contrary to the INVALL command, this targets a RD instead of a
> + * collection, and we don't need to hold the its_lock, since no ITS is
> + * involved here.
> + */
> +int vgic_its_invall(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	int irq_count, i = 0;
> +	u32 *intids;
> +
> +	irq_count = vgic_copy_lpi_list(kvm, vcpu, &intids);
> +	if (irq_count < 0)
> +		return irq_count;
> +
> +	for (i = 0; i < irq_count; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(kvm, NULL, intids[i]);
> +		if (!irq)
> +			continue;
> +		update_lpi_config(kvm, irq, vcpu, false);
> +		vgic_put_irq(kvm, irq);
> +	}
> +
> +	kfree(intids);
> +
> +	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.its_vm)
> +		its_invall_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe);
> +
> +	return 0;
>  }

nit: the refactoring happening at the same time as the functional change
is a bit distracting. Looks fine though.

>  /*
> @@ -1305,32 +1344,13 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
>  	u32 coll_id = its_cmd_get_collection(its_cmd);
>  	struct its_collection *collection;
>  	struct kvm_vcpu *vcpu;
> -	struct vgic_irq *irq;
> -	u32 *intids;
> -	int irq_count, i;
>  
>  	collection = find_collection(its, coll_id);
>  	if (!its_is_collection_mapped(collection))
>  		return E_ITS_INVALL_UNMAPPED_COLLECTION;
>  
>  	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
> -
> -	irq_count = vgic_copy_lpi_list(kvm, vcpu, &intids);
> -	if (irq_count < 0)
> -		return irq_count;
> -
> -	for (i = 0; i < irq_count; i++) {
> -		irq = vgic_get_irq(kvm, NULL, intids[i]);
> -		if (!irq)
> -			continue;
> -		update_lpi_config(kvm, irq, vcpu, false);
> -		vgic_put_irq(kvm, irq);
> -	}
> -
> -	kfree(intids);
> -
> -	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.its_vm)
> -		its_invall_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe);
> +	vgic_its_invall(vcpu);
>  
>  	return 0;
>  }
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index 58e40b4874f8..186bf35078bf 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -525,6 +525,59 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
>  			   pendbaser) != old_pendbaser);
>  }
>  
> +static unsigned long vgic_mmio_read_sync(struct kvm_vcpu *vcpu,
> +					 gpa_t addr, unsigned int len)
> +{
> +	return !!atomic_read(&vcpu->arch.vgic_cpu.syncr_busy);
> +}
> +
> +static void vgic_make_rdist_busy(struct kvm_vcpu *vcpu, bool busy)

nit: s/make/set, since you use this helper to decrement the counter too.

> +{
> +	if (busy) {
> +		atomic_inc(&vcpu->arch.vgic_cpu.syncr_busy);
> +		smp_mb__after_atomic();
> +	} else {
> +		smp_mb__before_atomic();
> +		atomic_dec(&vcpu->arch.vgic_cpu.syncr_busy);
> +	}
> +}
> +
> +static void vgic_mmio_write_invlpi(struct kvm_vcpu *vcpu,
> +				   gpa_t addr, unsigned int len,
> +				   unsigned long val)
> +{
> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +	struct vgic_irq *irq;
> +
> +	if (!vgic_cpu->lpis_enabled)
> +		return;
> +
> +	vgic_make_rdist_busy(vcpu, true);
> +
> +	irq = vgic_get_irq(vcpu->kvm, NULL, val);
> +	if (!irq)
> +		return;

Isn't the busy counter unbalanced if you return early?

--
Thanks,
Oliver

> +
> +	vgic_its_inv_lpi(vcpu->kvm, irq);
> +	vgic_put_irq(vcpu->kvm, irq);
> +
> +	vgic_make_rdist_busy(vcpu, false);
> +}
> +
> +static void vgic_mmio_write_invall(struct kvm_vcpu *vcpu,
> +				   gpa_t addr, unsigned int len,
> +				   unsigned long val)
> +{
> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +
> +	if (!vgic_cpu->lpis_enabled)
> +		return;
> +
> +	vgic_make_rdist_busy(vcpu, true);
> +	vgic_its_invall(vcpu);
> +	vgic_make_rdist_busy(vcpu, false);
> +}
> +
>  /*
>   * The GICv3 per-IRQ registers are split to control PPIs and SGIs in the
>   * redistributors, while SPIs are covered by registers in the distributor
> @@ -630,6 +683,15 @@ static const struct vgic_register_region vgic_v3_rd_registers[] = {
>  	REGISTER_DESC_WITH_LENGTH(GICR_PENDBASER,
>  		vgic_mmio_read_pendbase, vgic_mmio_write_pendbase, 8,
>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
> +	REGISTER_DESC_WITH_LENGTH(GICR_INVLPIR,
> +		vgic_mmio_read_raz, vgic_mmio_write_invlpi, 8,
> +		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
> +	REGISTER_DESC_WITH_LENGTH(GICR_INVALLR,
> +		vgic_mmio_read_raz, vgic_mmio_write_invall, 8,
> +		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
> +	REGISTER_DESC_WITH_LENGTH(GICR_SYNCR,
> +		vgic_mmio_read_sync, vgic_mmio_write_wi, 8,
> +		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH(GICR_IDREGS,
>  		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48,
>  		VGIC_ACCESS_32bit),
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index 3fd6c86a7ef3..53581e11f7c8 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -317,6 +317,10 @@ void vgic_lpi_translation_cache_init(struct kvm *kvm);
>  void vgic_lpi_translation_cache_destroy(struct kvm *kvm);
>  void vgic_its_invalidate_cache(struct kvm *kvm);
>  
> +/* GICv4.1 MMIO interface */
> +int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq);
> +int vgic_its_invall(struct kvm_vcpu *vcpu);
> +
>  bool vgic_supports_direct_msis(struct kvm *kvm);
>  int vgic_v4_init(struct kvm *kvm);
>  void vgic_v4_teardown(struct kvm *kvm);
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index bb30a6803d9f..d54bb44d6d98 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -344,6 +344,7 @@ struct vgic_cpu {
>  	struct vgic_io_device	rd_iodev;
>  	struct vgic_redist_region *rdreg;
>  	u32 rdreg_index;
> +	atomic_t syncr_busy;
>  
>  	/* Contains the attributes and gpa of the LPI pending tables. */
>  	u64 pendbaser;
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
