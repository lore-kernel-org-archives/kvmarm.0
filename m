Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4032134A3A5;
	Fri, 12 Jun 2026 19:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781294045; cv=none; b=rZKmXAk7JJGOv/o8HYmt2kMg7hjSo9JVN/AiP5/uTSGQWQ58BR00BJIQfm3B6bCZivtO/JeeyUs8GnNsEQXcisk/SaToDoyf7k9haYlj3hYCOL+xl6jDJAawOkO95cB1dQXGe/dcG8iyHzZSP523J1Kyq85ZzPNZUurhbfO94lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781294045; c=relaxed/simple;
	bh=qDj97zdXKxC09uJyUJ+sXpSoCnZxbTgAj2YMGPrfADo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A27S/ple+waQXNvrefGnl4KyrX9sbodWQqXmgPwRtBSYr6DR4Ecne4BG3UG3g/sd/kZcV2pcnYB18Zu1Dhly/XzxNYVqP3biy+qcgGeGzK2+P7Qv6s6tjqk1Idtm9XlbymQ07q/hWFLAi+4DkQP0e383MpJWQ1r0rFjHeOYtiK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nP4rCf47; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nP4rCf47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24D21F000E9;
	Fri, 12 Jun 2026 19:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781294043;
	bh=cv4xbaRmbA/uYMQyLGyxpFxV+CehEPFOTxKOvffz4y0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nP4rCf47Wj3+XWKMK0ya8JMkkUZH/8yXOal8zD9N6v6SOiFFm9uFRoyFGuBRXCfK4
	 WnQ4kDyMH/15TRUZ1ZaJwVXHoeTz4n0HwXIsmpBD/nNCxd6yy+GI12nScE390cN/Yq
	 FCwuY9jy2zK/wPA7uozcwCAQzeaWz1QODwfDJQlxGYFSxLIQkD8NdikZREj84OpbDF
	 tiAKwiFYx2K4nVQBePAC0zFDGgAk/9LcRkVhxfavrJr/v66CVyDJ2U9C1j28DEd4zW
	 l239v2rdFpmMHX4iu5a4WKCmhFJLXhR0J+xiPIK8AKaRWM8GNcadXcABTYeJJmeKsV
	 V2W8PnYB5VCKA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 18/21] KVM: arm64: Add vCPU device attr to partition the
 PMU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260612192909.1153907-19-coltonlewis@google.com>
References: <20260612192909.1153907-19-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 19:54:03 +0000
Message-Id: <20260612195403.A24D21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Unprivileged host userspace can trigger a host kernel panic (NULL =
pointer dereference) by calling KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION before=
 the VM's PMU is initialized.
- [Medium] `kvm_arm_pmu_v3_has_attr()` incorrectly advertises support for t=
he `KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION` attribute on systems that do not =
actually support it, breaking live migration.
--

commit 69324cfdaa77bd05919e5ffe00139f0a4c7a3e0c
Author: Colton Lewis <coltonlewis@google.com>

KVM: arm64: Add vCPU device attr to partition the PMU

Add a new PMU device attr to enable the partitioned PMU for a given
VM. This capability can be set when the PMU is initially configured
before the vCPU starts running.

> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> index f5ee18b4dfae7..4e15948ac2565 100644
> --- a/arch/arm64/kvm/pmu.c
> +++ b/arch/arm64/kvm/pmu.c
> @@ -769,6 +769,28 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, s=
truct kvm_device_attr *attr)
> =20
>  		return kvm_arm_pmu_v3_set_nr_counters(vcpu, n);
>  	}
> +	case KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION: {
> +		unsigned int __user *uaddr =3D (unsigned int __user *)(long)attr->addr;
> +		u32 val;
> +
> +		if (get_user(val, uaddr))
> +			return -EFAULT;
> +
> +		if (!has_kvm_pmu_partition_support())
> +			return -EPERM;
> +
> +		if (kvm_vm_has_ran_once(kvm))
> +			return -EBUSY;
> +
> +		kvm_pmu_partition_enable(kvm, val);
> +		if (val) {
> +			unsigned int max_counters =3D kvm_arm_pmu_get_max_counters(kvm);

[Severity: High]
Can an unprivileged host userspace process trigger a NULL pointer
dereference here if the PMU is not yet initialized?

If KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION is called before the PMU is
initialized, kvm->arch.arm_pmu will be NULL.

When this code calls kvm_arm_pmu_get_max_counters(), it dereferences the
NULL pointer inside bitmap_weight():

arch/arm64/kvm/pmu.c:kvm_arm_pmu_get_max_counters() {
    struct arm_pmu *arm_pmu =3D kvm->arch.arm_pmu;
    ...
    return bitmap_weight(arm_pmu->cntr_mask, ARMV8_PMU_MAX_GENERAL_COUNTERS=
);
}

> +
> +			if (kvm->arch.nr_pmu_counters > max_counters)
> +				kvm_arm_set_nr_counters(kvm, max_counters);
> +		}
> +		return 0;
> +	}
[ ... ]
> @@ -808,6 +830,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, st=
ruct kvm_device_attr *attr)
>  	case KVM_ARM_VCPU_PMU_V3_FILTER:
>  	case KVM_ARM_VCPU_PMU_V3_SET_PMU:
>  	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS:
> +	case KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION:
>  		if (kvm_vcpu_has_pmu(vcpu))
>  			return 0;
>  	}

[Severity: Medium]
Does this incorrectly advertise support for KVM_ARM_VCPU_PMU_V3_ENABLE_PART=
ITION
on systems that don't support it?

If kvm_arm_pmu_v3_has_attr() returns 0 as long as the VCPU has a PMU, VMMs
might assume the partition capability is available.

However, setting this attribute in kvm_arm_pmu_v3_set_attr() explicitly
rejects the configuration if has_kvm_pmu_partition_support() is false:

arch/arm64/kvm/pmu.c:kvm_arm_pmu_v3_set_attr() {
    ...
    case KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION: {
        ...
        if (!has_kvm_pmu_partition_support())
            return -EPERM;
    }
}

Could this inconsistency cause live migrations to fail when the VMM attempts
to restore this attribute on a destination that lacks partition support?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612192909.1153=
907-1-coltonlewis@google.com?part=3D18
