Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEEA128361
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 10:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713264649; cv=none; b=dVrv0Nsye/we4iju68KdxTSytqzinQpaRicgV4XU7T4UXVfjfdQ/M8MsSV1eeWI2GiRKRnv4UKn3TtBTCqhoeyNTNckqKbQNkkP6kxkBQGLcC32nnGiovytt+NSZHeNjmfh+dMFgzZ+vKYjSXRfWhuLpY4i1vndL8AAA63pw1/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713264649; c=relaxed/simple;
	bh=1JrEfUVSDWauZnvoCs0RQ0MewSe3/dsBzqhVbDmWnj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GhZnAXBZpxFoSZhZA6JrER1uWXN52RuiMKxeqZAtIHXb/iIaFbZddBXXX71RVFyWvrg1+DS6nZcYNnQD2YEFKoa4HDPw/K+7BhuoFtQ+Bv9gvmWq/CqVamd3Hydr+d1yXNX/7LzgXrQhOwsDmhnlQXlLPvQX+E7oyJA66p9on+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vON67qne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vON67qne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DA6C2BD10;
	Tue, 16 Apr 2024 10:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713264648;
	bh=1JrEfUVSDWauZnvoCs0RQ0MewSe3/dsBzqhVbDmWnj8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vON67qneKmdRvFPsMs8VaWk1sDySk+xcAKYcbadlqMYVByc+TBc4Fn7oQIdvBcx/w
	 DiGRS/cqKnSq/4Hn6s+NwC7tND9bfR5TMlWcNYUiHz7Wi7XGUpHvKTbPzqakomr3st
	 oiW8wiae6g8Ef9u9dRJgbresHw4W12/HxCra2VgsWDX2KDSMMYFkhekoe4y3J+uc62
	 yT3y0BnCR1jufoFVFzdkvwZ2B1hREHjkQmv5clXUi++AsulQSMlh4lp4d2Q25ny8tR
	 wm+P0k6IMSqIpEy01tWBlYOtdvJ3pyrEX3whL2/t61ReoXX4JpASbwiov0+3PuCAfb
	 mtai/IYcvw3zg==
Date: Tue, 16 Apr 2024 19:50:45 +0900
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	smostafa@google.com
Subject: Re: [PATCH v2 45/47] KVM: arm64: Move guest_owns_fp_regs() to enable
 use in KVM code
Message-ID: <Zh5YBTRJxLjhz7Lr@finisterre.sirena.org.uk>
References: <20240416095638.3620345-1-tabba@google.com>
 <20240416095638.3620345-46-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PvdWVN91D+nIfytX"
Content-Disposition: inline
In-Reply-To: <20240416095638.3620345-46-tabba@google.com>
X-Cookie: You might have mail.


--PvdWVN91D+nIfytX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 16, 2024 at 10:56:36AM +0100, Fuad Tabba wrote:
> guest_owns_fp_regs() will be used to check fpsimd state ownership
> across kvm/arm64. Therefore, move it to kvm_emulate.h to widen
> its scope.

Reviewed-by: Mark Brown <broonie@kernel.org>

--PvdWVN91D+nIfytX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYeWAQACgkQJNaLcl1U
h9BYZgf/Y1Xyd+tDfbLIhe0F/fv76doXhtefAI/x2hQjcG7MzRPxn0XuTtmODhvX
YIYn4HsT16clG12Zk5VlH34Qi2zxduGi+q3P2Kt2Tb4PhqSGoZhUfiRxN3PWcRAX
dvRNDHpu9SjZjZpmDIb826C3qL4Rbkke/w6XvOSWL8ZypKcRiIbGiqXIIZxJSSzb
UehxZl366DESPXF01dNyTHlsa+r6iZ4ZBpJu9lVbqI+V1RG5DyQrJas6oS92c+Ch
3kGdQD8GRxghi8YeJnpyQnTCZUjrD7CVpf12ztTKrWREFzzjPig49aklAh2VdXyc
rCaYzMLYeemRqInb1suiKNUkKi/P8A==
=1cB6
-----END PGP SIGNATURE-----

--PvdWVN91D+nIfytX--
