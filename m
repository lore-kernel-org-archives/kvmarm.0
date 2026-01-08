Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A161134A766;
	Thu,  8 Jan 2026 15:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767886215; cv=none; b=GGV0u8Qwg4r4rowg8wEu1ee8utly4TbrkskaXpYe2kIPjZp3oapxOgz+OntH5mBgYbVdyAJqtUFpSRdYTWxTSN9xsbIRJcWsuUTbZavF3FK+S3zRHS+d0+vD/wUK8FQ8hU6dE13JBHH/98feeFnW01TYQwYnIQfQtO9javIggF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767886215; c=relaxed/simple;
	bh=XRv28BEV+7f5GPwMsVGezx6oU/g6sID3XcDLpPgJ/UM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bke/9NvBwXbPfqK687m+CAU/PsVo9jmPjZtFJk8XxiEfHbFf8YZEryRHp6p3ieFmYsdINJLE0az1w5oOcXvJWei9+N1IFYmtIX+1o7yknSAGU0XFkeENHrGmNCrW8k33kbDKIOPYG0z16kUKjAwvWTLGUatmIVIR1Lwt+44xb4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=As77JXYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="As77JXYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3B1C116C6;
	Thu,  8 Jan 2026 15:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767886215;
	bh=XRv28BEV+7f5GPwMsVGezx6oU/g6sID3XcDLpPgJ/UM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=As77JXYbZSzOEVql1xo0ouFGu82gdNCv1NSpZj3O1uguqcpf9Pa4JwwCPtqU3nwJb
	 ZTDmuRCPXnllm23tgj8k/0CvoUIKFfJTgMeq53oq2qWoU7act7OlbwCC9Ot62UZgPx
	 kg8u5v8Qdobkzpvn2P9nrW8OpocKMs9whMS1pj1EA/LG+2O0y1N5wxNgVxe/aZeHEW
	 3RVJ21thBq/mg3+2BrYSQWCoaXcKuqOhfarxT/+vFaRJ8uCSJK70pikvJjbQ4/tjyu
	 iOWd56c0iiorhmYvpYnGBztMBO10NJydQja5+FVHqnf4NSq1TCkkaRaOMOGj3hspLh
	 yWROmsviluqng==
Date: Thu, 8 Jan 2026 15:30:09 +0000
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
Subject: Re: [PATCH v3 2/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in
 host handler
Message-ID: <aV_Ngc2KKKZYLH1m@willie-the-truck>
References: <20251119-host-direct-messages-v3-0-c74d04944b26@google.com>
 <20251119-host-direct-messages-v3-2-c74d04944b26@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119-host-direct-messages-v3-2-c74d04944b26@google.com>

On Wed, Nov 19, 2025 at 02:07:54AM +0000, Per Larsen via B4 Relay wrote:
> From: Per Larsen <perlarsen@google.com>
> 
> FF-A 1.2 adds the DIRECT_REQ2 messaging interface which is similar to
> the existing FFA_MSG_SEND_DIRECT_{REQ,RESP} functions and can use the
> existing handler function. Add support for FFA_MSG_SEND_DIRECT_REQ2 in
> the host ffa handler.
> 
> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index a38a3ab497e5eac11777109684a33f02d88d09a1..c794802bda589b315faf978086ad164a2aee510a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -683,8 +683,10 @@ static bool ffa_call_supported(u64 func_id)
>  	case FFA_NOTIFICATION_SET:
>  	case FFA_NOTIFICATION_GET:
>  	case FFA_NOTIFICATION_INFO_GET:
> +		return false;
>  	/* Optional interfaces added in FF-A 1.2 */
>  	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
> +		return hyp_ffa_version >= FFA_VERSION_1_2;

You might as well just move this to the end and avoid having to add the
'return false' above.

>  	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
>  	case FFA_CONSOLE_LOG:			/* Optional per 13.1: not in Table 13.1 */
>  	case FFA_PARTITION_INFO_GET_REGS:	/* Optional for virtual instances per 13.1 */
> @@ -866,12 +868,16 @@ static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
>  			      struct kvm_cpu_context *ctxt,
>  			      u64 vm_handle)
>  {
> +	DECLARE_REG(u64, func_id, ctxt, 0);
>  	DECLARE_REG(u32, flags, ctxt, 2);
>  
>  	struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];
>  
> -	/* filter out framework messages */
> -	if (FIELD_GET(FFA_MSG_FLAGS_MSG_TYPE, flags)) {
> +	/*
> +	 * filter out framework messages.
> +	 * FFA_MSG_SEND_DIRECT_REQ2 is only for partition messages.
> +	 */
> +	if (func_id != FFA_MSG_SEND_DIRECT_REQ2 && FIELD_GET(FFA_MSG_FLAGS_MSG_TYPE, flags)) {
>  		ffa_to_smccc_error(res, FFA_RET_INVALID_PARAMETERS);
>  		return;
>  	}

It would probably be better to switch the polarity of this check so that
you look at flags if FFA_MSG_SEND_DIRECT_REQ or
FFA_FN64_MSG_SEND_DIRECT_REQ rather than if !REQ2.

and again, I'm not seeing what the 'vm_handle' argument is doing here.

Will
