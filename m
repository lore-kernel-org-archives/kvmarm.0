Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCCB3232
	for <kvmarm@lists.linux.dev>; Mon,  3 Mar 2025 04:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740977338; cv=none; b=Gm/PNqyq4Z0RvdJucDi9uSw3MuexTL+BYXYfFpfYjbHMfIb5avYbRi+WJUiGHY7oB1kxvpFikUnac2VEwhbqrWUTAebpxXM5eHC5QRmvqedjezfxKMCsIU3VthO/UCY6dPlEX7W1LZhQgTdqWjN5rGxhJteSISfDHld5Ja3gTF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740977338; c=relaxed/simple;
	bh=zGU7A3mRvM1g91UEynHedjBx/bXUZ7w7qLMnWHvuBwk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L0kgUJsqLCQIWW2HpZxRSwdFnuSmMC2vYJwrd4IwL6DrlAEtQwt0/0gGwYdKVDrUTfLNolU8mdyjjLzb0NoPyBXedRVkYE/MXaKG5pio/uiHCPQnnxzcQo62J+oKo8NWwJ5YxLRAO7xKstEzlh8HSo0gFhbumq1Vw3PWhsDLEmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ViU0dSQ4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ViU0dSQ4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740977336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=szUhRzEc3gD/KXfeBaNWZbbt2DelRUyv9Ye2MPiDleo=;
	b=ViU0dSQ4VYznw5zuLAZoWWzkYc1BoCP1nOly2nlryCwOO6jZRU2JenN5yqc18YYvPGU599
	YsiL8czkWZiBjolqkqk5Wc4k0+q7hb4mSkv6n3MA3xfxFILGU5LYJUGu8Zb/iYYL9NzbCp
	5Ja5AV6JaBbYxkE7skQV8O4IXue0kNw=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-DHFTI8REPr-klA8Dsw7SuA-1; Sun, 02 Mar 2025 23:48:54 -0500
X-MC-Unique: DHFTI8REPr-klA8Dsw7SuA-1
X-Mimecast-MFC-AGG-ID: DHFTI8REPr-klA8Dsw7SuA_1740977333
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2feda472a7bso2572825a91.3
        for <kvmarm@lists.linux.dev>; Sun, 02 Mar 2025 20:48:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740977333; x=1741582133;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=szUhRzEc3gD/KXfeBaNWZbbt2DelRUyv9Ye2MPiDleo=;
        b=Uytf7SPWU6+EQZoKBDRvWGMOn9b86utP5/BuLeH90ycDX8CgIn8uQ+Zr55pX2KHWHe
         KMrnGDoGc4/0nUDnqdMZR4AJjL5ijqbmbJZod7ELJoHIoYwG4PRh2lfVwDnZUtaRmfyo
         dw6hbdLOk+UdZA6+jAy4FLZ3GGJi7SCdKniyKKxB3rUHPMwRHr9AlIJtxTqUkjiE5RUk
         uPCF8TjsWdhWAyE70HneOpu6C6RxGPpQvcuixyTi5O1QnJkx8icwkkaBmKwInEM4/PA9
         omlyo44C+cW2kyUl71702dinWVhzKdwN082V46wHbu/pE091Eg4JFhM7w3JXRVY04+2G
         xpKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYr99uMAVmRpKSxpmrb58XJ4Mo9vfRPy7QdFSO7Gcj3t0wFHesMW9vrUN80MCUCZGv6r7jrEM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwxcTJz0ITOUZAGmIaBiMimbkOcb8FwEJk/AHg1ZEIYiq+D5dLM
	Aqq/zEEhikov9L0EZMHY2KOMPZ5qe5d1TJNYtDdLzWZRHSfw9rCp1cz+esO1ZRG7MUK2oIL1iMT
	lBgCNuHbk/aNvjVNmSazGDE8EEUjG3Xqus/Bbuy2WQrEcXSnUzMCkNw==
X-Gm-Gg: ASbGncs8HfnvE+3iIqkOc/PQhkwACNeIzUsd6nu7top0W9A++M9LhS6PvJBm4ojoHlw
	3KRysWU2eSLPC17J+Pb2dxkxf44XKJW9QkGLTrnn6pYUCAqn1TfFNiGdA5fgI7ZJxnIsO2HXa8T
	RCKbAmIxFUcHsfWSDI7Zh8UnxcnjJ4bWchgoW45IK5Gep0D5plq5XzoP0bWEKpESObSjxVeNo4V
	M+SKIjwyxFNgwcf5WTrDjoWcA0kwQvprB7W7ZtCuv8clM0o0OG54fDVeygf06v6nO/g1Ce9MNkl
	gRG2/FQEaPZIGSdDrA==
X-Received: by 2002:a17:90b:3e84:b0:2ee:8031:cdbc with SMTP id 98e67ed59e1d1-2febac046a6mr14181201a91.23.1740977333520;
        Sun, 02 Mar 2025 20:48:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF0bFqBHp5vrV5kno/u9pdc5LbTz/krk4wxyP++znTwdfie+ZMz0iB8kF9GwoMI70Qf1wWKBg==
X-Received: by 2002:a17:90b:3e84:b0:2ee:8031:cdbc with SMTP id 98e67ed59e1d1-2febac046a6mr14181169a91.23.1740977333178;
        Sun, 02 Mar 2025 20:48:53 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2235050d7c1sm68704355ad.198.2025.03.02.20.48.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 20:48:52 -0800 (PST)
Message-ID: <cec600f2-2ddc-4c71-9bab-0a0403132b43@redhat.com>
Date: Mon, 3 Mar 2025 14:48:44 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 09/45] kvm: arm64: Expose debug HW register numbers for
 Realm
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-10-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-10-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Qwr4sVCI6AuYu9s3li26TzKbyp9vMV5xMm87z72kXo4_1740977333
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:13 AM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Expose VM specific Debug HW register numbers.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/arm.c | 24 +++++++++++++++++++++---
>   1 file changed, 21 insertions(+), 3 deletions(-)
> 

Documentation/virt/kvm/api.rst needs to be updated accordingly.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index b8fa82be251c..df6eb5e9ca96 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -78,6 +78,22 @@ bool is_kvm_arm_initialised(void)
>   	return kvm_arm_initialised;
>   }
>   
> +static u32 kvm_arm_get_num_brps(struct kvm *kvm)
> +{
> +	if (!kvm_is_realm(kvm))
> +		return get_num_brps();
> +	/* Realm guest is not debuggable. */
> +	return 0;
> +}
> +
> +static u32 kvm_arm_get_num_wrps(struct kvm *kvm)
> +{
> +	if (!kvm_is_realm(kvm))
> +		return get_num_wrps();
> +	/* Realm guest is not debuggable. */
> +	return 0;
> +}
> +

The above two comments "Realm guest is not debuggable." can be dropped since
the code is self-explanatory, and those two functions are unnecessary to be
kept in that way, for example:

	case KVM_CAP_GUEST_DEBUG_HW_BPS:
		return kvm_is_realm(kvm) ? 0 : get_num_brps();
	case KVM_CAP_GUEST_DEBUG_HW_WRPS:
		return kvm_is_realm(kvm) ? 0 : get_num_wrps();


>   int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>   {
>   	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
> @@ -323,7 +339,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
>   	case KVM_CAP_ARM_NISV_TO_USER:
>   	case KVM_CAP_ARM_INJECT_EXT_DABT:
> -	case KVM_CAP_SET_GUEST_DEBUG:
>   	case KVM_CAP_VCPU_ATTRIBUTES:
>   	case KVM_CAP_PTP_KVM:
>   	case KVM_CAP_ARM_SYSTEM_SUSPEND:
> @@ -331,6 +346,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_COUNTER_OFFSET:
>   		r = 1;
>   		break;
> +	case KVM_CAP_SET_GUEST_DEBUG:
> +		r = !kvm_is_realm(kvm);
> +		break;
>   	case KVM_CAP_SET_GUEST_DEBUG2:
>   		return KVM_GUESTDBG_VALID_MASK;
>   	case KVM_CAP_ARM_SET_DEVICE_ADDR:
> @@ -376,10 +394,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);
>   		break;
>   	case KVM_CAP_GUEST_DEBUG_HW_BPS:
> -		r = get_num_brps();
> +		r = kvm_arm_get_num_brps(kvm);
>   		break;
>   	case KVM_CAP_GUEST_DEBUG_HW_WPS:
> -		r = get_num_wrps();
> +		r = kvm_arm_get_num_wrps(kvm);
>   		break;
>   	case KVM_CAP_ARM_PMU_V3:
>   		r = kvm_arm_support_pmu_v3();

Thanks,
Gavin

