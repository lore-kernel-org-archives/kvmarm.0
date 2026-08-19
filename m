Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28613B95F9;
	Wed, 19 Aug 2026 14:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787149299; cv=none; b=oMyK8pgD7+t0Ld5LCEcB5odU+7AN/XoIr/oSFnTMc4k6NpjRETLaY8Ey4+kseqmswGnD0uEWffuS8MOMs8v5ZroDlwhMI9ciIIcwkZ6PoFBNqNi+tjHACx8+Ly9w3KBNAoaQTyjc2VcRlJjtarmYy0fj8vn0GOV+fhPFuJ56jdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787149299; c=relaxed/simple;
	bh=rhf197F+BiirB2/yG03+JJ4YBW52Y4RN03qbnq1bpEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JCvHg47/VcgW54Y9pUlGp51ge2gy+Qw6vw82KrysyUCvsViQzHkeUg+b1uzUk3TzIKOaOZZpw1QuFNlN1e4GQZEKqiAjaKK1zoXKXlSBB5W6UH0RL9Ua8tNWT2qtfOCv4+IEcJ+/EYILgjafEmOpYRekFzHNfbkGIMU8l/Yy50Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VKohbjQt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VKohbjQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690E41F00A3A;
	Wed, 19 Aug 2026 14:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787149297;
	bh=B7S1oNZ0d0Ppxea6fIUZHSrjDvjafdvBHWU+BL8Rgkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VKohbjQtxpEmZPWdiGLLB53jtRq3gLpCe0pPm4oD94Sua26B3Kglmb6SVxKA6OG0f
	 778AOfOYD+EQhg5rwoTH/Mh2Nr9oYXU2aUIo+9oCFZPbbhYMbmrKEG3seFXbcjFxPu
	 n6x/OfeD3l9zX+ymmwzEuAau991rDSSAPuWarsTfX465Z+aQUOZkRYYDNejsSDq4IG
	 1GtOYdTBOTmjNvmGcMllJnFhsmrM/hXjzjYnxj7beNukeo+njCDm03/PwRpWovpB/H
	 huvDR/cmMtK4Wco3Hdy8DRXEjllzhs5g34Vlbder9j2EHOuiR+xEWNC8nJmUTyINFD
	 8TmGj9ssUkynA==
Date: Wed, 19 Aug 2026 15:21:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 01/14] arm64/gcs: Ensure FGTs for EL1 GCS
 instructions are disabled
Message-ID: <a6fe8050-18f1-4013-8d6f-38ecc754c7e7@sirena.org.uk>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
 <20260812-arm64-gcs-v19-1-9105afd828ac@kernel.org>
 <aoWyeTx8lYGfiwYc@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="EpiKBYt0FrKwqKPC"
Content-Disposition: inline
In-Reply-To: <aoWyeTx8lYGfiwYc@LeoBrasDK>
X-Cookie: Allow 6 to 8 weeks for delivery.


--EpiKBYt0FrKwqKPC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 19, 2026 at 02:41:13PM +0100, Leonardo Bras wrote:
> On Wed, Aug 12, 2026 at 08:12:00PM +0100, Mark Brown wrote:

> > +	/* Disable traps of GCS instructions at EL1 */
> > +	orr	x2, x2, #HFGITR_EL2_nGCSEPP_MASK
> > +	orr	x2, x2, #HFGITR_EL2_nGCSSTR_EL1_MASK
> > +	orr	x2, x2, #HFGITR_EL2_nGCSPUSHM_EL1_MASK

> Which I understand to be the way of us saying that EL2 will not interfere=
=20
> on nor manage those instructions that let software change the entries of=
=20
> GCS. Is that correct?

Yes, the goal is to allow EL1 to manage things how it wants (there are
controls for store and push in GCSCR_EL1 too).

> As for the asm routine, x2 at this point have nBRBIALL and nBRBINJ alread=
y=20
> set, and will be loaded to SYS_HFGITR_EL2 in the next block of=20
> instructions.

> Did I get it right? Is there any missing detail here?

That's the idea.

--EpiKBYt0FrKwqKPC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqFu+sACgkQJNaLcl1U
h9AZpQf+M2xlXf78cJhC8qd3kd3TCTXSK7OPaRFzCzopuFWugQZnO8gta1cvLRQm
hu7hPMPgHfsLHkw07V5RQBBFC7hdozSVwrGK61A7mB9I+Qy36CoYWDiKWXZZW08s
e5u09U7j1iikPNTOQlKmgWHyjo8HwS6CWHe2qBsGGfoIiOPE5TDj0cioyIsF4I0H
hCaXKaxmqB5S+1dIkeVTNbJIt5uSG9DCdA5vMANOK3LFFnENrQqoT0D4aiXB4Et0
/rigSzS3c/ubrD7/I6IFoiV6WoduU0gWqCG473s4ghVaY/3eWC+s7tQlXFDizf4q
8GbMdi6CGWTzUEA8Gfls55jI8SWUag==
=vEYu
-----END PGP SIGNATURE-----

--EpiKBYt0FrKwqKPC--
