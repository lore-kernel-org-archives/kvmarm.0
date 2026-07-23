Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256EA466AF7;
	Thu, 23 Jul 2026 13:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784813387; cv=none; b=EQBIKTZxrTXolym/Q1b7Y8O2sF8VGHSeR6Cn9e8LQUHYckMDa5EoIK9Xx2Rw1x5TbXoutWKpurUyGI1Au2+CJS55TgHrQCxb3hxKATMBzcArDsA5+zon9yHAsSAc3oz5cIE+NOEMsnVjrPWkz7J3nGMYpSBzntmKMFRW43Fpkrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784813387; c=relaxed/simple;
	bh=huc3yG83fdTvCa219S/GL5mOlr601CiWURl4kKI0ycE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nelE2Cn+G/cIpP8RVgwMlNR9JbH5eJCB06PUDIt9QiUtcrHZTDSuaCTDrFYZnviMW4fhEDuWlrJNqYXqCEO3a12/T097GMeQimF4C+yAKuXJCXbZZ8RFCWbsh8hU/bipgFKpfr0dhpO+mKX3mfYENiXnBOurFxxAvZRw1g+WzlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R84+BwvH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R84+BwvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140501F00A3A;
	Thu, 23 Jul 2026 13:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784813386;
	bh=Z2KgZbO4TpspWzJ5rnBgNBsTAdx+AtGXW5ucqQ0n40k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R84+BwvHQdJrGxAXuCFEMD/ibO/8LHDMJtfIsL0TwN+2c2On+rU1v46Q43MVqh+hw
	 TeqYLTGpaF7k/cfe+XpEux1Hnt/4KY5H7y5dNqS8OI7vUkwT++LbWijvO6+PWbC1Kx
	 6H6zzVwx8LPZJqYyEKifO+i6S3frFTbf+7qxCrI3IQZkIAjcuTPAxtcBGqC3sKBo0c
	 NdvjTNWL07CUd+Un3nWQKHebOeSBmvQsY7W0Ha2vnhCJ6PgVvxzLDjWsYoXElS+o+b
	 y7eoSHf2iJfy1HdK37+BDiUOLj1MfzZovughDLkVcytwZ6t4oGODVvk8AerdCOfjwW
	 Ae7HuAtdxQ4Pg==
Date: Thu, 23 Jul 2026 14:29:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v12 02/29] arm64/fpsimd: Update FA64 and ZT0 enables when
 loading SME state
Message-ID: <49b06fd7-3cfa-4320-8e24-9ac88c91fb8f@sirena.org.uk>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
 <20260709-kvm-arm64-sme-v12-2-d0301d79ef58@kernel.org>
 <ali39DG6qie7XTuD@J2N7QTR9R3.cambridge.arm.com>
 <15a9ae14-395d-472a-a5be-9e46524fb493@sirena.org.uk>
 <3c76650f-ddda-47ae-a676-86016d8e39a6@sirena.org.uk>
 <CA+EHjTw9rGvQyev-4i7zkO5bPPZKGYn858485dCs8iHmCi0t3w@mail.gmail.com>
 <43f21c65-c5ba-44a3-9741-548390df369b@sirena.org.uk>
 <87a4rnqsuu.wl-maz@kernel.org>
 <18229974-b26d-4eed-82f7-7af7e1c26634@sirena.org.uk>
 <amINV-ZyUDXQW3Xg@J2N7QTR9R3.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4A0YswpY+SjfO+B2"
Content-Disposition: inline
In-Reply-To: <amINV-ZyUDXQW3Xg@J2N7QTR9R3.cambridge.arm.com>
X-Cookie: (null cookie


--4A0YswpY+SjfO+B2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 01:47:19PM +0100, Mark Rutland wrote:

> FWIW, my view is:

> (1) We shouldn't make speculative optimizations. Removing unnecessary
>     code is fine, within reason, but we shouldn't be adding conditional
>     logic.

>     To that end, I'd be happier with an unconditional ISB here.

> (2) Optimizations should be benchmarked to some extent, such that we can
>     decide whether the trade-off is worthwhile.

> (3) In this path specifically, if adding an ISB is a problem, then it
>     calls the wider approach into question.

> Is there anyone in particular that you expect feecback from w.r.t.
> barriers in this path?

I think you mainly in this instance, given the sysreg_cond_update()
stuff.  TBH I did actually write the unconditional isb() version but it
just looked obviously silly next to the sysreg_cond_update_s() for the
register and I couldn't imagine nobody would raise it as a review
concern, perhaps the best thing here is to expand that into:

	if (new_smcr !=3D old_smcr) {
		write_sysreg_s(new_smcr, SMCR_EL1);
		/* EZT0 and FA64 are not self synchronizing */
		isb();
	}

instead of using sysreg_cond_update_s(), not suppressing the write would
make using sysreg_cond_update_s() for ZCR_EL1 look strange. =20

An alternative would be to just drop sysreg_cond_update_s() and it's
usage for both ZCR_EL1 and SMCR_EL1 but given the existing code
suppresses the no change write that seems like something we ought to
benchmark and I'm not sure that's proportionate effort for something so
straightforward and localised.  If we didn't have the existing write
suppression or it was very new I'd not worry about it but it's been
there since forever.

--4A0YswpY+SjfO+B2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpiF0EACgkQJNaLcl1U
h9AS0Af9F+UeoG7xUnYhO3VjqKx1wGlsL/qur89XzqOiKlo36Jx4iNNK4x0mzUzX
zFdcttRmzRHvtbtiztojx5d5WkKmknKrlPz7b4WUfTrejFqVWWJJ4pR4p4Wsmuh1
xv47DGyCtC7FXetqftu44vOVYhmRLTL41AC3cNn6deMNZWojSfpvjgKW3oYphKh4
fRn6bi8U9onLSGndPYBg99kqw3jTbSsurPsERinrsrILC+FlPMsWHe8aApuCzOxo
LiMbcoWarmyxdT6fb20mmxA7ghZVphb9eOLu3Nkne+t7A8WcDjRhrcq0n3YXkwwI
d8KAj6UwK4lsj65nBS3mkdLxt6miPw==
=/mQp
-----END PGP SIGNATURE-----

--4A0YswpY+SjfO+B2--
