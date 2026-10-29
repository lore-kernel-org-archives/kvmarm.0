Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793296997;
	b=zVZLv92x0TWbzBEIRk7oSj74FQSJWg1U2qdWG5uCsuUxHlEeVWgSN0TXJE99S/I+mtzQ
	 2CsTf93jC1iVY2o/u0bf06tVPTOfS+CHoCqGe6eSsrv9cyERt20Ojzkz9FvUIZdDZQ6c9
	 YnnWB+TiqXj74tma/gLXDwd0GaphZ6zIHuACtXg1oZ/lHTxqmybwcF/4GBRcGXux7PF+W
	 bJdZ42QEni8mj5ekVjPBD0kvIoHfxCAweXyLCBI77voTSyudlwsPrURGGan6SCsek5t+0
	 fKp8qrXS3c83yyKOlLfagbw0lD8ZqPjgbP9YK2iAUB0CFd1eJXsidYqZLadVD3WBM8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793296997;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=+BSfrJ0Fvk6pE1EEg+dZVSHnO3k4S6/t9PQDyacXF7o=;
	b=CMmlAxhPPyt57fVO3OCORTEqavxNzxBLZj6jNHem81UWpjr/FSYNgTFIxpbvnWrDn3ah
	 qtFW7Oyp5haHnbd5DU89Y6+EzdgJHqLt21NDWNPwWl3q45E0LTViioxnAcCr/NTA7v69z
	 +zmvE7FONGZkz0h7FGaiHMe3WjxIpR8fL0X2a4eflE9Ei6m38Cr4caM+0VA/sxk8qQd2a
	 /mzlhg4Jf7xCEgSfl2qbCPNZpIYEztn+1ds7MZqOoPe1VbxUGZey0baM2+Cp0PHHGdnDy
	 TkDSDfn+D2Bi4myZjfM0BI8GdTe7Z8gBDLY3VxRyP01BOajQT8O4765JRrLekpzxEQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KYJwYCEl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8271606A334;
	Thu, 29 Oct 2026 18:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KYJwYCEl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3441F01824;
	Thu, 29 Oct 2026 18:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793296996;
	bh=+BSfrJ0Fvk6pE1EEg+dZVSHnO3k4S6/t9PQDyacXF7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KYJwYCElxdxWS679xOjC48/NIm/L2CqIDBLv8s8E+xU+vA+JqOfQHYixNUrQ0LzSY
	 ItBepWZ6kKBBsr4E4tqXhGlEN/SnGuJgbAu0MTHIZ5BpcmzAlyzCL5huyegq4rEgh4
	 ynKngZe7bRWzBHriiddEXebJEzThkroDmdl/3RzHf92eoIXv/D/ziF6MZxsJ+nyZbs
	 6viFG1bK85EegdzHqSzwVNmESgMVIh77mXg9zSpnGNYnZlGph1vSpyWFhzQ3es0EOp
	 LojqonfL/BvpvedyLH+EnNpRxqj+05ddEKLbEvZpMxUDI5sGb+uKqr2pnv0j6zjVec
	 Qqu9+5Uyd4P5A==
Date: Thu, 29 Oct 2026 18:03:09 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org, Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [RFC PATCH v7 14/28] KVM: arm64: Add SPE VCPU device attribute
 to initialize SPE
Message-ID: <auOG5W5hxDVYL-hh@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-15-alexandru.elisei@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-15-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:06:09PM +0100, Alexandru Elisei wrote:
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 8ffa3e89d38c..c695aae484d3 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -449,6 +449,7 @@ enum {
>  #define KVM_ARM_VCPU_SPE_CTRL		3
>  #define   KVM_ARM_VCPU_SPE_IRQ		0
>  #define   KVM_ARM_VCPU_SPE_ID		1
> +#define   KVM_ARM_VCPU_SPE_INIT		2
>
>  /* KVM_IRQ_LINE irq field index values */
>  #define KVM_ARM_IRQ_VCPU2_SHIFT		28
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 132df44c3088..c9a026c61ce7 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1026,6 +1026,12 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>  			return ret;
>  	}
>
> +	if (vcpu_has_spe(vcpu)) {
> +		ret = kvm_spe_vcpu_first_run_init(vcpu);
> +		if (ret)
> +			return ret;
> +	}
> +

So, staring at patch 18 made me think about ordering again, which seems to be
_super_ sensitive in KVM :)

The next patch in the series (15) makes PMSVer depend on the SPE instance having
been assigned via KVM_ARM_VCPU_SPE_ID.

But you can still KVM_RUN before KVM_ARM_VCPU_SPE_INIT, which means this will
return -EINVAL:

int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
{
	...
	if (!kvm_vcpu_spe_initialized(vcpu))
		return -EINVAL;
	...
}

And this is quite far down the function:

int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
{
	struct kvm *kvm = vcpu->kvm;
	int ret;

	if (!kvm_vcpu_initialized(vcpu))
		return -ENOEXEC;

	if (!kvm_arm_vcpu_is_finalized(vcpu))
		return -EPERM;

	if (likely(vcpu_has_run_once(vcpu)))
		return 0;

	...

	ret = kvm_vcpu_finalize_sys_regs(vcpu);
	if (ret)
		return ret;

	...

	/*
	 * This needs to happen after any restriction has been applied
	 * to the feature set.
	 */
	kvm_calculate_traps(vcpu);

	...

	if (vcpu_has_spe(vcpu)) {
		ret = kvm_spe_vcpu_first_run_init(vcpu);
		if (ret)
			return ret;
	}

	...
}

patch 18 made me think of this as kvm_calculate_traps() does the FGU
initialisation (which derives from SPE state), and once done sets
KVM_ARCH_FLAG_FGU_INITIALIZED, meaning this state is incorrectly setup.

This is a real problem as HAS_RAN_ONCE isn't set on that failed path,
userland can finish the SPE setup, set KVM_ARCH_FLAG_FGU_INITIALIZED, and
that state is never recomputed.

Also kvm_vcpu_finalize_sys_regs() calls kvm_spe_finalize_idregs() (via
kvm_vm_finalize_sys_regs()) which writes PMSVer in the first place.

So it seems you should put this check _before_ these, e.g.:

int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
{
	struct kvm *kvm = vcpu->kvm;
	int ret;

	if (!kvm_vcpu_initialized(vcpu))
		return -ENOEXEC;

	if (!kvm_arm_vcpu_is_finalized(vcpu))
		return -EPERM;

	if (likely(vcpu_has_run_once(vcpu)))
		return 0;

	...

>>>>
	if (vcpu_has_spe(vcpu)) {
		ret = kvm_spe_vcpu_first_run_init(vcpu);
		if (ret)
			return ret;
	}
>>>

	ret = kvm_vcpu_finalize_sys_regs(vcpu);
	if (ret)
		return ret;

	...

	/*
	 * This needs to happen after any restriction has been applied
	 * to the feature set.
	 */
	kvm_calculate_traps(vcpu);

	...

}

--
Cheers, Lorenzo
