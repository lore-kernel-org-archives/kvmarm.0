Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5677C4BD793;
	Mon, 28 Sep 2026 13:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790602006; cv=none; b=gXFvY5s8Mj/AV1sGvQBQCtpoCNM4OuqX3RGPlr62wtpv2jRyAbt/IibNwxDtbSelD2yo5kXlevQPQw27sLiyMvhvF+v8WbVSRVZ3kYoIwnAq1DOrfcjC1HTA+gYNxn+bxY3joSt0FYpxgj8PscKTU8hzroB3Dbv2IC6uEL1T20A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790602006; c=relaxed/simple;
	bh=hjsQqTHihYZWFjhW+yJ8YIGN09ZHZdnT15Bxrv64Bo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JoodfmVj6dvICZ1Kb9Qy6NOS294UyM0ZZpueKpFuYtLWUY+fNRAFxO8IIMliO1P+QElRb4OlWmB6sFIp1puVwg1XH7/NIbtPEMSqQOwi6xN5UXSJ2BoQjuEwiTn0J+uTw0y3n2u2ui34PkmSVZus/YOX7My21OEW5QgZOJBnoRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lH3vmEnW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lH3vmEnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97251F000FF;
	Mon, 28 Sep 2026 13:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790602005;
	bh=P8XERgof0nTzA/CjinCCycINM3WrSZVuaJDBDhsYGwo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lH3vmEnW30K559b8wdJuikEziIKRuxmX66X5fmLIo0nID/NhQRp82bjndrZ0+VL8b
	 TGaGLNPU9IinQjW3CR2Dv5gBgU3nt770x2+SrMI7srM/ryGtUM/+jNZXplt2LJmvVb
	 UsskaO3acuvgkNy24hsIl4x/6KibUvgONMCDhVTyUqSCYo+F9S0POp9hFzd1unVg4o
	 v/ZEDxJAORasUTlNtdHNcPh9hY2HrTkCsyDouqZuuUFjt13kpkT4/7dJUA75s/2K5R
	 lu3evfy4DN5BDvDYKqXUUrwao35D+BoRiE3iQoPnZO1xr/jt1Em1+axCJ7kab5ly+Y
	 YqyClejbcOXRQ==
Date: Mon, 28 Sep 2026 14:26:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Peter Maydell <peter.maydell@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] KVM: arm64: Finalize guest-wide sysregs prior to
 per-vCPU sysregs
Message-ID: <arpdF-fHx54xWiZB@gremlin>
References: <20260901-kvm-arm64-idreg-final-v3-0-a0ffa06fa872@kernel.org>
 <20260901-kvm-arm64-idreg-final-v3-1-a0ffa06fa872@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-kvm-arm64-idreg-final-v3-1-a0ffa06fa872@kernel.org>

On Tue, Sep 01, 2026 at 07:18:48PM +0100, Mark Brown wrote:
> In commit d82d09d5ba4b ("KVM: arm64: Don't skip per-vcpu NV
> initialisation") the NV register sanitisation was moved earlier in
> kvm_finalize_sys_regs() so that it runs for each vCPU rather than only
> once per guest. This means that for the first vCPU it runs prior to vGIC
> finalization, but the vGIC finalization updates the ID registers which
> the NV initialization uses so we may end up with a mismatch. For
> example, HFGRTR_EL2.ICC_IGRPENn_EL1 depends on GICv3 being enabled in
> ID_AA64PFR0_EL1.GIC so may be mistakenly marked or not marked as RES0.

Hand me some rope here, but I'm thinking this GIC case is because of:

kvm_init_nv_sysregs()
  -> get_reg_fixed_bits(kvm, HFGRTR_EL2)
    -> compute_reg_resx_bits()
      -> compute_resx_bits()
        [ does the dependency checks ]

?

Generally speaking it seems like a good idea that the broader system
registers are set up prior to nested in any case.

>
> Split the initialization which runs once per guest into a separate
> function and run that before the per-vCPU initialisation for NV,
> renaming the per-vCPU function to make it clear that it does per-vCPU
> setup.
>
> Fixes: d82d09d5ba4b ("KVM: arm64: Don't skip per-vcpu NV initialisation")
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Mark Brown <broonie@kernel.org>

One nit below but LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/arm64/kvm/arm.c      |  2 +-
>  arch/arm64/kvm/sys_regs.c | 40 ++++++++++++++++++++++++++--------------
>  arch/arm64/kvm/sys_regs.h |  2 +-
>  3 files changed, 28 insertions(+), 16 deletions(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8b080804bc90..4f044280dec0 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -949,7 +949,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>  			return ret;
>  	}
>
> -	ret = kvm_finalize_sys_regs(vcpu);
> +	ret = kvm_vcpu_finalize_sys_regs(vcpu);
>  	if (ret)
>  		return ret;
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 44aae52c473d..880f84248427 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5861,25 +5861,14 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
>  }
>
>  /*
> - * Perform last adjustments to the ID registers that are implied by the
> + * Do system register finalization that is shared by the whole guest. This
> + * includes last adjustments to the ID registers that are implied by the
>   * configuration outside of the ID regs themselves, as well as any
>   * initialisation that directly depend on these ID registers (such as
>   * RES0/RES1 behaviours). This is not the place to configure traps though.
> - *
> - * Because this can be called once per CPU, changes must be idempotent.
>   */
> -int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
> +static int kvm_vm_finalize_sys_regs(struct kvm *kvm)
>  {
> -	struct kvm *kvm = vcpu->kvm;
> -
> -	guard(mutex)(&kvm->arch.config_lock);

NIT: Maybe worth a comment or an assert that the config_lock is held here?

> -
> -	if (vcpu_has_nv(vcpu)) {
> -		int ret = kvm_init_nv_sysregs(vcpu);
> -		if (ret)
> -			return ret;
> -	}
> -
>  	if (kvm_vm_has_ran_once(kvm))
>  		return 0;
>
> @@ -5931,6 +5920,29 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>
> +/*
> + * Because this can be called once per CPU, changes must be idempotent.
> + */
> +int kvm_vcpu_finalize_sys_regs(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	int ret;
> +
> +	guard(mutex)(&kvm->arch.config_lock);
> +
> +	ret = kvm_vm_finalize_sys_regs(kvm);
> +	if (ret)
> +		return ret;
> +
> +	if (vcpu_has_nv(vcpu)) {
> +		ret = kvm_init_nv_sysregs(vcpu);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  int __init kvm_sys_reg_table_init(void)
>  {
>  	const struct sys_reg_desc *gicv3_regs;
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index bd56a45abbf9..a3cccad2766f 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -254,7 +254,7 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
>
>  bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index);
>
> -int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu);
> +int kvm_vcpu_finalize_sys_regs(struct kvm_vcpu *vcpu);
>
>  #define AA32(_x)	.aarch32_map = AA32_##_x
>  #define Op0(_x) 	.Op0 = _x
>
> --
> 2.47.3
>
>

--
Cheers, Lorenzo
