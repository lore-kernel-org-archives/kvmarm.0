Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B708B6AAD
	for <kvmarm@lists.linux.dev>; Fri, 17 Mar 2023 13:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47910C4339B;
	Fri, 17 Mar 2023 13:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679060990;
	bh=hYx2SB0J8tAxqp2JtYSAKc2OLyHhlB7K1qDpf1HJaSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EMRrxtPkZkvgfPnPSJBRw4tC7F/4vKjxF0mtYftwif7l6/2TBRq4RxKY2W+q+11+i
	 gyv0wo9xz9Gf/mDomDMOsgUjoYN6CYCSaqidhZkUjmx+U/JUbKnvLDp3XqkY9ppRw5
	 3NCw2i3u6s4w3aUx8y11XedZkeBwRo8aCfKJLryoW0g8NRY8Vz2ZjkwtfTQMSTG2w2
	 3x4+8cxnvbdw/b3glqzwYP3ZLSfFxxa3PyiOrKDwrxXoibriofLFHb4sAkNt/G6bJG
	 epvncBObylRAQho64abn4HZmmXi3HhKsM0o9RG4o9yF369Fw/t+/NgZzu/AlAG/zzm
	 hCaiiGcVvFDww==
Date: Fri, 17 Mar 2023 13:49:44 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/2] KVM: arm64: Move FGT value configuration to vCPU
 state
Message-ID: <855e60de-56c0-4500-a8ce-d79ffb0ed19d@sirena.org.uk>
References: <20230301-kvm-arm64-fgt-v1-0-cfdf71ac67dc@kernel.org>
 <20230301-kvm-arm64-fgt-v1-2-cfdf71ac67dc@kernel.org>
 <867cvfyclz.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BeswKVhtvigxCD8A"
Content-Disposition: inline
In-Reply-To: <867cvfyclz.wl-maz@kernel.org>
X-Cookie: Life is like an analogy.


--BeswKVhtvigxCD8A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 17, 2023 at 09:02:32AM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > +	vcpu->arch.hfgrtr_el2 = 0;
> > +	vcpu->arch.hfgwtr_el2 = 0;

> Although this looks completely innocent, this actually have the effect
> of trapping the SMPRI_EL1 and TPIDR2_EL0 registers, something that is
> self documented in the current code, and that completely disappears
> with this patch.

> This needs documenting by enumerating the sysregs that get trapped.

That's an awful lot of registers with the fine grained traps, and when
extended to cover HFHxTR2 there's a bunch of RES0 bits intended for
future traps.  It feels a bit unmanagable.  I'd have expected something
more along the lines of "enable all traps other than...".  The pattern
seemed to be more to have an explicit initialiser for the bits that are
set (eg, with CPACR_EL1) which was why I didn't put anything explicit.

> > +	/* Fine grained traps values for the guest and host */
> > +	u64 hfgrtr_el2;
> > +	u64 hfgwtr_el2;
> > +	u64 hfgrtr_el2_host;
> > +	u64 hfgwtr_el2_host;

> Why do we have both host and guest? This is the vcpu structure, and
> the host state doesn't belong here. If you want to save some host
> state, place the hfgxtr_el2 fields in kvm_cpu_context, and use the
> per-CPU instance of this structure to save the host state.

Ah, I'd not run into the percpu structure - that does look like a better
fit.

--BeswKVhtvigxCD8A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmQUb/gACgkQJNaLcl1U
h9BpiQf9FhJzoGdTexo3BcCa/elsUnLfLOOAYrDAHWiYDUpiWSZCDEZZtzjztFmZ
SP9iBfzdPUi/mheUcZ3zVwqDLas8rdGABquJNmKX0eHeXPOZLaKj4TB1/EbVAUWE
R1FKPFUIlfdw4OXdcX3Q02b4jUbs0SkemHIEQuABxfEDSJ+OOBONu5O92fg8ThRT
USH0z6q1cRz7S74C+8O90csb0WLFEsAB8D/hb2ijaQojU7XO9mVRYScRmPPJcDPe
jt1Z3NzCdG2rG0dd2BTCOHERwAvtz1rwr9DDx2+ss2FagAmcSQaebw6n4F0yIeit
DeMZY4fE/xgxpF3/6Jj6KlpmfUV+6g==
=EeY1
-----END PGP SIGNATURE-----

--BeswKVhtvigxCD8A--
