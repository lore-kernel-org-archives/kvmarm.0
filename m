Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678693C6BC
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e+d2Zn9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184CDC433C8;
	Thu, 14 Dec 2023 10:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702551030;
	bh=WhVk6LdYTBcLUolzvQwZzTU0osUuadmW4+S3Xld0eN0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e+d2Zn9x5QJyRYo15LjvCmCJPKt6hCIlfqkH6Vubiubw14MClDtGJuid0wq5MyPuj
	 vlpdloZmXDCiEUgxnbGw+9lIHlptZDKDzGHBIgeL2Z+KcarbM7ydytJWqFHbDTSiHM
	 QESMiPy0SSYsLrsz4SYfpVmmu0JjfInmnGdUHQ98GPfzj82yJAs+RtFoheFZMcNUJ6
	 h+eiloAwsjsJPlIZp/B6dRwkJ8LlCkjM8SW2g+KV4JJuex8GEjnLdAgx3EURdCz0AJ
	 8kLj2auLm/tCLdEOnpohE4y0dWyuaLdB2KlhmmdUBn8o9/9JV2UXyjMz6iuW+sQoP2
	 SPg4mhnRK26UA==
Date: Thu, 14 Dec 2023 10:50:25 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com,
	jingzhangos@google.com, joey.gouly@arm.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 03/17] arm64/sysreg: Add missing system register
 definitions for FGT
Message-ID: <c9a947e9-7bf0-484d-970d-4094d19ed5d5@sirena.org.uk>
References: <20231214100158.2305400-1-tabba@google.com>
 <20231214100158.2305400-4-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="SJaJ5HEXpA+q0OZk"
Content-Disposition: inline
In-Reply-To: <20231214100158.2305400-4-tabba@google.com>
X-Cookie: Preserve the old, but know the new.


--SJaJ5HEXpA+q0OZk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 14, 2023 at 10:01:43AM +0000, Fuad Tabba wrote:
> Add the definitions of missing system registers that are
> trappable by fine grain traps. The definitions are based on
> DDI0601 2023-09.

Reviewed-by: Mark Brown <broonie@kernel.org>

--SJaJ5HEXpA+q0OZk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmV63fAACgkQJNaLcl1U
h9AnOgf+PVtAXSrnlzE9CDnbX0WKrvaXfoEJCi3KzYwJreZcxVLhpBDdsTq/jZ2Z
E3xPbIxx8gQRlkQ8I0EJqgeUa16GnJk0tDCD+0BwfLX6NUsXCtMdLzbkAz35GSFZ
bPPlk7iq9Pqpi6PVNnNBSsNymODVg3+0X+gDBjj75zWZMNa32EeoSpQwPGf8lOcm
qOf0VBAEfVOP4ydYS41qboKlhKE88RDw1+xkb/ed0iK8cRIHwKdWgnxAwbUAarMs
fJKxzo4W1oFAF+kXGp+Zdu8D16BKqwcZFupt2O2f2HGCIcn2fzB7/Tleq12wCGJW
GzCzXEAvU4x86yAGpNxemfOse3LdOg==
=B+LD
-----END PGP SIGNATURE-----

--SJaJ5HEXpA+q0OZk--
