Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB35B2064F1;
	Fri, 25 Oct 2024 12:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729861160; cv=none; b=Ox3K9T2aQ345f9lCJvbQ92T3IjaROHIaSXFiTEwnX6+apBxQMoGpCNiYNWuNtWlE+4dU8RqGgNFk8dniwcoY8Xfa4aAM3wKFlzAjVNoIR31Vis/xBvy9lBtMMUTh9sXkL7WvQ3rUNOg3sDVn4KtcdTwBn8YcAi0CwazdF6YYY74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729861160; c=relaxed/simple;
	bh=aAqbBGyjPWgCK55GdUA5PUTQzhfpub6cqpcDphWFA+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LiSus7R1iDsHhvjxLUxcp0Ji4VgzXF2r2Op6zY+JZiRUdHiq3rz2l4VPEM4e2SmpotxnZC+W1tb4wa47uVw2y4RqhR/fknN1upQAVQhSOmNF3aMqKclv/Jhe3IBUNhP7zf9rTzLoxMZnXJiH9rszmgw59SChWQyhP3h0KgmStCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=baqk3DIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="baqk3DIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99498C4CEC3;
	Fri, 25 Oct 2024 12:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729861158;
	bh=aAqbBGyjPWgCK55GdUA5PUTQzhfpub6cqpcDphWFA+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=baqk3DIE5L8wdmTLARGGkTSnE1Eof9cFR5gHTOuFk2m4SHOyOjPwQK8jFmA5jvcdC
	 +zDj3uwxB82JTkDFuzGBxxtbcfZgn/HFnHLjdNjYBKWbLemTXh5TDmt8lnFiR2aA3X
	 9Hj+rPFuJZzCLQX13d7uMzu6iJYp1L0J/DGxK0rZIaHKvLS5w42U8BFp0+EeSZVGR3
	 M3UfJn4QWiVQtqu/JC8jd7tIdnd51d8veXgc1VARXstESVXz3LroiTnSrmGvwMXjE7
	 18+tl8zDV/4IUlVRfx29azRk/FAUxGUrkjLljRt71dgCCxduypj7Vnsn7nI2DgH3aT
	 MVKtmldtiGuew==
Date: Fri, 25 Oct 2024 13:59:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Eric Auger <eauger@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>, stable@vger.kernel.org,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH] KVM: arm64: Don't eagerly teardown the vgic on init error
Message-ID: <ZxuWIXFJignbcX1m@finisterre.sirena.org.uk>
References: <20241009183603.3221824-1-maz@kernel.org>
 <3f0918bf-0265-4714-9660-89b75da49859@sirena.org.uk>
 <86ldyd2x7t.wl-maz@kernel.org>
 <eb6e7e29-b0a8-47b1-94c4-f01569aa55cb@sirena.org.uk>
 <92d755af-e19b-49a5-b4df-a8ed0fb7aece@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="StHetKYo+xBy+vjm"
Content-Disposition: inline
In-Reply-To: <92d755af-e19b-49a5-b4df-a8ed0fb7aece@redhat.com>
X-Cookie: Editing is a rewording activity.


--StHetKYo+xBy+vjm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 25, 2024 at 02:18:02PM +0200, Eric Auger wrote:
> On 10/25/24 12:54, Mark Brown wrote:

> > I'm not even sure that's a terrible fix, looking at the changelog I get
> > the impression the test is deliberately looking to do problematic things
> > with the goal of making sure that the kernel handles them appropriately.
> > That's not interacting well with the KVM selftest framework's general
> > assert early assert often approach but it's a reasonable thing to want

> Can you elaborate on the "assert early assert often approach". What
> shall this test rather do according to you?

In general the KVM selftests are filled with asserts which just
immediately cause the test to exit with a backtrace.  That's certainly
an approach that can be taken with testsuites, but it does make things
very fagile.  This means that if the test is deliberately doing
something which is liable to cause errors and put the VM in a bad state
then it seems relatively likely that some part of a partial cleanup will
run into a spurious error caused by the earlier testing putting the VM
in an error state.

> I am OoO next week but I can have a look afterwards. On which machine is
> it failing?

It was failing on a wide range of arm64 machines, I think every one I
test (which would track with the change being very generic).

--StHetKYo+xBy+vjm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcbliAACgkQJNaLcl1U
h9AvQwf+PLqULPjWApldlDAjSS6Ydf3qKRr2wnzfn3GoYm2LQKpherEM6Br54G4F
6LGp6HkvVOA4i7vxRmzviXidU30Pg0DkJSUXkFlVcfbT5eW+YbvnZmDKvNC50p50
MExLjhmzwlA8M9jCqICqUim0nD23AtQZZLeTIVrqCtM2OiwQyg7+LY2KM+T/7aMT
AltD1XVQkPMVtsQ0wHrUMWJR7mCW0N8RY9RKuoswNJadle0n2yU8OK3SwyMO4kIw
ucyzQGoP27ckeeNQ2y072gZPDq6xg3O7yNFOzWwl9E+uDQs6GICu4LzIWFVsGFwe
pzdYascg4iXeDbwmnQGaxdvHXk0NEg==
=1fHJ
-----END PGP SIGNATURE-----

--StHetKYo+xBy+vjm--
