Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793821076;
	b=BVZOfY7jIDU9ORHKqKTRh1H+YLPrwsTzfILvIzIvLrFCmFzOb3l/2meTy/Q5lDqldo7Q
	 FSSCnVBBCzJpWPm8+Hy+t54ifewij5lpp7WMfzfcBkBPyfww40Pd9RYQUvXmo/0tov5lA
	 d997ZHrZsbJCj01AaXIZBVGn9zN/pMMS7gbLqhWysGfwkNp8MyhFcHoJngV+QfqepdjX6
	 Zw6uTH0oWcy9TAlZCE3XgcDd0l/DsKrBBDeFg4lFZopvhH4FRQZs3vA+/6uXQZN0D/lQP
	 ZEJdGjoY+MEB7C1VU+UuCis8Yvi1mGN3jyYwqFjrjcGZ8CuWWzvXTnJeG8RlBWDwAdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793821076;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QVysjEVRogPF+B3yzd6pfisjlcvHAyVumWQT5W125rY=;
	b=LRV2aHq5d6oMY+PgdPj/UM4yaasz1FCv6TcU+LD18BDtV/cPNt2chB+0jVaWBbfJT7ey
	 T1kdqPnFZsjc+yjVNvzYWNek2VwPxEGV2/T58HdNqqtMDpkUPgHfLqBewlExtxDl6NRGV
	 LBCghdoOjUGb5anj3d66UAI9VvsgJRxJ9s2iuZ9e/fHCjWln4s82FJspz+sA7BnGTKZ3l
	 dHZ1Zoz5wCwfZiq2uQ46UMn+vRCHPP7fClIwxod3z7Yhs1HR8XHq8OoY2BAz8kEoj1SqZ
	 Rw1vTGfkQ4CHfVy84At3Bd5YJIIJ1dFcB/q4S4RR7l2iD3IJbpPQD2IhUXWDwwzC8oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HBtDzDXB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A931260B4C2C
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 19:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HBtDzDXB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6CA1F0093A;
	Wed,  4 Nov 2026 19:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821075;
	bh=QVysjEVRogPF+B3yzd6pfisjlcvHAyVumWQT5W125rY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HBtDzDXBP0KRzJYiZn7wRkvZMckJAN761k0CFcivH6xpmesI76n1nUrk6ABAsdWO7
	 Ek7sqm2CB6KqrHeGy0kvRitjhgKZ8DtMdAJMjIyPpB88a7eDcYIt1UTZKlpF3IKquY
	 lj4dZAJoBM5HtVqdis4RJLaX+ttuH5ZaOcUq0qml1oKEGCTUbPk38BVeW8MdUBOb8H
	 IIonoxBGI3f3/RBxzXQhnzsl9qTdxnpWcuN88zur9azBqPyncqcuc5QofGGo42HZmF
	 ehN363AefG5SwO7FcPrvtwnTwOs8husyhVBv0rNUFHgasi2tiicRrUsUN4v25284KG
	 k/MNZpPOC4uQg==
Message-ID: <sashiko-outbox-197967@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/8] KVM: arm64: nv: Disallow KVM_CAP_ARM_MTE + FEAT_EL2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
Cc: "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261104192124.3932743-2-oupton@kernel.org>
References: <20261104192124.3932743-1-oupton@kernel.org>
 <20261104192124.3932743-2-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 19:37:54 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] KVM: arm64: rejecting MTE with EL2 breaks set_id_regs selftest o=
n NV+MTE hosts
--

commit 6863183ae448414619eb0267884e7d66bfaf521c
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: nv: Disallow KVM_CAP_ARM_MTE + FEAT_EL2

This commit updates kvm_vcpu_init_check_features() to return -EINVAL when
KVM_ARM_VCPU_HAS_EL2 is requested on a VM that has KVM_CAP_ARM_MTE enabled.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 157bf4b812020..a750413c684be 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1793,13 +1793,15 @@ static int kvm_vcpu_init_check_features(struct kv=
m_vcpu *vcpu,
>  	    !test_bit(KVM_ARM_VCPU_PMU_V3, &features))
>  		return -EINVAL;
> =20
> +	/* MTE is incompatible with AArch32 and nested virt */
> +	if (kvm_has_mte(vcpu->kvm) &&
> +	    (test_bit(KVM_ARM_VCPU_EL1_32BIT, &features) ||
> +	     test_bit(KVM_ARM_VCPU_HAS_EL2, &features)))
> +		return -EINVAL;

[Severity: Medium]
Does rejecting KVM_ARM_VCPU_HAS_EL2 when kvm_has_mte(vcpu->kvm) is true bre=
ak
the arm64 set_id_regs selftest on hosts that support both MTE and nested
virtualization?

In tools/testing/selftests/kvm/arm64/set_id_regs.c, main() enables MTE and
then creates a default vCPU:

tools/testing/selftests/kvm/arm64/set_id_regs.c:main() {
	...
	test_wants_mte();

	vm =3D vm_create(1);
	vm_enable_cap(vm, KVM_CAP_ARM_WRITABLE_IMP_ID_REGS, 0);
	vcpu =3D vm_vcpu_add(vm, 0, guest_code);
	...
}

During vm_create(), kvm_arch_vm_post_create() in
tools/testing/selftests/kvm/lib/arm64/processor.c enables KVM_CAP_ARM_MTE on
the VM when request_mte is set:

	if (request_mte && vm_check_cap(vm, KVM_CAP_ARM_MTE))
		vm_enable_cap(vm, KVM_CAP_ARM_MTE, 0);

Then during vm_vcpu_add() -> aarch64_vcpu_setup() ->
kvm_get_default_vcpu_target(), the selftest library checks vm_supports_el2()
and sets KVM_ARM_VCPU_HAS_EL2 by default on NV-capable hosts:

tools/testing/selftests/kvm/lib/arm64/processor.c:vm_supports_el2() {
	return vm_check_cap(vm, KVM_CAP_ARM_EL2) && vm->arch.has_gic;
}

tools/testing/selftests/kvm/lib/arm64/processor.c:kvm_get_default_vcpu_targ=
et() {
	...
	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &preferred);
	if (vm_supports_el2(vm))
		preferred.features[0] |=3D BIT(KVM_ARM_VCPU_HAS_EL2);
	...
}

Because kvm_vm_ioctl_check_extension() in arch/arm64/kvm/arm.c still reports
KVM_CAP_ARM_EL2 as supported on a VM fd where KVM_CAP_ARM_MTE was enabled:

	case KVM_CAP_ARM_EL2:
		r =3D cpus_have_final_cap(ARM64_HAS_NESTED_VIRT);
		break;

and vm_supports_el2() does not check !request_mte, aarch64_vcpu_setup() pas=
ses
KVM_ARM_VCPU_HAS_EL2 to KVM_ARM_VCPU_INIT, which now fails with -EINVAL unl=
ess
the test is run with NV=3D0.

Should kvm_vm_ioctl_check_extension() gate KVM_CAP_ARM_EL2 on
!kvm_has_mte(kvm) (or vm_supports_el2() check !request_mte) so userspace and
selftests do not request EL2 on MTE-enabled VMs?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104192124.3932=
743-1-oupton@kernel.org?part=3D1
