Received: from mta1.migadu.com (out-20.mta1.migadu.com [95.215.58.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CAD37DE99
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 18:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786992087; cv=none; b=gqe8EuebjGW8bHOBnmcnTMaOg+YlE40mzFqLpjDalWV9aTdDRaNRxUflAFTE6PQnNG3tUddlM6ryMNCW6vNsR2NRAtxudHneZITKUpv3tmX+ehqGM6xzh9qTNwLotjUIGL6b22PJaXPWOmzivZPuBXE7H8moryCXze5fcu66SiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786992087; c=relaxed/simple;
	bh=RrHhJ3A9FoasjBOLHlVqix4YEDNoiM+OR7lzWl4jd7s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HeViIv46gxxIDoybceV1wBrnV1CFNBZHRSpQmXL7dD9KGrzKPvEu0Lrr6S8OeNknFaonRsPrCPbINdhLlMQlj81f0k7cMxeKPtmEycwxxvej7VVcsC5MXjyJwqscM5xI7dfwKUVQbFFhMi1km0mHTgnxDpcdf/iynfsiDgplXlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pwVKxUBS; arc=none smtp.client-ip=95.215.58.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pwVKxUBS"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=RrHhJ3A9FoasjBOLHlVqix4YEDNoiM+OR7lzWl4jd7s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786992081; v=1; x=1787596881;
 b=pwVKxUBSJowIC4RTs+XVwBffaSRpiEzmqVy/OhGzh13F4gkcRHvQV8vSKtO2qGnvOSsRVXwz
 mMmxh1wWKyxtSpZUZIH7cpBBVckJlMjH/v31QyIecsh66xeFql3cGo9iuzkAy2IlKNsr2S20lI8
 cb2lScW0KFUXet4JKzQ/oXW0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f49.google.com (209.85.167.49)
	by smtp.migadu.com with ESMTPS id 9ec6ec17100ceaec;
	Mon, 17 Aug 2026 18:41:21 +0000
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b0129cf6ffso1233e87.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 11:41:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpvH6wQLZNI2/7+kp75uyZJwrW2vpZnRFzlimlIiF2O3abvx1quDeZmrvrYKRhEiCEN9XPuCYg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0m60jhXJtcJcEtpH8VY3AahPgh2sEEqURKdd2atHIt1o79k1w
	H5OBctdguf2ekTi49lYRxyCCX0cwtKgFROswGbyl3Z/yvrj3tL9SzYSv4sWxikhHufjyel0sb/p
	bmyOnFC+mfLVskIZLGRTsZklYddfXYRaoFUSez3zg
X-Received: by 2002:a05:6512:4027:b0:5b1:5e30:ab4d with SMTP id
 2adb3069b0e04-5b471fde592mr33238e87.5.1786992076773; Mon, 17 Aug 2026
 11:41:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260807104102.2410744-1-fuad.tabba@linux.dev>
 <20260807104102.2410744-3-fuad.tabba@linux.dev> <20260807105558.73D701F000E9@smtp.kernel.org>
 <CA+EHjTwVKkAwWUeMrF_m2-35kyhESqAezOKJy-Pj=vA3qE5Bjw@mail.gmail.com> <87fr0pq5uu.wl-maz@kernel.org>
In-Reply-To: <87fr0pq5uu.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 17 Aug 2026 19:40:40 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyQ-1sUhgs0LNuPa-VJ=J=+vS7UCwJJU0ATJG9LtEQpSA@mail.gmail.com>
X-Gm-Features: AcwNN1VrtrWbBJrYrjs_GvIHapN_ve_R88uonv4ayDAbGZQ7xJ3qvWzDpPWhULU
Message-ID: <CA+EHjTyQ-1sUhgs0LNuPa-VJ=J=+vS7UCwJJU0ATJG9LtEQpSA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Don't leak the SPI array when
 init is retried
To: Marc Zyngier <maz@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 7 Aug 2026 at 16:58, Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 07 Aug 2026 13:15:52 +0100,
> Fuad Tabba <fuad.tabba@linux.dev> wrote:
> >
> > On Fri, 7 Aug 2026 at 11:56, <sashiko-bot@kernel.org> wrote:
> > >
> > > Thank you for your contribution! Sashiko AI review found 1 potential =
issue(s) to consider:
> >
> > No, thank _you_ Sashiko!
> >
> > >
> > > Pre-existing issues:
> > > - [High] If `vgic_init()` fails after `vgic_v4_init()` succeeds, the =
VPE array is left allocated but `vgic_initialized` remains false. Userspace=
 can then create additional VCPUs and retry `vgic_init()`. The second `vgic=
_v4_init()` returns early because the VPE array is already allocated, leavi=
ng the new VCPUs without initialized VPE IRQs.
> > ...
> > > When a new VCPU runs, `vgic_v4_load()` calls `irq_set_affinity()` wit=
h an uninitialized IRQ (0), which fails and triggers a host `WARN_ON`, caus=
ing a host-side denial of service.
> >
> > This is a separate fix. But you're right about the state.
> > kvm_arch_vcpu_precreate() only refuses vCPUs once vgic_initialized()
> > is true, so the retry admits one the VPE array does not cover.
> >
> > I don't think a VMM can drive it. kvm_vgic_setup_default_irq_routing()
> > is the only failure after vgic_v4_init(), and it builds its own
> > routing entries, so nothing short of a real -ENOMEM fails it.
> >
> > The fix I have in mind keeps vgic_v4_init() idempotent, as this patch
> > is: return early only while the vCPU count is unchanged, rebuild when
> > it grew. That needs its_free_vcpu_irqs() to clear vm->domain and
> > vm->fwnode first, which it does not today, so its_alloc_vcpu_irqs()
> > can reach its error path with a domain it has already removed.
> >
> > Let me think about it some more and I'll send something once others
> > have had a chance to digest this as well.
>
> I don't think we should grow anything opportunistically.
>
> The GICv4 code expects the number of vcpus to be fixed when first
> initialised, and if we must fail it one way or another, then
> everything should be torn down and reinitialised from scratch.
>
> I really don't want to have to think about the intermediate state.

Agreed. I'll drop the idempotent version I sketched and do teardown
and reinit instead.

Cheers,
/fuad

>
> Thanks,
>
>         M.
>
> --
> Jazz isn't dead. It just smells funny.
