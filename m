Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2853D21ABC1;
	Thu, 29 May 2025 12:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748521080; cv=none; b=OLevuZiyMG+8TDJvy/pr/UZdk0H22uqY/GNhtxQLe977XvRiQ7wpkmQQ6C6mKq0oyW/ph6DyyRZRHFj81+6n3Tjti+0wFZpZqSGntQCn6+EjCLv3gTqtDdXRgm2NOd+ZSM2Ezc21nCL0NdqN5YeEGAqAYJmFp8riJvka85W4OOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748521080; c=relaxed/simple;
	bh=T9ZQY4CGugD2MH+iTUeDacs8pgXvAPcZYmxnuyRAiSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CCtYhs0UmgVO1scFKx3y7GDxR+GvDj75A6cR53+jUaOwTUnjOV2SB0eIu/fGTRXixE4EwBuPDALeNhNAgDsRTECD9elumIuVactNV1qqjr0I17ErTetuaxZzW5xZkUMiwuJTDY+S0LVVr/V0Y57mQL7kmV4aA06BojmwSATzo68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ASMqB7f4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ASMqB7f4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91365C4CEE7;
	Thu, 29 May 2025 12:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748521079;
	bh=T9ZQY4CGugD2MH+iTUeDacs8pgXvAPcZYmxnuyRAiSU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ASMqB7f4OJsnn10KsXlKeQM/6y2euEGVS1tST7xQP41q2zFYIFm2pMkZYy0KeKxlv
	 lRyrOX1aodcUCzR/FXUyNQcsj8bPBY7XP+lKehhvIqua5iyr05BmGjtt6STEtWzXOX
	 2esSec+XG+Iy5UQE4hSECHcaRkfe278g2RlaECY+mljC000Rh33knCq0XcPookZng5
	 mOhHU8huR6bsWDo29BaNgX6/pYnltWyWmdtlxLPpYmyzIMSRN9Q8T8TFKjgLsaZawi
	 Bz/yI4DVbNjiqyL8vru1iItVnVjH43YjHF/4CDlhcD5BBTZjdUQaG+e5woFS2c+wbV
	 rAKKNUd3UN83g==
Date: Thu, 29 May 2025 13:17:52 +0100
From: Will Deacon <will@kernel.org>
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, sebastianene@google.com,
	qperret@google.com, qwandor@google.com, arve@android.com,
	perl@immunant.com, lpieralisi@kernel.org, kernel-team@android.com,
	tabba@google.com, james.morse@arm.com, armellel@google.com,
	jean-philippe@linaro.org, ahomescu@google.com
Subject: Re: [PATCH v4 2/5] KVM: arm64: Zero x4-x7 in ffa_set_retval
Message-ID: <20250529121751.GB29242@willie-the-truck>
References: <20250516-virtio-msg-ffa-v4-0-580ee70e5081@google.com>
 <20250516-virtio-msg-ffa-v4-2-580ee70e5081@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250516-virtio-msg-ffa-v4-2-580ee70e5081@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, May 16, 2025 at 12:14:01PM +0000, Per Larsen via B4 Relay wrote:
> From: Per Larsen <perlarsen@google.com>
> 
> FF-A 1.0 references SMCCC 1.2 (reference [4] on page xi). The results of
> an SMC32/HVC32 are returned in W1-W7 in SMCCC 1.2. However, W4-W7 must be
> preserved unless they contain results according to the function definition.
> 
> ffa_set_retval is commonly used to report FFA_SUCCESS or FFA_ERROR back to
> the caller. FFA_SUCCESS requires that x2-x7 must be zero (MBZ) unless a
> register is explicitly used in the function response. FFA_ERROR requires
> x3-x7 MBZ.
> 
> ffa_set_retval is also used to return results of:
> - FFA_VERSION which requires x1-x7 MBZ
> - FFA_MEM_FRAG_TX which returns FFA_MEM_FRAG_RX or FFA_ERROR.
>   FFA_MEM_FRAG_RAX always requires that x5-x7 MBZ and x4 MBZ
>   at any virtual FF-A instance (applies to kvm).
> 
> Messaging interfaces such as FFA_MSG_SEND_DIRECT_{REQ,REQ2}, will not use
> ffa_set_retval.
> 
> Given the above, it is safe to zero x4-x7 in ffa_set_retval.
> 
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 2c199d40811efb5bfae199c4a67d8ae3d9307357..b3d016bee404ce3f8c72cc57befb4ef4e6c1657f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -101,6 +101,10 @@ static void ffa_set_retval(struct kvm_cpu_context *ctxt,
>  	cpu_reg(ctxt, 1) = res->a1;
>  	cpu_reg(ctxt, 2) = res->a2;
>  	cpu_reg(ctxt, 3) = res->a3;
> +	cpu_reg(ctxt, 4) = 0;
> +	cpu_reg(ctxt, 5) = 0;
> +	cpu_reg(ctxt, 6) = 0;
> +	cpu_reg(ctxt, 7) = 0;
>  }

Hmm. On reflection, isn't the root of the problem actually that we're
using SMCCC 1.1 to communicate with TZ, whereas FF-A requires SMCCC 1.2
(and we even enforce that in hyp_ffa_init())?

If we moved all of the hyp FF-A code over to SMCCC 1.2 unconditionally,
then we could just assign everything from res back to the CPU context
without having to worry about zeroing. That would also simplify your
later patches because we wouldn't have to deal with SMCCC 1.1 at all.

I'm aware that we're carrying a patch in Android to permit SMCCC 1.1,
but that's only for Pixel 6 iirc and we shouldn't worry about that
upstream.

Will
