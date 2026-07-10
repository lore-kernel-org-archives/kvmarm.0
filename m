Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C8441C2F1;
	Fri, 10 Jul 2026 11:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783683432; cv=none; b=BGW5AotjIHb46dRMabcwxB4v2gg8sRw0HEg+q6jlsyifyddrshxvMcI+j0rN6xRVYjRP04x3+pbZNSgT/r4q9UCNVyV+s2zzf/M3V95IVMbIBb0ZvZCOiU3mtB0CFXYoeO/iRnqD+iCQszsjmYCkuowCNtTjfrBoN1lG0cyvc94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783683432; c=relaxed/simple;
	bh=aFQY1JD9s0BZHVyPRbrSlJwhgcR2hayw7WgcrR66eAI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KvZSAc0VRhEaLmhkhsFJfFp9EvfhUeG71HbyONiNGIo99bNc+uWZj9dHyhOxHiX56nH9giKCg7+BtQP0xAFQgMmy2s6nnEOcRjIyLZTN43dudP8P+eWKNazARui6A/pB2pxOyo28yyc3h+l412vl/QXVcsSHfM0LT2oIbRA2dDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UjP8gyyl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UjP8gyyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACAF1F00ACA;
	Fri, 10 Jul 2026 11:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783683412;
	bh=hTwYAgULWrPKG6RKZXrlIntLYkaQj8bWJeudK/Uy2b8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UjP8gyylkoBjH6jjDBy/EoXO9m8gV5Urnw6Paty8TCT6dqQ2Nw9XqX/AL3nsC2SfE
	 UhqIxNSJPvBSsImTTr2vyfEpb4cxPkRnz65Ur0QdCoflT+TAcIEKjBN8SJckuZ8waC
	 0BKWv1UU2TImZX9crtmhLsRSUuM5ly6gfMzF133yiiU0JvAN4+ufvlR6s1m121BuKU
	 uPTHLl5ikZJ0Otab+6a6M47xe/unSjYi9CIULdU6YdyOmwOvQQj9ylkTeWkSN7WuoI
	 4dftE5xg7jab9RyR6zkNF0oFZ/WXgl3vEPQAaydQ0xRrzDI3s27TCmG44vKIYgmkB0
	 kx3JNix0xaAXw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 01/11] KVM: arm64: Serialize userspace MDCR_EL2
 access
Reply-To: sashiko-reviews@lists.linux.dev
To: "Akihiko Odaki" <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260710-hybrid-v8-1-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
References: <20260710-hybrid-v8-0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
 <20260710-hybrid-v8-1-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 11:36:51 +0000
Message-Id: <20260710113651.CACAF1F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing kvm_vm_has_ran_once() check allows KVM_ARM_VCPU_PMU_V3_SET=
_NR_COUNTERS to cause data races on MDCR_EL2 for running vCPUs.
- [High] Changes to MDCR_EL2 fields (HPMN, HPMD, HLP) fail to trigger a PMU=
 reload, leaving active perf events with a stale configuration.
- [High] Secondary KVM_ARM_VCPU_INIT calls bypass config_lock, causing data=
 races with PMU configuration on MDCR_EL2.
--

--- Patch [1]: [PATCH v8 01/11] KVM: arm64: Serialize userspace MDCR_EL2 ac=
cess ---
commit baa2d20fcb9f1e3b0daa7a4b72d1709acdab0380
Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

KVM: arm64: Serialize userspace MDCR_EL2 access

This patch addresses a race condition between PMU configuration and register
restore by adding explicit userspace accessors for MDCR_EL2. It serializes
these accesses using config_lock to ensure whole-register writes do not
conflict with HPMN rewrites.

> kvm_arm_set_nr_counters() updates MDCR_EL2.HPMN for every vCPU while
> holding kvm->arch.config_lock. However, KVM_SET_ONE_REG currently writes
> MDCR_EL2 through the generic sysreg path without taking the same lock.
> Concurrent PMU configuration and register restore can therefore race and
> lose updates to unrelated MDCR_EL2 bits.

[Severity: High]
This isn't a bug introduced by this patch, but does kvm_arm_set_nr_counters=
()
still have a race with running vCPUs?

Userspace can invoke KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS on an uninitialized
vCPU while another vCPU in the same VM is running. The ioctl handler in
arch/arm64/kvm/pmu-emul.c:kvm_arm_pmu_v3_set_attr() does not check
kvm_vm_has_ran_once(kvm).

It proceeds to call kvm_arm_set_nr_counters(), which performs a read-modify=
-write
of MDCR_EL2 across all vCPUs without acquiring their vcpu->mutex:

arch/arm64/kvm/pmu-emul.c:kvm_arm_set_nr_counters() {
	kvm_for_each_vcpu(i, vcpu, kvm) {
		u64 val =3D __vcpu_sys_reg(vcpu, MDCR_EL2);
		val &=3D ~MDCR_EL2_HPMN;
		val |=3D FIELD_PREP(MDCR_EL2_HPMN, kvm->arch.nr_pmu_counters);
		__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
	}
}

If a running vCPU concurrently traps on MDCR_EL2, access_mdcr() will perfor=
m a
racing read-modify-write. Could this cause data corruption of the guest's
MDCR_EL2 sysreg?

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 33c921df19b54..6ab46f21aa614 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c

[ ... ]

> +static int set_mdcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +		    u64 val)
> +{
> +	struct kvm *kvm =3D vcpu->kvm;
> +	u64 old, hpmn =3D FIELD_GET(MDCR_EL2_HPMN, val);
> +
> +	guard(mutex)(&kvm->arch.config_lock);

[Severity: High]
This isn't a bug introduced by this patch, but does the use of config_lock =
here
completely prevent races with KVM_ARM_VCPU_INIT?

While this patch adds config_lock to serialize userspace writes against
kvm_arm_set_nr_counters(), MDCR_EL2 is also updated during KVM_ARM_VCPU_INI=
T.

For secondary inits (already initialized vCPUs), the config_lock is bypasse=
d:

arch/arm64/kvm/arm.c:kvm_vcpu_set_target() {
	if (!kvm_vcpu_initialized(vcpu))
		return __kvm_vcpu_set_target(vcpu, init);

	if (kvm_vcpu_init_changed(vcpu, init))
		return -EINVAL;

	kvm_reset_vcpu(vcpu);
	return 0;
}

This allows reset_mdcr() to read nr_pmu_counters and write MDCR_EL2 without
config_lock, which could race with kvm_arm_set_nr_counters() modifying all
vCPUs' MDCR_EL2 registers.

> +
> +	if (hpmn > vcpu->kvm->arch.nr_pmu_counters)
> +		return -EINVAL;
> +
> +	old =3D __vcpu_sys_reg(vcpu, MDCR_EL2);
> +	__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
> +
> +	/*
> +	 * Request a reload of the PMU to enable/disable the counters
> +	 * affected by HPME.
> +	 */
> +	if ((old ^ val) & MDCR_EL2_HPME)
> +		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
> +
> +	return 0;
> +}

[Severity: High]
This is a pre-existing issue, but does checking only HPME leave the PMU in a
stale configuration if other fields change?

Both the newly added set_mdcr() and the existing access_mdcr() only request=
 a
PMU reload when the MDCR_EL2_HPME bit toggles. However, if fields like HPMN,
HPMD, or HLP change, shouldn't active perf events be re-evaluated to reflect
the new semantics?

If a guest or userspace modifies these fields but leaves HPME unchanged, co=
uld
host perf events count incorrectly or run with stale privilege exclusion
semantics?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710-hybrid-v8-=
0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp?part=3D1
