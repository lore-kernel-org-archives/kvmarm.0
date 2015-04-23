From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 0/2] irq: add get_gsi callback
Date: Thu, 23 Apr 2015 09:49:35 +0100
Message-ID: <1429778977-1632-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F17BC4E4CF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 04:41:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m4+36c168m+p for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2015 04:41:33 -0400 (EDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
 [209.85.212.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF9DE4E4B9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 04:41:32 -0400 (EDT)
Received: by wizk4 with SMTP id k4so207447709wiz.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 01:49:44 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, alex.williamson@redhat.com, peter.maydell@linaro.org, agraf@suse.de, pbonzini@redhat.com
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This series introduces a new callback function in IRQState, named
get_gsi_cb. It is supposed to be populated by the interrupt controller
and its role is to convert the interrupt controller pin number into
the global system interrupt (gsi) number. The gsi is used when setting
irqfd up.

With PCI there is a PCIINTxRoute bus lookup mechanism that enables to
retrieve the gsi from the PCI host controller/bridge pin. The conversion
is implemented by the PCI host controller. With platform devices, this
conversion function is implemented by the interrupt controller.

Besides the callback member, a setter is introduced. First user is
arm_gic_kvm. A public function wraps the callback, qemu_irq_get_gsi.

The first user of qemu_irq_get_gsi might be the VFIO platform device.
This will come in the "KVM platform device passthrough" series.

Eric Auger (2):
  irq: add get_gsi callback
  intc: arm_gic_kvm: set the get_gsi callback

 hw/core/irq.c         | 20 ++++++++++++++++++++
 hw/intc/arm_gic_kvm.c | 10 ++++++++++
 include/hw/irq.h      |  8 ++++++++
 3 files changed, 38 insertions(+)

-- 
1.8.3.2
