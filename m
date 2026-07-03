Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A801E3B530F
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 10:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074503; cv=none; b=HZjpgwF1qvE/i2GwdZZlTtzfgyEyDojFFVTUPSA70AdT07H8RW4v7oINypiQJdaoG17MM78Fk2zvlFYPOXN4BbFxa06s1bag/YJ8mxhBkbKYbFkyUrkhMyezsZgYzRB6cUm2SIG3W02NLP/u7UQ12H2IZEogjrUufT3+MogditE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074503; c=relaxed/simple;
	bh=3LJprq2PH1kgXaH+2RR/kmwaIqKoF1OsBV4LQ2RES/M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cw7NLKU8opqxiE+I+TrsBnmVRX0egFSLhZXaO461BiqQYC9hdNTnZmHQ4wTQR+jc9t0SZ+tknhE49Tix659rM6RRL89ICmARISCoDGgbYOm7kPIzR4cgdKqcpwb0WlhMVDR5wK80HEXK54/yII26wNXi78jurFHIP3BFFbobpc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hn29AqYX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hn29AqYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E761F000E9;
	Fri,  3 Jul 2026 10:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783074502;
	bh=sh6yXJc8vvVxrLNUbmPnyUP8gMxMn2i56Ah5hgoyLV8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Hn29AqYX1qT7JzKRHqF0LrCzaXLqoHTeyv2pO8wYSU/mCmx9c5sFdEgzhiTJnkSm6
	 KzOU9Pg+UPsuplHwF99Zu3QGH5ZcVXhirDcYFHeXqPViguzV86rP7YuuNJo/YCVwIN
	 WmDcUV8xwC4XckA6OhU8XyHq1P04VrNZRwABduAhfAU7DptUe5K4nlwBSSOVb7NOOX
	 yytrkZY7kj7jlc5UmUgkwcCdraLRGoMgGUIV3enmvWWZnE6Z52nzZgxjcdZdBjqK+z
	 V/znM1EiCu+KkNQqKDhd17g7PoDCsXlcRkX0gDlbLlqY4kKf5BI9XFDBYlX3L+FrvF
	 mFUXK1hUwBF1g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 16/17] arm64/nmi: Add Kconfig for NMI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260703100135.2512312-17-ruanjinjie@huawei.com>
References: <20260703100135.2512312-1-ruanjinjie@huawei.com>
 <20260703100135.2512312-17-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:28:21 +0000
Message-Id: <20260703102822.13E761F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] ARM64_NMI enables architected NMI support but forgets to select =
HAVE_PERF_EVENTS_NMI, disabling the Perf Hardlockup Detector.
--

commit f760a575acac0e1b2376b42b4862ffcc32421ca9
Author: Mark Brown <broonie@kernel.org>

arm64/nmi: Add Kconfig for NMI
   =20
Since NMI handling is in some fairly hot paths we provide a Kconfig option
which allows support to be compiled out when not needed.

Link: https://lore.kernel.org/r/20221112151708.175147-14-broonie@kernel.org

> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index b3afe0688919b..218996752079e 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -2195,6 +2195,23 @@ endmenu # "ARMv8.7 architectural features"
>  config AS_HAS_MOPS
>  	def_bool $(as-instr,.arch_extension mops)
> =20
> +menu "ARMv8.8 architectural features"
> +
> +config ARM64_NMI
> +	bool "Enable support for Non-maskable Interrupts (NMI)"

[Severity: Medium]
Does this configuration need to propagate its capability to the perf events
subsystem?

Currently, the main ARM64 configuration conditionally selects
HAVE_PERF_EVENTS_NMI when ARM64_PSEUDO_NMI is enabled:

arch/arm64/Kconfig:config ARM64
    ...
    select HAVE_PERF_EVENTS_NMI if ARM64_PSEUDO_NMI
    ...

Without similar treatment for ARM64_NMI, does the perf-based hardlockup
detector become silently unavailable when the system is configured to use
architected NMIs instead of pseudo-NMIs?

Should the ARM64 configuration be updated to select HAVE_PERF_EVENTS_NMI if
ARM64_NMI is also enabled?

> +	default y
> +	help
> +	  Non-maskable interrupts are an architecture and GIC feature
> +	  which allow the system to configure some interrupts to be
> +	  configured to have superpriority, allowing them to be handled
> +	  before other interrupts and masked for shorter periods of time.
> +
> +	  The feature is detected at runtime, and will remain disabled
> +	  if the cpu does not implement the feature. It will also be
> +	  disabled if pseudo NMIs are enabled at runtime.
> +
> +endmenu # "ARMv8.8 architectural features"

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703100135.2512=
312-1-ruanjinjie@huawei.com?part=3D16
