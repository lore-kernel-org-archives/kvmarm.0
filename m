Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C67A935;
	Wed, 19 Mar 2025 13:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742389356; cv=none; b=UsgVAo7gFQC99ulPH21oKwM/AlaXzfBWrHC9VtQwVq9YUAPog8kc/AAp5S5LtdNsHljAcjM7vIj8W2icyuDPpa1cFpuXNmtz3tPAv2/twcWczeulbSo269BnD2KEucV/19NU81EIfa7c5br/PSp4+LoHXpD5UgmQmmm1YNxRP44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742389356; c=relaxed/simple;
	bh=b5MAxAbhDjq6ZZSL+MGfjF0CskG7HgvkDEAYGiOdDq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J6ne/Sx8QsReemojU36vyWVruhOwYqIvyBFCArL5ZSYJ5lLQ6dgnXAQeKco0t68YYQP0t2kEGNHjMAyrBT00jLkTsJuC5mJ3V+ymQhmUs5rsGuSNvSFi2KtXHRNIkLOXGql0uFMel+cbPv8lGTDjbR08I8dfO+o8VM7xEIufmEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I2kglXAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I2kglXAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635F0C4CEE9;
	Wed, 19 Mar 2025 13:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742389356;
	bh=b5MAxAbhDjq6ZZSL+MGfjF0CskG7HgvkDEAYGiOdDq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I2kglXAat9+cETPdezJ9I+/0XQsd/3vBuEOuaW/9wTeIzdPqhLgnNzofNsLxKFduA
	 NFnN4kvMDersEzqtPRxHkGhmD98ux4FAIFzbRsGtMb6CM42PVofnPabL7rOKFO7vwJ
	 4tUc4ta5uB6KhU36B8y5AdWr18dqzTqJ2X9aDsqnrsvkaEs3GZYgpgug+7t2494H1U
	 Bu0zTRMqwClOBBTFwirLPaCnpBjbKYzqIaKOWiKoHMbK3HiZh/GquicmEnNdjQ2Y9m
	 NxsI1ueqrBKHsWsCB6YqfX4Fj4sbIKeyJM1LsJ+2Pzh6wQvZbzeNk+Awjt5ChhUOiI
	 SMZ53uBCn6Lsw==
Date: Wed, 19 Mar 2025 13:02:30 +0000
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gavin Shan <gshan@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 6.12 8/8] KVM: arm64: Eagerly switch ZCR_EL{1,2}
Message-ID: <83ba4e5b-7700-4527-8376-2c60507bd0d7@sirena.org.uk>
References: <20250314-stable-sve-6-12-v1-0-ddc16609d9ba@kernel.org>
 <20250314-stable-sve-6-12-v1-8-ddc16609d9ba@kernel.org>
 <019afc2d-b047-4e33-971c-7debbbaec84d@redhat.com>
 <86r02tmldh.wl-maz@kernel.org>
 <Z9qaW_H9UFqdc1bI@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="48i1XDxjnyzJoEmY"
Content-Disposition: inline
In-Reply-To: <Z9qaW_H9UFqdc1bI@J2N7QTR9R3>
X-Cookie: Chairman of the Bored.


--48i1XDxjnyzJoEmY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 19, 2025 at 10:20:11AM +0000, Mark Rutland wrote:
> On Wed, Mar 19, 2025 at 09:15:54AM +0000, Marc Zyngier wrote:

> > The result is that this change is turning a perfectly valid HYP VA
> > into... something. Odds are that the masking/patching will not mess up
> > the address, but this is completely buggy anyway. In general,
> > kern_hyp_va() is not an idempotent operation.

> IIUC today it *happens* to be idempotent, but as you say that is not
> guaranteed to remain the case, and this is definitely a logical bug.

I think so, yes.  I suspect the idempotency confused me.

> > Greg, it may be more prudent to unstage this series from 6.12-stable
> > until we know for sure this is the only problem.

> As above, likewise with the v6.13 version.

Yes, please unstage these.  I'll send out new versions.

--48i1XDxjnyzJoEmY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmfawGUACgkQJNaLcl1U
h9B7twf/ZUvdzHI6/ofuTOV2FN8KUBzERD5r5gX2ERnb6+ulsDq1weTD3yOHhVAt
pt3ShWCPHKkEWn9ZhmA7NhRgW9jJfNL3UNZ2utngKYgSu+EwOs/2RYmgJioWvT0/
KL8QDmi7cUZCzaESb9xGVrYPxQr/xGUtpdgaIzh7f+Xj9O/u/5viHBP5qSQVJx5s
zTZ9nX2AvVbBH23+krKPLbw2Norf+riVp9lvsFoCMTXgD62/JIrhW9gGYm+E0+p8
8w72Z9Rq2x4hGI2oAj33xG3iLpVBi+lFF3ctiPNLl6UOw/wUoU/Pk8rePEXqTtnj
6fTU+M08IF2Ed5+yF/DuNQ+GjmEyQQ==
=Oq0o
-----END PGP SIGNATURE-----

--48i1XDxjnyzJoEmY--
