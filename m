Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ACA8C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 16:30:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC67C61462
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 16:30:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AC67C61462
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CEC44B10A;
	Wed, 29 Sep 2021 12:30:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YetDEe4Vhcxt; Wed, 29 Sep 2021 12:30:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 427864B135;
	Wed, 29 Sep 2021 12:30:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CE454B10A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 12:30:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QcAgh0Nekg4u for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Sep 2021 12:30:06 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E0B24B0DF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 12:30:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632933006;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=t7eXK8bCTNOOv/qDjkAKe8YLsRux6EkwGlTN7TYoSGc=;
 b=bOAPgmu7Snz/Ho0kwPYWYSsjGAcC+25Q381GweCFPc0C05IF8V2e0N7We7Wdfe8bI/CST6
 dHXMGLVBsPwKpMQYvP/E+MmbxitRCOqqCzTIPphUT7/l1QO8IN7i46QGmGshvFSCyJadqD
 gUCSkFdi0ieCal3mKXaBMcom8nZP7u4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-8Dqag7fOPYeV60d6FuF6Vg-1; Wed, 29 Sep 2021 12:30:04 -0400
X-MC-Unique: 8Dqag7fOPYeV60d6FuF6Vg-1
Received: by mail-wm1-f72.google.com with SMTP id
 p63-20020a1c2942000000b0030ccf0767baso2935841wmp.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Sep 2021 09:30:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=t7eXK8bCTNOOv/qDjkAKe8YLsRux6EkwGlTN7TYoSGc=;
 b=VjJYqFRD3nsWDjEmzKxTTAHJVhQXPHboFHRwtHqGmpAOfndAzovDhbhj36OR96+u8a
 eFuQLNQr1WvUed+qCIEiUdhzZx64y12MiUerWdC2jwG6CqNw4lZkGGQP5NJGqW5Zsdqg
 JSIt1a5rujZ+VknRqRgD1/X3kauw+2TSMf0+aVqU6jCVd0ivrsxxfLACunLpujeZfJvX
 zebpj7IJxe3HNfXZt1jNXAoK75vcEMOvqNCTqQC55sqIpUElIq2Sw+GgvT0udC0V8/p6
 VvvcaxIxkq13uSh1mv3sF2OAQ8Zvbz09JZl9XabB+4J2CAGRGdIbDTDdSHcBVgluu4p7
 qMAA==
X-Gm-Message-State: AOAM5322rb2KLioazuEejn+xfTO704BmQoKvezZ0fe31GHwPytRRNDIr
 ZWJcdV4gdyFrAd3aaG0u1szxBcouV2iNIqwBZ6saNX26UgW8U2I+0zkvZxBRDJwf6I2MEvyXWTj
 Em53bNzMDgkuPYE4gR4bPugOo
X-Received: by 2002:adf:f191:: with SMTP id h17mr943927wro.43.1632933003597;
 Wed, 29 Sep 2021 09:30:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMKQ2tzAe8SV4xU9Q4r3+pzNtUhyQ6D04HKaRcV2gBTFGRYqLL3oOhEANMbHZjKoZNw4mKbA==
X-Received: by 2002:adf:f191:: with SMTP id h17mr943889wro.43.1632933003388;
 Wed, 29 Sep 2021 09:30:03 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id q18sm2165702wmc.7.2021.09.29.09.30.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 29 Sep 2021 09:30:02 -0700 (PDT)
Subject: Re: [PATCH v3 03/10] KVM: arm64: vgic-v2: Check cpu interface region
 is not above the VM IPA size
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
 alexandru.elisei@arm.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-4-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <4e4248ae-234c-20cb-6428-00a0cc7de5b9@redhat.com>
Date: Wed, 29 Sep 2021 18:30:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210928184803.2496885-4-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
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

Hi Ricardo,

On 9/28/21 8:47 PM, Ricardo Koller wrote:
> Verify that the GICv2 CPU interface does not extend beyond the
> VM-specified IPA range (phys_size).
>
>   base + size > phys_size AND base < phys_size
>
> Add the missing check into kvm_vgic_addr() which is called when setting
> the region. This patch also enables some superfluous checks for the
> distributor (vgic_check_ioaddr was enough as alignment == size for the
> distributors).
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index f714aded67b2..b379eb81fddb 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -79,7 +79,7 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  {
>  	int r = 0;
>  	struct vgic_dist *vgic = &kvm->arch.vgic;
> -	phys_addr_t *addr_ptr, alignment;
> +	phys_addr_t *addr_ptr, alignment, size;
>  	u64 undef_value = VGIC_ADDR_UNDEF;
>  
>  	mutex_lock(&kvm->lock);
> @@ -88,16 +88,19 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
>  		addr_ptr = &vgic->vgic_dist_base;
>  		alignment = SZ_4K;
> +		size = KVM_VGIC_V2_DIST_SIZE;
>  		break;
>  	case KVM_VGIC_V2_ADDR_TYPE_CPU:
>  		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
>  		addr_ptr = &vgic->vgic_cpu_base;
>  		alignment = SZ_4K;
> +		size = KVM_VGIC_V2_CPU_SIZE;
>  		break;
>  	case KVM_VGIC_V3_ADDR_TYPE_DIST:
>  		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V3);
>  		addr_ptr = &vgic->vgic_dist_base;
>  		alignment = SZ_64K;
> +		size = KVM_VGIC_V3_DIST_SIZE;
>  		break;
>  	case KVM_VGIC_V3_ADDR_TYPE_REDIST: {
>  		struct vgic_redist_region *rdreg;
> @@ -162,7 +165,7 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  		goto out;
>  
>  	if (write) {
> -		r = vgic_check_ioaddr(kvm, addr_ptr, *addr, alignment);
> +		r = vgic_check_iorange(kvm, addr_ptr, *addr, alignment, size);
>  		if (!r)
>  			*addr_ptr = *addr;
>  	} else {
Looks god to me

Reviewed-by: Eric Auger <eric.auger@redhat.com>


Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
