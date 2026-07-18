Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6811E330D34;
	Sat, 18 Jul 2026 14:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784384668; cv=none; b=ixbDm78SwkSDNZ7I9AqjNaeI2LK03hdW7PJkHLiPO9doTAxxoE8kBhT5EQ40iWWjGdVOdyB0LQjZhwn5qg75zFsJy73N64XXawUnkYTRco1HYN+Y1+M34qtCunwJdzxD19qx8uzgViMXoUK0ZPPaEh3ulw8Nvkcxs2gVpv/Q66k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784384668; c=relaxed/simple;
	bh=Sp6LEIaJIVS9L2IHVMDqH91fkjtvMLk3cHPyMYtk5zw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O9jvnjy3AySbDOkGglOqwwieuv5m5kq9kiV1ASoWrfjQHcYRd6Y8fix3x9JW0yKcTaA3lpMfbcgnr0JzYiMSFp6JSI1eDjLyzlMZ/s2RCMO1gRtBkXjZqA0y61Cd7Hyl2uo/Lb3EPSTT3DNW1iUFm9gD8/QroW28m6cV9N45Go4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MLbiH6aG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MLbiH6aG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EA71F000E9;
	Sat, 18 Jul 2026 14:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784384667;
	bh=I2X51PbVx/BFVJ6LA8OK813ZCDWpSmXg2JC3L04Zccg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MLbiH6aGlQARFRsEAlT96uAdWJuJ+GS0r6dW7tDq1vw6FAFXkn0jdnMzF3AgpUKTs
	 +jY/68c6WOZtDdG6v3RSGn1VEqqhvfNDvYgbdvnW0ItgrxgClhpUYrjCfqzhx2Wk8T
	 PsaW2+yf4C/qclVWDG8cd3lBFNE3hwxF997q66ouMDo2TCZRS0XkpVwAET+7Z1FVRX
	 AWnVu1p5q7vPD3g0zeInT4+2dB6E/lCWsg2PKFAshPiucSqc80AzCCT2AnvKBIV4E6
	 Gg2LwnlWCl+d1kBWuzdVbbpb0JBj7FjwJcUbmGnPWb1eeSkOEF4tAVFEXVyKK2TNBZ
	 RSMst6SU7+/Bg==
Date: Sat, 18 Jul 2026 15:24:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
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
Message-ID: <43f21c65-c5ba-44a3-9741-548390df369b@sirena.org.uk>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
 <20260709-kvm-arm64-sme-v12-2-d0301d79ef58@kernel.org>
 <ali39DG6qie7XTuD@J2N7QTR9R3.cambridge.arm.com>
 <15a9ae14-395d-472a-a5be-9e46524fb493@sirena.org.uk>
 <3c76650f-ddda-47ae-a676-86016d8e39a6@sirena.org.uk>
 <CA+EHjTw9rGvQyev-4i7zkO5bPPZKGYn858485dCs8iHmCi0t3w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="D59yeImOKcklFS0z"
Content-Disposition: inline
In-Reply-To: <CA+EHjTw9rGvQyev-4i7zkO5bPPZKGYn858485dCs8iHmCi0t3w@mail.gmail.com>
X-Cookie: Do not pick the flowers.


--D59yeImOKcklFS0z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 18, 2026 at 02:30:04PM +0100, Fuad Tabba wrote:
> On Sat, 18 Jul 2026 at 01:35, Mark Brown <broonie@kernel.org> wrote:

> > Actually I remembered: while SCMR_EL1.LEN is self synchronising the
> > "without the need for explict synchronization" wording is not present
> > for SMCR_EL1.{FA64,EZT0} and this is no longer explicitly just an update
> > of LEN.  It's possible I'm being overly paranoid here, I'll leave the
> > isb() and add a comment for the next version.

> I went through the ARM ARM (DDI 0487 M.c) on this and I don't think
> you're being overly paranoid, I believe the isb() is needed here.

Thanks for double checking so thoroughly.

> And task_fpsimd_load() does make indirect reads of both fields before
> the next context synchronization event: sme_load_state() executes LDR
> ZT0, whose execution at EL1 is trapped when SMCR_EL1.EZT0 is 0, and
> when PSTATE.SM is set sve_load_state() executes WRFFR, which is
> "illegal when executed in Streaming SVE mode, unless FEAT_SME_FA64 is
> implemented and enabled" (from the WRFFR description). The MSR SVCR in
> between doesn't provide the synchronization, since SVCR's
> self-synchronisation wording covers reads of its own SM and ZA fields
> only.

Yeah.  We should be able to optimise this:

 - If there is no change we don't need the isb().
 - If only EZT0 changes and we load state where ZA is disabled then we
   won't try to access ZT0.
 - If only FA64 changes and we load state where streaming mode is
   disabled then we won't try to access streaming mode FFR.

I've gone and implemented the first which will suppress the isb() for
current host kernel SME usage, the second two are starting to get more
fiddly than seems sensible to do right now.

--D59yeImOKcklFS0z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpbjJMACgkQJNaLcl1U
h9Aa2wf+MFnftbhCaUZX6WuBgJ/1JcYOGHYcvRPNQIAJbA+FOcoEoAhxy9zmXj4E
Lj0HbydOLUFDNPTHJkNwKiBFX1bMmV6G4zai0jO0hNEdSrINc3XsQIvPZ05V/wnf
P/22rDBegxR4h6onZCxuJybhd7tHT7HEzr/PSHT+7jq4UjUwNwFUafSkF1a4Wo+i
OXEs6TU0LE4WFCXXKAZQDXNwT4uZcNtcFz+zXupnqRMWaaYyXY1h4PNvm7gl4UMK
nizzA8eTfz10eI2NXtoYUDakxs+r3DKc1PF5a1WQaII9na/Ta1YymODmNqjNOSJv
PmJ5ahScZWWJKbSaPYCK0A9YyOGYKw==
=11bz
-----END PGP SIGNATURE-----

--D59yeImOKcklFS0z--
