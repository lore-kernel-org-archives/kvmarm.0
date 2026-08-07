Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF04346ADA;
	Fri,  7 Aug 2026 17:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786123063; cv=none; b=OxqN8kwmHTaAOsNV2llMiKR/yKh3/wa1HsjQOQyjuPdDw/78yY71U0SZ3Qs+WUeX7xH7+zmxdjyXpy7YpirZg53lXxwPbZFfl4G1dkYhaIo+BtB0Jcx7Hn6CgfSRz/KzkSgbsRk/e0oTiwaSjQtvnJ3zhSCCQ+7UWp7HKI9jwxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786123063; c=relaxed/simple;
	bh=Fc86sQdZ1CIHsASZtzey8e4waeAqeYYkV6G0CS/QTFc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=a5j3c6+nbrCx1HVGHEEure0gvhfRB8gcgGyB+55tx2HSNESwVxeBoHHwUWbfnf00QQo440zVnni6rRY9FbY+npKNtmjsLebZEurKb6FqeOT4bHuI+0pXcnaRMAqvLBtz64hXQ0hKNwHiUnZfiXO+w4QUv0AJFtZPQXwZMQx/Yv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PbiqI3a+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PbiqI3a+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295DA1F000E9;
	Fri,  7 Aug 2026 17:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786123062;
	bh=2x8tFKGrJQ8D4a3hGV0+KuP+/QXoO5iHUVPkHlVwqQ8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PbiqI3a+QFz6cpnDfaXEzyt50Gxg88/Lq/twqOQoRSXjyQ2BMGhU/CyEWzgwmN/7f
	 mYKqdmdijTPwaZlX99dLwU1I1w8lKy3gWJRK9xIin0b66LvGeIpnmSzredfXWB8lFA
	 hASTT2w95JIARy+R8Dmm/DPhq4ZK69uvYCTH7BscvvIGDMzsiHmfWqRSM2n12FietV
	 acbIuVsF8p7zYYYOIF+o53M5BE8JnZnjGob8Ag7dD3A7kTfkT+sYB5BRxqtrnsUY5q
	 L/UC4LAMkh1zqGu5J+rFRDoaOP+ZyY6b5kXTlR7/bywWtx5FFgXsQMzBi48tonF47X
	 wsLfUAwBnPN3g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 42/49] KVM: selftests: Add VGICv5 IRS_REGS attribute
 tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260807111159.429128-43-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-43-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 17:17:41 +0000
Message-Id: <20260807171742.295DA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The selftest for validating `GICV5_IRS_IDR0` domain rejection as=
signs a completely zeroed value to `val` instead of modifying the existing =
register value, making the test ineffective.
--

--- Patch [42]: [PATCH v5 42/49] KVM: selftests: Add VGICv5 IRS_REGS attrib=
ute tests ---
commit 11fcbef9e79956f20030f1a93c0eeaba44375ad8
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: selftests: Add VGICv5 IRS_REGS attribute tests
   =20
This commit adds test coverage for the VGICv5 IRS_REGS attribute group.
It verifies that KVM properly exposes valid registers and rejects
invalid inputs, bad offsets, or incorrect alignment.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/=
selftests/kvm/arm64/vgic_v5.c
> index f4c0d2c003bb4..54fa13906990b 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c

[ ... ]

> @@ -272,6 +340,189 @@ static void test_vgic_v5_nr_irqs_attrs(void)
> =20
>  }
> =20
> +static void test_vgic_v5_irs_regs_attrs(void)
> +{

[ ... ]

> +	/* ID restore validation rejects unsupported values. */
> +	val =3D FIELD_PREP(GICV5_IRS_IDR0_INT_DOM, GICV5_IRS_IDR0_INT_DOM_SECUR=
E);
> +	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
> +				    GICV5_IRS_IDR0, &val);
> +	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted bad ID=
R0 domain");

[Severity: Medium]
Will this test effectively check the INT_DOM field rejection?

Since val is assigned directly rather than modifying a valid read value (li=
ke
the SETLPI test below it), and since GICV5_IRS_IDR0_INT_DOM_SECURE is 0,
val is evaluated as 0.=20

The kernel will likely reject IDR0 =3D 0 due to other mismatched fields (su=
ch
as version numbers or feature bits), making this test pass even if the kern=
el
fails to validate the INT_DOM field specifically.

Could this be updated to read the existing IDR0 value and modify its INT_DOM
field before calling __kvm_device_attr_set?

> +
> +	ret =3D __kvm_device_attr_get(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
> +				    GICV5_IRS_IDR0, &val);
> +	TEST_ASSERT(!ret, "GICv5 IRS_REGS get IDR0 failed");
> +	val |=3D GICV5_IRS_IDR0_SETLPI;
> +	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_IRS_REGS,
> +				    GICV5_IRS_IDR0, &val);
> +	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 IRS_REGS accepted unsupp=
orted IDR0");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D42
