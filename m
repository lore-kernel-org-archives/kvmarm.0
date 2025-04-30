Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD56D1E0E1A
	for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 05:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745992463; cv=none; b=cXHboL6z9YtXUW8C0/rn1hg6UzyI7lYvF+In0Dys13no3yl3TzqpnpWezSg0co0vWnd3EtBGX0BZjwLnCjsgCC6/jsLs71/fWIG6CxozybgqCZIjThTmPmhh6MMoGylDRLt1tSmdDzFp+8TnNodTVjinXPShWw3XHg/eQiqb7UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745992463; c=relaxed/simple;
	bh=gjiijpuNZ8eaxb49J32vdBIrEm2hghOHXs5lHIIU/Wg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AFiaYQ/CrwWPSdy8zLPUQhEeo0pOMQN+vRr4XsQ+ozhIoSY4Z026thoPcas5y3msiAwLmjn4XbxBbvgK4b16DdhTMMYHV2OH68xy/hFGlXydtBgE3F182CowZZ15Rg4XTVUxQaWOkcx7G2Aen+BQkDuo+KKlSO831wMsgfSGq/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hZwUs5rW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hZwUs5rW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745992459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bIGWFGarGyFIijKMOzGh/uSVQg6azY82PqS3bKeu+Kk=;
	b=hZwUs5rWgk56EPiga55icA2l4rDrSxK2Db74ZHyyIwn01rgLnJETFFYfg5Z05IDGOo3H/Z
	R9WuQcLKgCDqg+3sPFZlGE8fXJHbhgf50QNUtsjcsBokeNu9roPy/4++Hen65v7m42lH+u
	LMaRgglVaxMgispzxKwcsMQXO/ILlqY=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-552-5AQkYsuxO2iUVRgDs7wexA-1; Wed, 30 Apr 2025 01:54:18 -0400
X-MC-Unique: 5AQkYsuxO2iUVRgDs7wexA-1
X-Mimecast-MFC-AGG-ID: 5AQkYsuxO2iUVRgDs7wexA_1745992457
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-736c1ea954fso3491767b3a.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 22:54:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745992457; x=1746597257;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bIGWFGarGyFIijKMOzGh/uSVQg6azY82PqS3bKeu+Kk=;
        b=bg4hr3La1RRXBd1FniJxjzEpB17TEcC2J4YaUV3XqbVKgAlTK0SqbKdi0lQlA+M331
         mv4qecj0XUgVZMZZjhZ+4LD0rrN3sj1M3uuTHF+Lao1hDo+6EFC84R478C4mCfxwP4w2
         0JnrC9JzeAfEMVfdY1YfcKwSGPjgWr/JqWjXMPG1QMjSP2u+Wls9/WiF0SJ4EtirlENc
         oa+Veg0YgsjjAi/r25g4WGv9la/svzU6q9v0dpzF2vjlgoqjdj2VDzhaBQg5594VzJ1j
         rMXYWwdfMOudM0+7XRgOcilUeDmpiB5eSdgZoIFsOJ9rpEfWB52YNePfwzaJ3jHZqVR7
         0WQA==
X-Forwarded-Encrypted: i=1; AJvYcCXjvitxrp9Stwu6vzIblUbPX0dHn7LvvUkA0HS0Ex/hpOeIgC9+BWzRrhtbDML1aOuo3FWvdG4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwOS8TJQwf4Idkv/IC0Qz5AUAXKKvJSgB2Cmw/j5g78I6w3ePnI
	4U6fM8eGT2DpW8ovcrsw7FjKXiX8IdIGJEHH73trclpIqJOn4FpJspMRN98/PCooA3YSD9Ve8aX
	k8nBaHBpMGCjXOW6ANufYj1sNljJxPcLZpACws6UCVAQwKyhVBQ9uQA==
X-Gm-Gg: ASbGncsZaR/xrxhB3GVmucFoEwvGz7H/ku6/Yxihb9OhufKEKtTg+yPUeEGh3gOx7Qz
	nQpIXbmY8vQNLAt0wKwS26BR6eMWEiEXfXlPU0jJFnlD1b8Dxvqp18wQiAhRJxV70ScQPQpIq8P
	kHWnM0o5PKBc0avI5I3Uesm8k/zcvs3l/u/LyBmQiCQERZ9hVfPp4gspbjrRG6Nnscv54bdsWB9
	dYgZspzGOvUn2vXTXy0bkJN+/gapbwkIGlO00/YQ65ZmlPugWwx422IHXRH88w017w9AlHD6I28
	6pfOLDavrj4s
X-Received: by 2002:a05:6a20:6f09:b0:1ee:c7c8:ca4 with SMTP id adf61e73a8af0-20a89a00bbcmr2861336637.36.1745992457142;
        Tue, 29 Apr 2025 22:54:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUXFSfIAhV0jE/BzfNUpot5jDexa8qPOr5xBP2FVKQDAqbgwsZM0ilxjtUmRqioxNOvLSyig==
X-Received: by 2002:a05:6a20:6f09:b0:1ee:c7c8:ca4 with SMTP id adf61e73a8af0-20a89a00bbcmr2861303637.36.1745992456803;
        Tue, 29 Apr 2025 22:54:16 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74039a94aecsm792360b3a.178.2025.04.29.22.54.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 22:54:16 -0700 (PDT)
Message-ID: <dda34de7-703b-4d9c-8666-c1a195327f32@redhat.com>
Date: Wed, 30 Apr 2025 15:54:08 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 12/43] KVM: arm64: vgic: Provide helper for number of
 list registers
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-13-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-13-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vpJiX4KaPjhmsFJl-tSiWDddA0KglX9Pmkyi1LXCqsg_1745992457
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> Currently the number of list registers available is stored in a global
> (kvm_vgic_global_state.nr_lr). With Arm CCA the RMM is permitted to
> reserve list registers for its own use and so the number of available
> list registers can be fewer for a realm VM. Provide a wrapper function
> to fetch the global in preparation for restricting nr_lr when dealing
> with a realm VM.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> New patch for v6
> ---
>   arch/arm64/kvm/vgic/vgic.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 

With below nitpick addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 8f8096d48925..8d189ce18ea0 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -21,6 +21,11 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
>   	.gicv3_cpuif = STATIC_KEY_FALSE_INIT,
>   };
>   
> +static inline int kvm_vcpu_vgic_nr_lr(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_vgic_global_state.nr_lr;
> +}
> +
>   /*
>    * Locking order is always:
>    * kvm->lock (mutex)
> @@ -802,7 +807,7 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
>   	lockdep_assert_held(&vgic_cpu->ap_list_lock);
>   
>   	count = compute_ap_list_depth(vcpu, &multi_sgi);
> -	if (count > kvm_vgic_global_state.nr_lr || multi_sgi)
> +	if (count > kvm_vcpu_vgic_nr_lr(vcpu) || multi_sgi)
>   		vgic_sort_ap_list(vcpu);
>   
>   	count = 0;
> @@ -831,7 +836,7 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
>   
>   		raw_spin_unlock(&irq->irq_lock);
>   
> -		if (count == kvm_vgic_global_state.nr_lr) {
> +		if (count == kvm_vcpu_vgic_nr_lr(vcpu)) {
>   			if (!list_is_last(&irq->ap_list,
>   					  &vgic_cpu->ap_list_head))
>   				vgic_set_underflow(vcpu);
> @@ -840,7 +845,7 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
>   	}
>   
>   	/* Nuke remaining LRs */
> -	for (i = count ; i < kvm_vgic_global_state.nr_lr; i++)
> +	for (i = count ; i < kvm_vcpu_vgic_nr_lr(vcpu); i++)
>   		vgic_clear_lr(vcpu, i);
>   

The unnecessary space before the semicolon can be dropped.

	for (i = count; i < kvm_vcpu_vgic_nr_lr(vcpu); i++)

>   	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))

Thanks,
Gavin

