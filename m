Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1676298CAF;
	Wed,  9 Sep 2026 16:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788972359; cv=none; b=Jwo1IROi1Nx6XEWA1pHn/MlscEDherUcg2iAO3fCKE5ubEooJHRVDLPMTK3msPH/TUqddSeMWozxO5cbaHJBh3/WS/C31uXcZi2EHfw9kv9RwZPUPNQKJKR0dgJEvfJ/wzpsSk8Rcmg+tB9mwPTLNfeBvMiWpggskCs1Ypy3izQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788972359; c=relaxed/simple;
	bh=pSd1camp7ry6f4jDInasPV7YNdDyWfvxFVh5yuKw47M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ph2preEpkM+U3mImKpxrmoqjhRwZq9oiTM5xgVVBuxOXBKDdGdk36k5DmTk27WqMAvPkFvs/MGGBRPamukgjkvj+DgAHWfv5XTjWtpxsk/2OFC/M6BBwLyLku4Qci+tuRH6cyKOWE77kXvQTb73bflgzEeynIHUi2st9NPGMTCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YqbKRDFx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YqbKRDFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EC31F000FF;
	Wed,  9 Sep 2026 16:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788972358;
	bh=gjKBR3MpL444SDh1d20QHzHS4p8TebdwJWQeVAcffMU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YqbKRDFx/vlGF2DLhdIeQ9LyJ1hbaJn6LbHAM4ygVNgKiqSpbEU9S8pG7sZA83IrV
	 bMs3jyHDvVcnttPJ9y+39FGNXmXxYvp6RX38IilzfMHfJVw9uPzmoBIoaQ0bNzrAjf
	 9bbjC5Wi/SHyd9UiqA1o+1361YLZ5k+CRU/XTkMwjjRmEFEGsofhDf88dnU45zLmlB
	 YAINiwI8oChr9ocnNJS/G2D5+VVQZ156IjKfe3phM4NkYzuuFNO2Lr8idVUTm8jm/0
	 4RoZLcA9tWyyq7PQUgx42ZppTIujEJplK/BTuAGWZMqyQn3V4SHqELQCwet+jZPdmS
	 M7voXfrS4cFxQ==
Date: Wed, 9 Sep 2026 17:45:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 09/14] KVM: arm64: Allow GCS to be enabled for guests
Message-ID: <a48e936b-29c9-410e-a0c7-84cd5143d3d5@sirena.org.uk>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-9-f31750bdfadb@kernel.org>
 <aqGKnQZOe6leuXgG@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+LzIUzHWTMa+rfMZ"
Content-Disposition: inline
In-Reply-To: <aqGKnQZOe6leuXgG@LeoBrasDK>
X-Cookie: Postage will be paid by addressee.


--+LzIUzHWTMa+rfMZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 09, 2026 at 05:34:37PM +0100, Leonardo Bras wrote:
> On Tue, Sep 01, 2026 at 10:47:07PM +0100, Mark Brown wrote:

> > @@ -2193,10 +2193,12 @@ static u64 sanitise_id_aa64pfr1_el1(const struc=
t kvm_vcpu *vcpu, u64 val)

> >  	val &=3D ~ID_AA64PFR1_EL1_THE;
> >  	val &=3D ~ID_AA64PFR1_EL1_MTEX;
> >  	val &=3D ~ID_AA64PFR1_EL1_PFAR;

> And here it says to only mask the feature bit if it's not available.

> IIUC this sanitize function is called when resetting a vcpu, is that righ=
t?

Yes.

> > @@ -3444,7 +3446,6 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> >  				     ~(ID_AA64PFR1_EL1_PFAR |
> >  				       ID_AA64PFR1_EL1_MTEX |
> >  				       ID_AA64PFR1_EL1_THE |
> > -				       ID_AA64PFR1_EL1_GCS |
> >  				       ID_AA64PFR1_EL1_MTE_frac |
> >  				       ID_AA64PFR1_EL1_NMI |
> >  				       ID_AA64PFR1_EL1_RNDR_trap |

> This one looks like to be a mask that's used to compare with=20
> arm64_ftr_regs[] on arm64_check_features(). That seems to be called on=20
> set_id_aa64pfr1_el1() which is used when we get an ioclt to set a system=
=20
> register.

> So, basically, does it use this mask to check if the set value is valid?

Yes, this excludes values that are never supported.

> Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!

--+LzIUzHWTMa+rfMZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqhjT8ACgkQJNaLcl1U
h9CUpwf/SYsgfeE57KbWPUv3ttaeYr8Wo7JqNTBEkLzMO4W3ZOuskAV8owdXthu3
F/044n75naZrTZ8F5SKfIDp4hJKY7KUMurSvOat9ilrZyki8RiTWMUHW9Wt6f43f
Ar7UZAUR6S/MsmNIIV2+j0SpW1WKr/iTabrqzsu1CCxi1zfWLZ8ume3WKrnxlGrJ
lsaPw66beA5spQnrQLAA7gRYJIj1aTeBfyEYI2Ziel/dlGuDIxthZ+1NjFeQK+Yw
o8cZRsDm4aGQoB9/ftauDgQiEbL3e5tGtgi5XnTT9xNx/QwTb6qr0LEs8EEKpqIX
TohH87q+3BMIZaMWJLYFeu1TFLFg5g==
=UHs5
-----END PGP SIGNATURE-----

--+LzIUzHWTMa+rfMZ--
