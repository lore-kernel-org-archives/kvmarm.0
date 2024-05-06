Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B0715359F;
	Mon,  6 May 2024 15:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715008510; cv=none; b=BeTor4kjNmR79nTCj1wfM1IS34qeA2egLD1cxh02iieAhZUGZq0qFhPJ98K5aV2mCxedDhtoEc3cFTiyB3XVuarmJ2iGJmglGmRl3Pv0rngtBYs8TvfGZg35gQhQPy8AVG2zgx0Wa39Zzxq9RaJ3e1iPg95Yuz/3GC4neN61FW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715008510; c=relaxed/simple;
	bh=V20s/rP9kfnfxqn8asOQLUse8pw4bK5bvZGq8XmE+YE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Js1mogdzLZILfz2H//oX1ZPOjX6uEKT6aTUB0EA4F/Z4dWzPQ2cgvsIkQooWKBsQ1u3SI1Tk0EipWvX8u6IwyxncNjlvThHAloFsBMwGcgj84K2f5vVU5WiScODJd5+tOVGKu535vZ8nxmcJHX46KWgDmib1oZcmlZ11EUAhr3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ufvq1GjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ufvq1GjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A3BC116B1;
	Mon,  6 May 2024 15:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715008509;
	bh=V20s/rP9kfnfxqn8asOQLUse8pw4bK5bvZGq8XmE+YE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ufvq1GjIm0JtpeREOOUMIhIxkcw/9k0sQTGIfqjN5iXg29RcGDLytn91LLxkXBFzy
	 iepohAi7JG77XjUBMSpVRbS/38XJwhteYmxHVy/TBX22ZhydD1CY5+JrXDCUKYww/M
	 57s4RqD+wKI2J4Iq/SxpfGSUuJHNOB6ITluWBYWPK7B+OhMpV/exZV5nQnDJfhwrB5
	 DJhxOmvw/SCV7rECgHYbof6u/6T2TphqPS5IQ+uihHvRbamhZs2tDlArmkKObto2bi
	 iFlo7U8lEnWMAFjfOecnzsZgFbTfRGrvxG3o1q+uiNCfv/fPusLAYQ3bLpS6phE6fO
	 BU6msL19Awk5w==
Date: Tue, 7 May 2024 00:15:06 +0900
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Liao Chang <liaochang1@huawei.com>, catalin.marinas@arm.com,
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	tglx@linutronix.de, ardb@kernel.org, anshuman.khandual@arm.com,
	miguel.luis@oracle.com, joey.gouly@arm.com, ryan.roberts@arm.com,
	jeremy.linton@arm.com, ericchancf@google.com,
	kristina.martsenko@arm.com, robh@kernel.org,
	scott@os.amperecomputing.com, songshuaishuai@tinylab.org,
	shijie@os.amperecomputing.com, akpm@linux-foundation.org,
	bhe@redhat.com, horms@kernel.org, mhiramat@kernel.org,
	rmk+kernel@armlinux.org.uk, shahuang@redhat.com,
	takakura@valinux.co.jp, dianders@chromium.org, swboyd@chromium.org,
	sumit.garg@linaro.org, frederic@kernel.org, reijiw@google.com,
	akihiko.odaki@daynix.com, ruanjinjie@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 1/8] arm64/sysreg: Add definitions for immediate
 versions of MSR ALLINT
Message-ID: <Zjjz-tzLRC2nH51A@finisterre.sirena.org.uk>
References: <20240415064758.3250209-1-liaochang1@huawei.com>
 <20240415064758.3250209-2-liaochang1@huawei.com>
 <ZjUKMWPknEhLYoK8@FVFF77S0Q05N>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AJCRMQbglmQeiqgZ"
Content-Disposition: inline
In-Reply-To: <ZjUKMWPknEhLYoK8@FVFF77S0Q05N>
X-Cookie: lisp, v.:


--AJCRMQbglmQeiqgZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 03, 2024 at 05:00:49PM +0100, Mark Rutland wrote:
> On Mon, Apr 15, 2024 at 06:47:51AM +0000, Liao Chang wrote:

> +#define PSTATE_ALLINT                  pstate_field(1, 0)

> +#define set_pstate_allint(x)           asm volatile(SET_PSTATE_ALLINT(x))

Hrm, those helpers are not ideally discoverable, partly due to the
system register description for ALLINT not providing any references to
this being a general scheme (which is fixable there) and partly due to
the use of __emit_inst() with a numeric literal - we should probably add
a comment next to the __emit_inst() saying what instruction we are
emitting.

--AJCRMQbglmQeiqgZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmY48/kACgkQJNaLcl1U
h9DFDgf9Fgw5UkzUrclx6ZUwslgWzoPOBx1IoBt1ouEpv32VHyFUSbHDNh0ajstZ
1tKqFwGNCSdXpfE09if2stHiiPfY8yxj9O2j+dibQVxKtxmS0RuoApWX/TzEv7Wy
1ERNBrIbdi3rDAZBRnLmnFw8pSwlDz+asThIgwBPmyW7HfPVZeuU+l7b/V24aTwg
4YGmRsYUG6f/oTl8DUmQwdAIwLfJrleBpli38lHUWAtnsPtv/d8SoyrG39CqoCIj
Cx9TXVNB9Vfd6H19q8DF9R3kqadtH5tINEcqLzea3Bh+ccikUa6wow0k5wEgRPVc
40WlPAXdINuZ4vKrXG00G8so0yfCSQ==
=4fOc
-----END PGP SIGNATURE-----

--AJCRMQbglmQeiqgZ--
