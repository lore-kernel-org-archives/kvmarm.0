Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70A56568552
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 17:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789062323; cv=none; b=AXJPoLuMo/T+NBPgBvilJ+7oRnQij9TPsyUWEeO5iJX3UPHQmFoSX4sv49mi/0NwqF/aQLBmPECwwgTMTSQBbkjyb2hImb3QrusfdJ3Jcopyv6Mqrg65scDPTv9mHG9R3nIxx2HRSe9gSNECM8aA81X32sOiT7ZpowZca3Qclt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789062323; c=relaxed/simple;
	bh=lQQkO6iZXqi0Y8a4ze7AN9SoD32y+6oFDlGAoHjbyWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ofQicr2vmqbnCuqUYT2LZAgU0LDJVvszPGEvJSuJbsAtUq69d3S4ztc8Y/N7IfuPzZWs9mb53WYb6G8FV2na/+lCbiYptlJNpNeyPhoXu6siafPsliMhi+VMaT69uBSCe0RVZMPTRcoBOdpQ275lYRX2MY1g18bYB77bugSAL1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZrUxtQll; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZrUxtQll"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CAFC4237B;
	Thu, 10 Sep 2026 10:45:03 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6CE533F59E;
	Thu, 10 Sep 2026 10:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789062307; bh=lQQkO6iZXqi0Y8a4ze7AN9SoD32y+6oFDlGAoHjbyWM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZrUxtQllsN28zYKXkkk3IqRKzVHUtFYqVDaNn5BTdoE46m6pFaNHLm2iQ7TheaNid
	 /ac3HDUb3O60bLD7dBYjM36MNMRCNDS5zA9UZQle/VLwVrcGmpTcyXBrlDWT18u5s9
	 EKEuy4XThJnYTB/SWuZ4ZiQbnXzQbEs4+0I4Y+8M=
Date: Thu, 10 Sep 2026 18:45:02 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, will@kernel.org,
	linux-kernel@vger.kernel.org, maz@kernel.org,
	pavan.kondeti@oss.qualcomm.com, tabba@google.com,
	aneesh.kumar@kernel.org, mark.rutland@arm.com,
	sdonthineni@nvidia.com, steven.price@arm.com, gshan@redhat.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev
Subject: Re: [PATCH v17 1/1] arm64: mm: Handle Granule Protection Faults
 (GPFs)
Message-ID: <aqLsnngKRbMRu211@arm.com>
References: <20260907162204.1479401-1-suzuki.poulose@arm.com>
 <20260907162204.1479401-2-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907162204.1479401-2-suzuki.poulose@arm.com>

On Mon, Sep 07, 2026 at 05:22:04PM +0100, Suzuki K Poulose wrote:
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 0b52557652be6..ad00997b1a873 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -910,6 +910,22 @@ static int do_tag_check_fault(unsigned long far, unsigned long esr,
>  	return 0;
>  }
>  
> +static int do_gpf_ptw(unsigned long far, unsigned long esr, struct pt_regs *regs)
> +{
> +	const struct fault_info *inf = esr_to_fault_info(esr);
> +
> +	die_kernel_fault(inf->name, far, esr, regs);
> +	return 0;
> +}
> +
> +static int do_gpf(unsigned long far, unsigned long esr, struct pt_regs *regs)
> +{
> +	if (!is_el1_instruction_abort(esr) && fixup_exception(regs, esr))
> +		return 0;
> +
> +	return 1;
> +}

If we end up with a user PC here, we correctly return 1 but only because
fixup_exception() won't find the PC. I'd rather have this explicit with
a user_mode() check.

> +
>  static const struct fault_info fault_info[] = {
>  	{ do_bad,		SIGKILL, SI_KERNEL,	"ttbr address size fault"	},
>  	{ do_bad,		SIGKILL, SI_KERNEL,	"level 1 address size fault"	},
> @@ -946,12 +962,12 @@ static const struct fault_info fault_info[] = {
>  	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 32"			},
>  	{ do_alignment_fault,	SIGBUS,  BUS_ADRALN,	"alignment fault"		},
>  	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 34"			},
> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 35"			},
> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 36"			},
> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 37"			},
> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 38"			},
> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 39"			},
> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 40"			},
> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"level -1 granule protection fault (translation table walk)" },
> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"level 0 granule protection fault (translation table walk)" },
> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"level 1 granule protection fault (translation table walk)" },
> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"level 2 granule protection fault (translation table walk)" },
> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"level 3 granule protection fault (translation table walk)" },
> +	{ do_gpf,		SIGBUS,  SI_KERNEL,	"granule protection fault" },

For SIGBUS, we should use BUS_OBJERR like we do for do_sea().

Otherwise it looks fine to me.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
