Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858C411C9F
	for <kvmarm@lists.linux.dev>; Mon,  5 Jun 2023 11:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685964502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gGxumpBmB6bu2hZrLx6m+icJFjDPrO90FlXSaiDOh7U=;
	b=cWMqXis51zo/8FrosFMCwJwlNSmhWyZsn43dQHMBHEiAH7FEuQXM0e4cAmiP7w3Qz00sTR
	Ip+RaxUJ8SZxYfIW27BIScI8YXcMoUfN1DqsBAtbK0407J/OkNONMNG/3hzRuV6p/NJW0s
	RIliqyljttmtCh0y2jxtdEO1bMK+WBI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-U40eTMGGPLmxKRqGBFBzyQ-1; Mon, 05 Jun 2023 07:28:19 -0400
X-MC-Unique: U40eTMGGPLmxKRqGBFBzyQ-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-625fd27e074so57269826d6.3
        for <kvmarm@lists.linux.dev>; Mon, 05 Jun 2023 04:28:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685964498; x=1688556498;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gGxumpBmB6bu2hZrLx6m+icJFjDPrO90FlXSaiDOh7U=;
        b=YS0geODtMC4u5VlrGi/3welo5elBLNJtL82VkZKe5uJMFg2suy6JDaNsYVcaMKHOkN
         xk1lMDzBxVmhsRDaZ/+Xm23Iftgfd44GENareVi1j8agq1deNETfTW5WWktR67OrV0/8
         BxqyAWObyewZ+vHdqGFu2OlVMaEy/R14/Oeocec59tffS27QaPxJvPirH8KIR4EqPVCg
         CwlxlEtXoXZ/uSuDQrgyZT3IYLpfTzLMAP1cX2yaSaQRQh87m8QJwg8MjvLFrVysDBjq
         IW6PmXQUf0lH3YUfFe3gi+XchWDFe3Pu3E++X49UET/koLvyaqOmoOFPxx7vaaRyJesj
         YDGg==
X-Gm-Message-State: AC+VfDyqbCk0EmOBEEToSXAuvh7Rbt7cjN5m/8ZEzJmBW+LcADNP1tl1
	LIjJLmYB+Ql/MyqSvgT1RdQJtA6CwhuiIkCK9TBdoz3Sszx55T6J0YX9+bFl73CGJAHLYTkDf9z
	mpd3lEgg5bI4EQW58
X-Received: by 2002:ad4:5dee:0:b0:626:3bf8:aef0 with SMTP id jn14-20020ad45dee000000b006263bf8aef0mr8498722qvb.23.1685964498503;
        Mon, 05 Jun 2023 04:28:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ55FTre2emNmet1eFAOUds+rzBrNT6QYexX6OUWe7LxSEYp7nZ9dLBxJJZUaUc8pLeQ8H6yWA==
X-Received: by 2002:ad4:5dee:0:b0:626:3bf8:aef0 with SMTP id jn14-20020ad45dee000000b006263bf8aef0mr8498690qvb.23.1685964498177;
        Mon, 05 Jun 2023 04:28:18 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id et9-20020a056214176900b0062595cd1972sm4480584qvb.82.2023.06.05.04.28.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 04:28:17 -0700 (PDT)
Message-ID: <9cf2356b-f990-1cd2-c7e6-a984e9f604c6@redhat.com>
Date: Mon, 5 Jun 2023 13:28:12 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 00/59] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Jintack Lim <jintack@cs.columbia.edu>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230515173103.1017669-1-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 5/15/23 19:30, Marc Zyngier wrote:
> This is the 4th drop of NV support on arm64 for this year.
> 
> For the previous episodes, see [1].
> 
> What's changed:
> 
> - New framework to track system register traps that are reinjected in
>   guest EL2. It is expected to replace the discrete handling we have
>   enjoyed so far, which didn't scale at all. This has already fixed a
>   number of bugs that were hidden (a bunch of traps were never
>   forwarded...). Still a work in progress, but this is going in the
>   right direction.
> 
> - Allow the L1 hypervisor to have a S2 that has an input larger than
>   the L0 IPA space. This fixes a number of subtle issues, depending on
>   how the initial guest was created.
> 
> - Consequently, the patch series has gone longer again. Boo. But
>   hopefully some of it is easier to review...
> 
> [1] https://lore.kernel.org/r/20230405154008.3552854-1-maz@kernel.org
> 
> Andre Przywara (1):
>   KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ

I guess you have executed kselftests on L1 guests. Have all the tests
passed there? On my end it stalls in the KVM_RUN.

for instance
tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c fails in
test_guest_raz(vcpu) on the KVM_RUN. Even with a basic

static void guest_main(void)
{
GUEST_DONE();
}

I get
 aarch32_id_regs-768     [002] .....   410.544665: kvm_exit: IRQ:
HSR_EC: 0x0000 (UNKNOWN), PC: 0x0000000000401ec4
 aarch32_id_regs-768     [002] d....   410.544666: kvm_entry: PC:
0x0000000000401ec4
 aarch32_id_regs-768     [002] .....   410.544675: kvm_exit: IRQ:
HSR_EC: 0x0000 (UNKNOWN), PC: 0x0000000000401ec4
 aarch32_id_regs-768     [002] d....   410.544676: kvm_entry: PC:
0x0000000000401ec4
 aarch32_id_regs-768     [002] .....   410.544685: kvm_exit: IRQ:
HSR_EC: 0x0000 (UNKNOWN), PC: 0x0000000000401ec4

looping forever instead of

aarch32_id_regs-1085576 [079] d..1. 1401295.068739: kvm_entry: PC:
0x0000000000401ec4
 aarch32_id_regs-1085576 [079] ...1. 1401295.068745: kvm_exit: TRAP:
HSR_EC: 0x0020 (IABT_LOW), PC: 0x0000000000401ec4
 aarch32_id_regs-1085576 [079] d..1. 1401295.068790: kvm_entry: PC:
0x0000000000401ec4
 aarch32_id_regs-1085576 [079] ...1. 1401295.068792: kvm_exit: TRAP:
HSR_EC: 0x0020 (IABT_LOW), PC: 0x0000000000401ec4
 aarch32_id_regs-1085576 [079] d..1. 1401295.068794: kvm_entry: PC:
0x0000000000401ec4
 aarch32_id_regs-1085576 [079] ...1. 1401295.068795: kvm_exit: TRAP:
HSR_EC: 0x0020 (IABT_LOW), PC: 0x0000000000401ec4
 aarch32_id_regs-1085576 [079] d..1. 1401295.068797: kvm_entry: PC:
0x0000000000401ec4
../..

Any idea or any known restriction wrt kselftests?

Thanks

Eric




> 
> Christoffer Dall (5):
>   KVM: arm64: nv: Trap EL1 VM register accesses in virtual EL2
>   KVM: arm64: nv: Implement nested Stage-2 page table walk logic
>   KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
>   KVM: arm64: nv: vgic: Emulate the HW bit in software
>   KVM: arm64: nv: Sync nested timer state with FEAT_NV2
> 
> Jintack Lim (7):
>   KVM: arm64: nv: Trap CPACR_EL1 access in virtual EL2
>   KVM: arm64: nv: Respect virtual HCR_EL2.TWX setting
>   KVM: arm64: nv: Respect virtual CPTR_EL2.{TFP,FPEN} settings
>   KVM: arm64: nv: Respect virtual HCR_EL2.{NV,TSC) settings
>   KVM: arm64: nv: Configure HCR_EL2 for nested virtualization
>   KVM: arm64: nv: Trap and emulate TLBI instructions from virtual EL2
>   KVM: arm64: nv: Nested GICv3 Support
> 
> Marc Zyngier (46):
>   KVM: arm64: Move VTCR_EL2 into struct s2_mmu
>   arm64: Add missing Set/Way CMO encodings
>   arm64: Add missing VA CMO encodings
>   arm64: Add missing ERXMISCx_EL1 encodings
>   arm64: Add missing DC ZVA/GVA/GZVA encodings
>   arm64: Add TLBI operation encodings
>   arm64: Add AT operation encodings
>   KVM: arm64: Add missing HCR_EL2 trap bits
>   KVM: arm64: nv: Add trap forwarding infrastructure
>   KVM: arm64: nv: Add trap forwarding for HCR_EL2
>   KVM: arm64: nv: Expose FEAT_EVT to nested guests
>   KVM: arm64: nv: Add trap forwarding for MDCR_EL2
>   KVM: arm64: nv: Add trap forwarding for CNTHCTL_EL2
>   KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
>   KVM: arm64: nv: Handle virtual EL2 registers in
>     vcpu_read/write_sys_reg()
>   KVM: arm64: nv: Handle SPSR_EL2 specially
>   KVM: arm64: nv: Handle HCR_EL2.E2H specially
>   KVM: arm64: nv: Save/Restore vEL2 sysregs
>   KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
>   KVM: arm64: nv: Handle shadow stage 2 page faults
>   KVM: arm64: nv: Restrict S2 RD/WR permissions to match the guest's
>   KVM: arm64: nv: Set a handler for the system instruction traps
>   KVM: arm64: nv: Trap and emulate AT instructions from virtual EL2
>   KVM: arm64: nv: Fold guest's HCR_EL2 configuration into the host's
>   KVM: arm64: nv: Hide RAS from nested guests
>   KVM: arm64: nv: Add handling of EL2-specific timer registers
>   KVM: arm64: nv: Load timer before the GIC
>   KVM: arm64: nv: Don't load the GICv4 context on entering a nested
>     guest
>   KVM: arm64: nv: Implement maintenance interrupt forwarding
>   KVM: arm64: nv: Deal with broken VGIC on maintenance interrupt
>     delivery
>   KVM: arm64: nv: Allow userspace to request KVM_ARM_VCPU_NESTED_VIRT
>   KVM: arm64: nv: Add handling of FEAT_TTL TLB invalidation
>   KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like
>     information
>   KVM: arm64: nv: Tag shadow S2 entries with nested level
>   KVM: arm64: nv: Add include containing the VNCR_EL2 offsets
>   KVM: arm64: nv: Map VNCR-capable registers to a separate page
>   KVM: arm64: nv: Move nested vgic state into the sysreg file
>   KVM: arm64: Add FEAT_NV2 cpu feature
>   KVM: arm64: nv: Fold GICv3 host trapping requirements into guest setup
>   KVM: arm64: nv: Publish emulated timer interrupt state in the
>     in-memory state
>   KVM: arm64: nv: Allocate VNCR page when required
>   KVM: arm64: nv: Enable ARMv8.4-NV support
>   KVM: arm64: nv: Fast-track 'InHost' exception returns
>   KVM: arm64: nv: Fast-track EL1 TLBIs for VHE guests
>   KVM: arm64: nv: Use FEAT_ECV to trap access to EL0 timers
>   KVM: arm64: nv: Accelerate EL0 timer read accesses when FEAT_ECV is on
> 
>  .../virt/kvm/devices/arm-vgic-v3.rst          |  12 +-
>  arch/arm64/include/asm/esr.h                  |   1 +
>  arch/arm64/include/asm/kvm_arm.h              |  14 +
>  arch/arm64/include/asm/kvm_asm.h              |   4 +
>  arch/arm64/include/asm/kvm_emulate.h          |  93 +-
>  arch/arm64/include/asm/kvm_host.h             | 181 +++-
>  arch/arm64/include/asm/kvm_hyp.h              |   2 +
>  arch/arm64/include/asm/kvm_mmu.h              |  20 +-
>  arch/arm64/include/asm/kvm_nested.h           | 133 +++
>  arch/arm64/include/asm/stage2_pgtable.h       |   4 +-
>  arch/arm64/include/asm/sysreg.h               | 196 ++++
>  arch/arm64/include/asm/vncr_mapping.h         |  74 ++
>  arch/arm64/include/uapi/asm/kvm.h             |   1 +
>  arch/arm64/kernel/cpufeature.c                |  11 +
>  arch/arm64/kvm/Makefile                       |   4 +-
>  arch/arm64/kvm/arch_timer.c                   |  98 +-
>  arch/arm64/kvm/arm.c                          |  33 +-
>  arch/arm64/kvm/at.c                           | 219 ++++
>  arch/arm64/kvm/emulate-nested.c               | 934 ++++++++++++++++-
>  arch/arm64/kvm/handle_exit.c                  |  29 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h       |   8 +-
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h    |   5 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         |   8 +-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                |   4 +-
>  arch/arm64/kvm/hyp/nvhe/switch.c              |   2 +-
>  arch/arm64/kvm/hyp/nvhe/sysreg-sr.c           |   2 +-
>  arch/arm64/kvm/hyp/pgtable.c                  |   2 +-
>  arch/arm64/kvm/hyp/vgic-v3-sr.c               |   6 +-
>  arch/arm64/kvm/hyp/vhe/switch.c               | 206 +++-
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c            | 124 ++-
>  arch/arm64/kvm/hyp/vhe/tlb.c                  |  83 ++
>  arch/arm64/kvm/mmu.c                          | 255 ++++-
>  arch/arm64/kvm/nested.c                       | 799 ++++++++++++++-
>  arch/arm64/kvm/pkvm.c                         |   2 +-
>  arch/arm64/kvm/reset.c                        |   7 +
>  arch/arm64/kvm/sys_regs.c                     | 958 +++++++++++++++++-
>  arch/arm64/kvm/trace_arm.h                    |  19 +
>  arch/arm64/kvm/vgic/vgic-init.c               |  33 +
>  arch/arm64/kvm/vgic/vgic-kvm-device.c         |  32 +-
>  arch/arm64/kvm/vgic/vgic-v3-nested.c          | 248 +++++
>  arch/arm64/kvm/vgic/vgic-v3.c                 |  43 +-
>  arch/arm64/kvm/vgic/vgic.c                    |  29 +
>  arch/arm64/kvm/vgic/vgic.h                    |  10 +
>  arch/arm64/tools/cpucaps                      |   1 +
>  include/clocksource/arm_arch_timer.h          |   4 +
>  include/kvm/arm_arch_timer.h                  |   1 +
>  include/kvm/arm_vgic.h                        |  17 +
>  include/uapi/linux/kvm.h                      |   1 +
>  tools/arch/arm/include/uapi/asm/kvm.h         |   1 +
>  49 files changed, 4790 insertions(+), 183 deletions(-)
>  create mode 100644 arch/arm64/include/asm/vncr_mapping.h
>  create mode 100644 arch/arm64/kvm/at.c
>  create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c
> 

