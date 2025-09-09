Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844E318A93F
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 21:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757452626; cv=none; b=OdTh3W57bxa5TLvaFbyCwzE/SdGrnqNUTuXUsFba4iBks1QUGtGors5YxlrTXxitXA/qtfgm3u+0p1Xte42B2Jp8Jyr/eb9/6Y4Pp693oLgidw03DivVTMJQw6pORxnyZ8z7YgirfEz51d/K++iJTN/CAJPsSQkfw1P2KqlnekU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757452626; c=relaxed/simple;
	bh=wqTbrEtUcaaZKtYI4r3Vm9Q8FnxOd4Fnxqf8dwa2ri4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NHNTfZeApZquKggWhTiLXHbBgKlKmceLCedKP73sDGJGyYqDBMp+S4VLMyA2FUZ1nEBYZOSufB5qhf83eFB58RsSQA4f8TxlmwcSxFiB+kd/5N02GSNiLN/lJMHSaiW1UxaL9lq+YAQm7dIEnp6YdktsIXcrs8Mq5Bk0tlqny6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kogutVux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kogutVux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A87C4CEF4;
	Tue,  9 Sep 2025 21:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757452626;
	bh=wqTbrEtUcaaZKtYI4r3Vm9Q8FnxOd4Fnxqf8dwa2ri4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kogutVuxlqUsh2U+p5ULajqFEYQj1kyC+8BEHJzkOo4T0ba5gwae2U6SCcmwg/wrD
	 qo/DoaDvhZnyyJ29/7zPEdqJ8wk6fpwKdoXJbNNimyEr1YZFHzlNwZIfj/fACfkja3
	 VLZVwftv+Hcj86iAhqW/8jYFw/ufmEnTIRt6SXac0pUOP5Qb81OVp8TXXvZnQGxYen
	 xB4rbETCMfasnzjGJW5WnhSioz0WDy7/cslM15Bn2m57rwerL4LM1DynkOSqkZ7UAn
	 8dqjgd1eeLuu9jdCI5k3Nd1/uVKE8m3IzET3/z/gClfhUnH6v662ngfFE5DPpqXOu0
	 08XwFWsyEyxeA==
Date: Tue, 9 Sep 2025 22:17:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, vdonnefort@google.com, qperret@google.com,
	sebastianene@google.com, keirf@google.com, smostafa@google.com
Subject: Re: [PATCH v4 0/9] KVM: arm64: Reserve pKVM VM handle during initial
 VM setup
Message-ID: <5f26bc44-8bd6-4b98-af1f-0af828df9a4f@sirena.org.uk>
References: <20250909072437.4110547-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XMFfmpfGmrVEKPJz"
Content-Disposition: inline
In-Reply-To: <20250909072437.4110547-1-tabba@google.com>
X-Cookie: Ma Bell is a mean mother!


--XMFfmpfGmrVEKPJz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 09, 2025 at 08:24:27AM +0100, Fuad Tabba wrote:

> - Fix bug reported by Mark [2]. The existing call to pkvm_init_host_vm()
>   wasn't gated by protected mode being enabled, unlike the call to
>   pkvm_destroy_hyp_vm(). This imbalance caused failures in non-protected
>   mode, especially when creating and destroying multiple VMs. Tested
>   with kvm demand_paging_test using nvhe, vhe, and protected.

I fed this into the testing that blew up with the prior version and it
seems happy this time so:

Tested-by: Mark Brown <broonie@kernel.org>

--XMFfmpfGmrVEKPJz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjAmUsACgkQJNaLcl1U
h9BIwAf/W/HLf/BuWBlLw2ke8IEN1N6vfqr9YguXATzWTFzruv/nEqnHXlSKA6WL
sguYK+Erg+Or2zTKvDDFo41gU/7nxfpR9vS5HKpqiz4LwTD4XJ064aYvhZT3WJzA
OPDAKLz5t9dBd0yDrWLSsYHBU/+R8RriWlydK7iwe2Iu7/xXE6GwOJVfEnIkXGH1
YeC+QCHmnD6v+Z58iSmRBPiwTO7kD4e8dJeYAESvucQRfDR31TStlpDC5RmGqjFd
RwXam4U1pMsWqtHOi6HsZbIlcDMQlKqqIDILajVb4JtPxGcJu4HgB6sKfHyrY7rq
r6o16HtoDGVxCfoLs3RsTXouM1NQbQ==
=ipmk
-----END PGP SIGNATURE-----

--XMFfmpfGmrVEKPJz--
