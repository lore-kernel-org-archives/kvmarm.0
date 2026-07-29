Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C2235E1C5
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 17:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785347153; cv=none; b=VsS/+E6oOveLoqiY4/mt8lzM0QbNOBIsESeLEKftSwvHnXREb2Nw+lHFTmWsMC5BPEm+/zDx9zbmRu6tfYXo21jsgJUk1Q8ze2S1wHGIbJRqtfO+hTAV/YHfkzFU+269uREydzyN/mzunDwgheSxHtlv0kGKigv9cwCvUjEXLdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785347153; c=relaxed/simple;
	bh=zfmqSG45MPP18hMoaAXwcOuAm70pzOQ7EdxS1N12l4I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FdIRWWt40UD+AI/vEgffvc1sspXu1aegkDZaUfWGD2BG4tr20BjezqgIDVyet4k9fmwjBx0kYwKtqjNlWsy29Ad7nb51n4w89c8bQFrusoCcJJBcBtuKKvxnKFdKTtFpJxIToNLw7Wz4C/Zq9+PRbnQFx4qOnxhCFnKf8jBssL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=F6hYzuHY; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="F6hYzuHY"
X-Forwarded-Encrypted: i=1; AHgh+RrRfR0qBNIVo21YeJD6k7p9SP2ylef0Eee7Upbr79DV4rN21FujGPSiDyT4WH2/ocRcS/h3uo8=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785347147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0y7NAqhy+F78Z9m8RS3MxYSs5HfIndgDT2RQmGz4iCU=;
	b=F6hYzuHYY1Gr8n5pc69aglAcdhD6h2wv0ak0VKAvjHbG3qWPH6/eqH8cfCxOLJ21yB8peF
	ywRN7torIhqICipadN3Kc7+rtV3/H2uwE6+wdzURPXch5LhWDEWlQDNXyhZ79ne2SqKQGO
	Jd+Vlj1KUsWj6gq5rXl3ozYIuri2d6U=
X-Gm-Message-State: AOJu0YyV5mBaqd6lUcsYnus68yDL1OxJIG3kbXDe7E1Q62dR6WE9Ibt7
	Dus1Rj2dbrCCwvhmyaK8OeTfsK+KhVJa1yzJSj8qWVSK1ZFzn5Unk3H2F2K0g7s5eD8O3V8nLeO
	FVGVxPmAv2qgQ+K5rbDEXjFwuMjNT7jFeakybZOaq
X-Received: by 2002:a05:6512:12c3:b0:5ae:b1b3:145a with SMTP id
 2adb3069b0e04-5b2d9b5dff2mr47211e87.6.1785347137689; Wed, 29 Jul 2026
 10:45:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
 <20260720-hybrid-v9-12-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp> <20260720060334.E9C6C1F000E9@smtp.kernel.org>
In-Reply-To: <20260720060334.E9C6C1F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 29 Jul 2026 18:44:58 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxzBQd5uqQBty_qjhsGv3XSTt-v2V0JAhm+9OWG8akVvA@mail.gmail.com>
X-Gm-Features: AUfX_mx1MxbMGozpXwtZYMAWoytrKt8CWyfo8MLfsYTWkLY03ClZGM1tdaj7_iY
Message-ID: <CA+EHjTxzBQd5uqQBty_qjhsGv3XSTt-v2V0JAhm+9OWG8akVvA@mail.gmail.com>
Subject: Re: [PATCH v9 12/16] KVM: arm64: PMU: Pass the pPMU to kvm_map_pmu_event()
To: sashiko-reviews@lists.linux.dev
Cc: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Mon, 20 Jul 2026 at 07:03, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [Critical] Host kernel panic via NULL pointer dereference in PMU event =
creation when a guest without a PMU toggles `MDCR_EL2.HPME`.

I don't think it's reachable. With no PMU, arm_pmu is NULL but the
event is never created: the cycle counter can't be enabled (PMCR.E is
0 and the guest can't write the hidden PMCR), and the
nested-transition path is gated by kvm_vcpu_has_pmu().

/fuad

> --
>
> --- Patch [12]: [PATCH v9 12/16] KVM: arm64: PMU: Pass the pPMU to kvm_ma=
p_pmu_event() ---
> commit 61c39cb093b2170b92839ae7097044db9d1474cc
> Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
>
> KVM: arm64: PMU: Pass the pPMU to kvm_map_pmu_event()
>
> This patch updates kvm_map_pmu_event() to accept the PMU structure direct=
ly
> rather than implicitly looking it up via the VM argument. This prepares t=
he
> code to map events against a per-vCPU selected pPMU in the future.
>
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index c5c505b6fc61c..27db8877f96ea 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> [ ... ]
> > @@ -725,7 +723,7 @@ static void kvm_pmu_create_perf_event(struct kvm_pm=
c *pmc)
> >        * Don't create an event if we're running on hardware that requir=
es
> >        * PMUv3 event translation and we couldn't find a valid mapping.
> >        */
> > -     eventsel =3D kvm_map_pmu_event(vcpu->kvm, eventsel);
> > +     eventsel =3D kvm_map_pmu_event(vcpu->kvm->arch.arm_pmu, eventsel)=
;
>
> [Severity: Critical]
> This is a pre-existing issue, but this change makes it a bit more explici=
t.
> Could this pass a NULL pointer to kvm_map_pmu_event() and cause a host ke=
rnel
> panic?
>
> If a guest with nested virtualization enabled but no PMU configured toggl=
es
> the MDCR_EL2.HPME bit, access_mdcr() will unconditionally trigger a
> KVM_REQ_RELOAD_PMU request without checking if the VM actually has a PMU.
>
> When kvm_vcpu_reload_pmu() handles this request on the next vCPU entry,
> it tries to reprogram the cycle counter (which defaults to enabled). This
> eventually reaches kvm_pmu_create_perf_event():
>
> arch/arm64/kvm/sys_regs.c:access_mdcr() {
>     ...
>     kvm_pmu_handle_mdcr(vcpu, old, val); /* Triggers KVM_REQ_RELOAD_PMU *=
/
> }
>
> arch/arm64/kvm/pmu-emul.c:kvm_pmu_create_perf_event() {
>     ...
>     eventsel =3D kvm_map_pmu_event(vcpu->kvm->arch.arm_pmu, eventsel);
> }
>
> arch/arm64/kvm/pmu-emul.c:kvm_map_pmu_event() {
>     ...
>     if (unlikely(pmu->map_pmuv3_event)) /* NULL pointer dereference */
> }
>
> Because no PMU was initialized for this guest, vcpu->kvm->arch.arm_pmu is=
 NULL.
>
> Could access_mdcr() or kvm_pmu_create_perf_event() check if the PMU is
> actually initialized before attempting to create events?
>
> >       if (eventsel < 0)
> >               return;
> >
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720-hybrid-v=
9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp?part=3D12
>
