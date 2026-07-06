Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDD6305698;
	Mon,  6 Jul 2026 11:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783336407; cv=none; b=UwoQV0IgubTLy2LmgS3+/wCTwFJE7KC4izZbfDNBqyiyRdL6WDqsE/vtwfmWaHVZLhxOgQ2/P/ICX8q8qI9bVy2U6sCtGiq4mPQFzHu0FrD8sEpZ43wXkxc9UxCnVmoBN2OwH5Dc1N0GuNTuqGQ2cFpsgaSJIslpXCJTVngwqW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783336407; c=relaxed/simple;
	bh=eAPfHgsgztUwKbfWhNdcUsRQYC0U6AZV/3HLMsLI8zE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uCXZM14Mm7CVYxjet5NWhZccDschbhirQ1rNw3SX2/+AzwAveB+fZDtrhYztkxxVEBQ6dqgRA38DwUCJnaZgGF4pHuy24OAvV37SJ3E5adINLAnp0SS7ArQCK6VdH9X8hCbStSfEmYhL6B9GGOVLVbIkM+hh7jvqTv31YD1uU00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uniq0lh5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uniq0lh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70F81F000E9;
	Mon,  6 Jul 2026 11:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783336405;
	bh=x75Efjm4jUDg/OTRwR+YL51tKG+yW5kaRuK1wz80leI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Uniq0lh5lpuG3pSUiUXn0CG+9ysHTOUuzzgx6Psb8HIMuZbR4q+KYuvZfl8B3Nw2p
	 TY2AtdAPrLNopjKjVLC7zmTTgUgOP1tHyOG4HF0M88FUb4LPTNyxGDwfyOREDu13lJ
	 OEhMUukKbxN9o+kCRRDP047HtIFNgqG6mRt1OlKQZrS4BXxaWakTfqbUAB25+z7PcT
	 BQbH299VF9pU6wEolTvU2obH0IzD88Yn5X4S/9JchJIjE5JCm75RyBE2bI5Sj43THZ
	 /ken5wwGTZ72wmfc8bgpzQcPJnl5VrmKSf9Q30UWUj/dG29V6tFYs3cinLI3yBPcRr
	 ofcLm6zCX+mhQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 6/7] KVM: arm64: PMU: Introduce FIXED_COUNTERS_ONLY
Reply-To: sashiko-reviews@lists.linux.dev
To: "Akihiko Odaki" <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260706-hybrid-v8-6-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
References: <20260706-hybrid-v8-0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
 <20260706-hybrid-v8-6-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 06 Jul 2026 11:13:24 +0000
Message-Id: <20260706111324.E70F81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Host-userspace can trigger a WARN_ON_ONCE in KVM by scheduling a V=
CPU on a physical CPU without a PMU.
- [Medium] KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS can silently override the KV=
M_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY restriction.

Pre-existing issues:
- [High] kvm_arm_set_nr_counters() modifies MDCR_EL2 for all vCPUs without =
acquiring their vcpu->mutex, causing a data race with KVM_SET_ONE_REG.
--

commit 18166de56dc2a0622e0ddd3b21dbd03b3b4d6bd7
Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

KVM: arm64: PMU: Introduce FIXED_COUNTERS_ONLY

Introduce the KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY attribute to
create a "fixed-counters-only" PMU.

> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c

[ ... ]

> @@ -1151,6 +1153,22 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu =
*vcpu, int pmu_id)
>  	return ret;
>  }
> =20
> +static int kvm_arm_pmu_v3_set_pmu_fixed_counters_only(struct kvm_vcpu *v=
cpu)
> +{
> +	struct kvm *kvm =3D vcpu->kvm;
> +
> +	lockdep_assert_held(&kvm->arch.config_lock);
> +
> +	if (kvm_vm_has_ran_once(kvm) || kvm->arch.pmu_filter ||
> +	    test_bit(KVM_ARCH_FLAG_PMU_V3_EXPLICIT, &kvm->arch.flags))
> +		return -EBUSY;
> +
> +	set_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags);
> +	kvm_arm_set_nr_counters(kvm, 0);

[Severity: High]
Can an unprivileged host userspace trigger a WARN_ON_ONCE if they bind the
VCPU thread to a physical CPU without a PMU and run the VM?

If KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY is set, it appears
kvm_pmu_create_perf_event() will attempt to find a PMU using
kvm_pmu_probe_armpmu(vcpu->cpu):

arch/arm64/kvm/pmu-emul.c:kvm_pmu_create_perf_event() {
    ...
	if (kvm_pmu_fixed_counters_only(vcpu->kvm)) {
		arm_pmu =3D kvm_pmu_probe_armpmu(vcpu->cpu);
		if (WARN_ON_ONCE(!arm_pmu))
			return;
	}
    ...
}

If the CPU lacks a PMU, wouldn't this hit the WARN_ON_ONCE and act as a host
denial of service if panic_on_warn is set?


[Severity: High]
This is a pre-existing issue, but can this call to kvm_arm_set_nr_counters()
cause a data race with KVM_SET_ONE_REG?

Looking at kvm_arm_set_nr_counters(), it iterates over all vCPUs and modifi=
es
__vcpu_sys_reg(vcpu, MDCR_EL2) "behind their back" without acquiring their
vcpu->mutex:

arch/arm64/kvm/pmu-emul.c:kvm_arm_set_nr_counters() {
    ...
		kvm_for_each_vcpu(i, vcpu, kvm) {
			u64 val =3D __vcpu_sys_reg(vcpu, MDCR_EL2);
			val &=3D ~MDCR_EL2_HPMN;
			val |=3D FIELD_PREP(MDCR_EL2_HPMN, kvm->arch.nr_pmu_counters);
			__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
		}
    ...
}

Concurrently, userspace could call KVM_SET_ONE_REG on another vCPU to modify
MDCR_EL2 bits, leading to a read-modify-write corruption since the global
config_lock is not taken by KVM_SET_ONE_REG.

> +
> +	return 0;
> +}
> +
>  static int kvm_arm_pmu_v3_set_nr_counters(struct kvm_vcpu *vcpu, unsigne=
d int n)
>  {

[ ... ]

> @@ -1270,6 +1288,8 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, =
struct kvm_device_attr *attr)
> =20
>  		return kvm_arm_pmu_v3_set_nr_counters(vcpu, n);
>  	}
> +	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
> +		return kvm_arm_pmu_v3_set_pmu_fixed_counters_only(vcpu);

[Severity: Medium]
If userspace configures the PMU for fixed-counters-only, can this state be
silently overwritten if userspace subsequently calls
KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS?

The kvm_arm_pmu_v3_set_nr_counters() function does not check if
KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY is active:

arch/arm64/kvm/pmu-emul.c:kvm_arm_pmu_v3_set_nr_counters() {
    ...
	if (n > kvm_arm_pmu_get_max_counters(kvm))
		return -EINVAL;

	kvm_arm_set_nr_counters(kvm, n);
	return 0;
}

Could this allow exposing programmable counters to the guest despite being
configured for fixed-counters-only?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706-hybrid-v8-=
0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp?part=3D6
