From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 0/6] arm64: mmu: avoid W+X mappings and re-enable PTE_CONT
 for kernel
Date: Sat,  4 Mar 2017 14:30:42 +0000
Message-ID: <1488637848-13588-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7017540064
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Mar 2017 09:30:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N9gRvQ7PEOwu for <kvmarm@lists.cs.columbia.edu>;
 Sat,  4 Mar 2017 09:30:03 -0500 (EST)
Received: from mail-wr0-f177.google.com (mail-wr0-f177.google.com
 [209.85.128.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC7D440B3E
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Mar 2017 09:30:02 -0500 (EST)
Received: by mail-wr0-f177.google.com with SMTP id l37so90346067wrc.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 04 Mar 2017 06:31:19 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, labbott@fedoraproject.org
Cc: keescook@chromium.org, marc.zyngier@arm.com, andre.przywara@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Having memory that is writable and executable at the same time is a
security hazard, and so we tend to avoid those when we can. However,
at boot time, we keep .text mapped writable during the entire init
phase, and the init region itself is mapped rwx as well.

Let's improve the situation by:
- making the alternatives patching use the linear mapping
- splitting the init region into separate text and data regions

This removes all RWX mappings except the really early one created
in head.S (which we could perhaps fix in the future as well)

Changes since v3:
- use linear alias only when patching the core kernel, and not for modules
- add patch to reintroduce the use of PTE_CONT for kernel mappings, except
  for regions that are remapped read-only later on (i.e, .rodata and the
  linear alias of .text+.rodata)

Changes since v2:
  - ensure that text mappings remain writable under rodata=off
  - rename create_mapping_late() to update_mapping_prot()
  - clarify commit log of #2
  - add acks

Changes since v1:
- add patch to move TLB maintenance into create_mapping_late() and remove it
  from its callers (#2)
- use the true address not the linear alias when patching branch instructions,
  spotted by Suzuki (#3)
- mark mark_linear_text_alias_ro() __init (#3)
- move the .rela section back into __initdata: as it turns out, leaving a hole
  between the segments results in a peculiar situation where other unrelated
  allocations end up right in the middle of the kernel Image, which is
  probably a bad idea (#5). See below for an example.
- add acks


Ard Biesheuvel (6):
  arm: kvm: move kvm_vgic_global_state out of .text section
  arm64: mmu: move TLB maintenance from callers to create_mapping_late()
  arm64: alternatives: apply boot time fixups via the linear mapping
  arm64: mmu: map .text as read-only from the outset
  arm64: mmu: apply strict permissions to .init.text and .init.data
  arm64: mm: set the contiguous bit for kernel mappings where
    appropriate

 arch/arm64/include/asm/mmu.h      |   1 +
 arch/arm64/include/asm/sections.h |   3 +-
 arch/arm64/kernel/alternative.c   |  11 +-
 arch/arm64/kernel/smp.c           |   1 +
 arch/arm64/kernel/vmlinux.lds.S   |  25 ++--
 arch/arm64/mm/mmu.c               | 139 ++++++++++++++------
 virt/kvm/arm/vgic/vgic.c          |   4 +-
 7 files changed, 129 insertions(+), 55 deletions(-)

-- 
2.7.4
