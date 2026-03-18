Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D77357A3E;
	Wed, 18 Mar 2026 17:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773856385; cv=none; b=EO9B0qDwhHuEI6swsEBzJYrI2c2l/V4LLVioJl4RMUOIHCZKNtEHkC076YOaGzpzDSlF9c/cwtBGTepd2f/bnASfO7bflAXjZueeAyAKHPl5mdHvSEgNtX5rRku9KHguJEJ5LYmQMHxaAmxY5TgmrSEACAT59OB0IB9e1zANWVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773856385; c=relaxed/simple;
	bh=/FtksUb0vQYznzFRIPfR9MewstAW7yg/M3ruCi0rssc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d5StQAE34z5C1x6wCWV8DePVyN1NoaCVVDQ1cA6uRD17A5mBxQSp5jPckSlT2WbpBhUNZRpTAwuIyO8n5jCmRC7nI4Z/jtOExUj77/tVLTR4r7T4hAt9al13DeJ+MxwoCNY+O58Gdyas/FFGazhjhEe+oDUz8zjfn9+/JhNLX7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kFWnYb+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kFWnYb+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C93C2BC87;
	Wed, 18 Mar 2026 17:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773856385;
	bh=/FtksUb0vQYznzFRIPfR9MewstAW7yg/M3ruCi0rssc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kFWnYb+fmbVaJ6RkkS/aTh8s2lU9oOFpaeQZ8BFoIRf61pruYIez+L5kWVn82fD4c
	 m1Dvg328rpKYz904q8wlIixVX9HUcOHsSJ/yNYHMX4C1Ff5PJV1RO/pEvAjPC4l6WF
	 YEuwqNGBNMnlCFsngSIdRbtRbFl8PibcCthdbQoVTsQyEX1xN/jRp885JJ7zak7nW+
	 oO6c0EulR8vnOjapPCBk0x9+abuzMvfbVh1PEXlBNK1qlXAtkg/X6nppcuPO4D77y7
	 8Rpd4E4QZMUpIPDVAUUv/qDkQhEcYQ4rNT6lvrYvG0pC3wckBK8N2NDEuyZrm83Qy7
	 jIXri9couDKNA==
Date: Wed, 18 Mar 2026 17:53:17 +0000
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
Subject: Re: [PATCH v10 14/30] KVM: arm64: Implement SME vector length
 configuration
Message-ID: <20260318175317.GL2390801@myrica>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-14-43f7683a0fb7@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306-kvm-arm64-sme-v10-14-43f7683a0fb7@kernel.org>

On Fri, Mar 06, 2026 at 05:01:06PM +0000, Mark Brown wrote:
> +#define vcpu_max_vl(vcpu) max(vcpu_sve_max_vl(vcpu), vcpu_sme_max_vl(vcpu))
> +#define vcpu_max_vq(vcpu) sve_vq_from_vl(vcpu_max_vl(vcpu))
> +
> +/* Current for the hypervisor */

Not sure what this means, isn't it also current for the guest?

> +#define vcpu_cur_sve_vl(vcpu) (vcpu_in_streaming_mode(vcpu) ? \
> +			       vcpu_sme_max_vl(vcpu) : vcpu_sve_max_vl(vcpu))
> +
> +/* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> +#define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
> +			     sve_ffr_offset(vcpu_cur_sve_vl(vcpu)))
>  
>  #define vcpu_sve_zcr_elx(vcpu)						\
>  	(unlikely(is_hyp_ctxt(vcpu)) ? ZCR_EL2 : ZCR_EL1)
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index c67564f02981..498a49a61487 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -354,6 +354,15 @@ struct kvm_arm_counter_offset {
>  #define KVM_ARM64_SVE_VLS_WORDS	\
>  	((KVM_ARM64_SVE_VQ_MAX - KVM_ARM64_SVE_VQ_MIN) / 64 + 1)
>  
> +/* SME registers */
> +#define KVM_REG_ARM64_SME		(0x17 << KVM_REG_ARM_COPROC_SHIFT)
> +
> +/* Vector lengths pseudo-register: */
> +#define KVM_REG_ARM64_SME_VLS		(KVM_REG_ARM64 | KVM_REG_ARM64_SME | \
> +					 KVM_REG_SIZE_U512 | 0xfffe)
> +#define KVM_ARM64_SME_VLS_WORDS	\
> +	((KVM_ARM64_SVE_VQ_MAX - KVM_ARM64_SVE_VQ_MIN) / 64 + 1)

I think this could be removed: it's never used and the doc describes only
SVE_VLS_WORDS for both SME and SVE. Maybe we could have a "VEC_VLS_WORDS"
alias but using the SVE one seems fine to me.

Rest looks good

Thanks,
Jean`
