Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5537835950
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 14:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733754149; cv=none; b=YpkYBOh2SO3m05Am4GJIEKoQ7ILMAhLrbZ84UPPRoW1xpp+1MliaHfnXfKPESe0eRPZIQYB8F4NbFwwbCL/jHHuZ1RI9v+Yi2f2KRlJbHs96BD8ykkT00wtPd04XYisEmOoyZCwYA4rXJmikSXTG7eRt8eDazPR7EuJwJJhjGSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733754149; c=relaxed/simple;
	bh=Hk2ii8RYr1XXVNys27bsSr8dA87e/0mQrw7DBTk62cs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z+83OuE7UkRQzImwxGCcRzsP+DFc1CxHN4t2P/DeW8rFwOOzUV3QKWNR7LZgHYshK2T9fqxRupE0EDypm2d37VYqoVmOt29QI5x5onXsr00Ih6UpS4cxBXLOVRMrL2VVj4QkJK5YVEzPECvrmasKl5TrMDw/DcGWJNfa9GmqklE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eXeX3jTu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eXeX3jTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5283AC4CEDE;
	Mon,  9 Dec 2024 14:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733754148;
	bh=Hk2ii8RYr1XXVNys27bsSr8dA87e/0mQrw7DBTk62cs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eXeX3jTuvqP3UVfF8VrIE1fenbqYGh+4vZIaQfTXVAaF2DS4+GTfxT/MjpgvRFy1T
	 31HsBqWW4MQCaEWIqspfc3/mwafSogObGqis17G3wpa5B+K+hSDU5C+RwuQsIBe1ID
	 p8EnfcqMFt29bODXBllIfHVhDz/ogMRtd/aWatY9VAgQUMcrWdaLIqTk0ajSQyndBS
	 ccttENwb5qyWy7GBNVA/LJ1BrC6yE3zmY0JYisKYme27Us/7fFr0AopW2qaNjU6bCX
	 MSm3MDZp3By+xouIeS2DMuhvnp0t3SdjsRZ6dTMz6Bgr4bglgTpZ5YaZ/qV8zVYbSs
	 z73EJ7KuNJ13A==
Date: Mon, 9 Dec 2024 14:22:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 3/4] arm64/sysreg: Convert *_EL12 accessors to Mapping
Message-ID: <49a35d0c-7ed6-4b87-bbc2-02a35b5a9604@sirena.org.uk>
References: <20241207190740.2607673-1-maz@kernel.org>
 <20241207190740.2607673-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="B9oMMmb8MLjHL9v5"
Content-Disposition: inline
In-Reply-To: <20241207190740.2607673-4-maz@kernel.org>
X-Cookie: Lensmen eat Jedi for breakfast.


--B9oMMmb8MLjHL9v5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 07, 2024 at 07:07:39PM +0000, Marc Zyngier wrote:
> Perform a bulk convert of the remaining EL12 accessors to use the
> Mapping qualifier, which meakes things a bit clearer.

Reviewed-by: Mark Brown <broonie@kernel.org>

--B9oMMmb8MLjHL9v5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdW/R8ACgkQJNaLcl1U
h9BvnQf8CDc+zo4lXTgr4kzGL3vkHBle8d0SVe3490in9rDummjt8l3/8zpiP4cI
jlfq0PIGYLLy906pSFRHsJyvT7mKVLwlNZb/Bz3y2uX0YD0V99LSVTzoemNLBIjq
rij5KXLlaOs90RmEIW6fTb5Of+ibaH+9k1L+npmblxSoCTlUV9vtST+VSZD2jCjq
hOHIRkBTiJatGpRkaLJY1z4tKNC4yHSmonItysGh8YCdiqHsM5uYQT0eBRuIcM6p
MZsEDC2ng9gr17YLqkgDD+iGO1v+6RcEGkvLezZmFPJXfre0JcT2s1I8ERc1oA6F
z5yKM/IGxCLpenbZSwljSmapKNSYhA==
=3jqe
-----END PGP SIGNATURE-----

--B9oMMmb8MLjHL9v5--
