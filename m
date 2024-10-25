Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2919C212178;
	Fri, 25 Oct 2024 13:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729863794; cv=none; b=a63MizETpLKZO5+X8LiMivzeH6YClz5F9BJqbxSQpO+fgVN2nwJ29FPSYad9iTT900YLpw+uMr7KteaqhzRZpiJ8LrpMo2bjeO9HdYL4QypUjmlJ5THE6INwoEm4aU/7UA2B+90S6u4vVIr+WxksmF3ZJLDm/zKE9r64VS2iVhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729863794; c=relaxed/simple;
	bh=QcgSLO9Ndsh6+YlbmmV4d9uuj5L/CYMsjacv9xI54Ns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dxyrboTnaCMaj4E38vBDtK+eYLx4/h9ptHW5ROwc4OsQJfmtSnwL71EsRw9da96dWU/KFKYLBaKFJNHdAA4vRcMbDTg+z1mbKXwzaLCV2sU+gbRWKL38YTQwKT/raYENa5n+lPFfDNDbqMUidc5+oT+RpGB8ecmSAHNW+dsDdhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZdELT36w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZdELT36w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAF4C4CEE6;
	Fri, 25 Oct 2024 13:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729863793;
	bh=QcgSLO9Ndsh6+YlbmmV4d9uuj5L/CYMsjacv9xI54Ns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZdELT36wIwde8NN0+Vp4FTKs2GYP2xckmgZ6rM7QUL9PIPomICybM+igyCBVPWlhD
	 YqoF+xq5Tmm5CFFUtbREbySlnNP29S6iJz1yKecQFyMEfaSYeX57cYmw9TDZ6E3mjT
	 MZoCGLWx0KtFurD4yQyTQORUxGtT5ApJHkaNrpPj0P+51fNF8+mXHPEAd7jipmhi0q
	 bgGgJdLqEUsJpVMIT8TF+U3jieIPyMDH738ZuG2CFYmhpsgJ/MC+yT1WCJKxTt3vN6
	 fuph75paFpnuTIZNRGyWWSdpgFcpHPcX9k8ZRHlzOtqsZGkSBPsyO5kn03UEjm7Z6D
	 Ju95QRcYQMnnA==
Date: Fri, 25 Oct 2024 14:43:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>, stable@vger.kernel.org,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH] KVM: arm64: Don't eagerly teardown the vgic on init error
Message-ID: <ZxugaK5Z4_7ula7n@finisterre.sirena.org.uk>
References: <20241009183603.3221824-1-maz@kernel.org>
 <3f0918bf-0265-4714-9660-89b75da49859@sirena.org.uk>
 <86ldyd2x7t.wl-maz@kernel.org>
 <eb6e7e29-b0a8-47b1-94c4-f01569aa55cb@sirena.org.uk>
 <87v7xgtjs9.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oaU2WkJ14yfoCs6h"
Content-Disposition: inline
In-Reply-To: <87v7xgtjs9.wl-maz@kernel.org>
X-Cookie: Editing is a rewording activity.


--oaU2WkJ14yfoCs6h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 25, 2024 at 02:05:26PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > I'm not even sure that's a terrible fix, looking at the changelog I get
> > the impression the test is deliberately looking to do problematic things
> > with the goal of making sure that the kernel handles them appropriately.
> > That's not interacting well with the KVM selftest framework's general
> > assert early assert often approach but it's a reasonable thing to want
> > to test so relaxing the asserts like this is one way of squaring the
> > circile.

> It *is* a terrible fix, since it makes no effort in finding out
> whether the VM is be dead for a good or a bad reason. In a way, the
> fix is worse than the current error, because it silently hide the
> crap.

I mean, it's clearly not ideal or finished especially in that it's just
allowing the error code throughout the program rather than during a
specific case but the broad approach of flagging that the VM is expected
to already be in a bad state and not support operations any more seems
reasonable.

--oaU2WkJ14yfoCs6h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcboGUACgkQJNaLcl1U
h9C2MAf+NELyDRQOR62AbhGylzzEH1W+It446W3mJYfqiES6RyzIoyd/29BoQXp7
5UvyDyrv4lEPvmMFIGOlcloHTTkCIOCsFviPgW9Mwm7/1RBaOomD/mB5GfDkyx4e
96VmsYkg+RfFyVychhYaJBKI8lzDO+9jHL/cwxTBdOADOZZeNrvA2eiv0sLAibHW
PO3KubatGXvf+Oyh6f7EGK1kZeok7MNnNwa3b9Mj558n3LbJXcBoBB0iPDHs0bwC
Dgjl3VaESLv86vexhAN+eIJZDTinTzXJJS5nFF0E4kKzC4ttB5PZ9DlMcUFqky9s
u4Onph+rXiYNZ6uRDoL9+emHnnLfhA==
=F9Rw
-----END PGP SIGNATURE-----

--oaU2WkJ14yfoCs6h--
