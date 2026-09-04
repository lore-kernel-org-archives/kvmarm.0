Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1071C447811;
	Fri,  4 Sep 2026 13:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788529102; cv=none; b=JouNgySwh2oStMViSDcoQvDQ29W5coCDxtDBENGHldaYW4ypVtBbIXJ+yzXiMtI1aKKHAplFpRrvw46y1IPw9L7nlv9BLz5dz7eEQZSbaUjVR56qIPVuYt03u7vCYXHqiQy5zq0A/OrYTiPZMWUXtMVPVj3L/bPtU+gjlMqXkJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788529102; c=relaxed/simple;
	bh=8Qhzsqo8mZKi+p534gFaAvP++PQLr1O56E0YQdeS668=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zd/zc5Z5T55LayXb1wqJQn9Y/M4aH1CgrLzDMsXbXJiDp8CSMFnKj991K0upxqqCL2MiOcNNBninXYoKQ8GFHvXc82KITLTwl+Ljgvtwz7Gm3vmjiB+DVqS9UQZnFIWegBbdZ9dFg2hKR3xHsX4+llu/6aGcR3+qTxQ+8g641Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aPBLWKDI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aPBLWKDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946031F00A3D;
	Fri,  4 Sep 2026 13:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788529100;
	bh=ImHZfxtU81KZMYiwHk+GpoqZqQbLfpX8wQ5dvb5NL2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aPBLWKDIH1u2uh9qt1fr5Txmnsj/o7b49sGvzCeJAansVIpptOaBJPmtwJH3TUk4M
	 T6B2nSrzUwRl5DpUCWqr+HAsHRm00UZexQtxt1aGJSJaRRQFht4hK3YrK01trv7cq6
	 kZqHmBt0DQuxC3F8LvKawzTu2dOLigtpt3kgAW4aAUr2d+dZ8UX6cjuSWdsP0lIFXX
	 dAk5/JOzFhjYFHPyhxp/K/NtVHcpDDjitUAUyoqRoass3NbkmeGj/9jBRd594G5kOZ
	 t1bEZbQT2vInEyleenT5lwprDiFsOnGmNoDRwQjZi/VfxNoiXdU9EegkwRUFwUr5lO
	 JUnUro9UdV4hg==
Received: by traversing.sirena.org.uk (Postfix, from userid 1000)
	id 30892D8BEB2; Fri, 04 Sep 2026 14:38:07 +0100 (BST)
Date: Fri, 4 Sep 2026 14:38:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Enable S1PIE for nVHE and hVHE
Message-ID: <aprJv4vkguNJb5vG@sirena.org.uk>
References: <20260904-kvm-arm64-nvhe-pie-v1-0-29d59f245e6c@kernel.org>
 <20260904-kvm-arm64-nvhe-pie-v1-2-29d59f245e6c@kernel.org>
 <86pkyt4gvt.wl-maz@kernel.org>
 <eb788ad5-5bb3-4767-87b8-d35d9e3ab220@sirena.org.uk>
 <apqrky27mJmUV9UA@willie-the-truck>
 <05f1e2f4-173a-4226-8c98-1452c20f0a47@sirena.org.uk>
 <CA+EHjTx87SnshzrUF69hGTSA9JmjW9oKbx+GbKjx5W+gnWYRgg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UmjJAuB3W22tES9f"
Content-Disposition: inline
In-Reply-To: <CA+EHjTx87SnshzrUF69hGTSA9JmjW9oKbx+GbKjx5W+gnWYRgg@mail.gmail.com>
X-Cookie: Orders subject to approval.


--UmjJAuB3W22tES9f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 04, 2026 at 01:20:44PM +0100, Fuad Tabba wrote:
> On Fri, 4 Sept 2026 at 12:48, Mark Brown <broonie@kernel.org> wrote:

> > I figure that if we're supporting hVHE it will end up less complicated
> > to also enable nVHE, it reduces the potential for having bad or missing
> > fallback paths for features downstream of S1POE.  It's not like it's a
> > huge extra bit of code and it seems likely to save hassle down the line.

> For pKVM there's no fallback path to get wrong: any CPU with S1PIE has
> VHE, so pKVM runs hVHE on it, and a CPU without VHE has no S1PIE to
> disable. I couldn't construct the protected nVHE plus S1PIE case under
> QEMU at all.

> Where I think it applies is kvm-arm.mode=nvhe on S1PIE hardware. That
> boots, and it's the one configuration where the nVHE side of the patch
> would run.

Yes, exactly.  As you say any system with S1PIE would only run actual
nNVHE mode if it was requested on the command line.  Realistically this
is something that people end up doing relatively often in development
even though it is not useful for production, so as Will said it should
run.  It seemed explicitly excluding supporting the nVHE case was more
likely to trip people up one way or another.

Marc also started out with a flat no and didn't mention anything
positive about the hVHE part so it appeared that he was objecting to the
whole concept of the patch, including the hVHE aspect.  It seems you and
Will are both OK with the hVHE bit and indifferent to the nVHE case, and
I can certainly rework to unsupport nVHE mode.

--UmjJAuB3W22tES9f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqayb4ACgkQJNaLcl1U
h9CFewf+Pe/GdgGreSGkHQC1BpvuxnEK1XKsZA/fuA6yTcpTySfrwg/DYRMk3uVZ
qnqCmZyh0gVz+wvtAIGdEUm4FyzQCKtIFCXlYRiQyQeErja7FhYQx8hHJae3E1Ow
Km5lZiibgiRy9noLNRRtXPJPDYcnG10C637ZtRYu13Eor1qXLFY4DgrjthVUHX+p
S6oHXyi7Br15EhhnlxoTw4UZO5CFa3HT3R9OJeta0F6YMRPwmfsscNnNSAqkVodr
kS4tVuUCOIGLeMUGZjebaXL9TuCADQW7Y6RYLTvoBKJ3vWILYC93OwxMwU2M0sXE
PxsugHPRtBkiKW8qog+YpaXXek8PTg==
=UFWG
-----END PGP SIGNATURE-----

--UmjJAuB3W22tES9f--
