Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BE72C15BB
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 17:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764697028; cv=none; b=rAwc8iFKzlXni9as+viIiCE1Qm3W75Ya0MXnzbPhDYD467+BuGOmgFg1nNqwSHardOs84wBU7wfMl/5QQ8qbNgIZtIZonCJd5aojQiRCV0DvqmhRCEgQivwU1TnE2goCw9bbj2uSnf8tObB/3Lp56yNtFs9jYD0FzV0Auo8BvNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764697028; c=relaxed/simple;
	bh=HMfbrwnlAUxz5naOIvMQumLZnN8BDKpvHbXQAMr9kxc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FlhmIFcG1LYMzSoC98D330D3jahYxeA2Gd7BmWxvU8xWUVvUkniEbK+j8V83yTwNP1CIlEwgGL9aAhOeSkLYBVnikFoXp3q1WCZmKPO9LegiDykerT8Brd/Lp7XHlCJFmtMPhZLiYAHwcIExpFmKg0pAuSC62J59razZwS+5MCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Br48EaSs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Br48EaSs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764697025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EiGdWpzAPFgFO0sO+D6/RDMrT+wOeBy17Oji/oGhy/E=;
	b=Br48EaSs6PwaI6QMV0yuFmLROysNBtfoNRV6DZwRiAD2YjXViRp4mfW8kFWRJrIN6MaKjx
	9mHx6hPoi19mLxj9vSLoZreU6q/Trwya75JpfBEuH/hk0oRUF92U7LJ7exb6U9yjZ041pV
	jQR/R9KsT9ulP5tQp+vInqUn4sy46Yg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-T0vlK_vUOT6vXIlDx1KjCA-1; Tue, 02 Dec 2025 12:37:04 -0500
X-MC-Unique: T0vlK_vUOT6vXIlDx1KjCA-1
X-Mimecast-MFC-AGG-ID: T0vlK_vUOT6vXIlDx1KjCA_1764697023
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42b487cda00so3317863f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 09:37:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764697023; x=1765301823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EiGdWpzAPFgFO0sO+D6/RDMrT+wOeBy17Oji/oGhy/E=;
        b=Y9XW5OaChLCna99IzXjPvUmx9HWXFtc9TtJ1L+3gxmUQt6QyfnMhK5/PXjMwq802Rc
         K5OGlQe/7IxhyA3c38u9mpgDXY/Tu0CyX8olvszchzolxhy2r5DM96sirDMgeSnsnSj1
         CWkBUG9hmkXmAik+6/BWkYZ4bzEeuMj2WSh5q5DhJIlo8b0D0EXmbYWVpso3BBtjQ6tf
         UcF1wzTzqMEVXPFM1ExKVxVzS3OWafVNKYq9BAIDwXMe1Yn/yaaSezTVzMCMa6T+ZjRe
         bkXewoKAsuE9/OQaLDxxMXKSEwfdjJUnE6u4mrAdQoWHSG8KoIRCZ/RTURB0dScfXjWE
         Yd4A==
X-Forwarded-Encrypted: i=1; AJvYcCWd1BGSQNmawU0ANOtBOooW8g/LfuKRJaSEOkZ5DRgMmVYhgzTmcHFGheGM0b5AnDk7UpHIS+E=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1eanIQoIq+it4ItIfzvPo/BPGgWuVrmSs/VMTyNyIyZkTPSc/
	hZNEWnyQr+w95NQoRn3NPLFqvJpPbTqp4SoER6xSz3GxuF/gHcuh4K3VIhe9YMqEOpRsW1sfxCf
	M5WhFcXABKywh0iYFZ74Q/uQfaBUhH2gbaa4+DkVWdeLyFYdiNLy+xCZp+Z4bKJLd/iEwuQKPh5
	ghMQvl7mRrOMTvoZeLUvaVVOUsoBtiwE8r
X-Gm-Gg: ASbGncsXLF8Di5bb0tidQicPM/RkDJTIcBjjpkoKVvON0y/JyVh/cr1cBJ6hGDfMJD9
	4q07o8RDG8fi1WIJxg4lz+CwNeZAxWuUZ391RlVvwZSc0aRoMD/DGXJ9Wu8cTrTYz82zRmhlEJv
	pgr/tZjkQ1ce4bWDzNqEmNbGq4xLNfj/tQZjbQDDYh8jodTB/EmPhqjQ7QCuDcf5MORFtcvPFGQ
	ZAm7s9GvVqINrs5bs6TVshhyQ8vJ/6L/ICoONnHJ55MXtAf7pSN952+iQK72EkbCo9iaHg=
X-Received: by 2002:a5d:588b:0:b0:42b:411b:e487 with SMTP id ffacd0b85a97d-42cc1cd920amr47088266f8f.2.1764697023168;
        Tue, 02 Dec 2025 09:37:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGIOXtAWvJ9VdxElkBPlQ+pEylDNwMtkv1NPj2pZpVDZadGX0qi7zft3MsXIgcfNxUFXD0WtJU0HKvNGhiN+CI=
X-Received: by 2002:a5d:588b:0:b0:42b:411b:e487 with SMTP id
 ffacd0b85a97d-42cc1cd920amr47088248f8f.2.1764697022735; Tue, 02 Dec 2025
 09:37:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <aS32T_UxeEfbeJx6@kernel.org>
In-Reply-To: <aS32T_UxeEfbeJx6@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 2 Dec 2025 18:36:49 +0100
X-Gm-Features: AWmQ_bluFZN0y7S7zCltnFLYD0jn-Gs2vxJHdyOeH_IyjYIGl7FDQHJyh5ynjm0
Message-ID: <CABgObfap4CL3_X4eW=zEzzMwvXDVcjYJYeHitruvxDQ0-sG=ow@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.19
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zixzLUtI2iHb34tQQnehtyxuqYorMF2FSc5fkXU9mck_1764697023
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 1, 2025 at 9:11=E2=80=AFPM Oliver Upton <oupton@kernel.org> wro=
te:
>
> Hi Paolo,
>
> Now that I'm back from the holiday, here's the bulk of the 6.19 content. =
The
> MMU changes look a little newer than they actually are (have been sitting=
 in -next
> for more than a week) because I squashed a fixup to avoid introducing bis=
ection
> issues.
>
> As always, details can be found in the tag. There's an extremely minor co=
nflict with
> fixes that Marc queued in 6.18, my resolution is included at the end. Sor=
ry about the
> wrinkle, will try to avoid next time.

No big deal at all, don't worry.

Pulled, thanks.

Paolo

> Please pull.
>
> Thanks,
> Oliver
>
> The following changes since commit dcb6fa37fd7bc9c3d2b066329b0d27dedf8bec=
aa:
>
>   Linux 6.18-rc3 (2025-10-26 15:59:49 -0700)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags=
/kvmarm-6.19
>
> for you to fetch changes up to 3eef0c83c3f3e58933e98e678ddf4e95457d4d14:
>
>   Merge branch 'kvm-arm64/nv-xnx-haf' into kvmarm/next (2025-12-01 00:47:=
41 -0800)
>
> ----------------------------------------------------------------
> KVM/arm64 updates for 6.19
>
>  - Support for userspace handling of synchronous external aborts (SEAs),
>    allowing the VMM to potentially handle the abort in a non-fatal
>    manner.
>
>  - Large rework of the VGIC's list register handling with the goal of
>    supporting more active/pending IRQs than available list registers in
>    hardware. In addition, the VGIC now supports EOImode=3D=3D1 style
>    deactivations for IRQs which may occur on a separate vCPU than the
>    one that acked the IRQ.
>
>  - Support for FEAT_XNX (user / privileged execute permissions) and
>    FEAT_HAF (hardware update to the Access Flag) in the software page
>    table walkers and shadow MMU.
>
>  - Allow page table destruction to reschedule, fixing long need_resched
>    latencies observed when destroying a large VM.
>
>  - Minor fixes to KVM and selftests
>
> ----------------------------------------------------------------
> Alexandru Elisei (3):
>       KVM: arm64: Document KVM_PGTABLE_PROT_{UX,PX}
>       KVM: arm64: at: Use correct HA bit in TCR_EL2 when regime is EL2
>       KVM: arm64: at: Update AF on software walk only if VM has FEAT_HAFD=
BS
>
> Colin Ian King (1):
>       KVM: arm64: Fix spelling mistake "Unexpeced" -> "Unexpected"
>
> Jiaqi Yan (3):
>       KVM: arm64: VM exit to userspace to handle SEA
>       KVM: selftests: Test for KVM_EXIT_ARM_SEA
>       Documentation: kvm: new UAPI for handling SEA
>
> Marc Zyngier (51):
>       irqchip/gic: Add missing GICH_HCR control bits
>       irqchip/gic: Expose CPU interface VA to KVM
>       irqchip/apple-aic: Spit out ICH_MISR_EL2 value on spurious vGIC MI
>       KVM: arm64: Turn vgic-v3 errata traps into a patched-in constant
>       KVM: arm64: vgic-v3: Fix GICv3 trapping in protected mode
>       KVM: arm64: GICv3: Detect and work around the lack of ICV_DIR_EL1 t=
rapping
>       KVM: arm64: Repack struct vgic_irq fields
>       KVM: arm64: Add tracking of vgic_irq being present in a LR
>       KVM: arm64: Add LR overflow handling documentation
>       KVM: arm64: GICv3: Drop LPI active state when folding LRs
>       KVM: arm64: GICv3: Preserve EOIcount on exit
>       KVM: arm64: GICv3: Decouple ICH_HCR_EL2 programming from LRs
>       KVM: arm64: GICv3: Extract LR folding primitive
>       KVM: arm64: GICv3: Extract LR computing primitive
>       KVM: arm64: GICv2: Preserve EOIcount on exit
>       KVM: arm64: GICv2: Decouple GICH_HCR programming from LRs being loa=
ded
>       KVM: arm64: GICv2: Extract LR folding primitive
>       KVM: arm64: GICv2: Extract LR computing primitive
>       KVM: arm64: Compute vgic state irrespective of the number of interr=
upts
>       KVM: arm64: Eagerly save VMCR on exit
>       KVM: arm64: Revamp vgic maintenance interrupt configuration
>       KVM: arm64: Turn kvm_vgic_vcpu_enable() into kvm_vgic_vcpu_reset()
>       KVM: arm64: Make vgic_target_oracle() globally available
>       KVM: arm64: Invert ap_list sorting to push active interrupts out
>       KVM: arm64: Move undeliverable interrupts to the end of ap_list
>       KVM: arm64: Use MI to detect groups being enabled/disabled
>       KVM: arm64: GICv3: Handle LR overflow when EOImode=3D=3D0
>       KVM: arm64: GICv3: Handle deactivation via ICV_DIR_EL1 traps
>       KVM: arm64: GICv3: Add GICv2 SGI handling to deactivation primitive
>       KVM: arm64: GICv3: Set ICH_HCR_EL2.TDIR when interrupts overflow LR=
 capacity
>       KVM: arm64: GICv3: Add SPI tracking to handle asymmetric deactivati=
on
>       KVM: arm64: GICv3: Handle in-LR deactivation when possible
>       KVM: arm64: GICv3: Avoid broadcast kick on CPUs lacking TDIR
>       KVM: arm64: GICv3: nv: Resync LRs/VMCR/HCR early for better MI emul=
ation
>       KVM: arm64: GICv3: nv: Plug L1 LR sync into deactivation primitive
>       KVM: arm64: GICv3: Force exit to sync ICH_HCR_EL2.En
>       KVM: arm64: GICv2: Handle LR overflow when EOImode=3D=3D0
>       KVM: arm64: GICv2: Handle deactivation via GICV_DIR traps
>       KVM: arm64: GICv2: Always trap GICV_DIR register
>       KVM: arm64: selftests: gic_v3: Add irq group setting helper
>       KVM: arm64: selftests: gic_v3: Disable Group-0 interrupts by defaul=
t
>       KVM: arm64: selftests: vgic_irq: Fix GUEST_ASSERT_IAR_EMPTY() helpe=
r
>       KVM: arm64: selftests: vgic_irq: Change configuration before enabli=
ng interrupt
>       KVM: arm64: selftests: vgic_irq: Exclude timer-controlled interrupt=
s
>       KVM: arm64: selftests: vgic_irq: Remove LR-bound limitation
>       KVM: arm64: selftests: vgic_irq: Perform EOImode=3D=3D1 deactivatio=
n in ack order
>       KVM: arm64: selftests: vgic_irq: Add asymmetric SPI deaectivation t=
est
>       KVM: arm64: selftests: vgic_irq: Add Group-0 enable test
>       KVM: arm64: selftests: vgic_irq: Add timer deactivation test
>       KVM: arm64: Convert ICH_HCR_EL2_TDIR cap to EARLY_LOCAL_CPU_FEATURE
>       KVM: arm64: Add endian casting to kvm_swap_s[12]_desc()
>
> Maximilian Dittgen (2):
>       KVM: selftests: Assert GICR_TYPER.Processor_Number matches selftest=
 CPU number
>       KVM: selftests: SYNC after guest ITS setup in vgic_lpi_stress
>
> Nathan Chancellor (1):
>       KVM: arm64: Add break to default case in kvm_pgtable_stage2_pte_pro=
t()
>
> Oliver Upton (23):
>       KVM: arm64: Drop useless __GFP_HIGHMEM from kvm struct allocation
>       KVM: arm64: Use kvzalloc() for kvm struct allocation
>       KVM: arm64: Only drop references on empty tables in stage2_free_wal=
ker
>       arm64: Detect FEAT_XNX
>       KVM: arm64: Add support for FEAT_XNX stage-2 permissions
>       KVM: arm64: nv: Forward FEAT_XNX permissions to the shadow stage-2
>       KVM: arm64: Teach ptdump about FEAT_XNX permissions
>       KVM: arm64: nv: Advertise support for FEAT_XNX
>       KVM: arm64: Call helper for reading descriptors directly
>       KVM: arm64: nv: Stop passing vCPU through void ptr in S2 PTW
>       KVM: arm64: Handle endianness in read helper for emulated PTW
>       KVM: arm64: nv: Use pgtable definitions in stage-2 walk
>       KVM: arm64: Add helper for swapping guest descriptor
>       KVM: arm64: Propagate PTW errors up to AT emulation
>       KVM: arm64: Implement HW access flag management in stage-1 SW PTW
>       KVM: arm64: nv: Implement HW access flag management in stage-2 SW P=
TW
>       KVM: arm64: nv: Expose hardware access flag management to NV guests
>       KVM: arm64: selftests: Add test for AT emulation
>       KVM: arm64: Fix compilation when CONFIG_ARM64_USE_LSE_ATOMICS=3Dn
>       Merge branch 'kvm-arm64/misc' into kvmarm/next
>       Merge branch 'kvm-arm64/sea-user' into kvmarm/next
>       Merge branch 'kvm-arm64/vgic-lr-overflow' into kvmarm/next
>       Merge branch 'kvm-arm64/nv-xnx-haf' into kvmarm/next
>
> Raghavendra Rao Ananta (2):
>       KVM: arm64: Split kvm_pgtable_stage2_destroy()
>       KVM: arm64: Reschedule as needed when destroying the stage-2 page-t=
ables
>
>  Documentation/virt/kvm/api.rst                     |  47 +++
>  arch/arm64/include/asm/kvm_arm.h                   |   1 +
>  arch/arm64/include/asm/kvm_asm.h                   |   8 +-
>  arch/arm64/include/asm/kvm_host.h                  |   3 +
>  arch/arm64/include/asm/kvm_hyp.h                   |   3 +-
>  arch/arm64/include/asm/kvm_nested.h                |  40 +-
>  arch/arm64/include/asm/kvm_pgtable.h               |  49 ++-
>  arch/arm64/include/asm/kvm_pkvm.h                  |   4 +-
>  arch/arm64/include/asm/virt.h                      |   7 +-
>  arch/arm64/kernel/cpufeature.c                     |  59 +++
>  arch/arm64/kernel/hyp-stub.S                       |   5 +
>  arch/arm64/kernel/image-vars.h                     |   1 +
>  arch/arm64/kvm/arm.c                               |  14 +-
>  arch/arm64/kvm/at.c                                | 196 +++++++++-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   7 +-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                     |   3 +
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |   5 +
>  arch/arm64/kvm/hyp/pgtable.c                       | 122 +++++-
>  arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c           |   4 +
>  arch/arm64/kvm/hyp/vgic-v3-sr.c                    |  96 +++--
>  arch/arm64/kvm/mmu.c                               | 132 ++++++-
>  arch/arm64/kvm/nested.c                            | 123 ++++--
>  arch/arm64/kvm/pkvm.c                              |  11 +-
>  arch/arm64/kvm/ptdump.c                            |  35 +-
>  arch/arm64/kvm/sys_regs.c                          |  28 +-
>  arch/arm64/kvm/vgic/vgic-init.c                    |   9 +-
>  arch/arm64/kvm/vgic/vgic-mmio-v2.c                 |  24 ++
>  arch/arm64/kvm/vgic/vgic-mmio.h                    |   1 +
>  arch/arm64/kvm/vgic/vgic-v2.c                      | 291 ++++++++++----
>  arch/arm64/kvm/vgic/vgic-v3-nested.c               | 104 ++---
>  arch/arm64/kvm/vgic/vgic-v3.c                      | 426 +++++++++++++++=
+-----
>  arch/arm64/kvm/vgic/vgic-v4.c                      |   5 +-
>  arch/arm64/kvm/vgic/vgic.c                         | 298 ++++++++------
>  arch/arm64/kvm/vgic/vgic.h                         |  43 ++-
>  arch/arm64/tools/cpucaps                           |   2 +
>  drivers/irqchip/irq-apple-aic.c                    |   7 +-
>  drivers/irqchip/irq-gic.c                          |   3 +
>  include/kvm/arm_vgic.h                             |  29 +-
>  include/linux/irqchip/arm-gic.h                    |   6 +
>  include/linux/irqchip/arm-vgic-info.h              |   2 +
>  include/uapi/linux/kvm.h                           |  10 +
>  tools/arch/arm64/include/asm/esr.h                 |   2 +
>  tools/testing/selftests/kvm/Makefile.kvm           |   2 +
>  tools/testing/selftests/kvm/arm64/at.c             | 166 ++++++++
>  tools/testing/selftests/kvm/arm64/sea_to_user.c    | 331 +++++++++++++++=
+
>  tools/testing/selftests/kvm/arm64/vgic_irq.c       | 285 ++++++++++++--
>  .../testing/selftests/kvm/arm64/vgic_lpi_stress.c  |   4 +
>  tools/testing/selftests/kvm/include/arm64/gic.h    |   1 +
>  .../selftests/kvm/include/arm64/gic_v3_its.h       |   1 +
>  tools/testing/selftests/kvm/include/kvm_util.h     |   1 +
>  tools/testing/selftests/kvm/lib/arm64/gic.c        |   6 +
>  .../testing/selftests/kvm/lib/arm64/gic_private.h  |   1 +
>  tools/testing/selftests/kvm/lib/arm64/gic_v3.c     |  22 ++
>  tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c |  10 +
>  tools/testing/selftests/kvm/lib/kvm_util.c         |  11 +
>  55 files changed, 2575 insertions(+), 531 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/arm64/at.c
>  create mode 100644 tools/testing/selftests/kvm/arm64/sea_to_user.ca
>
> --
> diff --cc arch/arm64/kvm/vgic/vgic-v3.c
> index 968aa9d89be6,2f75ef14d339..1d6dd1b545bd
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@@ -507,9 -301,21 +507,10 @@@ void vcpu_set_ich_hcr(struct kvm_vcpu *
>                 return;
>
>         /* Hide GICv3 sysreg if necessary */
> -       if (vcpu->kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_=
V2)
> +       if (vcpu->kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_=
V2 ||
>  -          !irqchip_in_kernel(vcpu->kvm)) {
> ++          !irqchip_in_kernel(vcpu->kvm))
>                 vgic_v3->vgic_hcr |=3D (ICH_HCR_EL2_TALL0 | ICH_HCR_EL2_T=
ALL1 |
>                                       ICH_HCR_EL2_TC);
>  -              return;
>  -      }
>  -
>  -      if (group0_trap)
>  -              vgic_v3->vgic_hcr |=3D ICH_HCR_EL2_TALL0;
>  -      if (group1_trap)
>  -              vgic_v3->vgic_hcr |=3D ICH_HCR_EL2_TALL1;
>  -      if (common_trap)
>  -              vgic_v3->vgic_hcr |=3D ICH_HCR_EL2_TC;
>  -      if (dir_trap)
>  -              vgic_v3->vgic_hcr |=3D ICH_HCR_EL2_TDIR;
>   }
>
>   int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *i=
rq)
>

