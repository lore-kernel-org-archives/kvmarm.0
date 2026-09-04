Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B1638F65D;
	Fri,  4 Sep 2026 17:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788543645; cv=none; b=M39eJsVr+dLdZ2nLjKixKzFsjLxigmQqNxm3dAOwlhIlpbciygBmvqWfafllPQkyDZdSiTzhfJjcDEe7gGGnAAL0LNEaPZGfBgRIUzLGHSMU5KVlxjZ/NnnlSkO1M4JVGiQuc9ss+TtIsWC1c0wUB8gy1mUJ9yeOeAhnnhAEO4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788543645; c=relaxed/simple;
	bh=VjN1gkM3/MJ3iD53susk88E53ze4Bbb7Yo3K3aqlx7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ME0CS+ZrCjaMLDblXjM8XOVWmEzSnzqnRzOUQL0R5zAJzGoCBnNAy/bHq6UcNsJN7gOgyhWgHHCqPIIQKwXg0M+oAECUJ9XDpHN31izdvj4FvXBkl8kTrbuqLurpNgf0TMhsOHM4rYHVU+/rBpey9nJtMhEjADnBhs9ek6h1bqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gXIrg7Gm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gXIrg7Gm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D071F00A3D;
	Fri,  4 Sep 2026 17:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788543644;
	bh=VjN1gkM3/MJ3iD53susk88E53ze4Bbb7Yo3K3aqlx7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gXIrg7GmobYPdnyckJvRGQzs9/B5pfELcXUk/lYcSM6f0RJOmCjpfqxjspCfhJDr8
	 BJUv69D+L1NfImxzer1lyZ1/+5IiGW3sleYy1H4n/sK9az1Mxnd5iNa7qvFkjuobTJ
	 a39a4Hk/Ek6KWdmJTSrwPvnTT86/tW+V2c8SR3N3gYQazpSajL5c3OxAq6J6rJZ7pv
	 xB9ErA04HEEvCeKtOAzjMpNVzz0tDQwi9gmTK9eBjLGV2SK/ZlQJVvT3H/LRxFlqcP
	 npo/nwTVxe0LCncH0ttWplJqa1JPrHfPwC7J/7rnoh0HmyQCU3+hmcsSOoeDpQcPx7
	 RV942uW+Ywd5A==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 66B941AC52F1; Fri, 04 Sep 2026 18:40:41 +0100 (BST)
Date: Fri, 4 Sep 2026 18:40:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Will Deacon <will@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Enable S1PIE for nVHE and hVHE
Message-ID: <apsCmewuhD9UZWT4@sirena.co.uk>
References: <20260904-kvm-arm64-nvhe-pie-v1-0-29d59f245e6c@kernel.org>
 <20260904-kvm-arm64-nvhe-pie-v1-2-29d59f245e6c@kernel.org>
 <86pkyt4gvt.wl-maz@kernel.org>
 <eb788ad5-5bb3-4767-87b8-d35d9e3ab220@sirena.org.uk>
 <apqrky27mJmUV9UA@willie-the-truck>
 <05f1e2f4-173a-4226-8c98-1452c20f0a47@sirena.org.uk>
 <CA+EHjTx87SnshzrUF69hGTSA9JmjW9oKbx+GbKjx5W+gnWYRgg@mail.gmail.com>
 <aprJv4vkguNJb5vG@sirena.org.uk>
 <87v78l3yrg.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rBn5QobMDx7UT59k"
Content-Disposition: inline
In-Reply-To: <87v78l3yrg.wl-maz@kernel.org>
X-Cookie: My vaseline is RUNNING...


--rBn5QobMDx7UT59k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 04, 2026 at 02:57:23PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > Marc also started out with a flat no and didn't mention anything
> > positive about the hVHE part so it appeared that he was objecting to the
> > whole concept of the patch, including the hVHE aspect.

> Then you should read my email again.

It is true that you only explicitly mentioned nVHE which doesn't exclude
hVHE, but the silence on hVHE made the position there unclear and the
tone was rather negative.

--rBn5QobMDx7UT59k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqbApgACgkQJNaLcl1U
h9CBkQf+M6gAaAslxrZd1oYFC/YbkP0vFgitN4ZJT1Xrtve/CiKxqhVlngLT4E22
3eS5rCMou3UAKB2lp+fa3VpeOv0fw8VBRupb6hMPXlpLeUrmI0CDNNc7XJSL/IeA
5jcwd4ftTBGkkE1p/nAQWDP2FjXtVr22qYTHo3rz+1aNED02060rrrSZMJc+7Y+m
gduUnHyYroKnIYBf0kO1uhydZsJ92/zbV8MjqcUnFJPUmbzEEfcmxvofn0GD147a
i95yeBKGDfrK7C5ymNMvfmCq7Hz9oT9/3gFpf0HwVpRxzsaEGWDif/ubHH5vRzbI
a5QzuIRqkbOVIBSQdMB+3Ef/cyjmeA==
=q+Ne
-----END PGP SIGNATURE-----

--rBn5QobMDx7UT59k--
