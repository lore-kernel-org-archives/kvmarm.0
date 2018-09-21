From: <gregkh@linuxfoundation.org>
Subject: Patch "KVM: arm/arm64: vgic: Fix possible spectre-v1 write in
 vgic_mmio_write_apr()" has been added to the 4.14-stable tree
Date: Fri, 21 Sep 2018 09:53:29 +0200
Message-ID: <1537516409136184@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3E644A242
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Sep 2018 04:02:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fH2qWa3RSoKh for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Sep 2018 04:02:17 -0400 (EDT)
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 16B204A1D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Sep 2018 04:02:17 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: alexander.levin@microsoft.com, christoffer.dall@arm.com, gregkh@linuxfoundation.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, mark.rutland@arm.com
Cc: stable-commits@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu


This is a note to let you know that I've just added the patch titled

    KVM: arm/arm64: vgic: Fix possible spectre-v1 write in vgic_mmio_write_apr()

to the 4.14-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     kvm-arm-arm64-vgic-fix-possible-spectre-v1-write-in-vgic_mmio_write_apr.patch
and it can be found in the queue-4.14 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From foo@baz Fri Sep 21 09:51:45 CEST 2018
From: Mark Rutland <mark.rutland@arm.com>
Date: Tue, 10 Jul 2018 19:01:23 +0100
Subject: KVM: arm/arm64: vgic: Fix possible spectre-v1 write in vgic_mmio_write_apr()

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 6b8b9a48545e08345b8ff77c9fd51b1aebdbefb3 ]

It's possible for userspace to control n. Sanitize n when using it as an
array index, to inhibit the potential spectre-v1 write gadget.

Note that while it appears that n must be bound to the interval [0,3]
due to the way it is extracted from addr, we cannot guarantee that
compiler transformations (and/or future refactoring) will ensure this is
the case, and given this is a slow path it's better to always perform
the masking.

Found by smatch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -348,6 +348,9 @@ static void vgic_mmio_write_apr(struct k
 
 		if (n > vgic_v3_max_apr_idx(vcpu))
 			return;
+
+		n = array_index_nospec(n, 4);
+
 		/* GICv3 only uses ICH_AP1Rn for memory mapped (GICv2) guests */
 		vgicv3->vgic_ap1r[n] = val;
 	}


Patches currently in stable-queue which might be from mark.rutland@arm.com are

queue-4.14/arm64-fix-possible-spectre-v1-write-in-ptrace_hbp_set_event.patch
queue-4.14/kvm-arm-arm64-vgic-fix-possible-spectre-v1-write-in-vgic_mmio_write_apr.patch
