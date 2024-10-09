Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6903F1946C8
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 13:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728480592; cv=none; b=Prmm1FRa6m0XmU06akjZO0b4QdtOs3nd6fyZLUDYyjBXil21WsmArDBJ9RJe/czbTFKvZngnbRRx/6lsUYb+5xoo4Nl/zcrOTa2f9g9WBL9wNv74AgT3gCmFfjj62oCNj/0ymRA3pzhaQf13K/SsbJQTb93sgQCO5fGlxNuQFeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728480592; c=relaxed/simple;
	bh=MOH0aLrszP/7+AYlkDVCm5CN76bwWTO+1ItQcDjDNcs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DIjVKdNh2ko84kWYTf2we1xEEgyJnOTYiWXbRPkq/MkH7dUBJFThtx5ru6KYzT1e5sAsitKlt6MZ+79JuFsT9E9Jx6tS8uzuG778QISv4B+k4CrHKv+Q8DsQic1pBGIxKf34uXx2xtVIT1uAyuG1aJdczFt8ssW1icAxeHco0Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8EED2FEC;
	Wed,  9 Oct 2024 06:30:19 -0700 (PDT)
Received: from [10.57.85.216] (unknown [10.57.85.216])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3D94E3F58B;
	Wed,  9 Oct 2024 06:29:48 -0700 (PDT)
Message-ID: <db908eb5-fa01-400a-a6c1-36a5ebddb47c@arm.com>
Date: Wed, 9 Oct 2024 14:29:46 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] arm64/ptdump: Test PMD_TYPE_MASK for block mapping
Content-Language: en-GB
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20241005123824.1366397-1-anshuman.khandual@arm.com>
 <20241005123824.1366397-4-anshuman.khandual@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20241005123824.1366397-4-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/10/2024 13:38, Anshuman Khandual wrote:
> arm64 block mapping requires given page table entry's bits[1:0] to be "01".
> But now only bit[1] is checked to be clear, while also implicitly assuming
> bit[0] to be set. This modifies ptdump to check both the relevant bits via
> the mask PMD_TYPE_MASK and check the resultant value against PMD_TYPE_MASK.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  arch/arm64/mm/ptdump.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
> index 264c5f9b97d8..8cec0da4cff2 100644
> --- a/arch/arm64/mm/ptdump.c
> +++ b/arch/arm64/mm/ptdump.c
> @@ -80,10 +80,10 @@ static const struct ptdump_prot_bits pte_bits[] = {
>  		.set	= "CON",
>  		.clear	= "   ",
>  	}, {
> -		.mask	= PTE_TABLE_BIT,
> -		.val	= PTE_TABLE_BIT,
> -		.set	= "   ",
> -		.clear	= "BLK",
> +		.mask	= PMD_TYPE_MASK,
> +		.val	= PMD_TYPE_SECT,
> +		.set	= "BLK",
> +		.clear	= "   ",
>  	}, {
>  		.mask	= PTE_UXN,
>  		.val	= PTE_UXN,

