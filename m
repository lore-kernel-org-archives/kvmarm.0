Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CAD3AB28F
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 10:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774347288; cv=none; b=OHc36I6wgpk4bgZVPP0JqloKp/pBn71WuzUeMswTpWC4wt4Ut8uhWOE55IDVBFEXp0Ktqy/NrG4vB0tjyqEHQWmd8pEr9utrcm+oFVKJ0121qRGdFQSMdOjdOG3uOh3RD9eqcu8v14YKp6QzgRwtxlyMoV1rUxnM2F/rOUcI/r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774347288; c=relaxed/simple;
	bh=iQstA0VA65oB606BWqTvA+NLqWOlhcXvpuzI/fSPJ94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qg/9feNrzz3sG6QdqXv53sZvpoTSE7QswUC1KqvYtl7i/pt69GBFad3bHtwcXTHIULcGLsfp1D9xVixujXmyWHZQovP0gq6teX/MabWiGQs7RTQUmX/t5SXI3+GNVNO3mq6TamYhhw3M1QoB9B7kcJNscB41UcrIvYEo2XvwXVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U24QI/sC; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U24QI/sC"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4853e1ce427so39591135e9.3
        for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 03:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774347285; x=1774952085; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9IY4dDZh9dDmUZT2xOVDzhyZHdg/R37G9q2o81SGSX0=;
        b=U24QI/sCsSby+sWLcBD78LD3dAd0931Eis0raWPxjb0+0C9MWP0s6K2h/4CRDPWPq2
         +pR2xsOaDg8LR/uPVdZGTA9iLj7AGaeu4GfmGWMyfvdelbTVAqNPT0mnum3eTIbIkLtA
         6RnHhbxwGXmvtRzccl1EzBnRXrAeruMjPP8Jln8jPvY4gQ6DP/lUZj1YnzPWuaL3b+Kt
         QsODFm9qeQtWqfnrzzSxGk/WswOlDeaDUJhyMPvyRaLX7X2HNweBnecJt3eozwUrVoIZ
         dDATMhnhJUBvYFlp0hJEBZwaIBgPfNCCI/ukAoYmvOPq6bjX5prlTDhRx791tcil5pLD
         ESlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774347285; x=1774952085;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9IY4dDZh9dDmUZT2xOVDzhyZHdg/R37G9q2o81SGSX0=;
        b=bbElf2aYU4iChmAo7pJLH3MDktEkLmwtDCRHj2lAqyV7lcsr2EkIUXvEsCMy8NWwUR
         T+gpUW9UY+1ihVbRzk+wkYp7QOuJ1Z/nHhii89Z+fgKucYdtaiFGhMaHKUcBjt9HIKx/
         T5gjUHaMbmIpNF7huyt4eZHl1t6BIrsUWzhvquZ9yv1vkL67rn8kY2FkkEKSPNiZx71I
         ldjs6IMiZHGkxxH9qXZDTnUBzJw1ZEiTHPFIzPS4mLEGBFzyQP9Juc8LGGULM5YFcnc1
         IpGkFwi31sY0d1zIx1tkJaBvtvDa7mIm+zHT8zBGTTla9vPrOg09nm1qfzLUqMDH1fl9
         g4ZA==
X-Forwarded-Encrypted: i=1; AJvYcCUeDJbzyWi3CWoycnnZXFOUUGIJvCowpxHPAbS1KfhgjqZKUryvT2e7RlXcNo9ESW1EpXkRQpU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzX8/S+lTyIsUfoMT0waNoh0COsRlwUXCAcT1LpRAA1MIYzFanK
	l58yx5kWzt3t/4WspQpFQcJOvGzYTsyvcdUZl5pTsd2Zn7lin3+gFHmUXl0qxdx6Ww==
X-Gm-Gg: ATEYQzyvOZ2T+rrly6xaRpE2LyJgJlQTFFF+6ktVR7IJYhpS7SWzJImoFFRCmZ3Rsi3
	m+OK6VgAjmQkjNz9PFNbePA1sBWlnelhzNJStmAY8RMixJ88+DT53m+5GCPTyIRVaD+H1SLheLX
	Z6qact2RpmqT3FZxJHmBpQ9eOgXUqxdayffSJE3meX4Yv1KV75vSs99Y+Fkq5MoWlODB8gBeCQc
	8ioZgvnjh6QLtXa+PYqEX4H/Vqj4xDE4zcXgSqk/66lcFv+Ff0KJO/FEj/CStHQ8qWdHzuLuSs1
	Rki3JISqFVlEzqdNUn4eGleeBl7/am+JfDs/WyUcpYa/Aw62NG9raMz5Hm83xxjwB82teeWyLk7
	VxQr0PCyIgkNDh7SHFPfjXvvojl6VNretm+dfOHMHNHUtlA0xDlKHnaIHYUn+56b6chwoUMAUX6
	/7S1JSht4vwD4P83y+JiYsEQxdp3rvf0FYBeArDsPOWeo7Ao448ESSZIYajp/5Do74KdQ=
X-Received: by 2002:a05:600c:1d15:b0:485:34b3:8587 with SMTP id 5b1f17b1804b1-486fedf9061mr218893015e9.10.1774347284527;
        Tue, 24 Mar 2026 03:14:44 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6425eeb4sm32171989f8f.0.2026.03.24.03.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 03:14:43 -0700 (PDT)
Date: Tue, 24 Mar 2026 10:14:40 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 5/5] KVM: arm64: Add SMC hook for SME dvmsync erratum
Message-ID: <acJkEEXKt_GunFLQ@google.com>
References: <20260323162408.4163113-1-catalin.marinas@arm.com>
 <20260323162408.4163113-6-catalin.marinas@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323162408.4163113-6-catalin.marinas@arm.com>

On Mon, Mar 23, 2026 at 04:24:05PM +0000, Catalin Marinas wrote:
> From: James Morse <james.morse@arm.com>
> 
> C1-Pro cores with SME have an erratum where TLBI+DSB does not complete
> all outstanding SME accesses. Instead a DSB needs to be executed on the
> affecteed CPUs. The implication is pages cannot be unmapped from the
> host stage2 then provided to the guest. Host SME accesses may occur
> after this point.
> 
> This erratum breaks pKVM's guarantees, and the workaround is hard to
> implement as EL2 and EL1 share a security state meaning EL1 can mask
> IPI sent by EL2, leading to interrupt blackouts.
> 
> Instead, do this in EL3. This has the advantage of a separate security
> state, meaning lower EL cannot mask the IPI. It is also simpler for EL3
> to know about CPUs that are off or in PSCI's CPU_SUSPEND.
> 
> Add the needed hook.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>
> Cc: Sudeep Holla <sudeep.holla@kernel.org>

In case this goes in before Will's p-guest series and with just a small comment
below:

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 17 +++++++++++++++++
>  include/linux/arm-smccc.h             |  6 ++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 38f66a56a766..ef8afbdd421b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -5,6 +5,8 @@
>   */
>  
>  #include <linux/kvm_host.h>
> +#include <linux/arm-smccc.h>
> +
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
> @@ -28,6 +30,15 @@ static struct hyp_pool host_s2_pool;
>  static DEFINE_PER_CPU(struct pkvm_hyp_vm *, __current_vm);
>  #define current_vm (*this_cpu_ptr(&__current_vm))
>  
> +static void pkvm_sme_dvmsync_fw_call(void)
> +{
> +	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_4193714)) {
> +		struct arm_smccc_res res;
> +
> +		arm_smccc_1_1_smc(ARM_SMCCC_CPU_WORKAROUND_4193714, &res);

With hyp tracing in kvmarm/next, this should be hyp_smccc_1_1_smc().

> +	}
> +}
> +
>  static void guest_lock_component(struct pkvm_hyp_vm *vm)
>  {
>  	hyp_spin_lock(&vm->lock);
> @@ -553,6 +564,12 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
>  	if (ret)
>  		return ret;
>  
> +	/*
> +	 * After stage2 maintenance has happened, but before the page owner has
> +	 * changed.
> +	 */
> +	pkvm_sme_dvmsync_fw_call();
> +
>  	/* Don't forget to update the vmemmap tracking for the host */
>  	if (owner_id == PKVM_ID_HOST)
>  		__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index 50b47eba7d01..e7195750d21b 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -105,6 +105,12 @@
>  			   ARM_SMCCC_SMC_32,				\
>  			   0, 0x3fff)
>  
> +/* C1-Pro erratum 4193714: SME DVMSync early acknowledgement */
> +#define ARM_SMCCC_CPU_WORKAROUND_4193714				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_32,				\
> +			   ARM_SMCCC_OWNER_CPU, 0x10)
> +
>  #define ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID				\
>  	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
>  			   ARM_SMCCC_SMC_32,				\
> 
