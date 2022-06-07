Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E9ABC43334
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jun 2022 19:29:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3A414B29F;
	Tue,  7 Jun 2022 15:29:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OpC5G-SmVM-m; Tue,  7 Jun 2022 15:29:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E7944B2AD;
	Tue,  7 Jun 2022 15:29:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA0B14B273
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 15:29:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kd76iViSaQCY for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jun 2022 15:29:04 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5105949F21
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 15:29:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1654630143;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=4ER/E+pAoWlGQSd+i/bJPappYOlr33p/scmrpdGboic=;
 b=OTtoU/OpzdGiAOhODefNX6C3QiMf1FwQ6b7kWIuafwjP5gPtG+Ntcu2fdI5o1IcJqf3hNm
 Kt8R+mSD2YcxSJBMm+4/GOvI14P6a/1Ci4OezuPmPKi/1xBEOoNwRQQMWEwqzEFk3D6NzM
 2jhStkTfSJyA+WLNtS7i8kAwCgvXRME=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-pN2N5ZkOPJGvyYxO9p114A-1; Tue, 07 Jun 2022 15:29:00 -0400
X-MC-Unique: pN2N5ZkOPJGvyYxO9p114A-1
Received: by mail-wm1-f71.google.com with SMTP id
 n18-20020a05600c3b9200b00397335edc7dso13170236wms.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Jun 2022 12:29:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=4ER/E+pAoWlGQSd+i/bJPappYOlr33p/scmrpdGboic=;
 b=yLAm3fKEKStjUhWOY0HRiPXSSwgBrubDSKka5aLzcL3fn+DKLRJrU2rnsCm8/Ds09m
 qsoxjCM3ZZnxzIBSAIAUPhBIqZNuhqP2OK8zHhLKzUlMMhWmiAbwo6cv0uD0EK9x9kVP
 U9RUadY6MyMwb9Kbye+o+gdC4YkSDYLxZv27WYay4zOyyFLqWKh4SGFVdhWNfsdUfXGu
 DvVQrA6i+0LNG8z6s3TsWBtH/sMfTO6bgf6BJ7Ho3eSnUyzJNhuTlSuyIWSm8o0q4zG9
 /QpYW52AaMuuDBDS8I6WrHkC0K/ZPGlHfOnllJKme4n1QmKSb/9IrPoalYJkGzAOYsxy
 AF9A==
X-Gm-Message-State: AOAM5316O355nDStYHZegSWSMIhpUuIOxDHCrilcrUYaBYE0s3CgqrI7
 6dvF9UOWXtZ/V04i/Z3GVYZNmyhpxiK6Bv7BGcTW/K30bIBTGNTIbXQ+IocBI7LWjRSoY0iDxbU
 hmLblDzNjbnI3I88wq+eBcBmG
X-Received: by 2002:a7b:cbda:0:b0:397:48d6:6c9f with SMTP id
 n26-20020a7bcbda000000b0039748d66c9fmr31141548wmi.10.1654630139529; 
 Tue, 07 Jun 2022 12:28:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxywDhM4TJW889qZ6fx5SI3Z/EOzRQo2GCVZ6ZqoEvbpydZwXHJlLu7cLscTQQs/BhpiyqoCA==
X-Received: by 2002:a7b:cbda:0:b0:397:48d6:6c9f with SMTP id
 n26-20020a7bcbda000000b0039748d66c9fmr31141520wmi.10.1654630139208; 
 Tue, 07 Jun 2022 12:28:59 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id
 h7-20020a05600c350700b0039c3b05540fsm18715587wmq.27.2022.06.07.12.28.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 07 Jun 2022 12:28:58 -0700 (PDT)
Message-ID: <e41af157-0de4-559f-9154-e259ee19166c@redhat.com>
Date: Tue, 7 Jun 2022 21:28:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 2/3] KVM: arm64: Replace vgic_v3_uaccess_read_pending
 with vgic_uaccess_read_pending
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20220607131427.1164881-1-maz@kernel.org>
 <20220607131427.1164881-3-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220607131427.1164881-3-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
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

On 6/7/22 15:14, Marc Zyngier wrote:
> Now that GICv2 has a proper userspace accessor for the pending state,
> switch GICv3 over to it, dropping the local version, moving over the
> specific behaviours that CGIv3 requires (such as the distinction
> between pending latch and line level which were never enforced
> with GICv2).
>
> We also gain extra locking that isn't really necessary for userspace,
> but that's a small price to pay for getting rid of superfluous code.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 40 ++----------------------------
>  arch/arm64/kvm/vgic/vgic-mmio.c    | 21 +++++++++++++++-
>  2 files changed, 22 insertions(+), 39 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index f7aa7bcd6fb8..f15e29cc63ce 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -353,42 +353,6 @@ static unsigned long vgic_mmio_read_v3_idregs(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> -static unsigned long vgic_v3_uaccess_read_pending(struct kvm_vcpu *vcpu,
> -						  gpa_t addr, unsigned int len)
> -{
> -	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> -	u32 value = 0;
> -	int i;
> -
> -	/*
> -	 * pending state of interrupt is latched in pending_latch variable.
> -	 * Userspace will save and restore pending state and line_level
> -	 * separately.
> -	 * Refer to Documentation/virt/kvm/devices/arm-vgic-v3.rst
> -	 * for handling of ISPENDR and ICPENDR.
> -	 */
> -	for (i = 0; i < len * 8; i++) {
> -		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> -		bool state = irq->pending_latch;
> -
> -		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
> -			int err;
> -
> -			err = irq_get_irqchip_state(irq->host_irq,
> -						    IRQCHIP_STATE_PENDING,
> -						    &state);
> -			WARN_ON(err);
> -		}
> -
> -		if (state)
> -			value |= (1U << i);
> -
> -		vgic_put_irq(vcpu->kvm, irq);
> -	}
> -
> -	return value;
> -}
> -
>  static int vgic_v3_uaccess_write_pending(struct kvm_vcpu *vcpu,
>  					 gpa_t addr, unsigned int len,
>  					 unsigned long val)
> @@ -666,7 +630,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISPENDR,
>  		vgic_mmio_read_pending, vgic_mmio_write_spending,
> -		vgic_v3_uaccess_read_pending, vgic_v3_uaccess_write_pending, 1,
> +		vgic_uaccess_read_pending, vgic_v3_uaccess_write_pending, 1,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICPENDR,
>  		vgic_mmio_read_pending, vgic_mmio_write_cpending,
> @@ -750,7 +714,7 @@ static const struct vgic_register_region vgic_v3_rd_registers[] = {
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH_UACCESS(SZ_64K + GICR_ISPENDR0,
>  		vgic_mmio_read_pending, vgic_mmio_write_spending,
> -		vgic_v3_uaccess_read_pending, vgic_v3_uaccess_write_pending, 4,
> +		vgic_uaccess_read_pending, vgic_v3_uaccess_write_pending, 4,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_LENGTH_UACCESS(SZ_64K + GICR_ICPENDR0,
>  		vgic_mmio_read_pending, vgic_mmio_write_cpending,
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
> index dc8c52487e47..997d0fce2088 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio.c
> @@ -240,6 +240,15 @@ static unsigned long __read_pending(struct kvm_vcpu *vcpu,
>  		unsigned long flags;
>  		bool val;
>  
> +		/*
> +		 * When used from userspace with a GICv3 model:
> +		 *
> +		 * Pending state of interrupt is latched in pending_latch
> +		 * variable.  Userspace will save and restore pending state
> +		 * and line_level separately.
> +		 * Refer to Documentation/virt/kvm/devices/arm-vgic-v3.rst
> +		 * for handling of ISPENDR and ICPENDR.
> +		 */
>  		raw_spin_lock_irqsave(&irq->irq_lock, flags);
>  		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
>  			int err;
> @@ -252,7 +261,17 @@ static unsigned long __read_pending(struct kvm_vcpu *vcpu,
>  		} else if (!is_user && vgic_irq_is_mapped_level(irq)) {
>  			val = vgic_get_phys_line_level(irq);
>  		} else {
> -			val = irq_is_pending(irq);
> +			switch (vcpu->kvm->arch.vgic.vgic_model) {
> +			case KVM_DEV_TYPE_ARM_VGIC_V3:
> +				if (is_user) {
> +					val = irq->pending_latch;
> +					break;
> +				}
> +				fallthrough;
> +			default:
> +				val = irq_is_pending(irq);
> +				break;
> +			}
>  		}
>  
>  		value |= ((u32)val << i);
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks!

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
