Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BEF36A022;
	Thu, 24 Sep 2026 17:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790272517; cv=none; b=eOhIlEPdmLGtpH2NAlh7tNYsijmHrCg8gTiUIzPflES8T9e38AOVXBFPX7j5svMllzKHF0F9NaeB3FzYydob0frkuRFMKu34zyPcLmyL/tnKUxjjv1oEZsKyqas1OOSzo7S4+UnNJFazKs1pEnUHfdK4BZFeOR/94nWOOBwsJ9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790272517; c=relaxed/simple;
	bh=pZ0CukMOTbICSj5d4Dw8MrZ1lxVkednNroOGzbMCbvQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AnJVdHlLqrH/NNnK055UZTNNyDp3v509fpN+ILtHu2Iyor+IXSn9qDCVO430iespAMy5quhDxLPkeAKNUzcNVxuu/0hczXFM5sap0h0eELxpWrTxQX2sEBGFYt74ubvI8YCo4Pj7RkzMmZvsfN096A0oAMIEM28NvoO/I87Zdpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXMo857F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXMo857F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D951F000FF;
	Thu, 24 Sep 2026 17:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790272515;
	bh=7TiOF3hpLnSYjEt1gkfHZv2P/kaJUm10k4wvzR1yHhk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RXMo857FFDl7F+cKK/oNcM+LStlSqZXSRXzvmDoAOx/zCIp06z0bYQaXNGkksCfms
	 ar/jHGFCR+8CuTUsWWRD2PsmzrN7P72nMKFJV3ifq2f9WMv/WGHg4VauPn1YD+G89x
	 nWhJ7ujaggX+8/IipDIHRYIZQ/TU27AgEYeyHu33D5yf6jVbYBKY9W0sr3Bf4a5kfV
	 Bw+ZMn42xCYRrN8zKc5eAfGUdf98xHNRfb7GNdlySegOqW+bp5OF4xb6dm4/tGLFhp
	 BYLZXiJXnR7X2fSBmiqJ8on46ZGyex72hxEqggMoxtip0MpTHfDM2GzatUP3RRwjy6
	 C0CcM9hc50xkw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 17/22] KVM: arm64: Implement lazy PMU context swaps
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260924172928.2110956-18-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-18-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:55:14 +0000
Message-Id: <20260924175515.68D951F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kvm: arm64: PMU hardware permanently frozen after live migration
--

commit 458afe99983a6c37492623080fcc934e4e368118
Author: Colton Lewis <coltonlewis@google.com>

KVM: arm64: Implement lazy PMU context swaps
   =20
This patch implements lazy PMU context swapping to avoid the overhead of
reserving hardware counters on every vCPU load and put. It introduces per-v=
CPU
PMU ownership tracking, transitioning to GUEST_OWNED only when the guest
actively enables PMU counters or interrupts.

> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
> --- a/arch/arm64/kvm/pmu-direct.c
> +++ b/arch/arm64/kvm/pmu-direct.c
> @@ -336,7 +342,9 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
>  	 * If we aren't guest-owned then we know the guest isn't using
>  	 * the PMU anyway, so no need to bother with the swap.
>  	 */
> -	if (!kvm_pmu_is_partitioned(vcpu->kvm))
> +	if (!kvm_pmu_is_partitioned(vcpu->kvm) ||
> +	    kvm_pmu_get_access(vcpu) !=3D VCPU_PMU_ACCESS_GUEST_OWNED ||
> +	    vcpu->arch.pmu.loaded_on_cpu)

[Severity: High]
Does this logic cause the PMU hardware to remain permanently frozen after a
live migration?

When userspace restores the PMU state via KVM_SET_ONE_REG (which routes
through set_pmcr() and set_pmreg() in arch/arm64/kvm/sys_regs.c), it
bypasses pmu_reg_write() and assigns the system registers directly. Because
the state is never transitioned to VCPU_PMU_ACCESS_GUEST_OWNED on this
restore path, it remains VCPU_PMU_ACCESS_FREE.

Later, when kvm_pmu_load() runs, it aborts early due to the access state
being FREE, meaning the physical counters are never configured or started.
Although kvm_pmu_part_overflow_status() acts as a fallback to catch state
restoration, it explicitly requires an overflow to be pending:

arch/arm64/kvm/pmu-direct.c:kvm_pmu_part_overflow_status() {
    ...
    if (overflow && kvm_pmu_get_access(vcpu) =3D=3D VCPU_PMU_ACCESS_FREE)
        kvm_pmu_set_guest_owned(vcpu);
    ...
}

If the guest is migrated while actively counting but no overflow is pending,
the counters will never tick, will never overflow, and this fallback will
never trigger. Could the restore paths be updated to ensure the ownership
transitions correctly?

>  		return;
> =20
>  	preempt_disable();

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D17
