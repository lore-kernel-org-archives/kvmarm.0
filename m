Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B2A3D1CD4;
	Wed, 25 Mar 2026 12:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774440745; cv=none; b=Rb0VH7rcFdR73cIPTa7lNY9sdZIT5FXJ8+Ss2WC3WGAut9/bDfKr5W16j91hKoMHWjfzLIk4Yqi4hiZXp6bq3zt2FnpPTc+58uJSg/bY+uKGil7LHKAwkU4G15gvKdiyeJYqHO6yr+PQRd4J4zhWsG96xkhdxszIvdKBO7ieTLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774440745; c=relaxed/simple;
	bh=sYgpxGo9jlZL6+m+mVfdS9j37scj2obQEFdntrcJch8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y6hm1Pypw5qghaUj3coF4+qYwjgjkCA/Y/QDpvSaK5xreP8+rojAfQgrQ+BkijXh6H7zS1a88WOudc7EN3iw2t9rIpM9Lg1RW0vNuCOY/GxW5slguQpSTCPtxEPT18L+WqVt5K+Id1MVY4DkCvUurHAgaN1lkC3FyHQSNISA808=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I3O/muHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I3O/muHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0081BC4CEF7;
	Wed, 25 Mar 2026 12:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774440744;
	bh=sYgpxGo9jlZL6+m+mVfdS9j37scj2obQEFdntrcJch8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I3O/muHj/Xwt3972sYtMJ7nPAOkaplNPL/3Wt7AwEbjEr04PKKok1RbUHC2prnPFa
	 l+nMKtH/HqKnfQoXRmM3Ky84bbRoyA23j+R85bm8l/9imKsm5qtVGlxkXvYlWzIKWI
	 4iXtzknXFu6DzN6tOqIWjCkYs6vqNN5kjg6/qIO1oTspSHpgRs9KdRiTsjiyOOgVoi
	 aq9FQMPbKrxF1nYuJvQzhDXBVOJtrDCStpOdkqrzVkbEtVPv1KJe5+cQuf68BFQQXq
	 EHll6LfHnlxLjeS0Yyjn+ho2SmkMq/CdYhOcop/R95aG4WtBm4X/Pwe3nnIRyIHxI0
	 PhvkPvp2nQtTQ==
Date: Wed, 25 Mar 2026 12:12:18 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Sebastian Ene <sebastianene@google.com>,
	Vincent Donnefort <vdonnefort@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, catalin.marinas@arm.com, joey.gouly@arm.com,
	mark.rutland@arm.com, oupton@kernel.org, suzuki.poulose@arm.com,
	tabba@google.com, yuzenghui@huawei.com
Subject: Re: [PATCH v2] KVM: arm64: Prevent the host from using an smc with
 imm16 != 0
Message-ID: <acPRIk7_dH5Erul8@willie-the-truck>
References: <20260325113138.4171430-1-sebastianene@google.com>
 <acPIdoA8oc7T8wKX@google.com>
 <86ldfg3ze2.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ldfg3ze2.wl-maz@kernel.org>

On Wed, Mar 25, 2026 at 11:46:29AM +0000, Marc Zyngier wrote:
> On Wed, 25 Mar 2026 11:35:18 +0000,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > On Wed, Mar 25, 2026 at 11:31:38AM +0000, Sebastian Ene wrote:
> > > The ARM Service Calling Convention (SMCCC) specifies that the function
> > > identifier and parameters should be passed in registers, leaving the
> > > 16-bit immediate field of the SMC instruction un-handled.
> > > Currently, our pKVM handler ignores the immediate value, which could lead
> > > to non-compliant software relying on implementation-defined behavior.
> > > Enforce the host kernel running under pKVM to use an immediate value
> > > of 0 by decoding the ISS from the ESR_EL2 and return a not supported
> > > error code back to the caller.
> > > 
> > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > ---
> > > v1 -> v2:
> > > 
> > >  - Dropped injecting an UNDEF and return an error instead
> > >    (SMCCC_RET_NOT_SUPPORTED)
> > >  - Used the mask ESR_ELx_xVC_IMM_MASK instead of masking with U16_MAX
> > >  - Updated the title of the commit message from:
> > >    "[PATCH] KVM: arm64: Inject UNDEF when host is executing an
> > >     smc with imm16 != 0
> > 
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > index e7790097db93..4ffe30fd8707 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > @@ -762,6 +762,12 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
> > >  		handle_host_hcall(host_ctxt);
> > >  		break;
> > >  	case ESR_ELx_EC_SMC64:
> > > +		if (ESR_ELx_xVC_IMM_MASK & esr) {
> > > +			cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;
> > > +			kvm_skip_host_instr();
> > > +			break;
> > > +		}
> > > +
> > 
> > I wonder if it isn't better to move that into handle_host_smc() as this is part
> > of how we handle the SMC after all? (and it calls that kvm_skip_host_instr()
> > already)
> 
> Yes, that'd be vastly better.
> 
> It also begs the question: if you don't want to handle SMCs with a
> non-zero immediate, why is it OK to do it for HVCs?

I suppose the difference is that the HVC API is a private interface
between EL2 and the host. As it stands, EL2 ignores the immediate but we
don't have a way to know how EL3 responds to the immediate for an SMC.

When proxying an SMC from the host, EL2 therefore has three choices:

  1. Ignore the immediate from the host and always use zero when talking
     to EL3. That's the current behaviour, but it could theoretically
     lead to problems if EL3 is using the immediate for something.

  2. Propagate the immediate from the host. That should work, but it's
     a bit involved.

  3. Reject non-zero immediates (this patch).

Will
