Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470452BEC4E
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 13:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775050419; cv=none; b=gld6fVmYGC8Eq1p3lGoZD1o/g7bcYo89LbJCeGi9Jxm69jyz64O/ZNWUT/WR0Tmtt85kcaZByVFSRhlQRaW20jmwOhcN5w5DffRNgX0Ipk3T5AfSslTb0xPOzqUhnMfD3d4ce4CsWKQVvJAqE6ulj9mUawgvdRgprz1OHPq/QTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775050419; c=relaxed/simple;
	bh=u2gA5z/ZbfkLAE1DgTTuoq+UeEly+WXscysmUm3Qsq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EONDPjGfpaniD2pte1q0Rq2PnFF32i8tQYmkMAOkhg+MudoFGWcwv1p/sOU0rXSSIwNARPejhDUwuJfC3dZNEkfcnN1TFBoCSEcEb47qWrh6CebzYA5M+miicTUW/neDR3OWr6bYdqKDhhdlC2DEP+YZj/PSZQ8Q6diFbOTbs20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RrjOLnO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RrjOLnO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B6FC4CEF7;
	Wed,  1 Apr 2026 13:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775050419;
	bh=u2gA5z/ZbfkLAE1DgTTuoq+UeEly+WXscysmUm3Qsq4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RrjOLnO3Ng86Zf3a7hqAtZQ38GjlF3Sqjp0X7l8Z0E7s2q5xleRk0UqrElA3+Yu2b
	 XgTOJY6NkNd3xLnOJrYdVz/IXGsps3BcK5CYPGtt7BGnXZA7PZ1zv9ck6R3H/D71KO
	 DGU7KA3lD6tc3wKOVJ0oHyVnui/qZqTBZlBoI+iyG7WpUI+ERM+UaiCO+bjhT1bZev
	 uAs03WJbSnCuAiGQqOre3t2g3aXilLCs2HLdvxmV/lCQXIHsjek51AbZaHEviEZK1i
	 CJvvNXA8mTb1QO00KWzQLf4xpZ41nO/Px51g2AIADI/uyGi575/zntZAvSV/1lG+KA
	 ofceWRRlmbsfQ==
Date: Wed, 1 Apr 2026 14:33:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Fix teardown of non-protected VMs with
 pKVM
Message-ID: <b7c54873-b53e-4737-a2f1-29e6b0f2f674@sirena.org.uk>
References: <20260331155056.28220-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VKjDXFZzISaRr2EE"
Content-Disposition: inline
In-Reply-To: <20260331155056.28220-1-will@kernel.org>
X-Cookie: Sentient plasmoids are a gas.


--VKjDXFZzISaRr2EE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 31, 2026 at 04:50:52PM +0100, Will Deacon wrote:

> This time, it spotted that my fix (introduced in v5 [1] of the pKVM
> series) to prevent taking a reference on a VM in the 'is_dying' state
> also prevents unsharing of pages shared with a non-protected VM if that
> VM is torn down by its VM fd being destroyed, rather than the usual path
> via the MMU notifiers.

> Rather than send a v6 of the whole series, here are three patches that
> apply on top of v5 and fix the issue by (a) preventing teardown of a
> referenced VM and (b) allowing some references to be taken on a dying
> VM. As an added bonus, this simplifies the locking on the reclaim path
> because now a VM reference is enough to stop the page-tables from going
> away.

This series fixes the warnings I reported with pKVM on N1DSP yesterday:

Tested-by: Mark Brown <broonie@kernel.org>

--VKjDXFZzISaRr2EE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnNHqwACgkQJNaLcl1U
h9CwMgf/fs8y9kNrlWFlAgNkzhfQnswRnqeKgN/WBQoa+ICQlo10qCf/fIXAIYuj
eiEfPzbOlhE8b1jpwyGPMaeNT0R3VME5RqHjTH0iMxkZNMcchbsV075VfPjeFIhS
Mha9t6CdJ2wfydRzUAjuHHGDsCSrMBDVs07sTpJw8CIz6znZFX/YfbxKs0meuRGj
F/RLlgyTtz4IdnIwk82pCiYz/uQm+boFHvkKe+/koKsewy6gTs+/sV2ik9tNGVlP
WTDpGktEbaIu7mchxtkv+rylgszxwR6piyba9qWE8SfppLvaspKXOb5RUDH/cq//
QFKMBIqswWyAZoTTfJ1neby0ZPm5Rg==
=/3Az
-----END PGP SIGNATURE-----

--VKjDXFZzISaRr2EE--
