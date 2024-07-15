Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D14C6AB8
	for <kvmarm@lists.linux.dev>; Mon, 15 Jul 2024 07:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721029664; cv=none; b=rXCfOhv00zA5TM8pFbpiCxPs3fEvc+ruUlVsE+BoGbkL61qFFSXZeifKYnAyeJE/kgoNRtWPeKMlYVHTiRR8DfF8y7K5D2scKArPowzbwoC0cljqJBMcwYv92aD4vOmnCxqwK9aP6egZDyh0EJo8w5LU5E22p4E/Dq5MuPoMqDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721029664; c=relaxed/simple;
	bh=I7seYVLChLDzy2ZoSFjTipjvojF80Bb/RljZUanzmDc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=YsUgByKmX5X5AA/zGMcsys2Q3/FIsDItlBJWZpOmIvDDkrb4kvpZWrcuA2fbL3eutiSJoPXm7Tl9W9WLn1CjztYeV9cD9pj0SQM3ozixeCfLgPW6dmsPZT2/71r/kxCYB/5ORSkjPjkkQ5PJucn4zhTd3ovqmsrbYDJwEDA0V88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 806EADA7;
	Mon, 15 Jul 2024 00:48:07 -0700 (PDT)
Received: from [10.162.40.16] (a077893.blr.arm.com [10.162.40.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E88C73F762;
	Mon, 15 Jul 2024 00:47:33 -0700 (PDT)
Message-ID: <763279ea-7885-444c-9ca0-7a2cf7c7016d@arm.com>
Date: Mon, 15 Jul 2024 13:17:30 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH v4 04/29] arm64: disable trapping of POR_EL0 to EL2
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
 <20240503130147.1154804-5-joey.gouly@arm.com>
Content-Language: en-US
In-Reply-To: <20240503130147.1154804-5-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/3/24 18:31, Joey Gouly wrote:
> Allow EL0 or EL1 to access POR_EL0 without being trapped to EL2.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/include/asm/el2_setup.h | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index b7afaa026842..df5614be4b70 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -184,12 +184,20 @@
>  .Lset_pie_fgt_\@:
>  	mrs_s	x1, SYS_ID_AA64MMFR3_EL1
>  	ubfx	x1, x1, #ID_AA64MMFR3_EL1_S1PIE_SHIFT, #4
> -	cbz	x1, .Lset_fgt_\@
> +	cbz	x1, .Lset_poe_fgt_\@
>  
>  	/* Disable trapping of PIR_EL1 / PIRE0_EL1 */
>  	orr	x0, x0, #HFGxTR_EL2_nPIR_EL1
>  	orr	x0, x0, #HFGxTR_EL2_nPIRE0_EL1
>  
> +.Lset_poe_fgt_\@:
> +	mrs_s	x1, SYS_ID_AA64MMFR3_EL1
> +	ubfx	x1, x1, #ID_AA64MMFR3_EL1_S1POE_SHIFT, #4
> +	cbz	x1, .Lset_fgt_\@
> +
> +	/* Disable trapping of POR_EL0 */
> +	orr	x0, x0, #HFGxTR_EL2_nPOR_EL0
> +
>  .Lset_fgt_\@:
>  	msr_s	SYS_HFGRTR_EL2, x0
>  	msr_s	SYS_HFGWTR_EL2, x0

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
