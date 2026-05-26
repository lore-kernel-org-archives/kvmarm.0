Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C08038D3F9
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 15:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779810949; cv=none; b=d3XECZ10p+3NMr1tMgzGyEF6LqlaM+23Pri+pFQyAeHZdgJ8XAutK+gN4dPdOJN2ixwhG4GoQCGmMxDtqn3UJi3RQ1yme9TsMUwD08RPxBZGgHzmSMH9QO978GISHh/FHryA18ZttsQxp8ja7HfiShE8RfE2cdLWk99G7fBZRB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779810949; c=relaxed/simple;
	bh=EV4SvhejT2hQh0C5k5sKp9uFWYLIKDHLD8spzzDKdUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B41EQO31Bqa0NtNfaa9Zh15Z45ExLXBoWnWZvr8Jwdo6RUG+ZhkQwBQSSWfm1ayozeAZHNyXkzbcoadaKknRoICsr5XmYBwheIJX+G1ptBguhgvsX5pdSo9kgnFacRAxlAuhsJluwmKAOCudUDUbTqfAdEeFIVaSQvZtFbyckkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EFvF0zJi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EFvF0zJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2351F000E9;
	Tue, 26 May 2026 15:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779810948;
	bh=ZNg65F8o+4jumSNRPx/T2FFyZjl7IBIA2OxW5ATa7ao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EFvF0zJica8h5ETJEnWESEi62COQQvAI8gG/6Mvn5TxmQvDlzj0GpwYIywEBnL8zF
	 8TfdSm4FfwVJeAd7Zzq753jZw70BCRGyxh58QxI7uyGIDHsiuilw7mA56LlPqN1mu4
	 15+v9mjgXon1yGukYoHIJ31Stz9ddJYYI6NoAD529w67Qh7i++5Q0C4lBSX6ptpUVV
	 Bu+GgRQAhFr9JscQASUNAPStaxlz/ZtohuTghE0CdPTZZZR2rx8Q5McTT3U8SUVzyw
	 qHw7ySp8qao5boWgIjpeeF7pwm7EZDDBq0o8b20OERZD6Oz7eefv0RE4LuuABgDFam
	 gUKP1jOusXyGw==
Date: Tue, 26 May 2026 16:55:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 10/18] arm64: sysreg: Add FPCR and FPSR
Message-ID: <458fcb4c-46a9-49db-a179-9081d7d50dbf@sirena.org.uk>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-11-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="G7fW5B6xakMhz0Gm"
Content-Disposition: inline
In-Reply-To: <20260521132556.584676-11-mark.rutland@arm.com>
X-Cookie: You are fairminded, just and loving.


--G7fW5B6xakMhz0Gm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 21, 2026 at 02:25:48PM +0100, Mark Rutland wrote:
> Add sysreg definitions for FPCR and FPSR.

> +Sysreg	FPCR	3	3	4	4	0

This looks good.

> +Sysreg	FPSR	3	3	4	4	1
> +Res0	63:32
> +Field	31	N
> +Field	30	Q

DDI0487 M.b and DDI0601 2026-03 both call this field Z.

--G7fW5B6xakMhz0Gm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoVwn8ACgkQJNaLcl1U
h9BTRggAhNEDG+iEgC6Eic1xR0NKIc+l4w6x+B77WYe505Ojy6JMyp170pylXegX
wSQxHgZ08gYCuIDngbxHVDVQxICBRKRgwHyPewpbA1r3fd3wNuco892mJQAttRtB
F1I6DCPBFnd2U1qSLrhC0kRyKs4Wrh5nmElIS0TOTnLRy7xZA1H0cx1lidCV6nCO
CNZY/WQ/VYwAYQlxWfEFh9Ende+LakujTqczdm3KDTihx6xDPoUIW92WaYqjQjcK
AS3nB8VG/TTLREfKYiO2FPHJOF9S2eSRFfJQ+zss3rTuQHyANI7i5e+bo5qUBn3h
q4A+Updj86SXLrO1tjHhrcoZXaH2Ow==
=f89D
-----END PGP SIGNATURE-----

--G7fW5B6xakMhz0Gm--
