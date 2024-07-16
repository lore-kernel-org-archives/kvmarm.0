Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51797195807
	for <kvmarm@lists.linux.dev>; Tue, 16 Jul 2024 09:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721120768; cv=none; b=SpCtogGkNaJfOsrzuhJ7ogt8S1V53AvFBTFvgQBfuAl/7O6yct76vgJu1RgIli1mSNyDlRXi3IDbC1vX1G4lM9YWkXR0rZrZUGjJSfBUVVdaJMkQw01utGb8wpA8mJlFcFZfT+pOiNRZUeJ/fU+LHXVPSgy0vBzTSdGYqic0cUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721120768; c=relaxed/simple;
	bh=kTI7OVggn/DxLA154r6xjqaIttidFEsR9apvEW4qpxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CHjRO8dLDqy9yvgc6oRQOxTlZOZ8NHIonyqOli7tirKjYtOVNpFvbWSNrBh9z6kgqnnL4IRA3wD6ZIgYW/EPH46EJwzH9KmzUSodlFmY14pn5UcfLtqcFASydWWsw2d2OnGjoBA1E+VP1mYJXdOECjI+wqCpMWaZMxOoUI8kKGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA2511063;
	Tue, 16 Jul 2024 02:06:30 -0700 (PDT)
Received: from [10.163.52.225] (unknown [10.163.52.225])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 83B843F762;
	Tue, 16 Jul 2024 02:05:53 -0700 (PDT)
Message-ID: <0f87e51e-f790-4302-896f-9b9a74ed7495@arm.com>
Date: Tue, 16 Jul 2024 14:35:48 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
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
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20240503130147.1154804-14-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/3/24 18:31, Joey Gouly wrote:
> Modify arch_calc_vm_prot_bits() and vm_get_page_prot() such that the pkey
> value is set in the vm_flags and then into the pgprot value.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/mman.h | 8 +++++++-
>  arch/arm64/mm/mmap.c          | 9 +++++++++
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/mman.h b/arch/arm64/include/asm/mman.h
> index 5966ee4a6154..ecb2d18dc4d7 100644
> --- a/arch/arm64/include/asm/mman.h
> +++ b/arch/arm64/include/asm/mman.h
> @@ -7,7 +7,7 @@
>  #include <uapi/asm/mman.h>
>  
>  static inline unsigned long arch_calc_vm_prot_bits(unsigned long prot,
> -	unsigned long pkey __always_unused)
> +	unsigned long pkey)
>  {
>  	unsigned long ret = 0;
>  
> @@ -17,6 +17,12 @@ static inline unsigned long arch_calc_vm_prot_bits(unsigned long prot,
>  	if (system_supports_mte() && (prot & PROT_MTE))
>  		ret |= VM_MTE;
>  
> +#if defined(CONFIG_ARCH_HAS_PKEYS)
> +	ret |= pkey & 0x1 ? VM_PKEY_BIT0 : 0;
> +	ret |= pkey & 0x2 ? VM_PKEY_BIT1 : 0;
> +	ret |= pkey & 0x4 ? VM_PKEY_BIT2 : 0;

0x1, 0x2, 0x4 here are standard bit positions for their corresponding
VM_KEY_XXX based protection values ? Although this is similar to what
x86 is doing currently, hence just trying to understand if these bit
positions here are related to the user visible ABI, which should be
standardized ?

Agree with previous comments about the need for system_supports_poe()
based additional check for the above code block.

> +#endif
> +
>  	return ret;
>  }
>  #define arch_calc_vm_prot_bits(prot, pkey) arch_calc_vm_prot_bits(prot, pkey)
> diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
> index 642bdf908b22..86eda6bc7893 100644
> --- a/arch/arm64/mm/mmap.c
> +++ b/arch/arm64/mm/mmap.c
> @@ -102,6 +102,15 @@ pgprot_t vm_get_page_prot(unsigned long vm_flags)
>  	if (vm_flags & VM_MTE)
>  		prot |= PTE_ATTRINDX(MT_NORMAL_TAGGED);
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
>  	return __pgprot(prot);
>  }
>  EXPORT_SYMBOL(vm_get_page_prot);
