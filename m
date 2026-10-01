Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092AC5304B0;
	Thu,  1 Oct 2026 18:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790878481; cv=none; b=QKm8QaJCxErNbQBqq/5Z1BeRN7WxwqpT1Zn11YTu9INWDTAmoztF0qu42pZhVKt/nt9o/vMDtrFYAjUwNTryDwkoEbIq6VAxd0i2LYxXpewVgJWzDJ8R4GNaMJBFeQtNHQuByQyBcbYoqplVGJ83pzd3BspKDumMEAI1jApsXB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790878481; c=relaxed/simple;
	bh=8EXPyjCLnT0u6Y3Aw1qgMDaoecca6+CurIO2hSBvPAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XNgN6I7Zxe6FT5tW6b4iFJj9TMHvoah0gjG9pzT/VduF7caGaPVmXSvSKDJN5fmZ4ehAWwxZksdmwISmcVsjfxCJiL5NM6dEa5s99SKMYCkblKLdkervgj06oOutuZVXcjAlgLPqQ0JBNyve/RJ/azXmGB+x753nBesYd7pE+bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K0YVCfY2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K0YVCfY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA111F000FF;
	Thu,  1 Oct 2026 18:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790878472;
	bh=8EXPyjCLnT0u6Y3Aw1qgMDaoecca6+CurIO2hSBvPAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K0YVCfY2IDUaC4Vt4tc6UsXJc2uHpFjZ8QQVRtHbwXnLVQqg+u5EW9RW5MrX/HhQt
	 aBsJd+I6q0vpz1wNylTgBOsPVkpnW2j+cvZENvcBD/lZ77oY3EszViUH6kkOwBetVZ
	 H9VGfiGECqOwiSeuB2jonVQsYNAMtKKI3/q4s6kzPVf87jTYbNAd4pPl9T4ACPIPek
	 LtFtHRGA6IIl2pBMyHvMWHQMUeqkiMrPxHmN8sH+OuFoedNzkmC7ZM9/iQztEMXzzH
	 NmCq/uXXPLYoUpwEva61QltarOEgoeojcabxt2AbJn61YJxlS/VrguUjw6ri9wGNBX
	 vbDa2ZJ5fJvBQ==
Date: Thu, 1 Oct 2026 19:14:26 +0100
From: Mark Brown <broonie@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
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
Subject: Re: [PATCH v21 12/15] KVM: selftests: arm64: Add GCS to set_id_regs
Message-ID: <8eb4d0f8-3080-4efa-afaf-bbe2a16eaa37@sirena.org.uk>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-12-3556644cd927@kernel.org>
 <ar6MIFW2vfM893yd@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hLSHdAw0xQgYgBov"
Content-Disposition: inline
In-Reply-To: <ar6MIFW2vfM893yd@gremlin>
X-Cookie: Do not stamp.


--hLSHdAw0xQgYgBov
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 01, 2026 at 05:38:54PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 30, 2026 at 10:48:22PM +0100, Mark Brown wrote:

> > Now that GCS is configurable via the ID registers update set_id_regs to
> > cover ID_AA64PFR1_EL1.GCS.

> Should maybe also mention adding the GCS-without-S1PIE test?

I'd have said that was part of the coverage the test now has for
bitfields TBH.

--hLSHdAw0xQgYgBov
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmq+owEACgkQJNaLcl1U
h9AK6Af8CW+PewA41u22GjCm2K4HWJprbzV/mTkY5qCL0xX8i+fFZwjBEGuDg++l
1WZRIYTi4kqI5ofqkLVG8zllv9dSAW+DXcsH7TJjs5wyZDO9bNqbbBeqFZswxGMh
ZYdKcZLYTg7gs9EGJ5eEPyIgNYjjJga9ABn6hZTFsDEM+VKDL7GcjpO6WXW+JPZg
cc2IlLt9eQTZcjwpvtnT9xwnHsbCppAuuVqV8tU+ZuTQ94TMixXsDTTltMvolgvB
9ZDUkJtJD9k4vuBdXiyh/UmkgMf+b9hoDlJwshmwjziFwY25asoZUM5LNZcJhC8t
E5Dked3ERLcN6MVu6njP5Qxr0XEW5A==
=ZnLt
-----END PGP SIGNATURE-----

--hLSHdAw0xQgYgBov--
