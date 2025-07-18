Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55C67262E;
	Fri, 18 Jul 2025 13:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752845841; cv=none; b=lNUpMccJyWkZ5h9yNWhaM8Di33D4/0ji26R39jM8CyQFAyY57wLDdOM8YWnHlhblNihTyRGLsT7rXjFCSH/1FFmXCmC5MjXRj6D7YvlKKMV68Xm/xknWUYc2EN2KnMNSU+qG+N5utMdNXGrEaur9r5Tww3TrHRsjn7Z0sN77+Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752845841; c=relaxed/simple;
	bh=4gYK7cAt8c0eJOPvaPS4yKEvnYcbVrFkdFhehLWxsik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dqdk/7PHadRmpHN8B+PPDkMu2LfTFTEqDTHvczhp4rEybXLX20Zcf9QyU9JPZ9Ao0TbKnA7xyt0oAg5t730Ev5m8BCGw4qausQAGFleL6mko73xXzOzLVwt4hJoClc8spYxxpCzQsTkdCF2HGZVhcn8btzMbnFpi3+lV5ljV+34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yy8qNN24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yy8qNN24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FB1C4CEEB;
	Fri, 18 Jul 2025 13:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752845841;
	bh=4gYK7cAt8c0eJOPvaPS4yKEvnYcbVrFkdFhehLWxsik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yy8qNN24agcDyfnirinDCL8kW7X+EzPdoiBa/bKjTRmdTumHRqgxlq98W1ZY9Lqqp
	 BXRCWHbuo/mPUK1rrExsvfoJk7+cLFTCsO5hvY5XicL6wgeSN0lHUjcUZDxHt/jJ+G
	 ikoPOXq+obE1oTE44wqcKgR3kbJP3XhaXkO6AokdrxUywUg/GlKuRNkLpE6k8mWuay
	 z/Xeoq8r/oezbD3wLUOMIgpPcTCeYaqIyloN9DCat7hju8q6/XvrRm2mk9loVJx5gw
	 tYPcY1areNux5tMVYVKowc7jJ12vSCEu9jHb/ArpmyAeafi1KBW1VgaAS85YgZT1LV
	 HY/OUHeipGcAg==
Date: Fri, 18 Jul 2025 14:37:14 +0100
From: Will Deacon <will@kernel.org>
To: Per Larsen <perl@immunant.com>
Cc: Marc Zyngier <maz@kernel.org>, perlarsen@google.com,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, ahomescu@google.com,
	armellel@google.com, arve@android.com, ayrton@google.com,
	qperret@google.com, sebastianene@google.com, qwandor@google.com
Subject: Re: [PATCH v7 2/5] KVM: arm64: Use SMCCC 1.2 for FF-A initialization
 and in host handler
Message-ID: <aHpOClH1k-3NhI_y@willie-the-truck>
References: <20250701-virtio-msg-ffa-v7-0-995afc3d385e@google.com>
 <20250701-virtio-msg-ffa-v7-2-995afc3d385e@google.com>
 <8634bdbgaz.wl-maz@kernel.org>
 <3b10fa81-bfdd-4325-a330-c79df2e21621@immunant.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b10fa81-bfdd-4325-a330-c79df2e21621@immunant.com>

On Mon, Jul 07, 2025 at 05:06:23PM -0700, Per Larsen wrote:
> On 7/3/25 5:38 AM, Marc Zyngier wrote:
> > On Tue, 01 Jul 2025 23:06:35 +0100,
> > Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org> wrote:
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > index 2c199d40811efb5bfae199c4a67d8ae3d9307357..65d241ba32403d014b43cc4ef4d5bf9693813809 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > @@ -71,36 +71,68 @@ static u32 hyp_ffa_version;
> > >   static bool has_version_negotiated;
> > >   static hyp_spinlock_t version_lock;
> > > -static void ffa_to_smccc_error(struct arm_smccc_res *res, u64 ffa_errno)
> > > +static void ffa_to_smccc_error(struct arm_smccc_1_2_regs *res, u64 ffa_errno)
> > >   {
> > > -	*res = (struct arm_smccc_res) {
> > > +	*res = (struct arm_smccc_1_2_regs) {
> > >   		.a0	= FFA_ERROR,
> > >   		.a2	= ffa_errno,
> > >   	};
> > >   }
> > > -static void ffa_to_smccc_res_prop(struct arm_smccc_res *res, int ret, u64 prop)
> > > +static void ffa_to_smccc_res_prop(struct arm_smccc_1_2_regs *res, int ret, u64 prop)
> > >   {
> > >   	if (ret == FFA_RET_SUCCESS) {
> > > -		*res = (struct arm_smccc_res) { .a0 = FFA_SUCCESS,
> > > -						.a2 = prop };
> > > +		*res = (struct arm_smccc_1_2_regs) { .a0 = FFA_SUCCESS,
> > > +						      .a2 = prop };
> > >   	} else {
> > >   		ffa_to_smccc_error(res, ret);
> > >   	}
> > >   }
> > > -static void ffa_to_smccc_res(struct arm_smccc_res *res, int ret)
> > > +static void ffa_to_smccc_res(struct arm_smccc_1_2_regs *res, int ret)
> > >   {
> > >   	ffa_to_smccc_res_prop(res, ret, 0);
> > >   }
> > >   static void ffa_set_retval(struct kvm_cpu_context *ctxt,
> > > -			   struct arm_smccc_res *res)
> > > +			   struct arm_smccc_1_2_regs *res)
> > >   {
> > > +	DECLARE_REG(u64, func_id, ctxt, 0);
> > >   	cpu_reg(ctxt, 0) = res->a0;
> > >   	cpu_reg(ctxt, 1) = res->a1;
> > >   	cpu_reg(ctxt, 2) = res->a2;
> > >   	cpu_reg(ctxt, 3) = res->a3;
> > > +	cpu_reg(ctxt, 4) = res->a4;
> > > +	cpu_reg(ctxt, 5) = res->a5;
> > > +	cpu_reg(ctxt, 6) = res->a6;
> > > +	cpu_reg(ctxt, 7) = res->a7;
> > 
> >  From DEN0028G 2.6:
> > 
> > <quote>
> > Registers W4-W7 must be preserved unless they contain results, as
> > specified in the function definition.
> > </quote>
> > 
> > On what grounds can you blindly change these registers?
> From DEN0077A 1.2 Section 11.2: Reserved parameter convention
> 
> <quote>
> Unused parameter registers in FF-A ABIs are reserved for future use by the
> Framework.
> 
> [...]
> 
> The caller is expected to write zeroes to these registers. The callee
> ignores the values in these registers.
> </quote>
> 
> My read is that, as long as we are writing zeroes into reserved registers
> (which I believe we are), we comply with DEN0026G 2.6.>

Right, the specs make this far more difficult to decipher than necessary
but I think SMCCC defers to the definition of the specific call being
made and then FF-A is basically saying that unused argument registers
are always zeroed.

Rather than have the EL2 proxy treat each call differently based on the
used argument registers, we can rely on EL3 doing the right thing and
blindly copy everything back, which is what you've done. So I think
that's ok.

> > > +
> > > +	/*
> > > +	 * DEN0028C 2.6: SMC32/HVC32 call from aarch64 must preserve x8-x30.
> > > +	 *
> > > +	 * The most straightforward approach is to look at the function ID
> > > +	 * sent by the caller. However, the caller could send FFA_MSG_WAIT
> > > +	 * which is a 32-bit interface but the reply could very well be 64-bit
> > > +	 * such as FFA_FN64_MSG_SEND_DIRECT_REQ or FFA_MSG_SEND_DIRECT_REQ2.
> > > +	 *
> > > +	 * Instead, we could look at the function ID in the response (a0) but
> > > +	 * that doesn't work either as FFA_VERSION responses put the version
> > > +	 * number (or error code) in w0.
> > > +	 *
> > > +	 * Set x8-x17 iff response contains 64-bit function ID in a0.
> > > +	 */
> > > +	if (func_id != FFA_VERSION && ARM_SMCCC_IS_64(res->a0)) {
> > > +		cpu_reg(ctxt, 8) = res->a8;
> > > +		cpu_reg(ctxt, 9) = res->a9;
> > > +		cpu_reg(ctxt, 10) = res->a10;
> > > +		cpu_reg(ctxt, 11) = res->a11;
> > > +		cpu_reg(ctxt, 12) = res->a12;
> > > +		cpu_reg(ctxt, 13) = res->a13;
> > > +		cpu_reg(ctxt, 14) = res->a14;
> > > +		cpu_reg(ctxt, 15) = res->a15;
> > > +		cpu_reg(ctxt, 16) = res->a16;
> > > +		cpu_reg(ctxt, 17) = res->a17;
> > > +	}
> > >   }
> > 
> > I don't see how that can ever work.
> > 
> > Irrespective of how FFA_MSG_WAIT actually works (and I couldn't find
> > anything in the spec that supports the above), the requester will
> > fully expect its registers to be preserved based on the initial
> > function type, and that alone. No ifs, no buts.
> > 
> > If what you describe can happen (please provide a convincing example),
> > then the spec is doomed.
> 
> DEN0077A 1.2 Section 8.2 (Runtime Model for FFA_RUN) and 8.3 (Runtime Model
> for Direct request ABIs) contains Figures 8.1 and 8.2. Each figure shows
> transitions between states "waiting", "blocked", "running", and "preempted".
> Key to my understanding is that the waiting state in Figure 8.1 and Figure
> 8.2 is the exact same state. This appears to be the case per Section 4.10.
> 
> So we have to consider the ways to get in and out of the waiting state by
> joining the state machines in Figures 8.1 and 8.2. Figure 8.1 has an edge
> between "running" and "waiting" caused by FFA_MSG_WAIT. Figure 8.2 has an
> edge between "waiting" and "running" caused by a "Direct request ABI".
> 
> Direct request ABIs include FFA_MSG_SEND_DIRECT_REQ2 which is why the FF-A
> 1.2 spec, in my read, permits the response to a 32-bit FFA_MSG_WAIT call can
> be a 64-bit FFA_MSG_SEND_DIRECT_REQ2 reply.

That seems bonkers to me and I agree with Marc's assessment above. The
SMCCC is crystal clear that a caller using the SM32/HVC32 calling
convention can rely on x8-x30 (as well as the stack pointers) being
preserved. If FF-A has a problem with that then it needs to be fixed
there and not bodged in Linux.

Setting that aside, I'm still not sure I follow this part of your check:

	if (... && ARM_SMCCC_IS_64(res->a0))

won't res->a0 contain something like FFA_SUCCESS? The FFA spec states:

  FFA_SUCCESS64, is used only if any result register encodes a 64-bit
  parameter.

which doesn't really seem related to whether or not the initial call
was using SMC32 or SMC64. What am I missing?

Will
