Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20295C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jun 2022 19:40:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B45174B1DB;
	Thu,  2 Jun 2022 15:40:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q-0bQfI4p6SP; Thu,  2 Jun 2022 15:40:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65C184B1E0;
	Thu,  2 Jun 2022 15:40:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE1DA4B1D7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2022 15:40:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0eE9+743m+L4 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jun 2022 15:40:17 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61BE04B1B0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2022 15:40:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1654198817;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=NdoryK+M36tETRrBxVGT5YI1I+RfGYSfPrbycvvJUV4=;
 b=Beucg6SgFwepLXSPjbT5BRcxhi59jEB3kTxGYMhopyKied5tYeTox9dUXg3Kjf+krQxH04
 VLJ6ypRlxVMdJ3koaoKibBxAK/g+g8opOsMepHh3xThTA2/hNnxBq0ijDkIUZqeCuaJBzk
 kQiRMKQu4FaM2SXYC/Hyp/RbaIlkNc0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-iSwG_voQMoWzukAyhnf4ZA-1; Thu, 02 Jun 2022 15:40:16 -0400
X-MC-Unique: iSwG_voQMoWzukAyhnf4ZA-1
Received: by mail-wm1-f71.google.com with SMTP id
 n35-20020a05600c3ba300b0039c1d2c6680so2414043wms.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jun 2022 12:40:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=NdoryK+M36tETRrBxVGT5YI1I+RfGYSfPrbycvvJUV4=;
 b=JlmZ53Bs1k9fy1OkYpla1OOg/cSfbHT3EQY7Pk3bu2QXS+RXhz+IaDqUicHCjlIaAE
 LQSJgerOQRC8MlBM+C1+c2HW4p8bF1rVXG3IRF9DJEIks4De1SwtrttGY+SP2jP+NAdS
 09uLA+m9GB2oTxjm6eVPG0YRG3rwpYECXS68hXxLdOt5BZerYaIwFEWLVPugqgGJ+xQs
 124kqU10njz7741HicfC0bjk0QZyIz9Egz7PKfgJhEFR02v2MtCLT9hipxpwojpOG0iI
 GQP41TVtfHbejef/UtFQqdhkM+8dGogCyxekjCsTuEIBusV4ECzPJUimeD0UgfeoxE9W
 jaNg==
X-Gm-Message-State: AOAM5309moDdrHWK7omFAbDoXtgkL1nFQ9ZkNZJ0CySN9y17irSqYmwf
 qLve1d5QaLCDBBWqg0yAxOm+lxaHFu3lAD60jWvNQSNtUcYyT0lJJu0AfvW7BVxfj4cEypASlpu
 s0OpWMhLvCQwmY8GDPBQjAxpB
X-Received: by 2002:adf:f111:0:b0:210:313a:790b with SMTP id
 r17-20020adff111000000b00210313a790bmr4970453wro.367.1654198814985; 
 Thu, 02 Jun 2022 12:40:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1s5DssqlB5RpZ26KQXt0NnkQ5b0EABlSV0CQ/B9bC+wJyIEVOl0GMjrc+H86jrSvxpVsdPA==
X-Received: by 2002:adf:f111:0:b0:210:313a:790b with SMTP id
 r17-20020adff111000000b00210313a790bmr4970423wro.367.1654198814651; 
 Thu, 02 Jun 2022 12:40:14 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id
 l6-20020a5d4bc6000000b0020e615bab7bsm5301652wrt.7.2022.06.02.12.40.13
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 02 Jun 2022 12:40:14 -0700 (PDT)
Message-ID: <85f51e59-5a2e-256c-9a1b-e2b336e865f4@redhat.com>
Date: Thu, 2 Jun 2022 21:40:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/3] KVM: arm64: Don't read a HW interrupt pending state
 in user context
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20220602083025.1110433-1-maz@kernel.org>
 <20220602083025.1110433-2-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20220602083025.1110433-2-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com
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



On 6/2/22 10:30, Marc Zyngier wrote:
> Since 5bfa685e62e9 ("KVM: arm64: vgic: Read HW interrupt pending state
> from the HW"), we're able to source the pending bit for an interrupt
> that is stored either on the physical distributor or on a device.
> 
> However, this state is only available when the vcpu is loaded,
> and is not intended to be accessed from userspace. Unfortunately,
> the GICv2 emulation doesn't provide specific userspace accessors,
> and we fallback with the ones that are intended for the guest,
> with fatal consequences.
> 
> Add a new vgic_uaccess_read_pending() accessor for userspace
> to use, build on top of the existing vgic_mmio_read_pending().
> 
> Reported-by: Eric Auger <eauger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Fixes: 5bfa685e62e9 ("KVM: arm64: vgic: Read HW interrupt pending state from the HW")
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arch/arm64/kvm/vgic/vgic-mmio-v2.c |  4 ++--
>  arch/arm64/kvm/vgic/vgic-mmio.c    | 19 ++++++++++++++++---
>  arch/arm64/kvm/vgic/vgic-mmio.h    |  3 +++
>  3 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
> index 77a67e9d3d14..e070cda86e12 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
> @@ -429,11 +429,11 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
>  		vgic_mmio_read_pending, vgic_mmio_write_spending,
> -		NULL, vgic_uaccess_write_spending, 1,
> +		vgic_uaccess_read_pending, vgic_uaccess_write_spending, 1,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
>  		vgic_mmio_read_pending, vgic_mmio_write_cpending,
> -		NULL, vgic_uaccess_write_cpending, 1,
> +		vgic_uaccess_read_pending, vgic_uaccess_write_cpending, 1,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
>  		vgic_mmio_read_active, vgic_mmio_write_sactive,
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
> index 49837d3a3ef5..dc8c52487e47 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio.c
> @@ -226,8 +226,9 @@ int vgic_uaccess_write_cenable(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> -unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
> -				     gpa_t addr, unsigned int len)
> +static unsigned long __read_pending(struct kvm_vcpu *vcpu,
> +				    gpa_t addr, unsigned int len,
> +				    bool is_user)
>  {
>  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>  	u32 value = 0;
> @@ -248,7 +249,7 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
>  						    IRQCHIP_STATE_PENDING,
>  						    &val);
>  			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
> -		} else if (vgic_irq_is_mapped_level(irq)) {
> +		} else if (!is_user && vgic_irq_is_mapped_level(irq)) {
>  			val = vgic_get_phys_line_level(irq);
>  		} else {
>  			val = irq_is_pending(irq);
> @@ -263,6 +264,18 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
>  	return value;
>  }
>  
> +unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
> +				     gpa_t addr, unsigned int len)
> +{
> +	return __read_pending(vcpu, addr, len, false);
> +}
> +
> +unsigned long vgic_uaccess_read_pending(struct kvm_vcpu *vcpu,
> +					gpa_t addr, unsigned int len)
> +{
> +	return __read_pending(vcpu, addr, len, true);
> +}
> +
>  static bool is_vgic_v2_sgi(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
>  {
>  	return (vgic_irq_is_sgi(irq->intid) &&
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio.h b/arch/arm64/kvm/vgic/vgic-mmio.h
> index 3fa696f198a3..6082d4b66d39 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio.h
> +++ b/arch/arm64/kvm/vgic/vgic-mmio.h
> @@ -149,6 +149,9 @@ int vgic_uaccess_write_cenable(struct kvm_vcpu *vcpu,
>  unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
>  				     gpa_t addr, unsigned int len);
>  
> +unsigned long vgic_uaccess_read_pending(struct kvm_vcpu *vcpu,
> +					gpa_t addr, unsigned int len);
> +
>  void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
>  			      gpa_t addr, unsigned int len,
>  			      unsigned long val);

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
