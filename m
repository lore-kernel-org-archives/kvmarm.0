Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 525C642070
	for <kvmarm@lists.linux.dev>; Tue, 16 Jul 2024 10:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721126850; cv=none; b=oaapLHCIEpfrZdKYaGNPeWkBQInOzlbxsqYJPS2+kUpP7W3ji5DK0zBZ4+8qX40dkwvuNGex2iCyDvur1vy/bQhTDe+J5NZ5B7+AjlBEXLmkc/wM9dlEIcoATr9QGK24SGJlZ9Tsdy2DyBrBrc1XpgiFXutjaQ26SIgCRTiBiF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721126850; c=relaxed/simple;
	bh=n3jgr9EnkoEFh/U3ujM8CKrwjfyaY2gWSIv+YBgf62I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GNKYRUhP7wnHrfaWWljFOAL2TfT7VRIKt9a6rz8Fu5gT3FCNlzogBIf0lYswKscuP3GewR+FwmLfo1c+ZeT/h1aJI6Ze0fKXqlRwM1ucpuRjMYh1u+YtKcYWfijNYZ+lwNc/YXMnC4EIYR32Cov59PBOqrM8KS8LP45zKTGt2MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E3E6B1063;
	Tue, 16 Jul 2024 03:47:51 -0700 (PDT)
Received: from [10.163.52.225] (unknown [10.163.52.225])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9F1E83F762;
	Tue, 16 Jul 2024 03:47:16 -0700 (PDT)
Message-ID: <fe3ccf1e-4c57-4795-add3-1eb47f3bdcaa@arm.com>
Date: Tue, 16 Jul 2024 16:17:12 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 19/29] arm64: enable PKEY support for CPUs with S1POE
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
 <20240503130147.1154804-20-joey.gouly@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20240503130147.1154804-20-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/3/24 18:31, Joey Gouly wrote:
> Now that PKEYs support has been implemented, enable it for CPUs that
> support S1POE.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/include/asm/pkeys.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/pkeys.h b/arch/arm64/include/asm/pkeys.h
> index a284508a4d02..3ea928ec94c0 100644
> --- a/arch/arm64/include/asm/pkeys.h
> +++ b/arch/arm64/include/asm/pkeys.h
> @@ -17,7 +17,7 @@ int arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
>  
>  static inline bool arch_pkeys_enabled(void)
>  {
> -	return false;
> +	return system_supports_poe();
>  }
>  
>  static inline int vma_pkey(struct vm_area_struct *vma)

Small nit. Would it better to be consistently using system_supports_poe()
helper rather than arch_pkeys_enabled() inside arch/arm64/ platform code
like - during POE fault handling i.e inside fault_from_pkey().
