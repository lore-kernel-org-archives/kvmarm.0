Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FD12F2D
	for <kvmarm@lists.linux.dev>; Wed,  7 Dec 2022 18:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FE9C433C1;
	Wed,  7 Dec 2022 18:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670436975;
	bh=iude3TPSecC3CxZ9O8wG4MIg1d3nbLDrxciITYNV+3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KPuYqvAG1P8+/viRmKd8uBTmEmRpDpXUaP9QUXvcZiw4nbKbt+6Ryr+RBNrXjjQpL
	 2inHqsV12FkFers/xFrNaLJYnykfZKQ85BR5Hu8C/nqnvqtZWjoUp+KY6BfEb60/Jn
	 ThW7N8eVgVLrmasDdAVNzL2Ybqb/6v3ec/YDN/DovIxI2Oy7LlExjbrVKzfWlxS1uc
	 rDsz7MraN/Cr7gz8t3VQtteNX1+h98ojYAGoiwSceKmQD28NL+cfl/5MoFbSfH/IDT
	 i/GLcdoiIyhjIIXkvkWUN1TK0eKXwwj4yljM3ZWFW6C3g9s3e8JM2Hm+CcBsqTzjf2
	 QHrC5zzy3sbvg==
Date: Wed, 7 Dec 2022 18:16:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v1 1/3] arm64/sysreg: Add definition for ICC_NMIAR1_EL1
Message-ID: <Y5DYatg7CiOTuClw@sirena.org.uk>
References: <20221206131144.115774-1-broonie@kernel.org>
 <20221206131144.115774-2-broonie@kernel.org>
 <86fsdrlaz5.wl-maz@kernel.org>
 <Y5ClnlHz5Spp0rUy@sirena.org.uk>
 <86bkofl08v.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2lYrz+i3cS1/YXEz"
Content-Disposition: inline
In-Reply-To: <86bkofl08v.wl-maz@kernel.org>
X-Cookie: What!?  Me worry?


--2lYrz+i3cS1/YXEz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 07, 2022 at 03:08:48PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > Given the textual conflict with the ISR patch and the fact that the NMI
> > series needs both anyway it seemed more productive to just carry them
> > both in the cleanup series even if this one isn't immediately used.

> I thought the point of this series was to extract stuff that was
> otherwise useful, independently of the NMI series.

I tend to view the system register definitions as just generally useful,
this being system register definitions plus a cleanup that could be done
on top.

> I must have misunderstood its purpose. This is instead making things
> harder to follow. Oh well.

I am hopeful that the extra cognative load of an additional register
definition will be managable.

--2lYrz+i3cS1/YXEz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmOQ2GoACgkQJNaLcl1U
h9A8hAf/UFhaxIdT750uCZIhr4DGI172tPMCConmMDYsQA1oxF9KnnTyNVweYeFC
Fto4oOqRFam2En1C5ZVrvuKYPMtebJ+1H2PQeTPp6zCVhvsGid4unIZeYciOMqjd
QhDw6o2bjrlKAZEV5RcAyK5tL/kFlWRsVi6/kMBTM3AOhnnota/7vsDTEc4sJb1c
Qowp4RlpLhzAK4J3Eg68RC30tkdQMgwUJkbdLX549rH1j7r0isCDD7BKwuzjbOy2
B4DcQ8vLj+Doeid38ZiBDve20KTN3IYF/atJdm0jNxergoUI5RgOXQ4btDYTNG9D
KuvzO3EfJi7FWVvUIU7l27himT/Ngw==
=YwJl
-----END PGP SIGNATURE-----

--2lYrz+i3cS1/YXEz--
