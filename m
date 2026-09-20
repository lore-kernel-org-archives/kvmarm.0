Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F31F3515F8;
	Sun, 20 Sep 2026 11:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789904442; cv=none; b=D3bD2WJMgQDNRPLyiy0rfg+5WJH+n0f4yJMzk+oG3jLsI1rTdJO2tYg1fQypg98FWcdW22DZNz3FoykFQD8aGltEjBJ2km4uCprKhJltBq7jYnLC0ibajVtSmcjV5Epqsfi9SKSEQMpCGRoEQ5YUF+LMeMOuuqHUq9HV/ERcg2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789904442; c=relaxed/simple;
	bh=i2RsxYaBXi8o4fvYkwcfPZvW3B8h5x57GUZ25WbGKYg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GvpicMrAO4J6Ec6UEioK9JTHYod5rCDN0Z4tIN3EQAod+F+gb7NE+/y2T+sS+L+UmApAb5t+GdcMunINwwqQZ+45uJGcKO/uVkPlGEhSOv9LkB+dZo9SQqfQbQu2VUKeYYdTbTj5+DBIm1wIgdCUN+2LxRG2b5ajPTDLzKyDBeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WPgMV+ym; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WPgMV+ym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BFF1F000FF;
	Sun, 20 Sep 2026 11:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789904438;
	bh=FDDmslj307TTkPPgJFQwJH9dFvEZf/0uiKi4KjNuYyI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WPgMV+ymqClbN6VSIXgDSnE8q/QKeLSFJvXEUSacJ/jasV6NEKW4Hku9hERXWu64q
	 PffhSUMPwRSgu0yI1w2uYcw0bPB2AZfGkbuN1PFpVMZTyB1U10QGp5iU/jnN+aWhrh
	 zPoBbkbutx5ykzPJfdq9jr7H3lUqrhKcLatS510hKy/OpIGPIKriazqug7HP0TbZxe
	 m0mDacaf+2qHuAc8SbK/XxM1uJdAf+0X3E5korIC9yRNQxMriO0XGYnuo83rD0xg9N
	 eNhHKMUiY+o4tBJAs1nzvjebd+Gf29Mitv0Rg3WWJ+iPe2r3YgqpuvsbSuLDyQieJy
	 tBGpL+6mgMqXQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 19/21] KVM: arm64: PMU: Implement
 fixed-counters-only emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Akihiko Odaki" <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260920-hybrid-v11-19-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
References: <20260920-hybrid-v11-0-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
 <20260920-hybrid-v11-19-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 11:40:37 +0000
Message-Id: <20260920114038.06BFF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kvm: arm64: PMU: host DoS via unprivileged user triggering TAINT_C=
PU_OUT_OF_SPEC
--

commit d0f716fd067877dc7eca2170bb877659746aae89
Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
KVM: arm64: PMU: Implement fixed-counters-only emulation

This commit adds a PMUv3 emulation mode that exposes only fixed event
counters to the guest. It recreates the underlying host perf event dynamica=
lly
if the vCPU thread migrates to a different physical CPU. If the destination
CPU lacks a registered PMU implementation, it warns and adds a kernel taint.

> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
[ ... ]
> @@ -811,6 +812,32 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc=
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

[Severity: High]
Can this allow an unprivileged user to intentionally crash the host?

An unprivileged user could create a VM with fixed-counters-only enabled,
and then use sched_setaffinity to force the vCPU thread to migrate
to a physical CPU that does not have a probed PMU (like an asymmetric core =
or
late-added CPU).

When the vCPU runs, kvm_pmu_create_perf_event() will detect the missing
PMU and call add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_STILL_OK). If the host
is configured with panic_on_taint enabled, this triggers a direct kernel
panic.

Is there a way to return an error to userspace instead of adding a taint
based on user-controlled thread affinity?

> +				return;
> +			}
> +
> +			kvm_pmu_create_perf_event_with_pmu(pmc, arm_pmu);
> +		} while (!cpumask_test_cpu(READ_ONCE(vcpu->cpu), &arm_pmu->supported_c=
pus));
> +	} else {
> +		kvm_pmu_create_perf_event_with_pmu(pmc, arm_pmu);
> +	}
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260920-hybrid-v11=
-0-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp?part=3D19
