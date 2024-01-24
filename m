Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 597AE1E503
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 15:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706111862; cv=none; b=m6PcJFCS2YbHorETe1gjETIWcOPdFLY+248YxPY8mEqEGlBvW9oqXrnd+OelM8bOB7H0NcFtwy8VgkZ9Z6AkYpWdhqSDhS5ukYogvaTfrMnLLgfv2RRWIUxKRZS6XJ9G+LY2scISCaaojZcyamFxwKi/ZXn3H80S4rccAghwq8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706111862; c=relaxed/simple;
	bh=Y7gt/16wmpq5YlvJxYH8hK6W5l4A0M6cw8zzfjxsfa4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AGSBJM09U8un5XDCNYOb4j/vcu++SqvwX/YkbYA8VX2NshxcUKePkV/Ny5iECIGXh2ZFirZxeTX230SZfIWHI1qWSV1cDofOq38fbMINjnt7j7KzmCFFY9YHrfhAOSt1KsaVdlfi1+EBiSDCS+SjQJcORPY1sZLORMCwhI/1JNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE9C51FB;
	Wed, 24 Jan 2024 07:58:24 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6619E3F762;
	Wed, 24 Jan 2024 07:57:38 -0800 (PST)
Date: Wed, 24 Jan 2024 15:57:36 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 11/25] KVM: arm64: Drop the requirement for XARRAY_MULTI
Message-ID: <20240124155736.GG1283334@e124191.cambridge.arm.com>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-12-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122201852.262057-12-maz@kernel.org>

On Mon, Jan 22, 2024 at 08:18:38PM +0000, Marc Zyngier wrote:
> Now that we don't use xa_store_range() anymore, drop the added
> complexity of XARRAY_MULTI for KVM. It is likely still pulled
> in by other bits of the kernel though.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 6c3c8ca73e7f..5c2a672c06a8 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -39,7 +39,6 @@ menuconfig KVM
>  	select HAVE_KVM_VCPU_RUN_PID_CHANGE
>  	select SCHED_INFO
>  	select GUEST_PERF_EVENTS if PERF_EVENTS
> -	select XARRAY_MULTI
>  	help
>  	  Support hosting virtualized guest machines.
>  

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
