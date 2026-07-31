Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AACF2222AC;
	Fri, 31 Jul 2026 13:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785505626; cv=none; b=Dxp/+NBa7QSWvBJlSKBQuB48tcUXseNef560ExSQvWezkkS89h+XkkEhppWPyraa0HEk96KcLXYCUQNqk2bS3hey9k7d0rXOvua+CE66Z2slDkcHoIrD96SGF8cPwOXeKF+/N9Rbw9/L7+MFVYShQrtjBkTHIT6CG41/b+r/tuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785505626; c=relaxed/simple;
	bh=GprfEJ5aWw9evnHbOhq3OPTYhKqyerpRsF6PLi43Mhg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T2dXiG3IooTot1GOyy6xWIyPpGdiS1HQSY2FSJ1yaE8bJoEDIusoajBC9eV6VCsbl3sH02DEnoGx7VH0nHysRoqI6wc7QIA8I1xWebYK/ULcQUr6sRXYhApOcNkvz/Oi8JeXqCz+zQiDxac/KOvn2qNtLqFAMR9AsQ3HJCawiXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MUx2mx4K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MUx2mx4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF2D1F000E9;
	Fri, 31 Jul 2026 13:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785505624;
	bh=m+Cx3ueQtJ1ljY5Vkowu93BgZnLkZ5F630W2IX0Vwyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MUx2mx4KSLnOO8o+a5EFyuo/FEP83UbU25qk4Ezm082hjVjg0vFFu+boFyd1kLSwV
	 Kzsu1qJewEliofqBc6yUAdci/qyjWhkSCHrWwbm5KqK8ZD3Ucn75WxRnWlTxU0JyFh
	 yUq+Kp+g1mm491c00wyXultDpmTTaHbSk5vJockDnP9t95A37ZRffcZIfVrX31QAA5
	 i51LSFqN7JpQCNgxBi05EmGMDrW8+mgGEg6psa0YgSYGB+u7RSo1QItExO2dL+cjeF
	 b7zv5Oa7b73h0Dolzy2RBPE1hSPtI1NSQAvuRje4mO1bb6rqwU5r+OShyDfZhQ5NrM
	 b020WepZ8BNAw==
Date: Fri, 31 Jul 2026 14:47:01 +0100
From: Mark Brown <broonie@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v17 02/14] KVM: arm64: Fix FGT mapping for
 HFGITR_EL2.nGCSEPP
Message-ID: <f4e3efda-61b1-4d2c-89db-1632f77fd7e2@sirena.org.uk>
References: <20260731-arm64-gcs-v17-0-5e39ca01b14e@kernel.org>
 <20260731-arm64-gcs-v17-2-5e39ca01b14e@kernel.org>
 <20260731130326.AC5701F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="A9XloNrNDlDJUaYT"
Content-Disposition: inline
In-Reply-To: <20260731130326.AC5701F00ACA@smtp.kernel.org>
X-Cookie: No shirt, no shoes, no service.


--A9XloNrNDlDJUaYT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2026 at 01:03:26PM +0000, sashiko-bot@kernel.org wrote:

> > -	SR_FGT(OP_GCSPOPX, 		HFGITR, nGCSEPP, 0),
> > +	SR_FGT(OP_GCSPOPCX, 		HFGITR, nGCSEPP, 0),
> >  	SR_FGT(OP_GCSPUSHM, 		HFGITR, nGCSPUSHM_EL1, 0),
>=20
> [Severity: High]
> This isn't a bug introduced by this patch, but is the Fine-Grained Trap
> mapping for HFGITR_EL2.nGCSPUSHM_EL1 incomplete here?

> It looks like this maps OP_GCSPUSHM to nGCSPUSHM_EL1 but omits the GCSPOPM
> instruction.

> If an L1 hypervisor clears HFGITR_EL2.nGCSPUSHM_EL1 and the L2 guest
> executes GCSPOPM, will L0 KVM fail to find OP_GCSPOPM in encoding_to_fgt
> during triage_sysreg_trap() and incorrectly inject an UNDEF exception into
> the L2 guest instead of properly forwarding the trap?

> If so, does OP_GCSPOPM (sys_insn(1, 3, 7, 7, 1)) need to be defined in
> arch/arm64/include/asm/sysreg.h and added to this array?

This appears to be incorrect, the documentation in DDI0601 for
HFGITR_EL2 only calls out GCSPUSHM as being trapped by nGCSPUSHM_EL1 and
I can't see anything that contradicts this or associates GCSPOPM with
any other FGT.

--A9XloNrNDlDJUaYT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpsp1QACgkQJNaLcl1U
h9CUAwf/fLRxVkXga4gJmBtnkYZIR+2heikj6xYxabWoT4dpceNQ74SofpIFsHUj
mgDtzKGsFZqPGBJafgMEGTXXsRZx0cqb9JlrTLkVF/sHyzfsCE+cEpt9VOBcHItX
j5O+U/ktwf7D9cyUkM4jvaBXj9oMiOUoae7mJBsrT9zen8eazVnaJYeGDM1VAK3q
XRoabSIiGpAPTf3oZxvdBnLMHmI2ovyfYMdvg6pApNC+r0lEd0zxgCDKUvo9DPx+
HNZ7cf7ZDNP+75sv0lx8hhIrEuD+CzzlcC4/wx5uxhJpy8HUzh1plW/p/dg1/Gck
f3vM8EceSb8MDoK7lRBtC59zCDG2kA==
=CyHS
-----END PGP SIGNATURE-----

--A9XloNrNDlDJUaYT--
