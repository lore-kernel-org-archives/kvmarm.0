Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21C78485926
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789133288; cv=none; b=dJPU1/rx/TdBIQaflYUKxZ2ZeVBmXWQO2fiqp6MjyTw2GpTYD4vAQQoDKeqLBp1Q12zwGUdwga++eiZ7v2ndiH3k62ocR9Kf5h2tPD+Yhr4PgPm6ipG7lyjrNnpz5Q/rGzkMdpOSLh4mBwJteEsg8PUlL9JLgpt8kgObvr8RA+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789133288; c=relaxed/simple;
	bh=4YD+Fk3HHL60l22D6521PP0drw4lBWBwFWKg00cHdOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uWIN+7bV1hm3wa1akHgGjTc3MzpWU9uQbG2M4iE37r5Ew4ni7VX9DpcwUHgYRupQ8jS2UWIUxOcl1FVvozGSBWlvIUb3mcI+gkzu3Dr2JaOjnTb9MUN3KFtgQ5YkgHD2r8gsy9239v8uGMl2EuJoE9cgrY6WyrcXNIHjuIE7Kww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PpsP4tqK; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PpsP4tqK"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D980A1655;
	Fri, 11 Sep 2026 06:28:02 -0700 (PDT)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 998CB3F59E;
	Fri, 11 Sep 2026 06:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789133286; bh=4YD+Fk3HHL60l22D6521PP0drw4lBWBwFWKg00cHdOg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PpsP4tqKrtQfSCwZE+blAV5Ik4POSn6QJ1SVHQxpbSN7xEZQndzNNwrTj9bnG4p4p
	 fyIXy/pnUo/2KQPsj2nQ0WIxx3foDqMy3DcGpHpTDFbGt5sDtP/ImD368c/lZbIYTb
	 TgpgppBePyhRq7KB0b+tsBGrfJNDAkZ9WRajr744=
Message-ID: <624c282f-4c48-4e06-a7e9-87f754db7b1b@arm.com>
Date: Fri, 11 Sep 2026 14:27:57 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] KVM: arm64: Trap guest MPAM accesses whenever MPAM is
 implemented
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>, Xi Ruoyao <xry111@xry111.site>,
 Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Gavin Shan <gshan@redhat.com>, Yuan Yao <yaoyuan@linux.alibaba.com>,
 Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260911104715.307500-1-fuad.tabba@linux.dev>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20260911104715.307500-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 11/09/2026 11:47, Fuad Tabba wrote:
> finalise_el2_state() clears the EL2 MPAM traps whenever the ID
> registers advertise MPAM, while KVM sets them only under ARM64_MPAM,
> which also requires MPAMEN. Without EL3 nothing sets that enable, so a

This "Without EL3..." part reads oddly to me. I guess what you are getting at is that the MPAMEN is
read only apart from at the highest implemented exception level.

> guest reaches the MPAM registers while ID_AA64PFR0_EL1.MPAM reads 0
> for it.
> 
> Gate on what finalise_el2_state() tests instead: this CPU's ID
> registers with the arm64.nompam override applied, and its
> MPAMIDR_EL1.HAS_HCR before writing MPAMHCR_EL2, which is UNDEFINED
> without it. MPAMEN isn't a term in any MPAM accessor, so the traps
> take effect without it.
> 
> Fixes: 31ff96c38ea3 ("KVM: arm64: Fix missing traps of guest accesses to the MPAM registers")
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

This looks good to me. Now that you're determining if the MPAM registers are present on a per CPU
basis and using that via a host flag, the traps will be set on all CPUs that have MPAM registers
unless overridden on the command line. IIUC this covers the mismatched CPU case as well and so all
cases that the register can be safely accessed (arm64.nompam not required) are covered.


> ---
> 
> Notes:
>     Changes since v2:
>      - A per-CPU flag in kvm_host_data, set at KVM's CPU init from the ID
>        registers with the override applied, instead of a third cpucap
>        (Will). The probe checks presence only, since MPAM3_EL3.TRAPLOWER
>        can't be read at EL2.
>      - The MPAMHCR_EL2 branch reads this CPU's MPAMIDR_EL1 rather than the
>        sanitised ARM64_MPAM_HCR, which would otherwise have been the one
>        system-wide test left in a per-CPU function.
>      - Fixes: names the KVM commit that left this case open, rather than
>        the head.S commit that cleared the traps.
>      - Yuan's Reviewed-by dropped, since the mechanism changed.
>     
>     v2: https://lore.kernel.org/all/20260908145651.2828597-1-fuad.tabba@linux.dev/
>     v1: https://lore.kernel.org/all/20260903160819.831518-1-fuad.tabba@linux.dev/
> 
>  arch/arm64/include/asm/kvm_host.h       |  1 +
>  arch/arm64/kvm/arm.c                    |  7 +++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 13 ++++++++-----
>  3 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 27fe0cd5b2d7a..98ca2d9b9e18d 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -755,6 +755,7 @@ struct kvm_host_data {
>  #define KVM_HOST_DATA_FLAG_VCPU_IN_HYP_CONTEXT		4
>  #define KVM_HOST_DATA_FLAG_L1_VNCR_MAPPED		5
>  #define KVM_HOST_DATA_FLAG_HAS_BRBE			6
> +#define KVM_HOST_DATA_FLAG_HAS_MPAM			7
>  	unsigned long flags;
>  
>  	struct kvm_cpu_context host_ctxt;
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8b080804bc90b..fde75a63cf045 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2281,9 +2281,16 @@ static void cpu_set_hyp_vector(void)
>  
>  static void cpu_hyp_init_context(void)
>  {
> +	u64 pfr0 = __read_sysreg_by_encoding(SYS_ID_AA64PFR0_EL1);
> +	u64 pfr1 = __read_sysreg_by_encoding(SYS_ID_AA64PFR1_EL1);
> +
>  	kvm_init_host_cpu_context(host_data_ptr(host_ctxt));
>  	kvm_init_host_debug_data();
>  
> +	/* The traps take effect without MPAMEN, which ARM64_MPAM requires. */
> +	if (id_aa64pfr0_mpam(pfr0) || id_aa64pfr1_mpamfrac(pfr1))
> +		host_data_set_flag(HAS_MPAM);
> +
>  	if (!is_kernel_in_hyp_mode())
>  		cpu_init_hyp_mode();
>  }
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 1ce7130e25490..2cb611e2bd69b 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -298,14 +298,17 @@ static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
>  	u64 clr = MPAM2_EL2_EnMPAMSM;
>  	u64 set = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
>  
> -	if (!system_supports_mpam())
> +	if (!host_data_test_flag(HAS_MPAM))
>  		return;
>  
>  	/* trap guest access to MPAMIDR_EL1 */
> -	if (system_supports_mpam_hcr()) {
> +	if (read_sysreg_s(SYS_MPAMIDR_EL1) & MPAMIDR_EL1_HAS_HCR) {
>  		write_sysreg_s(MPAMHCR_EL2_TRAP_MPAMIDR_EL1, SYS_MPAMHCR_EL2);
>  	} else {
> -		/* From v1.1 TIDR can trap MPAMIDR, set it unconditionally */
> +		/*
> +		 * TIDR is RES0 without MPAMIDR_EL1.HAS_TIDR, which MPAM v1.0
> +		 * prohibits: such a PE without HAS_HCR can't trap MPAMIDR_EL1.
> +		 */

The lack of a trap too bad as all the fields of MPAMIDR_EL1 are read only.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

Thanks,

Ben

>  		set |= MPAM2_EL2_TIDR;
>  	}
>  
> @@ -317,12 +320,12 @@ static inline void __deactivate_traps_mpam(void)
>  	u64 clr = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1 | MPAM2_EL2_TIDR;
>  	u64 set = MPAM2_EL2_EnMPAMSM;
>  
> -	if (!system_supports_mpam())
> +	if (!host_data_test_flag(HAS_MPAM))
>  		return;
>  
>  	sysreg_clear_set_s(SYS_MPAM2_EL2, clr, set);
>  
> -	if (system_supports_mpam_hcr())
> +	if (read_sysreg_s(SYS_MPAMIDR_EL1) & MPAMIDR_EL1_HAS_HCR)
>  		write_sysreg_s(MPAMHCR_HOST_FLAGS, SYS_MPAMHCR_EL2);
>  }
>  

