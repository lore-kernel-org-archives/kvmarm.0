Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2F23290C7;
	Wed,  5 Aug 2026 12:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785933153; cv=none; b=eONoBryyuAM1v5pI+LvPBnay3oY3RA7IeYqmBoHH3SgCeEKUkhvcdinmkmgCbYBpeMbCg0Fq45XEMNwODKI+bPzPGWX2bfKYEC5f/+eokNSgp89AC6maPpqDip+Qve4ugxVkULVpLa0oP7uupBCPv1pb9+SOpNpdgOQ2rcTjR2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785933153; c=relaxed/simple;
	bh=JLXEjiXJ5ead+A0UJEu6Kwd7Ra0vmx7BZcWBU8qsVfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RfsNNQJX0rjFBWJVEVYwbg0csQNa3twz4LUw1TgPgjwTy2yC1zrYKSc/2wIa8whMDcpC+oqwNiDzZ4mtKTB9v9wlyBISilhhQVsZUeIgTmpO0U9j0O5AnhB1gQK52hOl+86nXoPqi99GNRe5kicdgP+L8p3f+vOLC3ZTpiMvF9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kgarzZbc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kgarzZbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7563A1F000E9;
	Wed,  5 Aug 2026 12:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785933152;
	bh=5LSfaQsJnWTgUDlHUu9ZzXQ3/4tSCBUVOkdmaV5v2+4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kgarzZbcePG1xY1ektXE5fX/hI8viRoMoas3xXwM3dzop8NJE/Ox2uoR4T7k8JHmK
	 m4CUq5FDrCQbUh1Ae8x5roBl4qQX2apjTVHzkDh7FmAwCG1vMo3WRkPakqVOJmQUux
	 bE9TTgXH5dUMPg/+hlfsGYiwFyKm9ZSftz2LUs57TKqiwQozfuCl0DJB3sxe8rsjrF
	 phb7RyXHPE9zUuVm8LC2imncAm9Fp/BWU+gMTFWPte+9o9qzThQ8GEtlZIordwnqTo
	 pLokldhx5f/+pkjUP5N54JMUkKc7+BjQfMpPvkQW9TH0OBn5cpLQtKkPdlozP24H+G
	 9m9y98fuINt7Q==
Date: Wed, 5 Aug 2026 13:32:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Yao Yuan <yaoyuan@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v18 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Message-ID: <6d63905e-8c6e-4c88-b60b-d34ab1401783@sirena.org.uk>
References: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
 <20260803-arm64-gcs-v18-3-fd8c40f5ad88@kernel.org>
 <enhoyivbkdaacgyazubgfzftt34xjemtrybvgpuqvr4czjtbhm@7qvrce5lmdyw>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="G0bWhbbolYLdYDz9"
Content-Disposition: inline
In-Reply-To: <enhoyivbkdaacgyazubgfzftt34xjemtrybvgpuqvr4czjtbhm@7qvrce5lmdyw>
X-Cookie: Stop ahead.


--G0bWhbbolYLdYDz9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 05, 2026 at 05:48:04PM +0800, Yao Yuan wrote:
> On Mon, Aug 03, 2026 at 11:56:48PM +0800, Mark Brown wrote:

> >
> >  		if (ctxt_has_s1poe(&vcpu->arch.ctxt))
> >  			write_sysreg_el1(__vcpu_sys_reg(vcpu, POR_EL2), SYS_POR);
> > +
> > +		if (ctxt_has_gcs(&vcpu->arch.ctxt)) {
> > +			write_sysreg_el1(__vcpu_sys_reg(vcpu, GCSCR_EL2), SYS_GCSCR);
> > +			write_sysreg_el1(__vcpu_sys_reg(vcpu, GCSPR_EL2), SYS_GCSPR);
> > +		}

> Looks the s1pie checking for GCS vEL2 context switch is
> necessary yet IIUC, KVM does vEL2 context switch for nested
> L1's EL2, it should follow same rule as non-nested L1's EL1
> context switch.

Right, it's not really needed in either case but hopefully helps code
generation a bit.  Thanks for spotting that.

Please delete unneeded context from mails when replying.  Doing this
makes it much easier to find your reply in the message, helping ensure
it won't be missed by people scrolling through the irrelevant quoted
material.

--G0bWhbbolYLdYDz9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpzLVoACgkQJNaLcl1U
h9AShQf9GTcWUv5esdda/vVYebPT3BbxWQXttB8maWVlWNrtRAZ3CcuUZK1lNv3Q
M/gte5u9UOApkJA4FxQKLJKXrvlkl9eWlXAmhwPtMgd2JwfMt716GCJTqYO6AUe8
U1Zt5uL70KfvRw52jOA7fIwKLHh6qP072nyrPg0KKTMh16zBuSsr39cNDqu6/e2U
N/Uo4Zrb3Qqcl+tlYkZuPdCReFrJmJUuM0tOq7wOPpQjB7ySzou1akvTvBWNPlJm
Hyn4x0+bcF+fOAe+xkq+avmuS5AOix3cuAxcxeAOr0ZQWf+rR+1V6OOWqHx87gSS
NEhHYl2r6NQ/B5yMZuzvDYScdhY5zw==
=Ce0W
-----END PGP SIGNATURE-----

--G0bWhbbolYLdYDz9--
