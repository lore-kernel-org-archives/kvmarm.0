Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6923D1917C7
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 13:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728480731; cv=none; b=ocdDwDG4m8QIrsu5ReS8Pl8HiiLyfXaCmuZAJgEXE2arUoZfT0q90ycJwdlSkUmfvISVhUW2pM3CVLRKd5EOu3695rKYYtNRY3+6NgyFlIgHe79F/CKwTcaPWZlKc1A1VDO/eHCB/WyD3/KPbQ/1VgP1A1xfFlKXVTOeZ91PTcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728480731; c=relaxed/simple;
	bh=B/c27+MLFSfQ0SDvLKo7evuSk33cUyxxuoqi7orjZhc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KCxSe8gwWx/1QZImMB7EmSDnZ835Lpv6wsqpMr7En3e8WhhNptkFcxs60UzQVIfmx6c2a6YZ5obf0UVFNUsEfZC5KU9R+vWJz7KmslO0tvCFuFd4os9Wo0RrBvjyTryoVpsOBHZR2fVhS8GJ8PCA6RIrPtca3BmdktExCLI9k0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8165BFEC;
	Wed,  9 Oct 2024 06:32:37 -0700 (PDT)
Received: from [10.57.85.216] (unknown [10.57.85.216])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 761253F58B;
	Wed,  9 Oct 2024 06:32:06 -0700 (PDT)
Message-ID: <0ef88192-2523-418f-8ab7-442766a1c444@arm.com>
Date: Wed, 9 Oct 2024 14:32:05 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] arm64/mm: Drop PXD_TABLE_BIT
Content-Language: en-GB
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20241005123824.1366397-1-anshuman.khandual@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20241005123824.1366397-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/10/2024 13:38, Anshuman Khandual wrote:
> Clearing PXD_TABLE_BIT i.e bit[1] on a page table entry always operates on
> the assumption that subsequent PXD_VALID i.e bit[0] is set. That's because
> bits[1:0]="01" makes a block mapping. So it is prudent to treat bits[1:0]
> as a single register field, which should be updated as block or table etc.
> Although mk_[pmd|pud]_sect_prot() helpers go to some extent in using these
> PXD_TYPE_SECT macros, their usage is not really consistent else where.
> 
> This series removes these table bit clearing for block mapping creation and
> eventually completely drops off those table macros.

Given the issue I just noticed in patch 2, I'm not sure if it's going to be
practical to remove the table bit after all? Sorry I didn't spot this before.

> 
> This series applies on v6.12-rc1.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: James Morse <james.morse@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: kvmarm@lists.linux.dev
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> 
> Anshuman Khandual (5):
>   arm64/mm: Drop pte_mkhuge()
>   arm64/mm: Replace PXD_TABLE_BIT with PXD_TYPE_[MASK|SECT]
>   arm64/ptdump: Test PMD_TYPE_MASK for block mapping
>   KVM: arm64: ptdump: Test PMD_TYPE_MASK for block mapping
>   arm64/mm: Drop PXD_TABLE_BIT
> 
>  arch/arm64/include/asm/pgtable-hwdef.h |  6 +-----
>  arch/arm64/include/asm/pgtable.h       | 20 ++++++++------------
>  arch/arm64/kvm/ptdump.c                |  4 ++--
>  arch/arm64/mm/hugetlbpage.c            |  2 +-
>  arch/arm64/mm/ptdump.c                 |  8 ++++----
>  5 files changed, 16 insertions(+), 24 deletions(-)
> 

