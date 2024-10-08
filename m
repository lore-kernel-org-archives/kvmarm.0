Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AD08F6C
	for <kvmarm@lists.linux.dev>; Tue,  8 Oct 2024 00:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728347059; cv=none; b=cIicU9dANXrF88y9hI4qwCJTJwCd+rLe68LkiP8NuskLxOZzPuG+bk2agb66yKWIP7MA09vVkBsbFZry7Y3cjCNvlW4f8NzhwB1uhj2Qg0Oec9lf2GUCU7whYJyiaJyoFZ+1W/SSLChZIH+5XfNvcVfkguxvjTM3KihBeS/4jFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728347059; c=relaxed/simple;
	bh=KvWJnwVwl0NDrPnt2jed9aYpkeaKZIfqaGFr9K23u8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L0GFRabYttmzF7VQOnaNAXdFh1GdfqBP6hbAcI94JCsEHbURfox4OLHFkeQ+lg677xT5IgeLBGH5PgaO5KDgj7//kAe8MpD1SdMGQOGQ4Zy5UAhpO7+IaiR6fEWJPISbArN9Ra+3wCwAlwBnflhzTWa9vGdS/pXlgJKmOUYjORM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RhpLiOq7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RhpLiOq7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728347055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0376WQc127XhNG695n+yocxmWIkuvVKsPdxkTLuIqys=;
	b=RhpLiOq7FalyB0CX8I7lgTqdpP93eE0xBy+WhMVqcrH4Nx+StnJOGIsDKGvLBTH/+WNNie
	3T2hQbQ3UGYJFlhFhRPY1nY+0l8Xw0OkroOJ5kUOz5c3EmKoNbhvPr93vxOwj618dNaOhh
	8Ktm0HWuSAvmzDbFkZ/3lVCVoILSP3U=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-yQu9IR_4PwCzpALeQz8ZCQ-1; Mon, 07 Oct 2024 20:24:14 -0400
X-MC-Unique: yQu9IR_4PwCzpALeQz8ZCQ-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-6c8f99fef10so6417780a12.3
        for <kvmarm@lists.linux.dev>; Mon, 07 Oct 2024 17:24:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728347053; x=1728951853;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0376WQc127XhNG695n+yocxmWIkuvVKsPdxkTLuIqys=;
        b=idPXD8g0dPZrntu5xgB6axw9DKveCHLYyzrWR8RxolYzkkMjycMUabtWWmqtqpmBTt
         Xr4cJJRKAXugZGgUozLCDN/xJIWFlVux+WTCUlnXIAWw9bZkpXBFTk381f1UBb2Jqczx
         +ywrVzg0zibZTUJIG/nPmrv4rXHYTMoEECHvAMP+OGM23m0urmMBAOzgr6ePiFuZ4Ydd
         g4DihJk8vrir6y9IHhTCnh6AZFQYy/yXodh4cPGrBp7IVsFIQ0tfMGkF0mowyrrT/hvc
         /cgzI0gBi5tzQeRlS2gIi/tdj8CooPXpbzytoEMJjS9WDShRdw+KCtylonzEDQPew8lt
         VM2g==
X-Forwarded-Encrypted: i=1; AJvYcCUL6/AQCbgwyxuCKbpVPU6RTWl15ekLORHhfg6oLt5RR5e9qxw8dE/dlLJeXw8iNvK9lTvaKlY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyd4ofKbh3XBXLm/2d3SlF29FFAdK2HluuC9AuFBHs9OnuJEG3m
	5kp7tV5ADDDQgzd0sBuMwMqKm/qYL12KqEpIpbIrsXFyPHf+NljQOh6bntFb9anFY+HjBxKhzop
	9IlCqGxvx8c8xj2Eat8nwKevg4u35IIWYZLG4hhKOM3tQrVig8G4PbQ==
X-Received: by 2002:a17:902:d504:b0:20b:861a:25d3 with SMTP id d9443c01a7336-20bfdfd9423mr232892245ad.21.1728347053584;
        Mon, 07 Oct 2024 17:24:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGmBrtcwDaxpRIh5M4VJUUsKgMzLr25X0QLxLVSlJzA+dyLr+IP/KpbXFMj9jVG7hvezGVaGA==
X-Received: by 2002:a17:902:d504:b0:20b:861a:25d3 with SMTP id d9443c01a7336-20bfdfd9423mr232891965ad.21.1728347053242;
        Mon, 07 Oct 2024 17:24:13 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c138afc71sm45326155ad.47.2024.10.07.17.24.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 17:24:12 -0700 (PDT)
Message-ID: <2b161369-b9b3-4103-9cf4-fa316dec0ca1@redhat.com>
Date: Tue, 8 Oct 2024 10:24:03 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/11] arm64: rsi: Add support for checking whether an
 MMIO is protected
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
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-5-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004144307.66199-5-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/24 12:42 AM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> On Arm CCA, with RMM-v1.0, all MMIO regions are shared. However, in
> the future, an Arm CCA-v1.0 compliant guest may be run in a lesser
> privileged partition in the Realm World (with Arm CCA-v1.1 Planes
> feature). In this case, some of the MMIO regions may be emulated
> by a higher privileged component in the Realm world, i.e, protected.
> 
> Thus the guest must decide today, whether a given MMIO region is shared
> vs Protected and create the stage1 mapping accordingly. On Arm CCA, this
> detection is based on the "IPA State" (RIPAS == RIPAS_IO). Provide a
> helper to run this check on a given range of MMIO.
> 
> Also, provide a arm64 helper which may be hooked in by other solutions.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> New patch for v5
> ---
>   arch/arm64/include/asm/io.h       |  8 ++++++++
>   arch/arm64/include/asm/rsi.h      |  2 ++
>   arch/arm64/include/asm/rsi_cmds.h | 21 +++++++++++++++++++++
>   arch/arm64/kernel/rsi.c           | 26 ++++++++++++++++++++++++++
>   4 files changed, 57 insertions(+)
> 

With the following nitpick addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> index 1ada23a6ec19..cce445ff8e3f 100644
> --- a/arch/arm64/include/asm/io.h
> +++ b/arch/arm64/include/asm/io.h
> @@ -17,6 +17,7 @@
>   #include <asm/early_ioremap.h>
>   #include <asm/alternative.h>
>   #include <asm/cpufeature.h>
> +#include <asm/rsi.h>
>   
>   /*
>    * Generic IO read/write.  These perform native-endian accesses.
> @@ -318,4 +319,11 @@ extern bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
>   					unsigned long flags);
>   #define arch_memremap_can_ram_remap arch_memremap_can_ram_remap
>   
> +static inline bool arm64_is_mmio_private(phys_addr_t phys_addr, size_t size)
> +{
> +	if (unlikely(is_realm_world()))
> +		return arm64_is_protected_mmio(phys_addr, size);
> +	return false;
> +}
> +

The function names (arm64_is_{mmio_private, protected_mmio} are indicators to the
MMIO region's state or property. arm64_is_mmio_private() indicates the MMIO region
is 'private MMIO' while arm64_is_protected_mmio() indicates the MMIO region is
'protected MMIO'. They are equivalent and it may be worthy to unify the function
names (indicators) as below.

   option#1                         option#2
   --------                         --------
   arm64_is_private_mmio            arm64_is_protected_mmio
   __arm64_is_private_mmio          __arm64_is_protected_mmio


>   #endif	/* __ASM_IO_H */
> diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
> index acba065eb00e..42ff93c7b0ba 100644
> --- a/arch/arm64/include/asm/rsi.h
> +++ b/arch/arm64/include/asm/rsi.h
> @@ -14,6 +14,8 @@ DECLARE_STATIC_KEY_FALSE(rsi_present);
>   
>   void __init arm64_rsi_init(void);
>   
> +bool arm64_is_protected_mmio(phys_addr_t base, size_t size);
> +
>   static inline bool is_realm_world(void)
>   {
>   	return static_branch_unlikely(&rsi_present);
> diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
> index b661331c9204..fdb47f690307 100644
> --- a/arch/arm64/include/asm/rsi_cmds.h
> +++ b/arch/arm64/include/asm/rsi_cmds.h
> @@ -45,6 +45,27 @@ static inline unsigned long rsi_get_realm_config(struct realm_config *cfg)
>   	return res.a0;
>   }
>   
> +static inline unsigned long rsi_ipa_state_get(phys_addr_t start,
> +					      phys_addr_t end,
> +					      enum ripas *state,
> +					      phys_addr_t *top)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_smc(SMC_RSI_IPA_STATE_GET,
> +		      start, end, 0, 0, 0, 0, 0,
> +		      &res);
> +
> +	if (res.a0 == RSI_SUCCESS) {
> +		if (top)
> +			*top = res.a1;
> +		if (state)
> +			*state = res.a2;
> +	}
> +
> +	return res.a0;
> +}
> +
>   static inline unsigned long rsi_set_addr_range_state(phys_addr_t start,
>   						     phys_addr_t end,
>   						     enum ripas state,
> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
> index a6495a64d9bb..d7bba4cee627 100644
> --- a/arch/arm64/kernel/rsi.c
> +++ b/arch/arm64/kernel/rsi.c
> @@ -66,6 +66,32 @@ static void __init arm64_rsi_setup_memory(void)
>   	}
>   }
>   
> +bool arm64_is_protected_mmio(phys_addr_t base, size_t size)
> +{
> +	enum ripas ripas;
> +	phys_addr_t end, top;
> +
> +	/* Overflow ? */
> +	if (WARN_ON(base + size <= base))
> +		return false;
> +
> +	end = ALIGN(base + size, RSI_GRANULE_SIZE);
> +	base = ALIGN_DOWN(base, RSI_GRANULE_SIZE);
> +
> +	while (base < end) {
> +		if (WARN_ON(rsi_ipa_state_get(base, end, &ripas, &top)))
> +			break;
> +		if (WARN_ON(top <= base))
> +			break;
> +		if (ripas != RSI_RIPAS_DEV)
> +			break;
> +		base = top;
> +	}
> +
> +	return base >= end;
> +}
> +EXPORT_SYMBOL(arm64_is_protected_mmio);
> +

The function may be worthy to be renamed to __arm64_is_private_mmio, as explained
as above.

>   void __init arm64_rsi_init(void)
>   {
>   	if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_SMC)

Thanks,
Gavin

