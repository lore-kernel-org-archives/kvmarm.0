Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F451C5D7D;
	Wed, 22 Jul 2026 20:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784753280; cv=none; b=cJDLco0pEPswykplG5YGpTAE7xEqEESeFwEPustmqVVSb9DMUXYGtolnsDRpRG1nO/EtPD2dYi3J+TW0L8b0PkmuvxeJt1SeQIMlqcgkaubOyEYVCadSUufgz25OCKfCUG8qgkCuaFY7+PCW+iwHcD+bw8E3YjpVOTL1feJY7f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784753280; c=relaxed/simple;
	bh=mSbmySZA2UdLNjWAFBB5hbfBN74YYzC2hAeAAVvlIsE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eZanDPey9QyS+D2JOJyV9bygKDKB3BxWvgIc9lJASMSw9Vw99k/07rAW3hqIWjklGea0dq4WSQJvqoZKR/tJXdL8JWb5Wpvdzt/VDVbm6J9eejljjHLGLoOG8YKLtAPcSaSoBl01xwaNgg2Zvn+rvNcGSvCuJoO9oityGPeQ5j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LePc2PUI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LePc2PUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1582A1F000E9;
	Wed, 22 Jul 2026 20:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784753279;
	bh=Pv4OQhNBWKt8Rr5QVZJ/xO6KR1dueDn1Minq4iiHVu8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LePc2PUIewbbIhSYR6ztGqq0QJNM5y7jpwvM0ljJX71P975ZLLTVB/hk4TXBBJRG7
	 fdbN9ahdKAW/7KR6oXB48MyDP/gn4yN1b7bEqGLOAaF2Z3j+qwiJj8XeVIq5IaGJ76
	 L9kNLy/Mwp4J5uiyUp7TyuU2p7zuuQG8qLg3B1qT0QZeithyjZ79EoR/ydG2fGn3fR
	 tDSpjCCZNI5SDpiAqCzflQLNEPYUE+n44eDRSjcQrvAJVFHrVlS02SXRxxzzIrvDdq
	 T3wXOLe4e2SvHu+oNgtjISpOFlTbqEE52Ms4GQ2gYMraBP8DheI3pO9/qeKc+/xhw1
	 zYwcVtHaYskKw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/4] KVM: arm64: Expose PMMIR_EL1.SLOTS under strict
 PMUv3 UAPI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Congkai Tan" <congkai@amazon.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260722202702.4165917-2-congkai@amazon.com>
References: <20260722202702.4165917-1-congkai@amazon.com>
 <20260722202702.4165917-2-congkai@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 20:47:58 +0000
Message-Id: <20260722204759.1582A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The implementation of `KVM_ARM_VCPU_PMU_V3_STRICT` introduces two =
logic errors that completely break the new feature and its API contract:
1. `KVM_VCPU_MAX_FEATURES` was not increased from 9 to 10 to accommodate th=
e new flag (which is defined as 9). As a result, `KVM_VCPU_VALID_FEATURES` =
excludes bit 9, causing `kvm_vcpu_init_check_features()` to unconditionally=
 reject `KVM_ARM_VCPU_INIT` ioctls with `-ENOENT` when this feature is requ=
ested.
2. Even if the feature validation were fixed, the code fails to enforce the=
 documented 'No default PMU creation' behavior. `kvm_setup_vcpu()` uncondit=
ionally calls `kvm_arm_set_default_pmu()` if `kvm_vcpu_has_pmu()` is true, =
without checking if the strict flag is set. Thus, KVM will always assign a =
default PMU on initialization, defeating the stated purpose of the flag.
--

--- Patch [1]: [PATCH v3 1/4] KVM: arm64: Expose PMMIR_EL1.SLOTS under stri=
ct PMUv3 UAPI ---
commit 5883b44965f93aed147ca4ed5fb390ae481daa37
Author: Congkai Tan <congkai@amazon.com>

KVM: arm64: Expose PMMIR_EL1.SLOTS under strict PMUv3 UAPI

This commit introduces a new VCPU feature flag KVM_ARM_VCPU_PMU_V3_STRICT
to prevent KVM from automatically creating a default PMU, and exposes
the PMMIR_EL1.SLOTS value to the guest when a PMU is explicitly selected.

> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/=
asm/kvm.h
> index 1c13bfa2d38aa..019e5e3d892e6 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -106,6 +106,7 @@ struct kvm_regs {
>  #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authenticati=
on */
>  #define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
>  #define KVM_ARM_VCPU_HAS_EL2_E2H0	8 /* Limit NV support to E2H RES0 */
> +#define KVM_ARM_VCPU_PMU_V3_STRICT	9 /* No default PMU creation */

[Severity: High]
Does KVM_VCPU_MAX_FEATURES need to be updated to 10 to support this new fla=
g?

Currently, KVM_VCPU_MAX_FEATURES in arch/arm64/include/asm/kvm_host.h is 9,
so KVM_VCPU_VALID_FEATURES (BIT(KVM_VCPU_MAX_FEATURES) - 1) only covers bits
0 through 8. When userspace attempts to use this new flag (bit 9),
kvm_vcpu_init_check_features() will reject it with -ENOENT.

Additionally, does this patch actually prevent default PMU creation?=20

Looking at kvm_setup_vcpu() in arch/arm64/kvm/arm.c:

	if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu)
		ret =3D kvm_arm_set_default_pmu(kvm);

It appears that kvm_arm_set_default_pmu() will still be called on
initialization even if the strict flag is set, since there is no check for
kvm_vcpu_has_pmuv3_strict(vcpu) here.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722202702.4165=
917-1-congkai@amazon.com?part=3D1
