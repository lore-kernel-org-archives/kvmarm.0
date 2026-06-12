Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B161D63F0;
	Fri, 12 Jun 2026 19:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781293555; cv=none; b=Oi1xM83j3n7MDvZcl3XwWo6eLxjCwPSwi3Epz8lju2VpwAHIzoXnIYilNtaTN+qEzX3tUEhorslAuHH2CNzpdvQa6jET1DcvUjOUQJyNUsSN6cka1R3RvSbiyr9BcRzmtKdfyCYLzJwzgoTGINMkdNG+6EVLucE28c8nsJg2SwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781293555; c=relaxed/simple;
	bh=pllFxiRtmqpM7/SO+g1hkqmHPhoMYPmzg6WP2vQwDmY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Vu/q6uCaIRA5QRIjuRVonPznUiy+JML24ss7idjgaeaddaGc4oAatXGHr4tIndLiqHmuI9t7lC+JeJxJgCCiXpdnkSfiFxD+HnfmTi38A3KDldQ+iVbrVkL8Q1r2kZvVyw89LJNCctuaNDPRtd08KiEvwA/8BIDE7oaLrrs+JLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hPea2zsd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hPea2zsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E6C1F000E9;
	Fri, 12 Jun 2026 19:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781293553;
	bh=EHPvbxJ0jlbVId2qBr9DGEvts5On/tLjmpWwXy+7DwU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hPea2zsdms2/9DTXM79drj5U6DiT0PNGyyIvAElVshF03JRD33KcpPd/ckl9j8L8+
	 I4UxJHqFt9Q0X3CO2EXQlyjUh4n2SCRf5xhGH73hzrMjy8YDoGByJ1bRhjB6QOIrin
	 5q8h0GUWsi3blmYTK6i4dcEvDLDOD4idMkfMkJ6yI41wIhPVByvo2ImlLIWdps0Iaz
	 HU4WuQhr+w5aGC/fkwudMcUe92Ik7JYMe44J13HJdQSVWNKhDTuJL8TULoOc3kGskY
	 UFfP58U9T/4+6yQdzmsyirWp65C8hN9sYNwMwezoPoChnNnZgFldCopoe+lOZ+3Nmn
	 uVvlUUumIZDZQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 08/21] KVM: arm64: Set up FGT for Partitioned PMU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260612192909.1153907-9-coltonlewis@google.com>
References: <20260612192909.1153907-9-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 19:45:52 +0000
Message-Id: <20260612194553.05E6C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] `pmu_is_partitioned()` unsafely accesses a per-CPU variable via `h=
ost_data_ptr()` without preemption disabled, and evaluates incorrectly on h=
eterogeneous systems.
- [High] `has_host_pmu_partition_support()` enables PMU partitioning withou=
t checking for `FEAT_FGT`, breaking vPMU interrupts on systems without it.
- [Low] Dummy inline implementation of `pmu_is_partitioned()` unnecessarily=
 drops type safety by using `void *`.
--

commit e7fcce9967828eb595c4bfc42518f58b1e42429f
Author: Colton Lewis <coltonlewis@google.com>

KVM: arm64: Set up FGT for Partitioned PMU

This commit utilizes fine-grained traps (FEAT_FGT) to avoid trapping=20
common PMU register accesses by the guest, which improves performance=20
for partitioned PMUs. It selectively traps specific registers like=20
PMOVS_EL0 to track overflow IRQs while leaving common counters untrapped.

> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
> index 74e40e4915416..0135989667564 100644
> --- a/arch/arm64/kvm/pmu-direct.c
> +++ b/arch/arm64/kvm/pmu-direct.c
> @@ -20,3 +22,37 @@ bool has_host_pmu_partition_support(void)
>  	return has_vhe() &&
>  		system_supports_pmuv3();
>  }

[Severity: High]
Should this also check for cpus_have_final_cap(ARM64_HAS_FGT)?

Without FEAT_FGT, PMOVS_EL0 accesses won't be trapped. Since the host PMU
IRQ handler clears the hardware overflow bit and records it in a software
virtual overflow state, an untrapped guest read will incorrectly see 0,
and guest writes will bypass KVM completely.

Could this lead to KVM's virtual overflow state never being cleared,
resulting in a persistent vIRQ and a guest interrupt storm on pre-ARMv8.6
systems?

> +
> +/**
> + * pmu_is_partitioned() - Determine if given PMU is partitioned
> + * @pmu: Pointer to arm_pmu struct
> + *
> + * Determine if given PMU is partitioned by looking at hpmn field. The
> + * PMU is partitioned if this field is less than the number of
> + * counters in the system.
> + *
> + * Return: True if the PMU is partitioned, false otherwise
> + */
> +bool pmu_is_partitioned(struct arm_pmu *pmu)
> +{
> +	if (!pmu)
> +		return false;
> +
> +	return pmu->max_guest_counters >=3D 0 &&
> +		pmu->max_guest_counters <=3D *host_data_ptr(nr_event_counters);
> +}

[Severity: High]
Does evaluating host_data_ptr() here require preemption to be disabled?

host_data_ptr() expands to this_cpu_ptr(&kvm_host_data), and this function
is heavily used by KVM's PMU sysreg accessors which are reachable from
guest exit handlers with preemption enabled. Accessing this_cpu_ptr() here
can trigger a "BUG: using smp_processor_id() in preemptible" warning.

Additionally, on heterogeneous platforms (big.LITTLE) where different CPUs
might have a different number of event counters, could the PMU partition
status sporadically flip between true and false depending on which CPU the
thread is scheduled on, silently corrupting the vPMU state?

[ ... ]
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index f9a0823666949..36960b9e52da2 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
[ ... ]
> @@ -231,6 +238,11 @@ static inline bool kvm_pmu_counter_is_hyp(struct kvm=
_vcpu *vcpu, unsigned int id
> =20
>  static inline void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu) {}
> =20
> +static inline bool pmu_is_partitioned(void *pmu)
> +{
> +	return false;
> +}
> +

[Severity: Low]
Is there a specific reason to use void *pmu for this fallback stub?

Since struct arm_pmu is forward declared and widely used in this header,
using struct arm_pmu *pmu instead would preserve static type checking when
the feature is disabled.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612192909.1153=
907-1-coltonlewis@google.com?part=3D8
