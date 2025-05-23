Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285C0219FC;
	Fri, 23 May 2025 14:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748009758; cv=none; b=hL5C05VJ2paIS4m4dskQuPXJ63pYWGgkcahBDNFU0+JSNfOdSXWalje4VRI1YqSuCxNrYw200ENwOTJXvLgKn9kfxj0ZFgFUlXZDrU1oHYjv1MpeQuZkl8Q2nC7X9Mfm2Kf2ErHTAMnq+0BjDkN7H5LA61Y8jVkEeEcOLxHASFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748009758; c=relaxed/simple;
	bh=E2T15UQb7YmouLcQa9XmZQe3OTz89LQ9xuaFzoFi6tA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RfmyVZcImABtPAOmby5iGg+WUaLaMAy+RvTZvdSLkUnf0+VGf6rSOVHypswMUJ0PMMZGnkCdp5yOHy6ZL6zzn4V3bBD6yymnigs5Rl4iIzxh0c1jGuhWj3bkcdS0liO5Vgy0yJ9v7qGXbhsjdlhKdAiEnLuVxTb8WcwWecWvgR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SAtFyDcM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SAtFyDcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71AEC4CEE9;
	Fri, 23 May 2025 14:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748009757;
	bh=E2T15UQb7YmouLcQa9XmZQe3OTz89LQ9xuaFzoFi6tA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SAtFyDcMb8cPtd+I6NmN6gXlU5jz2lHRPwrwl1dVWWQMjkzDoHPs+DYfrSfIBUZnU
	 mVqgLR0xt/lgbEdY/+OWagqccWqRoiBTNUzvnW4SVDtWTpL5HQUmndRupgOVstrK29
	 /dp5pNnucd909xPdYF+jqK86o3kckB1sVr0AJQbvcUejN8lC49ic1gz3nr/rVoG7IJ
	 Q4Gp/3hCgeQca84/zDWVCWSrEwR4sRyy6sqxAeHU5lj9/YtKWYXF4xesQ7ak+v7205
	 sZZwWYNEEvuxydVXJvkCauk9Jou5faH7sDRXdCKK4+KK+yDfAg8jmCqMRKQY2Quijy
	 w6BvCQcBsQjiw==
Date: Fri, 23 May 2025 15:15:53 +0100
From: Mark Brown <broonie@kernel.org>
To: D Scott Phillips <scott@os.amperecomputing.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	James Clark <james.clark@linaro.org>,
	James Morse <james.morse@arm.com>, Joey Gouly <joey.gouly@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	"Rob Herring  (Arm)" <robh@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Shiqi Liu <shiqiliu@hust.edu.cn>, Will Deacon <will@kernel.org>,
	Yicong Yang <yangyicong@hisilicon.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] arm64: errata: Work around AmpereOne's erratum
 AC04_CPU_23
Message-ID: <aDCDGZ-G-nCP3hJI@finisterre.sirena.org.uk>
References: <20250513184514.2678288-1-scott@os.amperecomputing.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="JOptcxW8/D3dLVn7"
Content-Disposition: inline
In-Reply-To: <20250513184514.2678288-1-scott@os.amperecomputing.com>
X-Cookie: Always wear your seat belt.


--JOptcxW8/D3dLVn7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 13, 2025 at 11:45:14AM -0700, D Scott Phillips wrote:
> On AmpereOne AC04, updates to HCR_EL2 can rarely corrupt simultaneous
> translations for data addresses initiated by load/store instructions.
> Only instruction initiated translations are vulnerable, not translations
> from prefetches for example. A DSB before the store to HCR_EL2 is
> sufficient to prevent older instructions from hitting the window for
> corruption, and an ISB after is sufficient to prevent younger
> instructions from hitting the window for corruption.

This patch, which is in -next as fed55f49fad181be9dfb93c0, breaks the
build of at least the vDSO selftests:

$ make -C tools/testing/selftests ARCH=arm64 LLVM=1 TARGETS=vDSO

  CC       vdso_test_chacha
In file included from vgetrandom-chacha.S:9:
In file included from ./../../../../arch/arm64/kernel/vdso/vgetrandom-chacha.S:5:
In file included from /home/broonie/git/bisect/tools/testing/selftests/../../../arch/arm64/include/asm/assembler.h:21:
In file included from /home/broonie/git/bisect/tools/testing/selftests/../../../arch/arm64/include/asm/cpufeature.h:13:
/home/broonie/git/bisect/tools/testing/selftests/../../../arch/arm64/include/asm/sysreg.h:1097:5: error: function-like macro 'IS_ENABLED' is not defined
 1097 | #if IS_ENABLED(CONFIG_AMPERE_ERRATUM_AC04_CPU_23)
      |     ^
1 error generated.

--JOptcxW8/D3dLVn7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgwgxkACgkQJNaLcl1U
h9A3Pgf9GsTk5F/0fGNY7kWqakfU1yTU+RDK9n6FFb+6TJtfgeAXmmC8cEWLDAC7
tZX+QqEMT6QCMrQwW30wWrG0DMlSXea4lOlEbe+Bxyj7nXyb7buttUfdXWhSnWBv
yIJBf376RmMy97ILyMoS6rtIhLtKoU75JXoWjB5QgYiGkypejZR1F8nH9y/hGO+9
tXRx1oLyc/5agIHMewTCuqeCBZRz3yv+I5cF5C133O0bMdLt5JaPJ5tYL+SH1vi2
Cqe9Au9ZZsVntJwxf/c+iq7qtvjxxy+NMfgJrx+ebEgZVOzZN2HjDUoWgb9Z83pv
MVZQBGqQ1cq/g8bSFqTDiGjj4VbZTQ==
=buIY
-----END PGP SIGNATURE-----

--JOptcxW8/D3dLVn7--
