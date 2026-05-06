Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6834430F927
	for <kvmarm@lists.linux.dev>; Wed,  6 May 2026 13:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778074670; cv=none; b=mdeddgnsmSz6xtJxRPM15JlgRlhxuZclDf34I6E2IQKe2h/u/sBUqH6V3Tt/6ahf7b/YWHcvbyQ+/oFw8+c0C0gtbYNzf9tj6wF16eLlikNnO4mBWyNDZ6pz8VmBU9sHKzUF+HLlWmBaPIbCpeOfp0E04RBkpE1uQLcwAi53e6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778074670; c=relaxed/simple;
	bh=bD2q/d+aJDaBB95/ccdzBanX94Y0tl4/V3GCBGH00SY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XM/3lTh9dHO1+tJc2OTDiDmfa3QfNX5F/SAsLCjjcKUL0HGXWsmLoVdmr5QN7RgerEMSPPOb6U6UY2A/0ussHMM7K3XZYp8QhC3q0q/6FozvN43Trm3Hj5L3dwnYWFoVvvADC1/IfOZ4bYqnWwdsdyY+tzbQwK0mCUIh2yvXTO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mqBfkUBB; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mqBfkUBB"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4893940bb5eso36027395e9.3
        for <kvmarm@lists.linux.dev>; Wed, 06 May 2026 06:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778074667; x=1778679467; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XBCM6xv4Yg8/S1sk1lPfe+sG+a+CcBVlpaZP7IkBPRk=;
        b=mqBfkUBBxzEF3j5v2aMA8LaWzy5ejwLN623PYr3QRBse8gnmt7EmjaoCkaXv8H9Rna
         5dIFIbQ1fNain22lCN50KxA8yMVn66k1vduRbbDiOY92uzcnUnyACK3BVLDiWluLcr79
         dfYQvKni1kuEc8JrIRmXuJJ4UF8QpjpcIPVsCafmrhk4YmWDZSMEueU94dNFaCYZEOBB
         qK+NVpdxMf3YYsaZAkRnONYHjzJ4bGK0hB5+Kla7pXicebz45wY4fsmxhbVuLOtCccZS
         5URjCKkoqOUnjl2BsNTgOZJt1S8mqUP0ssATNCL9n9HWmS/33+7Rs1354kJVMQIH1k2I
         ip6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778074667; x=1778679467;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XBCM6xv4Yg8/S1sk1lPfe+sG+a+CcBVlpaZP7IkBPRk=;
        b=B3fvn7k9ingAdHW0DodB593W+J8SulPa8UOWQDG+w2h+57i4z9CJu7X20GvQ6ZRrYK
         Qmg0Er5Ub8ET3wdnPu0Z/BnqVYS7gcSc1Fn0SS3aCcDOxiaUAvgNVozatN7LE5Vu7w75
         zYEwXI11Q3AbR7CyD7DJ9QugI52T9QuqK5Jo3mi5aO4UDpWh5chuoSLtc+vUNgGD3B+s
         KBBT65axzqG7l8//wY7OyngkGW+iIKkC+4ca83lBQ1xVF/Yn3Lu8qn1ehKXsZ0konQG6
         R6R4JMRvIqcAlv8ZTfavBDugho4BOcra0CjcKXHdTxXdwIO0RBolkdxjxtRg6DdBfU7Q
         flPg==
X-Forwarded-Encrypted: i=1; AFNElJ/GuL8izm8k3UI3Jj8pIlOGhDZZdPSNA2pdEQbNBOhYsk9Hi2rUEMPtqu1MZr8544KWRAOKl2w=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFiEr9Ml+dYuM58N/cSE6sfyCyfyri6tpw2DV9FXqjHF4yb88n
	bihRwTSmLgRTxOTfNhCFI4suAIX68ORNtOqSwQmQsrYp9y6JdTLuJx2WIG/SJwuTDw==
X-Gm-Gg: AeBDies0LludzKgFW+MujZYdbGLFlfezlAW1MDNzGEuMk55EDC0oKteXnKjUCBI1TC6
	HmLpmqIEo2/w+vWOySekpcReMKbOQ5BEIP5NveDOd/cSYCaojhkn3FCu0o4RCkefIZhiNoJU6PR
	dA4o7q4n3jwFpxX6wxuAguUIhNZD4bryydM3h2t63i6CYLW1OvM3J9+bNOc64N0TGKSatJqyCDY
	aAu8aq6fl2KiazA5HxbW8vCjYzH1MzMRQB0hPRaTCJHN87Sz7r//5kMBW1kYKADSDPuo4obUGAG
	ZflGXXELI4wCw617wCQuNmYaeiAR8BG59oYlJRAFLfARiFsGKfBZ/Ua1Ts3iaCAfwwFy3x5ZeVj
	s9Xa9hk10IU/W5SV1wYmFTqlwpvWgfjV1pbV79z3IjTAuh7h8VsKVQPCW8vf5J1KwGPJUlmDOh7
	AvrY05SfdqjVnpDfznfWDOdtbDpbQKX2QgHjBG0OQHJ7w59zIco0pduUAlevbnxsh1gDU4DLYMo
	I/FqIoEoIgstqdr
X-Received: by 2002:a05:600c:a08b:b0:489:1f3e:5f69 with SMTP id 5b1f17b1804b1-48e51f40252mr61663985e9.18.1778074666409;
        Wed, 06 May 2026 06:37:46 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e5312df8dsm16977685e9.18.2026.05.06.06.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 06:37:45 -0700 (PDT)
Date: Wed, 6 May 2026 14:37:41 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [PATCH v2] KVM: arm64: Work around C1-Pro erratum 4193714 for
 protected guests
Message-ID: <aftEJffxGZ_XSk2E@google.com>
References: <20260505165205.2690919-1-catalin.marinas@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505165205.2690919-1-catalin.marinas@arm.com>

On Tue, May 05, 2026 at 05:52:03PM +0100, Catalin Marinas wrote:
> From: James Morse <james.morse@arm.com>
> 
> C1-Pro cores with SME have an erratum where TLBI+DSB does not complete
> all outstanding SME accesses. Instead a DSB needs to be executed on the
> affected CPUs. The implication is that pages cannot be unmapped from the
> host Stage 2 and then provided to a protected guest or to the
> hypervisor. Host SME accesses may still complete after this point.
> 
> This erratum breaks pKVM's guarantees, and the workaround is hard to
> implement as EL2 and EL1 share a security state meaning EL1 can mask
> IPIs sent by EL2, leading to interrupt blackouts.
> 
> Instead, do this in EL3. This has the advantage of a separate security
> state, meaning lower EL cannot mask the IPI. It is also simpler for EL3
> to know about CPUs that are off or in PSCI's CPU_SUSPEND.
> 
> Add the needed hook to host_stage2_set_owner_metadata_locked(). This
> covers the cases where the host loses access to a page:
> 
>   __pkvm_host_donate_guest()
>   __pkvm_guest_unshare_host()
>   host_stage2_set_owner_locked() when owner_id == PKVM_ID_HYP
> 
> Since pKVM relies on the firmware call for correctness, check for the
> firmware counterpart during protected KVM initialisation and fail the
> pKVM initialisation if it is missing.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Co-developed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: Vincent Donnefort <vdonnefort@google.com>
> Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>
> Cc: Sudeep Holla <sudeep.holla@kernel.org>
> ---
> 
> Added the kvm-arm list this time, missed it in v1.
> 
> Changelog below but it's only probing if the firmware counterpart is
> present and disable the hypervisor. If that's too harsh, we can leave it
> as a warning and maybe add a static label/flag to avoid the unnecessary
> SMC call on page donation.

As the pKVM upstream support is currently experimental and the protection
incomplete (see Documentation/virt/kvm/arm/pkvm.rst) perhaps a simple WARN() is
enough?

> 
> Changes:
> 
> v2:
> 
> (v1: https://lore.kernel.org/r/20260430155911.628402-1-catalin.marinas@arm.com)
> 
> - Add a check in init_hyp_mode() if KVM is running in protected mode and
>   refuse initialising the hypervisor if the firmware does not provide
>   the workaround counterpart
> - Add 'Co-developed-by: me'
> 
> v1:
> 
> (pre-7.1-rc: https://lore.kernel.org/r/20260323162408.4163113-6-catalin.marinas@arm.com)
> 
> - Move the hook to host_stage2_set_owner_metadata_locked()
> - Use hyp_smccc_1_1_smc()
> 
>  arch/arm64/kvm/arm.c                  | 21 +++++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 24 +++++++++++++++++++++++-
>  include/linux/arm-smccc.h             |  6 ++++++
>  3 files changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 176cbe8baad3..51b6db45a54f 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -4,6 +4,7 @@
>   * Author: Christoffer Dall <c.dall@virtualopensystems.com>
>   */
>  
> +#include <linux/arm-smccc.h>
>  #include <linux/bug.h>
>  #include <linux/cpu_pm.h>
>  #include <linux/errno.h>
> @@ -2634,6 +2635,22 @@ static int init_pkvm_host_sve_state(void)
>  	return 0;
>  }
>  
> +static int pkvm_check_sme_dvmsync_fw_call(void)
> +{
> +	struct arm_smccc_res res;
> +
> +	if (!cpus_have_final_cap(ARM64_WORKAROUND_4193714))
> +		return 0;
> +
> +	arm_smccc_1_1_smc(ARM_SMCCC_CPU_WORKAROUND_4193714, &res);
> +	if (res.a0) {
> +		kvm_err("pKVM requires firmware support for C1-Pro erratum 4193714\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * Finalizes the initialization of hyp mode, once everything else is initialized
>   * and the initialziation process cannot fail.
> @@ -2834,6 +2851,10 @@ static int __init init_hyp_mode(void)
>  		if (err)
>  			goto out_err;
>  
> +		err = pkvm_check_sme_dvmsync_fw_call();
> +		if (err)
> +			goto out_err;
> +
>  		err = kvm_hyp_init_protection(hyp_va_bits);
>  		if (err) {
>  			kvm_err("Failed to init hyp memory protection\n");
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 28a471d1927c..7d59faa99fee 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -5,6 +5,8 @@
>   */
>  
>  #include <linux/kvm_host.h>
> +#include <linux/arm-smccc.h>
> +

nit: probably not necessary with the nvhe/arm-smccc.h include below.

>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
> @@ -14,6 +16,7 @@
>  
>  #include <hyp/fault.h>
>  
> +#include <nvhe/arm-smccc.h>
>  #include <nvhe/gfp.h>
>  #include <nvhe/memory.h>
>  #include <nvhe/mem_protect.h>
> @@ -29,6 +32,19 @@ static struct hyp_pool host_s2_pool;
>  static DEFINE_PER_CPU(struct pkvm_hyp_vm *, __current_vm);
>  #define current_vm (*this_cpu_ptr(&__current_vm))
>  
> +static void pkvm_sme_dvmsync_fw_call(void)
> +{
> +	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_4193714)) {
> +		struct arm_smccc_res res;
> +
> +		/*
> +		 * Ignore the return value. Probing for the workaround
> +		 * availability took place in init_hyp_mode().
> +		 */
> +		hyp_smccc_1_1_smc(ARM_SMCCC_CPU_WORKAROUND_4193714, &res);
> +	}
> +}
> +
>  static void guest_lock_component(struct pkvm_hyp_vm *vm)
>  {
>  	hyp_spin_lock(&vm->lock);
> @@ -574,8 +590,14 @@ static int host_stage2_set_owner_metadata_locked(phys_addr_t addr, u64 size,
>  	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
>  			      addr, size, &host_s2_pool,
>  			      KVM_HOST_INVALID_PTE_TYPE_DONATION, annotation);
> -	if (!ret)
> +	if (!ret) {
> +		/*
> +		 * After stage2 maintenance has happened, but before the page
> +		 * owner has changed.
> +		 */
> +		pkvm_sme_dvmsync_fw_call();
>  		__host_update_page_state(addr, size, PKVM_NOPAGE);
> +	}
>  
>  	return ret;
>  }
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
