Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDCC4AF694;
	Thu,  3 Sep 2026 16:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788454771; cv=none; b=R1zIigy+q3iaOwWcm/IfBg1GETjDcuozlZ3N3KUWEHa37K1HUKf4H8nd+8KI7nZ52eX9QCZCK+qRot+f7caIZvIXKhwsC9yxOCLnhQmBJZTMU3wF+r2DGd3k1Qab2I3mB0x3ToNQnk7Mn21WaNQlNatqOLaOxSw/vuxkvK7nHb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788454771; c=relaxed/simple;
	bh=RvsQbE5s65d6+Anq0dODUPgUbrbj49OIhMV681TbNKA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uYUMxB5dEJtadfVXnu00PXMJZEXgFdDoUrvC7biHDt7/IIuqVMnF525TU/cc5Kd2nJIk1Onnz8B1JCCfNPSfnEbxM8q610w/WwJLv26pUyIN4/bobrrQPhvCiZ8QYWooS/6qrHRvCT2o/lXB1EaRIIvYuS88Uvbfh019KPY99mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lbNMUqir; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lbNMUqir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234811F00A3D;
	Thu,  3 Sep 2026 16:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788454770;
	bh=4/0/xKr0SqKermyN9+5lI5dNa6bRku1e2ag5QkY/6xA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lbNMUqirw6snFISY6DcFF3C/F1N4OX3BFNbkdg6Fke+cWxzRbG/t8CVdXrtyDjQYF
	 b+uQUkfIMFFxO0f6xYiKuukTsxa49NOFNkrDTm8im2hPYTpdIiL2XUVTaUsVuL+8f2
	 KhAaUlVk45dA3HUZupIHW6HKwPlb0xh3bIe4KNzyBHOgVv3j0bd3FO3e2YkB4sgoiM
	 QFjio4w3Y+tb/OyuqqUUIJT2tf/mqj5W78e79oFcstnMWhFpUsp4iAdNyqqyJmyjm+
	 3MWyycI5YfKdzIDAhCiOTs4TDU/6TmjQiNVAQ57LqSm7Z42vH9gj0ispTCR9ldFxtL
	 sNj1n5lkcF2Lg==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 28/28] KVM: arm64: Allow the creation of a SPE
 enabled VM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org
In-Reply-To: <20260903160623.315525-29-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-29-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:59:29 +0000
Message-Id: <20260903165930.234811F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The Kconfig dependency for `KVM_ARM_SPE` restricts it to 'n' whe=
n the `ARM_SPE_PMU` driver is built as a module, preventing users from enab=
ling SPE virtualization.
--

commit 9bb804f4572dd230ad3b5db909bd2001b3ee3186
Author: Alexandru Elisei <alexandru.elisei@arm.com>

KVM: arm64: Allow the creation of a SPE enabled VM

This commit introduces the Kconfig option KVM_ARM_SPE to allow userspace
to enable the Statistical Profiling Extension (SPE) for virtual machines.

[ ... ]

> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -106,9 +106,9 @@ endif # NVHE_EL2_DEBUG
> =20
> =20
>  config KVM_ARM_SPE
> -	bool
> +	bool "Support SPE in guest"
>  	depends on KVM && ARM_SPE_PMU

[Severity: Medium]
Does this Kconfig dependency unintentionally disable KVM_ARM_SPE when the
host driver ARM_SPE_PMU is built as a module?

Because KVM_ARM_SPE is a boolean, if ARM_SPE_PMU is configured as a
loadable module (=3Dm), the Kconfig dependency evaluates to m. For a boolean
config, this restricts its maximum value to n, effectively disabling the
feature in the build configuration.

Since the implementation in arch/arm64/kvm/spe.c supports being built
against a modular driver (using try_module_get()), should this dependency
be relaxed or handled differently so the feature can still be selected?

> -	default n
> +	default y
>  	help
>  	  Adds support for Statistical Profiling Extension (SPE) in virtual
>  	  machines.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D28
