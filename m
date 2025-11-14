Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742A8340A44;
	Fri, 14 Nov 2025 17:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763142105; cv=none; b=LlTv9aGnsROySofB6EkT1RltteLlLQOS3IAcHZPW6qBSxSmq9IMg0tc4OOBgAZOM1qHNFOZajiSlNATioEDYdQ1UZ/MCuUfKS2j1rVEuQ8mguSmFV9sZyycoyjHt+756j6eCb4nLeyXDiP8MPyJjKs2LxVFfcbQy+9reb0eK5ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763142105; c=relaxed/simple;
	bh=IQZR6GSdsfxkXbWwpBWciwNfmoY8y6liTJu6TwjjAWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e5sMNoX+KF42RZCcIIP8phbdsOoHeThvjLO069Ps/rzoN8XvfyWPMtMT3HxyiqFGuEJle3azhlpxqD6YH9WdNmbgazo8RWNFZmdM1wq4aoioIDdCokiAUPLJSotxg4a1VOxNNa3GAobG1oZ6zz4H4wHcgI7DzbHDpMbROtq1nL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hk6XIezo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hk6XIezo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66731C116D0;
	Fri, 14 Nov 2025 17:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763142105;
	bh=IQZR6GSdsfxkXbWwpBWciwNfmoY8y6liTJu6TwjjAWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hk6XIezoo/nMtNckSn17IIlP0olpWzyv6gHkAkkgDZS0z/4FfzAdOD1RDoY9DAlp9
	 Vx+z1XQvLC8KC3+MT6fU83Cw462fnoyo0KN6AoCKswor6OvN6ddCGRYKsfR9CfG8lI
	 DbvhEHbR3yR94FyfSTIzgSBzf8cHh5oaVWOW24JXCxIKWysEiorhDcnzDjR9nDJWqX
	 2sakkLLKUm7qNGP1g6x5CYDsf8KDjDYWY2yv7eimWa700/Nn5Q59JPBwRt5PDAT4t4
	 etMtcRTXG6ialwlupGxG9qOQOnWsBU3L1kFZCtimHG/mVKJtYzTHNdbEJFFh4bPcL8
	 eIfR2MHEOACTQ==
Date: Fri, 14 Nov 2025 17:41:39 +0000
From: Will Deacon <will@kernel.org>
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>, Ben Horgan <ben.horgan@arm.com>,
	Armelle Laine <armellel@google.com>,
	Sebastien Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in
 host handler
Message-ID: <aRdp02lPH0Ls5iqV@willie-the-truck>
References: <20251030-host-direct-messages-v2-0-9f27cef36730@google.com>
 <20251030-host-direct-messages-v2-1-9f27cef36730@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030-host-direct-messages-v2-1-9f27cef36730@google.com>

On Thu, Oct 30, 2025 at 03:49:16PM +0000, Per Larsen via B4 Relay wrote:
> From: Sebastian Ene <sebastianene@google.com>
> 
> Allow direct messages to be forwarded from the host.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 4e16f9b96f637599873b16148c6e40cf1210aa3e..bb38ee7c86bad1646c16c562127eb3bef6297a84 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -857,6 +857,15 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
>  	hyp_spin_unlock(&host_buffers.lock);
>  }
>  
> +static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
> +			      struct kvm_cpu_context *ctxt,
> +			      u64 vm_handle)
> +{
> +	struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];
> +
> +	arm_smccc_1_2_smc(args, res);
> +}
> +
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
>  	struct arm_smccc_1_2_regs res;
> @@ -915,6 +924,10 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  	case FFA_PARTITION_INFO_GET:
>  		do_ffa_part_get(&res, host_ctxt);
>  		goto out_handled;
> +	case FFA_MSG_SEND_DIRECT_REQ:
> +	case FFA_FN64_MSG_SEND_DIRECT_REQ:
> +		do_ffa_direct_msg(&res, host_ctxt, HOST_FFA_ID);
> +		goto out_handled;

Should we filter out framework messages so that this is limited to partition
messages instead?

Will
