Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B102C6EB6E
	for <kvmarm@lists.linux.dev>; Wed,  3 Apr 2024 08:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712134261; cv=none; b=S1sxBqHUHu3KHxxVFGg2CNb/HLUsjTxGCrFgISLo+rECS4QFgyUtF09N7doMSfjXcKR6qL/0XjubRGmkIDq4U2YQ6HnL+HW/Eo3X7JpgjrSzjTc8BOb+zGwWkC0FG2Q7QW/kv2Ju/QDJHVzUXbABCqt66M7JKo1h9xbZeLVe1qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712134261; c=relaxed/simple;
	bh=d1gqHPDU7mv+a2/4xNwGyTiXsOBnF5O9Ntsh1cq9LVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WrJa/GwUELFYASjvlqxEJ8MDAbdcUttUYU7ru9k5RsXx9HReIjQH2vWjJAlzUr6j+/SxOHixHcWQFeho5TjknWVNEiwO35l4GJabAC17uqxqATI+oE8eG7ro7ADHaBo0/IZsyB6WATwPH3OzOiQ5ZfLsQ8rqcNF0Fuw/dRR//MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C71E1007;
	Wed,  3 Apr 2024 01:51:30 -0700 (PDT)
Received: from [172.20.10.4] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D0FD23F7B4;
	Wed,  3 Apr 2024 01:50:57 -0700 (PDT)
Message-ID: <9e91a10a-a6a3-401d-a650-18a6893e3c5c@arm.com>
Date: Wed, 3 Apr 2024 09:50:45 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 1/3] arm64: Prepare for LPA2
To: Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com
References: <20240402132739.201939-5-andrew.jones@linux.dev>
 <20240402132739.201939-6-andrew.jones@linux.dev>
Content-Language: en-GB
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240402132739.201939-6-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/04/2024 14:27, Andrew Jones wrote:
> When checking for supported granules also check for the values
> which indicate support when LPA2 is implemented.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

> ---
>   lib/arm64/asm/processor.h | 49 +++++++++++++++++++++------------------
>   1 file changed, 27 insertions(+), 22 deletions(-)
> 
> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> index 1c73ba32725a..bab9c26c2c9e 100644
> --- a/lib/arm64/asm/processor.h
> +++ b/lib/arm64/asm/processor.h
> @@ -110,31 +110,36 @@ static inline unsigned long get_id_aa64mmfr0_el1(void)
>   #define ID_AA64MMFR0_TGRAN64_SHIFT	24
>   #define ID_AA64MMFR0_TGRAN16_SHIFT	20
>   
> -#define ID_AA64MMFR0_TGRAN4_SUPPORTED	0x0
> -#define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
> -#define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
> +#define ID_AA64MMFR0_TGRAN4_SUPPORTED(r)			\
> +({								\
> +	u64 __v = ((r) >> ID_AA64MMFR0_TGRAN4_SHIFT) & 0xf;	\
> +	(__v) == 0 || (__v) == 1;				\
> +})
> +
> +#define ID_AA64MMFR0_TGRAN64_SUPPORTED(r)			\
> +({								\
> +	u64 __v = ((r) >> ID_AA64MMFR0_TGRAN64_SHIFT) & 0xf;	\
> +	(__v) == 0;						\
> +})
> +
> +#define ID_AA64MMFR0_TGRAN16_SUPPORTED(r)			\
> +({								\
> +	u64 __v = ((r) >> ID_AA64MMFR0_TGRAN16_SHIFT) & 0xf;	\
> +	(__v) == 1 || (__v) == 2;				\
> +})
>   
>   static inline bool system_supports_granule(size_t granule)
>   {
> -	u32 shift;
> -	u32 val;
> -	u64 mmfr0;
> -
> -	if (granule == SZ_4K) {
> -		shift = ID_AA64MMFR0_TGRAN4_SHIFT;
> -		val = ID_AA64MMFR0_TGRAN4_SUPPORTED;
> -	} else if (granule == SZ_16K) {
> -		shift = ID_AA64MMFR0_TGRAN16_SHIFT;
> -		val = ID_AA64MMFR0_TGRAN16_SUPPORTED;
> -	} else {
> -		assert(granule == SZ_64K);
> -		shift = ID_AA64MMFR0_TGRAN64_SHIFT;
> -		val = ID_AA64MMFR0_TGRAN64_SUPPORTED;
> -	}
> -
> -	mmfr0 = get_id_aa64mmfr0_el1();
> -
> -	return ((mmfr0 >> shift) & 0xf) == val;
> +	u64 mmfr0 = get_id_aa64mmfr0_el1();
> +
> +	if (granule == SZ_4K)
> +		return ID_AA64MMFR0_TGRAN4_SUPPORTED(mmfr0);
> +
> +	if (granule == SZ_16K)
> +		return ID_AA64MMFR0_TGRAN16_SUPPORTED(mmfr0);
> +
> +	assert(granule == SZ_64K);
> +	return ID_AA64MMFR0_TGRAN64_SUPPORTED(mmfr0);
>   }
>   
>   #endif /* !__ASSEMBLY__ */
