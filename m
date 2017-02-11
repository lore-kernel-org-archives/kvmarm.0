From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 0/5] arm64: mmu: avoid writeable-executable mappings
Date: Sat, 11 Feb 2017 20:23:01 +0000
Message-ID: <1486844586-26135-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A96B740A74
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Feb 2017 15:23:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a0vqvGY1FSQs for <kvmarm@lists.cs.columbia.edu>;
 Sat, 11 Feb 2017 15:23:11 -0500 (EST)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D78840A69
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Feb 2017 15:23:11 -0500 (EST)
Received: by mail-wm0-f44.google.com with SMTP id c85so283781684wmi.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 11 Feb 2017 12:23:50 -0800 (PST)
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
 arch/arm64/kernel/vmlinux.lds.S   | 25 +++++++----
 arch/arm64/mm/mmu.c               | 45 +++++++++++++-------
 virt/kvm/arm/vgic/vgic.c          |  4 +-
 7 files changed, 53 insertions(+), 28 deletions(-)

-- 
2.7.4

The various kernel segments are vmapped from paging_init() [after inlining]

0xffffff8008080000-0xffffff80088b0000 8585216 paging_init+0x84/0x584 phys=40080000 vmap
0xffffff80088b0000-0xffffff8008cb0000 4194304 paging_init+0xa4/0x584 phys=408b0000 vmap
0xffffff8008cb0000-0xffffff8008d27000  487424 paging_init+0xc4/0x584 phys=40cb0000 vmap
0xffffff8008d27000-0xffffff8008da3000  507904 paging_init+0xe8/0x584 phys=40d27000 vmap
0xffffff8008dd1000-0xffffff8008dd3000    8192 devm_ioremap_nocache+0x54/0xa8 phys=a003000 ioremap
0xffffff8008dd3000-0xffffff8008dd5000    8192 devm_ioremap_nocache+0x54/0xa8 phys=a003000 ioremap
0xffffff8008dde000-0xffffff8008de0000    8192 pl031_probe+0x80/0x1e8 phys=9010000 ioremap
0xffffff8008e4c000-0xffffff8008e50000   16384 n_tty_open+0x1c/0xd0 pages=3 vmalloc
0xffffff8008e54000-0xffffff8008e58000   16384 n_tty_open+0x1c/0xd0 pages=3 vmalloc
0xffffff8008e80000-0xffffff8008e84000   16384 n_tty_open+0x1c/0xd0 pages=3 vmalloc
0xffffff8008e84000-0xffffff8008e88000   16384 n_tty_open+0x1c/0xd0 pages=3 vmalloc
0xffffff8008ea0000-0xffffff8008ea2000    8192 bpf_prog_alloc+0x3c/0xb8 pages=1 vmalloc
0xffffff8008ef2000-0xffffff8008ef6000   16384 n_tty_open+0x1c/0xd0 pages=3 vmalloc
0xffffff8008ef6000-0xffffff8008efa000   16384 n_tty_open+0x1c/0xd0 pages=3 vmalloc
0xffffff8009010000-0xffffff800914b000 1290240 paging_init+0x10c/0x584 phys=41010000 vmap
