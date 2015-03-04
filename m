From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 0/3] explicit VGIC initialization in finalize function
Date: Wed,  4 Mar 2015 14:16:14 +0000
Message-ID: <1425478577-32556-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A770447A11
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 09:10:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DMQbVDiQ05L6 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2015 09:10:48 -0500 (EST)
Received: from mail-we0-f177.google.com (mail-we0-f177.google.com
 [74.125.82.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 59CD7479F6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 09:10:48 -0500 (EST)
Received: by wevl61 with SMTP id l61so9698417wev.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Mar 2015 06:16:50 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, christoffer.dall@linaro.org, qemu-devel@nongnu.org, agraf@suse.de, pbonzini@redhat.com, mst@redhat.com, b.reynal@virtualopensystems.com
Cc: alex.williamson@redhat.com, patches@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

With current implementation the vgic is initialized implicitly,
on-demand. This patch forces the init in the vgic finalize function.
At that point all the dimensioning parameters are known.

A new group/attribute in VGIC KVM device is used for that:
KVM_DEV_ARM_VGIC_GRP_CTRL/KVM_DEV_ARM_VGIC_CTRL_INIT.

Among other things, this earlier VGIC initialization allows to
have a simpler handling of VFIO. VFIO platform signaling can be
setup on reset handler, making sure the VGIC is ready, at that time,
to accept injected virtual IRQs.

Tested on Calxeda Midway with VFIO platform use case

Can be found on
http://git.linaro.org/people/eric.auger/qemu.git,
branch early_vgic_init_v4

v3 -> v4:
- now integrates all the header updates of update-linux-headers.sh applied
  on top of 4.0-rc2 kernel (and not a partial export as in v3).
- VIRTIO_TRANSPORT_F_END value needed to be changed to 33 in
  include/hw/virtio/virtio.h to fix a duplicate definition compilation error
  (also defined in virtio_config.h)
- integrates a new patch file that add export of virtio_types.h, now
  included by virtio_ring.h.

v2 -> v3:
- changed to a patch since the kernel dependency was pulled

v1 -> v2:
- The init is not mandated to be done in a machine init done notifier
  anymore since only the number of vcpus and number of IRQs must be known
  at init time.

Eric Auger (3):
  update-linux-headers.sh: export virtio_types.h
  linux-headers: update to 4.0-rc2
  hw/intc/arm_gic: Initialize the vgic in the realize function

 hw/intc/arm_gic_kvm.c               |  6 +++++
 include/hw/virtio/virtio.h          |  4 +--
 linux-headers/asm-arm/kvm.h         |  2 ++
 linux-headers/asm-arm64/kvm.h       |  9 +++++++
 linux-headers/asm-s390/kvm.h        | 37 ++++++++++++++++++++++++++
 linux-headers/asm-x86/hyperv.h      | 11 ++++++++
 linux-headers/linux/kvm.h           | 20 +++++++-------
 linux-headers/linux/vfio.h          |  1 +
 linux-headers/linux/virtio_config.h | 11 ++++++--
 linux-headers/linux/virtio_ring.h   | 52 +++++++++++++++++++++----------------
 linux-headers/linux/virtio_types.h  | 46 ++++++++++++++++++++++++++++++++
 scripts/update-linux-headers.sh     |  2 +-
 12 files changed, 163 insertions(+), 38 deletions(-)
 create mode 100644 linux-headers/linux/virtio_types.h

-- 
1.8.3.2
