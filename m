From: Wei Huang <wei@redhat.com>
Subject: [PATCH V1 0/5] Enable ACPI support for KVM ARM
Date: Thu, 28 May 2015 01:34:29 -0400
Message-ID: <1432791274-15242-1-git-send-email-wei@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, hanjun.guo@linaro.org, a.spyridakis@virtualopensystems.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Initial ACPI support for ARM64 has been accepted into Linux kernel recently.
Now it is a good time to re-visit ACPI support for KVM. This patchset
enables ACPI for both arch_timer and vGIC by probing related ACPI tables
and does necessary initialization.

Note that Alexander Spyridaki submitted similar patches before. Some of
his ideas were borrowed in this patchset, but with substancial changes.
In addition we extend support for both GICv2 and GICv3.

This patchset would work better on top of recent GIC/IRQCHIP patches by
Hanjun Guo, who added support for gic_version in ACPI struct of GIC
distributor (search "ACPICA: Introduce GIC version for arm based system").

This patchset can be applied cleanly on top of Linx 4.1-rc1.

Wei Huang (5):
  kvm: arm64: Enable ACPI support for virt arch timer
  kvm: arm64: Dispatch virt GIC probing to device tree and ACPI
  kvm: arm64: Detect GIC version for proper ACPI vGIC probing
  kvm: arm64: Implement ACPI probing code for GICv2
  kvm: arm64: Implement ACPI probing code for GICv3

 include/kvm/arm_vgic.h    |  36 +++++++++---
 virt/kvm/arm/arch_timer.c |  64 ++++++++++++++++-----
 virt/kvm/arm/vgic-v2.c    |  65 +++++++++++++++++++--
 virt/kvm/arm/vgic-v3.c    |  56 +++++++++++++++++--
 virt/kvm/arm/vgic.c       | 140 ++++++++++++++++++++++++++++++++++++++++++----
 5 files changed, 320 insertions(+), 41 deletions(-)

-- 
1.8.3.1

