From: Wei Huang <wei@redhat.com>
Subject: [PATCH V2 0/5]  Enable ACPI support for KVM ARM
Date: Wed, 10 Jun 2015 00:16:02 -0400
Message-ID: <1433909767-12189-1-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC21C54081
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2015 00:06:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tNuaK2aNICdC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2015 00:06:27 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A6AB75400E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2015 00:06:27 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, hanjun.guo@linaro.org, pbonzini@redhat.com
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

This patchset can be applied cleanly on top of kvmarm.git queue branch.

-Wei

V1->V2:
* Initialize vgic->max_gic_vcpus field in GICv2 code (found by Andrew Jones)
* Rewrite arch_timer ACPI PPI parsing code
* Verified patches on APM Mustang machine, which has arch_timer & GICv2

V1:
* Initial patchset

Wei Huang (5):
  kvm: arm64: Enable ACPI support for virt arch timer
  kvm: arm64: Dispatch virt GIC probing to device tree and ACPI
  kvm: arm64: Detect GIC version for proper ACPI vGIC probing
  kvm: arm64: Implement ACPI probing code for GICv2
  kvm: arm64: Implement ACPI probing code for GICv3

 include/kvm/arm_vgic.h    |  36 +++++++++---
 virt/kvm/arm/arch_timer.c |  75 ++++++++++++++++++++-----
 virt/kvm/arm/vgic-v2.c    |  66 ++++++++++++++++++++--
 virt/kvm/arm/vgic-v3.c    |  56 +++++++++++++++++--
 virt/kvm/arm/vgic.c       | 140 ++++++++++++++++++++++++++++++++++++++++++----
 5 files changed, 332 insertions(+), 41 deletions(-)

-- 
1.8.3.1
