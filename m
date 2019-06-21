Return-Path: <SRS0=LUtr=UU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5A8C43613
	for <kvmarm@archiver.kernel.org>; Fri, 21 Jun 2019 13:00:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E912D21530
	for <kvmarm@archiver.kernel.org>; Fri, 21 Jun 2019 13:00:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SQvAF9EN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E912D21530
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88F834A331;
	Fri, 21 Jun 2019 09:00:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kOQUz0rbMeHQ; Fri, 21 Jun 2019 09:00:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 965A04A32E;
	Fri, 21 Jun 2019 09:00:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D59A04A4E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jun 2019 05:57:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id biY0OQDtqmiT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Jun 2019 05:57:35 -0400 (EDT)
Received: from mail-qt1-f193.google.com (mail-qt1-f193.google.com
 [209.85.160.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BCA744A389
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jun 2019 05:57:35 -0400 (EDT)
Received: by mail-qt1-f193.google.com with SMTP id d17so6235743qtj.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jun 2019 02:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=8GQhF/jDv1U3L0EK9zoOJNihmwjgS+qG74fJxRHMhRA=;
 b=SQvAF9EN0f5Yx9+H7jNFhVIzgqwb8+Y29KvGMv4h5G75G/z5+vf+KVODtGSUTRiISB
 2+XoZTvmAAfmIBrtbnUy3woKXZadLB4nIEgLC7d6ue52LSGEI8BTF++52hyaTM48Zrco
 g3l6cTkwpoXq3bvpJ/qJ/9WtnBeVRltni0wfFdmGNoZN+s44gwLKvB+mRhWf+RAmZ8ws
 qYdVfFpVNT+rHt6XtPqGhSa21UScpv+LjpK5d9Ir3sBfadB9wKebsNkcn+vaGSk5ofyb
 T4tYEKDVxExsMp6LDU7LazMB89nFX3ln+6B10jSnkhP4d4mS4X6H7ehVmZhiNEpZWxGS
 QoMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=8GQhF/jDv1U3L0EK9zoOJNihmwjgS+qG74fJxRHMhRA=;
 b=krNqH3q0AGsfumFBEbaQOY8CgtBPoOdlpH4EZPJBQS644t/SGvcRFTRiGJ9wvev2MP
 0Qmxj2dwc4ikgonsSgvtUFXCmtPoOKNhZ92DSl+WYbh/kWyRmwQ0soSTdcPUKWJbZsv7
 IqGJHGknFDf95DnOHIpRvRdZWMt7H6qhM2NVK+WrV+eusz1p6nvKERF+X9alZyW1lwNb
 FG6kQX9Q1fQe3VhWsJPHY0lPEXKnv5TvXCCgRW19x7hqxpUxuuGoXm5WFFnxY2YhTLCi
 DbzLHfrQ0lrEfSBhD1fce26lXi2nqpmt6ofRl0nA8jCQeyeIdX9rmOlXSQtQver1Jbb4
 gPQA==
X-Gm-Message-State: APjAAAWW/dWK7hjJnVu5Fp/P2hH0xuJ1LV2Lw+sWGS2b2de0tNdloesn
 PxmRjw2sSXdIwFdRjj1cIrTplk/lYyHx+DyB8hE=
X-Google-Smtp-Source: APXvYqwhqEmrfhxN9at2ybqPBZSDl20q6HEh8+TNarSI/416zh1jkEKyIBttT+1OBo81B4Qr/wU6AeW9f9CHGfZLVpM=
X-Received: by 2002:ac8:82a:: with SMTP id u39mr59275351qth.370.1561111055150; 
 Fri, 21 Jun 2019 02:57:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190621093843.220980-1-marc.zyngier@arm.com>
In-Reply-To: <20190621093843.220980-1-marc.zyngier@arm.com>
From: Itaru Kitayama <itaru.kitayama@gmail.com>
Date: Fri, 21 Jun 2019 18:57:24 +0900
Message-ID: <CANW9uyssDm_0ysC_pnvhHRrnsmFZik+3_ENmFz7L2GCmtH09fw@mail.gmail.com>
Subject: Re: [PATCH 00/59] KVM: arm64: ARMv8.3 Nested Virtualization support
To: Marc Zyngier <marc.zyngier@arm.com>
X-Mailman-Approved-At: Fri, 21 Jun 2019 09:00:49 -0400
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4083313157863634577=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============4083313157863634577==
Content-Type: multipart/alternative; boundary="000000000000e5b269058bd27d3b"

--000000000000e5b269058bd27d3b
Content-Type: text/plain; charset="UTF-8"

Marc,
Only possible way to test this series is to get
on Fast Model?

On Fri, Jun 21, 2019 at 18:55 Marc Zyngier <marc.zyngier@arm.com> wrote:

> I've taken over the maintenance of this series originally written by
> Jintack and Christoffer. Since then, the series has been substantially
> reworked, new features (and most probably bugs) have been added, and
> the whole thing rebased multiple times. If anything breaks, please
> blame me, and nobody else.
>
> As you can tell, this is quite big. It is also remarkably incomplete
> (we're missing many critical bits for fully emulate EL2), but the idea
> is to start merging things early in order to reduce the maintenance
> headache. What we want to achieve is that with NV disabled, there is
> no performance overhead and no regression. The only thing I intend to
> merge ASAP is the first patch in the series, because it should have
> zero effect and is a reasonable cleanup.
>
> The series is roughly divided in 4 parts: exception handling, memory
> virtualization, interrupts and timers. There are of course some
> dependencies, but you'll hopefully get the gist of it.
>
> For the most courageous of you, I've put out a branch[1] containing this
> and a bit more. Of course, you'll need some userspace. Andre maintains
> a hacked version of kvmtool[1] that takes a --nested option, allowing
> the guest to be started at EL2. You can run the whole stack in the
> Foundation model. Don't be in a hurry ;-).
>
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git
> kvm-arm64/nv-wip-5.2-rc5
> [2] git://linux-arm.org/kvmtool.git nv/nv-wip-5.2-rc5
>
> Andre Przywara (4):
>   KVM: arm64: nv: Handle virtual EL2 registers in
>     vcpu_read/write_sys_reg()
>   KVM: arm64: nv: Save/Restore vEL2 sysregs
>   KVM: arm64: nv: Handle traps for timer _EL02 and _EL2 sysregs
>     accessors
>   KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ
>
> Christoffer Dall (16):
>   KVM: arm64: nv: Introduce nested virtualization VCPU feature
>   KVM: arm64: nv: Reset VCPU to EL2 registers if VCPU nested virt is set
>   KVM: arm64: nv: Allow userspace to set PSR_MODE_EL2x
>   KVM: arm64: nv: Add nested virt VCPU primitives for vEL2 VCPU state
>   KVM: arm64: nv: Handle trapped ERET from virtual EL2
>   KVM: arm64: nv: Emulate PSTATE.M for a guest hypervisor
>   KVM: arm64: nv: Trap EL1 VM register accesses in virtual EL2
>   KVM: arm64: nv: Only toggle cache for virtual EL2 when SCTLR_EL2
>     changes
>   KVM: arm/arm64: nv: Support multiple nested stage 2 mmu structures
>   KVM: arm64: nv: Implement nested Stage-2 page table walk logic
>   KVM: arm64: nv: Handle shadow stage 2 page faults
>   KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
>   KVM: arm64: nv: arch_timer: Support hyp timer emulation
>   KVM: arm64: nv: vgic-v3: Take cpu_if pointer directly instead of vcpu
>   KVM: arm64: nv: vgic: Emulate the HW bit in software
>   KVM: arm64: nv: Add nested GICv3 tracepoints
>
> Dave Martin (1):
>   KVM: arm64: Migrate _elx sysreg accessors to msr_s/mrs_s
>
> Jintack Lim (21):
>   arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
>   KVM: arm64: nv: Add EL2 system registers to vcpu context
>   KVM: arm64: nv: Support virtual EL2 exceptions
>   KVM: arm64: nv: Inject HVC exceptions to the virtual EL2
>   KVM: arm64: nv: Trap SPSR_EL1, ELR_EL1 and VBAR_EL1 from virtual EL2
>   KVM: arm64: nv: Trap CPACR_EL1 access in virtual EL2
>   KVM: arm64: nv: Set a handler for the system instruction traps
>   KVM: arm64: nv: Handle PSCI call via smc from the guest
>   KVM: arm64: nv: Respect virtual HCR_EL2.TWX setting
>   KVM: arm64: nv: Respect virtual CPTR_EL2.TFP setting
>   KVM: arm64: nv: Respect the virtual HCR_EL2.NV bit setting
>   KVM: arm64: nv: Respect virtual HCR_EL2.TVM and TRVM settings
>   KVM: arm64: nv: Respect the virtual HCR_EL2.NV1 bit setting
>   KVM: arm64: nv: Emulate EL12 register accesses from the virtual EL2
>   KVM: arm64: nv: Configure HCR_EL2 for nested virtualization
>   KVM: arm64: nv: Pretend we only support larger-than-host page sizes
>   KVM: arm64: nv: Introduce sys_reg_desc.forward_trap
>   KVM: arm64: nv: Rework the system instruction emulation framework
>   KVM: arm64: nv: Trap and emulate AT instructions from virtual EL2
>   KVM: arm64: nv: Trap and emulate TLBI instructions from virtual EL2
>   KVM: arm64: nv: Nested GICv3 Support
>
> Marc Zyngier (17):
>   KVM: arm64: Move __load_guest_stage2 to kvm_mmu.h
>   KVM: arm64: nv: Reset VMPIDR_EL2 and VPIDR_EL2 to sane values
>   KVM: arm64: nv: Handle SPSR_EL2 specially
>   KVM: arm64: nv: Refactor vcpu_{read,write}_sys_reg
>   KVM: arm64: nv: Don't expose SVE to nested guests
>   KVM: arm64: nv: Hide RAS from nested guests
>   KVM: arm/arm64: nv: Factor out stage 2 page table data from struct kvm
>   KVM: arm64: nv: Move last_vcpu_ran to be per s2 mmu
>   KVM: arm64: nv: Don't always start an S2 MMU search from the beginning
>   KVM: arm64: nv: Propagate CNTVOFF_EL2 to the virtual EL1 timer
>   KVM: arm64: nv: Load timer before the GIC
>   KVM: arm64: nv: Implement maintenance interrupt forwarding
>   arm64: KVM: nv: Add handling of EL2-specific timer registers
>   arm64: KVM: nv: Honor SCTLR_EL2.SPAN on entering vEL2
>   arm64: KVM: nv: Handle SCTLR_EL2 RES0/RES1 bits
>   arm64: KVM: nv: Restrict S2 RD/WR permissions to match the guest's
>   arm64: KVM: nv: Allow userspace to request KVM_ARM_VCPU_NESTED_VIRT
>
>  .../admin-guide/kernel-parameters.txt         |    4 +
>  .../virtual/kvm/devices/arm-vgic-v3.txt       |    9 +
>  arch/arm/include/asm/kvm_asm.h                |    5 +-
>  arch/arm/include/asm/kvm_emulate.h            |    3 +
>  arch/arm/include/asm/kvm_host.h               |   31 +-
>  arch/arm/include/asm/kvm_hyp.h                |   25 +-
>  arch/arm/include/asm/kvm_mmu.h                |   83 +-
>  arch/arm/include/asm/kvm_nested.h             |    9 +
>  arch/arm/include/uapi/asm/kvm.h               |    1 +
>  arch/arm/kvm/hyp/switch.c                     |   11 +-
>  arch/arm/kvm/hyp/tlb.c                        |   13 +-
>  arch/arm64/include/asm/cpucaps.h              |    3 +-
>  arch/arm64/include/asm/esr.h                  |    4 +-
>  arch/arm64/include/asm/kvm_arm.h              |   28 +-
>  arch/arm64/include/asm/kvm_asm.h              |    9 +-
>  arch/arm64/include/asm/kvm_coproc.h           |    2 +-
>  arch/arm64/include/asm/kvm_emulate.h          |  157 +-
>  arch/arm64/include/asm/kvm_host.h             |  105 +-
>  arch/arm64/include/asm/kvm_hyp.h              |   82 +-
>  arch/arm64/include/asm/kvm_mmu.h              |   62 +-
>  arch/arm64/include/asm/kvm_nested.h           |   68 +
>  arch/arm64/include/asm/sysreg.h               |  143 +-
>  arch/arm64/include/uapi/asm/kvm.h             |    2 +
>  arch/arm64/kernel/cpufeature.c                |   26 +
>  arch/arm64/kvm/Makefile                       |    4 +
>  arch/arm64/kvm/emulate-nested.c               |  223 +++
>  arch/arm64/kvm/guest.c                        |    6 +
>  arch/arm64/kvm/handle_exit.c                  |   76 +-
>  arch/arm64/kvm/hyp/Makefile                   |    1 +
>  arch/arm64/kvm/hyp/at.c                       |  217 +++
>  arch/arm64/kvm/hyp/switch.c                   |   86 +-
>  arch/arm64/kvm/hyp/sysreg-sr.c                |  267 ++-
>  arch/arm64/kvm/hyp/tlb.c                      |  129 +-
>  arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c      |    2 +-
>  arch/arm64/kvm/inject_fault.c                 |   12 -
>  arch/arm64/kvm/nested.c                       |  551 +++++++
>  arch/arm64/kvm/regmap.c                       |    4 +-
>  arch/arm64/kvm/reset.c                        |    7 +
>  arch/arm64/kvm/sys_regs.c                     | 1460 +++++++++++++++--
>  arch/arm64/kvm/sys_regs.h                     |    6 +
>  arch/arm64/kvm/trace.h                        |   58 +-
>  include/kvm/arm_arch_timer.h                  |    6 +
>  include/kvm/arm_vgic.h                        |   28 +-
>  virt/kvm/arm/arch_timer.c                     |  158 +-
>  virt/kvm/arm/arm.c                            |   62 +-
>  virt/kvm/arm/hyp/vgic-v3-sr.c                 |   35 +-
>  virt/kvm/arm/mmio.c                           |   12 +-
>  virt/kvm/arm/mmu.c                            |  445 +++--
>  virt/kvm/arm/trace.h                          |    6 +-
>  virt/kvm/arm/vgic/vgic-init.c                 |   30 +
>  virt/kvm/arm/vgic/vgic-kvm-device.c           |   22 +
>  virt/kvm/arm/vgic/vgic-nested-trace.h         |  137 ++
>  virt/kvm/arm/vgic/vgic-v2.c                   |   10 +-
>  virt/kvm/arm/vgic/vgic-v3-nested.c            |  236 +++
>  virt/kvm/arm/vgic/vgic-v3.c                   |   40 +-
>  virt/kvm/arm/vgic/vgic.c                      |   74 +-
>  56 files changed, 4683 insertions(+), 612 deletions(-)
>  create mode 100644 arch/arm/include/asm/kvm_nested.h
>  create mode 100644 arch/arm64/include/asm/kvm_nested.h
>  create mode 100644 arch/arm64/kvm/emulate-nested.c
>  create mode 100644 arch/arm64/kvm/hyp/at.c
>  create mode 100644 arch/arm64/kvm/nested.c
>  create mode 100644 virt/kvm/arm/vgic/vgic-nested-trace.h
>  create mode 100644 virt/kvm/arm/vgic/vgic-v3-nested.c
>
> --
> 2.20.1
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>

--000000000000e5b269058bd27d3b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div><div dir=3D"auto">Marc,</div></div><div dir=3D"auto">Only possible way=
 to test this series is to get</div><div dir=3D"auto">on Fast Model?</div><=
div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On=
 Fri, Jun 21, 2019 at 18:55 Marc Zyngier &lt;<a href=3D"mailto:marc.zyngier=
@arm.com">marc.zyngier@arm.com</a>&gt; wrote:<br></div><blockquote class=3D=
"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding=
-left:1ex">I&#39;ve taken over the maintenance of this series originally wr=
itten by<br>
Jintack and Christoffer. Since then, the series has been substantially<br>
reworked, new features (and most probably bugs) have been added, and<br>
the whole thing rebased multiple times. If anything breaks, please<br>
blame me, and nobody else.<br>
<br>
As you can tell, this is quite big. It is also remarkably incomplete<br>
(we&#39;re missing many critical bits for fully emulate EL2), but the idea<=
br>
is to start merging things early in order to reduce the maintenance<br>
headache. What we want to achieve is that with NV disabled, there is<br>
no performance overhead and no regression. The only thing I intend to<br>
merge ASAP is the first patch in the series, because it should have<br>
zero effect and is a reasonable cleanup.<br>
<br>
The series is roughly divided in 4 parts: exception handling, memory<br>
virtualization, interrupts and timers. There are of course some<br>
dependencies, but you&#39;ll hopefully get the gist of it.<br>
<br>
For the most courageous of you, I&#39;ve put out a branch[1] containing thi=
s<br>
and a bit more. Of course, you&#39;ll need some userspace. Andre maintains<=
br>
a hacked version of kvmtool[1] that takes a --nested option, allowing<br>
the guest to be started at EL2. You can run the whole stack in the<br>
Foundation model. Don&#39;t be in a hurry ;-).<br>
<br>
[1] git://<a href=3D"http://git.kernel.org/pub/scm/linux/kernel/git/maz/arm=
-platforms.git" rel=3D"noreferrer" target=3D"_blank">git.kernel.org/pub/scm=
/linux/kernel/git/maz/arm-platforms.git</a> kvm-arm64/nv-wip-5.2-rc5<br>
[2] git://<a href=3D"http://linux-arm.org/kvmtool.git" rel=3D"noreferrer" t=
arget=3D"_blank">linux-arm.org/kvmtool.git</a> nv/nv-wip-5.2-rc5<br>
<br>
Andre Przywara (4):<br>
=C2=A0 KVM: arm64: nv: Handle virtual EL2 registers in<br>
=C2=A0 =C2=A0 vcpu_read/write_sys_reg()<br>
=C2=A0 KVM: arm64: nv: Save/Restore vEL2 sysregs<br>
=C2=A0 KVM: arm64: nv: Handle traps for timer _EL02 and _EL2 sysregs<br>
=C2=A0 =C2=A0 accessors<br>
=C2=A0 KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ<br>
<br>
Christoffer Dall (16):<br>
=C2=A0 KVM: arm64: nv: Introduce nested virtualization VCPU feature<br>
=C2=A0 KVM: arm64: nv: Reset VCPU to EL2 registers if VCPU nested virt is s=
et<br>
=C2=A0 KVM: arm64: nv: Allow userspace to set PSR_MODE_EL2x<br>
=C2=A0 KVM: arm64: nv: Add nested virt VCPU primitives for vEL2 VCPU state<=
br>
=C2=A0 KVM: arm64: nv: Handle trapped ERET from virtual EL2<br>
=C2=A0 KVM: arm64: nv: Emulate PSTATE.M for a guest hypervisor<br>
=C2=A0 KVM: arm64: nv: Trap EL1 VM register accesses in virtual EL2<br>
=C2=A0 KVM: arm64: nv: Only toggle cache for virtual EL2 when SCTLR_EL2<br>
=C2=A0 =C2=A0 changes<br>
=C2=A0 KVM: arm/arm64: nv: Support multiple nested stage 2 mmu structures<b=
r>
=C2=A0 KVM: arm64: nv: Implement nested Stage-2 page table walk logic<br>
=C2=A0 KVM: arm64: nv: Handle shadow stage 2 page faults<br>
=C2=A0 KVM: arm64: nv: Unmap/flush shadow stage 2 page tables<br>
=C2=A0 KVM: arm64: nv: arch_timer: Support hyp timer emulation<br>
=C2=A0 KVM: arm64: nv: vgic-v3: Take cpu_if pointer directly instead of vcp=
u<br>
=C2=A0 KVM: arm64: nv: vgic: Emulate the HW bit in software<br>
=C2=A0 KVM: arm64: nv: Add nested GICv3 tracepoints<br>
<br>
Dave Martin (1):<br>
=C2=A0 KVM: arm64: Migrate _elx sysreg accessors to msr_s/mrs_s<br>
<br>
Jintack Lim (21):<br>
=C2=A0 arm64: Add ARM64_HAS_NESTED_VIRT cpufeature<br>
=C2=A0 KVM: arm64: nv: Add EL2 system registers to vcpu context<br>
=C2=A0 KVM: arm64: nv: Support virtual EL2 exceptions<br>
=C2=A0 KVM: arm64: nv: Inject HVC exceptions to the virtual EL2<br>
=C2=A0 KVM: arm64: nv: Trap SPSR_EL1, ELR_EL1 and VBAR_EL1 from virtual EL2=
<br>
=C2=A0 KVM: arm64: nv: Trap CPACR_EL1 access in virtual EL2<br>
=C2=A0 KVM: arm64: nv: Set a handler for the system instruction traps<br>
=C2=A0 KVM: arm64: nv: Handle PSCI call via smc from the guest<br>
=C2=A0 KVM: arm64: nv: Respect virtual HCR_EL2.TWX setting<br>
=C2=A0 KVM: arm64: nv: Respect virtual CPTR_EL2.TFP setting<br>
=C2=A0 KVM: arm64: nv: Respect the virtual HCR_EL2.NV bit setting<br>
=C2=A0 KVM: arm64: nv: Respect virtual HCR_EL2.TVM and TRVM settings<br>
=C2=A0 KVM: arm64: nv: Respect the virtual HCR_EL2.NV1 bit setting<br>
=C2=A0 KVM: arm64: nv: Emulate EL12 register accesses from the virtual EL2<=
br>
=C2=A0 KVM: arm64: nv: Configure HCR_EL2 for nested virtualization<br>
=C2=A0 KVM: arm64: nv: Pretend we only support larger-than-host page sizes<=
br>
=C2=A0 KVM: arm64: nv: Introduce sys_reg_desc.forward_trap<br>
=C2=A0 KVM: arm64: nv: Rework the system instruction emulation framework<br=
>
=C2=A0 KVM: arm64: nv: Trap and emulate AT instructions from virtual EL2<br=
>
=C2=A0 KVM: arm64: nv: Trap and emulate TLBI instructions from virtual EL2<=
br>
=C2=A0 KVM: arm64: nv: Nested GICv3 Support<br>
<br>
Marc Zyngier (17):<br>
=C2=A0 KVM: arm64: Move __load_guest_stage2 to kvm_mmu.h<br>
=C2=A0 KVM: arm64: nv: Reset VMPIDR_EL2 and VPIDR_EL2 to sane values<br>
=C2=A0 KVM: arm64: nv: Handle SPSR_EL2 specially<br>
=C2=A0 KVM: arm64: nv: Refactor vcpu_{read,write}_sys_reg<br>
=C2=A0 KVM: arm64: nv: Don&#39;t expose SVE to nested guests<br>
=C2=A0 KVM: arm64: nv: Hide RAS from nested guests<br>
=C2=A0 KVM: arm/arm64: nv: Factor out stage 2 page table data from struct k=
vm<br>
=C2=A0 KVM: arm64: nv: Move last_vcpu_ran to be per s2 mmu<br>
=C2=A0 KVM: arm64: nv: Don&#39;t always start an S2 MMU search from the beg=
inning<br>
=C2=A0 KVM: arm64: nv: Propagate CNTVOFF_EL2 to the virtual EL1 timer<br>
=C2=A0 KVM: arm64: nv: Load timer before the GIC<br>
=C2=A0 KVM: arm64: nv: Implement maintenance interrupt forwarding<br>
=C2=A0 arm64: KVM: nv: Add handling of EL2-specific timer registers<br>
=C2=A0 arm64: KVM: nv: Honor SCTLR_EL2.SPAN on entering vEL2<br>
=C2=A0 arm64: KVM: nv: Handle SCTLR_EL2 RES0/RES1 bits<br>
=C2=A0 arm64: KVM: nv: Restrict S2 RD/WR permissions to match the guest&#39=
;s<br>
=C2=A0 arm64: KVM: nv: Allow userspace to request KVM_ARM_VCPU_NESTED_VIRT<=
br>
<br>
=C2=A0.../admin-guide/kernel-parameters.txt=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0|=C2=A0 =C2=A0 4 +<br>
=C2=A0.../virtual/kvm/devices/arm-vgic-v3.txt=C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 =C2=A0 9 +<br>
=C2=A0arch/arm/include/asm/kvm_asm.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A0 5 +-<br>
=C2=A0arch/arm/include/asm/kvm_emulate.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 |=C2=A0 =C2=A0 3 +<br>
=C2=A0arch/arm/include/asm/kvm_host.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A031 +-<br>
=C2=A0arch/arm/include/asm/kvm_hyp.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A025 +-<br>
=C2=A0arch/arm/include/asm/kvm_mmu.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A083 +-<br>
=C2=A0arch/arm/include/asm/kvm_nested.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|=C2=A0 =C2=A0 9 +<br>
=C2=A0arch/arm/include/uapi/asm/kvm.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A0 1 +<br>
=C2=A0arch/arm/kvm/hyp/switch.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A011 +-<br>
=C2=A0arch/arm/kvm/hyp/tlb.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A013 +-<br>
=C2=A0arch/arm64/include/asm/cpucaps.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 =C2=A0 3 +-<br>
=C2=A0arch/arm64/include/asm/esr.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A0 4 +-<br>
=C2=A0arch/arm64/include/asm/kvm_arm.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 =C2=A028 +-<br>
=C2=A0arch/arm64/include/asm/kvm_asm.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 =C2=A0 9 +-<br>
=C2=A0arch/arm64/include/asm/kvm_coproc.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0|=C2=A0 =C2=A0 2 +-<br>
=C2=A0arch/arm64/include/asm/kvm_emulate.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 |=C2=A0 157 +-<br>
=C2=A0arch/arm64/include/asm/kvm_host.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|=C2=A0 105 +-<br>
=C2=A0arch/arm64/include/asm/kvm_hyp.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 =C2=A082 +-<br>
=C2=A0arch/arm64/include/asm/kvm_mmu.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 =C2=A062 +-<br>
=C2=A0arch/arm64/include/asm/kvm_nested.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0|=C2=A0 =C2=A068 +<br>
=C2=A0arch/arm64/include/asm/sysreg.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0|=C2=A0 143 +-<br>
=C2=A0arch/arm64/include/uapi/asm/kvm.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|=C2=A0 =C2=A0 2 +<br>
=C2=A0arch/arm64/kernel/cpufeature.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A026 +<br>
=C2=A0arch/arm64/kvm/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A0 4 +<br>
=C2=A0arch/arm64/kvm/emulate-nested.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0|=C2=A0 223 +++<br>
=C2=A0arch/arm64/kvm/guest.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A0 6 +<br>
=C2=A0arch/arm64/kvm/handle_exit.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A076 +-<br>
=C2=A0arch/arm64/kvm/hyp/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A0 1 +<br>
=C2=A0arch/arm64/kvm/hyp/at.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 217 +++<br>
=C2=A0arch/arm64/kvm/hyp/switch.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A086 +-<br>
=C2=A0arch/arm64/kvm/hyp/sysreg-sr.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 |=C2=A0 267 ++-<br>
=C2=A0arch/arm64/kvm/hyp/tlb.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 129 +-<br>
=C2=A0arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =
=C2=A0 2 +-<br>
=C2=A0arch/arm64/kvm/inject_fault.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A012 -<br>
=C2=A0arch/arm64/kvm/nested.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 551 +++++++<br>
=C2=A0arch/arm64/kvm/regmap.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A0 4 +-<br>
=C2=A0arch/arm64/kvm/reset.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A0 7 +<br>
=C2=A0arch/arm64/kvm/sys_regs.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 1460 +++++++++++++++--<br>
=C2=A0arch/arm64/kvm/sys_regs.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A0 6 +<br>
=C2=A0arch/arm64/kvm/trace.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A058 +-<br>
=C2=A0include/kvm/arm_arch_timer.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A0 6 +<br>
=C2=A0include/kvm/arm_vgic.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A028 +-<br>
=C2=A0virt/kvm/arm/arch_timer.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 158 +-<br>
=C2=A0virt/kvm/arm/arm.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A062 +-<br>
=C2=A0virt/kvm/arm/hyp/vgic-v3-sr.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A035 +-<br>
=C2=A0virt/kvm/arm/mmio.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A012 +-<br>
=C2=A0virt/kvm/arm/mmu.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 445 +++--<br>
=C2=A0virt/kvm/arm/trace.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A0 6 +-<br>
=C2=A0virt/kvm/arm/vgic/vgic-init.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A030 +<br>
=C2=A0virt/kvm/arm/vgic/vgic-kvm-device.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0|=C2=A0 =C2=A022 +<br>
=C2=A0virt/kvm/arm/vgic/vgic-nested-trace.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0|=C2=A0 137 ++<br>
=C2=A0virt/kvm/arm/vgic/vgic-v2.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A010 +-<br>
=C2=A0virt/kvm/arm/vgic/vgic-v3-nested.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 |=C2=A0 236 +++<br>
=C2=A0virt/kvm/arm/vgic/vgic-v3.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A040 +-<br>
=C2=A0virt/kvm/arm/vgic/vgic.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A074 +-<br>
=C2=A056 files changed, 4683 insertions(+), 612 deletions(-)<br>
=C2=A0create mode 100644 arch/arm/include/asm/kvm_nested.h<br>
=C2=A0create mode 100644 arch/arm64/include/asm/kvm_nested.h<br>
=C2=A0create mode 100644 arch/arm64/kvm/emulate-nested.c<br>
=C2=A0create mode 100644 arch/arm64/kvm/hyp/at.c<br>
=C2=A0create mode 100644 arch/arm64/kvm/nested.c<br>
=C2=A0create mode 100644 virt/kvm/arm/vgic/vgic-nested-trace.h<br>
=C2=A0create mode 100644 virt/kvm/arm/vgic/vgic-v3-nested.c<br>
<br>
-- <br>
2.20.1<br>
<br>
<br>
_______________________________________________<br>
linux-arm-kernel mailing list<br>
<a href=3D"mailto:linux-arm-kernel@lists.infradead.org" target=3D"_blank">l=
inux-arm-kernel@lists.infradead.org</a><br>
<a href=3D"http://lists.infradead.org/mailman/listinfo/linux-arm-kernel" re=
l=3D"noreferrer" target=3D"_blank">http://lists.infradead.org/mailman/listi=
nfo/linux-arm-kernel</a><br>
</blockquote></div></div>

--000000000000e5b269058bd27d3b--

--===============4083313157863634577==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4083313157863634577==--
