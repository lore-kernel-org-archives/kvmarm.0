Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0CEEC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jun 2022 20:08:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11A8C4B128;
	Thu,  2 Jun 2022 16:08:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fwGqUlqKktSY; Thu,  2 Jun 2022 16:08:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6E5B4B205;
	Thu,  2 Jun 2022 16:08:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 563E14B1FE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2022 16:08:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6RqsIEBO+mO7 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jun 2022 16:08:28 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00BE04B128
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2022 16:08:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1654200507;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=IB/Vlnp4xtDrg/E/9iId0p0IwjHTTbtc1GZm3Z/63a4=;
 b=gIfciea83AGKQqCzGO9wpWSQKh2JUZ5xEzSHMtqD+9jG2s8OYKIMUCmm1h5nWmIXwmAg+S
 G/6/pTiI3G2BHqfYcdPu2wVh8mG3MR5OwjYpTzX28Rc5Jon+rG9+noJ8oQHLeq1aQpdVy3
 +hM7C9f8MWKnetpEWNRpeKqWIzwo4BU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-GQNquY7WNE-Q0EGB-D1JQg-1; Thu, 02 Jun 2022 16:08:26 -0400
X-MC-Unique: GQNquY7WNE-Q0EGB-D1JQg-1
Received: by mail-wm1-f70.google.com with SMTP id
 o2-20020a05600c510200b0039747b0216fso5667498wms.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jun 2022 13:08:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=IB/Vlnp4xtDrg/E/9iId0p0IwjHTTbtc1GZm3Z/63a4=;
 b=I/vFv9EpTCL8+Zh+H6kps/PqZ69HUegcNz90NSLb1B/Wtt62QtCvuGeYF2dhKDJKo+
 X+FUibvKguloffwvBBaSSbSSyuXuyio+zJwLPRnJiVaOscpOm9/svKG5lbvACdX+a/Ne
 Tb/1GkCdS/12LQe5K5/QGNIl1LehfyzBgWTSTLOx5Jy4jujSQUgfghtlNDopTN75wVYC
 aXEeeeMlsW4IiT3P0gemKKWjDuUokL3TzQ57NQvX0q7zhZy+NBGGW0c2ZXTAYBiu4GOD
 ESVd+pN3PNu9mKJ+0W8Teiwk3bARSObWSQFhW6DAAHPIX+UCkRcjxm/ubCwuvexJOdtr
 PXdg==
X-Gm-Message-State: AOAM533ltnWcO/LPenR2QHtU8QwsB5GZgylwTWMTwnBDMoSBBPIgsyLg
 pf0Yr9VO7mMCs/9qFA0HLLZDGoHx4VqvHqkxYxlOhGspDLdCx6q1jB18xPDU8MZf4N+CO0NBEZw
 c4WhjlhEa3+iL46sJVr/UAWbK
X-Received: by 2002:adf:e8cd:0:b0:210:2b10:ab22 with SMTP id
 k13-20020adfe8cd000000b002102b10ab22mr4970818wrn.476.1654200505465; 
 Thu, 02 Jun 2022 13:08:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyM5F6JgsKGDtu6GyHns/lkcUnrlSJd7dUYftOOVGVMQv8KigpKfTOOpmHYrxeyjunNyCekoQ==
X-Received: by 2002:adf:e8cd:0:b0:210:2b10:ab22 with SMTP id
 k13-20020adfe8cd000000b002102b10ab22mr4970800wrn.476.1654200505241; 
 Thu, 02 Jun 2022 13:08:25 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id
 bg20-20020a05600c3c9400b0039c15861001sm3796679wmb.21.2022.06.02.13.08.24
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 02 Jun 2022 13:08:24 -0700 (PDT)
Message-ID: <203411bb-39e5-ea3a-3265-354adf1fb551@redhat.com>
Date: Thu, 2 Jun 2022 22:08:23 +0200
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

Marc,

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
Feel free to add my
Tested-by: Eric Auger <eric.auger@redhat.com>

Thanks!

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
