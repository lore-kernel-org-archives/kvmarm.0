Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C654B3A59A7;
	Fri, 12 Jun 2026 19:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781294201; cv=none; b=GghpZetlhr7wZna24HCZarXv+rHl+ZPSLdwH74DK6iD1/NcMW0DNZ3oIZYUYMNejuY5Zt9t3TVVnJMlgNGecuULSmR9PMhu84WhBn7xHVU8l1+JJMoh915S2g8+QkGnsRvYPoxRNKRiF30Lw6lcoVU9e8+Q0aboEDdPDJKNfFkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781294201; c=relaxed/simple;
	bh=8i1BUR47saKfcOHXtNaCJcxsCpCKvd67LmoeDydEG9U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rDa5j8LZEDwoCuS8IzzIH4qgC1zqPyRmzcfzvNRpqBGcgRrR3INJSRoFQ5BRw1eUyu7S1uIkvLDuBAu6mS8MEiKi1mYb97xTpIHoa4jk5ZBe+ZLprCXps9A81AM6TNMRtW3WETaiC5H7ssS9vQHYVUKiVUwwAz78xuipPS2GhX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DkBQ4DU0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DkBQ4DU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180B71F000E9;
	Fri, 12 Jun 2026 19:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781294197;
	bh=7fX47y6XAfTQt9a74/0clxVHKiRL+N63RyxjWiKBdBQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DkBQ4DU0/Z89sjr70eCKMdD4Vh/IotWKb1Xwg8lKQNqc6Kz89992FQd4ItbmeEf1E
	 lPk/UXmRjbFFEU1673lsfY8cXZZNkmCY/oRzGBQTz9uMQQGlVKH/EYF1UAXK5QWdzs
	 UP2Zzx6OAfAST/sICJ9STqUwf3OiwUT7T64JFmZzkhJOh6ZQvSml0bvXAPUDd+SxbK
	 F2wY/WeV9y6TvoYdADPfBczT6m38RnET06t5+QRRJ5152CuSx48Cx4kRjKOTFQqnJs
	 ertubY6izOemNUq1vH5LUtXxd04OQ+BBP+pwegLj8XHFAQ8klBWiy7uXVy3hxYpLgq
	 1pNzDKXmX7bmA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 03/21] KVM: arm64: Reorganize PMU functions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260612192909.1153907-4-coltonlewis@google.com>
References: <20260612192909.1153907-4-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 19:56:36 +0000
Message-Id: <20260612195637.180B71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS ioctl modifies VM-wide sta=
te and VCPU system registers without checking if the VM has already run, al=
lowing a data race with active VCPUs.
- [High] Host-userspace-reachable WARN_ONCE in __kvm_pmu_event_mask allows =
unprivileged userspace to trigger a Denial of Service.
--

commit 5436d8ff9f4b80e9bf5e0df08454fa9ddf4d9e29
Author: Colton Lewis <coltonlewis@google.com>

KVM: arm64: Reorganize PMU functions

A lot of functions in pmu-emul.c aren't specific to the emulated PMU
implementation. Move them to the more appropriate pmu.c file where
shared PMU functions should live.

> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> index 6b48a3d16d0d5..9ad3520417413 100644
> --- a/arch/arm64/kvm/pmu.c
> +++ b/arch/arm64/kvm/pmu.c

[ ... ]

> +static u32 __kvm_pmu_event_mask(unsigned int pmuver)
> +{
> +	switch (pmuver) {
> +	case ID_AA64DFR0_EL1_PMUVer_IMP:
> +		return GENMASK(9, 0);
> +	case ID_AA64DFR0_EL1_PMUVer_V3P1:
> +	case ID_AA64DFR0_EL1_PMUVer_V3P4:
> +	case ID_AA64DFR0_EL1_PMUVer_V3P5:
> +	case ID_AA64DFR0_EL1_PMUVer_V3P7:
> +		return GENMASK(15, 0);
> +	default:		/* Shouldn't be here, just for sanity */
> +		WARN_ONCE(1, "Unknown PMU version %d\n", pmuver);
> +		return 0;
> +	}
> +}

[Severity: High]
This is a pre-existing issue, but can this warning be triggered by
unprivileged host userspace?

The pmuver here is extracted from the guest's SYS_ID_AA64DFR0_EL1 register.
KVM allows userspace to downgrade ID registers using safe semantics, meaning
userspace might purposefully set an unhandled PMUVer (such as 2 or 3) via t=
he
KVM_SET_ONE_REG ioctl.

If this happens, wouldn't it hit this default case and trigger the warning,
potentially causing a host denial of service if panic_on_warn is enabled?

[ ... ]

> +static void kvm_arm_set_nr_counters(struct kvm *kvm, unsigned int nr)
> +{
> +	kvm->arch.nr_pmu_counters =3D nr;
> +
> +	/* Reset MDCR_EL2.HPMN behind the vcpus' back... */
> +	if (test_bit(KVM_ARM_VCPU_HAS_EL2, kvm->arch.vcpu_features)) {
> +		struct kvm_vcpu *vcpu;
> +		unsigned long i;
> +
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			u64 val =3D __vcpu_sys_reg(vcpu, MDCR_EL2);
> +
> +			val &=3D ~MDCR_EL2_HPMN;
> +			val |=3D FIELD_PREP(MDCR_EL2_HPMN, kvm->arch.nr_pmu_counters);
> +			__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
> +		}
> +	}
> +}

[ ... ]

> +int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_att=
r *attr)
> +{

[ ... ]

> +	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS: {
> +		unsigned int __user *uaddr =3D (unsigned int __user *)(long)attr->addr;
> +		unsigned int n;
> +
> +		if (get_user(n, uaddr))
> +			return -EFAULT;
> +
> +		return kvm_arm_pmu_v3_set_nr_counters(vcpu, n);
> +	}

[Severity: High]
This isn't a bug introduced by this patch, but does this ioctl bypass the
kvm_vm_has_ran_once() check applied to other VM-wide attributes?

If userspace initializes VCPU 0, starts it via KVM_RUN, and then invokes th=
is
ioctl on an uninitialized VCPU 1, the check for vcpu->arch.pmu.created at t=
he
start of kvm_arm_pmu_v3_set_attr() would pass.

Since kvm_arm_set_nr_counters() loops over all VCPUs and performs a
read-modify-write on MDCR_EL2 without taking vcpu->mutex or pausing VCPUs:

kvm_arm_set_nr_counters() {
    ...
    kvm_for_each_vcpu(i, vcpu, kvm) {
        u64 val =3D __vcpu_sys_reg(vcpu, MDCR_EL2);
        val &=3D ~MDCR_EL2_HPMN;
        val |=3D FIELD_PREP(MDCR_EL2_HPMN, kvm->arch.nr_pmu_counters);
        __vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
    }
}

Could this cause a data race on hypervisor control registers if VCPU 0 is
actively running, potentially allowing unprivileged userspace to corrupt
execution state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612192909.1153=
907-1-coltonlewis@google.com?part=3D3
