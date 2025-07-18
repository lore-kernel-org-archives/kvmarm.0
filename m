Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD6C22D79F;
	Fri, 18 Jul 2025 13:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752846787; cv=none; b=rNIqp67FiG01mxCOAOxaXVBPyZ4Lx/DAhdXTT+oPNUzXDOMEpVsqr3PljiUaPif9Ae/Tu4AqDTv5bkGKqbh2o7XypyHB/dCLXVrt2ZudB4wYNJMimEkNWHD7yf4DlaGtZ1P48aGdqmXnmkdgsE6Gs/ovoew91F9UwIZTO60xpPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752846787; c=relaxed/simple;
	bh=B4SnE+zQQYrXoOXSH3uh52tXSCyHrejJfwt5H9FxdM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GG/lMV+a2XlIeGS8ZRlKbBjXxDqYc3eiNtzZJbylaT7+rVX9SQgXFFd8ERHLAA/3/WgL3Nra3bFtgMcmCpcjlgj3HZEPso2uOpr9pMRUz6Q/vcs9yCviNCD4e5HVDRGybkvOO/ihStLB31NnqTeJdsOHOj1uAEzxfyxd2ZFLvF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NlGGxUof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NlGGxUof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3169C4CEEB;
	Fri, 18 Jul 2025 13:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752846786;
	bh=B4SnE+zQQYrXoOXSH3uh52tXSCyHrejJfwt5H9FxdM8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NlGGxUof11Zehi8WBXyY/8GR05FhcOVGptIke0qiu0pQfbjWDF4kH235O8293aR2d
	 YvWNzcgzpoYL1rmqDAQ3XTk5/0gadDntr+1tTU1Z7YMmwlmqqe/K/vPbLQIMGcg6NQ
	 wZMibR8oYCiKzHRN1TwApjuzcj+ry5jE4DvLD/aQMtQdhO9lbq5DOiQvdFOwiq5J9+
	 /9QbvorA4qw/MObr/WO8ycsIoxPnGfDOnk8M6XCCgPvZDpkNJjlXMTuS2UH8XU/sTm
	 JIpt36PkfH6ZQOjQsmN8OnDI24KpPaYKKVfouIPA7lqNgK3GRNm7Nhg9VvowAU7lnN
	 dC4BzIdNfmnZQ==
Date: Fri, 18 Jul 2025 14:53:00 +0100
From: Will Deacon <will@kernel.org>
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, ahomescu@google.com,
	armellel@google.com, arve@android.com, ayrton@google.com,
	qperret@google.com, sebastianene@google.com, qwandor@google.com
Subject: Re: [PATCH v7 5/5] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in
 host handler
Message-ID: <aHpRvBO864x1vvqP@willie-the-truck>
References: <20250701-virtio-msg-ffa-v7-0-995afc3d385e@google.com>
 <20250701-virtio-msg-ffa-v7-5-995afc3d385e@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701-virtio-msg-ffa-v7-5-995afc3d385e@google.com>

On Tue, Jul 01, 2025 at 10:06:38PM +0000, Per Larsen via B4 Relay wrote:
> From: Per Larsen <perlarsen@google.com>
> 
> FF-A 1.2 adds the DIRECT_REQ2 messaging interface which is similar to
> the existing FFA_MSG_SEND_DIRECT_{REQ,RESP} functions except that it
> uses the SMC calling convention v1.2 which allows calls to use x4-x17 as
> argument and return registers. Add support for FFA_MSG_SEND_DIRECT_REQ2
> in the host ffa handler.
> 
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 24 +++++++++++++++++++++++-
>  include/linux/arm_ffa.h       |  2 ++
>  2 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 79d834120a3f3d26e17e9170c60012b60c6f5a5e..21225988a9365219ccfd69e8e599d7403b5cdf05 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -679,7 +679,6 @@ static bool ffa_call_supported(u64 func_id)
>  	case FFA_NOTIFICATION_GET:
>  	case FFA_NOTIFICATION_INFO_GET:
>  	/* Optional interfaces added in FF-A 1.2 */
> -	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */

I think that's the only change needed. In fact, maybe just don't add it
in the earlier patch?

>  	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
>  	case FFA_CONSOLE_LOG:			/* Optional per 13.1: not in Table 13.1 */
>  	case FFA_PARTITION_INFO_GET_REGS:	/* Optional for virtual instances per 13.1 */
> @@ -862,6 +861,22 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
>  	hyp_spin_unlock(&host_buffers.lock);
>  }
>  
> +static void do_ffa_direct_msg2(struct arm_smccc_1_2_regs *regs,
> +			       struct kvm_cpu_context *ctxt,
> +			       u64 vm_handle)
> +{
> +	DECLARE_REG(u32, endp, ctxt, 1);
> +
> +	struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];
> +
> +	if (FIELD_GET(FFA_SRC_ENDPOINT_MASK, endp) != vm_handle) {
> +		ffa_to_smccc_error(regs, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}

Why do we care about checking the src id? We don't check that for
FFA_MSG_SEND_DIRECT_REQ and I don't think we need to care about it here
either.

Will
