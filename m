Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1381186E51
	for <kvmarm@lists.linux.dev>; Mon, 15 Jul 2024 09:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721035328; cv=none; b=HOobFGYg8FYM/G7B2t7WFA4l0SmpICu2PnTCseZL9otj6FCybOx8S9Qffy7BsfKYsXBq2lVJHch8kbOPtlQxnLNkfKFZXs73niDZpfxtcuXEGATOCyXuaCbB1lYaV/kNOoFXAcfC3sv9eNLlkbI88LPl33yYHFphjdMvasCm4B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721035328; c=relaxed/simple;
	bh=9i3Vi6g/p2Zw7XipkMFMxQUKLgYefX20zTZNai4EXMo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fHmy+A4yf8CHftTpsYva1inDJHILJbGbznoP7CqSKA26Jb5Z1Ipjc/mUw7KgC1YXbYRF4Q410ar2uO2+bf1D9aJeh/6Pnk/29jSPUt+Bn+sBL8+TQXBnvYLzIUHTD1ol8vkjlUzoBAgDKX5mBRJOYp/oHP12ShN2V1SAQJ6qV10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E38B7DA7;
	Mon, 15 Jul 2024 02:22:30 -0700 (PDT)
Received: from [10.162.40.16] (a077893.blr.arm.com [10.162.40.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 89DCE3F73F;
	Mon, 15 Jul 2024 02:21:57 -0700 (PDT)
Message-ID: <388128db-1ddc-453f-9154-df2c5e255a2d@arm.com>
Date: Mon, 15 Jul 2024 14:51:54 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/29] arm64: re-order MTE VM_ flags
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
 <20240503130147.1154804-12-joey.gouly@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20240503130147.1154804-12-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/3/24 18:31, Joey Gouly wrote:
> To make it easier to share the generic PKEYs flags, move the MTE flag.

The change looks good but too less details about it here. Please do consider
adding some more description, on how moving the VM flags down the arch range
helps going forward.

> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> ---
>  include/linux/mm.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 5605b938acce..2065727b3787 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -377,8 +377,8 @@ extern unsigned int kobjsize(const void *objp);
>  #endif
>  
>  #if defined(CONFIG_ARM64_MTE)
> -# define VM_MTE		VM_HIGH_ARCH_0	/* Use Tagged memory for access control */
> -# define VM_MTE_ALLOWED	VM_HIGH_ARCH_1	/* Tagged memory permitted */
> +# define VM_MTE		VM_HIGH_ARCH_4	/* Use Tagged memory for access control */
> +# define VM_MTE_ALLOWED	VM_HIGH_ARCH_5	/* Tagged memory permitted */
>  #else
>  # define VM_MTE		VM_NONE
>  # define VM_MTE_ALLOWED	VM_NONE
