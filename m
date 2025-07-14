Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F20E1DEFDD
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 12:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752497995; cv=none; b=iPSw0LhIveQigLlS+zRmqPcAifI6BR7hsgTEDirfRBjRXumo7640eYSJSANApV6uHSejV9hiRr2phNWqlh14NsRQB5wCrSentufIXQom48OiXa7F6s9lXllRUl77iGgxBh6PrLGQ/ob6bj6d8TXVhk4sQZ7oviQDSFRdje0AP18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752497995; c=relaxed/simple;
	bh=qv69AQhkVHuQa7dTCCJJnMJIU92WsTIJ4t9pWgf+x6U=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=VPKuxG53oNlA9y1sfR1afRnQ0oiCn2O0hVfLOjQuXGMGI17gjj02wRKee87h6ZhZyLHOoN/dtvfQcATXXObiPtVMThz5f2dPhjj6SzILQPbLWwKOX4virqbgwLSeWPyz1ko4FLZieny4Vj3uZyfloriraI+zC3S03VffMPL6fEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UTEzyMtR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UTEzyMtR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752497992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ujD2aO+7jRtmoI26nY07rpizetu8iLKX8yfGwL3Ejgw=;
	b=UTEzyMtRRU8+S0qy06uJ1V/IOQUXWyvtIqADCFgl9Bitf0FL5kymxYnFxqkwq5MzJr+qTc
	K2lRmb5cijSF5aLzhM4uwCN+FxiKyfxH9AX0NqNX01eKMUUAhQqCv023H4jBkSM7fnt5fh
	MrDBQCwvUwOpJhdIs2MBiSgyD9aZB38=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-7DrsWCK9PPO4DYjE_NBKiA-1; Mon, 14 Jul 2025 08:59:51 -0400
X-MC-Unique: 7DrsWCK9PPO4DYjE_NBKiA-1
X-Mimecast-MFC-AGG-ID: 7DrsWCK9PPO4DYjE_NBKiA_1752497990
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451ecc3be97so22690955e9.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 05:59:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752497989; x=1753102789;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ujD2aO+7jRtmoI26nY07rpizetu8iLKX8yfGwL3Ejgw=;
        b=wmaa6ueJ/Mw6i9KYHfZ8QKPD2TeA0ztHkikgP9R4j0OswasLD5NW0PMT4AnaNL1unY
         XFs5bHhfxrkl4F+6PF2JaZYRqFut0/iciRdsAM1ahAdHwMdCkHGAL7hQXSYfEZTdl8AJ
         l76la+42IVYvzJ/gZBjHEvQL8IB8ODIXm5ocU/4vQ14gNajLfIQhxRzUnU6wpkWhPf77
         bjiv7bOB9hIiREQj43lsr0HKYnTfa4QccA5i4M9xShxGqab0anCQn4EZiptoEvKO5Vb1
         EZ/0wsRYBBEQ3NQQIQcaNkPjpFoZ7Fz+IKWnGOKylKajrQuWiZTF73PI2xcOjPw6Wma9
         K7Qw==
X-Forwarded-Encrypted: i=1; AJvYcCWmBB8xc9BdGma9BlgIWgfSY5+80JqqMOCtQULOtDNQdXRNyDXLkgZRFqjQWsTEM+TjhaAcZMg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyk9mSWBSViKJII73OTwQD2O/6Om+x56h3/nc5GTrYmsmr2uAu8
	GIjxaH4k4vYyOaoP86uEkVxUXpLqZon+Q0uDk7WHj4fYCCY8CkYn8MahxQUau5oiw7yJnDZZ7QJ
	vKgNvDkrX+AzDn9QLBoq/RtPUtyjUS4HvMpVmJLf3BTxRTYWB2xrCVZHmnP53uI/MhQ==
X-Gm-Gg: ASbGnctDykWC3dQes7rksteDkxiIQsw1bYxrwJ3D3KHrysKg3+948J7yE0vUNUI7mju
	m0kmbV8T5vu+COzG/96yNdA3E7qphW/rcJmdVtUIC9/ZDtpJWOM4SFJ4iEgqsmQzwRNBntY0FLG
	NuU7AX3/4wwnvYbFchyb3A/A4lvjmefTTh7cJ8UPF98Qg/T4OvMGE6NoNrN7/SBc3hMxSPVsQX5
	B7oiHI8Ndo7rCBzlmhd6sbjsZVJfPQ3fTQyZx4yHqd4F3Jojeb3svtVJY7n+WrALHT+aSSwdWyl
	VwBlLuV1iP4ZwoNfhh+/gMhOnG/rFXDQQnfusYhvMk8be62lM+wPdyhD+YzcWe9hyMPsJ9SP/BB
	W8D1fJg==
X-Received: by 2002:a05:600c:8b70:b0:456:fc1:c286 with SMTP id 5b1f17b1804b1-4560fc1c49amr49631945e9.1.1752497989415;
        Mon, 14 Jul 2025 05:59:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2VoU8Fo6KRGk25eoT2A1TUi8DxhnUPU41K6bPuIUS90s9m9pg888fup1bVy0XvlnPUoT71g==
X-Received: by 2002:a05:600c:8b70:b0:456:fc1:c286 with SMTP id 5b1f17b1804b1-4560fc1c49amr49631685e9.1.1752497988915;
        Mon, 14 Jul 2025 05:59:48 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454dd4b32d8sm131997205e9.17.2025.07.14.05.59.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 05:59:48 -0700 (PDT)
Message-ID: <7f9e9536-74e6-456c-afe3-79d5120f64a9@redhat.com>
Date: Mon, 14 Jul 2025 14:59:47 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/6] KVM: arm64: vgic-v3: Consolidate MAINT_IRQ
 handling
From: Eric Auger <eauger@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Raghavendra Rao Ananta <rananta@google.com>,
 Zhou Wang <wangzhou1@hisilicon.com>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
 <20250709211417.2074487-3-oliver.upton@linux.dev>
 <3ec89328-57e9-4527-8597-a1567f3ffe10@redhat.com>
In-Reply-To: <3ec89328-57e9-4527-8597-a1567f3ffe10@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8csMsGFiCTcYq_EuralBULc5iXKHlCCRWHhIj2x2sak_1752497990
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/14/25 2:52 PM, Eric Auger wrote:
> Hi Oliver,
> 
> On 7/9/25 11:14 PM, Oliver Upton wrote:
>> Consolidate the duplicated handling of the VGICv3 maintenance IRQ
>> attribute as a regular GICv3 attribute, as it is neither a register nor
>> a common attribute.
>>
>> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
>> ---
>>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 51 +++++++++++++--------------
>>  1 file changed, 25 insertions(+), 26 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
>> index f9ae790163fb..e28cf68a49c3 100644
>> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
>> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
>> @@ -303,12 +303,6 @@ static int vgic_get_common_attr(struct kvm_device *dev,
>>  			     VGIC_NR_PRIVATE_IRQS, uaddr);
>>  		break;
>>  	}
>> -	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ: {
>> -		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
>> -
>> -		r = put_user(dev->kvm->arch.vgic.mi_intid, uaddr);
>> -		break;
>> -	}
>>  	}
>>  
>>  	return r;
>> @@ -523,7 +517,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
>>  	struct vgic_reg_attr reg_attr;
>>  	gpa_t addr;
>>  	struct kvm_vcpu *vcpu;
>> -	bool uaccess, post_init = true;
>> +	bool uaccess;
>>  	u32 val;
>>  	int ret;
>>  
>> @@ -539,9 +533,6 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
>>  		/* Sysregs uaccess is performed by the sysreg handling code */
>>  		uaccess = false;
>>  		break;
>> -	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
>> -		post_init = false;
>> -		fallthrough;
>>  	default:
>>  		uaccess = true;
>>  	}
>> @@ -561,7 +552,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
>>  
>>  	mutex_lock(&dev->kvm->arch.config_lock);
>>  
>> -	if (post_init != vgic_initialized(dev->kvm)) {
>> +	if (!vgic_initialized(dev->kvm)) {
>>  		ret = -EBUSY;
>>  		goto out;
>>  	}
>> @@ -591,19 +582,6 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
>>  		}
>>  		break;
>>  	}
>> -	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
>> -		if (!is_write) {
>> -			val = dev->kvm->arch.vgic.mi_intid;
>> -			ret = 0;
>> -			break;
>> -		}
>> -
>> -		ret = -EINVAL;
>> -		if ((val < VGIC_NR_PRIVATE_IRQS) && (val >= VGIC_NR_SGIS)) {
> 
>> -			dev->kvm->arch.vgic.mi_intid = val;
>> -			ret = 0;
>> -		}
>> -		break;
>>  	default:
>>  		ret = -EINVAL;
>>  		break;
>> @@ -630,8 +608,24 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
>>  	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
>>  	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
>>  	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
>> -	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
>>  		return vgic_v3_attr_regs_access(dev, attr, true);
>> +	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ: {
>> +		u32 __user *uaddr = (u32 __user *)attr->addr;
>> +		u32 val;
>> +
>> +		if (get_user(val, uaddr))
>> +			return -EFAULT;
>> +
>> +		guard(mutex)(&dev->kvm->arch.config_lock);
> Previously we had a more elaborate lock sequence in
> vgic_v3_attr_regs_access() including
> kvm_trylock_all_vcpus(dev->kvm) and mutex_lock(&dev->kvm->arch.config_lock);
forget the last one which is obviously covered by the guard(mutex)

Eric
> Maybe worth to document in the commit msg why it is safe to remove that?
> 
> 
> 
>> +		if (vgic_initialized(dev->kvm))
>> +			return -EBUSY;
>> +
>> +		if ((val < VGIC_NR_SGIS) || (val >= VGIC_NR_PRIVATE_IRQS))
> nit: !irq_is_ppi()?
> 
> Thanks
> 
> Eric
>> +			return -EINVAL;
>> +
>> +		dev->kvm->arch.vgic.mi_intid = val;
>> +		return 0;
>> +	}
>>  	default:
>>  		return vgic_set_common_attr(dev, attr);
>>  	}
>> @@ -645,8 +639,13 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
>>  	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
>>  	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
>>  	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
>> -	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
>>  		return vgic_v3_attr_regs_access(dev, attr, false);
>> +	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ: {
>> +		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
>> +
>> +		guard(mutex)(&dev->kvm->arch.config_lock);
>> +		return put_user(dev->kvm->arch.vgic.mi_intid, uaddr);
>> +	}
>>  	default:
>>  		return vgic_get_common_attr(dev, attr);
>>  	}
> 

