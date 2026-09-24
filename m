Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C934B66ED;
	Thu, 24 Sep 2026 17:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790272384; cv=none; b=NlRgwAMgjQNYZIm6ptBMzGRx0Kg2mXl1AAjTfsKfmWeuOUdZ0B8hAs8boi44IPSdS0054S7LXYeF7nukw5KEen9h0yWK+L2z6wa/su3oVovh/fn4rTWJk5eYUrOhUH/ZbIXKWwl4zhh/DQmeXxcj0nHcCROJ/lcRWKZMZEjroDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790272384; c=relaxed/simple;
	bh=cBtxCJWdx7bFxJconx7xyHrb/JymeplIvtFPUD7RuB8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NghTjRns4nG3k3qkDQgal6cRMJBIEQ//M8f2aqhi6KL2nFATdRUY9WxnSSXLb/VME9Y0rhn5v2f51VOC309zCWSRLQ1jW5Qn5OAa01Ck602jRRnUt4Wd2G/ZSQmZFJaj0VeBUoS1rQqEB6dU7V9KkL3C7FKAPS7Kws4cOo0XbJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E3M8DAhM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E3M8DAhM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6CF1F000FF;
	Thu, 24 Sep 2026 17:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790272383;
	bh=QYk+XCH7tN7Wp2ffKKMn3KtXrPJDTweRVYW4ajlRXhE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E3M8DAhMovA+wQq5XTag8xRlCYLXRdEWmSomwJo20ooQWBDeRqJEko0Hhp1dN7NJ5
	 0QU3vHNf9SqxJKLXizakX50HSZ3OlULoMfFxRlvw/Pup/0dED7uMwY5o6Rk4iS5q5h
	 4EBMq6gjkOkqfitf8vUuCO4/oaELWca0Hv4wP1vbr59/ZN0tfvhpRGzpARMlIBMNuC
	 D9vd05kskoCrInHYGypG9gQm3wKwIBG6bvXpR/gu+XvXHpoIxTLMUYK9/Kr9aksXly
	 VvL4N0NYqaNLQ/Is4JggUI1mQbk02Pu+74U1O3wC7ymY8dIOQ6yANcozT74UCHkefm
	 xXTvLpHcFHcAA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 11/22] KVM: arm64: Set up MDCR_EL2 to handle a
 Partitioned PMU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: linux-perf-users@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260924172928.2110956-12-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-12-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:53:02 +0000
Message-Id: <20260924175302.CB6CF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] KVM: arm64: Missing validation allows 0 PMU counters on CPUs lacki=
ng FEAT_HPMN0, breaking host PMU profiling
- [High] KVM: arm64: local_irq_save() fails to mask pseudo-NMIs, causing TO=
CTOU race on mdcr_el2
--

commit c7c5ea4b657ecda0bf87202cf7ee0d846216d5cf
Author: Colton Lewis <coltonlewis@google.com>

KVM: arm64: Set up MDCR_EL2 to handle a Partitioned PMU

This commit sets up MDCR_EL2 to handle partitioned PMUs, configuring the
HPME, HPMD, and HCCD bits when a partitioned PMU is used. It also unsets
coarse grain PMU traps if fine grain traps are available and protects
mdcr_el2 updates using local_irq_save() to prevent races with the PMU NMI
handler.

> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index f4d7b12045e8f..a722fd4594e09 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -37,14 +37,16 @@ static int cpu_has_spe(u64 dfr0)
>   */
>  static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
>  {
> -	preempt_disable();
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
        ^^^^^^^^^^^^^^^^^^^^^^
[Severity: High]
Does this lock adequately protect against PMU interrupts?

On ARM64 systems with GICv3, the perf subsystem can use pseudo-NMIs for PMU
interrupts, and local_irq_save() does not mask NMIs. This leaves a structur=
ally
open race window where a PMU NMI could fire during the read-modify-write ph=
ase
of vcpu->arch.mdcr_el2 inside kvm_arm_setup_mdcr_el2().

[ ... ]

> +		/*
> +		 * Take out the coarse grain traps if we are using
> +		 * fine grain traps and enforce counter access with
> +		 * HPMN.
> +		 */
> +		if (!vcpu_on_unsupported_cpu(vcpu) &&
> +		    (cpus_have_final_cap(ARM64_HAS_HPMN0) || nr_guest_cntr > 0)) {
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^
[Severity: High]
Can host userspace break host PMU profiling by configuring 0 guest counters?

If host userspace configures a partitioned PMU with 0 guest counters via
KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS on a CPU where FEAT_HPMN0 is unsupporte=
d,
this condition evaluates to false and skips configuring HPMN.

Because KVM skips HPMN configuration when nr_guest_cntr =3D=3D 0 on these o=
lder CPUs,
HPMN defaults to N. This transfers all host counters to PMCR_EL0.E control =
and
renders MDCR_EL2.HPME entirely ineffective for the host, which loses the ab=
ility
to stop host counters. This continuous hardware counting could lead to NMI =
storms.

Should KVM reject such invalid configurations on CPUs lacking FEAT_HPMN0 in=
stead?

> +			vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_HPMN;
> +			vcpu->arch.mdcr_el2 |=3D FIELD_PREP(MDCR_EL2_HPMN, nr_guest_cntr);
> +
> +			if (cpus_have_final_cap(ARM64_HAS_FGT))
> +				vcpu->arch.mdcr_el2 &=3D ~(MDCR_EL2_TPM | MDCR_EL2_TPMCR);
> +		}
> +	}
> +

[ ... ]

>  	/* Write MDCR_EL2 directly if we're already at EL2 */
>  	if (has_vhe())
>  		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[Severity: High]
If a PMU pseudo-NMI fires during the critical section and calls
kvm_pmu_host_stop() to clear HPME, will this write clobber that update?

Because local_irq_save() fails to mask NMIs, this line writes the potential=
ly
stale, cached vcpu->arch.mdcr_el2 state back to hardware, discarding any
intermediate HPME updates from the NMI handler and leaving PMU counters in =
the
wrong hardware state.

> =20
> -	preempt_enable();
> +	local_irq_restore(flags);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D11
