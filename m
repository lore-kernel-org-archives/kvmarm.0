Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828BF4E56FD;
	Thu,  3 Sep 2026 16:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788454004; cv=none; b=QRZCaw2J4RYs7FMArH5rSQygLindV5/O7kyeKf/0PpFPkiFKRS9JLfAxV3vXz5EFoVV9NhO1gwZI7rEipdevuS4ndZ7Aha/VS3fx8l+yCk3SQkQSnrrJWPRIlRr4TJ3oQkCKojaRMu0Rx87pFVm/WLkejF4J9jZIUruCTn9lVUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788454004; c=relaxed/simple;
	bh=+cTU1Gdey6VJ/xOiJTwpoIIjyV5USj5HjGg4yZ9PLyY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Rpl4nZ60Ra/8Py6jpR2g0ISfzhSUues4VIgQHyU66VigepMsJo24l4m9jCAd/0Hh8kfZA+Ra5rAyMpWOFcJ4lPfERddxsy9JpKWE7Y5WTjFgZSZzon5eq+KFSUT98cpK2ZXjNsVyXvtRAp1zemchbizvNXo/17MVZUHmD/SPp/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gx6dsmyV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gx6dsmyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58F21F000E9;
	Thu,  3 Sep 2026 16:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788454003;
	bh=+cTU1Gdey6VJ/xOiJTwpoIIjyV5USj5HjGg4yZ9PLyY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gx6dsmyVc1qsumQxGmh4thc/bkkiq7yVHEGO/tngdyuLsK6axzIbowO83c51YtsWx
	 59aDFI5qRBOMzZMMxpx7Jv40bHxsshcKN7NRFNxc3dIg+nqgon+gF6Bwr5ODta1Bdz
	 rkEtklZu5v2BQ87ju8VUJAeFZmY8i2vDNV440WGH0gL5kzdlPUVZR4J2nO6e0akGGP
	 MiujPDeLuWotieUEnm6jokidLpBxPn+F5guOzRXgPDAezTjbDAs2aN2i4wVbSsPT4Y
	 UguuW7rZ+GPxPYYkNu7JRUqS16xDEHQXXyqz2w2e6oH487yj52AA0RxakXDcos5QIN
	 fjA3whFlkJYHA==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 23/28] KVM: arm64: Add kvm-arm.ignore_spe_errata
 kernel parameter
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260903160623.315525-24-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-24-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:46:42 +0000
Message-Id: <20260903164642.B58F21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> Add a new kernel command line parameter, kvm-arm.ignore_spe_errata with t=
he
> effect of ignoring any errata that might inhibit userspace from creating a
> SPE enabled virtual machine.
>=20
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D23

