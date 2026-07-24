Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9C43B7B96;
	Fri, 24 Jul 2026 12:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784894562; cv=none; b=oivlyqdxauGsR10yY2pkm12OxWIAMsdelOA9xF+4RYLmcn32irx9xsnPquStQXixkGwQuxf+cXzQU/YZSngVVwJhmhycaqtIMQ0kE7/ITuKzb8cCRiglCJFJBnclVI1ZN/WE+HdUoEdPd4GqeTouW8eWGBFCELsI0CB9actt6Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784894562; c=relaxed/simple;
	bh=O5gmTOibvt2nNKJj6j0Ubey6GE3+PTwQTCWa3EyMqG4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VvUBEDVvRXG4U2n5Ow4TTfQ2jmVCh9d9ZFE7U8JTsONF7fYp8ndQ/zVIWb/j+So+FbfJdipIeQ8U7kl0FQo3dnAR1H2RtcU0/GOwQvLtDr45elaTVzSnPn7gwiMd/9wvH2xvh73izFpPO41SJ3cWntILyKndogOVW49VoaBUrXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kBfhbxlV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kBfhbxlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69B91F00A3E;
	Fri, 24 Jul 2026 12:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784894561;
	bh=AJSF1yhOG4jes4R1S4BB9xsPMeuWF+VXXQgLrN+EQ0I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kBfhbxlVXH714+1MJdFF47NL2CqZ5UFhU9u3DgAUrGRVEfEGfv8yMp2NNkFtql1dV
	 ACrBgbNYjqsBB3y/XeX/10oUYEt1MjVAyEtJLcSQj0GYnMW/ZbmEJUk/foih6OjLgx
	 I2UrdsgQiRVAbm1aS+8hElKaBfraa2Kamg/W6IbuRkPxfilFPUbmBREbY2skCntQ6e
	 EIpbI6AEjrA/afbmWcObZQ0HUQdlnm6BunfLIi5WpKGPUaNkb6ks+AMXUY8VOkUsAj
	 C9f2I0qC21flB9+MYAp01F8O2Q1HmLFpBMRmWJolOJyAlOZh16kInpcu9cIF6MwL2q
	 A5eQ5ITbKexfw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 41/48] KVM: selftests: Add VGICv5 NR_IRQS attribute
 tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260724104819.1296803-42-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-42-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 12:02:40 +0000
Message-Id: <20260724120240.C69B91F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] The return value of `kvm_has_device_attr()` is silently ignored,=
 rendering the attribute check ineffective.
- [Medium] The test for exceeding the maximum supported SPI count uses an u=
naligned value, failing to correctly verify the bounds check.
- [Medium] The test meant to verify that `NR_IRQS` is immutable after the V=
M has run is defeated by an explicit `CTRL_INIT` call.
--

--- Patch [41]: [PATCH v4 41/48] KVM: selftests: Add VGICv5 NR_IRQS attribu=
te tests ---
commit 4c2364c5e2833c1962977d2e2805cafe763b427d
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: selftests: Add VGICv5 NR_IRQS attribute tests

Add coverage for the VGICv5 NR_IRQS attribute. VGICv5 exposes a
userspace-selectable SPI count, and KVM must reject values that cannot
be represented by the virtual IRS or that would change the interrupt
layout after it has been fixed.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/=
selftests/kvm/arm64/vgic_v5.c
> index 51ea2fe7141ad..95d74f501ef09 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c

[ ... ]

> @@ -125,60 +183,106 @@ static void test_vgic_v5_create(void)
>  	vm_gic_destroy(&v);
>  }
> =20
> -static void guest_irq_handler(struct ex_regs *regs)
> +static void test_vgic_v5_nr_irqs_attrs(void)
>  {
> -	bool valid;
> -	u32 hwirq;
> -	u64 ia;
> -	static int count;
> -
> -	/*
> -	 * We have pending interrupts. Should never actually enter WFI
> -	 * here!
> -	 */
> -	wfi();
> -	GUEST_SYNC(GUEST_CMD_IS_AWAKE);
> -
> -	ia =3D gicr_insn(CDIA);
> -	valid =3D GICV5_GICR_CDIA_VALID(ia);
> -
> -	GUEST_SYNC(GUEST_CMD_IRQ_CDIA);
> +	struct kvm_vcpu *vcpu;
> +	struct vm_gic v;
> +	uint64_t attr;
> +	u32 nr_irqs;
> +	int ret;
> =20
> -	if (!valid)
> -		return;
> +	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
> +	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
> +	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
> =20
> -	gsb_ack();
> -	isb();
> +	/* Check existing group/attribute */
> +	kvm_has_device_attr(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS, 0);

[Severity: Medium]
Is the return value of kvm_has_device_attr() intentionally ignored here?

If the attribute is missing, the test will proceed and fail on subsequent
operations rather than cleanly skipping or reporting the missing attribute.
Does this check need to be wrapped in a TEST_REQUIRE() or TEST_ASSERT()?

> +
> +	/* Before userspace sets NR_IRQS, no SPI count has been selected. */
> +	nr_irqs =3D 0xbad;

[ ... ]

> +	/* Not a multiple of 32 */
> +	nr_irqs =3D VGIC_V5_DEFAULT_NR_SPIS + 1;
> +	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
> +				    0, &nr_irqs);
> +	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 NR_IRQS not 32-aligned");
> +
> +	/* Larger than KVM's supported VGICv5 SPI count */
> +	nr_irqs =3D VGIC_V5_MAX_NR_SPIS + 1;
> +	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
> +				    0, &nr_irqs);
> +	TEST_ASSERT(ret && errno =3D=3D EINVAL, "GICv5 NR_IRQS above maximum");

[Severity: Medium]
Will this check actually verify the maximum limit?

Since VGIC_V5_MAX_NR_SPIS (65536) + 1 is 65537, which is not a multiple of
32, the kernel will reject it with EINVAL due to the alignment constraint
before it reaches the maximum SPI limit check.

Should this test use VGIC_V5_MAX_NR_SPIS + 32 to ensure we test the upper
bound check rather than triggering the alignment check again?

> +
> +	/* Valid custom SPI count */
> +	nr_irqs =3D VGIC_V5_DEFAULT_NR_SPIS * 2;

[ ... ]

> +	/* NR_IRQS must remain immutable after the VM has run. */
> +	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
> +	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
> +	vcpu =3D vm_vcpu_add(v.vm, 0, guest_code);
> =20
> -	gic_insn(hwirq, CDDI);
> -	gic_insn(0, CDEOI);
> +	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
> +	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);
> +	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> +			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
> =20
> -	GUEST_SYNC(GUEST_CMD_IRQ_DIEOI);
> +	ret =3D run_vcpu(vcpu);
> +	TEST_ASSERT(!ret, "Failed to run GICv5 VM before NR_IRQS test");

[Severity: Medium]
Does this explicit KVM_DEV_ARM_VGIC_CTRL_INIT call defeat the purpose of
testing if the attribute is immutable after the VM has run?

The previous test block already verifies that an explicit INIT locks the
NR_IRQS attribute. By calling it here before run_vcpu(), the subsequent
__kvm_device_attr_set() will return EBUSY solely because of this explicit
INIT, masking whether KVM_RUN actually implicitly locks the attribute as
intended.

> =20
> -	if (++count >=3D 2)
> -		GUEST_DONE();
> +	nr_irqs =3D VGIC_V5_DEFAULT_NR_SPIS * 2;
> +	ret =3D __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
> +				    0, &nr_irqs);
> +	TEST_ASSERT(ret && errno =3D=3D EBUSY, "GICv5 NR_IRQS set after run");
> =20
> -	/* Ask for the next interrupt to be injected */
> -	GUEST_SYNC(GUEST_CMD_IS_READY);
> -}
> +	vm_gic_destroy(&v);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D41
