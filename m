Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C84517AC5
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 12:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE94C433EF;
	Fri,  2 Jun 2023 12:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685707520;
	bh=up4fDEXdALuY+rpP+uRCpHKNiFvX8SI/VQPNNWMb0fw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QdUSZi8OxS4wLRgLR33AQZX5/y7b3G48SRO3BWVjxI2bdM+3bj+ziO17wq9z/Znrh
	 3JhnQLFVcjh02HvifU5awDg//1HviQYD5xXMuBH23VGWc6buNT9OtYjJ04X+9ceq6h
	 GDs7m1INIYlmZT9PUnOPMp5czgAaKwlieX52N4c9J06JLhkJvmCYTD09F/QyqesK6Z
	 lG+XJHVZ+KJUchddyGIK7htgrdgcTUtknAiJMUTHR5lyQKTWg6yC00bmGllS1Lghb7
	 FzA6B0m60Ib4wSEJd7ldZxxniO6jRNlypMEtigOPff2OVDhfpBEk9Yh1LRb9EYEFpc
	 dibhjqiNKTDRg==
Date: Fri, 2 Jun 2023 13:05:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>, kvmarm@lists.linux.dev,
	coresight@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 12/14] arm64/sysreg: Convert TRBMAR_EL1 register to
 automatic generation
Message-ID: <8a352dec-9655-4e7c-ba35-1c48e154bc71@sirena.org.uk>
References: <20230602062552.565992-1-anshuman.khandual@arm.com>
 <20230602062552.565992-13-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8M5OxuIqfoPiZ46q"
Content-Disposition: inline
In-Reply-To: <20230602062552.565992-13-anshuman.khandual@arm.com>
X-Cookie: War is an equal opportunity destroyer.


--8M5OxuIqfoPiZ46q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 02, 2023 at 11:55:50AM +0530, Anshuman Khandual wrote:

> +Sysreg	TRBMAR_EL1	3	0	9	11	4
> +Res0	63:12
> +Field	11:10	PAS
> +Field	9:8	SH
> +Field	7:0	Attr
> +EndSysreg

PAS and SH look like they should be enums, Attr is a bit more complex so
Field is probably a good fit there.  Adding the enum information could
be done incrementally though so:

Reviewed-by: Mark Brown <broonie@kernel.org>

--8M5OxuIqfoPiZ46q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmR52voACgkQJNaLcl1U
h9DeyAf8DMRfz+QJkdq/rhImQy6hP5af+QCrOyzOHCie8CFe3pZqv9GhUMgYjmZh
4nICqhn/HpopBQSGTzoW6qd0/HsjkjjT8WkJZ8gPzBtPM3VAPTHVe0jBgZ5UwCpC
mA46bIqFIgHJp/PW0lB+9P7t/lZ9qGwX+BqLA6ZYrYF7CjHcnEE9HytVSdi87mee
SopLtN874R6dWaMkjoXAbGU8xZ5edIgUoyQa69IX2AoN/MKFcqTbYm/GUh6PdwmC
Iq6RPTm1U6s/jI0D2AYVXaC8XDEKr/DXe8JhVXkkdHlvCDsWKb7HqXm9YOf9ZsVR
ij1fcvPznkRrsziyLVRiJHgbCSoLdg==
=U8Uy
-----END PGP SIGNATURE-----

--8M5OxuIqfoPiZ46q--
