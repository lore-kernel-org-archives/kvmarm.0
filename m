Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AB0617E019
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 13:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728480624; cv=none; b=WtohR3TQm52sJRjA/nnG+RIONaUE1cthYBpM3kyYczoW0lu3zTdqaNeiVoowfSQU1XDYqrQ39+fRn5umlnYmts0+3SXYWCSAtQ4xN4pitQlNjLCZEYt4eRG9YNOftdCslMVz6xSv1Xu06bYZ7yslYU7IamzBWwXXbCim+hFB3eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728480624; c=relaxed/simple;
	bh=QpJ/8EwRppC1UU+NnWIBUk/jF5UeSHguB4Zl+ucY5sw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GQIczXsAWVoXEXwa6lDJwXbSgVfe93Gx6pwsvogglPeMUqMKWz4x5rgJZCwWifHsOl8GUvC4erPVBYb9YXKmwICqaMJ/ISCLtDXIz4Rp2t4qLn4qK/un1Gq97Zasa8NtfYz+NWaODJmqc/PpWCfU2kDMcW32OAK6Xj4XrENnxac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2FEC1FEC;
	Wed,  9 Oct 2024 06:30:52 -0700 (PDT)
Received: from [10.57.85.216] (unknown [10.57.85.216])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7BD383F58B;
	Wed,  9 Oct 2024 06:30:20 -0700 (PDT)
Message-ID: <ade5437e-39db-4e95-9d32-b51a16bfc9ef@arm.com>
Date: Wed, 9 Oct 2024 14:30:18 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] KVM: arm64: ptdump: Test PMD_TYPE_MASK for block
 mapping
Content-Language: en-GB
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20241005123824.1366397-1-anshuman.khandual@arm.com>
 <20241005123824.1366397-5-anshuman.khandual@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20241005123824.1366397-5-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/10/2024 13:38, Anshuman Khandual wrote:
> This changes stage-2 ptdump making it test given page table entries against
> PMD_TYPE_SECT on PMD_TYPE_MASK bits for a block mapping, as is the case for
> stage-1 ptdump.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: James Morse <james.morse@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.linux.dev
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  arch/arm64/kvm/ptdump.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index e4a342e903e2..098416d7e5c2 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -52,8 +52,8 @@ static const struct ptdump_prot_bits stage2_pte_bits[] = {
>  		.set	= "AF",
>  		.clear	= "  ",
>  	}, {
> -		.mask	= PTE_TABLE_BIT | PTE_VALID,
> -		.val	= PTE_VALID,
> +		.mask	= PMD_TYPE_MASK,
> +		.val	= PMD_TYPE_SECT,
>  		.set	= "BLK",
>  		.clear	= "   ",
>  	},

