Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 455A112838A;
	Tue, 16 Apr 2024 11:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713266232; cv=none; b=UNy8mslyF5OJhIqKrgSWAiuJxhkT93vK//mRZ2yFjMdD7DhBMJyoHCPYb0PicS86iROdROKJ9ZwB8zAQ4BJchITJxVluyPIH5/hlBdH2fZyVS801oF0AEy96LaTktN5BSJ5IYAdGRkQutVuIeBvqhy/ojdS6l2p5Q5dQCPrr4ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713266232; c=relaxed/simple;
	bh=9FhYJpvHXnQmHxgxXicQhyk+mTtDwkQy/D0WwG1gg9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UKZVOjg1idCHDY7Wy5mm/i4QacZyZzFCoImZ/eI4jkrUQxFwBTKBPAd1sJrfI27wHKcfJR+mcP6H7WrEmgHEYKNhbWhycqG3FYPIOSUwdF4/REKcLW9Y09abzmMqs8qdwrAbWLc8m8YLlFnSXXGh4VEf0jnl+PH/t5cFatmsVdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A532F339;
	Tue, 16 Apr 2024 04:17:38 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3473C3F738;
	Tue, 16 Apr 2024 04:17:08 -0700 (PDT)
Message-ID: <d452859e-8b35-4aac-83d5-5b8d44ed4406@arm.com>
Date: Tue, 16 Apr 2024 12:17:06 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/43] arm64: RME: Handle Granule Protection Faults
 (GPFs)
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
 <20240412084309.1733783-5-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240412084309.1733783-5-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/04/2024 09:42, Steven Price wrote:
> If the host attempts to access granules that have been delegated for use
> in a realm these accesses will be caught and will trigger a Granule
> Protection Fault (GPF).
> 
> A fault during a page walk signals a bug in the kernel and is handled by
> oopsing the kernel. A non-page walk fault could be caused by user space
> having access to a page which has been delegated to the kernel and will
> trigger a SIGBUS to allow debugging why user space is trying to access a
> delegated page.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/mm/fault.c | 29 ++++++++++++++++++++++++-----
>   1 file changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 8251e2fea9c7..91da0f446dd9 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -765,6 +765,25 @@ static int do_tag_check_fault(unsigned long far, unsigned long esr,
>   	return 0;
>   }
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
> +	const struct fault_info *inf = esr_to_fault_info(esr);
> +
> +	if (!is_el1_instruction_abort(esr) && fixup_exception(regs))
> +		return 0;
> +
> +	arm64_notify_die(inf->name, regs, inf->sig, inf->code, far, esr);
> +	return 0;
> +}
> +
>   static const struct fault_info fault_info[] = {
>   	{ do_bad,		SIGKILL, SI_KERNEL,	"ttbr address size fault"	},
>   	{ do_bad,		SIGKILL, SI_KERNEL,	"level 1 address size fault"	},
> @@ -802,11 +821,11 @@ static const struct fault_info fault_info[] = {
>   	{ do_alignment_fault,	SIGBUS,  BUS_ADRALN,	"alignment fault"		},
>   	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 34"			},
>   	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 35"			},

Should this also be converted to do_gpf_ptw, "GPF at level -1", given we 
support LPA2 ?


> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 36"			},
> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 37"			},
> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 38"			},
> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 39"			},
> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 40"			},
> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"Granule Protection Fault at level 0" },
> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"Granule Protection Fault at level 1" },
> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"Granule Protection Fault at level 2" },
> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"Granule Protection Fault at level 3" },
> +	{ do_gpf,		SIGBUS,  SI_KERNEL,	"Granule Protection Fault not on table walk" },
>   	{ do_bad,		SIGKILL, SI_KERNEL,	"level -1 address size fault"	},
>   	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 42"			},
>   	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"level -1 translation fault"	},


Rest looks fine to me.

Suzuki
