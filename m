Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D3844236B;
	Sat, 12 Sep 2026 08:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202758; cv=none; b=qQnDy3P/nsOkI5ll5JKwk6+4AihYuFNgmpdXejbkXECTMK1QiNRWJp9UNLOk7A0Htb3HuSfQNUVUMY+wu6FVo5r+0u90Gi3RdXWDrC77GtfWjy1wZZy6MukdiVJ0MYAWTNE2t6UpYcdctmpQy+f2GBpo3ru13B9nADsiY9rHs30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202758; c=relaxed/simple;
	bh=Z0omvdScSbZLkw0ntRAIOsZnksWg5VvFc4dd+XCsnnc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=P30NWnnHTHwj9ZgoJJ0W+XDhl9MEtDjIRY1lrj2rjo5oyaRREHDcrTue40xawuDdyCxdgrMbLDfPbHHnT2tKuI2R4rwLrXua763PudyvXpYmQKDAKflcYz+mD8cMcmzhwI+FipRKCibxE4mppPTQwkOR0Olyc+bEHip1oo1J77E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ROjzWMV6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ROjzWMV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B68E1F00893;
	Sat, 12 Sep 2026 08:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789202756;
	bh=mg3GaPxc2QIzLsAvDNUYVpscXXPep6mp7Ir4QMLFMA8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ROjzWMV6J9n9LjFAzpLgxrHQJfq74FniEZw289Hznr/grl9rhguJKQT52iP5aSXnh
	 kkrPDsU0ssgqz73OBLoymRpCIPk/JrgKNAk3tTfFnL92VotX6utDfTL+fVcm1p14qt
	 B+S0VJYzeHXh2XP1OGFFgb7k0tAppAOPE5tmNXN5gA1A7VGLUtL4SHemUQg8wmc1jy
	 Af+SfBTUkxuFxT+kvD1qerdJMlLcDJwDEn3qvgBnwPs8hqxIfFxPJeX+M6q0ls0pL5
	 99+YYQkyDrLG7fmBuZk7rRSwRWR9GCx4jLIippFUXiqTa8CqSNoydqzzq7fj8EYxep
	 tW+j4CpyDOP1g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v18 1/7] firmware: arm_rmm: Add SMC definitions for
 calling the RMM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260912083611.2513845-2-suzuki.poulose@arm.com>
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-2-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 12 Sep 2026 08:45:55 +0000
Message-Id: <20260912084556.2B68E1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Usage of GENMASK and BIT macros for 64-bit masks causes Undefined B=
ehavior on 32-bit architectures
--

commit cfdd0e3f2fb70671ab2dbb64f06ca56946732456
Author: Steven Price <steven.price@arm.com>

firmware: arm_rmm: Add SMC definitions for calling the RMM

This commit introduces SMC definitions for calling the Realm Management Mon=
itor
(RMM) from the host. The definitions are based on the ARM RMM specification
version 2.0-bet3.

Link: https://developer.arm.com/documentation/den0137/2-0bet3/

> diff --git a/include/linux/arm-smccc-rmi.h b/include/linux/arm-smccc-rmi.h
> new file mode 100644
> index 0000000000000..214d6228dfc22
> --- /dev/null
> +++ b/include/linux/arm-smccc-rmi.h

[ ... ]

> +#define RMI_ADDR_TYPE_NONE		0
> +#define RMI_ADDR_TYPE_SINGLE		1
> +#define RMI_ADDR_TYPE_LIST		2
> +
> +#define RMI_ADDR_RANGE_STATE_MASK	GENMASK(63, 62)
> +#define RMI_ADDR_RANGE_ADDR_MASK	GENMASK(51, PAGE_SHIFT)

[Severity: Low]
Can the use of GENMASK for bit positions >=3D 32 cause undefined behavior on
32-bit architectures?=20

The GENMASK macro evaluates to unsigned long, which is 32 bits wide on 32-b=
it
architectures. Shifting by 32 or more results in truncation or an
out-of-bounds shift.

Would it be better to use GENMASK_ULL here for these 64-bit masks?

> +#define RMI_ADDR_RANGE_COUNT_MASK	GENMASK(PAGE_SHIFT - 1, 2)
> +#define RMI_ADDR_RANGE_BLOCK_SIZE_MASK	GENMASK(1, 0)

[ ... ]

> +enum rmi_ripas {
> +	RMI_EMPTY =3D 0,
> +	RMI_RAM =3D 1,
> +	RMI_DESTROYED =3D 2,
> +	RMI_DEV =3D 3,
> +};
> +
> +#define RMI_NO_MEASURE_CONTENT	0
> +#define RMI_MEASURE_CONTENT	1
> +
> +#define RMI_FEATURE_REGISTER_0_S2OASZ			GENMASK(40, 33)
> +#define RMI_FEATURE_REGISTER_0_L0GPT_BLOCK_DELEGATE	BIT(32)

[Severity: Low]
Similarly, will this GENMASK and BIT usage trigger the same undefined behav=
ior
when evaluated as unsigned long? Using GENMASK_ULL and BIT_ULL might avoid =
this.

> +#define RMI_FEATURE_REGISTER_0_PMU_NUM_CTRS		GENMASK(31, 27)
> +#define RMI_FEATURE_REGISTER_0_PMU			BIT(26)

[ ... ]

> +#define RMI_FEATURE_REGISTER_3_RTT_S2AP_INDIRECT	BIT(6)
> +#define RMI_FEATURE_REGISTER_3_RTT_PLANE		GENMASK(5, 4)
> +#define RMI_FEATURE_REGISTER_3_MAX_NUM_AUX_PLANES	GENMASK(3, 0)
> +
> +#define RMI_FEATURE_REGISTER_4_MEC_COUNT		GENMASK(63, 0)

[Severity: Low]
Could GENMASK_ULL(63, 0) be used here as well?

> +
> +#define RMI_MEM_CATEGORY_CONVENTIONAL		0
> +#define RMI_MEM_CATEGORY_DEV_NCOH		1

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260912083611.2513=
845-1-suzuki.poulose@arm.com?part=3D1
