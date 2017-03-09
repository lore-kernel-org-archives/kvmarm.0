From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 00/10] arm64: mmu: avoid W+X mappings and re-enable
 PTE_CONT for kernel
Date: Thu,  9 Mar 2017 09:25:02 +0100
Message-ID: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0746B40B5B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 03:24:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8EWU0lGG-wFg for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 03:23:59 -0500 (EST)
Received: from mail-wr0-f171.google.com (mail-wr0-f171.google.com
 [209.85.128.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 564E740A95
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 03:23:59 -0500 (EST)
Received: by mail-wr0-f171.google.com with SMTP id u48so39711009wrc.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Mar 2017 00:25:24 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, keescook@chromium.org, labbott@fedoraproject.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, marc.zyngier@arm.com, catalin.marinas@arm.com, kernel-hardening@lists.openwall.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu
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

Changes since v4:
- the PTE_CONT patch has now spawned four more preparatory patches that clean
  up some of the page table creation code before reintroducing the contiguous
  attribute management
- add Mark's R-b to #4 and #5

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

Ard Biesheuvel (10):
  arm: kvm: move kvm_vgic_global_state out of .text section
  arm64: mmu: move TLB maintenance from callers to create_mapping_late()
  arm64: alternatives: apply boot time fixups via the linear mapping
  arm64: mmu: map .text as read-only from the outset
  arm64: mmu: apply strict permissions to .init.text and .init.data
  arm64/mmu: align alloc_init_pte prototype with pmd/pud versions
  arm64/mmu: ignore debug_pagealloc for kernel segments
  arm64/mmu: add contiguous bit to sanity bug check
  arm64/mmu: replace 'page_mappings_only' parameter with flags argument
  arm64: mm: set the contiguous bit for kernel mappings where
    appropriate

 arch/arm64/include/asm/mmu.h      |   1 +
 arch/arm64/include/asm/pgtable.h  |  10 +
 arch/arm64/include/asm/sections.h |   2 +
 arch/arm64/kernel/alternative.c   |  11 +-
 arch/arm64/kernel/smp.c           |   1 +
 arch/arm64/kernel/vmlinux.lds.S   |  25 +-
 arch/arm64/mm/mmu.c               | 250 ++++++++++++++------
 virt/kvm/arm/vgic/vgic.c          |   4 +-
 8 files changed, 212 insertions(+), 92 deletions(-)

-- 
2.7.4
