Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91395377EAF;
	Mon,  6 Jul 2026 10:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783335234; cv=none; b=bOzfUOToex7letfOqdqO+PVI5q8iCDfALXhupURu9/1U3nGAb1vYSFs4hRDbXaw0VeTxO/097bftrdslQHMQWxkd2iDP5LBuWjXdCztILI+JZVkuYUlhkGfN2no4+AJljnPamIZ4JWViPl+1ZEDQ7XOWncWz4LsvZZtk8CAjiy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783335234; c=relaxed/simple;
	bh=Tih3QQXMxc5EWq/vejle0+NjlTrn55eEEeUXVtaVCRw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FRUkfvuSjsGsSlqQHswo5wNpenPlAFIVgZzVPn5qU8VCgUQqB0DqLyWibvpZmmztWppdL4z59bkgsFybNfjd5ZjOszXGD7nbk6ReVdSJKAyCV/H2q/SNfodGq3dBFKjVMpK4aqvV2Jb5E3/UFVk2ujLxBubR6xRImg513h0F4wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i2LxHQwi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i2LxHQwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225BC1F000E9;
	Mon,  6 Jul 2026 10:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783335233;
	bh=z9JfdJvlQX2/K37GJrmKEKkaSUiMPVt9LgvO4gAFqcQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i2LxHQwinziBktQgktA8Ygbs0hGNkzDyXPf1MmEhptewz0UAdsCZtb57qx3itur/2
	 vANPXKtxDgjAX3SuX7yIwmDohJ1UfF+cyYS3YzeTpuBAIYevFil5+Xc/Jxq0q5wTls
	 ntdP90u3AqEQUjol0bqwDM8u0923lKylDrDBte4wScg5LYMvgr1bsZcvQ6iHTKVG/D
	 s6E0aK03xGTE/gU0+YqpPge4ayBQTwiyGGFg5a6xkGWH5EHaQriP0I4WyWcAe0SVLP
	 jMyyWqqQYz2pQcUBunoWqsCSFSmxz6A6wtFavbYCZNXKPVSQChNvTRM6026RYc7HUr
	 NsYXkwz045nyQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 5/7] KVM: arm64: PMU: Implement fixed-counters-only
 emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Akihiko Odaki" <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260706-hybrid-v8-5-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
References: <20260706-hybrid-v8-0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
 <20260706-hybrid-v8-5-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 06 Jul 2026 10:53:52 +0000
Message-Id: <20260706105353.225BC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Time-of-check to time-of-use (TOCTOU) race condition in `kvm_pmu=
_create_perf_event()` allows the PMU cycle counter event to be created agai=
nst the wrong physical CPU's PMU if the vCPU thread migrates during event c=
reation, silently breaking the guest cycle counter.
--

commit 20c92d3c8fbdbec7346087339db116c12fe2ba15
Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

KVM: arm64: PMU: Implement fixed-counters-only emulation

This commit adds internal state for PMUv3 emulation without programmable
event counters. When fixed-counters-only mode is active, it reports no
programmable counters, hides PMCEID, and manages per-load PMU reloading
for the cycle counter across asymmetric PMUs.

> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 465e40bd7353e..de4daaab3ae5e 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -707,6 +716,12 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc=
 *pmc)
>  	int eventsel;
>  	u64 evtreg;
> =20
> +	if (kvm_pmu_fixed_counters_only(vcpu->kvm)) {
> +		arm_pmu =3D kvm_pmu_probe_armpmu(vcpu->cpu);
> +		if (WARN_ON_ONCE(!arm_pmu))
> +			return;
> +	}
> +
>  	evtreg =3D kvm_pmc_read_evtreg(pmc);
> =20
>  	kvm_pmu_stop_counter(pmc);

[ ... ]

> @@ -892,6 +910,24 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool p=
mceid1)
>  	return val & mask;
>  }
> =20
> +void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * ARMV8_PMU_INSTR_IDX will need the same check once
> +	 * FEAT_PMUv3_ICNTR is supported.
> +	 */
> +	struct kvm_pmc *pmc =3D kvm_vcpu_idx_to_pmc(vcpu, ARMV8_PMU_CYCLE_IDX);
> +	struct arm_pmu *cpu_pmu;
> +
> +	if (!kvm_pmu_fixed_counters_only(vcpu->kvm) ||
> +	    !kvm_pmu_counter_is_enabled(pmc) || !pmc->perf_event)
> +		return;

[Severity: Medium]
Is there a TOCTOU race condition if the vCPU thread migrates during event
creation?

In kvm_pmu_create_perf_event(), arm_pmu is cached based on vcpu->cpu, and
then pmc->perf_event is cleared by kvm_pmu_stop_counter():

	if (kvm_pmu_fixed_counters_only(vcpu->kvm)) {
		arm_pmu =3D kvm_pmu_probe_armpmu(vcpu->cpu);
		...
	}
	...
	kvm_pmu_stop_counter(pmc);

If the thread is preempted and migrates to a different physical CPU before
the new event is assigned, the preempt notifier calls kvm_arch_vcpu_load(),
updating vcpu->cpu and calling kvm_vcpu_load_pmu().

Because pmc->perf_event is temporarily NULL during this window, this check
returns early and skips setting KVM_REQ_RELOAD_PMU.

When the thread resumes, it completes event creation using the originally
cached arm_pmu. On asymmetric systems, could this result in the cycle
counter being instantiated against the wrong hardware PMU and silently
failing to count?

> +
> +	cpu_pmu =3D to_arm_pmu(pmc->perf_event->pmu);
> +	if (!cpumask_test_cpu(vcpu->cpu, &cpu_pmu->supported_cpus))
> +		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706-hybrid-v8-=
0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp?part=3D5
