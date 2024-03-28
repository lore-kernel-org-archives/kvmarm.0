Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0655A4CF
	for <kvmarm@lists.linux.dev>; Thu, 28 Mar 2024 19:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711653437; cv=none; b=tTBPYWV5ffCaeudsJLAQtUxdUy3wZSL8A1oYOM7LJ/hBWUv3eaMbj+E4FHxbbVtpnL4KwNdI+qJ6U/RJDFvVh89l2EqZy7z1xkekIezf58OhctPq28WRLCKcl3XExuwlhN4efEz9MIMg/nU0bAbAY5LdzeXPW9rbaHl6jFl94Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711653437; c=relaxed/simple;
	bh=qwhoKpBGT/nRMfyHufu+tawF4vzH8/S98ebyCX9BueM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nuy31Gg6PVRRddgLQHggrRq+j+AEwjTqbrva8zMKL9/2KJZAm1Okv2XBetfthBiePI3dXm7y0VO2D5a/kFtJTZioYe6LETIE361rCzaS4ItH2Ey+afWpVeTava1JU8Brdrhf3zi5muN18c6ByphrZjq6ptZTmIch3y6PZQv2JLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ke9sZ4nn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ke9sZ4nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D865AC433C7;
	Thu, 28 Mar 2024 19:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711653437;
	bh=qwhoKpBGT/nRMfyHufu+tawF4vzH8/S98ebyCX9BueM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ke9sZ4nnOU/MaRM5iZU/ALr1PwxlJ6VBFQCLod3oPOLXUhMhsFrnO7m076r34lMYg
	 gEeAVUouQtyAjRcOb+qsD3Kj+lkFMAdzKL4xuugYUxk+jpKmc/dBzhxFkVfZms4Bi1
	 LcAl9qRbocssS63dE5nIExBwarjlUw7tUnXbBlStA+JuwKHzfveT+7zDFYUeCVp7lE
	 Fo9lqW64ZgkB2/4U3da+W3zxHY30nUOnoeniEk5x7BdRXzRKZukD2jZzaEzD4nAAiW
	 mE8DqFyeioAWdUkcS1iJAuzrz33E25sC5+1RbQS5KgKiobWVxA9LJLL1LgZknxtrMN
	 SowbJj4GVf5zA==
Date: Thu, 28 Mar 2024 19:17:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com
Subject: Re: [PATCH v1 15/44] KVM: arm64: Use active guest SVE vector length
 on guest restore
Message-ID: <0cf02eac-318f-4507-8ca7-510dbb1ca98d@sirena.org.uk>
References: <20240327173531.1379685-1-tabba@google.com>
 <20240327173531.1379685-16-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cWMQ/kF5ByCw8RWa"
Content-Disposition: inline
In-Reply-To: <20240327173531.1379685-16-tabba@google.com>
X-Cookie: Yes, but which self do you want to be?


--cWMQ/kF5ByCw8RWa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 27, 2024 at 05:35:02PM +0000, Fuad Tabba wrote:
> On restoring guest SVE state, use the guest's current active
> vector length. This reduces the amount of restoring for the cases

For this to work don't we also need to also save the state with the
currently operational guest VL, all the saves and loads are done with VL
dependent operations?  It has crossed my mind to save and load the guest
state with the currently active guest VL since that's probably a little
quicker but we don't appear to be doing that.

> where the maximum size isn't used. Moreover, it fixes a bug where
> the ZCR_EL2 value wasn't being set when restoring the guest
> state, potentially corrupting it.

>  static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
>  {
> -	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);

What was the bug with ZCR_EL2 not being set - I'm not clear how this
could be skipped?

> +	u64 zcr_el1 = __vcpu_sys_reg(vcpu, ZCR_EL1);
> +	u64 zcr_el2 = min(zcr_el1, vcpu_sve_max_vq(vcpu) - 1ULL);

This works currently since all the bits other than LEN are either RES0
or RAZ but will break if anything new is added, explicit extraction of
LEN is probably safer though slight overhead.

--cWMQ/kF5ByCw8RWa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmYFwjYACgkQJNaLcl1U
h9DMiwf8Dg+OTb5KbGD31hkRlTZ+qsYe/8gAuPMN+e7sxEPND1aTwSrSeEq8p1NC
yK4E2DDvw66eEkpZ9bbOr0cZ+kvGkejcXH2mKgNanfVoyk14YP6gDkUAOptGRDft
43QDEcjJwMBlfXge7+DouKc3oJZTx7ZGwE/CQSkGAOSiNtJljQdXTHbDYN9vlYce
q42QOum5nLIs+1H7VfM0Ep7RQPFww6XGC0xb7esPV/9vBwu3pRggyWWSym545cY+
pjpbQCqUgAp0URyHcV/YjW7SgkfN5vMRzc2XUi0po5UXMcFYjr5naXi5cX4UCRcZ
k+aurqcHa1q/DptSWbk9DcK8q48JEQ==
=2dOz
-----END PGP SIGNATURE-----

--cWMQ/kF5ByCw8RWa--
