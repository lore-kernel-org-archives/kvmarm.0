From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 00/12] KVM: arm/arm64: Allow multiple GICv3 redistributor regions
Date: Mon, 19 Mar 2018 10:20:08 +0100
Message-ID: <1521451220-27754-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DC2F49FA9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Mar 2018 05:13:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wfkvlN0Ac975 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Mar 2018 05:12:46 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4DE0049DAB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Mar 2018 05:12:46 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org
Cc: andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

At the moment the KVM VGICv3 only supports a single redistributor
region (whose base address is set through the GICv3 kvm device
KVM_DEV_ARM_VGIC_GRP_ADDR/KVM_VGIC_V3_ADDR_TYPE_REDIST). There,
all the redistributors are laid out contiguously. The size of this
single redistributor region is not set explicitly but instead
induced at a late stage by the number of online vcpus.

The GIC specification does not mandate all redistributors to be
contiguous. Moreover DT and ACPI were specified so that multiple
redistributors regions can be defined.

The current interface brings a limitation on QEMU where ARM
virt machine available GPA holes only allowed to assign a
redistributor region fitting a max of 123 vcpus. Overcoming this
limitation would force either to create a new machine or relocate
the single rdist region or allow the allocation of multiple rdist
regions.

This series enables this last alternative. A new GICv3 KVM device
KVM_DEV_ARM_VGIC_GRP_ADDR/KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION allows
to register individual redistributor regions whose size is defined
explicitly. Those rdist regions then are filled by vcpu rdist frames
according to the need. The vgic init and related base address checks
are impacted.

Best Regards

Eric

Git: complete series available at
https://github.com/eauger/linux/tree/v4.16-rc5-rdist-regions-rfc

* Testing:
- With QEMU, splitting the single rdist region into 2 seperate ones.
- Work in progress to allow clean support of more than 123 vcpus.

Eric Auger (12):
  KVM: arm/arm64: Avoid multiple dist->spis kfree
  KVM: arm/arm64: Document KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
  KVM: arm/arm64: Record RDIST Last bit at registration
  KVM: arm/arm64: Replace the single rdist region by a list
  KVM: arm/arm64: Helper to locate free rdist space
  KVM: arm/arm64: Helper to detect whether an RDIST is the last one
  KVM: arm/arm64: Helper to register a new redistributor region
  KVM: arm/arm64: Adapt vgic_v3_check_base to multiple rdist regions
  KVM: arm/arm64: Check vcpu redist base before registering an iodev
  KVM: arm/arm64: Check all vcpu redistributors are set on map_resources
  KVM: arm/arm64: Add KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
  KVM: arm/arm64: Implement KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION

 Documentation/virtual/kvm/devices/arm-vgic-v3.txt |  12 +++
 arch/arm/include/uapi/asm/kvm.h                   |   7 +-
 arch/arm64/include/uapi/asm/kvm.h                 |   7 +-
 include/kvm/arm_vgic.h                            |  14 ++-
 virt/kvm/arm/vgic/vgic-init.c                     |  25 ++++-
 virt/kvm/arm/vgic/vgic-kvm-device.c               |  47 ++++++++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c                  | 111 +++++++++++++++++++---
 virt/kvm/arm/vgic/vgic-v3.c                       |  89 +++++++++++++----
 virt/kvm/arm/vgic/vgic.h                          |  42 +++++++-
 9 files changed, 307 insertions(+), 47 deletions(-)

-- 
2.5.5
