Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6CA7249ED
	for <kvmarm@lists.linux.dev>; Tue, 16 Jul 2024 09:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721121048; cv=none; b=MaP8ZVbjGv+sDbRvdkw39bFkiLn5TUEJuTUYuKu0uOlSEB/Zv07yDAOT2Fh6mkwR5UOCl6PtYUoH1yT4C6qsQmUxyDzMWUqkpC+/AjNbxwZpAWiLV647TNinmx8uKbF6e9TjjDGbZnjDbQhVSC20qo0KJYrTm+C36PVzctsAMJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721121048; c=relaxed/simple;
	bh=fIMLR418ezoVN2qVa3zhAxHvTg2UX0nt2THp6JU0cVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OkuIDSFuc13ydlbvrMLWRReCpodjOAmYEp87WqNdiRmmjXOZB2BWQzU0YhbVcC4ik9XsSALR5U4FiFviv0wIr922G0HdCoNFStde3qPY66tT3KIk1qVAqjvubwYzl6zEtvjrPu0D+IUdU0FuWY0K1QqUfkZOQgrRlirgNO1imRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B54F1063;
	Tue, 16 Jul 2024 02:11:10 -0700 (PDT)
Received: from [10.163.52.225] (unknown [10.163.52.225])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 675003F762;
	Tue, 16 Jul 2024 02:10:34 -0700 (PDT)
Message-ID: <3b04d3b6-1e78-456b-a377-2c6b2a72e4bd@arm.com>
Date: Tue, 16 Jul 2024 14:40:29 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 14/29] arm64: mask out POIndex when modifying a PTE
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
 <20240503130147.1154804-15-joey.gouly@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20240503130147.1154804-15-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/3/24 18:31, Joey Gouly wrote:
> When a PTE is modified, the POIndex must be masked off so that it can be modified.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/include/asm/pgtable.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index afdd56d26ad7..5c970a9cca67 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1028,7 +1028,8 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
>  	 */
>  	const pteval_t mask = PTE_USER | PTE_PXN | PTE_UXN | PTE_RDONLY |
>  			      PTE_PROT_NONE | PTE_VALID | PTE_WRITE | PTE_GP |
> -			      PTE_ATTRINDX_MASK;
> +			      PTE_ATTRINDX_MASK | PTE_PO_IDX_MASK;
> +
>  	/* preserve the hardware dirty information */
>  	if (pte_hw_dirty(pte))
>  		pte = set_pte_bit(pte, __pgprot(PTE_DIRTY));
