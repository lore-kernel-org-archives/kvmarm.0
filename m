From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v2 0/2] add qemu_irq/gsi hashtable
Date: Thu, 23 Apr 2015 16:08:34 +0100
Message-ID: <1429801716-8027-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A75164E57F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 11:00:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sLpkbckUoVvv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2015 11:00:33 -0400 (EDT)
Received: from mail-wg0-f54.google.com (mail-wg0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BFE914E573
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 11:00:33 -0400 (EDT)
Received: by wgso17 with SMTP id o17so21709699wgs.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 08:08:46 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, peter.maydell@linaro.org, agraf@suse.de, pbonzini@redhat.com
Cc: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

The VFIO platform needs to setup irqfd but it does not know the gsi associated
to the sysbus device qemu_irq.

With PCI there is a PCIINTxRoute bus lookup mechanism that enables to
retrieve the gsi from the PCI host controller/bridge pin. The conversion
is implemented by the PCI host controller. With platform devices, this
conversion function is implemented by the interrupt controller.

This series implements a hash table in kvm-all that stores the mapping
between qemu_irq and gsi. A setter is introduced for the interrupt controller
to insert mappings. Also functions are added to setup/tear down irqfd directly
from a qemu_irq. Those functions now can be used by the VFIO platform device
to setup VFIO signaling.

v1 -> v2:
- series renamed from "irq: add get_gsi callback"
- follow implementation suggested by Paolo (hope I fully understood it)

Eric Auger (2):
  kvm-all.c: add qemu_irq/gsi hash table and utility routines
  intc: arm_gic_kvm: set the qemu_irq/gsi mapping

 hw/intc/arm_gic_kvm.c |  5 +++++
 include/sysemu/kvm.h  |  6 ++++++
 kvm-all.c             | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+)

-- 
1.8.3.2
