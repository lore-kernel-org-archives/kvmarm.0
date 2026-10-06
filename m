Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40287547073;
	Tue,  6 Oct 2026 13:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791292555; cv=none; b=C0WF7n2rHRb7vOqeFKDjJC6GKk+SAM9RNd9u6lhXeEXU6CBbyVrjqkGOWiFz9UYoK8zzxcacsDqrNjlbE+tBFMKguKYazdBsEAqDqd2cs3FpZ2PFOmBBfai18bXrEJjyO1zalw9VEWMWE/ajwbnDhWZ//HOmMa3bn3PNzK2kQOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791292555; c=relaxed/simple;
	bh=neMEhSy5MC/57V3vC9TzT/YW98aFm8hYdz4c0IFHXFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ekWafqYrohzUy50Sgh9vxM8mWqiyGwtjBzkJn4Nn5WkgyXcKKY5AesfsKcQ1yXS8LLbIMMZfHrGJKvIQ1ZJyDleTfpZhUyomJG8lTQzYu5P8+Lvaxb5BWyl/AwjgiPHPY1m+WYhmZnfFpn2qECfr+PNG+P4JO06Ub8oGAMura+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aBGYT4ts; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aBGYT4ts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9871F000FF;
	Tue,  6 Oct 2026 13:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791292553;
	bh=lPJXXQVjMbcrdoG8rT5He+PCXmg6oCae9J9HjUac2RI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aBGYT4tsSDfzDqI6aslxN4IB9QH6DPgY/M5H8kIcYszHq0vlxvF1gxcTWGS6K9vWm
	 Viqk/JbSr5ZEnozb6gCiA0CGn4SScl/xzQN1W00w44OGjyJCmC+3roKRYnZvkWAQmQ
	 zanWgvP0s9UBcYqIt0FWuQnsr8bRvxOBsxo+uYsPFtV4jz0C0ySWGiomO6mTKjGyWO
	 d2MGJJ1GpDc9b9anHeeIQFTLJzfbXVgnET7S6iDilaKrjxmFoxya2YsyjNMGnVbfcm
	 T2sPhe0xNfFZUsztsDtKRL0O2lWh/bQQnwUixTvHcW0Ah6bmtdAWAfeihXmW9yQhE7
	 vlm3hjziMvpbg==
Date: Tue, 6 Oct 2026 06:15:47 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	vdonnefort@google.com, qperret@google.com, mark.rutland@arm.com,
	tabba@google.com
Subject: Re: [PATCH v2] KVM: arm64: Mask SErrors in a protected vCPU's host
 copy at first run
Message-ID: <asT0g8CcKoXBAmfi@kernel.org>
References: <20261006092826.2201763-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006092826.2201763-1-fuad.tabba@linux.dev>

Hi Fuad,

On Tue, Oct 06, 2026 at 10:28:26AM +0100, Fuad Tabba wrote:
> The host's copy of a protected vCPU has SErrors masked from reset, so a
> host-injected SError is pended through HCR_EL2.VSE and the guest takes
> it when it unmasks SErrors. However, the VMM can unmask SErrors in that
> copy before the first run, through PSTATE.A or SCTLR2_EL1.NMEA. KVM
> then emulates the SError's entry on the host copy, and the guest never
> takes it as an SError. Exits that copy PSTATE out set PSTATE.A again,
> but nothing clears NMEA. With NMEA set, an SError injected after a
> KVM_RUN that completes an MMIO access but returns before entering the
> guest also trips WARN_ON(INCREMENT_PC).
> 
> Mask SErrors in the host copy when the first run creates the hyp vCPU,
> after which KVM_SET_ONE_REG is rejected. An SError injected before then
> is still emulated, but only writes registers the VMM can set itself.
> 
> Fixes: 872383bd12e11 ("KVM: arm64: Add per-EC entry/exit state marshalling for protected guests")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/all/20261001142109.794CA1F000FF@smtp.kernel.org/
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
> v2:
>  - Set PSTATE.A and clear SCTLR2_EL1.NMEA in the host copy when the hyp
>    vCPU is created, instead of testing vcpu_is_protected() in
>    kvm_inject_serror_esr() (Marc).
> 
> Applies on kvmarm/next. A follow-up to "KVM: arm64: Confine protected VM
> vCPU state to EL2" [1], from Sashiko's review of its v4 patch 12.
> 
> v1: https://lore.kernel.org/r/20261005050352.836980-1-fuad.tabba@linux.dev/
> [1] https://lore.kernel.org/all/20261001135711.1640520-1-fuad.tabba@linux.dev/
> 
>  arch/arm64/kvm/pkvm.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index d4822d8bb16b8..49973c689789f 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -191,12 +191,18 @@ static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
>  	/*
>  	 * Mirror EL2's seeding of power_state from mp_state. The hyp vCPU is
>  	 * published, so take mp_state_lock against kvm_psci_vcpu_on().
> +	 *
> +	 * EL2 never reads the VMM's PSTATE or SCTLR2_EL1: undo any unmasking
> +	 * so that a host SError is pended through HCR_EL2.VSE.
>  	 */
>  	if (vcpu_is_protected(vcpu)) {
>  		spin_lock(&vcpu->arch.mp_state_lock);
>  		if (kvm_arm_vcpu_stopped(vcpu))
>  			WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_UNINITIALIZED);
>  		spin_unlock(&vcpu->arch.mp_state_lock);
> +
> +		*vcpu_cpsr(vcpu) |= PSR_A_BIT;
> +		__vcpu_rmw_sys_reg(vcpu, SCTLR2_EL1, &=, ~SCTLR2_EL1_NMEA);
>  	}

Urgh, I hadn't realized that PSTATE.A is still modifiable by userspace
prior to KVM_RUN. In that case, I would prefer the vcpu_has_nv()
approach that I had recommended as a backup.

FWIW, since pVMs do not implement FEAT_SCTLR2 it should not be able to
write to the register at all.

Thanks,
Oliver
