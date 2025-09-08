Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE5B219A89;
	Mon,  8 Sep 2025 13:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757339887; cv=none; b=hcaOA3ei5Ab98ZdjxpLA8VpcTnUWQiWbYY4BKFrGi/Fd7esjcOUJBiTL9kER7btiwSr14j8M78Op5oBK9herbuXJ50yOr6olQWgj4AqBL4vWFA6m6H5utYgaK++qfh7rLSMOvi33k1iSmzQPEDD71CjE/i0HvobxuH38W2Cyp3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757339887; c=relaxed/simple;
	bh=ChmIAcj/dnFANRrz5jNvnNUzLHzNhXpK8n1dncSrldM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S6HIbgY7LLJt+l5n/vRNwoKIKxcRhgo2odL0onostOCNwr1fwaA5gjEPQsAGHkZXDSj6cr8w/0ZFnfrT54LgkPkukk6BCHj8xM65iIdkitLpGe8wWZQarjbSZvWHPr5UTlGZiXiUjl1AR+k+fDX9UceYkrOGtjd74x4uUeTVqZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s9P+QMlc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s9P+QMlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B949EC4CEF1;
	Mon,  8 Sep 2025 13:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757339887;
	bh=ChmIAcj/dnFANRrz5jNvnNUzLHzNhXpK8n1dncSrldM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s9P+QMlcB6/kv65EJ/r8wgbS1+rtOGpcJZUD3K2SSnlyfyzMP8DgDTBOVsziC87ae
	 /egbfDyxkD5rX9oSgZVjb7NVefInUL4WblogJNfV3+OQHHKQQpEnrXG0Xi566B+TR1
	 gX4+mCXL0bfdZ0/jA0ufVCBMIIibVRZ2HmdLLAc8yQrsBu4xP7jUhn6NQD8qp2F+as
	 a5D+4mzU25h7R40AJN/y6zcCH/hI0aDQ/k8zlMzoYRfjG0YUdJy3lQPvHPZxoMP7Gk
	 6BvWpUPTcBPLsZHe40AL7pooO7YRLZVkRZ+9LxRGC15ZP4n6lYQ5iru41RQoaXhH7b
	 W+Fb8Cjzu2tTw==
Date: Mon, 8 Sep 2025 14:58:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 1/2] arm64/sysreg: Update TCR_EL1 register
Message-ID: <a195095c-8ebd-4d74-959b-7b407d416a1f@sirena.org.uk>
References: <20250907123000.414181-1-anshuman.khandual@arm.com>
 <20250907123000.414181-2-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Fenb2D74LwSI5seO"
Content-Disposition: inline
In-Reply-To: <20250907123000.414181-2-anshuman.khandual@arm.com>
X-Cookie: Air is water with holes in it.


--Fenb2D74LwSI5seO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 07, 2025 at 05:59:59PM +0530, Anshuman Khandual wrote:

> Update TCR_EL1 register fields as per latest ARM ARM DDI 0487 L.B and while
> here drop an explicit sysreg definition SYS_TCR_EL1 from sysreg.h, which is
> now redundant.

I actually checked against DDI0601 2025-06 to spare my poor machine the
strain of loading the ARM.

Reviewed-by: Mark Brown <broonie@kernel.org>

I guess the cleanup of the redundant definition could've been a separate
patch but it's not super important.

--Fenb2D74LwSI5seO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmi+4OoACgkQJNaLcl1U
h9DpUgf/eYIiyohWTImwl29rN26NIgS5XpcDfsusIXjvrtJB++D0WIWMytjRlJQW
fmO8gsCX7JHPCsUWsVW8XGlK4etS1VKCNzhrrdhddLXpba6ehzkIIAL39P/55a1H
C5tRtgSOakcYFO9RgLunVn4NaXZ0onGAzKwgEzfQROETU1jxAFFPxPMzdX4NC6cE
1BjFexNWOPIXyde1/U7oQC4lqutO7mJ3JXfnwqJ7I2POTngOYtNzSfjaOxUUTfh6
78jdDrGCsyC8f0X9P8RNr+DBI1nsje/20MI6akPiwMDbD61NYkNuQJ2shiOdG+Fz
bAE6/MUBIxbUJaEUZXpZVZuDh8sxDg==
=Md/t
-----END PGP SIGNATURE-----

--Fenb2D74LwSI5seO--
