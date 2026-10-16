Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8184EB84D;
	Fri, 16 Oct 2026 16:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167513; cv=none; b=ETCFgXPu2g3v+8iuGDQNYSnNwTkuSgIHLS6eM3yZaxvTNSi9fF5J/Z4KtGVoVqhv+rCcS/KnlM5q1ySSSXOeR3q3B36PWH0+TtxATeCFJS4c9dL0jHe9jKSkkCKC4ALyxvTypihXKErlNXcgtZe24hJ5eHaBqi4zA8AZIMwluIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167513; c=relaxed/simple;
	bh=aH4IH8Yd54UY1jTWq3eh6UdpfFNWzKZsS9+vZ5KhCLc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=DLngG+Cyy0eQUh1dtiGu4sUwuiH40/fSv+lSOSFXWslYVHK41GMeEkVHRT9rfMCT5lqOKIaHvXpDQ2hheXN8tVQTF5eozrP26Qtrabpo8xxSK+g9+WJMER/HqA2erxr28Br0ctW8hKQ+Nx6jGvsCYUh0mgFG9kwf27NcmIIJSIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hlp8qBtl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hlp8qBtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C751F000C4;
	Fri, 16 Oct 2026 16:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792167509;
	bh=CrQQEYmfJ88SYkYBNZ9iUpRMziywckddhJM6vtsMpdE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hlp8qBtlNoswYVV2KhoWiq0ft+Is7YLkyomZc1PZpikSvMJhH6coQ6bXWu3rXq6p0
	 3GTf0N/bjZUp9EjcLv5Zy8Zqnpml74q5VdWZjs8XXbKGaTed75f70L6IGi72z6WjxS
	 RpZ/RvRtMssmG1Fgr17pHNZyZ2qStdx+HJVwaPjDYzm8xSfIo0jZFoGSeIlsNz96uR
	 i/0CuxsBnkMi565mq/nB+QtxXlUOPJALyJxt9/QKccRdibWx+bxcPTJRy0Qjrsrkr+
	 hx9f0fEQfb7CUh7Cm2DlG/YxxADj51e9j2BnFtVVoDqRomeAG5zEgqtCf3+rxZxOHy
	 nJi8IOHRC5Mww==
Message-ID: <sashiko-outbox-174624@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 14/16] KVM: selftests: Add VGICv5 ITS attribute tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261016155741.979985-15-sascha.bischoff@arm.com>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-15-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 16:18:28 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] kvm: selftests: tautological test for ITS DT_CFGR/DT_BASER updates
- [Low] kvm: selftests: missing idle status register checks for ITS
--

commit c7601fac392a61f968d6064e81cd764b666cb504
Author: Sascha Bischoff <sascha.bischoff@arm.com>

KVM: selftests: Add VGICv5 ITS attribute tests

This commit adds coverage for the VGICv5 ITS device address and ITS_REGS
attribute groups. Userspace needs to be able to discover and save the virtu=
al
ITS register state, while KVM must reject invalid address placement and
malformed register accesses.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/=
selftests/kvm/arm64/vgic_v5.c
> index d5df742b23001..b7fb002a64f6c 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
[ ... ]
> @@ -1287,6 +1339,177 @@ static void test_vgic_v5_irs_regs_attrs(void)
>  	vm_gic_destroy(&v);
>  }
> =20
> +static void test_vgic_v5_its_attrs(void)
> +{
[ ... ]
> +	/* Check MMIO by checking if present, reading, then writing back */
> +	for (i =3D 0; i < ARRAY_SIZE(gic_v5_its_regs); i++) {
> +		attr =3D gic_v5_its_regs[i].attr;
> +		ret =3D __kvm_has_device_attr(v.its_fd,
> +					    KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
> +					    attr);

[Severity: Low]
The commit message mentions exercising "idle status register values", but t=
his
loop only reads and writes back the registers without checking their values.
Should there be an explicit assertion that the status registers (like STATU=
SR,
SYNC_STATUSR, GEN_EVENT_STATUSR) actually read as idle? The corresponding
test_vgic_v5_irs_regs_attrs() test includes these checks for the IRS.

[ ... ]
> +	/* Make sure we can restore the vITS's enable state */
> +	val =3D GICV5_ITS_CR0_ITSEN;
> +	ret =3D __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
> +				    GICV5_ITS_CR0, &val);
> +	TEST_ASSERT(!ret, "GICv5 ITS_REGS failed to enable ITS");
> +
> +	/* And DT CFGR/BASER */
> +	val =3D 0;
> +	ret =3D __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
> +				    GICV5_ITS_DT_CFGR, &val);
> +	TEST_ASSERT(!ret, "GICv5 ITS_REGS rejected enabled DT_CFGR update");
> +	ret =3D __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
> +				    GICV5_ITS_DT_CFGR, &val);
> +	TEST_ASSERT(!ret && !val, "GICv5 ITS_REGS DT_CFGR restore mismatch");

[Severity: Low]
Is this test effectively verifying that the updates to GICV5_ITS_DT_CFGR wo=
rk
while the ITS is enabled?=20

Because val is set to 0 (the default/reset value of the register) before the
write, if the kernel incorrectly discards the write while ITSEN=3D1, the
register will remain 0 and the read-back will return 0, allowing the test to
pass spuriously. Writing a non-zero valid value would avoid this tautology.

Also, the test writes GICV5_ITS_CR0_ITSEN to CR0 but never reads it back.
Could the test be trying to update the configuration registers on a disabled
ITS if the enable bit didn't actually stick?

> diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/t=
esting/selftests/kvm/include/arm64/gic_v5.h
> index 2d455515563e0..22ab78626af5a 100644
> --- a/tools/testing/selftests/kvm/include/arm64/gic_v5.h
> +++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
[ ... ]
> +#define GICV5_ITS_CR0_IDLE		BIT(1)

[Severity: Low]
Is this macro correct for the ITS? It defines an IDLE bit for CR0, but it
appears to be unused in the test. Looking at the GICv5 architecture, it see=
ms
only the IRS has an IDLE bit in CR0, not the ITS.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016155741.9799=
85-1-sascha.bischoff@arm.com?part=3D14
