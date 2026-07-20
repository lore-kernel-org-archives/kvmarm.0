Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6599323A561;
	Mon, 20 Jul 2026 06:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784527424; cv=none; b=FHgfV6k/6kAPcJ+utt71SI2rXlTtpu1VvpbP+lBJfKV6mRUBznAziLixjW78pffo58TD9l7h7oEJZb0azU+RO7H+ERQk/oEMtmqiwLoLwmFfQ13TEwLLu92d4OrI8AZAZEAT++dxQmkJ4Epn5C+N6SexkyW+5x4+1xEB1DLp1IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784527424; c=relaxed/simple;
	bh=AOqhmVm05+IXCHYbVyuORNDAcOWT2UJy4tAOpaBlr4k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WyQWAHdJGI4iEqbKYMlo172jL80iMFZqToTCaamhcuPIDoLTxtQ+pGQalsGMPQPV+/H+hg4v8xkRqCW7/XMz/eyJlLX9vfnX+NtmmZql2S5lTKo47sifJq4Pek5ikB+/xCiaJj7rfsW96pqqtNzZuKOdgaQIpSojhuDGRta4A7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V8AnlbF1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V8AnlbF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C6C1F000E9;
	Mon, 20 Jul 2026 06:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784527415;
	bh=3PLAZ2F8Ek2W3c5JVGwAy/aJ57wl9izpplJ3MzxwtYQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V8AnlbF10ABgFzCGBsMRr/tWpYjS4HEyAEAQPoI1jT+Y7O/+vOdYPM+Q1UdKSx6Hh
	 KArY47KP0/7WpBqGx9N+JyHkKrEotPJiqS5sFfC0CAKwZAafZeEAlkARSh15bCJpyD
	 bOGoUbxyW3tcDVOCmO0lzrnl5gtmrB9ARfENcgS9TuV5cCYMMDIPTvlTIzOcs0RJE0
	 VG0yWVhS+JojWs6ect9EpbpIv+yl7pylVj0I2c7jIo22tHJZtHv2SSObDeMAEuHdfh
	 jDBeRVrpvKq7xXcfKMMchXkj3Izhob6vZAgvimPdC4rQoP9h5IZMI2NqMcuJr0SEa8
	 pJSigDqoI7atg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 12/16] KVM: arm64: PMU: Pass the pPMU to
 kvm_map_pmu_event()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Akihiko Odaki" <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260720-hybrid-v9-12-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
 <20260720-hybrid-v9-12-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 06:03:34 +0000
Message-Id: <20260720060334.E9C6C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Host kernel panic via NULL pointer dereference in PMU event cr=
eation when a guest without a PMU toggles `MDCR_EL2.HPME`.
--

--- Patch [12]: [PATCH v9 12/16] KVM: arm64: PMU: Pass the pPMU to kvm_map_=
pmu_event() ---
commit 61c39cb093b2170b92839ae7097044db9d1474cc
Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

KVM: arm64: PMU: Pass the pPMU to kvm_map_pmu_event()

This patch updates kvm_map_pmu_event() to accept the PMU structure directly
rather than implicitly looking it up via the VM argument. This prepares the
code to map events against a per-vCPU selected pPMU in the future.

> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index c5c505b6fc61c..27db8877f96ea 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
[ ... ]
> @@ -725,7 +723,7 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc =
*pmc)
>  	 * Don't create an event if we're running on hardware that requires
>  	 * PMUv3 event translation and we couldn't find a valid mapping.
>  	 */
> -	eventsel =3D kvm_map_pmu_event(vcpu->kvm, eventsel);
> +	eventsel =3D kvm_map_pmu_event(vcpu->kvm->arch.arm_pmu, eventsel);

[Severity: Critical]
This is a pre-existing issue, but this change makes it a bit more explicit.
Could this pass a NULL pointer to kvm_map_pmu_event() and cause a host kern=
el
panic?

If a guest with nested virtualization enabled but no PMU configured toggles
the MDCR_EL2.HPME bit, access_mdcr() will unconditionally trigger a
KVM_REQ_RELOAD_PMU request without checking if the VM actually has a PMU.

When kvm_vcpu_reload_pmu() handles this request on the next vCPU entry,
it tries to reprogram the cycle counter (which defaults to enabled). This
eventually reaches kvm_pmu_create_perf_event():

arch/arm64/kvm/sys_regs.c:access_mdcr() {
    ...
    kvm_pmu_handle_mdcr(vcpu, old, val); /* Triggers KVM_REQ_RELOAD_PMU */
}

arch/arm64/kvm/pmu-emul.c:kvm_pmu_create_perf_event() {
    ...
    eventsel =3D kvm_map_pmu_event(vcpu->kvm->arch.arm_pmu, eventsel);
}

arch/arm64/kvm/pmu-emul.c:kvm_map_pmu_event() {
    ...
    if (unlikely(pmu->map_pmuv3_event)) /* NULL pointer dereference */
}

Because no PMU was initialized for this guest, vcpu->kvm->arch.arm_pmu is N=
ULL.

Could access_mdcr() or kvm_pmu_create_perf_event() check if the PMU is
actually initialized before attempting to create events?

>  	if (eventsel < 0)
>  		return;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720-hybrid-v9-=
0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp?part=3D12
