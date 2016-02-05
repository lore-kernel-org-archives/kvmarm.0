From: Wei Huang <wei@redhat.com>
Subject: [PATCH V1 0/7] Enable ACPI support for ARM KVM GIC
Date: Fri,  5 Feb 2016 12:07:27 -0500
Message-ID: <1454692054-8984-1-git-send-email-wei@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, christoffer.dall@linaro.org, kvm@vger.kernel.org, hanjun.guo@linaro.org, fu.wei@linaro.org, drjones@redhat.com, wei@redhat.com, al.stone@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch set enables ACPI support for KVM GIC. Note that the patches
are in fact the V3 of previously submitted patches (search "Enable ACPI
support for KVM ARM"). But because Fu Wei includes the arch_timer part
in his series [1] and I have substantially re-written the GIC code in this
revision, the version number is reset to v1. 

By following Marc's prior comments, the main design idea is to let DT or
ACPI code to fill out the "struct vgic_params" which are extended to
include all GIC related info.

[1] https://lkml.org/lkml/2016/2/1/658

Thanks,
-Wei

Wei Huang (7):
  KVM: GIC: Move GIC DT probing code to GICv2 and GICv3 files
  KVM: GIC: Add extra fields to store GICH and GICV resource info
  KVM: GIC: Create a common probe function for GIC
  KVM: GICv2: Extract the common code from DT
  KVM: GICv2: Add ACPI probing function
  KVM: GICv3: Extract the common code from DT
  KVM: GICv3: Add ACPI probing function

 include/kvm/arm_vgic.h      |  14 ++--
 virt/kvm/arm/vgic-v2-emul.c |   4 +-
 virt/kvm/arm/vgic-v2.c      | 186 +++++++++++++++++++++++++++++++++-----------
 virt/kvm/arm/vgic-v3.c      | 159 ++++++++++++++++++++++++++++---------
 virt/kvm/arm/vgic.c         |  22 +-----
 5 files changed, 277 insertions(+), 108 deletions(-)

-- 
1.8.3.1

