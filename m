Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A657D433B9
	for <kvmarm@lists.linux.dev>; Thu,  7 Dec 2023 17:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fE0ZoFF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72822C433C7;
	Thu,  7 Dec 2023 17:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701969563;
	bh=soAGsCzUSI60M8maE1rFx/WCahhUvyzkLxfGt6y1kXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fE0ZoFF3UbUerTcY5Zv1EL1ucedcGP8ZnZ5I9KHDXOE5rZ37gMFyUW7mYMOl/trwq
	 wrCBaec3IMxolkAttd6L3mEcEhYS6Zk/fsP4YNsApiqQ0y896SeocLc0POKr7eOO6p
	 M/XnHpw9YgdoHf0ZVrag/d0Ce/WgTbRt+sBZ57wJPe3W8DJxhzQ0NrzX4OnTCQQPKZ
	 bXHBbtEZnL5OUGjGrT5U3Xjy8QZzaX22OFYgKJdoLCDcBUF/+D8zkPrzMddKF68/Ki
	 cCMLMkIVSWk/EBKZwP3NMdKfji1lhpE6XuKKW4WmXPrbT9t2QcsrxezU3FClpCUe7I
	 +zKEvcnRgUmag==
Date: Thu, 7 Dec 2023 17:19:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com,
	jingzhangos@google.com, joey.gouly@arm.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 04/12] KVM: arm64: Add bit masks for HAFGRTR_EL2
Message-ID: <268ebe97-1f79-416e-805e-9a67144f6a99@sirena.org.uk>
References: <20231206100503.564090-1-tabba@google.com>
 <20231206100503.564090-5-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RnYvB9yQ0FuLj9k4"
Content-Disposition: inline
In-Reply-To: <20231206100503.564090-5-tabba@google.com>
X-Cookie: No purchase necessary.


--RnYvB9yQ0FuLj9k4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 06, 2023 at 10:04:54AM +0000, Fuad Tabba wrote:
> To support HAFGRTR_EL2 supported in nested virt in the following
> patch, first add its bitmask definitions based on the 2023-09
> Arm Architecture System Registers xml specification [*].
>=20
> [*] https://developer.arm.com/downloads/-/exploration-tools

DDI0601 is a more stable name, and I'd have expected an "arm64/sysreg"
subject.

> +#define __HAFGRTR_EL2_RES0	(GENMASK(63, 50) | GENMASK(16, 5))
> +#define __HAFGRTR_EL2_MASK	(GENMASK(49, 17) | GENMASK(4, 0))
> +#define __HAFGRTR_EL2_nMASK	0UL
> +

This one is an example of something where some manual encoding does make
sense given all the AMCNTEN<x> and so on fields so:

Reviewed-by: Mark Brown <broonie@kernel.org>

--RnYvB9yQ0FuLj9k4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmVx/pQACgkQJNaLcl1U
h9AOagf/f4HcFJfYdCPNDBEcuHhuw4R4UDRuES8s5pkKdtNasOPF50yN3JetOy8m
JQQ94ZydZjeroP9Fzcvs00N3vErfN3dfLBpkTSQ22gIYmUEzQNCP67bS3jhXWz+w
qIOGB8lb4gnyUsIV6LH9fWq9WGjk/vZst3HPZG/jqp/57sO3AbDG/tl5H+5fuk1b
g2DOw3wywF75GAT53jKodLced0ROLJDtCfQ8ummGkbw9yFgFG3LkJma4vbs0XAdX
AOmCySfLw7JFgRxhbp03IBwiFyXb4cnD/44VfKVa+cX1fSYGZjzw4cp8iSdRbHZX
PwxMZBr97HdOm/WWL+6Hb6PnYfgiew==
=z6EX
-----END PGP SIGNATURE-----

--RnYvB9yQ0FuLj9k4--
