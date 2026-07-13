Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0725240F8C3;
	Mon, 13 Jul 2026 13:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783949457; cv=none; b=VmiKKdBcdsx80BaFlhNeXsZwPCpTqPQwcypHz5iH57l4+q8AJ/0CTCAqzF7DfYEs5mXyh4dyd4IwVBlJFQp+biIc7Nql32NFuoqPwHn2T4f49wZXf2K5X1SDUMc7iKuaRyAfizEe942S36+ijzBONmeH387aYcxAVpzUQ6Mg2y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783949457; c=relaxed/simple;
	bh=ErzqW2O0g/i8zFRKK9AZyKTYfMW8W9zx1lacXJE/7U0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ku+huRiPaPVQHVakwtTgQymHAqCDHlgYp9sdsK+qOTe1alOxunTHkZ+AjrXbUCAmgaOIJoo7iAv3Aqz/9MIC1AOJLlkhazTabav/VQS8E4qEY8czlYGMbgClm/egC+WyYUJBd1uh1nG7jarfgVycf+3240k+SZHMDCEpkVx1AZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ikTp/ZDJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ikTp/ZDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812431F00A3F;
	Mon, 13 Jul 2026 13:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783949455;
	bh=2PE3gaGsNLQ/wJ/jx4xmXlbU0Ll5weYz4ZF4wxRh4WY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ikTp/ZDJbKzZqXWQdgJFs4mxUmOx5W44no98j831xxLyCdzKqQoLZo0aubu7A6s4I
	 pHh+efGT9meohmhUvaKUh/9NhBL49M6U1IfTZLuCDURT9zO31YfLr2SBN3ScUD26+W
	 VkCFEJFSu9obPyRdJSJ72kzy/VLeOvMf10vfXZpbaCI3wSnfxgcpW76ZRvh3kS/ZHD
	 Yv06UQBSZoTyN/qEb0fEQmSroyWlJiM4/+bIXwhSR1jQarFKw3ksg2oLI+HqyPRfF2
	 CvzHlCEH2mrN/QQRWwvlsrczJMPg7BKTRAWndik19UrgS416WGQAAxpSqCM1/v4tJg
	 yEau/1bCMbsqg==
Date: Mon, 13 Jul 2026 14:30:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v12 22/29] KVM: arm64: Context switch SME state for guests
Message-ID: <8db1cdd1-5294-4166-99f4-340d124d72c0@sirena.org.uk>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
 <20260709-kvm-arm64-sme-v12-22-d0301d79ef58@kernel.org>
 <CA+EHjTx6P_Wz8=+3fanry_Cs6sqyTD8Swz61WZah46u6-UXP5w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="v9CtVmyreETBkO2w"
Content-Disposition: inline
In-Reply-To: <CA+EHjTx6P_Wz8=+3fanry_Cs6sqyTD8Swz61WZah46u6-UXP5w@mail.gmail.com>
X-Cookie: Courage is grace under pressure.


--v9CtVmyreETBkO2w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 12, 2026 at 03:40:34PM +0100, Fuad Tabba wrote:

> For a nested guest this folds in the LEN restriction from the guest
> hypervisor's SMCR_EL2 just above, but not FA64/EZT0. vcpu_has_fa64()
> and vcpu_has_sme2() are VM-level capabilities (kvm_has_fa64/sme2 on
> vcpu->kvm), so an L1 that clears SMCR_EL2.FA64 or .EZT0 to deny them to
> L2 is overridden here: the physical SMCR_EL2 gets the bits set from the
> VM cap regardless.

Doh, of course.  I've fixed this locally.

> > @@ -128,7 +220,7 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hy=
p_vcpu)
> >  {
> >         struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> >
> > -       fpsimd_sve_flush();
> > +       fpsimd_sve_flush(host_vcpu);
>=20
> sync_hyp_vcpu() runs fpsimd_sve_sync() on &hyp_vcpu->vcpu, but flush
> passes host_vcpu, so the two sides operate on different vCPUs. That
> asymmetry alone looks wrong: flush and sync should cover the same
> state.
>=20
> Concretely it means kvm_sme_configure_traps() programs a protected
> guest's SVCR/SMCR from host-owned values, so the host can e.g. set
> SVCR.SM and fault the guest. Keying flush off &hyp_vcpu->vcpu like
> sync fixes both.

Thanks for spotting that, I've updated locally.

BTW it'd be really helpful to delete unneeded context when replying

--v9CtVmyreETBkO2w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpU6IcACgkQJNaLcl1U
h9AaOAf+KDIg9SieNgLHu8cIPChCdW1/JE5Q90xi5O9YT1F33j626OleMhM1VngO
WHezCRNFf8cg4aTf93obOsz6F6jnWTTZaK82gt6bRu3udlizG+33O7jnsnLFd589
SMe5MOi6iwIgvK0yl8Tf4GAxXgJxMNb/vzvY9hfmke/jCDLYT7BF31PeQMwfDTgq
pKvDiG9o4dUBK4pNzzKuyqaOxHbKmRBlI2+oYON8XCsp7k6PvWSxwnQcPS2WqoyD
h9pAC1jb/eUt/5pQtbQOv1a0O+9QPeVg2CywPMriMQhSZERveEm4vNP+n4EmfEfH
aDQwImKDchI/GbVfMboiAWDd+dLhrw==
=X8+a
-----END PGP SIGNATURE-----

--v9CtVmyreETBkO2w--
