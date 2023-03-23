Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B29D2F1
	for <kvmarm@lists.linux.dev>; Thu, 23 Mar 2023 22:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2358C433D2;
	Thu, 23 Mar 2023 22:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679609330;
	bh=x1ANynbg7sxcbxW58uUMx+EhenQNWNHyr/Dpqip+Md4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FT71rjVXwhGQetsHuGsafPVXht8w6EblT2NtL5wBAWizZGUddzmNRMHviHJw852PR
	 KHCftd2lewcckgTSeRb0oe51nOgVxx6zwwAfkAX1TBAgyTGV+DvhMLWw15/Axeu7AJ
	 14F03gghPBGZkohATUmytzrLbgg7MhV5goBx0+fK0Q36CBnWv9qdQciVh1XAoKwVp4
	 Vv2R3/YlKtK/vumwLiJMDHcu0IG5Uejcq3YeIPMU0Hz5vXIYIzkyUcZTDTWsjZzEfI
	 xOzCoSUodR6Wtc6FgTL0lsF+UvEfv+68tBEp6CWLX/5izRv2fmT4Ack7PwzLSYZ8P3
	 PhfYPSvSyMmlw==
Date: Thu, 23 Mar 2023 22:08:44 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 2/2] KVM: arm64: Move FGT value configuration to vCPU
 state
Message-ID: <4f6a5565-af40-4bde-8aaf-5470e9562b0e@sirena.org.uk>
References: <20230301-kvm-arm64-fgt-v2-0-c11c0dcf810a@kernel.org>
 <20230301-kvm-arm64-fgt-v2-2-c11c0dcf810a@kernel.org>
 <865yarxnwv.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yG042uWorPt/O9Uo"
Content-Disposition: inline
In-Reply-To: <865yarxnwv.wl-maz@kernel.org>
X-Cookie: A lie in time saves nine.


--yG042uWorPt/O9Uo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 23, 2023 at 07:34:08PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -365,6 +365,8 @@ enum vcpu_sysreg {
> >  	TPIDR_EL2,	/* EL2 Software Thread ID Register */
> >  	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
> >  	SP_EL2,		/* EL2 Stack Pointer */
> > +	HFGRTR_EL2,	/* Fine Grained Read Traps */
> > +	HFGWTR_EL2,	/* Fine Grained Write Traps */

> No, this is the wrong spot. These registers describe the *guest*
> state. Not the state that KVM sets for its own use. These registers
> would be used by a guest hypervisor to manage traps it uses for its
> own guests.

Ah, sorry, I misinterpreted what you meant when you said to put them in
kvm_vcpu_context - the sys_regs array in there seemed to be the place
where data for sysregs is stored.  The large set of EL2 registers in
there already stopped alarm bells going off, as did the fact that with
the patch above we were loading a copy from there for the guest.

To clarify, place just regular member variables in kvm_vcpu_context then
save host state to the percpu host context (I guess while activating
traps) and load the guest state from vcpu->arch.ctxt.hfgxtr_el2?  I've
got that testing locally just now.

--yG042uWorPt/O9Uo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmQczesACgkQJNaLcl1U
h9CgrQf+Iyu8i074tUZexlZ56xsN6baTS1Cxk8NkCdIQ6UdYc8WJg9XmxPEeBI6q
k0d6P1ahYHu80p2oa0EDT3UXugP2WTS5sPv2WcwirkKIB05cH7rhJaShCOr5vm1S
QAsRpYOEM3ndxxBApFr1kpanjpqPq+f7hJvO0nfr08CLJw9UQ+49yc8s+eNkAj5V
UMiPzvLV+2yjW9f9vj4dmrSy3lUNrD7WrmNllE5om/+4KZtuBb/j1IuMFsa+NPUV
mllbKenGuyVrDR0u51y0OU8+3/Q4n3LW0+L5yDWLHxXMqc6vaPoE2mMnJmu5JM/o
jV+GwYgtg7txxMFLE3bHV8x4d/YiNA==
=x/lI
-----END PGP SIGNATURE-----

--yG042uWorPt/O9Uo--
