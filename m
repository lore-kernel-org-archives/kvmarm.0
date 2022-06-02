Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E906C43334
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jun 2022 20:06:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B06824B224;
	Thu,  2 Jun 2022 16:06:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2EGZKGz5i0HY; Thu,  2 Jun 2022 16:06:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BC1C4B205;
	Thu,  2 Jun 2022 16:06:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C6394B1FE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2022 16:06:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MUsaCTuEor7P for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jun 2022 16:06:47 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E4984B128
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2022 16:06:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1654200406;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=l/i4joqQe4Nrt/4Qofvmf5cvZ87wqEYmhoQLV8Tt5QU=;
 b=hfBBuTecn1WrtOm+emok13XeE+X69z/N3DQYitVe3sX/1xmFbYYLGJCsMnCYSx7wh9Xif8
 xsouUhhEjZKSH5cyaRhWUfykH8EE46eNfFNofOLEohXab6CxRKdZsgEYXQnxt2DH3OBJa3
 /3AJznGFPF0NAf2eZ+EBJX+CzQWUvLc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-zo-8CMoINPSFTpEan5PuiQ-1; Thu, 02 Jun 2022 16:06:45 -0400
X-MC-Unique: zo-8CMoINPSFTpEan5PuiQ-1
Received: by mail-wm1-f71.google.com with SMTP id
 n35-20020a05600c3ba300b0039c1d2c6680so2428032wms.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jun 2022 13:06:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=l/i4joqQe4Nrt/4Qofvmf5cvZ87wqEYmhoQLV8Tt5QU=;
 b=GEvhS/DqD5vTAcIojoUrm2YINQCdf+iWRIR6HSW2ae2bxphqMUQo541w/wmjKZiRAn
 wYHreIbrNShXke6CJ4tdgHKhX1wvcWsohW5UnNFTl5VGjlz3AzLAVpG+i6tEvzH1fpnS
 gRxboDc5RjivdAFcEkm/oZIH3tjFEuf9osl85QZq3c8JyRT3/NlHstJt8KGLyPvu5DBY
 HnsGO8WlkvpSSuQA/hywtNTTKiZ/3j4qPiVsbaP/pnrX0pXLr9Q1q60wFJPkfNPtD8oK
 sZuwTaGlayewKm3sVxEZR4zE1uo1wKRerUoLLPNYmbZGk7Axn5wSt14vulNgfzIM7+/2
 KLmw==
X-Gm-Message-State: AOAM531x3AxdqBtl+xK+13YC4BFG590sXqDPjJFkhwXL0QHPStBntUhc
 LFlK9hODadtPmJNDge9+Aey24ZXv1uTCsC6WdBTa7bAC+u25I4mo3rXcaudpi3CpfpNJkxDyVkl
 llCRrCW5E9kcxT7l5DXxZyjg/
X-Received: by 2002:a5d:5084:0:b0:210:3309:2824 with SMTP id
 a4-20020a5d5084000000b0021033092824mr4950506wrt.110.1654200404653; 
 Thu, 02 Jun 2022 13:06:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw584iK4yyIe0RYsWscdi21nRw5c3HuoXC63v+ECSkcQc+f1+Xof1Ah/uZ9/K4H7F2/h6zzMw==
X-Received: by 2002:a5d:5084:0:b0:210:3309:2824 with SMTP id
 a4-20020a5d5084000000b0021033092824mr4950485wrt.110.1654200404338; 
 Thu, 02 Jun 2022 13:06:44 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id
 o10-20020adfeaca000000b0020c5253d8c2sm5292141wrn.14.2022.06.02.13.06.43
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 02 Jun 2022 13:06:43 -0700 (PDT)
Message-ID: <168da62b-51c0-b883-0912-15139f24d31f@redhat.com>
Date: Thu, 2 Jun 2022 22:06:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 2/3] KVM: arm64: Replace vgic_v3_uaccess_read_pending with
 vgic_uaccess_read_pending
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20220602083025.1110433-1-maz@kernel.org>
 <20220602083025.1110433-3-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20220602083025.1110433-3-maz@kernel.org>
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

Hi Marc,
On 6/2/22 10:30, Marc Zyngier wrote:
> Now that GICv2 has a proper userspace accessor for the pending state,
> switch GICv3 over to it, dropping the local version.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 40 ++----------------------------
>  1 file changed, 2 insertions(+), 38 deletions(-)
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
Don't know if you want a derivative of this comment in
vgic_uaccess_read_pending()?
> -	 */
> -	for (i = 0; i < len * 8; i++) {
> -		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> -		bool state = irq->pending_latch;
> -
> -		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
> -			int err;
> -
in __read_pending(), irq->irq_lock is hold which looks safer at 1st
sight. If potentially fixing something this can be documented in the
commit msg.
> -			err = irq_get_irqchip_state(irq->host_irq,
> -						    IRQCHIP_STATE_PENDING,
> -						    &state);
> -			WARN_ON(err);
> -		}
> -
in __read_pending(), irq_is_pending(irq) is used instead of
irq->pending_latch. for level sensitive IRQ this is not identical. This
may also deserve some comment. The nuance may be related to the above
comment.

Thanks

Eric
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
