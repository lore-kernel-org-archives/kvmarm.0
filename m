Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8626F443313
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 09:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790328129; cv=none; b=U4D4h0TEQdTF9irm1nnRfmGD7S3GzgazQT+K+47r+aEKR/0v/H5Y6Fs0PiOHQTZJ2SNDLHhKJGyQ7QaDS1hikwZjc5h6u4gsd4zv085qjpazYRQa+hq0Jo5ewBEtxOvO5IMNPUboIeBCnD9YkqW7No2myIidiIV6Q3Qa0Y0RiHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790328129; c=relaxed/simple;
	bh=vvsH/jsy0p9RrLtoELsLs64nRul6iFMtU+55j8ZDHK8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vuizip+psgfSAaeebi9X50xBB38jtSfLyOmVci21fMfOe4+dHp6QRZFAad2I8lOrvxX4srMzlmsk7twFfl9JtiOqxcv1T/e7WTw5zRT8guDU613xh/R5paFjW75BKpYQcQakckRwC9Qa8NujgQQDAPX+HpSgHaGHZJ5PVxLpUEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YWQAfP+/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YWQAfP+/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D76F71688;
	Fri, 25 Sep 2026 02:22:00 -0700 (PDT)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 297283F86C;
	Fri, 25 Sep 2026 02:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790328124; bh=vvsH/jsy0p9RrLtoELsLs64nRul6iFMtU+55j8ZDHK8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YWQAfP+/lL054XUPcunay8V7CV83HKV0gj7w9Me3wDmcY4WYSKp2e6L4c/UrD8rXj
	 YzsmT9PEI7ClMQNYb8byBScTZWPrRwHKeoum/yUy+ksIMRCf/1Gccko0slkAZjK+FU
	 QTLYwQ+11S3bwZUa31sItFEj4mqMMlWI5hmHqRb8=
Message-ID: <05714056-53b7-46ce-86eb-fdb7d2afe1fa@arm.com>
Date: Fri, 25 Sep 2026 10:22:00 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] KVM: arm64: Trap guest MPAM accesses whenever MPAM is
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
References: <20260924165329.1684155-1-fuad.tabba@linux.dev>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20260924165329.1684155-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 24/09/2026 17:53, Fuad Tabba wrote:
> finalise_el2_state() clears the EL2 MPAM traps on every CPU whose ID
> registers, with the arm64.nompam override applied, advertise MPAM.
> KVM sets the traps again on guest entry, but only when the ARM64_MPAM
> capability is set, and that capability also requires
> MPAM1_EL1.MPAMEN. MPAMEN is writable only at the highest implemented
> exception level. Without EL3 that is MPAM2_EL2.MPAMEN, which the
> kernel does not set, so ARM64_MPAM is never set either and the traps
> stay clear. A guest on such a machine can access MPAM0_EL1,

IIUC, this patch also covers the mismatched system case where EL3 f/w may set MPAMEN for cpus that
support MPAM but system_supports_mpam() returns false.

> MPAM1_EL1, MPAMSM_EL1 and MPAMIDR_EL1 while its ID_AA64PFR0_EL1.MPAM
> reads 0.
> 
> Set the traps under the condition finalise_el2_state() clears them:
> record per CPU whether its ID registers, with the override applied,
> advertise MPAM, and whether MPAMIDR_EL1.HAS_HCR is set, since
> MPAMHCR_EL2 is UNDEFINED without it. MPAMEN does not appear in the
> conditions that trap an MPAM register access to EL2, so the traps
> take effect whether or not it is set.
> 
> Fixes: 31ff96c38ea3 ("KVM: arm64: Fix missing traps of guest accesses to the MPAM registers")
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

Thanks,

Ben

> ---
> 
> Notes:
>     Changes since v3:
>      - MPAMIDR_EL1.HAS_HCR probed once at CPU init into a second flag,
>        HAS_MPAM_HCR, instead of read on every guest entry and exit (Marc).
>      - A comment on why the ID registers are read through
>        __read_sysreg_by_encoding() (Marc).
>      - Commit message reworded around MPAMEN being writable only at the
>        highest implemented exception level (Ben).
>      - Ben's Reviewed-by dropped, since the MPAMHCR_EL2 test changed.
>     
>     Based on Linux 7.3-rc1 (cee9395acd80).
>     
>     v3: https://lore.kernel.org/all/20260911104715.307500-1-fuad.tabba@linux.dev/
>     v2: https://lore.kernel.org/all/20260908145651.2828597-1-fuad.tabba@linux.dev/
>     v1: https://lore.kernel.org/all/20260903160819.831518-1-fuad.tabba@linux.dev/
> 
>  arch/arm64/include/asm/kvm_host.h       |  2 ++
>  arch/arm64/kvm/arm.c                    | 13 +++++++++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 13 ++++++++-----
>  3 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 27fe0cd5b2d7a..3f5b347093fe8 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -755,6 +755,8 @@ struct kvm_host_data {
>  #define KVM_HOST_DATA_FLAG_VCPU_IN_HYP_CONTEXT		4
>  #define KVM_HOST_DATA_FLAG_L1_VNCR_MAPPED		5
>  #define KVM_HOST_DATA_FLAG_HAS_BRBE			6
> +#define KVM_HOST_DATA_FLAG_HAS_MPAM			7
> +#define KVM_HOST_DATA_FLAG_HAS_MPAM_HCR			8
>  	unsigned long flags;
>  
>  	struct kvm_cpu_context host_ctxt;
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8b080804bc90b..9677d234e17b1 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2281,9 +2281,22 @@ static void cpu_set_hyp_vector(void)
>  
>  static void cpu_hyp_init_context(void)
>  {
> +	u64 pfr0 = __read_sysreg_by_encoding(SYS_ID_AA64PFR0_EL1);
> +	u64 pfr1 = __read_sysreg_by_encoding(SYS_ID_AA64PFR1_EL1);
> +
>  	kvm_init_host_cpu_context(host_data_ptr(host_ctxt));
>  	kvm_init_host_debug_data();
>  
> +	/*
> +	 * The ID registers are read above with the arm64.nompam override
> +	 * applied, as finalise_el2_state() reads them.
> +	 */
> +	if (id_aa64pfr0_mpam(pfr0) || id_aa64pfr1_mpamfrac(pfr1)) {
> +		host_data_set_flag(HAS_MPAM);
> +		if (read_sysreg_s(SYS_MPAMIDR_EL1) & MPAMIDR_EL1_HAS_HCR)
> +			host_data_set_flag(HAS_MPAM_HCR);
> +	}
> +
>  	if (!is_kernel_in_hyp_mode())
>  		cpu_init_hyp_mode();
>  }
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 1ce7130e25490..c7adf8c206d84 100644
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
> +	if (host_data_test_flag(HAS_MPAM_HCR)) {
>  		write_sysreg_s(MPAMHCR_EL2_TRAP_MPAMIDR_EL1, SYS_MPAMHCR_EL2);
>  	} else {
> -		/* From v1.1 TIDR can trap MPAMIDR, set it unconditionally */
> +		/*
> +		 * TIDR is RES0 without MPAMIDR_EL1.HAS_TIDR, which MPAM v1.0
> +		 * prohibits: such a PE without HAS_HCR can't trap MPAMIDR_EL1.
> +		 */
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
> +	if (host_data_test_flag(HAS_MPAM_HCR))
>  		write_sysreg_s(MPAMHCR_HOST_FLAGS, SYS_MPAMHCR_EL2);
>  }
>  
> 
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935

