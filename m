Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823B71F3B85;
	Thu, 30 Jul 2026 14:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785420686; cv=none; b=ELwABMLKltVASgmpvdtXc2Q8Hawn7al7ETkSmpRkSeMzrU+qtI7SA3aUPNgi8tHnq3uHjjFWXpHUNdvEglRmSc7sENKFeF38BSI4QLA5YDdUBLORNQBobHk5wyPX5/MU4tKZMBkz8PiXw32NqmNMUpsbGveodWACsf6rvff0uwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785420686; c=relaxed/simple;
	bh=a6J37B2pZblj/ORx0/wORmIZxx13s4E4W+XFjZwszaA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=n4ku7hCQ6QXQwXuGnvIFqS+0BsKr+MBz2wGHHCQlmi0A+jI/ZQdnLgaS4QDYu+AM67a2unSOGDrr8vX/qyry0rJstsAzHQvQRvEAVlqCZPC/6TEbO/Ms9jUUHASPWsxX8sEPBmNP9iuUOSa/IIy3B1AowkJKP9IUoMfA6a4gUCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=USYgR3qT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="USYgR3qT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162E31F000E9;
	Thu, 30 Jul 2026 14:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785420685;
	bh=RLwPaWczutbFZz2l0hdfV/DG/T5MQRjMTbKarsnrv7E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=USYgR3qTwwj+osOWOMs61kEQZZEtzDR+vSbtKDdrvQf3JRYTiZFwuYKZ82YUZt4sT
	 WN9ByPYJPrawXndcP+AedYZg91n8PMFwZ5Zbqa0XOmLGPeBikX9SL8F4flXeu8FkTO
	 wCuKpwKLV4/q8LdhOSJPVbD0N3qBOkVbrXMDcPklyblqsSHOG7Su11zF5oVv2ekh4m
	 3q9MHYNRWcJPK5B9YdwtU6xezvHxJd7jcsIPm2Me454TMD0pVtUhA23kczvqjDIOi5
	 lC8x6IWxHYaKFCpWe1GXbgpokbfPtQuBZnXG5MnQrqSkhLfmcdB+AYpLCWKbLjEl7R
	 jENI5B9Vzne/g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] arm64: errata: Add NXP iMX8QM workaround for A53
 cache coherency issue
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?UGVuZyBGYW4gKE9TUyk=?= <peng.fan@oss.nxp.com>
Cc: imx@lists.linux.dev, Frank.Li@kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260730-imx8qm-cache-coherency-v2-1-5651aeb1af16@nxp.com>
References: <20260730-imx8qm-cache-coherency-v2-1-5651aeb1af16@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 14:11:24 +0000
Message-Id: <20260730141125.162E31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing Context Synchronization Event (CSE) after writing to `SCTL=
R_EL1`.
--

--- Patch [1]: [PATCH v2] arm64: errata: Add NXP iMX8QM workaround for A53 =
cache coherency issue ---
commit 174c9667365c79e4a6011c183eeb84b1ff94a880
Author: Peng Fan <peng.fan@nxp.com>

arm64: errata: Add NXP iMX8QM workaround for A53 cache coherency issue

This commit adds a workaround for the NXP i.MX8QuadMax SoC cache coherency
issue (ERR050104). It upgrades targeted TLBI and IC IVAU operations to
broadcast-all variants via static keys and alternatives, and disables KVM
support for the affected hardware.

Link: https://lore.kernel.org/all/20230420112952.28340-1-iivanov@suse.de/

> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errat=
a.c
> index 5db8f0619e4bc..1866eeec27cab 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c

[ ... ]

> @@ -200,6 +201,16 @@ cpu_enable_cache_maint_trap(const struct arm64_cpu_c=
apabilities *__unused)
>  	sysreg_clear_set(sctlr_el1, SCTLR_EL1_UCI, 0);

[Severity: High]
This is a pre-existing issue, but does this write to SCTLR_EL1 require an
immediate isb() barrier before returning?

Writing to a control-plane system register like SCTLR_EL1 in
cpu_enable_cache_maint_trap() without an immediate Context Synchronization
Event (CSE) violates architectural invariants. Returning without an isb()
leaves the CPU pipeline in an undefined state, which could lead to spurious
exceptions or boot-time hangs on affected platforms.

>  }

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730-imx8qm-cac=
he-coherency-v2-1-5651aeb1af16@nxp.com?part=3D1
