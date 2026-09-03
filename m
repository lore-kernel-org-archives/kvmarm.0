Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B3D440636;
	Thu,  3 Sep 2026 20:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788468104; cv=none; b=ckeg/yS4o3ATUXGEaZifkXjNKURfPAGi5eqAMSgigd0pkiw4RYtuYtqcKIohmH72SJauYGQpaJw6OSCrm5xcYnA0FjtUMiOZOrB/mDMrtaxUSwJMJjZ76rsYlaUWf0kD8DYz4DWpDvxUYU5aOmw+T9GfoMDJ8ehvl2k71aDGfmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788468104; c=relaxed/simple;
	bh=AY0HA4ndetMZiaqwqU8UghLdFoFnfxZMx6zhDjYAUVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f0hTyOQecbtqV/MkOeEg6MwSTM3C6YoOUlwbLdKRqE8nSzJ6nWwnTQYSK0JRRZipFkpUJEWtxuMWIAjN9ZAU0wcQdRKqmh6Li4oHK7e5c+OePwp5X9di5xONeC39k0U06iR9N1A4QTCjQT8gSpQvfs8ZDsQcstNjKbck3JXtNkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JR2UQdMe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JR2UQdMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D0D1F000E9;
	Thu,  3 Sep 2026 20:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788468092;
	bh=dccCzEuEh91JJr7dSASJ482QV1CaMg8i/UVv42TMhjI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JR2UQdMedKz3s+eb+c1UCQQBjsKsBHzJlHuFj2Ndy9O43ymWj5x3mOfKb1Q5JvXNE
	 KjOkRK/WycgPVOuiZ8U86TarsmBu34sUO2A/9O8ocEWdbYgnwxsD4j17EZOK3p8yv0
	 bJduA9CcV1S7EvYXaf84BGRJU0pNPD6Qjg1U3nQypI6UyOgce4QkyFMbJl9wh71+Kd
	 vORJuMOxPeYUbYM5QX/BgkU0V6rV4zloEh9sBjA9nzoLXTvmKAMevGibSGQl2yeE4j
	 pkVy5b43uQ2Sp2VjQcwkKUfXpRQ6oDNQleOE44v5J58v70mqD/mcN4J2lIM6EzaBK8
	 y/knE4VmtEqcg==
Date: Thu, 3 Sep 2026 21:41:26 +0100
From: Mark Brown <broonie@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	Leonardo Bras <leo.bras@arm.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Message-ID: <d2659ac3-2f00-4fc4-8f9e-0585691a4ba2@sirena.org.uk>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-3-f31750bdfadb@kernel.org>
 <apmfx08vccSd2MXw@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ww7DzEmaeFudEMkX"
Content-Disposition: inline
In-Reply-To: <apmfx08vccSd2MXw@gremlin>
X-Cookie: One picture is worth 128K words.


--ww7DzEmaeFudEMkX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 03, 2026 at 07:13:17PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Sep 01, 2026 at 10:47:01PM +0100, Mark Brown wrote:

> > GCS introduces a number of system registers, on systems with GCS we need
> > to context switch them and expose them to VMMs to allow guests to use
> > GCS.

> > +				ctxt_sys_reg(ctxt, GCSCR_EL1)	=3D read_sysreg_el1(SYS_GCSCR);
> > +			}

> I had AI check this (and I think sashiko also hit on) it but this is a ch=
ain of:

> 	ctxt_has_tcrx() -> ctxt_has_s1pie() -> ctx_has_gcs()

> Is it correct to make the gcs stuff conditional on tcrx + s1pie + gcs?

There are architectural dependencies which mean it is not valid to
configure GCS without S1PIE, and S1PIE depends on TCRX.  I had
originally written the code without expressing this dependency but on a
previous version Marc asked for this nesting as an optimisation.  Since
it's about optimisastion adding checks that don't otherwise exist on the
restore path would doubtless get the similar complaints.  Exactly the
same concerns were raised on v19.

> And it seems like that feature depends on ctxt_has_tcrx() so _architectur=
ally_
> fine, but it doesn't seem like KVM enforces the dependency at all and so =
in
> theory somebody could KVM_SET_ONE_REG a GCS, !S1PIE configuration.

> And nicer to be consistent everywhere also I think (+ shut sashiko up! :)

FWIW I do agree but I'm not sure how else to implement Marc's feedback
here. =20

We could do checking of the ID registers at vCPU creation so we could
avoid worrying about them in the fast path but there was also feedback
about not doing that.  One idea I had was to generate feature
combination validation from the MRS, I think the main complaint was
about open coding things rather than having the validation per se but
ICBW.  Last I heard we were very near to having code for working with
the MRS released which will help a lot with uses like that.  There is
the possibility that people are relying on doing architecturally
invalid configurations though.

> And it seems like it makes it possible for a silly VMM which sets up the
> registers wrong + some unfortunate guest behaviour -> oops via:

> el1h_64_sync_handler() -> el1_gcs() -> do_el1_gcs()

> Because the host's restore is skipped for s1pie=3D0, gcs=3D1, so a naught=
y guest can
> set gcsr_el1.pcrsel=3D1 and some value in gcspr_el1, then the host will g=
et a
> mismatch and trigger the kernel die().

Yes, that's possible.  GCSCR_EL1.EXLOCKEN would create similar issues.

--ww7DzEmaeFudEMkX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqZ23UACgkQJNaLcl1U
h9Al2Qf9ELbi7FMrvb55gE/GD2/KOEk1DQNXY0/pdhRkKK5qem9JnkbO+L14rCTr
UAItGA0GK83uI0GsfGMcj+oMPSMdbYvXFkruxoB9rq15icQhDSJ23bs7AAfowinc
kkURT3oHz+G5t1sjwqswxdDjgVnIBF1f1Wy6UGOLNDGubJC1N8Gg+5tkHSQbz44j
i2T04NdcyfXNQ6Zauee2wDnDG7ER2rPCRQVs0bKbiKG5DGkY1qLKgz/wunubw5Qd
sS+p5dbX963skXH+nupEIW2HmAGu1cnU8hN9uOQw8JrsNJF743QHBNO+HPQqX4M6
1M/aypWp/LTSHMquahmBniNSxNWzlQ==
=1LHo
-----END PGP SIGNATURE-----

--ww7DzEmaeFudEMkX--
