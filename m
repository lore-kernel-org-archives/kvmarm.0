Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1D33FADEE;
	Thu,  9 Jul 2026 11:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783594804; cv=none; b=WRZebJ91bayylinXkCZCTi0+lcpsuYimgAJpVBCxCdgK5/NttBctw5iqJgtGCBrc+tu9BHa4jPfaaJucVKdX5Pgfrc62BKIN1mv9njni4JBfJpTJvP0QBAKVLDnFW8YoY3mZcau1xWVTEAK3I22l/I0RLT5qc49P4EkgGNALNS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783594804; c=relaxed/simple;
	bh=Jhcamkq2zKCut4tjebip/8+0ahz8XqA80BbU90zRoVs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YJ3Kv2zg/eDBcvJE9DsFhANiKHuc2UGoE9N3qjzQ8SjJPl5i9iBYey0D2HiIe8I18k7zx+I9J7Ij9cixe0+tvavqF1qBDMBJWaPvly0N/yxeYRqJ0ZjQB0Lyantj8Ihr6RwgOH3Ad/l5RO38aU1I/bu9XBmFR6Ee3kYQAmO59as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yl8JmyBq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yl8JmyBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21C51F00A3A;
	Thu,  9 Jul 2026 11:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783594803;
	bh=q8c00F2YR1bkaBPJCdJzBUnBH0hwKbC+/ZE9GitYAkE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yl8JmyBqZjQtPzb4DhVMTVTMYqLShftwQ4H0RNCeybq12mJVCftWXE/W5RnOBaw+w
	 n2BGkflU1sC+A6c2R8LykQKs8X646DGhzAuR6NNgFhFbRLwgKgLq/cJIm6+lU5JKn4
	 kG2j+j4lm9nRx76fkAHwukhBNNQUN2o4GxSVnQ+Kp/Sw4JkqT91QK0O26zYKDVKePW
	 ddeqfNaTemjEmJ1DIVuCUS2u2N8Hvzg0XBlGitynK+ewk4ZdcKMQZk6EiPp5QXUZXI
	 ZBArwlcNv000heACcjiKi4QmRcMHMXTVEfmB7UNG9V83ho+Sty5Xpf7A9GaQ51Rarw
	 uS7k2H/Tkkggg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/6] KVM: arm64: Add support for FEAT_HDBSS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tian Zheng" <zhengtian10@huawei.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260709104026.2612599-3-zhengtian10@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
 <20260709104026.2612599-3-zhengtian10@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 09 Jul 2026 11:00:02 +0000
Message-Id: <20260709110002.D21C51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The parameter name `cope` in `has_vhe_hdbss()` is a typo for `scope=
`.
--

--- Patch [2]: [PATCH v4 2/6] KVM: arm64: Add support for FEAT_HDBSS ---
commit fc8e5042a6724701835a3f111b45e733575a4a2e
Author: Tian Zheng <zhengtian10@huawei.com>

KVM: arm64: Add support for FEAT_HDBSS

This commit adds CPU capability detection for the Hardware Dirty Bit State=
=20
Structure (HDBSS) feature introduced in Armv9.5. It provides a helper=20
function to check for hardware support, requiring VHE mode.

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeatur=
e.c
> index 9a22df0c5120f..aa327eebaf1ca 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
[ ... ]
> @@ -2131,6 +2131,11 @@ static bool hvhe_possible(const struct arm64_cpu_c=
apabilities *entry,
>  	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
>  }
> =20
> +static bool has_vhe_hdbss(const struct arm64_cpu_capabilities *entry, in=
t cope)
                                                                           =
  ^^^^

[Severity: Low]
This isn't a bug, but is the parameter name "cope" a typo for "scope"?

> +{
> +	return is_kernel_in_hyp_mode() && has_cpuid_feature(entry, cope);
> +}
> +
>  bool cpu_supports_bbml2_noabort(void)
>  {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260709104026.2612=
599-1-zhengtian10@huawei.com?part=3D2
