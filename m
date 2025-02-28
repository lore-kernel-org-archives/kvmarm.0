Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29C5F191F72
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 03:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740714174; cv=none; b=nhgLHw/Xz2AKe8xeS2cfOYCJrQvs8vf3QU0sCavQRemjk1YNQob4iMrHyJ4k+qJkzxRyB9EV/qCbZYJI47JZHYpDGKpieACyWIk5fx3yp1pt12ZxFvMEnybINWnaRuhvw6zttupDVUntkmcd99HB9ko2gcM1ppDrh8eA7t+F7hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740714174; c=relaxed/simple;
	bh=TCBAffphN5Vd25xw6/XwG6SOhGD9Ey9T0bjna/8WfEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oz73Pk6VBCL8DkkyjYCua+Y1NNlrABczGHZp62I3pJp4mWFNPMxPm8ci5618t+g/ww/ZqlFGZEhrvQgjwVdOjzvzPkbn5S1tpxv0MdJHFzmDm4/ly7T/M3tlx0rurrQiE26SzJpKKuU3Z8jmwy86Bu13kAiOj00JScbOjKWo53Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8747A12FC;
	Thu, 27 Feb 2025 19:43:06 -0800 (PST)
Received: from [10.163.40.184] (unknown [10.163.40.184])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B6F033F6A8;
	Thu, 27 Feb 2025 19:42:45 -0800 (PST)
Message-ID: <ccbe751d-9022-4c66-b894-73b3788f7050@arm.com>
Date: Fri, 28 Feb 2025 09:12:38 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/8] arm64/mm: Drop PXD_TABLE_BIT
To: arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250221044227.1145393-1-anshuman.khandual@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250221044227.1145393-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/21/25 10:12, Anshuman Khandual wrote:
> Remove the PXX_TABLE_BIT definitions and instead rely on PXX_TYPE_MASK,
> PXX_TYPE_SECT and PXX_TYPE_TABLE. The latter versions are more abstract
> and also include the PTE_VALID bit.
> 
> This abstraction is valuable for the impending D128 page table support,
> which doesn't have a single page table bit to determine table vs block.
> Instead it has the skip level (SKL) field, where it will consider 0 to
> mean table and any other value to mean a block entry. So PXX_TABLE_BIT
> therefore doesn't fit into the D128 model well, but the type fields do.
> 
> This series applies on v6.14-rc3.
> 
> Changes in V2:
> 
> - Changed pmd_mkhuge() and pud_mkhuge() implementation
> - Changed pud_bad() implementation with an additional patch
> 
> Changes in V1:
> 
> https://lore.kernel.org/all/20241005123824.1366397-1-anshuman.khandual@arm.com/
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
> Anshuman Khandual (6):
>   KVM: arm64: ptdump: Test PMD_TYPE_MASK for block mapping
>   arm64/ptdump: Test PMD_TYPE_MASK for block mapping
>   arm64/mm: Clear PXX_TYPE_MASK in mk_[pmd|pud]_sect_prot()
>   arm64/mm: Clear PXX_TYPE_MASK and set PXD_TYPE_SECT in [pmd|pud]_mkhuge()
>   arm64/mm: Check PXD_TYPE_TABLE in [p4d|pgd]_bad()
>   arm64/mm: Drop PXD_TABLE_BIT
> 
> Ryan Roberts (2):
>   arm64/mm: Check PUD_TYPE_TABLE in pud_bad()
>   arm64/mm: Check pmd_table() in pmd_trans_huge()
> 
>  arch/arm64/include/asm/pgtable-hwdef.h |  5 --
>  arch/arm64/include/asm/pgtable.h       | 65 ++++++++++++++++++--------
>  arch/arm64/kvm/ptdump.c                |  4 +-
>  arch/arm64/mm/ptdump.c                 |  4 +-
>  4 files changed, 50 insertions(+), 28 deletions(-)
> 

Gentle ping, just wondering any updates on the series.
