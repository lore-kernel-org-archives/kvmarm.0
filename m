Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9171D262FC4
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 23:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746142259; cv=none; b=E/tVD91w/TEnGTKgc6pflnN8cLssnY/zIut0zyB+R7sVyqxAazxoU6d5qLqa23HZlbRX/WL6zb4yjxyksGCb0xCN5wzDTQbLXu0SyY1OxmHVVe22GfuTE1cgn8uwevygq1IuoOSdqDMi65CugdY+SSeTz2aJ+14E6WIqn00PU48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746142259; c=relaxed/simple;
	bh=xVGEn53VMIadoPNtpTXYP9w2q/1FWFt4j5ySM3+Il+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PVcTXs+lMVONdyqbu+Vi5w+i4cNppNurDDnJk93Xoit19aF2GhfvZJOpAcWDHalEqpgfAtnB6XaTFgOSaCHkjlL4IM8Cuglvan9BCknlHmEEpARQGXEq6tnNg+ns6/uaAiUZG16MkPG+BndKdvSesYP87d4Lj9mP4eOu778g19Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gIjzGHXf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gIjzGHXf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746142256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V61xkxPc38oYjgZEUT4lB2Jdszj4oz3OEIRZu6N5HPs=;
	b=gIjzGHXfn4m1KLPwUzQ7v6DBOI6QYyhbetysAooCi6KIEpuH7F5qKWrGLjdoPHMcnuBWqt
	4S4YTsRyaOIWSBYEhvzPSQskwXs+AVFLYGJqn9I5IUiUPp3PagCvdEP41OSOR5W9ViViy5
	D92/jtiSfLqv62wrMCFlXuyVVIeaif0=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-TN3d9tkeMqibo2Jzc1g6HA-1; Thu, 01 May 2025 19:30:53 -0400
X-MC-Unique: TN3d9tkeMqibo2Jzc1g6HA-1
X-Mimecast-MFC-AGG-ID: TN3d9tkeMqibo2Jzc1g6HA_1746142252
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b1c122308dcso1630288a12.3
        for <kvmarm@lists.linux.dev>; Thu, 01 May 2025 16:30:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746142252; x=1746747052;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V61xkxPc38oYjgZEUT4lB2Jdszj4oz3OEIRZu6N5HPs=;
        b=Nhaqgtd0Jjby8Y81tFSHgRgBxaAkLAUHIZXXtHq15MuYiLYt3YDAQHdzrXQ+V2kmby
         oFwJGdUkiLGUOB229RHKMcsy1IGCxZT5vVR9dJJau27zL2QZULXpXzod9fQixMU1FwWG
         9VxxaVL7JNeUDtwZNZXnK87vS7W7jTmsPHwpvsN9s6HsnoBZLJEbkQRtndhCRe6uEcHU
         xoMNOIAoNXtBlr7u3m/84le0F0SP3nrFOEZXnBrYX2TRpJiPJzrrKw+12to3HgwHm5U0
         YWT7vMw7Eb55ONiew4n+fjQrMBApsBHufC0ttZFmtXInVxcXllxt8KR6S17/B3QpU9Tw
         BseQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtke3WOJH1ZVcMqDYUFj6gAXrqmx4fh23Th3aFkck9HINGw2fuwtmULDn4mTWjTe4aAeJbBTI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8biMbaRqMpU8SvZzjajinMOEK1PuKSs7xfO0JzbxHTAOMmtdM
	2TykG8BBOcj1uL6pgqFExrRRQ8Tw9SKb45L0OL2mwv7rAQu5y/BqBa4Lhbxd9M/nnElKwn6wbd3
	KFK4AzMd//iOmZhdRnY1O14TZ0otk9DN23QK9D1UwHDG4JtbcFbnTdQ==
X-Gm-Gg: ASbGncsjNTvA5h8UIXKiFZoX8cradbXafKBktGtnVlcn9y0PhiP+6ZY+pOnSCfaW08B
	YHIyLf9SzCxml2oGtddyXOE5YTwtbnhzteK4BxTYpL0WFB3T8QSJ9DLRU4jvS9vuV1gz+rmZpcj
	4XB9osWGhdGTUz2CjlqbgjHIhuVJjXD8thPawC5N0SwdO38bXkalvxALWr7d4IrKFZipUEoZnMb
	dSIPZirkhUBrCfvbkeDYw8/M8g+HYR1WG6KbCATOuhEXhiQ7ywoFX9JTC5/UfyvM4pYSHeSsM6G
	XJpD2/DFMeF9
X-Received: by 2002:a05:6a20:394d:b0:1f3:2c55:8d8a with SMTP id adf61e73a8af0-20cde952da6mr1047587637.12.1746142252566;
        Thu, 01 May 2025 16:30:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2dZAV7HsuZ8oKI3zYsiz7ja1Xpp36L3rGRrA0ckr87PI6dc2juV/UWU2b7kcpP5iRZnp7dw==
X-Received: by 2002:a05:6a20:394d:b0:1f3:2c55:8d8a with SMTP id adf61e73a8af0-20cde952da6mr1047551637.12.1746142252156;
        Thu, 01 May 2025 16:30:52 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fa82422e0sm228551a12.13.2025.05.01.16.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 16:30:51 -0700 (PDT)
Message-ID: <6799bc5f-cc4a-446e-b47b-1cbabbc0b518@redhat.com>
Date: Fri, 2 May 2025 09:30:42 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 39/43] arm64: RME: Provide register list for
 unfinalized RME RECs
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
 <20250416134208.383984-40-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-40-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ab-1q1yXzC6l4lFFGu64NYgviVMJaQufolF7eLRHKAA_1746142252
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:42 PM, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> KVM_GET_REG_LIST should not be called before SVE is finalized. The ioctl
> handler currently returns -EPERM in this case. But because it uses
> kvm_arm_vcpu_is_finalized(), it now also rejects the call for
> unfinalized REC even though finalizing the REC can only be done late,
> after Realm descriptor creation.
> 
> Move the check to copy_sve_reg_indices(). One adverse side effect of
> this change is that a KVM_GET_REG_LIST call that only probes for the
> array size will now succeed even if SVE is not finalized, but that seems
> harmless since the following KVM_GET_REG_LIST with the full array will
> fail.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/arm.c   | 4 ----
>   arch/arm64/kvm/guest.c | 9 +++------
>   2 files changed, 3 insertions(+), 10 deletions(-)
> 

With below comment addressed.

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 4780e3af1bb9..eaa60ba6d97b 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1832,10 +1832,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   		if (unlikely(!kvm_vcpu_initialized(vcpu)))
>   			break;
>   
> -		r = -EPERM;
> -		if (!kvm_arm_vcpu_is_finalized(vcpu))
> -			break;
> -
>   		r = -EFAULT;
>   		if (copy_from_user(&reg_list, user_list, sizeof(reg_list)))
>   			break;
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index dd379aba31bb..1288920fc73d 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -671,12 +671,9 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
>   {
>   	const unsigned int slices = vcpu_sve_slices(vcpu);
>   
> -	if (!vcpu_has_sve(vcpu))
> +	if (!vcpu_has_sve(vcpu) || !kvm_arm_vcpu_sve_finalized(vcpu))
>   		return 0;
>   
> -	/* Policed by KVM_GET_REG_LIST: */
> -	WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
> -
>   	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */)
>   		+ 1; /* KVM_REG_ARM64_SVE_VLS */
>   }

KVM_REG_ARM64_SVE_VLS is exposed even SVE isn't finalized. See set_sve_vls() where
it's required that SVE isn't finalized, or -EPERM is returned. So this would be
something like below:

	if (!vcpu_has_sve(vcpu))
		return 0;

	if (!kvm_arm_vcpu_sve_finalized(vcpu))
		return 1;	/* KVM_REG_ARM64_SVE_VLS */

	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */)
		+ 1; /* KVM_REG_ARM64_SVE_VLS */

> @@ -692,8 +689,8 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
>   	if (!vcpu_has_sve(vcpu))
>   		return 0;
>   
> -	/* Policed by KVM_GET_REG_LIST: */
> -	WARN_ON(!kvm_arm_vcpu_sve_finalized(vcpu));
> +	if (!kvm_arm_vcpu_sve_finalized(vcpu))
> +		return -EPERM;
>   
>   	/*
>   	 * Enumerate this first, so that userspace can save/restore in

Since KVM_REG_ARM64_SVE_VLS can be exposed before the vCPU is finalized, it'd better to
move the check after the followup block where KVM_REG_ARM64_SVE_VLS index is copied
to user space.

	/*
          * Enumerate this first, so that userspace can save/restore in
          * the order reported by KVM_GET_REG_LIST:
          */
         reg = KVM_REG_ARM64_SVE_VLS;
         if (put_user(reg, uindices++))
                 return -EFAULT;
         ++num_regs;

	if (!kvm_arm_vcpu_sve_finalized(vcpu))
		return num_regs;

Thanks,
Gavin
	

