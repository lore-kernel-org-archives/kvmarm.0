Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F83DDA9;
	Thu, 24 Sep 2026 17:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790272564; cv=none; b=TFINDqRlOYByNTWEIACRjTOqDyRxWSNUL6YIBNCxyK4+9gSBQTFNWFFXNwgOFHNBIBM5QQp4SvQoqo9c0/PBR5K1UXmddt/xXNmJ1jZISl2BGvlD9e+6W7n5Y3qMzLUHAmIXuFCDzxvfzniJUOkekYSPNLmLXbfrHlNi5is50kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790272564; c=relaxed/simple;
	bh=CL7UhkDtsQCO9nkLLO+rc2XF2T9+StCSxMdveizu6r4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VsvCcQbwHtB207BIEbjax0O/VqqXVZp2kU2OpFrPQwWzGndh/xgXQD4588hzUHyd3fD3lj836MPUqEuCz1iLfAiZ/JMUBMPCu9SpSFSuyLUgNA9Gq6AoBDq/2IVSHY6JDBqad3SZxceFqtbj+SyOsI1LJVx5Qv/2zXewTZawOzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kc5voWnC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kc5voWnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF961F000FF;
	Thu, 24 Sep 2026 17:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790272563;
	bh=gH8IjpYzIbp1e+Ri/K5UWLu/0JF761wIBpaWONjm+n8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kc5voWnCQ/S/xq6VKq+4BFlLC/wjKBCPou3ekfIJfxCknJZPFa1OGv5I3BtUp8Ami
	 eCqo0P8TmASTC/HkjVe6kV3Z6/W2kJZ8YrNRbflBph3d+74+wwVaH6pl06bFTHrdxf
	 r5sDYyDW0suZEbV7j4XVwkTaJVkj4CMLPziQpy5QaETjKxJPNjFO+E1Tuk5pJuTBoS
	 llw54YBek/Kol5R+nKDzPngtPUYEqgs0A8Eg2E5X6S6XnMVOu4afw2xFIOPSr3agYR
	 HAnDmnYuklPgipUvNejolxMgI1eQ4YbmNqnR8WQkacPb5oIvRZK2KtvqjMCXmllosb
	 Iqykz+nqNtZ9w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 20/22] KVM: arm64: Add vCPU device attr to partition
 the PMU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260924172928.2110956-21-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-21-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:56:02 +0000
Message-Id: <20260924175602.9FF961F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] kvm: Missing FEAT_HPMN0 validation allows PMU partition mismatch=
 breaking host profiling
--

commit 35f982d966d35bba8af3b23d939070b539de71cf
Author: Colton Lewis <coltonlewis@google.com>

KVM: arm64: Add vCPU device attr to partition the PMU

This commit introduces the KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION attribute=20
to enable partitioned PMU support for a VM. When partitioning is enabled,
userspace must configure the number of guest event counters strictly less=20
than the maximum implemented by the PMU, reserving at least one for host=20
profiling.

> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> index 4a3c6600b2678..31e46a5e937c7 100644
> --- a/arch/arm64/kvm/pmu.c
> +++ b/arch/arm64/kvm/pmu.c
[ ... ]
> @@ -667,14 +694,26 @@ static int kvm_arm_pmu_v3_set_nr_counters(struct kv=
m_vcpu *vcpu, unsigned int n)
>  {
>  	struct kvm *kvm =3D vcpu->kvm;
> +	unsigned int max_counters;
> +
> +	if (kvm_vm_has_ran_once(kvm) ||
> +	    (kvm_arm_pmu_any_vcpu_created(kvm) &&
> +	     (!kvm->arch.pmu_nr_counters_specified ||
> +	      kvm->arch.nr_pmu_counters !=3D n)))
> +		return -EBUSY;
> =20
>  	if (!kvm->arch.arm_pmu)
>  		return -EINVAL;
> =20
> -	if (n > kvm_arm_pmu_get_max_counters(kvm))
> +	max_counters =3D kvm_arm_pmu_get_max_counters(kvm);
> +	if (n > max_counters)
> +		return -EINVAL;
> +
> +	if (kvm_pmu_is_partitioned(kvm) && n >=3D max_counters)
>  		return -EINVAL;
> =20
>  	kvm_arm_set_nr_counters(kvm, n);

[Severity: Medium]
The commit message states that the number of guest event counters must be=20
configured "with a value strictly less than the maximum... or 0 only when=20
FEAT_HPMN0 is supported".=20

Is the FEAT_HPMN0 check missing from kvm_arm_pmu_v3_set_nr_counters() here?

If n is set to 0 on hardware without ARM64_HAS_HPMN0, the hardware fallback
in debug.c will prevent a panic by leaving HPMN set to max_counters. Howeve=
r,
kvm_pmu_host_counter_mask() will still assume all counters belong to the=20
host.=20

Because the hardware assigns all counters to the guest partition in this=20
state, does this mismatch break host-side performance profiling?

[ ... ]
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 20c46ef705d30..a4779593c4f8d 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
[ ... ]
> @@ -1756,7 +1756,10 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const s=
truct sys_reg_desc *r,
>  	if (!kvm_vm_has_ran_once(kvm) &&
>  	    !vcpu_has_nv(vcpu)	      &&
>  	    !kvm_vcpu_has_pmuv3_strict(vcpu) &&
> -	    new_n <=3D kvm_arm_pmu_get_max_counters(kvm))
> +	    !kvm->arch.pmu_nr_counters_specified &&
> +	    new_n <=3D kvm_arm_pmu_get_max_counters(kvm) &&
> +	    (!kvm_pmu_is_partitioned(kvm) ||
> +	     new_n < kvm_arm_pmu_get_max_counters(kvm)))
>  		kvm->arch.nr_pmu_counters =3D new_n;

[Severity: Medium]
Can userspace also bypass the FEAT_HPMN0 validation by writing a 0 to=20
PMCR_EL0.N via SET_ONE_REG?

Without a check for FEAT_HPMN0 in set_pmcr(), it appears nr_pmu_counters=20
could be set to 0, which would lead to the same host profiling breakage=20
described above.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D20
