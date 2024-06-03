Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D17D12D76B
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 13:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717422921; cv=none; b=cAeXVrJ2VW4eg5PKqwdXJWGDH+HlrdBpFZAqo3Ugt6zKF84j346qYbLQyksV1LGEyprmQFGI4t2nBTMq8hSiCN50RofavaJgbmmkQjt0NGAtHoJpx6/8CdlwqQOO+Hgnnk/O6dxAXk5B84kgCWuvjT3NVr9KZaUnn3ozBk/ZPIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717422921; c=relaxed/simple;
	bh=xA3oCa1CYEd7ouy4Sh7Ptn757ZUwZHe6DLBlnd249vA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jK+yMbJ8vdTnsbI2BQ638t0gEUz9QZ/p12q71bIeH2c41SBJD09Ww+lSOmsuwmpWNXqDGM8Y4wWtsqoBm8ubQZAenCaPkRDV/hwFhZZLAMHaBsutRTUttgX6GFnDZr+i7DWO+I9ZIs7ukZ7OZWk2a3bsOY1L/TokmZDv9pPJeSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dPYhl7jH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPYhl7jH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70669C2BD10;
	Mon,  3 Jun 2024 13:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717422920;
	bh=xA3oCa1CYEd7ouy4Sh7Ptn757ZUwZHe6DLBlnd249vA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dPYhl7jHMrC/AU7rKi4D/82hPKSj7YLSnNyN7qS8ShroeMFFUqrFAPAZZg38WT3F+
	 3zDdhZBUPC/eiuS06Krv63c5fFIem+hQIllNroTQzDEqFNbk5yho22hMUuVzyrn8/C
	 7FEj1hRor6vPa6BrfIZGl9m2x+Z/boSSeJEuzbYktB78uCStzkWy4AiCDhAdU5Lrzl
	 88nCdIhWzVUAgqKKFXrs8CQcwjcHe2eNTowzSSICdqVuTao9ApUT2xYI3h6uslqA4S
	 NGsP+5UD1XpDhDWnME/iJCszncEZI+H1wYIWCCvE4H+J+y60CHdpDxA0+FlfnT/dW6
	 dxwoMshqxsN7w==
Date: Mon, 3 Jun 2024 14:55:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v4 1/9] KVM: arm64: Reintroduce __sve_save_state
Message-ID: <8d33e86e-893c-45b8-b16c-61a4fb91cc30@sirena.org.uk>
References: <20240603122852.3923848-1-tabba@google.com>
 <20240603122852.3923848-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nrlRnk/GKrdn3I7T"
Content-Disposition: inline
In-Reply-To: <20240603122852.3923848-2-tabba@google.com>
X-Cookie: Don't let your status become too quo!


--nrlRnk/GKrdn3I7T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 03, 2024 at 01:28:43PM +0100, Fuad Tabba wrote:

> +void __sve_save_state(void *sve_pffr, u32 *fpsr);

> +SYM_FUNC_START(__sve_save_state)
> +	mov	x2, #1
> +	sve_save 0, x1, x2, 3
> +	ret
> +SYM_FUNC_END(__sve_save_state)

This is still trying to use x2 as an argument here?

--nrlRnk/GKrdn3I7T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZdy0EACgkQJNaLcl1U
h9Br9Af/ew4i3dHWDq5Ijq+1lYvuNQ5sx67sSSMW+DAg0cfJAy4IL4S374EtNfxF
YKHiN14SZZEqJ6GXNKvtfBlQAsbSboaJowIUbVwW//pM/B8qh4D1CmaO89nsdd4D
ubdFQkP1G67Apk42tqOIK93vvj/2AQ9DZLatg5aD37D3AWoiUJj9ZwWzHFZv14D0
FU+sbUI7LXt0sCD480yW3+Tmk3mzg/0CdRFHlNCGKxD7IXfh/Y6pu7dk4WR//kWx
N+j6BNoVb+WihUQBcnxtFHicaHK4XPWIaULNDYTUbzf+xSzcH3lvAeOsgSvF/ScP
6YjsuWHEakHBYgxrDEuc2oL9VeFrxw==
=+B6H
-----END PGP SIGNATURE-----

--nrlRnk/GKrdn3I7T--
