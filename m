Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AE43ACEF6;
	Mon, 20 Jul 2026 06:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784528276; cv=none; b=UJJNsDCHxcVryOxKoQ5qrHSfwaZazF42+iWmwmXPXW2jprohtAhmd8DbRh+8ge/vbxaDC6Q+Q6bCZP2DV0gXt5YalK4veUPZ+67X2PZB8Z/Xf04Z4RxvaALo70xLkNJeax+GuCQklUBNzbrOkrMWzIo032h6tYNP9qgTUoA93EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784528276; c=relaxed/simple;
	bh=pflnMY2/S0a7j5lliNe2p/WCULVv2c+M2fZ52pTnogg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JKQv7gw6yjRiRspHAPltOUm7y7ahejOZ+J4725gZdLfc/KDAhNdWXI2jmDak1Tog6M3RpaK/CheGgu59PA2y3hqMMbWh8rlib/xRdaNO2LFhBgRtRlsEv0ra+VjxwTBlHlTzdjwY1X++JTADsWwNnF+G6NDzKFsAzohhasNqRSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iDckIS2z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iDckIS2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86291F000E9;
	Mon, 20 Jul 2026 06:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784528264;
	bh=K0UynwdCv5WDm1BVlmikLW/Dj+dAPIIfg1V5Im2kFiU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iDckIS2zrx4DuvkuzGtu412bP5XfyM/S7yusMn1RyrdraIvl0lSYk1NZHprmt6lHi
	 7Rqgdqx12NBFf0wbAO+qar2Pz6D2taRRlaRFXEiHjOcZCd47W09InPTs1N2vBDO4yx
	 nUPQo6A3hF0pc02gFCwn/HrQfAbLXGmCt6LfNV/vwWeYNtEdoOuFQpTkkyafxwejtY
	 /QAm1s0w1irGZ/AF6voSDjzerMAw28/elv9kzUkGlKGxPsoVsL+4rL8y8/soZqXpza
	 fJfBG4W1Ya+fX2Oofz6tcJLKc4v8a7OUfYRsHwt0CHj89X6xAy7Hwq5u4ACdYDMB3t
	 tepOey7ODA4AA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 14/16] KVM: arm64: PMU: Implement fixed-counters-only
 emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Akihiko Odaki" <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260720-hybrid-v9-14-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
 <20260720-hybrid-v9-14-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 06:17:43 +0000
Message-Id: <20260720061743.E86291F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] State desynchronization in PMU virtualization due to retained st=
ale perf_event.
--

--- Patch [14]: [PATCH v9 14/16] KVM: arm64: PMU: Implement fixed-counters-=
only emulation ---
commit 8eabffaec38175a063281e21d7253117967c6ca4
Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

KVM: arm64: PMU: Implement fixed-counters-only emulation

This patch adds internal state for emulating PMUv3 without programmable
event counters. In fixed-counters-only mode, KVM tracks physical CPU
migrations and requests PMU reloads so the host perf event for the cycle
counter can be recreated on the new physical CPU's PMU. Uncovered CPUs are
treated as unsupported and taint the kernel.

> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 78611eaecca25..1ec09ef28467a 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
[ ... ]
> @@ -785,6 +791,32 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc=
 *pmc)
>  	pmc->perf_event =3D event;
>  }
> =20
> +/**
> + * kvm_pmu_create_perf_event - create a perf event for a counter
> + * @pmc: Counter context
> + */
> +static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
> +{
> +	struct kvm_vcpu *vcpu =3D kvm_pmc_to_vcpu(pmc);
> +	struct arm_pmu *arm_pmu =3D vcpu->kvm->arch.arm_pmu;
> +
> +	if (kvm_pmu_fixed_counters_only(vcpu->kvm)) {
> +		do {
> +			arm_pmu =3D kvm_pmu_probe_armpmu(READ_ONCE(vcpu->cpu));
> +
> +			if (!arm_pmu) {
> +				pr_warn_once("kvm: Unsupported PMU variation detected.\n");
> +				add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_STILL_OK);
> +				return;

[Severity: Medium]
Does this early return leave a stale perf_event attached to the PMC?

If a vCPU in fixed-counters-only mode migrates to a physical CPU without a
supported PMU, and the guest attempts to reprogram the cycle counter's
filter, kvm_pmu_create_perf_event() will exit here without stopping the old
counter or replacing it.

If the vCPU later migrates back to a supported CPU, kvm_vcpu_load_pmu() will
trigger a KVM_REQ_RELOAD_PMU. When kvm_pmc_enable_perf_event() checks the
PMC, it will find the old perf_event. Since that old event is valid for the
now-current supported CPU, it will be re-enabled without recreating it.

Can this lead to KVM silently discarding the configuration updates the guest
made while on the unsupported CPU, resulting in incorrect performance
monitoring statistics?

> +			}
> +
> +			kvm_pmu_create_perf_event_with_pmu(pmc, arm_pmu);
> +		} while (!cpumask_test_cpu(READ_ONCE(vcpu->cpu), &arm_pmu->supported_c=
pus));
> +	} else {
> +		kvm_pmu_create_perf_event_with_pmu(pmc, arm_pmu);
> +	}
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720-hybrid-v9-=
0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp?part=3D14
