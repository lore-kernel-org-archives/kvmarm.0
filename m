Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D19571BDD3
	for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 06:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716879327; cv=none; b=MqinKHeu/I2VkvBM7jHucAuHYsSdUEejxaQCezdJocTASC91DyZ+18OFFqAISbzu53I701QDw37YKW4YZ/MGxYC0uBiqMD188L8pvj8m/DS/aXTNIg1yvlOYCbYS/L0WOJTzO6xCH2HaAI4D3AEkSMeGVlKDXHhKx/g2l4nZ/RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716879327; c=relaxed/simple;
	bh=BF2nYbG8XK7M/dOe/WkvEWY8Wc4GRw1KBhYDuTM/0Ns=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=h5BlxuV1eFWTFhP5C1r3zUCZJs7TaqJ8Bo8mbj+yqk1KxGrzi9c1kJJ7UnGqN1yT3HDxTq1g8YRHDZQtL2Lpran75rroMwqY8e5XrTrEvApewDDg+gidmDXQHYEwqrMb+ipcYq4yhJCbm3zrE72LVb6M9xG0oMIGuEhQp9Gn3RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88109339;
	Mon, 27 May 2024 23:55:43 -0700 (PDT)
Received: from [10.162.40.16] (a077841.arm.com [10.162.40.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 77D173F792;
	Mon, 27 May 2024 23:55:11 -0700 (PDT)
Message-ID: <4f7d8691-fe19-4e8a-95e5-9f7680c82021@arm.com>
Date: Tue, 28 May 2024 12:24:57 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Amit Daniel Kachhap <amitdaniel.kachhap@arm.com>
Subject: Re: [PATCH v4 13/29] arm64: convert protection key into vm_flags and
 pgprot values
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, aneesh.kumar@kernel.org,
 aneesh.kumar@linux.ibm.com, bp@alien8.de, broonie@kernel.org,
 catalin.marinas@arm.com, christophe.leroy@csgroup.eu,
 dave.hansen@linux.intel.com, hpa@zytor.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, maz@kernel.org,
 mingo@redhat.com, mpe@ellerman.id.au, naveen.n.rao@linux.ibm.com,
 npiggin@gmail.com, oliver.upton@linux.dev, shuah@kernel.org,
 szabolcs.nagy@arm.com, tglx@linutronix.de, will@kernel.org, x86@kernel.org,
 kvmarm@lists.linux.dev
References: <20240503130147.1154804-1-joey.gouly@arm.com>
 <20240503130147.1154804-14-joey.gouly@arm.com>
Content-Language: en-US
In-Reply-To: <20240503130147.1154804-14-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/3/24 18:31, Joey Gouly wrote:
> Modify arch_calc_vm_prot_bits() and vm_get_page_prot() such that the pkey
> value is set in the vm_flags and then into the pgprot value.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/include/asm/mman.h | 8 +++++++-
>   arch/arm64/mm/mmap.c          | 9 +++++++++
>   2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/mman.h b/arch/arm64/include/asm/mman.h
> index 5966ee4a6154..ecb2d18dc4d7 100644
> --- a/arch/arm64/include/asm/mman.h
> +++ b/arch/arm64/include/asm/mman.h
> @@ -7,7 +7,7 @@
>   #include <uapi/asm/mman.h>
>   
>   static inline unsigned long arch_calc_vm_prot_bits(unsigned long prot,
> -	unsigned long pkey __always_unused)
> +	unsigned long pkey)
>   {
>   	unsigned long ret = 0;
>   
> @@ -17,6 +17,12 @@ static inline unsigned long arch_calc_vm_prot_bits(unsigned long prot,
>   	if (system_supports_mte() && (prot & PROT_MTE))
>   		ret |= VM_MTE;
>   
> +#if defined(CONFIG_ARCH_HAS_PKEYS)

Should there be system_supports_poe() check like above?

Thanks,
Amit

> +	ret |= pkey & 0x1 ? VM_PKEY_BIT0 : 0;
> +	ret |= pkey & 0x2 ? VM_PKEY_BIT1 : 0;
> +	ret |= pkey & 0x4 ? VM_PKEY_BIT2 : 0;
> +#endif
> +
>   	return ret;
>   }
>   #define arch_calc_vm_prot_bits(prot, pkey) arch_calc_vm_prot_bits(prot, pkey)
> diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
> index 642bdf908b22..86eda6bc7893 100644
> --- a/arch/arm64/mm/mmap.c
> +++ b/arch/arm64/mm/mmap.c
> @@ -102,6 +102,15 @@ pgprot_t vm_get_page_prot(unsigned long vm_flags)
>   	if (vm_flags & VM_MTE)
>   		prot |= PTE_ATTRINDX(MT_NORMAL_TAGGED);
>   
> +#ifdef CONFIG_ARCH_HAS_PKEYS
> +	if (vm_flags & VM_PKEY_BIT0)
> +		prot |= PTE_PO_IDX_0;
> +	if (vm_flags & VM_PKEY_BIT1)
> +		prot |= PTE_PO_IDX_1;
> +	if (vm_flags & VM_PKEY_BIT2)
> +		prot |= PTE_PO_IDX_2;
> +#endif
> +
>   	return __pgprot(prot);
>   }
>   EXPORT_SYMBOL(vm_get_page_prot);
