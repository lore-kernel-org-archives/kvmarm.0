Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F83155757
	for <kvmarm@lists.linux.dev>; Mon, 23 Feb 2026 14:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771856877; cv=none; b=QqIoC53feaBAoGZOiHgE4pAGVivm7JHs1PEWKF+TNoWOeGbXh4//5SH2jbEkxCwvY3fh4i0JzmVtL3lKDSL84wzXx4/YLYBxZkhDnSMW84N4OeDyr0d+CGlYcylvotgr89fF1wKKOlFs5ALc/tE8fpYKs19dHUstP/l/jCu0WU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771856877; c=relaxed/simple;
	bh=Xu/qpZ8MrYMsaZJT4hMSe8XVOwxu0IZGwImZRtSZlP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HnhsWgAelxWdtSlQayej++kyg2CTt//akkdjf3F1mR8k8pZ6Jr4bhegCv7FMHGJPV9s++dYYNMpzFOTAO37P38OGJJ12idfZkDugPhxWAmGmb3q3ZOkPFmejKH5fxYJbG+SSxfDbpP/suEvt1H+Q9vHuwW6Wg1MQwWw6l5stS/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i5Yv5FZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i5Yv5FZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EF9C116C6;
	Mon, 23 Feb 2026 14:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771856876;
	bh=Xu/qpZ8MrYMsaZJT4hMSe8XVOwxu0IZGwImZRtSZlP8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i5Yv5FZQoTig+ho19Y7LTHAo+iOvINI3/BmGjRxJAsnIk+FjoEAAc5aZ9pqoatnoH
	 yBTmd2ABqtSueuL7cJOv0U+qJJgGkU81jxBdj1Rb9wIqnaqETPolb5iwdpdF0VHM3p
	 UvpjEuZlzqymZ3deaCin1xLH+WcrFWGeSDqu5obZd8tL6tPaCuyfENveZ3YRoUX0FV
	 yQT1O88qQ0jyCVR26peI1a4mKDItXqimmNZMxGBXyc408l16EVPgEw6NyqaRHkguWG
	 uCjmCeExIeDH8BCzSBxqRKMTwsy0Vq6vPaqRA5/+/5tczg7yEz5mKFGo4Sq0+kMjin
	 9wU4T9en2yE6g==
Date: Mon, 23 Feb 2026 14:27:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: pKVM breakage in mainline on n1sdp
Message-ID: <fbe627c3-02fd-48e9-84f1-c6587da13d94@sirena.org.uk>
References: <60916cb6-f460-4751-b910-f63c58700ad0@sirena.org.uk>
 <87bjhie67o.wl-maz@kernel.org>
 <87a4x2e60i.wl-maz@kernel.org>
 <aZm2XCZLYxgxL99d@sirena.co.uk>
 <aZwmevKcvW2HxdJ5@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="kedVc5uWqaZsu8rh"
Content-Disposition: inline
In-Reply-To: <aZwmevKcvW2HxdJ5@J2N7QTR9R3>
X-Cookie: My LESLIE GORE record is BROKEN ...


--kedVc5uWqaZsu8rh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2026 at 10:05:46AM +0000, Mark Rutland wrote:
> On Sat, Feb 21, 2026 at 01:42:52PM +0000, Mark Brown wrote:

> > It won't be vanilla v6.19, that specific log will be tip of Linus' tree
> > from yesterday morning UK time which should be 8bf22c33e7a1 ("Merge tag
> > 'net-7.0-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/n=
et"),
> > there were a few results for commits over the day prior to that showing
> > the same behaviour.

> Are you sure? That log says:

>   CPU: 1 UID: 0 PID: 1955 Comm: qemu-system-aar Not tainted 6.19.0 #1 PRE=
EMPT  =20

> ... where "6.19.0" means that's the 6.19 tag, and "#1" means that's the
> first build against that.

The UI claims that we're seeing this in 956b9cbd7f156 (Merge tag
'kbuild-fixes-7.0-1' of
git://git.kernel.org/pub/scm/linux/kernel/git/kbuild/linux) but
unfortunately the build logs don't clearly confirm this.

All the builds are fresh builds in a new container so it would be
surprising if we reported a build number other than 1.

> Is the build system overriding things such that this is misleading?

I believe that to be the case here, the builds are not building from a
git checkout but rather the build coordination is packing a tarball of
the source up then handing that off to be built on a separate system
which means that the magic to figure out the git describe and put that
into the version number during the build can't do anything and just
reports whatever is in the Makefile.

> Is there potentially a problem with the build system?

I can't 100% discount that possibility but it does seem to DTRT for
other commits and has done for a long time.

--kedVc5uWqaZsu8rh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmcY+YACgkQJNaLcl1U
h9ABJAf/bmikUHaa7X45/hwLAckp2UmAK5tgs7Vm7Z/8ttuQZzXQ+73y+8mOT332
cm7iaTK+2auzw/EBIzzBX2khEjak/35SiZaVa92c7vXpzEAwSV/DypoRgEBADSMq
2mg1RghdBoCoRkHeVBUeQjL5Q2VOFJQRkefDNtAnBWr4/rEV9UUQRAf+bUTRwFlN
p+s6HGgx5M+Btx80EJGK7pWkQJf+n8nXHDW3YaDfwDA/DyxWKJ0DxGLT7nrIxXfe
HS7V6k4+Vd/4j/PnF1tISRTK/ZgKS/TLX6uwu/W9Aft14/D6WFNSpvATa8HgBnfu
WhvzSJ3gNH2CHkYJYgvq9Sny/6R4Mw==
=q1pY
-----END PGP SIGNATURE-----

--kedVc5uWqaZsu8rh--
