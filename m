Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2B56AB6
	for <kvmarm@lists.linux.dev>; Fri, 17 Mar 2023 14:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2A1C4339E;
	Fri, 17 Mar 2023 14:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679061996;
	bh=r/f10ey+KU36SLq2h2eD9znVRssRaSlxnMrs70+n5uc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N44eU/pIxNjA46zEM0B+iRJtINf5NzVaxv01/BCsgSuPCkXYZYUiUvZj0QIxnQXjz
	 +JRGdGBG5iqafRiozFrVB2m5ceMHfM9271enAn4XeD3UN+0KqSIA/BfwleUXnJ+UG5
	 4ZESi4GwsK35LjqZsMbdQCH9lvbda6jFQx5oOpczQXRXKjb6XKSmTj224dV5i8Xg10
	 KUt5zJYe9+tAftQc/3J7GbEAA/yLWdOC9SahXwC3SP5UIvHbOPpspW0ozixgRP0VUq
	 rAC7OaX2Ji6+uq47XjXSTgVV+uRuCVARSlznMS0/M4OaXc5vNKF87i6VWkhCCU7Cqt
	 Gqe/ZWkDhXtwA==
Date: Fri, 17 Mar 2023 14:06:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/2] KVM: arm64: Move FGT value configuration to vCPU
 state
Message-ID: <543feb71-3223-40f3-8e04-088c208946fe@sirena.org.uk>
References: <20230301-kvm-arm64-fgt-v1-0-cfdf71ac67dc@kernel.org>
 <20230301-kvm-arm64-fgt-v1-2-cfdf71ac67dc@kernel.org>
 <867cvfyclz.wl-maz@kernel.org>
 <855e60de-56c0-4500-a8ce-d79ffb0ed19d@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/iQdiWwoqUOXGLnW"
Content-Disposition: inline
In-Reply-To: <855e60de-56c0-4500-a8ce-d79ffb0ed19d@sirena.org.uk>
X-Cookie: Life is like an analogy.


--/iQdiWwoqUOXGLnW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 17, 2023 at 01:49:50PM +0000, Mark Brown wrote:
> On Fri, Mar 17, 2023 at 09:02:32AM +0000, Marc Zyngier wrote:
> > Mark Brown <broonie@kernel.org> wrote:

> > > +	vcpu->arch.hfgrtr_el2 = 0;
> > > +	vcpu->arch.hfgwtr_el2 = 0;

> > This needs documenting by enumerating the sysregs that get trapped.

> That's an awful lot of registers with the fine grained traps, and when
> extended to cover HFHxTR2 there's a bunch of RES0 bits intended for
> future traps.  It feels a bit unmanagable.  I'd have expected something
> more along the lines of "enable all traps other than...".  The pattern
> seemed to be more to have an explicit initialiser for the bits that are
> set (eg, with CPACR_EL1) which was why I didn't put anything explicit.

Actually having checked it's a bit more than half of the bits are 0 for
no trap so enumerating those that are trapped is a bit shorter.

--/iQdiWwoqUOXGLnW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmQUc+YACgkQJNaLcl1U
h9D8MAf/aNsBXb4sUtZM9+x35UPbwLCUk0WS+98tT2VSEEZaMYgsl/uDmT3brFfk
9FSZKoTGugIIBMaWVEtZH+eGXkwd0uiHaghTC9oJ898EIFhI3vWsyFmfE/qyDcAd
UKL+ZuySnyEsfloZW+wCKDcy19PmJRSrxIrEuOhfGzRZ/aB8YW0em4yx2x8VvxnA
7Ay2eOe94vTQN4cjb7BBC/537uE4+SOr22oK0li8zWhyiuNC6IG8YWC5q9LKeEfF
9gYfoxVtRnp0gJf7VX3XmUynjy2gi6FV0OW+KqxTgOo26GHkz7uNoyUbK7IgFCuf
nLjaoX0iypYkGgMlhV3l+SsA+ufKpQ==
=t8KZ
-----END PGP SIGNATURE-----

--/iQdiWwoqUOXGLnW--
