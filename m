From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 0/4] VFIO Platform device featuring IRQ forwarding
Date: Mon,  4 May 2015 13:49:54 +0100
Message-ID: <1430743798-8839-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 467B24F789
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2015 08:41:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aZF4oagtdQRS for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 May 2015 08:41:24 -0400 (EDT)
Received: from mail-wi0-f170.google.com (mail-wi0-f170.google.com
 [209.85.212.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 460FF4F781
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2015 08:41:23 -0400 (EDT)
Received: by wief7 with SMTP id f7so76796662wie.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 May 2015 05:50:05 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, alex.williamson@redhat.com
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This series adds IRQ forwarding support in the VFIO platform device.

The VFIO platform device uses the KVM-VFIO device to enable IRQ forwarding.

Dependency List:
- QEMU KVM platform device passthrough and its dependencies
  see https://lists.gnu.org/archive/html/qemu-devel/2015-04/msg04379.html
- kernel forwarding series:
  see (https://www.mail-archive.com/kvm@vger.kernel.org/msg115253.html)

Repos:
- QEMU pieces can be found at:
  http://git.linaro.org/people/eric.auger/qemu.git
  (branch vfio_integ_v15_fwd)
- kernel pieces can be found at:
  http://git.linaro.org/people/eric.auger/linux.git
  (branch 4.1-rc1_forward)

The patch series was tested on Calxeda Midway (ARMv7) where one xgmac
is assigned to KVM host while the second one is assigned to the guest.
Reworked PCI device is not tested.

Wiki for Calxeda Midway setup:
https://wiki.linaro.org/LEG/Engineering/Virtualization/Platform_Device_Passthrough_on_Midway

History:

v1 -> v2:
- update following
  x introduction of kvm qemu_irq/gsi hash table
  x new irq connect notifier
  x 2 stage eventfd/irqfd setup which complexifies irq forwarding setup

v1:
- that code originally was in KVM platform device passthrough series (v8),
  now moved in a separate RFC since dependent on many RFCs.

Best Regards

Eric


Eric Auger (4):
  linux-headers: Update KVM header for KVM-VFIO FORWARD/UNFORWARD
  hw/vfio/common: vfio_kvm_device_fd moved in the common header
  kvm: add kvm_vfio_get_device_irq
  hw/vfio/platform: add forwarded irq support

 hw/vfio/common.c                |   2 +-
 hw/vfio/platform.c              | 103 +++++++++++++++++++++++++++++++++++++---
 include/hw/vfio/vfio-common.h   |   4 ++
 include/hw/vfio/vfio-platform.h |   3 ++
 include/sysemu/kvm.h            |   5 ++
 kvm-all.c                       |  32 +++++++++++++
 linux-headers/linux/kvm.h       |  12 +++++
 trace-events                    |   1 +
 8 files changed, 154 insertions(+), 8 deletions(-)

-- 
1.8.3.2
