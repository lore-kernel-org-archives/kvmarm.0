Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8501DFF7;
	Tue, 24 Mar 2026 14:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774364044; cv=none; b=i39ayYo5KGOegXy59kLHS76t2Sr2yt2ihxMQ/LZBBqb67uCaOyUqjQZEjl9NG/NimPPL8+xj26okU8jOwIPWCD8hbfgEPJZfZXOnfbSzYAG0V/bAHXQ9dKAKr0scVBvFCX+ahQ2QNjqScCV4dAGgMcVtP8eANXQFpbli73lCRqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774364044; c=relaxed/simple;
	bh=+H1RQt9nEFm1mW3pj/3FppU+zA1eZ4F6q95FB9cWR8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S5nhKVa/ZyJvEjhYUc2wH66Q2zf03TKZlO2JlcAPc2HmhT/7X78jz/O7gaV/mhZ43pbt5JEtIDen8DIrGTFg05YwLltfElIq2rSbg8gFM/ddjqY2A8VgT35eebEMJSRfz5YSYPVNTgGeLZXFeMoeG7d/Z+nKNWsHip2mNrhVo7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BkfiHLJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BkfiHLJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4C6C19424;
	Tue, 24 Mar 2026 14:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774364044;
	bh=+H1RQt9nEFm1mW3pj/3FppU+zA1eZ4F6q95FB9cWR8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BkfiHLJM5s81UYxIuCAfaj1IksuK9rnIWP+LpacEP5uJVh/LQcoMMg4k7V64C46GZ
	 e1+7qX//DfTBR0TFWWC9mOorVx5VQw2OEhefk4mVdz9696oTL+g2WtqTy4dRO3ePvq
	 HBJAG83ZpjtWReeqtxy6LUX4scRHqpUmvIisjHVyCmnaDGcjVC5dkwZha1wMGvqZCH
	 FRdpRZKQfkXHtQAK54NIoaZv56uify9FuBiTwWEluViSRMEZjGVlYZ79H7NnappQsr
	 UuOBGM4yhYUbpxFvi4f0+Zlm/Rt3GIJ+F+drFxjglJfc1LSQyiRNe8FOWIiW08ncX/
	 6VPCHLIAyRTQQ==
Date: Tue, 24 Mar 2026 14:53:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Sascha Bischoff <Sascha.Bischoff@arm.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
Subject: Re: [PATCH v7 12/41] KVM: arm64: gic-v5: Sanitize
 ID_AA64PFR2_EL1.GCIE
Message-ID: <ebd9ebb4-06ac-41a1-af16-664a4eedf3fd@sirena.org.uk>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
 <20260319154937.3619520-13-sascha.bischoff@arm.com>
 <638a3453-91c9-4a76-8241-25d5c27ca518@sirena.org.uk>
 <86se9p472z.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sWsDtecpd5ZuVCN+"
Content-Disposition: inline
In-Reply-To: <86se9p472z.wl-maz@kernel.org>
X-Cookie: Forest fires cause Smokey Bears.


--sWsDtecpd5ZuVCN+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 24, 2026 at 02:48:04PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > We're also seeing an issue with this in the aarch32_id_regs test:

...

> > which for some reason only manifests on TX2 of the platforms I've
> > seen.

> Is your TX2 the only machine you have that is AArch64 only at all ELs?

Yes, that should be the case.

--sWsDtecpd5ZuVCN+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnCpYUACgkQJNaLcl1U
h9Bm3Af/QFizHYbTB/ryz4KjPxz66HDJQLTRF4ZCv9unqS36DteUBrzH+P1u9Dvs
RER8M4hbwORq3ev4XgGsh3NhIsgs0aeENgRBkp++ZbluNEFIYRfyINyR9KeAi7ZW
HNqFEbnEdVJsaWin8pO+TjA0e5mmHxqiI8fvDYw48BT6y8Y+cmAmeNTmM1tIKSCy
c8L1YsatMZ9z0X/VZTLuUHTHAvkc0NrH0WnjrnThxcJ2SIb9EDtYATHYTsxYnfs5
1y18PWomKuZT4BTUwJs4PEfvVfj4iwEjHol/VjXaiwkE6OyhgiSVmHa/22aZZ8EU
CXwCEHYHNuWRI1Zm3xWCAdNv/SOrlg==
=Nq5T
-----END PGP SIGNATURE-----

--sWsDtecpd5ZuVCN+--
