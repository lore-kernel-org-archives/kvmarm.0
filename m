Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312A219AD93
	for <kvmarm@lists.linux.dev>; Tue, 16 Jul 2024 13:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721137883; cv=none; b=LAbELRMdmQ5vu00g2y6W8d3bcv2QO2uDJVB+XYxjG9iNL6jVhBzDpuNIjbrXNwzJkDyMOHRYP1Q/4G7pfWXXm7j4iqGC+pJXMADV+XQW/MwljrDJhNVcB163wmz++QKSCFdYd6uUqKTnbjx/G1qpHcKyu5Q0VeFVSg1Y4VKSmrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721137883; c=relaxed/simple;
	bh=6YIpoHpCO/c0TX0CzEhE7vyNjwowoCD8tiIzAS2HJ9Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bvz8jyjAn09/lS4qCi4Stozw3hSG5oevvWb8+qWWwMfL6+DlrJ6eFInYXRyropksMmdBcInAvo+EKjIhAs923YO+RLxgEy1gQhXHwP6DlW8rmgX+bYjuaEa0ZGMbS7ahMrkYBL3wxC/1PqHDIL6kk5TjP34j6WZAZdmA8jjJPoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WlqE8lKm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WlqE8lKm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721137880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eajIdwDOBvD6JI+kztTRBgAUPohirWWSrOTsDLywyyg=;
	b=WlqE8lKmKopbQmCjmjqiWtaNh2aGva/8KfSVhraPDIM/JWDu/F/p/zmk6L5Ilp+OldSr6K
	6KyU5/JI2l8pLO8Bgfr6IX9Ht0/68WEZDOGUxaOihc+lfD4C7/RphfjsOFpQ2wCcRQb/6l
	U+oL2uiusUH13ZZMNaAS0PUApTy+ZF0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-MHtmDtd5OGqVOPYah-FNdg-1; Tue, 16 Jul 2024 09:51:18 -0400
X-MC-Unique: MHtmDtd5OGqVOPYah-FNdg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-367879e8395so3408150f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Jul 2024 06:51:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721137877; x=1721742677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eajIdwDOBvD6JI+kztTRBgAUPohirWWSrOTsDLywyyg=;
        b=WN5r3z0twbCzlrvEL9/Rm00yNZ+tCtaxwbB+bBQP/t37H8+NY0zRDf7ibG8hHo0usT
         ncLgHBZWXuwgmC9P4u9sAPTLJRCBGqS7/YLYuurOzpK8rBOeuQ1KF1j/C+Q/bcj5x4+L
         pYPsWj7AKGC6gXCpWijuiyVzaZ/DYw/iPV8AK7k55/KRkyljGDK+I1vYs0b0XasqX3Pr
         7tL/cTRv1Z48TB8tmP72/cjTu8/YUceZDq0m9TNt4a1h+FNy/AuA3uYtNtRS7wEX39Qv
         vHlgNQzYeasJr5ioVZeAP7LVI6YT9t04sXrwIbPSqUa8eFqq9nm+vDUvosDSCCTdkTAj
         37NQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCmaEffJZ6IqQoh5TeUcKj3hOMAs8os48L8d9xDJtZLdLwB95vq0RVt/TXsVL7IkbSVqgbc0pPLbjhcdG87HgJBvPFFY3/
X-Gm-Message-State: AOJu0Yxh2AZypY1y3ouMKTLKfrbuHgtYsar2xIAEr5ghT1TN2J6IcdIX
	dSz4AsaDZiT3xJ69U4czfExKCb14TFN2AkVc8Dp3u3heFgUo2v94lCbSGWC30N599blecbmiEPc
	6jOYE3VoAuG9lofCKqDrwOEY1M6SYJOCRPEQKH9AY5NZgYOreg2kP66xP/iDrcNTcDC3BTAc2TA
	n/Co1+od2SF0OwZ30EWj5kJwRSd7+q
X-Received: by 2002:a05:6000:1fa8:b0:367:434f:caa2 with SMTP id ffacd0b85a97d-36825ce1d1fmr1664248f8f.0.1721137877590;
        Tue, 16 Jul 2024 06:51:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGN3pshprrdSits0mGK+qv8WN/ikP9lOW25YYwsa4Pm53v/JhwVGtJE+P+u1g4WqyamVk7paK+y92Mnhsqfe+k=
X-Received: by 2002:a05:6000:1fa8:b0:367:434f:caa2 with SMTP id
 ffacd0b85a97d-36825ce1d1fmr1664222f8f.0.1721137877179; Tue, 16 Jul 2024
 06:51:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZpTIYCFIgvKogfE4@linux.dev>
In-Reply-To: <ZpTIYCFIgvKogfE4@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 16 Jul 2024 15:51:04 +0200
Message-ID: <CABgObfaWBW5o9kC554AQ4QzTUE7eJ=NGusjBUScp+rjGF1CqHA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.11
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, =?UTF-8?Q?Pierre=2DCl=C3=A9ment_Tosi?= <ptosi@google.com>, 
	Sebastian Ott <sebott@redhat.com>, Sebastian Ene <sebastianene@google.com>, 
	Changyuan Lyu <changyuanl@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Jintack Lim <jintack.lim@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 15, 2024 at 8:57=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Paolo,
>
> Apologies for sending this later than usual, I took some vacation at the
> end of last week and didn't have the time to send out before.
>
> Details can be found in the tag. Nothing significant to note, though
> Catalin reports a trivial conflict in arch/arm64/include/asm/esr.h
> between our trees [*].

All good, pulled.

Thanks,

Paolo

>
> Please pull.
>
> Thanks,
> Oliver
>
> [*] https://lore.kernel.org/linux-arm-kernel/20240711190353.3248426-1-cat=
alin.marinas@arm.com/
>
> The following changes since commit 83a7eefedc9b56fe7bfeff13b6c7356688ffa6=
70:
>
>   Linux 6.10-rc3 (2024-06-09 14:19:43 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-6.11
>
> for you to fetch changes up to bb032b2352c33be374136889789103d724f1b613:
>
>   Merge branch kvm-arm64/docs into kvmarm/next (2024-07-14 00:28:57 +0000=
)
>
> ----------------------------------------------------------------
> KVM/arm64 changes for 6.11
>
>  - Initial infrastructure for shadow stage-2 MMUs, as part of nested
>    virtualization enablement
>
>  - Support for userspace changes to the guest CTR_EL0 value, enabling
>    (in part) migration of VMs between heterogenous hardware
>
>  - Fixes + improvements to pKVM's FF-A proxy, adding support for v1.1 of
>    the protocol
>
>  - FPSIMD/SVE support for nested, including merged trap configuration
>    and exception routing
>
>  - New command-line parameter to control the WFx trap behavior under KVM
>
>  - Introduce kCFI hardening in the EL2 hypervisor
>
>  - Fixes + cleanups for handling presence/absence of FEAT_TCRX
>
>  - Miscellaneous fixes + documentation updates
>
> ----------------------------------------------------------------
> Changyuan Lyu (3):
>       KVM: Documentation: Fix typo `BFD`
>       KVM: Documentation: Enumerate allowed value macros of `irq_type`
>       KVM: Documentation: Correct the VGIC V2 CPU interface addr space si=
ze
>
> Christoffer Dall (2):
>       KVM: arm64: nv: Implement nested Stage-2 page table walk logic
>       KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
>
> Colton Lewis (1):
>       KVM: arm64: Add early_param to control WFx trapping
>
> Jintack Lim (1):
>       KVM: arm64: nv: Forward FP/ASIMD traps to guest hypervisor
>
> Marc Zyngier (25):
>       KVM: arm64: nv: Fix RESx behaviour of disabled FGTs with negative p=
olarity
>       KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
>       KVM: arm64: nv: Handle shadow stage 2 page faults
>       KVM: arm64: nv: Add Stage-1 EL2 invalidation primitives
>       KVM: arm64: nv: Handle EL2 Stage-1 TLB invalidation
>       KVM: arm64: nv: Handle TLB invalidation targeting L2 stage-1
>       KVM: arm64: nv: Handle TLBI VMALLS12E1{,IS} operations
>       KVM: arm64: nv: Handle TLBI ALLE1{,IS} operations
>       KVM: arm64: nv: Handle TLBI IPAS2E1{,IS} operations
>       KVM: arm64: nv: Handle FEAT_TTL hinted TLB operations
>       KVM: arm64: nv: Tag shadow S2 entries with guest's leaf S2 level
>       KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like informa=
tion
>       KVM: arm64: nv: Add handling of outer-shareable TLBI operations
>       KVM: arm64: nv: Add handling of range-based TLBI operations
>       KVM: arm64: nv: Add handling of NXS-flavoured TLBI operations
>       KVM: arm64: nv: Handle CPACR_EL1 traps
>       KVM: arm64: nv: Add TCPAC/TTA to CPTR->CPACR conversion helper
>       KVM: arm64: nv: Add trap description for CPTR_EL2
>       KVM: arm64: nv: Add additional trap setup for CPTR_EL2
>       KVM: arm64: Correctly honor the presence of FEAT_TCRX
>       KVM: arm64: Get rid of HCRX_GUEST_FLAGS
>       KVM: arm64: Make TCR2_EL1 save/restore dependent on the VM features
>       KVM: arm64: Make PIR{,E0}_EL1 save/restore conditional on FEAT_TCRX
>       KVM: arm64: Honor trap routing for TCR2_EL1
>       KVM: arm64: nv: Truely enable nXS TLBI operations
>
> Oliver Upton (28):
>       KVM: arm64: nv: Use GFP_KERNEL_ACCOUNT for sysreg_masks allocation
>       KVM: arm64: Get sys_reg encoding from descriptor in idregs_debug_sh=
ow()
>       KVM: arm64: Make idregs debugfs iterator search sysreg table direct=
ly
>       KVM: arm64: Use read-only helper for reading VM ID registers
>       KVM: arm64: Add helper for writing ID regs
>       KVM: arm64: nv: Use accessors for modifying ID registers
>       KVM: arm64: nv: Forward SVE traps to guest hypervisor
>       KVM: arm64: nv: Handle ZCR_EL2 traps
>       KVM: arm64: nv: Load guest hyp's ZCR into EL1 state
>       KVM: arm64: nv: Save guest's ZCR_EL2 when in hyp context
>       KVM: arm64: nv: Use guest hypervisor's max VL when running nested g=
uest
>       KVM: arm64: nv: Ensure correct VL is loaded before saving SVE state
>       KVM: arm64: Spin off helper for programming CPTR traps
>       KVM: arm64: nv: Load guest FP state for ZCR_EL2 trap
>       KVM: arm64: nv: Honor guest hypervisor's FP/SVE traps in CPTR_EL2
>       KVM: arm64: Allow the use of SVE+NV
>       KVM: arm64: nv: Unfudge ID_AA64PFR0_EL1 masking
>       KVM: selftests: Assert that MPIDR_EL1 is unchanged across vCPU rese=
t
>       MAINTAINERS: Include documentation in KVM/arm64 entry
>       Revert "KVM: arm64: nv: Fix RESx behaviour of disabled FGTs with ne=
gative polarity"
>       Merge branch kvm-arm64/misc into kvmarm/next
>       Merge branch kvm-arm64/ffa-1p1 into kvmarm/next
>       Merge branch kvm-arm64/shadow-mmu into kvmarm/next
>       Merge branch kvm-arm64/ctr-el0 into kvmarm/next
>       Merge branch kvm-arm64/el2-kcfi into kvmarm/next
>       Merge branch kvm-arm64/nv-sve into kvmarm/next
>       Merge branch kvm-arm64/nv-tcr2 into kvmarm/next
>       Merge branch kvm-arm64/docs into kvmarm/next
>
> Pierre-Cl=C3=A9ment Tosi (8):
>       KVM: arm64: Fix clobbered ELR in sync abort/SError
>       KVM: arm64: Fix __pkvm_init_switch_pgd call ABI
>       KVM: arm64: nVHE: Simplify invalid_host_el2_vect
>       KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
>       KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
>       arm64: Introduce esr_brk_comment, esr_is_cfi_brk
>       KVM: arm64: Introduce print_nvhe_hyp_panic helper
>       KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2
>
> Sebastian Ene (4):
>       KVM: arm64: Trap FFA_VERSION host call in pKVM
>       KVM: arm64: Add support for FFA_PARTITION_INFO_GET
>       KVM: arm64: Update the identification range for the FF-A smcs
>       KVM: arm64: Use FF-A 1.1 with pKVM
>
> Sebastian Ott (5):
>       KVM: arm64: unify code to prepare traps
>       KVM: arm64: Treat CTR_EL0 as a VM feature ID register
>       KVM: arm64: show writable masks for feature registers
>       KVM: arm64: rename functions for invariant sys regs
>       KVM: selftests: arm64: Test writes to CTR_EL0
>
>  Documentation/admin-guide/kernel-parameters.txt   |   18 +
>  Documentation/virt/kvm/api.rst                    |   10 +-
>  Documentation/virt/kvm/devices/arm-vgic.rst       |    2 +-
>  MAINTAINERS                                       |    2 +
>  arch/arm64/include/asm/esr.h                      |   12 +
>  arch/arm64/include/asm/kvm_arm.h                  |    1 -
>  arch/arm64/include/asm/kvm_asm.h                  |    2 +
>  arch/arm64/include/asm/kvm_emulate.h              |   95 +-
>  arch/arm64/include/asm/kvm_host.h                 |   68 +-
>  arch/arm64/include/asm/kvm_hyp.h                  |    4 +-
>  arch/arm64/include/asm/kvm_mmu.h                  |   26 +
>  arch/arm64/include/asm/kvm_nested.h               |  131 ++-
>  arch/arm64/include/asm/sysreg.h                   |   17 +
>  arch/arm64/kernel/asm-offsets.c                   |    1 +
>  arch/arm64/kernel/debug-monitors.c                |    4 +-
>  arch/arm64/kernel/traps.c                         |    8 +-
>  arch/arm64/kvm/arm.c                              |   86 +-
>  arch/arm64/kvm/emulate-nested.c                   |  104 +++
>  arch/arm64/kvm/fpsimd.c                           |   19 +-
>  arch/arm64/kvm/handle_exit.c                      |   43 +-
>  arch/arm64/kvm/hyp/entry.S                        |    8 +
>  arch/arm64/kvm/hyp/include/hyp/switch.h           |   29 +-
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h        |   35 +-
>  arch/arm64/kvm/hyp/include/nvhe/ffa.h             |    2 +-
>  arch/arm64/kvm/hyp/nvhe/Makefile                  |    6 +-
>  arch/arm64/kvm/hyp/nvhe/ffa.c                     |  180 +++-
>  arch/arm64/kvm/hyp/nvhe/gen-hyprel.c              |    6 +
>  arch/arm64/kvm/hyp/nvhe/host.S                    |    6 -
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S                |   30 +-
>  arch/arm64/kvm/hyp/nvhe/setup.c                   |    4 +-
>  arch/arm64/kvm/hyp/vhe/switch.c                   |  202 ++++-
>  arch/arm64/kvm/hyp/vhe/tlb.c                      |  147 +++
>  arch/arm64/kvm/mmu.c                              |  213 ++++-
>  arch/arm64/kvm/nested.c                           | 1002 +++++++++++++++=
+++---
>  arch/arm64/kvm/pmu-emul.c                         |    2 +-
>  arch/arm64/kvm/reset.c                            |    6 +
>  arch/arm64/kvm/sys_regs.c                         |  593 +++++++++++-
>  include/linux/arm_ffa.h                           |    3 +
>  tools/testing/selftests/kvm/aarch64/set_id_regs.c |   17 +
>  39 files changed, 2764 insertions(+), 380 deletions(-)
>

