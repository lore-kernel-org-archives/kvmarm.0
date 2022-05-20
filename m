Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA95FC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 20 May 2022 11:55:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FFFD4B37E;
	Fri, 20 May 2022 07:55:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iEZx6n5symaT; Fri, 20 May 2022 07:55:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 938F94B383;
	Fri, 20 May 2022 07:55:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 925704B28B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 07:55:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MUPnC8hvPqOg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 May 2022 07:55:47 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAB2A4101F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 07:55:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1653047747;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=RRDEzcMGVR0BdQDXOmNLpkbPevyevuUPJnyEYnznFQE=;
 b=RSjXU6k0ldQy2swR4nIiWtoL9S1C23rV6mPk7CAUHGqgrPVZ1Kewa0n95hu0gQeePLhLlj
 sVAtiDXdiykWjFJ6baKJR5E5OW1lP95AseSSrFnyr4rLBfpH/U4Q8u4nxiXMfNrsM2L9ja
 B2l9VVjTSr0NwnYkF+fbCmOce4ST9kM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-Su1ANgzaM32GU2K5qe3Rig-1; Fri, 20 May 2022 07:55:46 -0400
X-MC-Unique: Su1ANgzaM32GU2K5qe3Rig-1
Received: by mail-ed1-f69.google.com with SMTP id
 bc17-20020a056402205100b0042aa0e072d3so5521838edb.17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 04:55:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=RRDEzcMGVR0BdQDXOmNLpkbPevyevuUPJnyEYnznFQE=;
 b=mwpE7K/Jpq4w1kYdlN2lh29yEDqreG/eEsIpiZJAecCuWQehBLYc/LvxhrzM8vFa1Y
 4oRIsVNvxw6BToVuAn3HY5fHjijz6To24YYjxln0v1QeqJjgkNKcrwkj7ulw2DNwUMS8
 AYBAtho3D8W5B1JcFm/FqcZlXRTraZyOhQnEeLvBLSe/pZA9HxRG8gEzXsCSeMs+5ibG
 R+gGmEVYgiCNjXKdz9+bJaP+9f3Fu9otA6c+PKUIWNPBGREfXJjMNQrNtsfqg+qzrzu7
 Ki95O0+sp6neqJ18e1rk5KADVbTa5fPBakCFommphlUMc/H/BvG2ulMYNnpXGmYpaqUX
 B9lQ==
X-Gm-Message-State: AOAM532QKcU4DF5HwAlnNP+8DpsVvYo/8vebK5BVH/A8mRw/WHTWerDx
 vNVrIHz7pIjoMnqi3vU49GE0si+RkUP4svtFTvOoA4wR7XyjjE/kGQA9JI50TstDV2RsHOfO+Pr
 PXi+YOBjKdC9oc+WnQbHpmWU6
X-Received: by 2002:a05:6402:26d6:b0:42b:31b9:2064 with SMTP id
 x22-20020a05640226d600b0042b31b92064mr2043098edd.227.1653047745073; 
 Fri, 20 May 2022 04:55:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVpCbTQOnmAOV5+nZzROJ0bXiR6ZdTXXzKgFchMRarRUizOVPk5G5te7yEizfrH894FoXrLQ==
X-Received: by 2002:a05:6402:26d6:b0:42b:31b9:2064 with SMTP id
 x22-20020a05640226d600b0042b31b92064mr2043055edd.227.1653047744758; 
 Fri, 20 May 2022 04:55:44 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.googlemail.com with ESMTPSA id
 r17-20020a056402019100b0042abf2affebsm4150848edv.67.2022.05.20.04.55.41
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 20 May 2022 04:55:44 -0700 (PDT)
Message-ID: <a433a946-5398-c695-0f69-19c19ec86b6b@redhat.com>
Date: Fri, 20 May 2022 13:55:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [GIT PULL] KVM/arm64 updates for 5.19
To: Marc Zyngier <maz@kernel.org>
References: <20220519092744.992742-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220519092744.992742-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Wan Jiabing <wanjiabing@vivo.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, Mark Brown <broonie@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 5/19/22 11:27, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's the bulk of the KVM/arm64 updates for 5.19. Major features are
> guard pages for the EL2 stacks, save/restore of the guest-visible
> hypercall configuration and PSCI suspend support. Further details in
> the tag description.
> 
> Note that this PR contains a shared branch with the arm64 tree
> containing the SME patches to resolve conflicts with the WFxT support
> branch.

Pulled, thanks.  I solved the conflict for KVM_EXIT_SYSTEM_EVENT values 
in your favor.

Paolo

> Please pull,
> 
> 	M.
> 
> The following changes since commit 672c0c5173427e6b3e2a9bbb7be51ceeec78093a:
> 
>    Linux 5.18-rc5 (2022-05-01 13:57:58 -0700)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.19
> 
> for you to fetch changes up to 5c0ad551e9aa6188f2bda0977c1cb6768a2b74ef:
> 
>    Merge branch kvm-arm64/its-save-restore-fixes-5.19 into kvmarm-master/next (2022-05-16 17:48:36 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm64 updates for 5.19
> 
> - Add support for the ARMv8.6 WFxT extension
> 
> - Guard pages for the EL2 stacks
> 
> - Trap and emulate AArch32 ID registers to hide unsupported features
> 
> - Ability to select and save/restore the set of hypercalls exposed
>    to the guest
> 
> - Support for PSCI-initiated suspend in collaboration with userspace
> 
> - GICv3 register-based LPI invalidation support
> 
> - Move host PMU event merging into the vcpu data structure
> 
> - GICv3 ITS save/restore fixes
> 
> - The usual set of small-scale cleanups and fixes
> 
> ----------------------------------------------------------------
> Alexandru Elisei (3):
>        KVM: arm64: Hide AArch32 PMU registers when not available
>        KVM: arm64: Don't BUG_ON() if emulated register table is unsorted
>        KVM: arm64: Print emulated register table name when it is unsorted
> 
> Ard Biesheuvel (1):
>        KVM: arm64: Avoid unnecessary absolute addressing via literals
> 
> Fuad Tabba (4):
>        KVM: arm64: Wrapper for getting pmu_events
>        KVM: arm64: Repack struct kvm_pmu to reduce size
>        KVM: arm64: Pass pmu events to hyp via vcpu
>        KVM: arm64: Reenable pmu in Protected Mode
> 
> Kalesh Singh (6):
>        KVM: arm64: Introduce hyp_alloc_private_va_range()
>        KVM: arm64: Introduce pkvm_alloc_private_va_range()
>        KVM: arm64: Add guard pages for KVM nVHE hypervisor stack
>        KVM: arm64: Add guard pages for pKVM (protected nVHE) hypervisor stack
>        KVM: arm64: Detect and handle hypervisor stack overflows
>        KVM: arm64: Symbolize the nVHE HYP addresses
> 
> Marc Zyngier (30):
>        arm64: Expand ESR_ELx_WFx_ISS_TI to match its ARMv8.7 definition
>        arm64: Add RV and RN fields for ESR_ELx_WFx_ISS
>        arm64: Add HWCAP advertising FEAT_WFXT
>        arm64: Add wfet()/wfit() helpers
>        arm64: Use WFxT for __delay() when possible
>        KVM: arm64: Simplify kvm_cpu_has_pending_timer()
>        KVM: arm64: Introduce kvm_counter_compute_delta() helper
>        KVM: arm64: Handle blocking WFIT instruction
>        KVM: arm64: Offer early resume for non-blocking WFxT instructions
>        KVM: arm64: Expose the WFXT feature to guests
>        KVM: arm64: Fix new instances of 32bit ESRs
>        Merge remote-tracking branch 'arm64/for-next/sme' into kvmarm-master/next
>        Merge branch kvm-arm64/wfxt into kvmarm-master/next
>        Merge branch kvm-arm64/hyp-stack-guard into kvmarm-master/next
>        Merge branch kvm-arm64/aarch32-idreg-trap into kvmarm-master/next
>        Documentation: Fix index.rst after psci.rst renaming
>        irqchip/gic-v3: Exposes bit values for GICR_CTLR.{IR, CES}
>        KVM: arm64: vgic-v3: Expose GICR_CTLR.RWP when disabling LPIs
>        KVM: arm64: vgic-v3: Implement MMIO-based LPI invalidation
>        KVM: arm64: vgic-v3: Advertise GICR_CTLR.{IR, CES} as a new GICD_IIDR revision
>        KVM: arm64: vgic-v3: List M1 Pro/Max as requiring the SEIS workaround
>        KVM: arm64: Hide KVM_REG_ARM_*_BMAP_BIT_COUNT from userspace
>        KVM: arm64: pmu: Restore compilation when HW_PERF_EVENTS isn't selected
>        KVM: arm64: Fix hypercall bitmap writeback when vcpus have already run
>        Merge branch kvm-arm64/hcall-selection into kvmarm-master/next
>        Merge branch kvm-arm64/psci-suspend into kvmarm-master/next
>        Merge branch kvm-arm64/vgic-invlpir into kvmarm-master/next
>        Merge branch kvm-arm64/per-vcpu-host-pmu-data into kvmarm-master/next
>        Merge branch kvm-arm64/misc-5.19 into kvmarm-master/next
>        Merge branch kvm-arm64/its-save-restore-fixes-5.19 into kvmarm-master/next
> 
> Mark Brown (25):
>        arm64/sme: Provide ABI documentation for SME
>        arm64/sme: System register and exception syndrome definitions
>        arm64/sme: Manually encode SME instructions
>        arm64/sme: Early CPU setup for SME
>        arm64/sme: Basic enumeration support
>        arm64/sme: Identify supported SME vector lengths at boot
>        arm64/sme: Implement sysctl to set the default vector length
>        arm64/sme: Implement vector length configuration prctl()s
>        arm64/sme: Implement support for TPIDR2
>        arm64/sme: Implement SVCR context switching
>        arm64/sme: Implement streaming SVE context switching
>        arm64/sme: Implement ZA context switching
>        arm64/sme: Implement traps and syscall handling for SME
>        arm64/sme: Disable ZA and streaming mode when handling signals
>        arm64/sme: Implement streaming SVE signal handling
>        arm64/sme: Implement ZA signal handling
>        arm64/sme: Implement ptrace support for streaming mode SVE registers
>        arm64/sme: Add ptrace support for ZA
>        arm64/sme: Disable streaming mode and ZA when flushing CPU state
>        arm64/sme: Save and restore streaming mode over EFI runtime calls
>        KVM: arm64: Hide SME system registers from guests
>        KVM: arm64: Trap SME usage in guest
>        KVM: arm64: Handle SME host state when running guests
>        arm64/sme: Provide Kconfig for SME
>        arm64/sme: Add ID_AA64SMFR0_EL1 to __read_sysreg_by_encoding()
> 
> Oliver Upton (21):
>        KVM: arm64: Return a bool from emulate_cp()
>        KVM: arm64: Don't write to Rt unless sys_reg emulation succeeds
>        KVM: arm64: Wire up CP15 feature registers to their AArch64 equivalents
>        KVM: arm64: Plumb cp10 ID traps through the AArch64 sysreg handler
>        KVM: arm64: Start trapping ID registers for 32 bit guests
>        selftests: KVM: Rename psci_cpu_on_test to psci_test
>        selftests: KVM: Create helper for making SMCCC calls
>        KVM: arm64: Don't depend on fallthrough to hide SYSTEM_RESET2
>        KVM: arm64: Dedupe vCPU power off helpers
>        KVM: arm64: Track vCPU power state using MP state values
>        KVM: arm64: Rename the KVM_REQ_SLEEP handler
>        KVM: arm64: Return a value from check_vcpu_requests()
>        KVM: arm64: Add support for userspace to suspend a vCPU
>        KVM: arm64: Implement PSCI SYSTEM_SUSPEND
>        selftests: KVM: Rename psci_cpu_on_test to psci_test
>        selftests: KVM: Create helper for making SMCCC calls
>        selftests: KVM: Use KVM_SET_MP_STATE to power off vCPU in psci_test
>        selftests: KVM: Refactor psci_test to make it amenable to new tests
>        selftests: KVM: Test SYSTEM_SUSPEND PSCI call
>        KVM: arm64: pkvm: Drop unnecessary FP/SIMD trap handler
>        KVM: arm64: pkvm: Don't mask already zeroed FEAT_SVE
> 
> Raghavendra Rao Ananta (9):
>        KVM: arm64: Factor out firmware register handling from psci.c
>        KVM: arm64: Setup a framework for hypercall bitmap firmware registers
>        KVM: arm64: Add standard hypervisor firmware register
>        KVM: arm64: Add vendor hypervisor firmware register
>        Docs: KVM: Rename psci.rst to hypercalls.rst
>        Docs: KVM: Add doc for the bitmap firmware registers
>        tools: Import ARM SMCCC definitions
>        selftests: KVM: aarch64: Introduce hypercall ABI test
>        selftests: KVM: aarch64: Add the bitmap firmware registers to get-reg-list
> 
> Randy Dunlap (1):
>        KVM: arm64: nvhe: Eliminate kernel-doc warnings
> 
> Ricardo Koller (4):
>        KVM: arm64: vgic: Check that new ITEs could be saved in guest memory
>        KVM: arm64: vgic: Add more checks when restoring ITS tables
>        KVM: arm64: vgic: Do not ignore vgic_its_restore_cte failures
>        KVM: arm64: vgic: Undo work in failed ITS restores
> 
> Stephen Rothwell (1):
>        Documentation: KVM: Fix title level for PSCI_SUSPEND
> 
> Wan Jiabing (1):
>        arm64/sme: Fix NULL check after kzalloc
> 
>   Documentation/arm64/cpu-feature-registers.rst      |   2 +
>   Documentation/arm64/elf_hwcaps.rst                 |  37 ++
>   Documentation/arm64/index.rst                      |   1 +
>   Documentation/arm64/sme.rst                        | 428 +++++++++++++++
>   Documentation/arm64/sve.rst                        |  70 ++-
>   Documentation/virt/kvm/api.rst                     |  94 +++-
>   Documentation/virt/kvm/arm/hypercalls.rst          | 138 +++++
>   Documentation/virt/kvm/arm/index.rst               |   2 +-
>   Documentation/virt/kvm/arm/psci.rst                |  77 ---
>   arch/arm64/Kconfig                                 |  11 +
>   arch/arm64/include/asm/barrier.h                   |   4 +
>   arch/arm64/include/asm/cpu.h                       |   4 +
>   arch/arm64/include/asm/cpufeature.h                |  24 +
>   arch/arm64/include/asm/cputype.h                   |   8 +
>   arch/arm64/include/asm/el2_setup.h                 |  64 ++-
>   arch/arm64/include/asm/esr.h                       |  21 +-
>   arch/arm64/include/asm/exception.h                 |   1 +
>   arch/arm64/include/asm/fpsimd.h                    | 123 ++++-
>   arch/arm64/include/asm/fpsimdmacros.h              |  87 +++
>   arch/arm64/include/asm/hwcap.h                     |   9 +
>   arch/arm64/include/asm/kvm_arm.h                   |   4 +-
>   arch/arm64/include/asm/kvm_asm.h                   |   1 +
>   arch/arm64/include/asm/kvm_emulate.h               |   7 -
>   arch/arm64/include/asm/kvm_host.h                  |  45 +-
>   arch/arm64/include/asm/kvm_mmu.h                   |   3 +
>   arch/arm64/include/asm/processor.h                 |  26 +-
>   arch/arm64/include/asm/sysreg.h                    |  67 +++
>   arch/arm64/include/asm/thread_info.h               |   2 +
>   arch/arm64/include/uapi/asm/hwcap.h                |   9 +
>   arch/arm64/include/uapi/asm/kvm.h                  |  34 ++
>   arch/arm64/include/uapi/asm/ptrace.h               |  69 ++-
>   arch/arm64/include/uapi/asm/sigcontext.h           |  55 +-
>   arch/arm64/kernel/cpufeature.c                     | 120 +++++
>   arch/arm64/kernel/cpuinfo.c                        |  14 +
>   arch/arm64/kernel/entry-common.c                   |  11 +
>   arch/arm64/kernel/entry-fpsimd.S                   |  36 ++
>   arch/arm64/kernel/fpsimd.c                         | 585 +++++++++++++++++++--
>   arch/arm64/kernel/process.c                        |  44 +-
>   arch/arm64/kernel/ptrace.c                         | 358 +++++++++++--
>   arch/arm64/kernel/signal.c                         | 188 ++++++-
>   arch/arm64/kernel/syscall.c                        |  29 +-
>   arch/arm64/kernel/traps.c                          |   1 +
>   arch/arm64/kvm/Makefile                            |   4 +-
>   arch/arm64/kvm/arch_timer.c                        |  47 +-
>   arch/arm64/kvm/arm.c                               | 158 +++++-
>   arch/arm64/kvm/fpsimd.c                            |  43 +-
>   arch/arm64/kvm/guest.c                             |  10 +-
>   arch/arm64/kvm/handle_exit.c                       |  49 +-
>   arch/arm64/kvm/hyp/include/nvhe/mm.h               |   6 +-
>   arch/arm64/kvm/hyp/nvhe/host.S                     |  32 +-
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  18 +-
>   arch/arm64/kvm/hyp/nvhe/mm.c                       |  78 ++-
>   arch/arm64/kvm/hyp/nvhe/setup.c                    |  31 +-
>   arch/arm64/kvm/hyp/nvhe/switch.c                   |  87 +--
>   arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |   3 -
>   arch/arm64/kvm/hyp/vhe/switch.c                    |  11 +-
>   arch/arm64/kvm/hypercalls.c                        | 327 +++++++++++-
>   arch/arm64/kvm/mmu.c                               |  68 ++-
>   arch/arm64/kvm/pmu-emul.c                          |   3 +-
>   arch/arm64/kvm/pmu.c                               |  40 +-
>   arch/arm64/kvm/psci.c                              | 248 ++-------
>   arch/arm64/kvm/sys_regs.c                          | 305 ++++++++---
>   arch/arm64/kvm/sys_regs.h                          |   9 +-
>   arch/arm64/kvm/vgic/vgic-init.c                    |   7 +-
>   arch/arm64/kvm/vgic/vgic-its.c                     | 160 ++++--
>   arch/arm64/kvm/vgic/vgic-mmio-v2.c                 |  18 +-
>   arch/arm64/kvm/vgic/vgic-mmio-v3.c                 | 125 ++++-
>   arch/arm64/kvm/vgic/vgic-v3.c                      |   4 +
>   arch/arm64/kvm/vgic/vgic.h                         |  10 +
>   arch/arm64/lib/delay.c                             |  12 +-
>   arch/arm64/tools/cpucaps                           |   3 +
>   include/kvm/arm_arch_timer.h                       |   2 -
>   include/kvm/arm_hypercalls.h                       |   8 +
>   include/kvm/arm_pmu.h                              |  34 +-
>   include/kvm/arm_psci.h                             |   7 -
>   include/kvm/arm_vgic.h                             |   8 +-
>   include/linux/irqchip/arm-gic-v3.h                 |   2 +
>   include/uapi/linux/elf.h                           |   2 +
>   include/uapi/linux/kvm.h                           |   4 +
>   include/uapi/linux/prctl.h                         |   9 +
>   kernel/sys.c                                       |  12 +
>   scripts/kallsyms.c                                 |   3 +-
>   tools/include/linux/arm-smccc.h                    | 193 +++++++
>   tools/testing/selftests/kvm/.gitignore             |   3 +-
>   tools/testing/selftests/kvm/Makefile               |   3 +-
>   tools/testing/selftests/kvm/aarch64/get-reg-list.c |   8 +
>   tools/testing/selftests/kvm/aarch64/hypercalls.c   | 336 ++++++++++++
>   .../selftests/kvm/aarch64/psci_cpu_on_test.c       | 121 -----
>   tools/testing/selftests/kvm/aarch64/psci_test.c    | 213 ++++++++
>   .../selftests/kvm/include/aarch64/processor.h      |  22 +
>   .../testing/selftests/kvm/lib/aarch64/processor.c  |  25 +
>   tools/testing/selftests/kvm/steal_time.c           |  13 +-
>   92 files changed, 4949 insertions(+), 908 deletions(-)
>   create mode 100644 Documentation/arm64/sme.rst
>   create mode 100644 Documentation/virt/kvm/arm/hypercalls.rst
>   delete mode 100644 Documentation/virt/kvm/arm/psci.rst
>   create mode 100644 tools/include/linux/arm-smccc.h
>   create mode 100644 tools/testing/selftests/kvm/aarch64/hypercalls.c
>   delete mode 100644 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
>   create mode 100644 tools/testing/selftests/kvm/aarch64/psci_test.c
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
