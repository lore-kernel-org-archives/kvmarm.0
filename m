Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0747F404BDA;
	Fri, 24 Jul 2026 12:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784894790; cv=none; b=T8IlPdA1oqDMb/W6iFkW5qKbU/GYXDBd7f8MTr6xJbpsFegKKMYPxTeGeXb92WzCwL98PP4PPN5T+q0mTSd/qR82CvUToWwvyA7MWm+Z5vg+xOrtrKKBuuxGI09/vzqUGjmlH72wbiQKDfnot2Uuh71iOFbSTPoT/u9tcFDpiFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784894790; c=relaxed/simple;
	bh=cEv72i/m2aAgTLXo9SKTH+S2yRtxoUcAemnL/PMI9EY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SA4sqIIV264Wom6J07MGI3TEeVt+1nV89S91GxhnjfKTd6GSZYlVnb9FF8maJHwGXYuifwtE8DYECM4gPsqFh9abryJ5DFkpj/MjfGBFFQi7GPewJF+mXt6o5yCOPPpVpl9m2vmVtSZOQ0QUUoxqiG5eRE/GyTBQxnkmTx8IWNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NXdu1+yj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NXdu1+yj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF181F000E9;
	Fri, 24 Jul 2026 12:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784894788;
	bh=FEY/ClQEfDscOyJJYeNo9OTXv7C64uTiQGIl6P9sKRY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NXdu1+yjhY1OOdThsVvpq/3NnAZor2Ka3EvRkrb84M7NWSFfZh+BO3iRJt8Qynpi3
	 bpG3pJXwGOT+LwPiHP59wuxdMpIpgfolx71HsPxtASPJSVxjPRlV+sL+VFd5YjVB5V
	 1G0iZpeojg8kemT0K/oZlCWJKEXH1bfcyQQNJJFh+cAYjZ58peJAp8DTBCz6fXWBVF
	 6RWS08asMbPHf6gEUt8RDX8eQoH5cbzQjvDS2+GZJomR3+mhx91RUvPuCcv3n9idiz
	 PbEZkPn8sBcKYEaI13Fx4bXaaYrqm3Mhn+EL7uvEXPbYOntwcS9eU0//zwBNkI6oPH
	 JZclJw3quT1ng==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 42/48] KVM: selftests: Add VGICv5 IRS_REGS attribute
 tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260724104819.1296803-43-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-43-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 12:06:27 +0000
Message-Id: <20260724120628.5FF181F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] Using a `u64` variable for 32-bit KVM device attributes causes t=
est logic failures on Big-Endian architectures.
- [Medium] `IST_BASER` is configured to point to the VGIC MMIO region inste=
ad of guest RAM.
- [Medium] Spurious test failure on hardware supporting 8 priority bits.
--

--- Patch [42]: [PATCH v4 42/48] KVM: selftests: Add VGICv5 IRS_REGS attrib=
ute tests ---
commit 7457ae5ec0d03e64cfdb7419437558dc7acaf9df
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: KVM: selftests: Add VGICv5 IRS_REGS attribute tests

Add coverage for the VGICv5 IRS_REGS attribute group. Migration needs a
userspace-visible view of the virtual IRS register state, but KVM must
only expose valid registers and must reject state that cannot be restored
safely.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/=
selftests/kvm/arm64/vgic_v5.c
> --- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c

[ ... ]

> +static void test_vgic_v5_irs_regs_attrs(void)
> +{

[ ... ]

> +	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
> +				    GICV5_IRS_IDR1, &val);
> +	TEST_ASSERT(!ret, "GICv5 IRS_REGS get IDR1 failed");
> +	val |=3D FIELD_PREP(GICV5_IRS_IDR1_PRIORITY_BITS, 0x7);
> +	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
> +				    GICV5_IRS_IDR1, &val);
> +	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad ID=
R1");

[Severity: Medium]
Will this assertion falsely fail on hardware that supports 8 priority bits?

The architecture allows up to 8 priority bits, which encodes as 0x7. If the
test runs on a host whose hardware legitimately supports this configuration,
KVM will likely accept the write instead of returning -EINVAL, causing a
spurious test failure.

[ ... ]

> +	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
> +				    GICV5_IRS_IDR5, &val);
> +	TEST_ASSERT(!ret, "GICv5 IRS_REGS get IDR5 failed");
> +	val++;
> +	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
> +				    GICV5_IRS_IDR5, &val);
> +	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad ID=
R5");

[Severity: Medium]
Could this cause spurious test failures on Big-Endian architectures?

KVM reads and writes 32-bit attributes to the upper 32 bits of a u64 buffer
on BE systems. The val++ operation increments the lower 32 bits, leaving
the actual 32-bit attribute value in the upper 32 bits untouched. When
this is written back, KVM might legitimately accept the unchanged value,
causing this assertion to fail.

[ ... ]

> +	/* Status registers read as idle through userspace accessors. */
> +	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
> +				    GICV5_IRS_SYNC_STATUSR, &val);
> +	TEST_ASSERT(!ret && val =3D=3D GICV5_IRS_SYNC_STATUSR_IDLE,
> +		    "GICv5 IRS_REGS SYNC_STATUSR is not idle");

[ ... ]

> +	/* Userspace restore of IST_BASER updates state without allocating ISTs=
. */
> +	val =3D FIELD_PREP(GICV5_IRS_IST_BASER_ADDR_MASK,
> +			 GICV5_IRS_CONFIG_BASE_GPA >> GICV5_IRS_IST_BASER_ADDR_SHIFT);
> +	val |=3D GICV5_IRS_IST_BASER_VALID;
> +	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
> +				    GICV5_IRS_IST_BASER, &val);
> +	TEST_ASSERT(!ret, "GICv5 IRS_REGS failed to restore IST_BASER");

[Severity: Medium]
Is it intentional to configure the Interrupt Status Table to overlap with t=
he
VGIC's own MMIO region here?

GICV5_IRS_CONFIG_BASE_GPA is the base address of the IRS MMIO region, but
the IST should typically reside in standard guest RAM (such as
VGIC_V5_LPI_IST_BASE_GPA). If KVM adds validation in the future to ensure
IST_BASER points to a valid memory slot instead of an MMIO region, could
this configuration be rejected and break the test?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D42
