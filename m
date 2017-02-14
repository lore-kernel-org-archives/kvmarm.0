From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 0/5] arm64: mmu: avoid writeable-executable mappings
Date: Tue, 14 Feb 2017 20:52:33 +0000
Message-ID: <1487105558-21897-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECAF440992
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 15:54:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bEXOSf8MDvmh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Feb 2017 15:54:02 -0500 (EST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 77F9C40296
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 15:54:01 -0500 (EST)
Received: by mail-wm0-f50.google.com with SMTP id v77so26689416wmv.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Feb 2017 12:54:46 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, labbott@fedoraproject.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, keescook@chromium.org, marc.zyngier@arm.com, andre.przywara@arm.com, kernel-hardening@lists.openwall.com, kvmarm@lists.cs.columbia.edu
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

Ard Biesheuvel (5):
  arm: kvm: move kvm_vgic_global_state out of .text section
  arm64: mmu: move TLB maintenance from callers to create_mapping_late()
  arm64: alternatives: apply boot time fixups via the linear mapping
  arm64: mmu: map .text as read-only from the outset
  arm64: mmu: apply strict permissions to .init.text and .init.data

 arch/arm64/include/asm/mmu.h      |  1 +
 arch/arm64/include/asm/sections.h |  3 +-
 arch/arm64/kernel/alternative.c   |  2 +-
 arch/arm64/kernel/smp.c           |  1 +
 arch/arm64/kernel/vmlinux.lds.S   | 25 +++++---
 arch/arm64/mm/mmu.c               | 61 +++++++++++++-------
 virt/kvm/arm/vgic/vgic.c          |  4 +-
 7 files changed, 65 insertions(+), 32 deletions(-)

-- 
2.7.4
