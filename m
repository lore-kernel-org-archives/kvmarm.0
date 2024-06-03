Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3333B82D8E
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 14:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717425793; cv=none; b=NNpC6t4RLlG8Pt0y+WzBpZJH1bwTq3/5sfyUL/sNUcdUlAOeNhZez0IR3dqMtgz1xxZBZv1f5+ZLQg4w/0ZiMEV7djGSeDT5x9i3b5EfQpZmyUFcilixjkJ+OEspUQ27nZpy1jH0Mgn3VKnqe3Rkyxp+aNg9r8h8yhE1mF7rVH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717425793; c=relaxed/simple;
	bh=6fnmNrZ0O7TQc4s0C4/XGVFsoyhddHQHHGM2msxtClw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hn831xoAhTMokIeHcUBAveyoivhYIqt8SiShIpmrgBxaREBsiPgTH8SK8sgWtyIW3zgBroZwmObrPRnwUWiElBA/nm/vBOnw9HfzrMpXBbxWTQqvIDIhY/yVkDUQSiGxKjpD8a+ZFpEbuyItxQb9TSbWAfuB4s31WKYUB42Lzq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qH05zUWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qH05zUWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD31EC32781;
	Mon,  3 Jun 2024 14:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717425793;
	bh=6fnmNrZ0O7TQc4s0C4/XGVFsoyhddHQHHGM2msxtClw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qH05zUWdhWAlcTmKHTw+/MVFtnRP2FpxSJhaj7zUKd6tgHDkQ+p6yb4/dSxe07orc
	 UOCGt6E9uw8ximhHKTk3dkfK/BLTRtlAhXxVMrDH7M8vnAXrs0+cqm+QOTF2b6+LlL
	 j4VJICrQj/SVBcSu89MOPicXKTunq0BguB2ENYdT0Fw69jhqQ1C+A6PTAjVcVe3PqC
	 uywsLCSDLpGilA12C9fzf1wtRLLwLv9w9T+bHxPJHzFcWcWen4ndjwneOD9GiqkNfM
	 1PETavhUZb6IaeOUe15T4fd6KKj+nR5/TPROfs4tmH83jfHrSdrJjN/FRn9MCpnLjf
	 TZ3IQ1nxQnPzg==
Date: Mon, 3 Jun 2024 15:43:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	mark.rutland@arm.com, joey.gouly@arm.com, rananta@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v4 9/9] KVM: arm64: Ensure that SME controls are disabled
 in protected mode
Message-ID: <a63872c3-2c6d-4b6a-8d41-70d4d8c9a24f@sirena.org.uk>
References: <20240603122852.3923848-1-tabba@google.com>
 <20240603122852.3923848-10-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3VCdSU+2UwO5YZzL"
Content-Disposition: inline
In-Reply-To: <20240603122852.3923848-10-tabba@google.com>
X-Cookie: Don't let your status become too quo!


--3VCdSU+2UwO5YZzL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 03, 2024 at 01:28:51PM +0100, Fuad Tabba wrote:

> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -90,6 +90,13 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>  			fpsimd_save_and_flush_cpu_state();
>  		}
>  	}
> +
> +	/*
> +	 * If normal guests gain SME support, maintain this behavior for pKVM
> +	 * guests, which don't support SME.
> +	 */
> +	WARN_ON(is_protected_kvm_enabled() && system_supports_sme() &&
> +		read_sysreg_s(SYS_SVCR));
>  }

The comment doesn't line up clearly with the check here, we're checking
if the hypervisor supports protected guests not if the current guest is
protected.  At this point we're dealing with the host state rather than
the guest state so the guest being protected or not doesn't matter when
we check SVCR.  I'm not sure this assert really makes sense, or perhaps
it should be hoisted into the above system_support_sme() section?

--3VCdSU+2UwO5YZzL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZd1nUACgkQJNaLcl1U
h9BMNwf/Yp2VXUS7F3cXvzyH/qyq1D5UpRG/7T0L+tjpwxnZhAqFFqvZqwibzg61
gLEEFgJYYdeCxrfQPqDOhkPL4BsccPHDBsuXqGVvDfBLtm/IppFkEY+YHiOR8rdJ
M7h/91581BmUx/k0NqQxDoxYMrajPYGvD5fn7VvTawYpfLjyPNDvQclc1dE7F66G
d0SuMa+DKqBHQyoVgwd6T4PRl4q+ehPeu85NmqScxnHPzrqMh9AoX3+wStj1I44m
CjHP/FMs/NJp3rIYClLrlizFnUkZGVAmCds84VT6ogTVOjwc5NyxpBxEnzARpNUo
8YzUn//Es9+jXAinhGrblwRwWv+5vA==
=/ImV
-----END PGP SIGNATURE-----

--3VCdSU+2UwO5YZzL--
