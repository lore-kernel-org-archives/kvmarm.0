Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7079B1D7E41;
	Wed, 18 Mar 2026 17:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773855133; cv=none; b=CVSMzwihxT6XDsUn4dqmS8Wcl4quFJ5sF2ix2EoLQuKfckc1N9YoF+PlstNn+1dN41vYKQV40FpxfBmxtVhuDdg1SGS+Yzyn98624OQd50/fOBB7NhDL36x7OyrOsA8InXqHzItMb51o1JSiZ39aOZHWxYtJIxJoG68ZkXrSsIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773855133; c=relaxed/simple;
	bh=sF/aK8JkOU0ossQCc5sxtIuMz7+kqiKvuKMAv3Qynxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J6yMvCH9qgKMFNvJAkKYSeusOf0KawUhqcmh2RJcJFIcml6ZiZhHP5z4V46yf9S4LyOSFbi+QGv/Rz1g1IccAn2i44GN6Y8ab09HMGN7/ULaXENDXWlv57L+uD7OplZ3dGkx7x2oc1ifmUw9Nv0+/ai4WvFAJZQkGKWcQZvs6Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sn1bQ3Yw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sn1bQ3Yw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10ACBC19421;
	Wed, 18 Mar 2026 17:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773855133;
	bh=sF/aK8JkOU0ossQCc5sxtIuMz7+kqiKvuKMAv3Qynxs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sn1bQ3Yw/xn4wIh0AgdEXcXeiw7P3UstDbxZOyK9hOrkCv/T0+j/AGylz0sKO4tvH
	 mv65wWmYhB5a1VZfnVjCn3rHhYU63qQfFvOClPFD7ldCcRxPnJhYIjBRPxYJypDdd2
	 neF3chlGZLsgpmR7WleIllCCghnUPeb9STIbqacF5QDpf7fwEB2ZwN0zURIQCCgkaH
	 KiMjGn5vQCpvCr6SI+Pu1iNjG0Ffgn6OvmjYtJcsYfGLL9V699gD1kKjtLErQo1SY7
	 pTPbNcXcNG/UinqopKRw+1VzYiwvGro0gOfI+NIdBnGO81ytoqgRobFGpruYakSQgk
	 VZLd17oP0Te8A==
Date: Wed, 18 Mar 2026 17:32:26 +0000
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
Subject: Re: [PATCH v10 07/30] KVM: arm64: Move SVE state access macros after
 feature test macros
Message-ID: <20260318173226.GE2390801@myrica>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-7-43f7683a0fb7@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306-kvm-arm64-sme-v10-7-43f7683a0fb7@kernel.org>

On Fri, Mar 06, 2026 at 05:00:59PM +0000, Mark Brown wrote:
> In preparation for SME support move the macros used to access SVE state
> after the feature test macros, we will need to test for SME subfeatures to
> determine the size of the SME state.
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Jean-Philippe Brucker <jpb@kernel.org>

> ---
>  arch/arm64/include/asm/kvm_host.h | 50 +++++++++++++++++++--------------------
>  1 file changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 2ca264b3db5f..3e7247b3890c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1072,31 +1072,6 @@ struct kvm_vcpu_arch {
>  #define NESTED_SERROR_PENDING	__vcpu_single_flag(sflags, BIT(8))
>  
>  
> -/* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> -#define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
> -			     sve_ffr_offset((vcpu)->arch.sve_max_vl))
> -
> -#define vcpu_sve_max_vq(vcpu)	sve_vq_from_vl((vcpu)->arch.sve_max_vl)
> -
> -#define vcpu_sve_zcr_elx(vcpu)						\
> -	(unlikely(is_hyp_ctxt(vcpu)) ? ZCR_EL2 : ZCR_EL1)
> -
> -#define sve_state_size_from_vl(sve_max_vl) ({				\
> -	size_t __size_ret;						\
> -	unsigned int __vq;						\
> -									\
> -	if (WARN_ON(!sve_vl_valid(sve_max_vl))) {			\
> -		__size_ret = 0;						\
> -	} else {							\
> -		__vq = sve_vq_from_vl(sve_max_vl);			\
> -		__size_ret = SVE_SIG_REGS_SIZE(__vq);			\
> -	}								\
> -									\
> -	__size_ret;							\
> -})
> -
> -#define vcpu_sve_state_size(vcpu) sve_state_size_from_vl((vcpu)->arch.sve_max_vl)
> -
>  #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
>  				 KVM_GUESTDBG_USE_SW_BP | \
>  				 KVM_GUESTDBG_USE_HW | \
> @@ -1132,6 +1107,31 @@ struct kvm_vcpu_arch {
>  
>  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.regs)
>  
> +/* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> +#define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
> +			     sve_ffr_offset((vcpu)->arch.sve_max_vl))
> +
> +#define vcpu_sve_max_vq(vcpu)	sve_vq_from_vl((vcpu)->arch.sve_max_vl)
> +
> +#define vcpu_sve_zcr_elx(vcpu)						\
> +	(unlikely(is_hyp_ctxt(vcpu)) ? ZCR_EL2 : ZCR_EL1)
> +
> +#define sve_state_size_from_vl(sve_max_vl) ({				\
> +	size_t __size_ret;						\
> +	unsigned int __vq;						\
> +									\
> +	if (WARN_ON(!sve_vl_valid(sve_max_vl))) {			\
> +		__size_ret = 0;						\
> +	} else {							\
> +		__vq = sve_vq_from_vl(sve_max_vl);			\
> +		__size_ret = SVE_SIG_REGS_SIZE(__vq);			\
> +	}								\
> +									\
> +	__size_ret;							\
> +})
> +
> +#define vcpu_sve_state_size(vcpu) sve_state_size_from_vl((vcpu)->arch.sve_max_vl)
> +
>  /*
>   * Only use __vcpu_sys_reg/ctxt_sys_reg if you know you want the
>   * memory backed version of a register, and not the one most recently
> 
> -- 
> 2.47.3
> 
> 
