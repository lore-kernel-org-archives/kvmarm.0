Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E3E4229BE;
	Fri, 10 Jul 2026 11:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783684155; cv=none; b=rwlVECFsjIsI+q9899DdUYSq/RYlN2qBAoLmE4HocO7Ov/7JSAM78mUu62gt23PO4kBm9fu5zhlwXbuaz3t4TF1cVBXtQINLPUoVYB9iPzJKmZ+w+NLVdFuT/mi4YzVRuqbOBynO7I9XKRq/s8R50ydhuiE5EvJti1Adz/wreY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783684155; c=relaxed/simple;
	bh=UBtcQ9P+7Q1x1BkCGu2HhG2AuU/GF77eySUh1JIQMOg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MlqPKCxNN4zG79/i6qNudOs+1kE0K16xEmr5S6MALLubWeSU1sdMHOuuRsHGCx1XVMTpsFxz3QzleD2ftvqfxYeNXYRWF/0GobV7jjq1EXh9LHBdHPdZ0eo1Ukdu4+xfoy6q64d0CV14NP0MwxCXTpvX6Bo1hxImayQtMeiy4zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VOO45OEC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VOO45OEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10951F00A3A;
	Fri, 10 Jul 2026 11:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783684137;
	bh=kd4nsDVKxA8eaOAkGL3IHBlyGyjXlRLqgJTzDAI8BVc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VOO45OECTRPlsfhe4HJy5e0yBx3CW5aI97X5vWQ0LkF3aOG6pB4WMSF0R8K/zoB6D
	 aoJv26iUVdJO5xQRUkLqtecZUZegHlzRMeZGkBg3wituOqdHaoOn6ntBG5dyqlgnl1
	 EcXbd8lBhuMFzqIq6JNTJZbFDflbTc8b1zJf0XWbgSi3Jj2HUOdBRPAbka8NeVqO/f
	 DIxjZpgB4RShroxC8MeLbL8Pts0MAJMFRl6Uytxw6G/ivoOymUFq+Dz4ZW2yeArjY0
	 /JUJwz6+1dY0vJwW+qw6q0nlYXf257O5Zb2Q7jXZVZCcD9NCfIIqFJ2RLh9/vwL9RV
	 EQnK4xKzB4edA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 09/11] KVM: arm64: PMU: Implement fixed-counters-only
 emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Akihiko Odaki" <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260710-hybrid-v8-9-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
References: <20260710-hybrid-v8-0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
 <20260710-hybrid-v8-9-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 11:48:56 +0000
Message-Id: <20260710114856.D10951F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Host-userspace-reachable WARN_ON_ONCE(!arm_pmu) when a VCPU is mig=
rated to a physical CPU without an ARM PMU.
--

--- Patch [9]: [PATCH v8 09/11] KVM: arm64: PMU: Implement fixed-counters-o=
nly emulation ---
commit 9fc8926767402baf798832c66340a34d9fea3673
Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

KVM: arm64: PMU: Implement fixed-counters-only emulation

This patch implements fixed-counters-only mode for PMUv3 emulation. It
restricts KVM to reporting only the cycle counter, and introduces a reload
mechanism if the vCPU migrates to a different physical CPU.

> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 2e7a0a427ddde..477852e8ddfe7 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c

[ ... ]

> @@ -767,6 +773,29 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc=
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
> +			if (WARN_ON_ONCE(!arm_pmu))

[Severity: High]
Can host userspace trigger this warning by migrating a VCPU thread to a
physical CPU that does not have a registered ARM PMU?

If host userspace uses sched_setaffinity to migrate a VCPU thread,
kvm_vcpu_load_pmu() detects the change and requests KVM_REQ_RELOAD_PMU.
When this request is handled before guest entry, it calls
kvm_pmu_create_perf_event(). In fixed-counters-only mode,
kvm_pmu_probe_armpmu() would return NULL, immediately hitting this
assertion.

This allows an unprivileged host userspace process to trigger a kernel
warning, which leads to a host kernel panic if panic_on_warn is enabled.

> +				return;
> +
> +			kvm_pmu_create_perf_event_with_pmu(pmc, arm_pmu);
> +		} while (!cpumask_test_cpu(READ_ONCE(vcpu->cpu), &arm_pmu->supported_c=
pus));
> +	} else {
> +		kvm_pmu_create_perf_event_with_pmu(pmc, arm_pmu);
> +	}
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710-hybrid-v8-=
0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp?part=3D9
