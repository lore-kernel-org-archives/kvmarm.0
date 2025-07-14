Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE466246BD9
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 12:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752497567; cv=none; b=LVLudi4gdJft9oSgrHN5t4/E6mOg1dc20w3jkOOOT3zocupOezZd4fRd3+zwkkbDE0FZvdCme2wq6FDw7hoMpIQElzs8J6YHZjIB8ZVOMSkpgbPtCcGMxiOtv1jFuW+wZQwinPcOfsYFpDKAUl37TgqPYuAcEUit6EbaVbBNCqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752497567; c=relaxed/simple;
	bh=6UU+QXP2U1DZmf8xddT0qu9fF+k7SbuSmQTvW3SEWiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jGWifQFWnFNyLqzVWyoXPsqNkNQTRYZPn0cBSFdM8471Qw0vt0Os9twkl0jdQvuBOWydkz6ERV4xnW3IhQoncc0jQI/fpFfRJPIqFNE8ezgPkBf12n4k7ZQI1Gyp2MXbTClHPHcAbIhZqABxWTmjAEW5B/P4yHuvDGhBqmDqgAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zx9uxZ8q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zx9uxZ8q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752497563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PpnCeHPJsIafBnKtVxQhkkDfCyc9AK3tMSisZs1m82w=;
	b=Zx9uxZ8qI/nc1nlZ4fZ49EvHHCfWjjl+tdV0rgrctcmvDG0aedM3dBJaBhEDDFEoDBKEnS
	1BZ9qOr3sbnxor4bgSaL4wMyITibntDxLdb70elsVHVUQttiD8SmXvvdORr4DzzVmA3RRv
	9SeKqtCeXKeOArXocRnSwDdvWKy/LNg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-nv9Tny9xODm2mCUXNPV1aQ-1; Mon, 14 Jul 2025 08:52:42 -0400
X-MC-Unique: nv9Tny9xODm2mCUXNPV1aQ-1
X-Mimecast-MFC-AGG-ID: nv9Tny9xODm2mCUXNPV1aQ_1752497561
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-455f7b86aeeso12866675e9.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 05:52:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752497560; x=1753102360;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PpnCeHPJsIafBnKtVxQhkkDfCyc9AK3tMSisZs1m82w=;
        b=Bi8Kj/rdecKcLWbqd2SM7sHhnsqtGqq18iWsNEWVMPGdPtRBsqxGQkVergdArxDmbX
         3aUAVARPhogg7S2TWQnMXPGap2qNQAjzWmMgVSSk7RTDI9TsyR8N8VostKAcCdRQsBXe
         ZyqdXYImifYvvMUNTyR9uln7Qc2pl1eOHwHxjybVnTVxlyJH+g7ssv1dKmi2VlamTcha
         z06JEtlfDiLAbCoo34Lv0PmlUm0JD1cuKgmv/yf3oiBtXB9ZzuEqhazRFzCpkFBuWg2h
         WgossC31liP5aj5jpLkmDm4Yq+H9CjZ8bS9jBcPCKCWXZA1cibRvHjfRMU1z3lyxrdyN
         pNSw==
X-Forwarded-Encrypted: i=1; AJvYcCVb5e0oYUdshCEoL7H4rJ7qiR0ZfZpMIYHdQFlQk9IReiCqongI2Byw5kO4+O7x1vaTWxZq+4A=@lists.linux.dev
X-Gm-Message-State: AOJu0YxAjK+78ujOhmzpbEKSOG5k0hvttywx1n1RgciWsSgfTr+a1WID
	ORsv4/wCESrW41Ba5lLbgMuuOH+L/GCKRiipXMMx/hMFCMOCshraf/d46HC6wOEk5nfOA6jW5ca
	kGouizraEpO1GOqmGuOG5mBQX1E3fpSfl/noNE3zLS20FT28mU2MTN1WmnvaQfocUJA==
X-Gm-Gg: ASbGncsAJJSkxwUwfMGYzVr0P56Y6Eo609yiYpfA4r2Q7HYdYcNOqUKaLDZE+KcU9RM
	Y0WV+Bdz6BFF++GL9fpAz6UbdoTTnaHQefd954yuDQNQmnPWaB45m1xaK6UwEWO1Asyua+upWuT
	+MhScbsxFS7RhA92rsgBKx6sBFppag2SaCiv60nyqA3E7lxhUMNy/b9tIxPJGtsXlPs0yK7LE/K
	CjTzctpOjCrDMcAM9BMV0JLubb5I0QOSryFZETVaM85LzPcybc47Y5L36xqdr4aaBXyKutYeqlv
	n1wuzMOhn2X8VbPvkwNs9Gkpqn4wWMJY5F/IVGmAfgWLNCgWVRJlOBaTcK9XqIhuBKENSmqZI0F
	qy2QbmQ==
X-Received: by 2002:a05:600c:3155:b0:441:ac58:eb31 with SMTP id 5b1f17b1804b1-454f4257e83mr95866735e9.20.1752497560050;
        Mon, 14 Jul 2025 05:52:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEs5LRFL+2w5eVj4SeXrAGCCtAdBr1imFk0gKJl6v7G9NX6GvLHwpOOQ7rD9+P21yUrXoGbhQ==
X-Received: by 2002:a05:600c:3155:b0:441:ac58:eb31 with SMTP id 5b1f17b1804b1-454f4257e83mr95866515e9.20.1752497559562;
        Mon, 14 Jul 2025 05:52:39 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-455f8fc5a01sm85453345e9.32.2025.07.14.05.52.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 05:52:38 -0700 (PDT)
Message-ID: <3ec89328-57e9-4527-8597-a1567f3ffe10@redhat.com>
Date: Mon, 14 Jul 2025 14:52:37 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/6] KVM: arm64: vgic-v3: Consolidate MAINT_IRQ
 handling
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Raghavendra Rao Ananta <rananta@google.com>,
 Zhou Wang <wangzhou1@hisilicon.com>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
 <20250709211417.2074487-3-oliver.upton@linux.dev>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20250709211417.2074487-3-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bpKRcfdtERMjve7igNmkk_DFZ-EULctB9M4lot0Ozk8_1752497561
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 7/9/25 11:14 PM, Oliver Upton wrote:
> Consolidate the duplicated handling of the VGICv3 maintenance IRQ
> attribute as a regular GICv3 attribute, as it is neither a register nor
> a common attribute.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 51 +++++++++++++--------------
>  1 file changed, 25 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index f9ae790163fb..e28cf68a49c3 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -303,12 +303,6 @@ static int vgic_get_common_attr(struct kvm_device *dev,
>  			     VGIC_NR_PRIVATE_IRQS, uaddr);
>  		break;
>  	}
> -	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ: {
> -		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> -
> -		r = put_user(dev->kvm->arch.vgic.mi_intid, uaddr);
> -		break;
> -	}
>  	}
>  
>  	return r;
> @@ -523,7 +517,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
>  	struct vgic_reg_attr reg_attr;
>  	gpa_t addr;
>  	struct kvm_vcpu *vcpu;
> -	bool uaccess, post_init = true;
> +	bool uaccess;
>  	u32 val;
>  	int ret;
>  
> @@ -539,9 +533,6 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
>  		/* Sysregs uaccess is performed by the sysreg handling code */
>  		uaccess = false;
>  		break;
> -	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
> -		post_init = false;
> -		fallthrough;
>  	default:
>  		uaccess = true;
>  	}
> @@ -561,7 +552,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
>  
>  	mutex_lock(&dev->kvm->arch.config_lock);
>  
> -	if (post_init != vgic_initialized(dev->kvm)) {
> +	if (!vgic_initialized(dev->kvm)) {
>  		ret = -EBUSY;
>  		goto out;
>  	}
> @@ -591,19 +582,6 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
>  		}
>  		break;
>  	}
> -	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
> -		if (!is_write) {
> -			val = dev->kvm->arch.vgic.mi_intid;
> -			ret = 0;
> -			break;
> -		}
> -
> -		ret = -EINVAL;
> -		if ((val < VGIC_NR_PRIVATE_IRQS) && (val >= VGIC_NR_SGIS)) {

> -			dev->kvm->arch.vgic.mi_intid = val;
> -			ret = 0;
> -		}
> -		break;
>  	default:
>  		ret = -EINVAL;
>  		break;
> @@ -630,8 +608,24 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
>  	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
>  	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
>  	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
> -	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
>  		return vgic_v3_attr_regs_access(dev, attr, true);
> +	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ: {
> +		u32 __user *uaddr = (u32 __user *)attr->addr;
> +		u32 val;
> +
> +		if (get_user(val, uaddr))
> +			return -EFAULT;
> +
> +		guard(mutex)(&dev->kvm->arch.config_lock);
Previously we had a more elaborate lock sequence in
vgic_v3_attr_regs_access() including
kvm_trylock_all_vcpus(dev->kvm) and mutex_lock(&dev->kvm->arch.config_lock);
Maybe worth to document in the commit msg why it is safe to remove that?



> +		if (vgic_initialized(dev->kvm))
> +			return -EBUSY;
> +
> +		if ((val < VGIC_NR_SGIS) || (val >= VGIC_NR_PRIVATE_IRQS))
nit: !irq_is_ppi()?

Thanks

Eric
> +			return -EINVAL;
> +
> +		dev->kvm->arch.vgic.mi_intid = val;
> +		return 0;
> +	}
>  	default:
>  		return vgic_set_common_attr(dev, attr);
>  	}
> @@ -645,8 +639,13 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
>  	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
>  	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
>  	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
> -	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
>  		return vgic_v3_attr_regs_access(dev, attr, false);
> +	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ: {
> +		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> +
> +		guard(mutex)(&dev->kvm->arch.config_lock);
> +		return put_user(dev->kvm->arch.vgic.mi_intid, uaddr);
> +	}
>  	default:
>  		return vgic_get_common_attr(dev, attr);
>  	}

