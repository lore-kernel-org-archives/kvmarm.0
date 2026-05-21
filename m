Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8200633A9CB;
	Thu, 21 May 2026 15:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779376635; cv=none; b=NPvdACOIfPR02WdhSM1Uc1wMxjIbbYVh+81Knx87nLBU467tUi68BSgcSsTtCof+r9jO0PjRfKAetPCz2M+uaqDwtDzUUatVC3T8Rv+daEZPf2K+ApLI7Klqba9Eou2xmMJd87Ovxcif7outdoTlNXv5nfQrxFq7cJqahcuQ6UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779376635; c=relaxed/simple;
	bh=dRQ7wbvAkJirWmzRur/hlCx4EftiDaoSDUHVW/tWMjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d6ts+tPC+5awc/TJUTwox9KCPeoms/5M/sBGRrBRoXRsz7outpPOVa2m5yUiO9mTgj5kQ7wdgpXRS/CpmpR7NbG88EnhaeRVQsxx71ikGGJnYsWhKk8Leh+pCcyF/H3+yWsT8rs3Hc5uQJmpVIbF88ulOG4Xm1CBT5NopbqquwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ggBnNLig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ggBnNLig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFB51F000E9;
	Thu, 21 May 2026 15:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779376634;
	bh=MJiYGSKR2Xooa6md+cNozvBYHksgw4v8W3oMC6Zadps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ggBnNLigs+MYrxcu3lkCl0NI75vfveOsqe4q67/PhDS1RaXR4+2Zv3GULwDgmR7pb
	 BdTOtrlx5wp0bS3CRX3bydNnTPl01m16gQ8/vQsgCZ3+XJjvcgD+4fVOe6s+DBeF9y
	 ZWhgzPOy5g0VUrJJzGemtXk5IKlKEX/1y8Il2sa/6vVpK+oskajCWBR6/v0Y67RHmo
	 jGBZdODmOBVw4hszRgTDNBL9jHeO27Qs39KrV9s/+JFnsnDWld9FBZqi03a1LxBEtO
	 kEdRmpypvICqFDlrqvVzlwF9Q0InHB5D14eiorpUW1ivnacAuMd21zXtvg/rNjtET8
	 qYjid3+pNnDNw==
Date: Thu, 21 May 2026 16:17:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>,
	Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v10 19/30] KVM: arm64: Provide assembly for SME register
 access
Message-ID: <a5226b77-636d-4e6d-acb6-b26f6276f6bd@sirena.org.uk>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-19-43f7683a0fb7@kernel.org>
 <ag8b7oq4SFpdmlP_@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XnCLFiWrG4EBMfBq"
Content-Disposition: inline
In-Reply-To: <ag8b7oq4SFpdmlP_@J2N7QTR9R3>
X-Cookie: No shirt, no shoes, no service.


--XnCLFiWrG4EBMfBq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 21, 2026 at 03:51:26PM +0100, Mark Rutland wrote:

> While this specific instance is simple enough, I don't think we should
> continue to duplicate the low level save/restore routines between the
> main kernel and KVM hyp code.

> I've sent a series that avoids the need for this, and cleans up some
> other bits):

>   https://lore.kernel.org/linux-arm-kernel/20260521132556.584676-1-mark.rutland@arm.com/

> Assuming Marc and Oliver are on board, I'd prefer that we do that
> cleanup first, and build the KVM SME support atop.

Yeah, I've got a laundry list of things that I want to improve with both
the main kernel and KVM but the latency on getting anything reviewed
with both sides and sometimes obscure implementation decisions means
I've been waiting until this is landed first.

--XnCLFiWrG4EBMfBq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoPIfIACgkQJNaLcl1U
h9CJpwf+PVTKcbGobSIt2V1nPmtForFYSfILfE++Ovngx/OIzlSmVFC52be0sVWq
kOnhNIA8nT6/F4EXTWuc1tbEkCuxa2iPJ7VTwNvtKU35QL7roJNU4Cap+A3yHPkL
0C/+LQIXheQka+i6fCoqMXIWTz625keaedSH5XBMS2ktxjK+Oyka5XiUJqPmyVeQ
YSbd87c6rzpbn+C7p4RPZX+FwVm05w/yUoAloztHmd5GqsAr8NgEJoe8uOFd4Fe4
hoGcpIgfvhM/oqMQAXtLvCEmyPSKuDc70RM7Y3KDnvyiWQfnXh/ftNYqspba9Oic
Ii8HVtxvR6JE450ekIq13Rx4A9d0Ug==
=JOnr
-----END PGP SIGNATURE-----

--XnCLFiWrG4EBMfBq--
