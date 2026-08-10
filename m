Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79BB943B3EE
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 19:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786388470; cv=none; b=sxQBiRQ+Nibf1E+7jaoMXgXInfvddk3WcxlLTb25tUJVGNi/Vn76NKpfIQy9yJYMtwcdrB4QYh2IiZciTi6Z+1Or2igiHFZ6ojbA3mMpozGhu+qRY1P96O9LKmveX/aH4VsQwNHjcVBf9pK0iUnvF25DsyZW6xk5v1D4ZXMmYQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786388470; c=relaxed/simple;
	bh=Zvr1Mqog1F5FXR6W2+Z0D6uIY2t2ZIe0qqSdBJHutBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a1D//C0eZowD0GEoWnNA62MhBBU2WqerNGekB+McPTAmTytvxvFksZwChKGGT60Y5hKQC5HFpAIOZaoiZS51w/COxLEMSHDZT+giPaighTvJsT3xsIFtBzMshWWj6mXn/vF95D1j88DetQqWwvvwsnhVKV7KYOWXRgdIgyeDui0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QuqdIL3f; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QuqdIL3f"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C497D14BF;
	Mon, 10 Aug 2026 12:00:41 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E80D3F86F;
	Mon, 10 Aug 2026 12:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786388445; bh=Zvr1Mqog1F5FXR6W2+Z0D6uIY2t2ZIe0qqSdBJHutBY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QuqdIL3fFzRCVJpany3mDGkCPNxFE9bjUbslJw71VMebIeIPlvyKOyOjGJs5l/bc8
	 53QlJb78gEg2656/jlYbHBwvCmbE5RLInl1Uh+3eSV9kqmplq5Rchqe+VYiVzYuOnG
	 pr2n/l5RFSEFUcLQq2sdmy4CBMjpVhnvzC9Hlk+8=
Date: Mon, 10 Aug 2026 20:00:36 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <fuad.tabba@linux.dev>, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Correctly cap TLBI Range to the architural
 limit
Message-ID: <ulkkvfcbwgv5nu5yo4wfpcjglhety4pzgoujmvnspfbklf4p3m@7bggrzdjxibg>
References: <20260810170616.746100-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810170616.746100-1-maz@kernel.org>

On Mon, Aug 10, 2026 at 06:06:16PM +0100, Marc Zyngier wrote:
> TLB Invalidation by Range has a fairly powerful way of encoding pretty
> large ranges in a small number of bits. This range can be based on an
> arbitrary VA, which means it is pretty easy for a guest to generate an
> overflow should the hypervisor be naive enough to add the range to the
> base...
> 
> Make sure the range is capped to the limit dictated by the address bit
> that determines the VA range. For an IPA invalidation, this is further
> corrected down the line to ignore the upper range.
> 
> Fixes: 4ffa72ad8f37e ("KVM: arm64: nv: Add S1 TLB invalidation primitive for VNCR_EL2")
> Reported-by: Wei-Lin Chang <weilin.chang@arm.com>
> Link: https://lore.kernel.org/r/yifz3wn5gk5sr6mapi32trgk5m5kp33bquctsjmkifebnsnndt@fix6u4rthx4g
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/include/asm/kvm_nested.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index c83be6d0e79ac..1ed7083358096 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -305,6 +305,12 @@ static inline u64 decode_range_tlbi(u64 val, u64 *range, u16 *asid)
>  	num	= FIELD_GET(GENMASK(43, 39), val);
>  	*range	= __TLBI_RANGE_PAGES(num, scale) << shift;
>  
> +	/* Cap the range to the correct half of the address space */
> +	if (!(base & BIT(48)))
> +		*range = min(*range, (BIT(48) - base));
> +	else
> +		*range = min(*range, ~base + 1);
> +
>  	return base;
>  }

Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>

>  
> -- 
> 2.47.3
> 
