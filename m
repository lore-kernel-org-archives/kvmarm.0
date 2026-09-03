Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8464EBAF7;
	Thu,  3 Sep 2026 16:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788453689; cv=none; b=ssjjoTNAeEPX+BwQrJ4GDv7RhlSs48gKVJ3AKzPDRlmw8g5GgRrmCcEN6vWjY/eVVj5nrJ84i8argOfx92y0ZMPLpTgdfcDvbn1FZ2t0fXqyQztYD3hx6Nh0dGwUoB2qBRkc4Gbl7Ho996CiXJyhi/LcMu/B3M+OrRbvzJFPyWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788453689; c=relaxed/simple;
	bh=1vbgx1ozWZRgt2sUUvC1tk5PMJMxVINZwiAqs2eHX9s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MjvXYlL4FvzbYNc5OGqnP2BQ8eBTvvSnuAUaBiUOWpXpL5gY8WurMKwO9OlVaCTR+yzkQIhSWDAAbwY7FC9WylxZgXfmK7G4JA09xhYDc6YAEuULTwOnBy13yDvNaSzKv0iS735woY4J9UKStQfsrWR8cDkMK+fI6pSwf4eF0Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bSLSVmBz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bSLSVmBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497DB1F000E9;
	Thu,  3 Sep 2026 16:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788453687;
	bh=ZZOokgpqf4Gn3GibHP6tDFUPte3jrlnETQo3YVVJ2jg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bSLSVmBzH0oW2fHgLBELSr5FlxeNiPxFLyUTL98WWsFrZwVBbLhkgOlpiulOBbXPz
	 IK8yqR71+pKywqkR9lucqrhASbhIIbedWDglqrIHPQoggwaV2Sz50zyJhwlvlxFQ5J
	 3Ho75TKdfUN/zkDx6wW95lCBzg/RBJ/LS3vghV2FhQegiwBFW5yO6tkpG2fqSjctOj
	 y0eiYqot4vBvaKzfgmgclF7k+MRJzRsS13s/dwYK2a2XP8t+n3oQanu09jUwLkvBgs
	 ZaNEyQQ7AF9d/CxGoM8cU+AmilILb5k3TugAlesg6Xp+Bx7GBjrGBEGF55nsWPmg8g
	 xwwpAtBLZdiwg==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 15/28] KVM: arm64: Use PMSVer from the assigned
 SPE instance
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260903160623.315525-16-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-16-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 16:41:26 +0000
Message-Id: <20260903164127.497DB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] kvm_spe_finalize_idregs() unconditionally overwrites the user-prov=
ided ID_AA64DFR0_EL1.PMSVer with the host's physical version on the first K=
VM_RUN, breaking live migration.
- [High] sanitise_id_aa64dfr0_el1() evaluates PMSVer dynamically based on t=
he assigned SPE PMU, returning 0 if called before the PMU is assigned, whic=
h breaks KVM_SET_ONE_REG validation.
- [High] kvm_spe_finalize_idregs() is skipped if a vCPU without SPE runs fi=
rst in a heterogeneous VM, permanently leaving PMSVer as 0 and hiding SPE f=
rom the guest.
--

commit 45e0320e2eaeb926a33b978420aa5a133c7a42c6
Author: Alexandru Elisei <alexandru.elisei@arm.com>

KVM: arm64: Use PMSVer from the assigned SPE instance

This commit updates KVM to initialize the VM's ID_AA64DFR0_EL1.PMSVer using
the SPE PMU instance assigned to the VM rather than the physical CPU execut=
ing
the vCPU init ioctl. This is intended to handle heterogeneous systems where
SPE instances may have different versions or be entirely absent on some CPU=
s.

> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index fa87d224c8af8..4426d614a9e0b 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
[ ... ]
> @@ -87,6 +87,30 @@ bool kvm_spe_pmu_set(struct kvm *kvm)
>  	return !!kvm->arch.kvm_spe.spe_pmu;
>  }
> =20
> +void kvm_spe_finalize_idregs(struct kvm *kvm)
> +{
> +	struct arm_spe_pmu *spe_pmu =3D kvm->arch.kvm_spe.spe_pmu;
> +	u64 reg;
> +
> +	if (!spe_pmu)
> +		return;
> +
> +	reg =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1);
> +	reg &=3D ~ID_AA64DFR0_EL1_PMSVer_MASK;
> +	reg |=3D SYS_FIELD_PREP(ID_AA64DFR0_EL1, PMSVer, spe_pmu->pmsver);
> +	kvm_set_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1, reg);
> +}

[Severity: High]
Does this unconditionally overwrite the user-provided ID_AA64DFR0_EL1.PMSVer
value on the first KVM_RUN?

If a VMM restores ID_AA64DFR0_EL1 during live migration (for example, when
migrating from an older host to a newer one), kvm_spe_finalize_idregs() will
silently clobber the userspace-configured value and force it back to the ho=
st
hardware's version. Could this violate the KVM ABI and break live migration
sequences?

[ ... ]
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 44aae52c473d7..a6bb6884b965a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2220,8 +2220,11 @@ static u64 sanitise_id_aa64dfr0_el1(const struct k=
vm_vcpu *vcpu, u64 val)
>  		val |=3D SYS_FIELD_PREP(ID_AA64DFR0_EL1, PMUVer,
>  				      kvm_arm_pmu_get_pmuver_limit());
> =20
> -	/* Hide SPE from guests */
>  	val &=3D ~ID_AA64DFR0_EL1_PMSVer_MASK;
> +	if (vcpu_has_spe(vcpu))
> +		val |=3D SYS_FIELD_PREP(ID_AA64DFR0_EL1, PMSVer,
> +				      kvm_spe_get_pmsver(vcpu->kvm));

[Severity: High]
Can this dynamic evaluation break KVM_SET_ONE_REG validation during VM setu=
p?

VMMs like QEMU typically restore VM ID registers via KVM_SET_ONE_REG
immediately after KVM_ARM_VCPU_INIT, before configuring device attributes.
Because sanitise_id_aa64dfr0_el1() evaluates PMSVer based on the assigned S=
PE
PMU, kvm_spe_get_pmsver() returns 0 until the SPE PMU is assigned.

This strict ordering dependency will cause KVM_SET_ONE_REG to reject valid,
non-zero userspace values with -EINVAL, which breaks standard live migration
sequences.

[ ... ]
> @@ -5928,6 +5931,9 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
>  		kvm_vgic_finalize_idregs(kvm);
>  	}
> =20
> +	if (vcpu_has_spe(vcpu))
> +		kvm_spe_finalize_idregs(kvm);
> +
>  	return 0;
>  }

[Severity: High]
Can this leave PMSVer permanently set to 0 in a heterogeneous VM if a vCPU
without SPE runs first?

kvm_finalize_sys_regs() executes on the first KVM_RUN for a given VM. It us=
es
a per-vCPU feature check (vcpu_has_spe(vcpu)) to guard the VM-wide ID regis=
ter
initialization in kvm_spe_finalize_idregs(kvm).

If the first scheduled vCPU happens to lack SPE, vcpu_has_spe(vcpu) evaluat=
es
to false and kvm_spe_finalize_idregs(kvm) is skipped. The VM is then marked
with KVM_ARCH_FLAG_HAS_RAN_ONCE, meaning SPE initialization is skipped fore=
ver.
This would permanently hide SPE from all vCPUs in the VM.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D15
