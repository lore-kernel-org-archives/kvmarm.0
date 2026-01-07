Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DD3258ECA
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 12:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767787203; cv=none; b=Gy9syi5CJvCJ0y7UolBg8ySFpu4+UU34PyttKP7nQsc/8jSopgo3aCIl39I7gr7Yl4kpLyZpiLNXuRKoos4scShC+PJLhZ8h8PzoXO/NoL7QVG5XfmOlp2UmHY9yW9JzjMaEXlg7B+jdKbxo7nExhFyIcuUNK7UB9Hr5ymKcu6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767787203; c=relaxed/simple;
	bh=c8Vo9dsyzzNPonTUyLVifSACgsr/xvnHu5Rzrn29nUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qRINmh6+PB3lBDbuD0NtLKn0qWgpS5MQfbs5qE5fWnLlu7IUgT2y50JxWCbEdHjtss60pxrVdFWgYRk+tHb1RRkfg4apqHDDLq3ENwDgXy6JIlsSITmM0Zm344S7lYL2EuSiJNFggD/35/Q0oJzbhYzCe5l498m+tyvR/AX89Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aykSm78Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aykSm78Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3EEC4CEF7;
	Wed,  7 Jan 2026 12:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767787202;
	bh=c8Vo9dsyzzNPonTUyLVifSACgsr/xvnHu5Rzrn29nUg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aykSm78YRBaeK2Nn027FpWoMFfGw9mr/20rtbrqwagJz3x59N1N2tYu2IGNa5+IGd
	 NdyN5ke260TrzgN1d8vV4X2acRLg9VF48Vlsi1YoLrQPcfexz0VEp1B7iBpx1pLJZD
	 a5pRVOZOdeWatXEWXm8MuArP92IvlVEVZgrLjgE6WWhTjDsrtwS6HCbHFBJQwI1vzI
	 PfJOw8+c5Ciz3TiynEEGFGpJQg6g8TNZdk88wunXManbFJDb8cN0pdY9wMJBCylFb4
	 GqdinOV2vdEVcHaATZtfXeQYXW7f+ipxH+h7ck2v5KyV14FUF2qhZW3rHar4SfAzTP
	 cxwbaERc1hMiA==
Date: Wed, 7 Jan 2026 11:59:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, maz@kernel.org, oliver.upton@linux.dev,
	tabba@google.com, will@kernel.org
Subject: Re: [PATCH 3/3] KVM: arm64: Remove ISB after writing FPEXC32_EL2
Message-ID: <82ace4a0-716b-4e20-b74c-780a28832407@sirena.org.uk>
References: <20260106173707.3292074-1-mark.rutland@arm.com>
 <20260106173707.3292074-4-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="F8CNh9YRKDELmQeX"
Content-Disposition: inline
In-Reply-To: <20260106173707.3292074-4-mark.rutland@arm.com>
X-Cookie: Is there life before breakfast?


--F8CNh9YRKDELmQeX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2026 at 05:37:07PM +0000, Mark Rutland wrote:
> The value of FPEX32_EL2 has no effect on execution in AArch64 state, and
> consequently there's no need for an ISB after writing to it in the hyp
> code (which executes in AArch64 state). When performing an exception
> return to AArch32 state, the exception return will provide the necessary
> context synchronization event.
>=20
> Remove the redundant ISB.

Reviewed-by: Mark Brown <broonie@kernel.org>

--F8CNh9YRKDELmQeX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmleSr0ACgkQJNaLcl1U
h9DypggAhbniX85c/2LRXLMPuqwJNp1Ckks0jsb/diW3g/klnt7da21jL97LWuJ8
qSOtXy2npPphiTLN7j2u5cu1Bp7ISZth76D1a6apHA2efySFkOnkuhCprVQkJn0A
0I24b6FNqtf3xyMyChm44ZTJKRmky8ltMBtVBRx+rVBPYqevg3pdFtocAB3zlYY8
XTZNB8Fbol2p7ElgaPidfRPnMiYS8rGi4iVP/f2y+6gtskK5mOrj//I8ZL2gmTpO
LQDyWIKVGBuY3OCFIy89yPdEwjOGQr9m/ixTU60LF5YrrgdQIz/rjUUjP+5uXDNx
9GHHbGY8Nx/flbHOrYvlViNQ4X56Mg==
=i/o5
-----END PGP SIGNATURE-----

--F8CNh9YRKDELmQeX--
