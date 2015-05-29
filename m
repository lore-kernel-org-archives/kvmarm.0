From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 0/4] Add support for for GICv2m and MSIs to arm-virt
Date: Fri, 29 May 2015 13:01:06 +0200
Message-ID: <1432897270-7780-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 633555247E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2015 06:50:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XyUxOSEDBDk4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 May 2015 06:50:56 -0400 (EDT)
Received: from mail-lb0-f177.google.com (mail-lb0-f177.google.com
 [209.85.217.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1EDD95236A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2015 06:50:55 -0400 (EDT)
Received: by lbcmx3 with SMTP id mx3so46021396lbc.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2015 04:00:42 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-devel@nongnu.org
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Now when we have a host generic PCIe controller in the virt board, it
would be nice to be able to use MSIs so that we can eventually enable
VHOST with KVM.

With these patches you can use MSIs with TCG and with KVM, but you still
need some fixes for the mapping of the IRQ index to the GSI number for
IRQFD to work.  A separate series that enables IRQFD and vhost
is available: "ARM adaptations for vhost irqfd setup"
https://lists.gnu.org/archive/html/qemu-devel/2015-04/msg01054.html)

Tested with KVM on XGene and with TCG by configuring a virtio-pci
network adapter for the guest and verifying MSIs going through as
expected.

Rebased on target-arm.next, see the individual patches for detailed
changelogs.

Christoffer Dall (4):
  target-arm: Add GIC phandle to VirtBoardInfo
  arm_gicv2m: Add GICv2m widget to support MSIs
  target-arm: Extend the gic node properties
  target-arm: Add the GICv2m to the virt board

 hw/arm/virt.c         |  73 ++++++++++++++-----
 hw/intc/Makefile.objs |   1 +
 hw/intc/arm_gicv2m.c  | 190 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/hw/arm/virt.h |   2 +
 4 files changed, 248 insertions(+), 18 deletions(-)
 create mode 100644 hw/intc/arm_gicv2m.c

-- 
2.1.2.330.g565301e.dirty
