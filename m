Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44A91DDE4
	for <kvmarm@lists.linux.dev>; Thu, 13 Jul 2023 15:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E558FC433C9;
	Thu, 13 Jul 2023 15:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689261342;
	bh=J8CI62843qBV5g/ywtX7mPy3L1k6qiTP9b+hSJ/Z27Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VK0TV2p9pEw7IaCwgFhtGS595nBMvq/hqM46Ks0+aKCulTlbVFi5lRTJakgtIiDYO
	 56y0BchyC2Z+qKePBvNlqR/FPYq3PwEINOsB2HXu1K87IeLy/7WsqKUoLmenJrISs7
	 VId9WS55XFkvFeMxK/f6YTqiWhfoajP4CzLsBNOjqZxCDOdpXo7QEc8U78YPKreU1E
	 5196lP6hyK0JEk/azHIpDhM4Z4WEdbXr/uOl45DdvgZi+Te94dzQEXJl+pG1UuxFec
	 o+60ca7aXHIbtQJO9z66l/1yv1FT3umIyng1H8pnImz0+y9NkVSam3IjLszrEYBdqs
	 fVsA55RK5Gyow==
Date: Thu, 13 Jul 2023 16:15:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 2/2] KVM: arm64: Move FGT value configuration to vCPU
 state
Message-ID: <9dedca62-7821-461f-805f-9550b17efd48@sirena.org.uk>
References: <20230712-kvm-arm64-fgt-v5-0-dae3ec236288@kernel.org>
 <20230712-kvm-arm64-fgt-v5-2-dae3ec236288@kernel.org>
 <740731b6-5f3f-7acd-6d9f-8adfcef833ab@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="EnCPHKtO44F78zY9"
Content-Disposition: inline
In-Reply-To: <740731b6-5f3f-7acd-6d9f-8adfcef833ab@arm.com>
X-Cookie: MOUNT TAPE U1439 ON B3, NO RING


--EnCPHKtO44F78zY9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 13, 2023 at 10:48:54AM +0100, Suzuki K Poulose wrote:
> On 12/07/2023 13:50, Mark Brown wrote:

> > +	/* We currently assume the host configuration never changes */
> > +	vcpu->arch.hfgrtr_el2_host = read_sysreg_s(SYS_HFGRTR_EL2);
> > +	vcpu->arch.hfgwtr_el2_host = read_sysreg_s(SYS_HFGWTR_EL2);

> Doesn't this crash an nVHE host ?

This series is probably moot given Marc's nv series (or at least needs
another rework) but could you expand on the issue you're seeing please?

--EnCPHKtO44F78zY9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmSwFRgACgkQJNaLcl1U
h9CXpwf+JLP1w8uzY5yZBuNkyGYO30fWFE87nlIIyAtFk6QUfErKGKTqAvBizyDe
i7ulxCVbSPvk4a4lFeNmciOZjC1iDVBEIomeJO3fJq0bQSFeMqXUv08hF7HRjG9h
QLCVvwU4bifo+m9W5v4T9MHCdFf9DtP/+8hk2D8iox1Ds2+kU/7iTNtNLP94lWiZ
lkxHAg+sDPAWqcTZj6gjunguf46D0Cn/eknWy/ve738jG6WPmio4CH3U6G6BJRZI
RbqQsf9IE9kumSkZgvohVdOzRvgxJpWE3dRpPLhbvBc1nCqnWU3xLmAYkO3kkQCq
IOaitV84FjAPfxazuqqaBRjk5OMmyw==
=nHc1
-----END PGP SIGNATURE-----

--EnCPHKtO44F78zY9--
