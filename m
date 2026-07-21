Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157143A1B5
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 12:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784637701; cv=none; b=axteQuZkXR8lTd4yQ/SIKbUqFOvz+mY2k4sFGPQpmtfeQVE3wHSksetQeKMlyYYVhoeT8PuwJFuXVBIhFKzs1UE16Y0hGpagYqI0tUaXHCSDsBy3jPUpBOly3+GKN8RNFspzS/umH+cC3ZIVI3S5R8EfYl6TytmToXYE8C4I3J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784637701; c=relaxed/simple;
	bh=qhlNccdn6VSnaHgMArV9jVsfTdt8p0NwDmK+//UyHZQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HR2DiE9A0iUHKYbB/fXY05yJnes6PhxSXkIFQwF8HuLOV08FRtUm86cpKU4KEl3ZmHOSJ43CtF81WM6l1iBBch4vTC+vGBUr+iYpcsd2tLMGc9oN0iqIXe4A7/zp5NVZ/CDj+BoIEZMsz+R6IBEO7LAUx+3xf9p6Nw6QL9oqcaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OF91ug4u; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OF91ug4u"
X-Forwarded-Encrypted: i=1; AHgh+Rr710CtxXcJPXJzJcEE8NRW7Ujg8lcLDlmVCKuLVO+8xKD35QJeMs/xdE1rcPDtk/hpTRh+5Ps=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784637697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hbo0rEPdyo/RS3klqwsaW7ttCGK52Wr2lekvLCNfpdU=;
	b=OF91ug4umgTkIf7LkMP39PS2DDLsCfl+yvmrDlzfR/lwmf5o4EQOs2DDP8Q3LoE41xICCN
	6ydqLg0OJ4/U0ehC8m80LU1aAFIPHWAQpJq9W2DpUqNjvN4d1bipIhIAv01U047sX8jRsw
	1t8vfK/bR/hmJf5t3dQ1joOGEi72Yvo=
X-Gm-Message-State: AOJu0YzVv51AJs4YvKw9bhdpGJCuFO8ngWQNXTXpWCvMIaxGOwVQOFiN
	u7bSAJjpbIbQCA6tDxavA5cQ7vI421/izp3gvCRgLfB1JhDWbfY6g9mLq+nIVHR/NukUBoOECgb
	0TCsEZ3cBDNfrbSAg9C1/G58KrzB9tGPZoTVJXsEp
X-Received: by 2002:ac8:7e86:0:b0:517:38aa:c2b3 with SMTP id
 d75a77b69052e-526020ed9dfmr13556821cf.14.1784637687132; Tue, 21 Jul 2026
 05:41:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
In-Reply-To: <20260703154811.3355680-1-sascha.bischoff@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 21 Jul 2026 13:40:50 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx4RHdZEnkLwF=ptKiONYzG+roaoKA+pN3K8xZQB2ohGA@mail.gmail.com>
X-Gm-Features: AUfX_mzQ7GQavo_zxl1H71frf9lmbFIPMvmXQfzg2YVNT5U2ew1mgekfSOgS1Bw
Message-ID: <CA+EHjTx4RHdZEnkLwF=ptKiONYzG+roaoKA+pN3K8xZQB2ohGA@mail.gmail.com>
Subject: Re: [PATCH v3 00/40] KVM: arm64: Add GICv5 IRS support
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>, 
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, 
	Suzuki Poulose <Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>, 
	Timothy Hayes <Timothy.Hayes@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Sacha,

I have started working through this series and will send per-patch
comments as I go, starting with the userspace interface since that's
trickier to change later. I am still coming up to speed on GICv5, so
please take these with that in mind. A couple of series level things
first, while v4 is still open.

...

> Please pay close attention to the save/restore interface and ordering,
> in particular to make sure that no guest state has been omitted.

This is around 6000 lines of new code, and the only test change is the
nine lines that keep the existing vGICv5 selftest passing now that the
IRS address is mandatory.

The ordering part is what worries me most here. Reading the save and
restore sequences in the documentation, several of the constraints
exist only as prose, for instance that guest memory must be serialised
after the ISTs have been saved. Nothing in the API expresses them, so
a VMM that gets one wrong gets no error, and finds out on the
destination. A save/restore round trip selftest would turn that whole
class of thing into something mechanical. Would one be feasible for
the IRS and IST state? Without it I am not sure how much confidence a
reviewer can really give you on the request above.

...

> Thanks for taking the time to look at these changes. Apologies for the
> size of the series, but this is a rather hard set to disentangle and
> review separately!

The apology rather invites the question, so it may be worth answering
it up front instead. From the outside, patches 33 to 40, which are
largely the userspace save/restore support and its documentation, look
separable from getting a GICv5 guest booting with SPIs and LPIs. If
you think migration support has to land together with the feature then
I would find that convincing, but it would help to say so. Given the
rework you have already described for v4, this might be a reasonable
moment to revisit the split.

Cheers,
/fuad



>
> Thanks,
> Sascha
>
> [1] https://lore.kernel.org/all/20260319154937.3619520-1-sascha.bischoff@arm.com/
> [2] https://developer.arm.com/documentation/aes0070/latest
> [3] https://developer.arm.com/documentation/108086/latest
> [4] https://linaro.atlassian.net/wiki/x/CQAF-wY
> [5] https://lore.kernel.org/all/20260116182606.61856-1-sascha.bischoff@arm.com/
> [6] https://gitlab.arm.com/linux-arm/linux-sb/-/tree/gicv5_kvm_irs_support_v3
> [7] https://lore.kernel.org/all/20260427160547.3129448-1-sascha.bischoff@arm.com/
> [8] https://lore.kernel.org/all/20260521144846.1899475-1-sascha.bischoff@arm.com/
>
> Sascha Bischoff (40):
>   irqchip/gic-v5: Allow KVM setup without a maintenance IRQ
>   irqchip/gic-v5: Provide OF IRS config frame attrs to KVM
>   irqchip/gic-v5: Set up gic_kvm_info on ACPI hosts
>   KVM: arm64: gic-v5: Define remaining IRS MMIO registers
>   arm64/sysreg: Add GICv5 GIC VDPEND and VDRCFG encodings
>   arm64/sysreg: Update ICC_CR0_EL1 with LINK and LINK_IDLE fields
>   KVM: arm64: gic-v5: Extract host IRS caps from IRS config frame
>   KVM: arm64: gic-v5: Add VPE doorbell domain
>   KVM: arm64: gic-v5: Create and manage VM and VPE tables
>   KVM: arm64: gic-v5: Introduce guest IST alloc and management
>   KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops
>   KVM: arm64: gic-v5: Keep GICv5 vCPU limit model-specific
>   KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
>   KVM: arm64: gic-v5: Set up VMTEs and VPE doorbells
>   KVM: arm64: gic-v5: Add resident/non-resident hyp calls
>   KVM: arm64: gic-v5: Request doorbells when VPEs enter WFI
>   KVM: arm64: gic-v5: Introduce struct vgic_v5_irs and IRS base address
>   KVM: arm64: gic-v5: Add IRS IODEV support to MMIO handlers
>   KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
>   KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO emulation
>   KVM: arm64: gic-v5: Initialise per-VM IRS state
>   KVM: arm64: gic-v5: Register the IRS IODEV
>   KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS enable state
>   KVM: arm64: selftests: Update vGICv5 selftest to set IRS address
>   KVM: arm64: gic-v5: Introduce SPI AP list
>   KVM: arm64: gic-v5: Add GIC VDPEND and GIC VDRCFG hyp calls
>   KVM: arm64: gic-v5: Track SPI state for in-flight SPIs
>   KVM: arm64: gic: Introduce set_pending_state() to irq_op
>   KVM: arm64: gic-v5: Support SPI injection
>   Documentation: KVM: Extend VGICv5 docs for KVM_VGIC_V5_ADDR_TYPE_IRS
>   KVM: arm64: gic-v5: Add GICv5 SPI injection to irqfd
>   KVM: arm64: gic-v5: Mask per-vcpu PPI state in
>     vgic_v5_finalize_ppi_state()
>   KVM: arm64: gic-v5: Add GICv5 EL1 sysreg userspace accessors
>   KVM: arm64: gic-v5: Handle userspace accesses to IRS MMIO region
>   KVM: arm64: gic-v5: Add CoreSight MMIO regs to IRS
>   KVM: arm64: gic-v5: Implement save/restore mechanisms for ISTs
>   Documentation: KVM: Document KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for
>     VGICv5
>   Documentation: KVM: Add KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
>   Documentation: KVM: Add docs for KVM_DEV_ARM_VGIC_GRP_IST
>   Documentation: KVM: Add the VGICv5 IRS save/restore sequences
>
>  .../virt/kvm/devices/arm-vgic-v5.rst          |  237 ++-
>  arch/arm64/include/asm/kvm_asm.h              |    4 +
>  arch/arm64/include/asm/kvm_hyp.h              |    4 +
>  arch/arm64/include/asm/sysreg.h               |   18 +-
>  arch/arm64/include/uapi/asm/kvm.h             |    7 +
>  arch/arm64/kvm/Makefile                       |    3 +-
>  arch/arm64/kvm/arm.c                          |    2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   34 +
>  arch/arm64/kvm/hyp/vgic-v5-sr.c               |   55 +
>  arch/arm64/kvm/sys_regs.c                     |    6 +-
>  arch/arm64/kvm/vgic-sys-reg-v5.c              |  519 +++++
>  arch/arm64/kvm/vgic/vgic-init.c               |  111 +-
>  arch/arm64/kvm/vgic/vgic-irqfd.c              |   17 +-
>  arch/arm64/kvm/vgic/vgic-irs-v5.c             | 1138 ++++++++++
>  arch/arm64/kvm/vgic/vgic-kvm-device.c         |  252 ++-
>  arch/arm64/kvm/vgic/vgic-mmio.c               |    6 +
>  arch/arm64/kvm/vgic/vgic-mmio.h               |    2 +
>  arch/arm64/kvm/vgic/vgic-v5-tables.c          | 1855 +++++++++++++++++
>  arch/arm64/kvm/vgic/vgic-v5-tables.h          |  112 +
>  arch/arm64/kvm/vgic/vgic-v5.c                 | 1220 ++++++++++-
>  arch/arm64/kvm/vgic/vgic.c                    |   39 +-
>  arch/arm64/kvm/vgic/vgic.h                    |   21 +-
>  arch/arm64/tools/sysreg                       |    4 +-
>  drivers/irqchip/irq-gic-v5-irs.c              |   19 +-
>  drivers/irqchip/irq-gic-v5.c                  |  117 +-
>  include/kvm/arm_vgic.h                        |  165 +-
>  include/linux/irqchip/arm-gic-v5.h            |  256 ++-
>  include/linux/irqchip/arm-vgic-info.h         |    5 +
>  tools/arch/arm64/include/uapi/asm/kvm.h       |    7 +
>  tools/testing/selftests/kvm/arm64/vgic_v5.c   |    6 +
>  .../selftests/kvm/include/arm64/gic_v5.h      |    3 +
>  31 files changed, 6093 insertions(+), 151 deletions(-)
>  create mode 100644 arch/arm64/kvm/vgic-sys-reg-v5.c
>  create mode 100644 arch/arm64/kvm/vgic/vgic-irs-v5.c
>  create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.c
>  create mode 100644 arch/arm64/kvm/vgic/vgic-v5-tables.h
>
> --
> 2.34.1
>
