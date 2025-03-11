Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B782925C6FF;
	Tue, 11 Mar 2025 18:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741716635; cv=none; b=c57IfkVFHKQrY+LWvZizdA1EAqgCoA4vLa3K4tjRhMO8DhVOkDKo80VpmTz9JrQXTdvIgDaxrzXmE7P+kC7GS9GIiu4h4gjgPsxQljZIwm1gWrKyiUnwrASZOGQqIcnEG0caH/Ez4fKX69st9e8OSC6iOS1uhs9JhftVC0DYlzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741716635; c=relaxed/simple;
	bh=D6hN+Qkvta6a2s58a8zh/7uUSxWvPtoQAir/dtSg3TY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A4alsh0I06OWnUZyECvxVSA9s9uxKyN+xp6d49AKE1Zq9sd2hooeJybfSAZmVLn3JAkonYjSjSMJQup1cu/zGxBjJWlmHjsfncgmCsNzGEb1yV5ifeEujNFelMOQV58USxn3J/uk9cyvcc2EH0Y999HX9ptAs9pYM1qQAzQxi10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF88C4CEE9;
	Tue, 11 Mar 2025 18:10:33 +0000 (UTC)
Date: Tue, 11 Mar 2025 18:10:31 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/8] KVM: arm64: ptdump: Test PMD_TYPE_MASK for block
 mapping
Message-ID: <Z9B8lyYEtL62ZzVb@arm.com>
References: <20250221044227.1145393-1-anshuman.khandual@arm.com>
 <20250221044227.1145393-2-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250221044227.1145393-2-anshuman.khandual@arm.com>

On Fri, Feb 21, 2025 at 10:12:20AM +0530, Anshuman Khandual wrote:
> Test given page table entries against PMD_TYPE_SECT on PMD_TYPE_MASK mask
> bits for identifying block mappings in stage 2 page tables.
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

Marc, Oliver - are you ok with this patch going in through the arm64
tree?

Thanks.

-- 
Catalin
