Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E67C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  3 Oct 2022 19:39:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0D03411BD;
	Mon,  3 Oct 2022 15:39:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r32l4fWmWcTQ; Mon,  3 Oct 2022 15:39:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12ACE410DE;
	Mon,  3 Oct 2022 15:39:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A663410DE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Oct 2022 15:39:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ONvyHkoLbzXz for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Oct 2022 15:39:18 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00372410AD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Oct 2022 15:39:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1664825957;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=sQIFh9E1moB39O9uswnxNRAhNBaWxumvBbogR1iYCAU=;
 b=ESwqhdz8k9bkCE1O1hMhT4xBUVgjTkKB8DO4LoTT2w7JlrMttWn8oFDtzjewoID4xpBxA9
 bcW8yXYgV0NCR35kncwSMKGSPZlbf/E+k5fUUpb0+39DbHbkPskNp1EPYeyXuDumJWn7bJ
 hMN1IzLk9H5mhREXOfnR5ykmMpgn4eA=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-556-skX1iQOQM8m0ZbqhUeFZXQ-1; Mon, 03 Oct 2022 15:39:16 -0400
X-MC-Unique: skX1iQOQM8m0ZbqhUeFZXQ-1
Received: by mail-vk1-f200.google.com with SMTP id
 t125-20020a1f7883000000b003a9d400434aso983201vkc.20
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Oct 2022 12:39:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=sQIFh9E1moB39O9uswnxNRAhNBaWxumvBbogR1iYCAU=;
 b=fJ+/4OYc2U+Tn4d+grl35tYi0iuJr8TmM6huhDx0X0J8KNgmuMAtMASit4MMXZEFO6
 zjiHl0qCIa7Eyyl2m/jOZsvOakktyjXzDkE+ayriu6/af6QTUskkhsULnTF3bzw+2gkf
 vNd/1roDVLK+5FkktHAU0Tq39Jw53W8np+3dREpdPFlmEDPiTMUeBWpssty+S1wZp1o/
 XU6yDAyrnZKKBBh8ipZUs4dWNxbzBuvVGsGXlKkQgRBMO04s1ZGPqVUJxAS+oA3h8LNM
 gWqhNkMNcmYpYy61PyK6MzI4r+31kfUgPLxH29suUlTQT7unypiGVcdgpZq6Dfm7IR0u
 CEow==
X-Gm-Message-State: ACrzQf3ZZREVzDPnNgnnIwlSWklFIJ8XRmNodCzzpoUEl9ZzvM3QK/Ku
 8nxTQdZ2z90/7FZt9+W7k3w7WFvfbwh3tqQf/LUfrsNAC6b4WcYVcDHiEsMpzWCF4SFNQhcmDgJ
 cju8/HpNgCS0s8JlOzZNnX0dEfzehlnutLma+f4mx
X-Received: by 2002:a05:6102:348:b0:3a6:4240:6d3e with SMTP id
 e8-20020a056102034800b003a642406d3emr4087679vsa.16.1664825955775; 
 Mon, 03 Oct 2022 12:39:15 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7jQI2r9QR9nix+Dwc7/OqcC7ZH5vng9wtOftG5PhvwZ9SzH/GR8GdWmLrB4C9LUHkfdIn7rWyXRjButK0bUFY=
X-Received: by 2002:a05:6102:348:b0:3a6:4240:6d3e with SMTP id
 e8-20020a056102034800b003a642406d3emr4087660vsa.16.1664825955481; Mon, 03 Oct
 2022 12:39:15 -0700 (PDT)
MIME-Version: 1.0
References: <20221002124219.3902661-1-maz@kernel.org>
In-Reply-To: <20221002124219.3902661-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 3 Oct 2022 21:39:04 +0200
Message-ID: <CABgObfZzD-2yiu67RAzNDH6UieCihoc5_e1OVTeUsXRFBMQ+0Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.1
To: Marc Zyngier <maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Wei-Lin Chang <r09922117@csie.ntu.edu.tw>, Mark Brown <broonie@kernel.org>,
 Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.linux.dev,
 Elliot Berman <quic_eberman@quicinc.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Pulled, thanks!

Paolo

On Sun, Oct 2, 2022 at 2:42 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> Please find below the rather small set of KVM/arm64 updates
> for 6.1. This is mostly a set of fixes for existing features,
> the most interesting one being Reiji's really good work tracking
> an annoying set of bugs in our single-stepping implementation.
> Also, I've included the changes making it possible to enable
> the dirty-ring tracking on arm64. Full details in the tag.
>
> Note that this pull-request comes with a branch shared with the
> arm64 tree, in order to avoid some bad conflicts due to the
> ongoing repainting of all the system registers.
>
> Please pull,
>
>         M.
>
> The following changes since commit b90cb1053190353cc30f0fef0ef1f378ccc063c5:
>
>   Linux 6.0-rc3 (2022-08-28 15:05:29 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-6.1
>
> for you to fetch changes up to b302ca52ba8235ff0e18c0fa1fa92b51784aef6a:
>
>   Merge branch kvm-arm64/misc-6.1 into kvmarm-master/next (2022-10-01 10:19:36 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 updates for v6.1
>
> - Fixes for single-stepping in the presence of an async
>   exception as well as the preservation of PSTATE.SS
>
> - Better handling of AArch32 ID registers on AArch64-only
>   systems
>
> - Fixes for the dirty-ring API, allowing it to work on
>   architectures with relaxed memory ordering
>
> - Advertise the new kvmarm mailing list
>
> - Various minor cleanups and spelling fixes
>
> ----------------------------------------------------------------
> Elliot Berman (1):
>       KVM: arm64: Ignore kvm-arm.mode if !is_hyp_mode_available()
>
> Gavin Shan (1):
>       KVM: arm64: vgic: Remove duplicate check in update_affinity_collection()
>
> Kristina Martsenko (3):
>       arm64: cache: Remove unused CTR_CACHE_MINLINE_MASK
>       arm64/sysreg: Standardise naming for ID_AA64MMFR1_EL1 fields
>       arm64/sysreg: Convert ID_AA64MMFR1_EL1 to automatic generation
>
> Marc Zyngier (12):
>       Merge branch kvm-arm64/aarch32-raz-idregs into kvmarm-master/next
>       Merge remote-tracking branch 'arm64/for-next/sysreg' into kvmarm-master/next
>       Merge branch kvm-arm64/single-step-async-exception into kvmarm-master/next
>       KVM: Use acquire/release semantics when accessing dirty ring GFN state
>       KVM: Add KVM_CAP_DIRTY_LOG_RING_ACQ_REL capability and config option
>       KVM: x86: Select CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL
>       KVM: Document weakly ordered architecture requirements for dirty ring
>       KVM: selftests: dirty-log: Upgrade flag accesses to acquire/release semantics
>       KVM: selftests: dirty-log: Use KVM_CAP_DIRTY_LOG_RING_ACQ_REL if available
>       KVM: arm64: Advertise new kvmarm mailing list
>       Merge branch kvm-arm64/dirty-log-ordered into kvmarm-master/next
>       Merge branch kvm-arm64/misc-6.1 into kvmarm-master/next
>
> Mark Brown (31):
>       arm64/sysreg: Remove stray SMIDR_EL1 defines
>       arm64/sysreg: Describe ID_AA64SMFR0_EL1.SMEVer as an enumeration
>       arm64/sysreg: Add _EL1 into ID_AA64MMFR0_EL1 definition names
>       arm64/sysreg: Add _EL1 into ID_AA64MMFR2_EL1 definition names
>       arm64/sysreg: Add _EL1 into ID_AA64PFR0_EL1 definition names
>       arm64/sysreg: Add _EL1 into ID_AA64PFR1_EL1 constant names
>       arm64/sysreg: Standardise naming of ID_AA64MMFR0_EL1.BigEnd
>       arm64/sysreg: Standardise naming of ID_AA64MMFR0_EL1.ASIDBits
>       arm64/sysreg: Standardise naming for ID_AA64MMFR2_EL1.VARange
>       arm64/sysreg: Standardise naming for ID_AA64MMFR2_EL1.CnP
>       arm64/sysreg: Standardise naming for ID_AA64PFR0_EL1 constants
>       arm64/sysreg: Standardise naming for ID_AA64PFR0_EL1.AdvSIMD constants
>       arm64/sysreg: Standardise naming for SSBS feature enumeration
>       arm64/sysreg: Standardise naming for MTE feature enumeration
>       arm64/sysreg: Standardise naming of ID_AA64PFR1_EL1 fractional version fields
>       arm64/sysreg: Standardise naming of ID_AA64PFR1_EL1 BTI enumeration
>       arm64/sysreg: Standardise naming of ID_AA64PFR1_EL1 SME enumeration
>       arm64/sysreg: Convert HCRX_EL2 to automatic generation
>       arm64/sysreg: Convert ID_AA64MMFR0_EL1 to automatic generation
>       arm64/sysreg: Convert ID_AA64MMFR2_EL1 to automatic generation
>       arm64/sysreg: Convert ID_AA64PFR0_EL1 to automatic generation
>       arm64/sysreg: Convert ID_AA64PFR1_EL1 to automatic generation
>       arm64/sysreg: Convert TIPDR_EL1 to automatic generation
>       arm64/sysreg: Convert SCXTNUM_EL1 to automatic generation
>       arm64/sysreg: Add defintion for ALLINT
>       arm64/sysreg: Align field names in ID_AA64DFR0_EL1 with architecture
>       arm64/sysreg: Add _EL1 into ID_AA64DFR0_EL1 definition names
>       arm64/sysreg: Use feature numbering for PMU and SPE revisions
>       arm64/sysreg: Convert ID_AA64FDR0_EL1 to automatic generation
>       arm64/sysreg: Convert ID_AA64DFR1_EL1 to automatic generation
>       arm64/sysreg: Convert ID_AA64AFRn_EL1 to automatic generation
>
> Oliver Upton (8):
>       KVM: arm64: Use visibility hook to treat ID regs as RAZ
>       KVM: arm64: Remove internal accessor helpers for id regs
>       KVM: arm64: Drop raz parameter from read_id_reg()
>       KVM: arm64: Spin off helper for calling visibility hook
>       KVM: arm64: Add a visibility bit to ignore user writes
>       KVM: arm64: Treat 32bit ID registers as RAZ/WI on 64bit-only system
>       KVM: selftests: Add test for AArch32 ID registers
>       KVM: selftests: Update top-of-file comment in psci_test
>
> Reiji Watanabe (4):
>       KVM: arm64: Preserve PSTATE.SS for the guest while single-step is enabled
>       KVM: arm64: Clear PSTATE.SS when the Software Step state was Active-pending
>       KVM: arm64: selftests: Refactor debug-exceptions to make it amenable to new test cases
>       KVM: arm64: selftests: Add a test case for KVM_GUESTDBG_SINGLESTEP
>
> Wei-Lin Chang (1):
>       KVM: arm64: Fix comment typo in nvhe/switch.c
>
>  Documentation/virt/kvm/api.rst                     |  17 +-
>  MAINTAINERS                                        |   3 +-
>  arch/arm64/include/asm/assembler.h                 |  10 +-
>  arch/arm64/include/asm/cache.h                     |   4 -
>  arch/arm64/include/asm/cpufeature.h                |  66 +--
>  arch/arm64/include/asm/el2_setup.h                 |  18 +-
>  arch/arm64/include/asm/hw_breakpoint.h             |   4 +-
>  arch/arm64/include/asm/kvm_host.h                  |   4 +
>  arch/arm64/include/asm/kvm_pgtable.h               |   6 +-
>  arch/arm64/include/asm/sysreg.h                    | 211 ++--------
>  arch/arm64/kernel/cpufeature.c                     | 238 +++++------
>  arch/arm64/kernel/debug-monitors.c                 |   2 +-
>  arch/arm64/kernel/head.S                           |  10 +-
>  arch/arm64/kernel/hyp-stub.S                       |   8 +-
>  arch/arm64/kernel/idreg-override.c                 |  10 +-
>  arch/arm64/kernel/perf_event.c                     |   8 +-
>  arch/arm64/kernel/proton-pack.c                    |   4 +-
>  arch/arm64/kvm/arm.c                               |  15 +-
>  arch/arm64/kvm/debug.c                             |  38 +-
>  arch/arm64/kvm/guest.c                             |   1 +
>  arch/arm64/kvm/handle_exit.c                       |   8 +-
>  arch/arm64/kvm/hyp/include/nvhe/fixed_config.h     |  60 +--
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  38 +-
>  arch/arm64/kvm/hyp/nvhe/switch.c                   |   2 +-
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |  10 +-
>  arch/arm64/kvm/hyp/pgtable.c                       |   2 +-
>  arch/arm64/kvm/pmu-emul.c                          |  16 +-
>  arch/arm64/kvm/reset.c                             |  12 +-
>  arch/arm64/kvm/sys_regs.c                          | 198 +++++----
>  arch/arm64/kvm/sys_regs.h                          |  24 +-
>  arch/arm64/kvm/vgic/vgic-its.c                     |   2 +-
>  arch/arm64/mm/context.c                            |   6 +-
>  arch/arm64/mm/init.c                               |   2 +-
>  arch/arm64/mm/mmu.c                                |   2 +-
>  arch/arm64/mm/proc.S                               |   4 +-
>  arch/arm64/tools/sysreg                            | 449 ++++++++++++++++++++-
>  arch/x86/kvm/Kconfig                               |   3 +-
>  drivers/firmware/efi/libstub/arm64-stub.c          |   4 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c    |   6 +-
>  drivers/irqchip/irq-gic-v4.c                       |   2 +-
>  include/uapi/linux/kvm.h                           |   1 +
>  tools/testing/selftests/kvm/.gitignore             |   1 +
>  tools/testing/selftests/kvm/Makefile               |   1 +
>  .../selftests/kvm/aarch64/aarch32_id_regs.c        | 169 ++++++++
>  .../selftests/kvm/aarch64/debug-exceptions.c       | 149 ++++++-
>  tools/testing/selftests/kvm/aarch64/psci_test.c    |  10 +-
>  tools/testing/selftests/kvm/dirty_log_test.c       |   8 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c         |   5 +-
>  virt/kvm/Kconfig                                   |  14 +
>  virt/kvm/dirty_ring.c                              |   4 +-
>  virt/kvm/kvm_main.c                                |   9 +-
>  51 files changed, 1294 insertions(+), 604 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
