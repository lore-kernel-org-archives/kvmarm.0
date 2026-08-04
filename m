Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E6A3E1D1D;
	Tue,  4 Aug 2026 18:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785868591; cv=none; b=WN9STDxMq6g1h2BUPrUMBkt/4vs0kWMAf20aZjsdlFawzUJNENzHubRkTyYxP6D0lVQxK+b2lcaz56xCwwd/77wxCj/Zr5APLzGfOB6nck78yQL2KHF7Tdo0291RSS5O1NSH8aa5rqJ58UFK5xgrsFCf3FjzbCFZJIHSoptYGRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785868591; c=relaxed/simple;
	bh=09lqXXi05Z+FNmCxbsJgced0foZ7LaZlPoZ9Pk+u5QU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M+zPRzr9wYXo4nqp+Htne1rj2V1UABISHjTbmmOY/ko+MToI6S41ybM/WgpjXQlngsyG1SDvy85GNhTauZbjLRekTsTJd71Dpb9s3pdTqZYNInrib9qlutGTJieErlEviNArzAdbhMfkfUYKO6lI1JXMGOiMyK9N3s2S80XLx9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FNFv/4xn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FNFv/4xn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB851F000E9;
	Tue,  4 Aug 2026 18:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785868590;
	bh=MsrewjxSSyqLQoF56zKc/HGwK9yvsx9HfDzcpzwEwNc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FNFv/4xn8rB3nhf7/Yzu0odlf/hsPD5HdeGDFTmzOG79lWWtydtYupWrQiraoPdpE
	 vVhOImYogC2W/V0osZXZQ1ee9d43vmPt50rCjU3JcjgYX+Vke9GfxaXl7qxvhXe8vv
	 yf9rFRo0gDEnpKw1k+WBFPLStpZYvVlrU9xhrMOfEpDAI4vZewidxdXa1su4CqHdXq
	 hHCt29rOTcpQVyfVESyQF71DQpudRgBelt92/Sxm5dvKoO08QnMKM7AbT/ZqrONWMs
	 bSoyLmu4qN9m6gQhxIrs/U90kuppnpoAQGQ0dDfm9f5gR+EcgBwEJToXR0N9WnHnmu
	 ibWUQVjrnOt6w==
Date: Tue, 4 Aug 2026 19:36:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: selftests: Check ID regs are immutable after
 a failed run
Message-ID: <537b173e-56d5-4e14-a7dc-18cc8884de8e@sirena.org.uk>
References: <20260804092421.1728880-1-fuad.tabba@linux.dev>
 <7e660a4c-af62-4751-a8cf-49151054f0df@sirena.org.uk>
 <CA+EHjTx9iLrnnaEVzV=3B+22bhh0DsPZRrBPvB6ZUT_CV5DvWA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/eGGtsQu6VHOQjKh"
Content-Disposition: inline
In-Reply-To: <CA+EHjTx9iLrnnaEVzV=3B+22bhh0DsPZRrBPvB6ZUT_CV5DvWA@mail.gmail.com>
X-Cookie: Biz is better.


--/eGGtsQu6VHOQjKh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 04, 2026 at 07:30:44PM +0100, Fuad Tabba wrote:
> On Tue, 4 Aug 2026 at 19:14, Mark Brown <broonie@kernel.org> wrote:

> > > +     TEST_ASSERT(r < 0 && errno == EBUSY,
> > > +                 "ID reg write after failed first run: r=%d errno=%d",
> > > +                 r, errno);
> > > +     TEST_ASSERT_EQ(vcpu_get_reg(vcpu, reg), val);

> > > +     kvm_vm_free(vm);
> > > +     ksft_test_result_pass("%s\n", __func__);

> > Mixing TEST_ASSERT() and ksft_test_result_ in the same test program also
> > interacts really poorly with automation, TEST_ASSERT() just kills the

> Agreed, but it looks file-wide rather than specific to this test, so I
> would rather leave it to your series than convert one function. Happy
> to follow once that lands.

Unfortunately at the minute it's not even consistent within the program -
the MPAM tests in there do use ksft_ based reporting, while they do so
with inconsistent strings you at least get all the results out if it's
just them that blow up.

--/eGGtsQu6VHOQjKh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpyMScACgkQJNaLcl1U
h9AAbgf/W+3LTMl/N5/eGuB3SteA/AMMoqc9R14TDJVBLdsyQ54rto/8rO1S6R2K
6z5XXdzQEyAUun4VTtWRdVNC4EBGCgFmx6iL0NIA7Mq/Hgg9Y5Kg4O9J+AZhUa7s
QkyroJpscInKTT2Z6AwulpLV1DGOuoaNsWykIUzLjTT3Fy1rzBh9gGSc4SkGOXjL
iZndvJCwijyJr0Co+C/6kXSffdmtoLXShJ0GQJTjgjDzlNo/Ofp9sQyY55n3+fxW
18Onf1DAZXOpaa+XZ+SxVFPasuCDoutSoPJgVPygau5lbWJkU2bLzX24FT5QHKK0
tkolz+CDfa4jgTcf0U5aMUw5ihJTfg==
=oRTP
-----END PGP SIGNATURE-----

--/eGGtsQu6VHOQjKh--
