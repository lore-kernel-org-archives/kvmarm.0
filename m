Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873E936C
	for <kvmarm@lists.linux.dev>; Thu,  5 Dec 2024 00:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733358388; cv=none; b=VunyEVswOMr1keHujqLEEktx0LBaw/68WcK051Uea50wSpfW0VSmvfj+uhC6pbva8mMMio1n+FRXJbbdEpmJiUvX7bddkR+GbBbVWzNGpNimZOlsXW/LbPgxtNL5+WtxoFIvPY2/O35mTAuO8egPihsYtLLwCyNZT9jJiZ9Gw9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733358388; c=relaxed/simple;
	bh=XCkrCQ2f/9vOpVWkxECETGiqv8L6UxPIJxiXovhru2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ct1CuUnbmASTsm1Tjsq0tg5KK6y7qhFxetYnnLLB3PmbbUugfiqYPa8zEGQx0GDwZO0zJz7UzmN8qq2mxV6Zh4/uDaFZb9tonDEjKR5h04XB1Ik8WwfgWXh5vBqXcOCH9zgpFBLwywjLhrmuOifH3NX77dPe1dXvJlNDVnWhVuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NwDU9FQI; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NwDU9FQI"
Date: Wed, 4 Dec 2024 16:26:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733358381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F5r6szPNnorsqIWpPC+AQkvg5kKkB5X+Ow8aOshGuD0=;
	b=NwDU9FQIwoub1Gg6x2WTmSKJlM3Vv1CCwTH0gdQv3lxYpy0GYCXYNJW4L5WJKA2Y6sY9v0
	7hnfnX7N++NtUa91/EOBAjXqVjsyInmUbGxW1DdODnGteUn9kaVQnBkX1LESOwCGHkWvtQ
	3OSVqrt03bSDzkTEL29MjMXmQur6YSY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 02/11] KVM: arm64: nv: Sync nested timer state with
 FEAT_NV2
Message-ID: <Z1DzI75XOcJVHARq@linux.dev>
References: <20241202172134.384923-1-maz@kernel.org>
 <20241202172134.384923-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241202172134.384923-3-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 02, 2024 at 05:21:25PM +0000, Marc Zyngier wrote:
> Emulating the timers with FEAT_NV2 is a bit odd, as the timers
> can be reconfigured behind our back without the hypervisor even
> noticing. In the VHE case, that's an actual regression in the
> architecture...
> 
> Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arch_timer.c  | 44 ++++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/arm.c         |  3 +++
>  include/kvm/arm_arch_timer.h |  1 +
>  3 files changed, 48 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 1215df5904185..81afafd62059f 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -905,6 +905,50 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>  		kvm_timer_blocking(vcpu);
>  }
>  
> +void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * When NV2 is on, guest hypervisors have their EL0 timer register
> +	 * accesses redirected to the VNCR page. Any guest action taken on
> +	 * the timer is postponed until the next exit, leading to a very
> +	 * poor quality of emulation.
> +	 */
> +	if (!is_hyp_ctxt(vcpu))
> +		return;
> +
> +	if (!vcpu_el2_e2h_is_set(vcpu)) {
> +		/*
> +		 * A non-VHE guest hypervisor doesn't have any direct access
> +		 * to its timers: the EL2 registers trap (and the HW is
> +		 * fully emulated), while the EL0 registers access memory
> +		 * despite the access being notionally direct. Boo.
> +		 *
> +		 * We update the hardware timer registers with the
> +		 * latest value written by the guest to the VNCR page
> +		 * and let the hardware take care of the rest.
> +		 */
> +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTV_CTL_EL0),  SYS_CNTV_CTL);
> +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTV_CVAL_EL0), SYS_CNTV_CVAL);
> +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTP_CTL_EL0),  SYS_CNTP_CTL);
> +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTP_CVAL_EL0), SYS_CNTP_CVAL);
> +	} else {
> +		/*
> +		 * For a VHE guest hypervisor, the EL2 state is directly
> +		 * stored in the host EL0 timers, while the emulated EL0
> +		 * state is stored in the VNCR page. The latter could have
> +		 * been updated behind our back, and we must reset the
> +		 * emulation of the timers.
> +		 */

nitpick: s/host EL0/EL1/

At least in the way the architecture terms it there's no such thing as
an EL0 timer, and "host EL0" might lead one to think of ELIsInHost(EL0)

-- 
Thanks,
Oliver
