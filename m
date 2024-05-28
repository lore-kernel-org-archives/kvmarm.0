Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 265FD1BDD3
	for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 06:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716879427; cv=none; b=jByR82TaGfjB+9tal61eMfLHDLbMW542euZia0Wy40Hz1fBMNrIy05EKnUwrj7s0u2PQf0pE38XM7FfvDcqHjNvf0uXsN5ivc006876vwU+EY7kl9MrV+9TqudPfetDA1IurwqOeA1qbA/4hMW8quOkL7sEH6M/Ofbn1kHHNmJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716879427; c=relaxed/simple;
	bh=x3RnDu7FS0yETf0PyFpTvtyfVJ4/2lY97V3xrfYdUf8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=NsiWVyBlAgYCpf3a7QzZkdwPPuL9cZZPs6JOCAfe0V0aU4vZkJwk58L526m6MqBPNUaneW+ERmXUiIUDE0VsTefaxW+0Or0shLsol5Hpc9KkEHmgh0D3dCo8U8CtUV5BA2ku9cB6BMpmbDxnDmEA9DXB3QjR7n4/qHVpxt1SoqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B57FF150C;
	Mon, 27 May 2024 23:57:29 -0700 (PDT)
Received: from [10.162.40.16] (a077841.arm.com [10.162.40.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5B67F3F792;
	Mon, 27 May 2024 23:56:57 -0700 (PDT)
Message-ID: <229bd367-466e-4bf9-9627-24d2d0821ff4@arm.com>
Date: Tue, 28 May 2024 12:26:54 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Amit Daniel Kachhap <amitdaniel.kachhap@arm.com>
Subject: Re: [PATCH v4 18/29] arm64: add POE signal support
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, aneesh.kumar@kernel.org,
 aneesh.kumar@linux.ibm.com, bp@alien8.de, broonie@kernel.org,
 catalin.marinas@arm.com, christophe.leroy@csgroup.eu,
 dave.hansen@linux.intel.com, hpa@zytor.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, maz@kernel.org,
 mingo@redhat.com, mpe@ellerman.id.au, naveen.n.rao@linux.ibm.com,
 npiggin@gmail.com, oliver.upton@linux.dev, shuah@kernel.org,
 szabolcs.nagy@arm.com, tglx@linutronix.de, will@kernel.org, x86@kernel.org,
 kvmarm@lists.linux.dev
References: <20240503130147.1154804-1-joey.gouly@arm.com>
 <20240503130147.1154804-19-joey.gouly@arm.com>
Content-Language: en-US
In-Reply-To: <20240503130147.1154804-19-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/3/24 18:31, Joey Gouly wrote:
> Add PKEY support to signals, by saving and restoring POR_EL0 from the stackframe.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Acked-by: Szabolcs Nagy <szabolcs.nagy@arm.com>
> ---
>   arch/arm64/include/uapi/asm/sigcontext.h |  7 ++++
>   arch/arm64/kernel/signal.c               | 52 ++++++++++++++++++++++++
>   2 files changed, 59 insertions(+)
> 
> diff --git a/arch/arm64/include/uapi/asm/sigcontext.h b/arch/arm64/include/uapi/asm/sigcontext.h
> index 8a45b7a411e0..e4cba8a6c9a2 100644
> --- a/arch/arm64/include/uapi/asm/sigcontext.h
> +++ b/arch/arm64/include/uapi/asm/sigcontext.h
> @@ -98,6 +98,13 @@ struct esr_context {
>   	__u64 esr;
>   };
>   
> +#define POE_MAGIC	0x504f4530
> +
> +struct poe_context {
> +	struct _aarch64_ctx head;
> +	__u64 por_el0;
> +};

There is a comment section in the beginning which mentions the size
of the context frame structure and subsequent reduction in the
reserved range. So this new context description can be added there.
Although looks like it is broken for za, zt and fpmr context.

> +
>   /*
>    * extra_context: describes extra space in the signal frame for
>    * additional structures that don't fit in sigcontext.__reserved[].
> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
> index 4a77f4976e11..077436a8bc10 100644
> --- a/arch/arm64/kernel/signal.c
> +++ b/arch/arm64/kernel/signal.c
> @@ -63,6 +63,7 @@ struct rt_sigframe_user_layout {
>   	unsigned long fpmr_offset;
>   	unsigned long extra_offset;
>   	unsigned long end_offset;
> +	unsigned long poe_offset;

For consistency this can be added after fpmr_offset.

Thanks,
Amit

>   };
>   
>   #define BASE_SIGFRAME_SIZE round_up(sizeof(struct rt_sigframe), 16)
> @@ -185,6 +186,8 @@ struct user_ctxs {
>   	u32 zt_size;
>   	struct fpmr_context __user *fpmr;
>   	u32 fpmr_size;
> +	struct poe_context __user *poe;
