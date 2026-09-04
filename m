Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215143D34B9;
	Fri,  4 Sep 2026 12:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788525725; cv=none; b=ddqJhE5HR599F06eBNW+lbSj3UDplyEcC9ogI9fjQlCHYrU+KTClvhtAYrBRfMURPyg1QjXH5uzI76FLDwdEvBZdachQPUXpWnjDTe9B2MNfkGLoEc8K3rfVvVfxtlOktHqZpSyir4rmZYUuXs4MdIwhhzjsxQ3tVEjj3pfMULg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788525725; c=relaxed/simple;
	bh=jbpd3jMUXT5ZyUIfjsLDHGdhwIR9vvikFhLC2IKhOu4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eboKzQM5IAw6IXYqdxNPLUWmGrbNPQ6h8CiJajlawSoYU8+kcO6Hvg/LMobNt3OdvGZcroZrXRHqn0z/CetsFYT5VM6Awi5xKJItI1BEHs9L7M3sj6dMQM07QANdv88VBve0qH6oJ9Gg9+8313yf2NINIlNS4UvIYCBDV3uCCYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OhFyZVRV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OhFyZVRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C9D1F00A3D;
	Fri,  4 Sep 2026 12:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788525723;
	bh=jy+2f0yJSwn86TrnDouWZGR20Q1G8OtdEMlcPVgRTa0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OhFyZVRVZmGYlyxvk3rI0Ed1TqZuuGM2EqNexuCvqVs84DdHHrCqwa+FJ/2W9pjgJ
	 /WJylEf3jTgZQTU2UU4aTZjOmYrAOC8J8Cy84/o6Zq6fBoZ92sE7A6URNrcpiFw7oz
	 rbKd5thQ3crceqXIvCIcjOkBc9A6wIHB7jI1G0o36lo88V8T0T7d98KbjgCen4k/ql
	 AnftOn1xV8ch8YeGPG4NmwkF6Z1zMf77thJJnTVFaTFcgEjmtcrvLqYQ849CdTTdXS
	 m3nRCf3y6IZAOHsiAB54yCcyTkvjPh1Fwx02qmANsgTDnomJGLBTR38JUEemazsbza
	 IdNvZ9013eG0g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 15/49] KVM: arm64: gic-v5: Add resident/non-resident
 hyp calls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260904113404.4051341-16-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-16-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 12:42:03 +0000
Message-Id: <20260904124203.73C9D1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Early return in `vgic_v5_load` when `IN_WFI` is set breaks VPE har=
dware residency on CPU migration.
--

commit 5c761580bd9775ac4c98a890e1f6aab6f8768957
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add resident/non-resident hyp calls

This commit introduces hypercalls to manage GICv5 VPE residency and
extends vgic_v5_load and vgic_v5_put to make VPEs resident and
non-resident during the load-to-put interval. It also adds a check
for residency faults that marks the VM as dead on failure.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 5b599821b2da2..d7d6db5014269 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
[ ... ]
> @@ -1066,7 +1068,15 @@ void vgic_v5_load(struct kvm_vcpu *vcpu)
> =20
>  	kvm_call_hyp(__vgic_v5_restore_vmcr_apr, cpu_if);
> =20
> -	cpu_if->gicv5_vpe.resident =3D true;
> +	cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_V, true) |
> +				FIELD_PREP(ICH_CONTEXTR_EL2_VPE, vpe) |
> +				FIELD_PREP(ICH_CONTEXTR_EL2_VM, vm);
> +
> +	kvm_call_hyp(__vgic_v5_make_resident, cpu_if);

[Severity: High]
Does this break VPE hardware residency on CPU migration during WFI?

When a vCPU executes WFI and yields the CPU, the IN_WFI flag is set and
vgic_v5_put makes the VPE non-resident. When the thread is scheduled back i=
n,
vgic_v5_load is called by kvm_sched_in. However, the pre-existing early
return in vgic_v5_load bypasses the rest of the function:

vgic_v5_load() {
    ...
    if (vcpu_get_flag(vcpu, IN_WFI))
        return;
    ...
}

Because the new hardware residency setup (__vgic_v5_make_resident) is placed
after this early return, it appears to be skipped completely. Even if
kvm_arch_vcpu_unblocking calls vgic_v5_load again later, it will also return
early since IN_WFI is only cleared after the blocking sequence finishes.

Could this result in the vCPU resuming execution after a WFI block without
its VPE being resident in the GIC hardware, breaking LPI and SPI interrupt
delivery?

> +
> +	/* Failed to make the VPE resident? Bang! */
> +	if (WARN_ON(!!FIELD_GET(ICH_CONTEXTR_EL2_F, cpu_if->vgic_contextr)))
> +		kvm_vm_dead(vcpu->kvm);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D15
