Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E499F436370
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 11:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783509522; cv=none; b=CJVnZdkraoeR/Y15fopb9wxyIxRsM5oA+iKkuNzhmo0Qq6fbzee+/BNGNWnxSugVMPmnfrRQSOZWHJo1Vt4sQ+ciOOP86Nlxxe3gv7rRQbafpjwMgUMf5qnh9gM71+H3YVBmgOVbmvzhXJLjBCU012ZV1/eKdfYYF2E1p4e23H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783509522; c=relaxed/simple;
	bh=Q3mIYycQy8bOLg/worl5ZK/PQN7XNptnDVDQhCRzReM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yix1TSyjHweSIOcH9oMlDttaCTX+9Ngf9Y2JSJ8KyyiOY5sgJ2fUDVM8FBWq07EXkNvtzvedMi6SJFcMUWuUHeAB+dzpffahXjHMk6q/IZ3Xr14pyzK6NJTQ0Pb1AiN4zTX4C3oNWuIW+w2ds4W5xqJ1xtpOITOUebyN6+UHOk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=X9En1xPY; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="X9En1xPY"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A96B71516;
	Wed,  8 Jul 2026 04:18:34 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.2.213.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8BAA73F85F;
	Wed,  8 Jul 2026 04:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783509519; bh=Q3mIYycQy8bOLg/worl5ZK/PQN7XNptnDVDQhCRzReM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X9En1xPYusv8IDZUhoObjF477Iwi+uP/2tcsxErNG3U1j4VAUJ3/e3FZ16l4tSQ43
	 Jkvjm9GWmNxtp09fyP2qj3CQ0aKO/sEr2f2AjcjTcFwgRkRn3UUW4cvnY6Vj1yfhtn
	 L7fOug012cdLeudm56L6DVc3F+m2flj3MBom21pg=
Date: Wed, 8 Jul 2026 12:18:32 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 19/28] KVM: arm64: Make HCR_EL2 a non-VNCR register
Message-ID: <20260708111832.GA99849@e124191.cambridge.arm.com>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-20-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702160248.1377250-20-maz@kernel.org>

On Thu, Jul 02, 2026 at 05:02:39PM +0100, Marc Zyngier wrote:
> FEAT_NV3 makes a fundamental change to the architecture, by moving
> guest-initiated HCR_EL2 accesses to the NVHCR_EL2 register. As the
> names suggests, this is HCR_EL2 for a NV guest.
> 
> But where do NVHCR_EL2 accesses from a guest go? The are redirected
> to the VNCR page, right where HCR_EL2 is stored in the NV2 case.
> Does it hurt? Good. There's more coming.
> 
> The challenge here is to make KVM work seamlessly, without rewriting
> everything. Which implies that things such as __vcpu_sys_reg(HCR_EL2)
> must work, no matter the underlying NV implementation.
> 
> A simple way to deal with it is to move HCR_EL2's canonical storage
> outside of VNCR for the vast majority of the KVM code, and only have
> a copy at entry/exit times. Given that we don't really support NV3
> yet, this is pretty simple.
> 
> In the process, advertise NVHCR_EL2 as the register that now holds
> offset 0x78 in the VNCR page.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/include/asm/kvm_host.h     | 3 ++-
>  arch/arm64/include/asm/vncr_mapping.h | 2 +-
>  arch/arm64/kvm/hyp/vhe/switch.c       | 9 +++++++++
>  3 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index bae2c4f92ef5c..2648c8a717ba0 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -543,6 +543,7 @@ enum vcpu_sysreg {
>  	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
>  	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
>  	ZCR_EL2,	/* SVE Control Register (EL2) */
> +	HCR_EL2,	/* Hypervisor Control Register */
>  
>  	/* Any VNCR-capable reg goes after this point */
>  	MARKER(__VNCR_START__),
> @@ -571,7 +572,7 @@ enum vcpu_sysreg {
>  	VNCR(TFSR_EL1),	/* Tag Fault Status Register (EL1) */
>  	VNCR(VPIDR_EL2),/* Virtualization Processor ID Register */
>  	VNCR(VMPIDR_EL2),/* Virtualization Multiprocessor ID Register */
> -	VNCR(HCR_EL2),	/* Hypervisor Configuration Register */
> +	VNCR(NVHCR_EL2),/* NV Hypervisor Configuration Register */
>  	VNCR(HSTR_EL2),	/* Hypervisor System Trap Register */
>  	VNCR(VTTBR_EL2),/* Virtualization Translation Table Base Register */
>  	VNCR(VTCR_EL2),	/* Virtualization Translation Control Register */
> diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
> index 14366d35ce82f..9e8a49fa8b638 100644
> --- a/arch/arm64/include/asm/vncr_mapping.h
> +++ b/arch/arm64/include/asm/vncr_mapping.h
> @@ -11,7 +11,7 @@
>  #define VNCR_VTCR_EL2           0x040
>  #define VNCR_VMPIDR_EL2         0x050
>  #define VNCR_CNTVOFF_EL2        0x060
> -#define VNCR_HCR_EL2            0x078
> +#define VNCR_NVHCR_EL2          0x078
>  #define VNCR_HSTR_EL2           0x080
>  #define VNCR_VPIDR_EL2          0x088
>  #define VNCR_TPIDR_EL2          0x090
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 8268779df4fa9..05bcf8bf7f978 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -70,6 +70,9 @@ static u64 __compute_hcr(struct kvm_vcpu *vcpu)
>  		if (!vcpu_el2_e2h_is_set(vcpu))
>  			hcr |= HCR_NV1;
>  
> +		/* Publish the guest's view of HCR_EL2 to the HW */
> +		__vcpu_assign_sys_reg(vcpu, NVHCR_EL2, __vcpu_sys_reg(vcpu, HCR_EL2));
> +
>  		/*
>  		 * Nothing in HCR_EL2 should impact running in hypervisor
>  		 * context, apart from bits we have defined as RESx (E2H,
> @@ -547,6 +550,7 @@ static void fixup_nv_guest_exit(struct kvm_vcpu *vcpu)
>  	 */
>  	if (unlikely(host_data_test_flag(VCPU_IN_HYP_CONTEXT))) {
>  		u64 mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
> +		u64 hcr;
>  
>  		switch (mode) {
>  		case PSR_MODE_EL1t:
> @@ -559,6 +563,11 @@ static void fixup_nv_guest_exit(struct kvm_vcpu *vcpu)
>  
>  		*vcpu_cpsr(vcpu) &= ~(PSR_MODE_MASK | PSR_MODE32_BIT);
>  		*vcpu_cpsr(vcpu) |= mode;
> +
> +		/* Publish the latest HCR_EL2 to the emulation */
> +		hcr = __vcpu_sys_reg(vcpu, NVHCR_EL2);

My alarm bells went off reading this, because the context (in-memory) seemed
wrong, but I see that patch 23 further modifies this for NV3!

> +
> +		__vcpu_assign_sys_reg(vcpu, HCR_EL2, hcr);
>  	}
>  
>  	/* Apply extreme paranoia! */
> -- 
> 2.47.3
> 
