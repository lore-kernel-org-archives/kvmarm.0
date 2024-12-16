Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C757143725;
	Mon, 16 Dec 2024 15:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734362425; cv=none; b=q/Wg2n3xYsf/GXLrDG0hyplxPWGZIIjeEMt8YQDZkIxq/jhweSPCfkiVwz9rFquA61FRcibS0+wfUhoPBIjr8aUx7WLx4ZMRtSs60DLX7rE4QxLSgiFe8nse1ICxXBGIDZj9dwxoehCQo1yX0V/vmhp9yeWFBz0T0YwvFHJHYFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734362425; c=relaxed/simple;
	bh=niuP99foet4I342cbmg1ad+24zmVWlrRXskx/PKgMeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k5GGD3jiEgM74sr0SiMlAycrnyBKqxxgGN06oL8iOOcH9lQCiC4FLgZSN3A3XjBmNgjdQ+McN31InIuB0GoDsNEWo5h63ElWda4a5P95qQCE6vKrtuIkq6JlWKhOXRzPo6S7G6uk7WxpsY0INlE8iF/qlqYEWApLqj+jldGSn58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZ6by4yZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZ6by4yZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD1CC4CED0;
	Mon, 16 Dec 2024 15:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734362425;
	bh=niuP99foet4I342cbmg1ad+24zmVWlrRXskx/PKgMeA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AZ6by4yZy5p8vmJWprcWcSzejs0HD301qf7H6WGL/P6uFexO/i9/4THiOROKKjpTp
	 p3lnXZsO3Ls16sah2Fl6o7xN+KkkINT5geZugNL2AyxnQXoGRA3f1PYnqdw3nEuUBH
	 A4xbs63Q6+6yfgaTtYomCnJ+Z0lEmm4Ylnlrjw6T5o3HkJWcOvk8u+3fVkmQSiTMpw
	 sHgOFR4GQdICKtqjuAuasMCZvCT+a6wjiuccd9G+hR9T2pIro+v8Ik7Kwd88rGsIgL
	 rb9WtkeQJBDgFk5SjIpmu86iRrWrFzyJaZp7FcjmvK/HhV1bDdAlLNJ2EWb/s8KNnM
	 /5ARr9FnqUtXg==
Date: Mon, 16 Dec 2024 15:20:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH V2 08/46] arm64/sysreg: Add register fields for
 HFGRTR2_EL2
Message-ID: <4830a422-9acc-4d2e-86e7-7e75af340dea@sirena.org.uk>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-9-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gbV1zyZYu1Z/82Fp"
Content-Disposition: inline
In-Reply-To: <20241210055311.780688-9-anshuman.khandual@arm.com>
X-Cookie: Be different: conform.


--gbV1zyZYu1Z/82Fp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 10, 2024 at 11:22:33AM +0530, Anshuman Khandual wrote:
> This adds register fields for HFGRTR2_EL2 as per the definitions based
> on DDI0601 2024-09.

Reviewed-by: Mark Brown <broonie@kernel.org>

--gbV1zyZYu1Z/82Fp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdgRTMACgkQJNaLcl1U
h9Cr+Af/be1pfnGEb8Mpa6M3rCI0zQapxUu/nCyhxYEhFwSgpJKVWvmG8wKwfN5r
ecIGCKLibBIafWvty9jw5oEbM+FYxc5Joqop8XlJ0MxphUH1wiu8Qgui1hcvDzCI
p3src1DgDTlRMnrWCaukPFpVXz6Cp99JpV1OzbfrLFcqLemdEaeuUB7bt8qWFktY
kE8BC3XoDUq5GzU17ZmfEIEBlNmzY27YBUA+5tx9RF58jC4WJ4Sluznfm9kGQlgc
SrwdZ/TmsVm+qSbY9yNl/Y5eeLG3J9dNr8+zEJtzUU0GbBG5jVf4KkjpyFkLOLjx
ih6XgEVmGbb+L2n2jishqNTXwKJ+ow==
=9/v5
-----END PGP SIGNATURE-----

--gbV1zyZYu1Z/82Fp--
