Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CDA355F2E;
	Wed, 18 Mar 2026 17:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773856174; cv=none; b=PGvsrWmTL/SmZkSM9IwjUzUKUHUpRpMdispCHMXQC+i4mN/ZLmr9dj9XJ1yrMuuHMYdqjCnjNS2olPymQN9QX3hwtSLlsslcqVIcpRWVx3k7gXy3i5NuQBVd51GDK99WQ7zDfA/oLXbXrlXbkLcXrsXIhXgv84OeI3mmbprSV5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773856174; c=relaxed/simple;
	bh=wT/iYNzCm2V9NPLbTEHHOe/QpojvcSnk86PQ+66AEt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LrSRj2KKDV7wl7YKeH3zXVBakutM+UbzFiVU1zF5QhTmM0O2Bs6j5H6K6uMfxPVi7SFzPjtvK9PU0+uiQJJ1Yj0rsJS6fxQ0znFVEU+7kRu3+xoLi0ntnh0UOQ6xicULshGUItB8BxbAgiNBSjFrd47w0S87+LPHuOsUPxEVKfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jkSQV6tw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jkSQV6tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF2CC2BCAF;
	Wed, 18 Mar 2026 17:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773856173;
	bh=wT/iYNzCm2V9NPLbTEHHOe/QpojvcSnk86PQ+66AEt4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jkSQV6twayNsM864uyXHJbD3Bz09Zv3RgGje9V3ZbME8R/H1Wh1obgiGhENM+mggW
	 D5ABCcEiuY5rZeHWUNjiyLOpjfOczS0ca6yNrSRX1Rr0r4vL4Ya/GVwnTxaB09HX3Y
	 EV0u7knDwunWhKyXhLzFTXZ4MPZOFTT5szpZn0dgZHQeJXD72GZhwujl8G3tbxZlo1
	 lgnHzLej7fBKuQKZZ8br9V3tdiJRm5POUPxOJvnqXb//ozruODKZ+3iFXOb7rRed4w
	 IffUWkwA6iRO/DW2NQihZNs7JzfIcHAZ6Zb87phBm9GB52j3cSNwRiLQkQZtRDAADg
	 dqnhkjtDLNflA==
Date: Wed, 18 Mar 2026 17:49:46 +0000
From: Jean-Philippe Brucker <jpb@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Mark Rutland <mark.rutland@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v10 12/30] KVM: arm64: Factor SVE code out of
 fpsimd_lazy_switch_to_host()
Message-ID: <20260318174946.GJ2390801@myrica>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-12-43f7683a0fb7@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306-kvm-arm64-sme-v10-12-43f7683a0fb7@kernel.org>

On Fri, Mar 06, 2026 at 05:01:04PM +0000, Mark Brown wrote:
> Since the function will grow as a result of adding SME support move the
> SVE code out of fpsimd_lazy_switch_to_host(). No functional change, just
> code motion.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Jean-Philippe Brucker <jpb@kernel.org>

>  arch/arm64/kvm/hyp/include/hyp/switch.h | 46 +++++++++++++++++++--------------
>  1 file changed, 26 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 4e38610be19a..5b99aa479c59 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -483,11 +483,11 @@ static inline void fpsimd_lazy_switch_to_guest(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> -static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
> +static inline void sve_lazy_switch_to_host(struct kvm_vcpu *vcpu)
>  {
>  	u64 zcr_el1, zcr_el2;
>  
> -	if (!guest_owns_fp_regs())
> +	if (!vcpu_has_sve(vcpu))
>  		return;
>  
>  	/*
> @@ -498,29 +498,35 @@ static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
>  	 * synchronization event, we don't need an ISB here to avoid taking
>  	 * traps for anything that was exposed to the guest.
>  	 */
> -	if (vcpu_has_sve(vcpu)) {
> -		zcr_el1 = read_sysreg_el1(SYS_ZCR);
> -		__vcpu_assign_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu), zcr_el1);
> +	zcr_el1 = read_sysreg_el1(SYS_ZCR);
> +	__vcpu_assign_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu), zcr_el1);
>  
> -		/*
> -		 * The guest's state is always saved using the guest's max VL.
> -		 * Ensure that the host has the guest's max VL active such that
> -		 * the host can save the guest's state lazily, but don't
> -		 * artificially restrict the host to the guest's max VL.
> -		 */
> -		if (has_vhe()) {
> -			zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
> -			write_sysreg_el2(zcr_el2, SYS_ZCR);
> -		} else {
> -			zcr_el2 = sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SVE]) - 1;
> -			write_sysreg_el2(zcr_el2, SYS_ZCR);
> +	/*
> +	 * The guest's state is always saved using the guest's max VL.
> +	 * Ensure that the host has the guest's max VL active such
> +	 * that the host can save the guest's state lazily, but don't
> +	 * artificially restrict the host to the guest's max VL.
> +	 */
> +	if (has_vhe()) {
> +		zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
> +		write_sysreg_el2(zcr_el2, SYS_ZCR);
> +	} else {
> +		zcr_el2 = sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SVE]) - 1;
> +		write_sysreg_el2(zcr_el2, SYS_ZCR);
>  
> -			zcr_el1 = vcpu_sve_max_vq(vcpu) - 1;
> -			write_sysreg_el1(zcr_el1, SYS_ZCR);
> -		}
> +		zcr_el1 = vcpu_sve_max_vq(vcpu) - 1;
> +		write_sysreg_el1(zcr_el1, SYS_ZCR);
>  	}
>  }
>  
> +static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
> +{
> +	if (!guest_owns_fp_regs())
> +		return;
> +
> +	sve_lazy_switch_to_host(vcpu);
> +}
> +
>  static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
>  {
>  	/*
> 
> -- 
> 2.47.3
> 
> 
