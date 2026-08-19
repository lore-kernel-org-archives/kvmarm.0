Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819673A783F;
	Wed, 19 Aug 2026 18:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787162888; cv=none; b=TxwMFYxajgLLOGAzA39gbxHhhxTgciN1GLtHKYF5SmwCW4OuD0G7gVI+TswF0k7Tapij/pyomrR0r1aqAvOmrA0lMZTDEeaCMekwrr05CTGRh5GXW/82POw7+ST8EuV2pos8K0lKqyODb19YAIn1iRwwmZfp6mrAZaMccP3hPvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787162888; c=relaxed/simple;
	bh=yDswP/zTtlamhTNgWOwGt/bK2scN2YOFm9u4b5IoSzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NvmJKBOU6rhoh2Ei8LqKkJVmu9N6PRazsQMZysnn1A41NV5aNo6xnN22p+HiPKb2hDKHLcjM91tLZx5mJb7iWtNGq6ijyEk2mzbh4QtztjDE1JoYpVqjnDjDkk8MAIVcqYjTKyq/qjrN3xp+mIqtRtOoLGvQh7//m5/afFKel0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aw4v7TmI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aw4v7TmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009111F000E9;
	Wed, 19 Aug 2026 18:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787162887;
	bh=yDswP/zTtlamhTNgWOwGt/bK2scN2YOFm9u4b5IoSzA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Aw4v7TmIhMvmCT7kPU6JnfuwLfgRoUqV+iF5wE0g3hUQVgVXgnOqyc6czkcQP4sxE
	 vilP1kI9NXcrGiWTvrb15JhA2KCGVRzKiOsCs1NisrSn6pKdc3m1Vj8ciK4SJznvR3
	 w+D7IK7YywaDMdd2cGnAP2flEHElm5hZPv/9UxSMAk8DjofW/7njZi7q6Dbqhmsx1J
	 saC7rBuOZLTghng83dAmIGgPLhE13qVWlnb9f7b7f7uh6w7iZALvAGMYjbNolkzzfH
	 fL3JfdxuXX1szhCZe6yKNlhKxVQlU2fR25Y1M8J7Wb5V+EItSS+y1984PiGVqWUj/v
	 sVy5hqADZjT7A==
Date: Wed, 19 Aug 2026 19:08:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 04/14] KVM: arm64: Ensure GCS memory effects are
 visible
Message-ID: <3cc4cccd-1a4a-487e-8ac6-9bbbc9713e58@sirena.org.uk>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
 <20260812-arm64-gcs-v19-4-9105afd828ac@kernel.org>
 <aoXmfz5pPwRYRKTO@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5kCzT7+Dr0CeiCFv"
Content-Disposition: inline
In-Reply-To: <aoXmfz5pPwRYRKTO@LeoBrasDK>
X-Cookie: Allow 6 to 8 weeks for delivery.


--5kCzT7+Dr0CeiCFv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 19, 2026 at 06:23:11PM +0100, Leonardo Bras wrote:

> You state that we do _not_ use GCS in the hypervisor, nor in the host.
> I understand that we GCSB() when we exit the vcpu context, but why would =
we=20
> need to GCSB() before getting back in?

> If cpus will GCSB() on guest_exit, and host/hyp does not use GCS, there=
=20
> should be no GCS pending operation at the entry point.

That's there to ensure that updates written by another PE are seen,
following the same pattern as DDI0487 M.c K10.6.5 example K10-8 (or the
prior migration between PEs example, that has barriers due to the stack
switch operations rather than as distinct instructions).

--5kCzT7+Dr0CeiCFv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqF8QAACgkQJNaLcl1U
h9BePQf+OGif9yTteOKxAeb4o+1LXzrTPgOt6KeKCzRt/t4tBBwTYB9KSRz2d3XT
yKGUZN6J9H9c2DuQB5Bd5YmSvnkDeFSmbyZiP6B++oDN07DJ2HrGW722/VA+fxwY
CU3zRqKUQT0K8AhGi5Sc2Xg+HANN+iG4FUTFstZSE+tw3ecm4/zZnabShXcJzpnQ
LEomvP77gb8tl4SASjXN5Eqa2XxhEMD9uT5k714u+FVWQ9TC9I9zbnJb+DHgFJXF
XVnObidvm7Hs+AsgUKi8Q4geY+CRRwVRqk0wRHCe+dF7iHOZFNDD0gGzJ2c5Hs/k
NENDaUUsfBso4RvD56Xybejkncilbg==
=swJ4
-----END PGP SIGNATURE-----

--5kCzT7+Dr0CeiCFv--
