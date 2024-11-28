Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4BA537F8
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 17:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732815361; cv=none; b=m88Um1+yAYXSckxlfb0+3YJRL3NN8ozTrByFUMqb7iUmL8hOdh1FhBuR1kgaMlrnrMyLxhTiyfOVGCXpMKMSgphTOXFmiZCGSX7ZCQCAfaeUc+vDFnxnOBOfCWQhKJwMliyKVOsmDkq6LiThfrRTJlOXTTLgu4FYQEZp/RQNIcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732815361; c=relaxed/simple;
	bh=26Aq4ZaxkboOkjwursPiJrPZXJhOAiBZuFn+AEls1yQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r97+ry9LchsIoBZ8QBYem1+8/QRCRzTSXT07LBZtACowgeuKiySK/Gvee/Eu53W6iEn3w/t5DkL83mgzCUoj/GuTjxYY2DrT3XN3l0lx7oVkeqwE4/Y1tQouhEtbEBntgTJxFUj/2abg1mAT+DGyt+DFLJlm5q3dW5NzplHyCsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lg2yDZal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lg2yDZal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874C0C4CECE;
	Thu, 28 Nov 2024 17:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732815361;
	bh=26Aq4ZaxkboOkjwursPiJrPZXJhOAiBZuFn+AEls1yQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lg2yDZalnDYUTgDUDfap6cfQPi7A0ApkIxTIZ2nlyYSbS+D7XFE10sGtMzDB6E/mW
	 X+QK+Lrggc8nZ+pEtKUhZ6+3kRBiUEgC013flKA+/B3MWI7IkkDsTrVaMUk3sSnEIQ
	 KokgaogtNxIloZiVjP7xNMNMhNLRLqOZOuvUOyf253yUZwD7GQxeZRb31MT0O4AkEo
	 BtDzpBX+8AERCNvkypyIkimYQATFvi3y6DdEr/7kpQGY7YpTWYPY3zUlOOkWUU9Y3a
	 75/NCJp2wdXVm4W419QCBxkDAXzkxlLdmlDY9ASlZeS68oPRIQ3eunPqVMkNIq8cRs
	 0EfvtnlFluezQ==
Date: Thu, 28 Nov 2024 17:35:55 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org,
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, qperret@google.com,
	kristina.martsenko@arm.com
Subject: Re: [PATCH v3 00/15] KVM: arm64: Rework guest VM fixed feature
 handling and trapping in pKVM
Message-ID: <137ae0f1-32c7-4856-9357-00493995a89f@sirena.org.uk>
References: <20241128123515.1709777-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+UK7DtF2N3FgCqnU"
Content-Disposition: inline
In-Reply-To: <20241128123515.1709777-1-tabba@google.com>
X-Cookie: Close cover before striking.


--+UK7DtF2N3FgCqnU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 28, 2024 at 12:35:00PM +0000, Fuad Tabba wrote:

> This patch series redoes how fixed features for protected guests
> are specified in pKVM, as well as how trapping is handled based
> on the features available for the VM. It also fixes a couple of
> existing bugs in the process.

Tested-by: Mark Brown <broonie@kernel.org>

--+UK7DtF2N3FgCqnU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmdIqfoACgkQJNaLcl1U
h9Ahnwf/RXp6E2oXvmFjv+NBfMZiMoVnatZ8caqPgnXg3+GBDJnpTL758vHDQZhy
nOCeDC06R4dn2ZyFvoWswcl5tBy6vORO88rgWycarzzUUdBoGoSk8tySA5QbKSnk
GM61J75SiZfrtKt8C7WefoUZb5o+EKN8uulUfqwbG601KtIeqtIeh6XQcYG/0FSQ
5FnbcH09p8BDtFB/wK171+5HlG2h80CIffO+RdUsI3Bjfz6+xjVPXZHLb1C43uPy
PV6NzfIc4NNLbIDtdtp7KCJO+5L1DZ2Dqr3WUfEJjEUsSZgEU9ETs4ZRcc44xGGK
pHjGvk+9pXNvpcr0AbjaJEK8YOnLbA==
=v6vt
-----END PGP SIGNATURE-----

--+UK7DtF2N3FgCqnU--
