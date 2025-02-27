Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22BB71B4151
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 16:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740675206; cv=none; b=RVmdL8vLE9DkzrKRKFWoUh2JsfymjTZCr5oc0YXLHjUdmscyI5ZkexhHJtMsyxzqtlqJHiGUl+SRePnG1q6WxXAd0AS/6PXm914bEuM1bY+XwozJXKuq4cqtAiD165Wv561Fh2hwT3fEn8prBJGpscIoBJjnvobP1JXBLm5TgX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740675206; c=relaxed/simple;
	bh=sP92n0yPsaHv8z3vFtzWYf7oj36PRK8d/7Oa57GRapI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZL9yFiY1a239SG1AQtK1Okepbo+REW7BFRojNU7xRpA9HX9MTZr5Nby2RMNHjMNh7b7x/pYTdXiCdHuAGcM4hPxsSs+hVcGvfukS7X1F7dsC6rvfMMhlwjBTg2A894phUUKL3Rz4rQHGnqie1i83BYqBDRUpGTvZbJP2UPMSdnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F066A1424;
	Thu, 27 Feb 2025 08:53:38 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 674763F5A1;
	Thu, 27 Feb 2025 08:53:22 -0800 (PST)
Date: Thu, 27 Feb 2025 16:53:15 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, drjones@redhat.com, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v1 1/7] arm64: drop to EL1 if booted at EL2
Message-ID: <Z8CYeyKrFoglWWSp@raptor>
References: <20250220141354.2565567-1-joey.gouly@arm.com>
 <20250220141354.2565567-2-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220141354.2565567-2-joey.gouly@arm.com>

Hi Joey,

On Thu, Feb 20, 2025 at 02:13:48PM +0000, Joey Gouly wrote:
> EL2 is not currently supported, drop to EL1 to conitnue booting.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>  arm/cstart64.S | 27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index b480a552..3a305ad0 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -57,14 +57,25 @@ start:
>  	add     x6, x6, :lo12:reloc_end
>  1:
>  	cmp	x5, x6
> -	b.hs	1f
> +	b.hs	reloc_done
>  	ldr	x7, [x5]			// r_offset
>  	ldr	x8, [x5, #16]			// r_addend
>  	add	x8, x8, x4			// val = base + r_addend
>  	str	x8, [x4, x7]			// base[r_offset] = val
>  	add	x5, x5, #24
>  	b	1b
> -
> +reloc_done:
> +	mrs	x4, CurrentEL
> +	cmp	x4, CurrentEL_EL2
> +	b.ne	1f
> +drop_to_el1:
> +	mov	x4, 4
> +	msr	spsr_el2, x4
> +	adrp	x4, 1f
> +	add	x4, x4, :lo12:1f
> +	msr	elr_el2, x4

I'm going to assume this works because KVM is nice enough to initialise the
EL2 registers that affect execution at EL1 to some sane defaults. Is that
something that can be relied on going forward?

What about UEFI?

I was expecting some kind of initialization of the registers that affect
EL1.

Thanks,
Alex

> +	isb
> +	eret
>  1:
>  	/* zero BSS */
>  	adrp	x4, bss
> @@ -186,6 +197,18 @@ get_mmu_off:
>  
>  .globl secondary_entry
>  secondary_entry:
> +	mrs	x0, CurrentEL
> +	cmp	x0, CurrentEL_EL2
> +	b.ne	1f
> +drop_to_el1_secondary:
> +	mov	x0, 4
> +	msr	spsr_el2, x0
> +	adrp	x0, 1f
> +	add	x0, x0, :lo12:1f
> +	msr	elr_el2, x0
> +	isb
> +	eret
> +1:
>  	/* enable FP/ASIMD and SVE */
>  	mov	x0, #(3 << 20)
>  	orr	x0, x0, #(3 << 16)
> -- 
> 2.25.1
> 
