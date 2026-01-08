Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47553329C7D;
	Thu,  8 Jan 2026 15:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767885987; cv=none; b=KxOx7Yubk88iE0j0jm9xVKsiY0oCckape7wxRL1O3K4rC81G+lSL3fwbLil5HEsI/tkKRsXyKNT1SHVL0EIzFTEjCX5mhXTYlEVFze9I0RF9CmvAhopwIz4raTgKjlk9uE9Hh29eSaX0eSxLzArcaduliS3fPyqSUnR/NpqJwNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767885987; c=relaxed/simple;
	bh=+ovEomnQgps42mBgCaU8zAij1WwMupnacumZo1P2P/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lhi7KiirX8GqSxO1V++aXQmyrxZAtMZcMTzNOlk/n6g1+BrJCFF4ZLQIDqcF+bgCu9WdjdW2/vsjepRv2nF6uBeF2ee3zPr4Sq8vAfPjuNGeDwD0QpPocLsHS8FJNKB3yW0MTF1+pIr6W340aXlE1VtnEpjDfxYlsYg5yiiYDaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YICLigBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YICLigBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8ACC116C6;
	Thu,  8 Jan 2026 15:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767885986;
	bh=+ovEomnQgps42mBgCaU8zAij1WwMupnacumZo1P2P/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YICLigBh8it9PyFKds+w/KJn+a3+w/NSUl5i6g44lYWLNx/pKfE3KuVPNx+9ZmeWY
	 qzCiTTNbx9N2mbSeZqKM08M945LqyJn1jwWAyqP1YSJJ9RbtWAmnCtsXb4x1IlDaw4
	 LWngcz1AwfsdsNnc8QbWccMiuR3qV+sMH5DHaGrUmXkxx1TmFld5OX0TkmnLD0dS4C
	 AaevQGJsM2bp4bejW/keV+Asjy8379X9swsWCoiWuPQu6x9u/lZ53KOYNCtfSqw9j0
	 zuogC2bjuvLTXjG1A2ORCWMV+HotsAa2/ZUJibCpOHvvbD562U7WdJ9ns7YrQkwAWJ
	 WEbw9Um5Jq+xw==
Date: Thu, 8 Jan 2026 15:26:21 +0000
From: Will Deacon <will@kernel.org>
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>, Ben Horgan <ben.horgan@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Armelle Laine <armellel@google.com>,
	Sebastien Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in
 host handler
Message-ID: <aV_MnW8cg7IsWPuD@willie-the-truck>
References: <20251119-host-direct-messages-v3-0-c74d04944b26@google.com>
 <20251119-host-direct-messages-v3-1-c74d04944b26@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119-host-direct-messages-v3-1-c74d04944b26@google.com>

On Wed, Nov 19, 2025 at 02:07:53AM +0000, Per Larsen via B4 Relay wrote:
> From: Sebastian Ene <sebastianene@google.com>
> 
> Allow direct messages to be forwarded from the host. The host should
> not be sending framework messages so they are filtered out.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 22 ++++++++++++++++++++++
>  include/linux/arm_ffa.h       |  3 +++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 58b7d0c477d7fce235fc70d089d175c7879861b5..a38a3ab497e5eac11777109684a33f02d88d09a1 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -862,6 +862,23 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
>  	hyp_spin_unlock(&host_buffers.lock);
>  }
>  
> +static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
> +			      struct kvm_cpu_context *ctxt,
> +			      u64 vm_handle)
> +{
> +	DECLARE_REG(u32, flags, ctxt, 2);
> +
> +	struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];
> +
> +	/* filter out framework messages */
> +	if (FIELD_GET(FFA_MSG_FLAGS_MSG_TYPE, flags)) {

Wouldn't we be better off just checking that flags is 0? The rest of it
is SBZ or MBZ in the current spec.

> +		ffa_to_smccc_error(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	arm_smccc_1_2_smc(args, res);
> +}
> +
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
>  	struct arm_smccc_1_2_regs res;
> @@ -920,6 +937,11 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  	case FFA_PARTITION_INFO_GET:
>  		do_ffa_part_get(&res, host_ctxt);
>  		goto out_handled;
> +	case FFA_MSG_SEND_DIRECT_REQ:
> +	case FFA_FN64_MSG_SEND_DIRECT_REQ:
> +

Weird whitespace addition ^^

> +		do_ffa_direct_msg(&res, host_ctxt, HOST_FFA_ID);

What's the point of passing HOST_FFA_ID here? Is that supposed to end up
in the Sender ID bits of W1?

Will
