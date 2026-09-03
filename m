Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A143EFFAF;
	Thu,  3 Sep 2026 17:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788454812; cv=none; b=YZ6/WM56Qwyfp7piDOi/OHTwn+1SpaqvVh116Ft3uGtWzv5jCYg8BR0wcU8NNegdPSA2E2MoT8/ccXz9fUFMwzbmdUg21TvfIHNemc2ds/H8/ScXLZQSLpyol34/3vTgwGIjEj6tayKXBpiMob8/INA1fz147sMpEpSCnZRxyXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788454812; c=relaxed/simple;
	bh=KshVxQXNgngisR5BoyKqFhcuY21vSQ6BbLNU5td7rrU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=otWv2RRqbtzVWmkK1rHUHFOfM5a54Ps+baNjCTKBLatJvr+jwXPs0IN9BEAZMMIbezgvwLfW3S+QWjAi6YhRSBvPXRwgNRRB42RHWVdC2tYe9H3DQ1LZpE7eVYnziKpRLfxGGcf5CKTezGCgzWih23rFzfHbBvvbTS/3on0xcgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K05zf1uA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K05zf1uA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1025F1F000E9;
	Thu,  3 Sep 2026 17:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788454811;
	bh=zF/KsxokTC2tP5qztmGEE+raUNsT9p6WYChqmGs5mnA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K05zf1uAFaRGMCzEKr0GFm+///4YmOKlUvwjN09JnCmFpkoBj6a97KjxUR0y4nMGw
	 LPUGjHFjvIA0l6vu1CE4alhgGVd1A2//T8ANmOvWvywg4YHjvJ9pFmA47mf0rFsvkT
	 bIR5HlplDdSnoy1/2IsZdIpVEuzuQPORjMtsmbfBQun/4APsUkVtr5YzySznx3aeXV
	 Q8sTJx1WY2361yXhCgy2AXyFzaZyohU8WE68wv+euMW6YG32Ix6xAYXSxiqJJOaoXb
	 PpQQ89misAkO7ifQWSUmFK/CmczU0U8FMVzvet5OGtXSGb8rQCg2OPmRaCs1tOOvcQ
	 Oc+B0jEUdYYGw==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 24/28] arm64: errata: Don't enable guest buffer
 if misprogrammed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260903160623.315525-25-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-25-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 17:00:10 +0000
Message-Id: <20260903170011.1025F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> When PMBPTR_EL1 is programmed to be equal to or greater than
> PMBLIMITR_EL1.Limit, SPE is enabled and PMBSR_EL1.S is zero, the CPU might
> deadlock.
>=20
> This doesn't affect correctly written software, like the SPE driver, but a
> buggy KVM guest might trigger the erratum. The workaround for KVM is not =
to
> enable the hardware buffer, and, as a consequence, profiling. According
> to ARM DDI0487M.c, rule R_PGGHS, this is one of the acceptable
> behaviours when the buffer is misprogrammed.
>=20
> Several parts are affected:
>=20
> * ARM Neoverse-N1 (MP050), SDEN v35, erratum 1978083
>   https://support.arm.com/documentation/SDEN-885747/35-0
> * ARM Neoverse-V1 (MP076), SDEN v23, erratum 1978082
>   https://support.arm.com/documentation/SDEN-1401781/23-0
> * ARM Cortex-X1 (MP077), SDEN v25, erratum 2004055
>   https://support.arm.com/documentation/SDEN-1401782/25-0
> * ARM Cortex-X1C (MP136), SDEN v20, erratum 2004056
>   https://support.arm.com/documentation/SDEN-1707914/20-0
> * ARM Cortex-A78 (MP102), SDEN v25, erratum 2004055
>   https://support.arm.com/documentation/SDEN-1401784/25-0
> * ARM Cortex-A78AE (MP105), SDEN v22, erratum 2004059
>   https://support.arm.com/documentation/SDEN-1707912/22-0
> * ARM Cortex-A78C (MP138), SDEN v20, erratum 2004056
>   https://support.arm.com/documentation/SDEN-1707916/20-0
>=20
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D24

