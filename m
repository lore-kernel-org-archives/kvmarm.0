Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ABC29405;
	Sat, 18 Jul 2026 00:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784334929; cv=none; b=LShBIUHDWCEvZWJygo7NklhJPiWA9F6+MbjW75usRdI1KUZbo8zAeuJBSplPpSaws6jiT/1RzWqWpKhmu95r9cZSwPA45LJlOnLY80Tp6iEaqkcu2VNs4JerCY4rErEi1SmcoBrhKSzaGd3eD0sRTxvLBSRAdq1uu/x1kSUC8A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784334929; c=relaxed/simple;
	bh=9WCZr/0a6+6yd4+H2iJZREJPaBMBp4S3/hNJ5RCJPrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UqFoZkof+81zWdqP5YR9PVelDv+hXqe7QcqxHLYD1TW9cpniHr+OsbpHT/XSeBJSdduHpeuBMUnCFeqFY/B4bjML7nvDjL6W3/pV0LTxJ+XxTDLRvl7tyRxbB0HIQval1Hn9ftkiSbWkCN+PhPDagVkXMBjhzfDhDFdWkskkV40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UZMqhG7j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UZMqhG7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4571F000E9;
	Sat, 18 Jul 2026 00:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784334927;
	bh=83/QFKPUAecuur3XiUDSCrCipZXjd2KIGyHaxlFSSCE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UZMqhG7jOCM0NcG8H7yxHekee//rMmL/U7Ry2BrLImm6unJIexmYIklkgmaYx2kJc
	 w0QAzde1FMPP7tZgjagzsxmyGTzvWe+VetYaC6HyrUjg4v+PbZo1VN7Q8KWkcEo19T
	 3EX+dn0yks9KVfhECXAzeEyN/luAsqwLZ2nH/c1kLeZxzu2Q27VxKzyUlYgTME67FT
	 eIIkaE72/6x6u+8QvFPawI8tcNgDH3IBoD5VJYpu4gG8qoCTUHjV7m/6qrkXWvRkea
	 vjYcsAWsbreVTHJrKt36aQ67Ts+zrieyLSdwkax7w8Vcuwbb7uH6ZPG5/tRr5i6KHP
	 YHwLOVzyyTdgg==
Date: Sat, 18 Jul 2026 01:35:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Ben Horgan <ben.horgan@arm.com>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v12 02/29] arm64/fpsimd: Update FA64 and ZT0 enables when
 loading SME state
Message-ID: <3c76650f-ddda-47ae-a676-86016d8e39a6@sirena.org.uk>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
 <20260709-kvm-arm64-sme-v12-2-d0301d79ef58@kernel.org>
 <ali39DG6qie7XTuD@J2N7QTR9R3.cambridge.arm.com>
 <15a9ae14-395d-472a-a5be-9e46524fb493@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="B1L8qt03Fu74vlzF"
Content-Disposition: inline
In-Reply-To: <15a9ae14-395d-472a-a5be-9e46524fb493@sirena.org.uk>
X-Cookie: Thufir's a Harkonnen now.


--B1L8qt03Fu74vlzF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 16, 2026 at 04:28:02PM +0100, Mark Brown wrote:
> On Thu, Jul 16, 2026 at 11:52:36AM +0100, Mark Rutland wrote:

> > >  		if (test_thread_flag(TIF_SME)) {
> > > -			unsigned long vq = sve_vq_from_vl(sme_vl);
> > > -			sysreg_clear_set_s(SYS_SMCR_EL1, SMCR_ELx_LEN, vq - 1);
> > > +			sysreg_cond_update_s(SYS_SMCR_EL1, task_smcr(current));
> > > +			isb();
> > >  		}

> > What's the ISB for? That mysteriously appeared in v11 without
> > explanation. It wasn't in the original code, prior versions of the
> > series, or my suggested rework with the task_smcr() helper.

> > I don't believe it's necessary to add an ISB here.

> I can't remember or figure it out, I'll delete.

Actually I remembered: while SCMR_EL1.LEN is self synchronising the
"without the need for explict synchronization" wording is not present
for SMCR_EL1.{FA64,EZT0} and this is no longer explicitly just an update
of LEN.  It's possible I'm being overly paranoid here, I'll leave the
isb() and add a comment for the next version.

--B1L8qt03Fu74vlzF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpaykgACgkQJNaLcl1U
h9DjvAf+Mo2V+vK8ka9ifnzNbT6e4l1B8v1nwzBzZqNOsHRBkYVA+3HzxPfa42iQ
wBsUd5GDNYhvYnfigzrrCBiqP6iEXL2auvhxC05ZD/FMYpMpjg6l8a5YbyFZrCaI
VCnHsZDwaYx0qDsmnOUgwi/AvliSoRdtky5XTuT5aJLAPePiiXhE3f3ltNCQqynG
VzaW9xKH0Tng2mJ8kiajrNPlzKMChuJdcebmYosYMMiYFLiHjnE2FDyBqAf7A0It
jjU1d99NHubQeKLYc+3Io4KDKVRAafjVK2BfVWpOhGPufaC/a+HxGr2ZkU250Q1q
8YjIq/ZvP2kx3EodKw5prhfkTiaubw==
=Oojd
-----END PGP SIGNATURE-----

--B1L8qt03Fu74vlzF--
