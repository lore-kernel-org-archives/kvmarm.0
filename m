Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C7620B20
	for <kvmarm@lists.linux.dev>; Wed,  5 Jun 2024 15:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717602407; cv=none; b=nmiPjlOTzfwNCMyrfdhDeeCsT9g1bxPXfKwOezY9Rj63yCJQ2sL+gzSCChAOeBac+pW2+UzqTrsiJwlfX2Rs/0EVmlDZOxpgTgGS0mwga5STExiK1Dr2lYv8sSrgDs7p1b+18QeEUq3wddvHY+D9CB13qDRm2NqT+x6VAbhCMMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717602407; c=relaxed/simple;
	bh=G8zYggtS8GpEMe501vG8z77dJS5Dwy6+VMPjrgF7wOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VhNmzRN4AZJbRB7OFa1U7JYA2ocqj0ogpewQFvxL1ULyLdQ7bUeEX3kKn13DJjA/V+yLvX68k8itKiimTbrl3YjU4KbzsYo32KCPPI4NSypWRiz2LS4r84lcG10yLFKXrI1Wlc4RuC/DFHvLiGRGHjF0fOGQfwtwOZuf8hlGqcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RwKVfSz0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RwKVfSz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE39C2BD11;
	Wed,  5 Jun 2024 15:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717602407;
	bh=G8zYggtS8GpEMe501vG8z77dJS5Dwy6+VMPjrgF7wOQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RwKVfSz0MpQrDtZeFYxVgGa+DXh7mwFkIG7CjViIMHXGUnDINds9hCJMUcg94wfw6
	 /dtLsW1P6O8n5iXE896IfvIl0UMbkzdUNqOHFZl4j1IgtjQrkfFhfNu6H7SwaQPUub
	 v9EbJDqNCaP+AcLfaa790Vr45eWV9MFvdrE12a5mJkp5MZSIhBmXm1+zYIiFt4WY4B
	 5dESoGIwQ7N5s3Spw1n/SiwB23SS8CKy0JTf4dnbXviZ292w+3uxY4IluJU/uTttF0
	 DZd2ABEDOAKBGRXbhZ1iStY483GJpx4BbbAhBSl3gQJXeebGNf4GX5z7NIl+JANpyA
	 KgqKvafK18FAg==
Date: Wed, 5 Jun 2024 16:46:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v1] KVM: arm64: Allocate for maximum vector length for
 pKVM host sve state
Message-ID: <cff5b8a1-d837-474e-9b92-b538d7e6caae@sirena.org.uk>
References: <20240605150312.3684150-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="L62M8457MRKPFgH2"
Content-Disposition: inline
In-Reply-To: <20240605150312.3684150-1-tabba@google.com>
X-Cookie: Simulated picture.


--L62M8457MRKPFgH2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 05, 2024 at 04:03:12PM +0100, Fuad Tabba wrote:

> +	/* The maximum vl encountered for any cpu in the system. */
> +	int max_system_vl;
> +

As previously mentioned I'd really prefer not to call this _system_ due
to the potential confusion with the maximum VL we're using.  Naming is
hard.

> @@ -1031,7 +1031,12 @@ static void vec_probe_vqs(struct vl_info *info,
> =20
>  		vq =3D sve_vq_from_vl(vl); /* skip intervening lengths */
>  		set_bit(__vq_to_bit(vq), map);
> +
> +		if (!max_vl)
> +			max_vl =3D vl;
>  	}
> +
> +	info->max_system_vl =3D max((int) max_vl, info->max_system_vl);

It's not clear to me why we stage this in a local variable prior to
updating the global value, and like I say it does feel cleaner and safer
to keep the current split between enumeration of the PE and integration
of the results.  This should *work* but it doesn't feel consistent with
the rest of the code.

> -               kvm_host_sve_max_vl =3D sve_max_vl();
> +               kvm_host_sve_max_vl =3D sve_max_system_vl();

I appreciate that we're adding a host_ on the front of it but it would
feel safer to keep the name of the hypervisor copy of the value
consistent with where we copied it from, sve_max_vl is a different thing
in the host kernel.

--L62M8457MRKPFgH2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZgiGAACgkQJNaLcl1U
h9Ax+wf/Q0Ud8tzOYnJgVmtZ1QIoj9Ppi0ID80lu8AYs5oKXMlzgfuQZJXdrhyF0
zc9uBilqgwm6qX0iZyhL9zP9x+FdSRS8PKP+lC+A9ci+sxeCCgEkjp7PsCviCfqj
w2ql7Y72ApyTXsVTZt7RstgoBpChQdZGqQZYDVeCuGO7wpfm0vSrP/AFobZVi8Dv
08cBcVIj91SbmiJxJR5qPHS+oRAqVvd2iBzbMcB3s5DuH+xW24vZnswyrPl/riPy
qEaVOzU5o2fCRsDyhN9ZYu44C2gsNj703EhwOkWbyghZ00yVH7plmPLmCpbQ3QA9
OgkwWnGnGSgtKsXI5GBFspOioF29Vg==
=qfXL
-----END PGP SIGNATURE-----

--L62M8457MRKPFgH2--
