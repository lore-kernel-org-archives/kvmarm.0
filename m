Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E75158DD9
	for <kvmarm@lists.linux.dev>; Fri, 31 May 2024 13:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717162518; cv=none; b=pJh7w7PWO4gzfr2QINXZsJ9GkFhkZBt1wibb6Zt4N2AXs9Xgh67Ns0seZzJOWn5Xd+I4Il4MEWDBwLDa/etWbMAnWNBJWEuNQsp0193ciu7v5hzOeQ0BushyiymPwSnMZmIpToV0PwhvXYNut470j+Mc6y6jBn4TJ5w0dVLeXrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717162518; c=relaxed/simple;
	bh=F/QFLJTKdDvFo9/FG7G3sd/CY/5mdrjJZmH9E75I8oY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tk358tOcuuuKv8Bjef/UYMgW0eqEakwltr9Wt9YzP7b62n98Rl+qZ4RBFKcwvqDgUh7ONUIRzeVk2BZOG/n2IZ28+B78OL8AlZ2Ytmqu25j/+9Uu7w9csJdbxx7TTT5vWQy5toXXNQvFHjgmZsygexED3RARa6LeitHpxAs3NBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EkSHTu0X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EkSHTu0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653E9C116B1;
	Fri, 31 May 2024 13:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717162517;
	bh=F/QFLJTKdDvFo9/FG7G3sd/CY/5mdrjJZmH9E75I8oY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EkSHTu0XEGyIaAMNM0Kob4hE6LfZfwbn+ROgvDUx4UeqscIR+z67NgoViCmUl4cMR
	 bBkCZujNHpcQwhlphLaY0ub93NuJ4lO9Be3d1zdMi1CVt5XTQEsu2krRo2n7G6dHlO
	 JmLsFVmiZjyeg/Q0JOXYiwJ92YY7JMFO4oNbhejXqnrlhVCkXH7fuOYS8pXCxgzNQ7
	 SAoMHCPw3W1fMTjhLmlCEZPAmKsZBKq9+DduhOJRqA5pv3fdvKJfh0eVUHNmyUXG3x
	 3UOAGbtnBg69F8g74FHSamITZ1Rgevxjy5FeXdbZPuQewRic9jrxDOeq2m0zfds57y
	 wjQDKIw4atNgw==
Date: Fri, 31 May 2024 14:35:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v3 03/11] KVM: arm64: Specialize handling of host fpsimd
 state on trap
Message-ID: <cc9efa90-01f6-4b7e-8211-a10e790cae84@sirena.org.uk>
References: <20240528125914.277057-1-tabba@google.com>
 <20240528125914.277057-4-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jtrlcLGSTGXoyS+d"
Content-Disposition: inline
In-Reply-To: <20240528125914.277057-4-tabba@google.com>
X-Cookie: Serving suggestion.


--jtrlcLGSTGXoyS+d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 28, 2024 at 01:59:06PM +0100, Fuad Tabba wrote:
> In subsequent patches, n/vhe will diverge on saving the host
> fpsimd/sve state when taking a guest fpsimd/sve trap. Add a
> specialized helper to handle it.

Reviewed-by: Mark Brown <broonie@kernel.org>

--jtrlcLGSTGXoyS+d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZZ0g4ACgkQJNaLcl1U
h9DTHQf+LiF6GN/JhYgk8BJSoQMwOAl/cw3Oo/PH6BdfuvBLzIGC9m55J5ZpB5TP
tZicfyWWUEqStllFgfeFJCVQL731/w+yz41ZNyh+dirTWVCNqT37rIEIkxqFWA5c
tuHE2K/fXnrKwYGipaVgExdX2p29dfWScUsd6ZMYueZ/XpY4Zq++P42PsipBG1lh
4VLtpCjtLPgh6QZDklfx6zGPgFCzhCbdvAuDtkUr8R0QFURvD50fLjMKYvYAAFTr
eZhhjNWClhKg17TNgucSY05lVtYqYqWyZGp+sitZlZqYLPF8vZIdMvgXrs5IswW/
v4f9lMGPnul2XGBv/Hh2UEpeqGyxUw==
=gcmS
-----END PGP SIGNATURE-----

--jtrlcLGSTGXoyS+d--
