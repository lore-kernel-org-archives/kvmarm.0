Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2FF386452;
	Tue, 24 Mar 2026 14:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774364192; cv=none; b=Ee/wOWV2ODYpGBDgg6xzhNEAO7g8Tku9tiHK9eRneP3PDpR7GWO26qHQWqDDRdUq5IglvlBlpjwGzVFg5+u5+DSzZ3CTHqGeYEQYaYpDNQAy4tDBtvEdZSuI9kkkxfkUL/OUG7plxqLBazt1dc0Mi0P22dOTEYFQSjHDU0ekp/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774364192; c=relaxed/simple;
	bh=jqt0+iHaBhTs+/uQV5esdkb26UOg4Aqfep49wdige64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q2mhizx+JzhcHnp6i4XYy0sjAaoBNVt+ZqGp4PlWeJ+iv25XJgtmWUwp0+11F8r3gjoPuDHwKDbCyFRYbVfUX4EIgK0bnfRjHFw3FonTZRy3ou+sMSrpHVT6Iop9opGM58T6mkpdDx4pFtK4POl7JD7haij0oLcdbjvI/MphOi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GsBC513e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GsBC513e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F802C19424;
	Tue, 24 Mar 2026 14:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774364191;
	bh=jqt0+iHaBhTs+/uQV5esdkb26UOg4Aqfep49wdige64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GsBC513eseXrSA62sIrshbevbDZFymxnJwjEp48xC2wtdLTdDdQfOxM5qyBabEM9y
	 LSQ1b6xsz8xlI598EflNB3MoLQ4q/dEsvQiAO6IAfA77n/2sI00osF+ngoljUZP3lj
	 SpFGOxr9NhZIt+6PvrRKJu45JaHmnEUSi1rc1Vsf0rGCs/R4kaZT+qAt9aNsN9vr86
	 kOWC3HMzvW04Vgoy8qp5blwbmRdVI4Ngf1k1F6BfBjuKWx8WI9f7tWGBGeHhWW4QsI
	 rnHOwHROJrfIm7LR3T77dVT6+25zZfjM5gRFYwS9E9mpdrIErkuzjNab98SVxVApMd
	 la8aqMbUp1L4Q==
Date: Tue, 24 Mar 2026 14:56:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Ben Horgan <ben.horgan@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v10 28/30] KVM: arm64: selftests: Skip impossible invalid
 value tests
Message-ID: <546c1fc9-995f-45e9-b330-e7a911fe8d16@sirena.org.uk>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-28-43f7683a0fb7@kernel.org>
 <0f8d0966-4e05-4d5a-a523-098b3dbcf7d9@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1ZNS4L2H5GKx15fP"
Content-Disposition: inline
In-Reply-To: <0f8d0966-4e05-4d5a-a523-098b3dbcf7d9@arm.com>
X-Cookie: Forest fires cause Smokey Bears.


--1ZNS4L2H5GKx15fP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 24, 2026 at 02:54:54PM +0000, Ben Horgan wrote:
> On 3/6/26 17:01, Mark Brown wrote:

> > +		default:
> > +			*skip = true;
> > +			break;
> > +		}
> >  	}

> I hacked up a quick loop to check what this function is doing.
> With a mask=0x1 I see some value returned that have bits set
> outside of the mask.

Thanks, do you happen to still have that to hand?

--1ZNS4L2H5GKx15fP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnCphcACgkQJNaLcl1U
h9BLbAf/ebAp06o9rTWWi16HumPClxLSFzlzTKPTm2R2MXa5wHA3m3E1Cit9UBKt
NI/cqi4+wgO7D11xFAnfhiD8f1ikM91fzsP2wx2DTyhbutXQsooqJt7jWPYDj5Ph
UDCeY7IZUIJSkskkeTnrjBTovL5mCGpeMZ70OuenynhBJ8sXdjYy56z36pNgDHb5
0lqAx9ZIUZ8MHRQ7fpGvxSoB1o2EEGvoVVwBgOHcXpYRgrAB4klD9Y0tPBsDsYzj
L8dAqlMBSt6i6b+q6eZz0aqmKhfzqQsPYPWATGBoGSun70R22KNU7XPCYtaR8IJs
Q2Wj1aP1+2dhbfpO0oot5eG9ERiR/g==
=guob
-----END PGP SIGNATURE-----

--1ZNS4L2H5GKx15fP--
