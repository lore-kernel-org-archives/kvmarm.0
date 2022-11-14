Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9A83FC2
	for <kvmarm@lists.linux.dev>; Mon, 14 Nov 2022 11:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0988C433D6;
	Mon, 14 Nov 2022 11:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668424260;
	bh=H1xzJZTubwFeAlTY1DhtTMmeDddQSbNKQgnF+y/bS3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FFan1mqru+Ke4a6aEUqTPqLpGD97SM0MdY41WAbM+XEMkYdMJeBRcFhREnPBAVsiT
	 Y9WBkjpn1Maynn1h5OqtR5ptEacPBTPexu01smY8UML81Q1E8AxEmUqCDgyR+uFhAZ
	 Dgaz51oG1avzQx49kqLvBzcHJU7VbD7OQT6mzpwOHA0ztcKezV11buENjRyljDbERf
	 +gdOrzYRsd+nlmucBsZ2qxjBABE+VQKEvUybb5rDS/yBAAAZIfhTFdEp/Rq/+m85HC
	 9xJSclKRhIIttODdhqdsn5gAuLQZg2MEeYHV14FWSj3ifT8IxQqQx6VKTki4P8Y793
	 fEtb4+Qk3h+sQ==
Date: Mon, 14 Nov 2022 11:10:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Zhang Lei <zhang.lei@jp.fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/8] arm64/fpsimd: Track the saved FPSIMD state type
 separately to TIF_SVE
Message-ID: <Y3IiQtN5b0C0+IZM@sirena.org.uk>
References: <20221021230321.1159287-1-broonie@kernel.org>
 <20221021230321.1159287-3-broonie@kernel.org>
 <Y3FrvJQzvW4YFfEF@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TihKtjQW9wNhkqAw"
Content-Disposition: inline
In-Reply-To: <Y3FrvJQzvW4YFfEF@arm.com>
X-Cookie: Ego sum ens omnipotens.


--TihKtjQW9wNhkqAw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 13, 2022 at 10:12:12PM +0000, Catalin Marinas wrote:
> On Sat, Oct 22, 2022 at 12:03:15AM +0100, Mark Brown wrote:

> > +enum fp_type {
> > +	FP_STATE_FPSIMD,
> > +	FP_STATE_SVE,
> > +};

> More of a nitpick, I still find the type/state naming confusing but I
> don't have a better suggestion. Maybe call them FP_TYPE_* or rename the
> enum to fp_state_type (up to you really, feel free to leave them as they
> are).

Yeah, the naming is kind of awkward and I'm not a massive fan
either.  I think whatever name is chosen will end up being
awkward in some circumstance.  No problem with renaming if
someone has a firm thought that some specific thing would be
better though.

> Either way, I think having an explicit type of what state is about is a
> significant improvement in clarity.

> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks.



--TihKtjQW9wNhkqAw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmNyIkIACgkQJNaLcl1U
h9Al7Qf/YVtBPKUU+JPnxFwq2bBEVwPZUl91IFvU2MQIWm6bIjqkYhnUInTCqInT
5XX32VREzr1VRHB58cJ+99IANzFWHj+KkQanvx1MDyhDVAl9NbHzrChvUSbo5lAP
T1xOvXVSJr0q6iNzfXUQIbcjHimXZDV8ibQ/Ktj6TQ1knKgmZTDOAz12i4CmvS5Z
Pe/1Ltj85flgeAS+iuHbpy59dJB8QJkQOkMd939G7vovS+V/nPQc7MoAQx+ugv4Q
JDBmX3Mk+XzUJd0XA9EGMU1r/okfmSYiExmBpp4WOiwDGMogZiLVF/ETCryRJQA4
CRTzCrpb+LrYdQjnmDmhhJ+R2QUlMQ==
=56gF
-----END PGP SIGNATURE-----

--TihKtjQW9wNhkqAw--
