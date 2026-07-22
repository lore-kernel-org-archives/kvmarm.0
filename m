Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D77435C6AC
	for <kvmarm@lists.linux.dev>; Wed, 22 Jul 2026 15:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784733061; cv=none; b=U1EzxL8EFMAd9idFPhF5qTv7cRjRJzwgwP8N5K9NfEYRIDo+PwMyHVKK8lkwjk2Ft/K4exozI5/3TjWjV/GAikzsNKq8+wZ0Lgkcf5DScpDQOm3Ub5CbHrWGATjtf70tIJg8c3BRZQ3SrRoSxg0l9/m9pU+sDqFzDqApqJ0x6xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784733061; c=relaxed/simple;
	bh=joPBJZIeeEoyn3WY5PVmXu/ldAZK1UP8QHTwkGX4oqI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bn85Y2wk2UDBjFLofLpMhveaE5RtsXOENmgY54tv5iFQpnrlyjFp9bO0W1zNZJ48m0ce4+yDkrmrAFAMNbmEewAC3lBmD0yrzGo9JEbAyRadMqe0Iv2N/SOS3ClK8MQe/UcnJnH4bojMBxPdVBIggyYM2a13J67M9RoTL0VkyJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZCJxKYRU; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZCJxKYRU"
X-Forwarded-Encrypted: i=1; AHgh+RodWSpOnhh6FOLZV+d5zAVHmpao89vtHQMC1UXgTmolbsLdBxkPMCW9VAaqPwL85+mVUl72W9s=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784733055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+eXziWrVe6iq+ExZQ6O6xmITHayaDdJsXK4xTLpyju8=;
	b=ZCJxKYRUsxH23iQ46/kdw8Hymu8sA9oS0cMpNkZbhdUCveLST/ZtgbPQOKRhcsXM1DISdf
	8SFS2qUZKb9G6KyIyzriVj8N9IEU/Dzk7uj++rqOqHpqUX5VNZqIk58k0RfkFmVeJssmNi
	X0DGo5v1PZ7xSC/el2k09PzWt5eroy4=
X-Gm-Message-State: AOJu0YzbSzbdlrQARSBbh83Lkz10BZPbedCYrwqlUJAmj1Tp+u87mooW
	m3PbEgAwyQisQt9/p+WcG1FfTdlpIUVLBMKImkdWfTCXyR4XrAAeu0qkX/5NRh6zxBtGY55Yjka
	5e3bInhP/Ph0CwRnitnnx226fAFh+vtPLdBbfJIC0
X-Received: by 2002:a05:622a:1819:b0:50d:edb1:6bd1 with SMTP id
 d75a77b69052e-527ef056bdcmr9238801cf.13.1784733045941; Wed, 22 Jul 2026
 08:10:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <CA+EHjTx4RHdZEnkLwF=ptKiONYzG+roaoKA+pN3K8xZQB2ohGA@mail.gmail.com> <f84f1481f0a0fe0abe9c8b7b044c9987368005d2.camel@arm.com>
In-Reply-To: <f84f1481f0a0fe0abe9c8b7b044c9987368005d2.camel@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 22 Jul 2026 16:10:09 +0100
X-Gmail-Original-Message-ID: <CA+EHjTz5oM=5CtTqWJ5W0svZXTH5TaAyr9fceFNHsd7T=Yq67Q@mail.gmail.com>
X-Gm-Features: AUfX_mw9L8L6cSBsUGZVddvjS8Pti3Yc-w-b5bisisvngAzfQGu0uw0y7hIVvCQ
Message-ID: <CA+EHjTz5oM=5CtTqWJ5W0svZXTH5TaAyr9fceFNHsd7T=Yq67Q@mail.gmail.com>
Subject: Re: [PATCH v3 00/40] KVM: arm64: Add GICv5 IRS support
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>, 
	Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, 
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, 
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Sascha,

On Wed, 22 Jul 2026 at 15:40, Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:
...
> > I have started working through this series and will send per-patch
> > comments as I go, starting with the userspace interface since that's
> > trickier to change later. I am still coming up to speed on GICv5, so
> > please take these with that in mind. A couple of series level things
> > first, while v4 is still open.
>
> Thanks a lot for taking the time and for any and all comments.

Thanks, that answers most of what I was after.

...

> I have a set of tests that look at the various "components" that we
> have in the GICv5 KVM implementation, including the IST save/restore.
> This latter test does also save/restore the IRS MMIO regs as part of
> testing the IST save/restore.

Good that the round trip already exists, that was really the question.
One thing I could not tell from the output: does the test compare the
restored state against the saved state field by field, so that a
dropped field fails it, rather than just a save and restore within one
VM? That is what would give the confidence you asked for on omitted
state. If it already does, worth a line in the cover letter.

> These do add a further ~2k lines to review across 9 commits, which is
> why I'd not included them in the series posting. The git diff --stat
> for the local series with these included is currently:

I would still land them in tree rather than point at them: out-of-tree
tests give reviewers nothing to run and no regression cover, which is
where the ordering constraints most need it. The test code is not the
expensive part of the review, the ~6000 lines of IRS and table code
are, so the selftests help more than they cost. If nine commits is too
much at once, the IST save/restore one is the piece I would most want
alongside the save/restore code, the rest can follow.

...

> Noted - I should have been clearer here. The intent was that the
> save/restore functionality was bundled together with the IRS, SPI, and
> LPI support. With this series it becomes possible to run something real
> with KVM on a GICv5 system. Prior to this series, we only had PPI
> support which also meant a single VPE, and no ability to run anything
> particularly meaningful.
>
> Personally, I'm quite happy to do whatever is best for the reviewers to
> make things as easy to review as possible. I can either extend the
> series with the set of selftests, or I can drop the save/restore
> support for the time being. Happy to hear your thoughts. FWIW, I
> believe that Marc preferred them to land together for the reason above.

Makes sense, no objection to keeping them together. Worth putting in
the v4 cover letter so the next reader does not have to ask. One thing
on the reasoning: "run something real" argues for SPI and LPI landing
together, since a guest boots without save/restore. Bundling
save/restore itself reads more like not shipping a feature userspace
can create but not migrate, then retrofitting the ABI later. If that
is the reason, worth saying so.

Cheers,
/fuad


>
> Thanks again for your input.
> Sascha
>
> >
> > Cheers,
> > /fuad
> >
> >
> >
> > >
> > > Thanks,
> > > Sascha
> > >
> > > [1]
> > > https://lore.kernel.org/all/20260319154937.3619520-1-sascha.bischoff@arm.com/
> > > [2] https://developer.arm.com/documentation/aes0070/latest
> > > [3] https://developer.arm.com/documentation/108086/latest
> > > [4] https://linaro.atlassian.net/wiki/x/CQAF-wY
> > > [5]
> > > https://lore.kernel.org/all/20260116182606.61856-1-sascha.bischoff@arm.com/
> > > [6]
> > > https://gitlab.arm.com/linux-arm/linux-sb/-/tree/gicv5_kvm_irs_support_v3
> > > [7]
> > > https://lore.kernel.org/all/20260427160547.3129448-1-sascha.bischoff@arm.com/
> > > [8]
> > > https://lore.kernel.org/all/20260521144846.1899475-1-sascha.bischoff@arm.com/
> > >
> > > Sascha Bischoff (40):
> > >   irqchip/gic-v5: Allow KVM setup without a maintenance IRQ
> > >   irqchip/gic-v5: Provide OF IRS config frame attrs to KVM
> > >   irqchip/gic-v5: Set up gic_kvm_info on ACPI hosts
> > >   KVM: arm64: gic-v5: Define remaining IRS MMIO registers
> > >   arm64/sysreg: Add GICv5 GIC VDPEND and VDRCFG encodings
> > >   arm64/sysreg: Update ICC_CR0_EL1 with LINK and LINK_IDLE fields
> > >   KVM: arm64: gic-v5: Extract host IRS caps from IRS config frame
> > >   KVM: arm64: gic-v5: Add VPE doorbell domain
> > >   KVM: arm64: gic-v5: Create and manage VM and VPE tables
> > >   KVM: arm64: gic-v5: Introduce guest IST alloc and management
> > >   KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops
> > >   KVM: arm64: gic-v5: Keep GICv5 vCPU limit model-specific
> > >   KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
> > >   KVM: arm64: gic-v5: Set up VMTEs and VPE doorbells
> > >   KVM: arm64: gic-v5: Add resident/non-resident hyp calls
> > >   KVM: arm64: gic-v5: Request doorbells when VPEs enter WFI
> > >   KVM: arm64: gic-v5: Introduce struct vgic_v5_irs and IRS base
> > > address
> > >   KVM: arm64: gic-v5: Add IRS IODEV support to MMIO handlers
> > >   KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
> > >   KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO emulation
> > >   KVM: arm64: gic-v5: Initialise per-VM IRS state
> > >   KVM: arm64: gic-v5: Register the IRS IODEV
> > >   KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS enable state
> > >   KVM: arm64: selftests: Update vGICv5 selftest to set IRS address
> > >   KVM: arm64: gic-v5: Introduce SPI AP list
> > >   KVM: arm64: gic-v5: Add GIC VDPEND and GIC VDRCFG hyp calls
> > >   KVM: arm64: gic-v5: Track SPI state for in-flight SPIs
> > >   KVM: arm64: gic: Introduce set_pending_state() to irq_op
> > >   KVM: arm64: gic-v5: Support SPI injection
> > >   Documentation: KVM: Extend VGICv5 docs for
> > > KVM_VGIC_V5_ADDR_TYPE_IRS
> > >   KVM: arm64: gic-v5: Add GICv5 SPI injection to irqfd
> > >   KVM: arm64: gic-v5: Mask per-vcpu PPI state in
> > >     vgic_v5_finalize_ppi_state()
> > >   KVM: arm64: gic-v5: Add GICv5 EL1 sysreg userspace accessors
> > >   KVM: arm64: gic-v5: Handle userspace accesses to IRS MMIO region
> > >   KVM: arm64: gic-v5: Add CoreSight MMIO regs to IRS
> > >   KVM: arm64: gic-v5: Implement save/restore mechanisms for ISTs
> > >   Documentation: KVM: Document KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for
> > >     VGICv5
> > >   Documentation: KVM: Add KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5
> > > docs
> > >   Documentation: KVM: Add docs for KVM_DEV_ARM_VGIC_GRP_IST
> > >   Documentation: KVM: Add the VGICv5 IRS save/restore sequences
> > >
> > >  .../virt/kvm/devices/arm-vgic-v5.rst          |  237 ++-
> > >  arch/arm64/include/asm/kvm_asm.h              |    4 +
> > >  arch/arm64/include/asm/kvm_hyp.h              |    4 +
> > >  arch/arm64/include/asm/sysreg.h               |   18 +-
> > >  arch/arm64/include/uapi/asm/kvm.h             |    7 +
> > >  arch/arm64/kvm/Makefile                       |    3 +-
> > >  arch/arm64/kvm/arm.c                          |    2 +-
> > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   34 +
> > >  arch/arm64/kvm/hyp/vgic-v5-sr.c               |   55 +
> > >  arch/arm64/kvm/sys_regs.c                     |    6 +-
> > >  arch/arm64/kvm/vgic-sys-reg-v5.c              |  519 +++++
> > >  arch/arm64/kvm/vgic/vgic-init.c               |  111 +-
> > >  arch/arm64/kvm/vgic/vgic-irqfd.c              |   17 +-
> > >  arch/arm64/kvm/vgic/vgic-irs-v5.c             | 1138 ++++++++++
> > >  arch/arm64/kvm/vgic/vgic-kvm-device.c         |  252 ++-
> > >  arch/arm64/kvm/vgic/vgic-mmio.c               |    6 +
> > >  arch/arm64/kvm/vgic/vgic-mmio.h               |    2 +
> > >  arch/arm64/kvm/vgic/vgic-v5-tables.c          | 1855
> > > +++++++++++++++++
> > >  arch/arm64/kvm/vgic/vgic-v5-tables.h          |  112 +
> > >  arch/arm64/kvm/vgic/vgic-v5.c                 | 1220 ++++++++++-
> > >  arch/arm64/kvm/vgic/vgic.c                    |   39 +-
> > >  arch/arm64/kvm/vgic/vgic.h                    |   21 +-
> > >  arch/arm64/tools/sysreg                       |    4 +-
> > >  drivers/irqchip/irq-gic-v5-irs.c              |   19 +-
> > >  drivers/irqchip/irq-gic-v5.c                  |  117 +-
> > >  include/kvm/arm_vgic.h                        |  165 +-
> > >  include/linux/irqchip/arm-gic-v5.h            |  256 ++-
> > >  include/linux/irqchip/arm-vgic-info.h         |    5 +
> > >  tools/arch/arm64/include/uapi/asm/kvm.h       |    7 +
> > >  tools/testing/selftests/kvm/arm64/vgic_v5.c   |    6 +
> > >  .../selftests/kvm/include/arm64/gic_v5.h      |    3 +
> > >  31 files changed, 6093 insertions(+), 151 deletions(-)
> > >  create mode 100644 arch/arm64/kvm/vgic-sys-reg-v5.c
> > >  create mode 100644 arch/arm64/kvm/vgic/vgic-irs-v5.c
> > >  create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.c
> > >  create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.h
> > >
> > > --
> > > 2.34.1
> > >
>
