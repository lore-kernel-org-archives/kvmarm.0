From: <gregkh@linuxfoundation.org>
Subject: Patch "KVM: arm/arm64: vgic: fix possible spectre-v1 in
 vgic_mmio_read_apr()" has been added to the 4.16-stable tree
Date: Sun, 17 Jun 2018 13:23:43 +0200
Message-ID: <1529234623567@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B0C049F93
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Jun 2018 07:32:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WqzdDBNbgNhV for <kvmarm@lists.cs.columbia.edu>;
 Sun, 17 Jun 2018 07:31:50 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CDB8349F8C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Jun 2018 07:31:49 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: alexander.levin@microsoft.com, christoffer.dall@arm.com, gregkh@linuxfoundation.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, mark.rutland@arm.com, will.deacon@arm.com
Cc: stable-commits@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu


This is a note to let you know that I've just added the patch titled

    KVM: arm/arm64: vgic: fix possible spectre-v1 in vgic_mmio_read_apr()

to the 4.16-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     kvm-arm-arm64-vgic-fix-possible-spectre-v1-in-vgic_mmio_read_apr.patch
and it can be found in the queue-4.16 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From foo@baz Sun Jun 17 12:07:33 CEST 2018
From: Mark Rutland <mark.rutland@arm.com>
Date: Wed, 25 Apr 2018 17:13:42 +0100
Subject: KVM: arm/arm64: vgic: fix possible spectre-v1 in vgic_mmio_read_apr()

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 5e1ca5e23b167987d5b6d8b08f2d5b7dd2d13f49 ]

It's possible for userspace to control n. Sanitize n when using it as an
array index.

Note that while it appears that n must be bound to the interval [0,3]
due to the way it is extracted from addr, we cannot guarantee that
compiler transformations (and/or future refactoring) will ensure this is
the case, and given this is a slow path it's better to always perform
the masking.

Found by smatch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -14,6 +14,8 @@
 #include <linux/irqchip/arm-gic.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/nospec.h>
+
 #include <kvm/iodev.h>
 #include <kvm/arm_vgic.h>
 
@@ -324,6 +326,9 @@ static unsigned long vgic_mmio_read_apr(
 
 		if (n > vgic_v3_max_apr_idx(vcpu))
 			return 0;
+
+		n = array_index_nospec(n, 4);
+
 		/* GICv3 only uses ICH_AP1Rn for memory mapped (GICv2) guests */
 		return vgicv3->vgic_ap1r[n];
 	}


Patches currently in stable-queue which might be from mark.rutland@arm.com are

queue-4.16/init-fix-false-positives-in-w-x-checking.patch
queue-4.16/mips-dts-boston-fix-pci-bus-dtc-warnings.patch
queue-4.16/kvm-arm-arm64-vgic-fix-possible-spectre-v1-in-vgic_mmio_read_apr.patch
queue-4.16/arm64-ptrace-remove-addr_limit-manipulation.patch
queue-4.16/bpf-fix-possible-spectre-v1-in-find_and_alloc_map.patch
queue-4.16/bpf-use-array_index_nospec-in-find_prog_type.patch
queue-4.16/arm64-kasan-avoid-pfn_to_nid-before-page-array-is-initialized.patch
queue-4.16/arm64-fix-possible-spectre-v1-in-ptrace_hbp_get_event.patch
queue-4.16/efi-libstub-arm64-handle-randomized-text_offset.patch
queue-4.16/arm64-only-advance-singlestep-for-user-instruction-traps.patch
