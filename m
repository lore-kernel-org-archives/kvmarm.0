Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC8B2F90E0;
	Fri,  7 Aug 2026 17:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786125406; cv=none; b=BAUCk3rwlbZQXiqpNVbnd7ZDt0Y3S4u5/btbM3sj5hVea503jCgG3X6JZ7OhnPQlzVwgPFDfx92HBOLZMIycw9mpOIFRvaI0kMt92GJobBHwZ8Nn2Vs9h4nwdZJxmDWUMiK6XZ2ZXZZvlEtCOy/4ZMvHaRFW1bjWdGipYpZfVuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786125406; c=relaxed/simple;
	bh=/F8g3hn+CZXUuvErPv7ZJ40nbSL4yVUr6mpZuXdRREs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OrzL8pzYdxhwTNmhk8t3pcj6eKI7ZtPQ2jGUjtOAiklAUQTPtLNJajCdGw3OnmfQ+Sh4wHSsxf35IMPQKlUUXuUQEsIPyr/jRwQKMWnEeqTl5GYVl1/xC3aYXd3E7RdXeW58eaLNIwBWxfcF3pFrDuswKH7f+4oZ1lybOxOyGNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B5awmsXD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B5awmsXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF0F1F000E9;
	Fri,  7 Aug 2026 17:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786125405;
	bh=CEymFZY2mD/zQE+VUavnk50VCoErSEENfguvLRPB/fw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B5awmsXDUmF+e3X54kMWVpaNwa7NLFc6czbCWAEe9xIXAj2xha/RIcb4/2NUOzs+X
	 bAebLrCrDjhWjZKGGriYWJghqjqvrd81CpxT7zetE6S/ASNz4LzH0yONIpgn31uc4Q
	 XSQ5w2ICSbgFyV+ZihjhmUXniozwD9I1uorbMqX/20CpW7jvmHHXZxDFTexBfVFXkY
	 QLVNDC4arjBPPF8eZH7uIFBz7/dsAZ2wGpHhbMvaoUXVYIP3dP63Ei0ZYo8wsT3Evh
	 7hBUVLR3voDU3hfv85GCtNULeCZpKy8RvsmOKtg4Z3QWbwNAC/zh/BzIxeaFcvIebG
	 4TSYKJhW5mKQA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 49/49] KVM: selftests: Add VGICv5 sparse vCPU IDs
 test
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260807111159.429128-50-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-50-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 17:56:44 +0000
Message-Id: <20260807175645.0FF0F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] The VGICv5 sparse vCPU IDs test uses an out-of-bounds vCPU ID of=
 512 to verify GICv5 VPE ID validation, but KVM core globally rejects IDs >=
=3D 512, making the test a false positive.
- [Medium] The VGICv5 sparse vCPU IDs test hardcodes a vCPU ID of 17, which=
 will cause spurious test failures on hardware that supports 16 or fewer VP=
Es per VM.
--

--- Patch [49]: [PATCH v5 49/49] KVM: selftests: Add VGICv5 sparse vCPU IDs=
 test ---
commit 253db5fcbd1548e3eb0e84e65ece4ca5747e50c2
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: selftests: Add VGICv5 sparse vCPU IDs test

GICv5 uses the userspace-provided vCPU ID as the VPE ID. This must
work when vCPU IDs are sparse and differ from the dense internal vCPU
index.

Add a test that creates vCPUs with IDs 17 and 3, verifies that a vCPU
with ID 512 is rejected after a GICv5 has been created, and runs both
vCPUs to check that ICC_IAFFIDR_EL1 reports the correct VPE IDs on
each.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/=
selftests/kvm/arm64/vgic_v5.c
> index 47e147bc14b87..3eef2d2da595f 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
> @@ -14,6 +14,10 @@

[ ... ]

> +static void test_vgic_v5_sparse_vcpu_ids(void)
> +{
> +	struct kvm_vcpu *vcpus[VGIC_V5_SPARSE_NR_VCPUS];
> +	const u32 vcpu_ids[VGIC_V5_SPARSE_NR_VCPUS] =3D {
> +		VGIC_V5_SPARSE_VCPU0_ID,
> +		VGIC_V5_SPARSE_VCPU1_ID,
> +	};
> +	int ret, i;
> +	struct ucall uc;
> +	struct vm_gic v;
> +	u64 attr;
> +
> +	v.gic_dev_type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
> +	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, VGIC_V5_SPARSE_NR_VCPUS, 0);
> +	v.gic_fd =3D kvm_create_device(v.vm, v.gic_dev_type);
> +
> +	/*
> +	 * A GICv5 VM cannot create a vCPU outside the VPE ID range. We've
> +	 * already created a GICv5, so it should reject VCPU creation.
> +	 */
> +	ret =3D __vm_ioctl(v.vm, KVM_CREATE_VCPU,
> +			 (void *)(unsigned long)VGIC_V5_SPARSE_TOO_BIG_ID);
> +	TEST_ASSERT(ret < 0 && errno =3D=3D EINVAL,
> +		    "GICv5 accepted vCPU ID %u", VGIC_V5_SPARSE_TOO_BIG_ID);

[Severity: Medium]
Will this test actually verify the GICv5 validation logic as intended?

The test unconditionally calls KVM_CREATE_VCPU with VGIC_V5_SPARSE_TOO_BIG_=
ID
(which is 512). The KVM core's kvm_vm_ioctl_create_vcpu() will immediately
return -EINVAL because the ID is >=3D KVM_MAX_VCPU_IDS (which defaults to 5=
12
on ARM64).

This happens before any architecture-specific or GICv5 validation is reache=
d,
potentially making this test a false positive.

> +
> +	/* Now, create two vCPUs with legal, albeit sparse, IDs */
> +	for (i =3D 0; i < ARRAY_SIZE(vcpus); i++) {
> +		vcpus[i] =3D vm_vcpu_add(v.vm, vcpu_ids[i], guest_iaffid_code);
> +		TEST_ASSERT(vcpus[i], "Failed to create vCPU %u", vcpu_ids[i]);

[Severity: Medium]
Could hardcoding the vCPU ID to 17 cause spurious test failures on some
hardware?

The test unconditionally adds a vCPU with ID 17 (VGIC_V5_SPARSE_VCPU0_ID).
In KVM ARM64, a VM's max_vcpus is bounded by hardware capabilities (for
example, GICV5_IRS_IDR4_VPE_ID_BITS).

If the hardware supports 16 or fewer VPEs per VM, the KVM_CREATE_VCPU ioctl
for ID 17 will be legitimately rejected by KVM with -EINVAL, which triggers
this TEST_ASSERT and fails the test.

> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D49
