Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80966494836
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 14:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787321742; cv=none; b=tfDZgtppnkS+TZ+CEgPcazDd2/eWdwAMVK99gWnBCrNFIScbVf9RYsuO/Oti5XLSIza5UmjUKy3KhGZiUWie6LDgj/8nbPsY79hT5pB4nhGqDgQD0Duub3FPmFDjhgiRb7v0EVCg9kodqHimMto1f1LFtCoFu69R90Q+af97d4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787321742; c=relaxed/simple;
	bh=wr+oDs6GaWbQ12XdjZDarAcNoSJgxK7egAFc5/zGO30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qrYdKIl54/8//Ou9D7vVhifRBKjlpBMXzCJ9MPHDyull4uGlHIpkKCSHjtI0TxRVwwn76Akxj+D1Rfm1+F2qLHm6OFHlcNlxO9KnN5X5nCMGrr7j4lxndWd2S8SP7+l3iAvylio0IoTflRkTs++DXneeDz/UeMaMrWNVgPXIU84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RHs4kc7X; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RHs4kc7X"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5799153B;
	Fri, 21 Aug 2026 07:15:35 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5412E3F85F;
	Fri, 21 Aug 2026 07:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787321739; bh=wr+oDs6GaWbQ12XdjZDarAcNoSJgxK7egAFc5/zGO30=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RHs4kc7X/JIMYPOZt3UHHS0UF10RItxSgEwu/gJcUgPays+T/VhcyM3Zj0+O6JD9q
	 9pEGZIgyxqw6W8R+la4pH2O0tDoFOQm5XMRiwmLROx9/wX+H6eO1I8xzF4hz8EPt9l
	 PN5eYbMbey7tAMIoAinLM0uQF5Utj7iLYrYHg0Ew=
Date: Fri, 21 Aug 2026 15:15:26 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Mark Brown <broonie@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 05/14] KVM: arm64: Set PSTATE.EXLOCK when entering an
 exception
Message-ID: <wu4y6mfg7avc32gg55vkxy565errbecy6kgckmthrjvuben2sc@xmrqciocdmgb>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
 <20260812-arm64-gcs-v19-5-9105afd828ac@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812-arm64-gcs-v19-5-9105afd828ac@kernel.org>

On Wed, Aug 12, 2026 at 08:12:04PM +0100, Mark Brown wrote:
> As per DDI 0487 R_WTXBY we need to manage PSTATE.EXLOCK when entering an
> exception, when the exception is entered from a lower EL the bit is cleared
> while if entering from the same EL it is set to GCSCR_ELx.EXLOCKEN.
> Implement this behaviour in enter_exception64().
> 
> Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/uapi/asm/ptrace.h |  1 +
>  arch/arm64/kvm/hyp/exception.c       | 37 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
> index 6fed93fb2536..6113b9f9771b 100644
> --- a/arch/arm64/include/uapi/asm/ptrace.h
> +++ b/arch/arm64/include/uapi/asm/ptrace.h
> @@ -56,6 +56,7 @@
>  #define PSR_C_BIT	0x20000000
>  #define PSR_Z_BIT	0x40000000
>  #define PSR_N_BIT	0x80000000
> +#define PSR_EXLOCK_BIT 0x400000000
>  
>  #define PSR_BTYPE_SHIFT		10
>  
> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
> index bef40ddb16db..15b00e0ee1ec 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -65,6 +65,38 @@ static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
>  		vcpu->arch.ctxt.spsr_und = val;
>  }
>  
> +static unsigned long compute_exlock(struct kvm_vcpu *vcpu,
> +				    unsigned long mode,
> +				    unsigned long target_mode)
> +{
> +	u64 gcscr;
> +
> +	if (!kvm_has_gcs(kern_hyp_va(vcpu->kvm)))
> +		return 0;
> +
> +	/* GCS can't be enabled for 32 bit */
> +	if (mode & PSR_MODE32_BIT)
> +		return 0;
> +
> +	/* When taking an exception to a higher EL EXLOCK is cleared. */
> +	if ((mode | PSR_MODE_THREAD_BIT) != target_mode)
> +		return 0;

This is essentially doing an EL comparison, which is also done in
kvm_check_illegal_exlock_return() later. Would it be clearer if we
follow the EL comparison pattern there? exlock_el_from_spsr() can have
more use too.

Thanks,
Wei-Lin Chang

> +
> +	/*
> +	 * When taking an exception to the same EL EXLOCK is set to
> +	 * the effective value of GCSR_ELx.EXLOCKEN.
> +	 */
> +	if (is_hyp_ctxt(vcpu))
> +		gcscr = __vcpu_read_sys_reg(vcpu, GCSCR_EL2);
> +	else
> +		gcscr = __vcpu_read_sys_reg(vcpu, GCSCR_EL1);
> +
> +	if (gcscr & GCSCR_ELx_EXLOCKEN)
> +		return PSR_EXLOCK_BIT;
> +
> +	return 0;
> +}
> +

[...]
