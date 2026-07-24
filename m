Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36C537F30D;
	Fri, 24 Jul 2026 11:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784892407; cv=none; b=I/aiVCXRkkLz342Au0QecbwWUwRT1rP64l/fJrS2GOGDZZDK5VH+22qX+iXSKyKD0lLmO6XVqyxZqg15Bn9Aex1XDZKaMud31gkPHbz0Tsef3b0l9dpqn0UPrC66si9nYP0rP950pEeyOcTJU0UpGm39kLBemmiFvsz6eT38iA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784892407; c=relaxed/simple;
	bh=beKnvkdCU+mzSzQtpepAt0gxGALsgyf+JVyZp9zChS8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pA4Khck2o5AVaOHFCceheD1Z8nCI9wwi/WCvel3nLvZl+WLbEaU2ByYudMKHPLeBYDRL9TcsJ3D/frBVM7jjbg/rUYIY6dDCYC1RQDS5Qu/xlmVY1ItenRd9PyVZrK/wXmGWn/PvAb+F2gU6uEfaqIYAN+nf/LUr301w3r1+ZGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a2grCGcM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a2grCGcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AC51F000E9;
	Fri, 24 Jul 2026 11:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784892405;
	bh=EX/w+gqMTY0liEKjo1Kp3qfPB7YRk0YePZ8kZFHcCXg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a2grCGcMfmmm7cdRc52WWRonem1DLu/p4oIpg8smVmj8VVT19h8xncPVpbRc/Vsc/
	 c2v7N4teUkHaM0sgvEnOEsjP8m81u2Y5WdAu4r+WyJv6aZybn5zP6DdeF77Wc2K5NN
	 PIOdOCMr7aBYrf5KiiTyyiALFHaKzeBpH+m1ouSKvBvg7yyZEId/mPxfdqvUf/W8O8
	 dFl1uq7fINub01s00Y2SP1vJlI2a67PUpaVYL2aA3IHtzbHUuD3swK1LcXNr9dRn/0
	 wgwAU/XMJjkk89t6/q5mFr7muUlgFRmzoQIYxQHYdzZ5eF0ae79RcqjU0LvltQKIbI
	 ZYcc1bPKluqcg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 15/48] KVM: arm64: gic-v5: Add resident/non-resident
 hyp calls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260724104819.1296803-16-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-16-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:26:44 +0000
Message-Id: <20260724112645.10AC51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] The __vgic_v5_make_resident and __vgic_v5_make_non_resident hy=
percalls write unvalidated host-supplied data directly to the sensitive ICH=
_CONTEXTR_EL2 system register, breaking pKVM isolation.
- [Medium] EL2 double-fetches the system register value from host memory to=
 check for residency faults, enabling a TOCTOU race.
--

--- Patch [15]: [PATCH v4 15/48] KVM: arm64: gic-v5: Add resident/non-resid=
ent hyp calls ---
commit 1b185bf2c8c83d76bc583dab060f0d8f605b0939
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add resident/non-resident hyp calls

This patch introduces GICv5 VPE residency management by adding hypercalls
to make a VPE resident or non-resident via ICH_CONTEXTR_EL2. It also
updates vgic_v5_load() and vgic_v5_put() to use these hypercalls, ensuring
the VPE is considered resident during the load-to-put interval.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c

[ ... ]

> @@ -691,6 +691,20 @@ static void handle___tracing_write_event(struct kvm_=
cpu_context *host_ctxt)
>  	trace_selftest(id);
>  }
> =20
> +static void handle___vgic_v5_make_resident(struct kvm_cpu_context *host_=
ctxt)
> +{
> +	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
> +
> +	__vgic_v5_make_resident(kern_hyp_va(cpu_if));

[Severity: Critical]
Does this hypercall act on a raw, unvalidated host memory pointer passed in
a register?

Because the host can pass an arbitrary pointer to
handle___vgic_v5_make_resident(), EL2 should copy the necessary fields to
EL2 private memory and validate them before acting on the data to prevent
isolation bypasses.

> +}
> +
> +static void handle___vgic_v5_make_non_resident(struct kvm_cpu_context *h=
ost_ctxt)
> +{

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5=
-sr.c
> --- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
> @@ -7,6 +7,32 @@
> =20
>  #include <asm/kvm_hyp.h>
> =20
> +void __vgic_v5_make_resident(struct vgic_v5_cpu_if *cpu_if)
> +{
> +	write_sysreg_s(cpu_if->vgic_contextr, SYS_ICH_CONTEXTR_EL2);

[Severity: Critical]
Does this code write unvalidated host-supplied data directly to the
sensitive ICH_CONTEXTR_EL2 system register?

Under the pKVM threat model, cpu_if points to untrusted host memory post
deprivilege. By blindly reading vgic_contextr from the host and writing it
to the hardware register, a malicious host could potentially supply an
arbitrary VMID and VPEID belonging to a protected VM. This could trick the
Interrupt Routing System into routing a protected VM's interrupts to the
host's physical CPU.

Should EL2 derive and validate the residency state from EL2-private data
instead of trusting the raw hypercall parameters in
__vgic_v5_make_resident()?

> +	isb();
> +
> +	/* Catch any faults */
> +	cpu_if->vgic_contextr =3D read_sysreg_s(SYS_ICH_CONTEXTR_EL2);
> +	if (!!FIELD_GET(ICH_CONTEXTR_EL2_F, cpu_if->vgic_contextr))

[Severity: Medium]
Can this sequence cause a Time-of-Check to Time-of-Use race?

The code writes the system register value to cpu_if->vgic_contextr in
host-shared memory, and then immediately evaluates it back from host memory
using FIELD_GET(). A concurrent thread on the host could overwrite this
memory location between the write and the check.

If the hardware reports a residency fault (F=3D1), could the host overwrite
the memory with F=3D0 to trick EL2 into ignoring the fault? Reading the
system register into a local EL2-private variable for validation before
writing it out to host memory might avoid this issue.

> +		return;
> +
> +	cpu_if->gicv5_vpe.resident =3D true;
> +}
> +
> +void __vgic_v5_make_non_resident(struct vgic_v5_cpu_if *cpu_if)
> +{
> +	/*
> +	 * Make as non-resident before actually making non-resident. Avoids race
> +	 * with doorbell arriving.
> +	 */
> +	cpu_if->gicv5_vpe.resident =3D false;
> +	dsb(st);
> +
> +	write_sysreg_s(cpu_if->vgic_contextr, SYS_ICH_CONTEXTR_EL2);

[Severity: Critical]
Similarly to __vgic_v5_make_resident(), does __vgic_v5_make_non_resident()
write host-controlled memory to the system register instead of securely
writing a hardcoded 0 from EL2-private state?

> +	isb();
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D15
