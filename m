Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368813F484D;
	Wed, 14 Oct 2026 17:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792000125; cv=none; b=SUcR47Ix9ofa6jLMfooCv4JV89CrCG4cDT67/4N5zKmJ1wPy2/4xiysIwNKrXhhh28zdlpzTDV6YqBUUqWT4fHBD0Ob1C0t6Cg27Gc+QWeFGBXJr1uTg2aE4OErqWMDRzEKj36z8gaB7nWB/WH0IafkQkzeYuQPBw2KUYY4AK9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792000125; c=relaxed/simple;
	bh=71a9bS9KOD7KGqIJAy7haSe7B0cJeULJ9tVA1djapEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HM+1kuENpVtf6B///zFLkImZc96yhfl/e+BrAS0sDcb+hPAW/pkgkf5fOYpyLKs/4IzRkFguIgTtd41OR1NZkwnnVBdQCIWU5kUVAyRkyLP8v+I5U5roCTrC3FMJYtUedcznx0gTskmxloF/jyWyg/DGWDqqe+WgCSVPcQU8FVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f/feUoZ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/feUoZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D221F000C4;
	Wed, 14 Oct 2026 17:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792000123;
	bh=ztWJU2EjfoLTEJPuQ+2lII5i140c6mxubxZEL3aTvdI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f/feUoZ9pYIyFM/8FFZmrN+WLzqLFlPKmlCZq5JI/mWB99rlDr7gLp5u57SkWD5Tf
	 xhuAeuHnSy+e/2o9NRja9m64WfLg0oywRgfF0h+vXEyilYMpt13sWKOF3rawAS/30t
	 uKvpuaWGoSHOuiWxr9X7mUEXphHsY8P+uG+3FXAGPDME28HXs+Ldh2jF/r3peGCgUP
	 K/Hw4GWmjliah8rPLLjGSSV5EkmwhlPVVSX3k4p1gCQSnNItMSv3ZCcc66OXq+n2aB
	 nWKF56v5iQkT5jqXRoONduYqkAJZInCgvBCFe2qudpnKLm7J5IuWIScrhaWYMttitc
	 gIspDF4iL+i/Q==
Date: Wed, 14 Oct 2026 18:48:37 +0100
From: Mark Brown <broonie@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	Leonardo Bras <leo.bras@arm.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v21 02/15] KVM: arm64: Refuse to start a guest with S1PIE
 or S1POE but not TCR2
Message-ID: <ae24e80c-1b34-4827-9c93-e80b987e9cd7@sirena.org.uk>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-2-3556644cd927@kernel.org>
 <86fqyn2che.wl-maz@kernel.org>
 <as-f1JfUy38Xt9QA@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gBzASHaWQ8wEZzsB"
Content-Disposition: inline
In-Reply-To: <as-f1JfUy38Xt9QA@gremlin>
X-Cookie: Live free or die.


--gBzASHaWQ8wEZzsB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2026 at 04:47:22PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Sat, Oct 03, 2026 at 01:30:05PM +0100, Marc Zyngier wrote:

> > This *absolutely* needs to be data driven, and we're not going back to
> > over two years ago. We already have most of what is needed in
> > config.c, and it is only a matter of making sure that S1PxE is only
> > enabled for the guest if TCR2 and ATS1A are also present. If that
> > means additional sanitisation of the idregs when finalised, so be it.

I do agree that's what we should have, I started down that route but as
I noted in the commit log it felt like I was pulling in disproportionate=20
refactoring given the existing gap.

> > If userspace decides to expose crap in the ID registers, that's its
> > own problem, and we're not in the business of enforcing idiotic
> > configurations. The only thing that matters is that the state that KVM
> > deals with is consistent.

> As I understand it: don't return an error for a configuration that doesn't
> make sense, enforce RES0 instead.

I went with erroring out there to make sure that we didn't make any
mistakes with the ordering of our checks - I didn't want to accidentally
end up with a situation where we look at the dependencies for feature A,
decide that it's OK, then later check feature B which it depends on and
turn it off due to it missing it's own prerequisite.

We can resolve that like you've done here by having the full dependency
stack in every check but I worried that this would be error prone due to
all the duplication, however looking at your code I think we can resolve
that anyway, see blow.

Userspace really shouldn't be setting up guests where we need to make
adjustments in the first place, and setting up guests isn't that hot a
path so like Marc says so long as KVM protects itself we're fine.

>  #define kvm_has_s1pie(k)				\
> -	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1PIE, IMP))
> +	(kvm_has_tcr2(k) &&				\
> +	 kvm_has_feat((k), ID_AA64ISAR2_EL1, ATS1A, IMP) &&	\
> +	 kvm_has_feat((k), ID_AA64MMFR3_EL1, S1PIE, IMP))

This will mean that every time we check for an individual feature
throughout KVM we check for all the dependencies as well.  A lot of the
time that's not really going to matter but we have these checks in hot
paths like context switches.

> +static bool feat_s1pie(struct kvm *kvm)
> +{
> +	return kvm_has_s1pie(kvm);
> +}

We should put the dependencies in here where they're only checked during
initialisation instead, that way the hot paths only need to look at the
leaf features.  We could also deal with the duplication concern by
having the functions call each other rather than duplicating their
contents:

	static bool feat_gcs(struct kvm *kvm)
	{
		if (!feat_s1pie(kvm))
			return false;

		return kvm_has_gcs(kvm);
	}

(or whatever stylistic variation of that.) =20

This approach also needs the code for updating the ID registers since
config.c doesn't do that at the moment.  Some of the existing visibility
limiting stuff (like for 32 bit ID registers without AArch32 or
ID_AA64ZFR0_EL1 without SVE) could be moved over too.

TBH when I said in the commit log I was thinking of something more data
driven I was thinking more of having the dependencies expressed as pure
data, more like the way the test in set_id_regs is written.  This also
seems fine to me, the checks are similar.  It's just much more invasive.

--gBzASHaWQ8wEZzsB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmrPwHQACgkQJNaLcl1U
h9CR5wf/Wuk4OnY8jsShSYGyT/jXaUVL1JmMxLFVq7VJR3Q9U18Q7X7aNQxEBmTB
MblTigPUrxmBmSJnBZO19fUPGo/8rz2WOg6vruuGvjhlPlIy8DtfK5zMFE6wj2LK
tRckwodxThZkNIMri/YbJmkkmJoth7PeE8/uvsWOrfuHqRyyeTgEoeCfAyeBR2HZ
8M43Q/l6H+UUimfx0mmFoN8Ts0jzAQXQy5zlaypa+riXdDQCWJ2/T2DNlqLyIIHS
waGqLdgDNILbAaTUastiy4kw3QT5D/YnZ2iT4CsJP9nfXW9O9GGlVqS8IgXfkMrq
JF/M0vzZDnAfQL9LwvrjqiLcDIK2aA==
=ae8X
-----END PGP SIGNATURE-----

--gBzASHaWQ8wEZzsB--
