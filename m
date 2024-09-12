Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684043A1DB;
	Thu, 12 Sep 2024 14:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726152333; cv=none; b=fHeWEyuQFKIderKaT3P29sIds5oeYOKmEKaIU7JbdR5CnOydh3tpIMGhcUqEC7yYGtL+Ny5lq99pCC9CUppjNiD/ApStlzDLTxVgFkEFXp8cX0q+EG5RQ1vLD3jUkcMQ7dLp8mSrQLeLLji/cqocvYi91gmTxrSADysD9pUsHOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726152333; c=relaxed/simple;
	bh=mxjYBhgowa+hjwoRUX8TMN4qUXla0ab3yShjgqYmAZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NWvyVFX93erbH+96TH0IKYwsjYUIqdXDwViP1Sq6uLCTonFqu1Aw8GTYZqiR4ZOIQNjPeC9h/ur6qLJxTzuEhwjmjlu5SxLGcvBcdqk1UAebe74MSdYxtzGYkaYSfWGbC9HYj3qTgdnQhEnp7l6DarCdeYQgg2Two54Wf2uNieI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mdcLyu/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mdcLyu/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E51C4CEC3;
	Thu, 12 Sep 2024 14:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726152332;
	bh=mxjYBhgowa+hjwoRUX8TMN4qUXla0ab3yShjgqYmAZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mdcLyu/kHFaLs5fJSP8jTKdCOlB/C9IumoxREhx5ws9z5SAyNHEgDAqVCapVd14lS
	 k+m21hvwCzp1wgmpxC+HReq3XV5DI/WoREwlDEKTnpPEUvAQB30AaNcXzBDjf98H85
	 cEtriWooeu9kmTM/+3WmwYEnlr8oGabYVfOTd2xoWszjAQzgVE5kpQ5XVhRloeKMsi
	 RJ14l1PJKPvWH5SbhEEMT4qo3ocrdpnxrnBz3nF6a4rC0ZPTVoQin2tzFvgoSOK13v
	 UD2icaiMgnbDxgIPtRsPek44bI18ul/7T2k9o0FanhzcrhJzixmVW9uAK85z79e/vG
	 mmwyLbHfC9YDg==
Date: Thu, 12 Sep 2024 15:45:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Constrain the host to the maximum shared
 SVE VL with pKVM
Message-ID: <17cb5e48-ca96-433a-a351-639dd339dfb7@sirena.org.uk>
References: <20240912-kvm-arm64-limit-guest-vl-v2-1-dd2c29cb2ac9@kernel.org>
 <CA+EHjTyJcP0NcvhF0WeuF9_zuFSa1o7w8tA5J2eU=GutF+ZmRA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zvLpLCutOfqrtBno"
Content-Disposition: inline
In-Reply-To: <CA+EHjTyJcP0NcvhF0WeuF9_zuFSa1o7w8tA5J2eU=GutF+ZmRA@mail.gmail.com>
X-Cookie: Happiness is the greatest good.


--zvLpLCutOfqrtBno
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 12, 2024 at 03:21:43PM +0100, Fuad Tabba wrote:

> One part that you haven't changed is setting ZCR_EL2 during el2 setup:
> arch/arm64/include/asm/el2_setup.h: .Linit_sve_ : lines 290/291

> I guess at that point it's not straightforward to figure sve_max_vl.
> Is there a window after el2 setup where we might actually get the VL
> implied by ZCR_ELx_LEN_MASK, or would it always get set to
> sve_vq_from_vl(kvm_host_sve_max_vl) - 1 ?

Yeah, at that point we have no idea what any other cores might look like
and there's just generally a bootstrapping issue - we need to see the
actual maximum VLs for the PEs to work out what the maximum VL for the
system is so we can tell KVM what to enforce.

--zvLpLCutOfqrtBno
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbi/ocACgkQJNaLcl1U
h9DwIQgAgHAplmlFimeXOPg87QCxQYwQgB69MEEXPWng96GZ7ERHdeiWQrYeVXp/
nb+0pFchKtsQA0yG9m2EgTqXfTof58gl7jt9lEkHSu6eKnrKfL+CunUMN1ppDdvv
qxGoPWsGlv8y6ecu4WsBmcV5NXnaefdtPSy4+SU5Yjn1eSU9I+Tm63645qO+dznr
clV5kdld6v5Ac5T35ZueNxB9lKbZ02p/iKUB/vuyy0+vNynoDkph8UEpUsCjQb+1
Y0ADncVYT4a5FiLf05o5Fr8H4aktWP/yT59JSRqlNnQikXMgTWkn0qF4GjFIh2hJ
FK0q++YGLADrJF+lB+aIk+73HguFgQ==
=Hd54
-----END PGP SIGNATURE-----

--zvLpLCutOfqrtBno--
