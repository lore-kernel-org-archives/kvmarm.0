Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5BF3806B8;
	Thu,  2 Jul 2026 19:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783020562; cv=none; b=o3LxaoN+ohYYCZoQLnQEMf84FaguhdvDrVVpD7EEKphB2L6Pu1QVxdy9ZmhSSpsWqONgFSn3CHF4EWpp5zV8VLPtrxDMqKZepRpQ/IpemjSpc8PZWSXsRihecowOZ3xZl+77D6oaj5drdyrS32va7V4Zx+Esq6+TpnV7ruvJYVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783020562; c=relaxed/simple;
	bh=eMTCveHf4b42UmPLsVog/6eKcO5YH1mS3KOYnWImkOM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XgGUKBtdjcxKTU2ffU+G9W1IUtEZZ0I/dkOuzPGF6UafzujzR/b28bFOi8P5mR/RFPDXgSDaEzLRWsa+8u8H5FXD9r9So9dCyKqnJz5FRdUC5WN1n1AYWVYK4F80xodXA8jEKIRuf3oBF7Hcl55sAy8rMvSN7gdeG8c3qAZWMvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=haEiZMQv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="haEiZMQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303A01F000E9;
	Thu,  2 Jul 2026 19:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783020558;
	bh=iZl9JDQIHjG62388ytP/5VgAVIl3zMuub6V9fDzeAuw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=haEiZMQvgIjuALSwDDApmPg2HIP2vPGtpoAg/SQqEpNtaPVpjuKIGOveQDx3Ltz8i
	 yHks9sDyTNrj6xuDWCgaNsojTPhDrMG/uUxoYRrf9PrnLXaWFybnniCi05F2+CzUwX
	 +nMs/Kavol4E3gosAOSEiRtzWR0hAzOroQb5yuywCiFPjRhAuxVOeP+omz20K1MPBI
	 Tnsm2UU6OYUqzyHP6pBX+bmTwL6913ivnhseMo/ayzwNsUDT7ixdBZIKTPmgQXUgK+
	 HR2nNhUJtPSPwwTSFTZnuqLHgETRZXuXy0BrlUngvO7WJBYwxuonMf7DdPgTiGtCKR
	 +p4+gBq/jEonw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/3] KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_STRICT vCPU
 feature
Reply-To: sashiko-reviews@lists.linux.dev
To: "Congkai Tan" <congkai@amazon.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260702190421.420992-2-congkai@amazon.com>
References: <20260702190421.420992-1-congkai@amazon.com>
 <20260702190421.420992-2-congkai@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 19:29:17 +0000
Message-Id: <20260702192918.303A01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Silent truncation of PMU event counter states and PMCR_EL0.N durin=
g VCPU sysreg restoration before PMU initialization.
--

commit 7651e4c8e75621127e5fba611a9aa7f3257fa4b2
Author: Congkai Tan <congkai@amazon.com>

KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_STRICT vCPU feature

This patch introduces the KVM_ARM_VCPU_PMU_V3_STRICT vCPU feature, preventi=
ng
KVM from creating a default PMU on initialization. Userspace must instead
explicitly select a PMU via KVM_ARM_VCPU_PMU_V3_SET_PMU before the first
KVM_RUN.

> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index e1860acae641f..1f24169505a91 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c

[ ... ]

> @@ -1021,6 +1024,14 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
>  {
>  	struct arm_pmu *arm_pmu =3D kvm->arch.arm_pmu;
> =20
> +	/*
> +	 * Under KVM_ARM_VCPU_PMU_V3_STRICT no PMU exists until userspace sets
> +	 * one, so this can be reached before arm_pmu is set. Report no
> +	 * counters in that case.
> +	 */
> +	if (!arm_pmu)
> +		return 0;
> +

[Severity: High]
Could returning 0 here before the PMU is explicitly selected cause silent
truncation of PMU event counter states during live migration?

If a VMM restores PMU sysregs via KVM_SET_ONE_REG before selecting the PMU
via KVM_ARM_VCPU_PMU_V3_SET_PMU, set_pmcr() in arch/arm64/kvm/sys_regs.c
evaluates:

arch/arm64/kvm/sys_regs.c:set_pmcr() {
    if (!kvm_vm_has_ran_once(kvm) &&
        !vcpu_has_nv(vcpu)        &&
        new_n <=3D kvm_arm_pmu_get_max_counters(kvm))
        kvm->arch.nr_pmu_counters =3D new_n;
    ...
}

Because kvm_arm_pmu_get_max_counters() now returns 0, the bounds check fail=
s.
set_pmcr() then leaves nr_pmu_counters at 0 without returning an error to
userspace.

Consequently, when set_pmreg() executes:

arch/arm64/kvm/sys_regs.c:set_pmreg() {
    ...
    u64 mask =3D kvm_pmu_accessible_counter_mask(vcpu);
    __vcpu_assign_sys_reg(vcpu, r->reg, val & mask);
}

The mask evaluates to only the cycle counter since nr_pmu_counters is 0.
This silently zeroes out the restored event counter bits for registers like
PMOVSSET_EL0, PMINTENSET_EL1, and PMCNTENSET_EL0.

Should the KVM API reject this out-of-order restoration sequence with an
error like -EINVAL, rather than silently discarding the VMM's restored
PMCR_EL0.N and event counter states?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702190421.4209=
92-1-congkai@amazon.com?part=3D1
