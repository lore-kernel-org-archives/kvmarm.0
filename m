Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA042BF3F4;
	Fri,  3 Jul 2026 16:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783095784; cv=none; b=n0R763CY7xl6yxG9hntnFCsaTZaP1UXd7Ok2HOakGdcB9KS5hI+85VbUVDQGl+2v8Kv57WCOFBg1fNVGdIPfEtmwBo47wG+nUNXE6aWee1YcNnu4lLlIeCbqqQvZ/fDCys6sFAkE+6LPN/KQ9p+x9sB0l/mhZpkVv4qeGQ/BmGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783095784; c=relaxed/simple;
	bh=lNk/GJUF4sEqYaUF6Xr7J5lqwzbInf0Efk+UuSQglqs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oL4chkzQKZiCtmMRGNgAqZnH5yt4v/M8oCJ7DpqvLR2g0nsuwraw8jp2xX3ex2xtxGBnVQTA+QpjsGDB9wJQ5Db3lmlGnPm5yBqsUCDxSdcGCai82p5vzpkyEamHs+Cj/vPCNBLDU9p0XQ2qV4HiCdxqof6lcMG98BtLI79vmHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5ZN82SE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5ZN82SE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1311F000E9;
	Fri,  3 Jul 2026 16:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783095782;
	bh=CIww3kfVBUBNW5+OOFzlq1xMzjnjIXR7aNRO3sfajV8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R5ZN82SECNQYgzYM4aq6++bjwyxrFfQQUBSA8HsmpCDn9M8nh6tPLM+svOkVCN2kv
	 fq5YT+7NMSPU30y+I2PZhje4oak/ZsAXXCzpmnQy2eNXGj6UcQfbJS0hqTc6TFzg3p
	 MIRzSfRaWLqojFUP3OE7J0Vey/5i6/2fBV4GSKUxYa5s0Sf5D1oOPTX5BKx6R7tza+
	 UgGIFqEiMfZFZpnAFdepgsvoYcbTnVsjAFFMsWbnhWbwITctLGhNLSmsdSEoU/yVQa
	 5taCw22e4eLIGU8Gmgclsf9NWqtmZu3Gebrq3jTaNni+Zxbm6YC38g7n4ngBLaRixC
	 UHHCV6TVIfedA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 15/40] KVM: arm64: gic-v5: Add resident/non-resident
 hyp calls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260703154811.3355680-16-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-16-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:23:01 +0000
Message-Id: <20260703162302.6A1311F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] EL2 directly writes unvalidated, host-controlled memory to `SY=
S_ICH_CONTEXTR_EL2`, violating the pKVM trust boundary and allowing a compr=
omised host to hijack protected VMs' interrupts.
- [High] Time-of-Check to Time-of-Use (TOCTOU) vulnerability due to a doubl=
e-fetch of the host-shared `vgic_contextr` field when evaluating the hardwa=
re fault status.
--

commit 7cd120d3ed0e8b391f422c1d75c53d34d13d0b6c
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
KVM: arm64: gic-v5: Add resident/non-resident hyp calls

This commit introduces new hypercalls to make a GICv5 VPE resident or
non-resident by writing to ICH_CONTEXTR_EL2. It extends the load and put
functions to handle this residency interval and checks for residency faults.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 1d01c6e547f5d..8d0896f50f879 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
[ ... ]
> @@ -689,6 +689,20 @@ static void handle___tracing_write_event(struct kvm_=
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
> +}
[ ... ]
> diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5=
-sr.c
> index 6d69dfe89a96c..f064045a31aee 100644
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
Can this regression allow the host to force the GICv5 hardware to make a
protected VM's VPE resident?

The handle___vgic_v5_make_resident hypercall is exposed to the untrusted
host. Here, EL2 directly writes the host-controlled cpu_if->vgic_contextr
memory to the SYS_ICH_CONTEXTR_EL2 register without validating if
the requested VM/VPE belongs to a protected VM. This could break guest
isolation by allowing the host to modify a protected VM's interrupts.

> +	isb();
> +
> +	/* Catch any faults */
> +	cpu_if->vgic_contextr =3D read_sysreg_s(SYS_ICH_CONTEXTR_EL2);
> +	if (!!FIELD_GET(ICH_CONTEXTR_EL2_F, cpu_if->vgic_contextr))

[Severity: High]
Does this introduce a Time-of-Check to Time-of-Use (TOCTOU) regression?

The code writes the SYS_ICH_CONTEXTR_EL2 value into cpu_if->vgic_contextr,
which resides in host memory. It then immediately fetches it back
to check the ICH_CONTEXTR_EL2_F bit. A concurrent host CPU could overwrite
this value in the small window between the store and the load, clearing the
fault bit and hiding a hardware residency fault from the hypervisor.

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
Similar to the resident path, does this write introduce the same regression?

The non-resident path also directly writes the host-controlled vgic_contextr
value to the hardware register without validation.

> +	isb();
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D15
