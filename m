Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE0343E4A4;
	Tue, 20 Jan 2026 14:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768918209; cv=none; b=npdPgVghcFzCIBUF3zz1xHAKnOdOGkyunSL10e6v+J9Rm9dSDGf0R5L4OJvCAFCTqTGZ+WWgoT7tEbDmgSdytyf8YcFoVHeq+MyiGE8Ch/Crp0uetvsBhI/cRUDCXdI2nm6d8uUHSBR5MkTUb/KVbexBB2c/EOOIJKI4Ws+m+sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768918209; c=relaxed/simple;
	bh=Ym1BChiDA/nfvHPs0Pfn4x26/vTjDWdcKmeSW/i2+E8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NPjCgA67o530sZizzw7Htx8rF01ZmRbINtG+pmDVrA99BpkMbuFf2l7jwhFhGk9UvmIS3NcxvCsp9mhN6qFyK8DjwFUn9vxyBq+gQG0LP7JbWbve1mLewo8utp0beQzOfErh7O9hynXjGL787bzqpXSwv5Tm8GelF7SnLjueI1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KYpbZuFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KYpbZuFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F47C4AF0B;
	Tue, 20 Jan 2026 14:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768918208;
	bh=Ym1BChiDA/nfvHPs0Pfn4x26/vTjDWdcKmeSW/i2+E8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KYpbZuFluE7Uc8y1vpgERaU6XAa5n/fvQ/K56ZbqGt3sRL5iQF21JCt+kALvLIugx
	 FyVaRlMeMTI8Ih94Sz5EFdsDwE93XxHrSRisOlawIKJneUtql5nqD3nwWJNSjc5Ora
	 Xve2KhQIT4X+PvjLymzzZt1SZNPCK0lbklFE68IYwcEpMnxW2NFoOh49AvA/MX2O5x
	 9RDv7nSvqunBctVvkVSrMIIQ05S/GTVsLs9CBwcp7Ey0ztr7MyIhazqm4yJ5xRdWsD
	 icxl3qapy2SikY3ermb7927dsvsNNK76kZU0Z69iDaslwUQD9wqvXvIXgM2plbEXOw
	 0OuVAOlpTAI1Q==
Date: Tue, 20 Jan 2026 14:10:02 +0000
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
Subject: Re: [PATCH v4 1/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in
 host handler
Message-ID: <aW-MugHHrJVQQKxc@willie-the-truck>
References: <20260109-host-direct-messages-v4-0-95da4221d186@google.com>
 <20260109-host-direct-messages-v4-1-95da4221d186@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109-host-direct-messages-v4-1-95da4221d186@google.com>

On Fri, Jan 09, 2026 at 10:34:25PM +0000, Per Larsen via B4 Relay wrote:
> From: Sebastian Ene <sebastianene@google.com>
> 
> Allow direct messages to be forwarded from the host. The host should
> not be sending framework messages so they are filtered out.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 20 ++++++++++++++++++++
>  include/linux/arm_ffa.h       |  3 +++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index f731cc4c3f280a32acccca0de92b9ac6c8e05602..fc84595007f310004def7d525371fa7c128f244a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -862,6 +862,22 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
>  	hyp_spin_unlock(&host_buffers.lock);
>  }
>  
> +static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
> +			      struct kvm_cpu_context *ctxt)
> +{
> +	DECLARE_REG(u32, flags, ctxt, 2);
> +
> +	struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];
> +
> +	/* filter out framework messages and validate SBZ/MBZ bits */
> +	if (flags) {
> +		ffa_to_smccc_error(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	arm_smccc_1_2_smc(args, res);

I thought we were going to validate that the sender is HOST_FFA_ID?

> diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
> index 81e603839c4a51873090b7e22edbe7b33a7e94df..d209d0cdac1eb804be01e4607acac8f76cc99e40 100644
> --- a/include/linux/arm_ffa.h
> +++ b/include/linux/arm_ffa.h
> @@ -130,6 +130,9 @@
>  #define FFA_FEAT_RXTX_MIN_SZ_16K	2
>  #define FFA_FEAT_RXTX_MIN_SZ_MASK	GENMASK(1, 0)
>  
> +/* FFA message flags */
> +#define FFA_MSG_FLAGS_MSG_TYPE		BIT(31)
> +

This hunk is no longer needed now that we're just checking for the flags
being zero.

Will
