Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C21C3590A5;
	Fri,  9 Jan 2026 11:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767958654; cv=none; b=Pi2CQywaSXyJjnYiURqn5u7tcQ8tkjZUmiCRQMkM+fQtsk2LKTqeuIWOAezk3JC1Lw9lpspbT+9PQMpTVepeIv4WFXI/EwGMVy0QPHDLZ8SwDp2e1wdghNqU/X+Li308Ucq1yHpXlI1Vr+FgjZ/leVTKtALw1fQDdVRUXQkoImE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767958654; c=relaxed/simple;
	bh=4NcWKcseDv7quEbWxMIMjnmm3Je3chS+A/b4mc7HaGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C9RBHVtEX2fs5JFBUTwNVkEUbERb9EZZCYxbJ9MIBzesAm7z6avez5RrN3ZdyFotIoksKvYvpof6ObZdWrceoc1T8hflj017Jcnx4ivzZLWZ+2K+59iz5udfkMY/S/ZjCZwHNErvF2VYeSGb5zatEg69dzPjlfIiUzTiD5yMGXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l8GYwtui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l8GYwtui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0F2C4CEF1;
	Fri,  9 Jan 2026 11:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767958654;
	bh=4NcWKcseDv7quEbWxMIMjnmm3Je3chS+A/b4mc7HaGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l8GYwtuiJGOZyVoIBlEIfUHWnEr5/zX6cVNzVsNoXT1xJxoT9tRsh+boZWMPT1xuI
	 6gKwUaBK7KyZ5n3/viF0H6xR60QcKGNAWLx8clcGSa4iONDKePZRLlUdclrp3+ah/u
	 54tCIXbNgN51qGOkpnoS3VpOsEd9OAgzjxb8muL6FJ6CJ/0GSQTvTjTdn/uNpwnf/o
	 xCVJBfc84olVIdsBnn8ee5cYIlamPcP71Tzbgz0qjv76Qku0LKgGzvbOCgr3cq5FP1
	 7w6CnU2wSN783reAM/GjxaNhZojvO+YJ6OZGkeVBHBt3OxemA7B/1hMXFKaZex3+la
	 QiEySLI1Zc3/A==
Date: Fri, 9 Jan 2026 11:37:28 +0000
From: Will Deacon <will@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: perlarsen@google.com, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>, Ben Horgan <ben.horgan@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Armelle Laine <armellel@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in
 host handler
Message-ID: <aWDoeMRZbbsQ2htP@willie-the-truck>
References: <20251119-host-direct-messages-v3-0-c74d04944b26@google.com>
 <20251119-host-direct-messages-v3-1-c74d04944b26@google.com>
 <aV_MnW8cg7IsWPuD@willie-the-truck>
 <aWDkCQ7m1-w8e-Py@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWDkCQ7m1-w8e-Py@google.com>

Hey Seb,

Cheers for the reply.

On Fri, Jan 09, 2026 at 11:18:33AM +0000, Sebastian Ene wrote:
> On Thu, Jan 08, 2026 at 03:26:21PM +0000, Will Deacon wrote:
> > On Wed, Nov 19, 2025 at 02:07:53AM +0000, Per Larsen via B4 Relay wrote:
> > > From: Sebastian Ene <sebastianene@google.com>
> > > 
> > > Allow direct messages to be forwarded from the host. The host should
> > > not be sending framework messages so they are filtered out.
> > > 
> > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > > Signed-off-by: Per Larsen <perlarsen@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/ffa.c | 22 ++++++++++++++++++++++
> > >  include/linux/arm_ffa.h       |  3 +++
> > >  2 files changed, 25 insertions(+)
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > index 58b7d0c477d7fce235fc70d089d175c7879861b5..a38a3ab497e5eac11777109684a33f02d88d09a1 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > @@ -862,6 +862,23 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
> > >  	hyp_spin_unlock(&host_buffers.lock);
> > >  }
> > >  
> > > +static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
> > > +			      struct kvm_cpu_context *ctxt,
> > > +			      u64 vm_handle)
> > > +{
> > > +	DECLARE_REG(u32, flags, ctxt, 2);
> > > +
> > > +	struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];
> > > +
> > > +	/* filter out framework messages */
> > > +	if (FIELD_GET(FFA_MSG_FLAGS_MSG_TYPE, flags)) {
> > 
> > Wouldn't we be better off just checking that flags is 0? The rest of it
> > is SBZ or MBZ in the current spec.
> 
> Yes, we can simplify it in this way.

I think it would also be more robust if new messaging types are added
in future, as we would fail safe.

> > > +		do_ffa_direct_msg(&res, host_ctxt, HOST_FFA_ID);
> > 
> > What's the point of passing HOST_FFA_ID here? Is that supposed to end up
> > in the Sender ID bits of W1?
> 
> I can remove it, this doesn't bring too much for upstream but on the
> android kernel with guest-ffa it makes sense because we need to validate
> the sender to prevent impersonation.

We could also validate that the sender is HOST_FFA_ID in this case, but
that seems to be missing atm.

Cheers,

Will
