From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH 0/5] Clarify GICC_PMR export format and remove struct vmcr
Date: Tue, 21 Mar 2017 12:05:25 +0100
Message-ID: <20170321110530.15857-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E966C40C2F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 07:03:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bc5FIjPcDB6m for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 07:03:48 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 59B7440BDA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 07:03:48 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id v203so2144492wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 04:05:34 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Vijaya.Kumar@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch series addresses two issues with the way we export the GIC
CPU interface registers to userspace.

First, we clarify that the ABI is slightly broken and misleading, in
that we export the GICC_PMR using an invented format where we put the
GICH_VMCR.VMPriMask field in the lower five bits of the GICC_PMR
exported to userspace.

Second, since we don't have any non-version-specific users of the struct
vmcr representation, we don't have any clear benefit of using this
indirection inside the kernel, and this has already led to confusion.
Instead, slightly rework some of the user access functions and get rid
of the VMCR structure entirely, which results in a rather nice diffstat
considering I've added quite a few lines of comments.

Based on v4.11-rc1.

Thanks,
-Christoffer

Christoffer Dall (5):
  KVM: arm/arm64: Clarify GICC_PMR export format
  KVM: arm64: vgic: Factor out access_gic_ctlr into separate r/w
    functions
  KVM: arm64: vgic: Rename vgic_v3_cpu to vgic_cpu
  KVM: arm64: vgic: Get rid of struct vmcr for GICv3
  KVM: arm/arm64: vgic: Get rid of struct vmcr for GICv2

 Documentation/virtual/kvm/devices/arm-vgic.txt |   6 +
 arch/arm64/kvm/vgic-sys-reg-v3.c               | 239 ++++++++++++-------------
 virt/kvm/arm/vgic/vgic-mmio-v2.c               |  51 ++++--
 virt/kvm/arm/vgic/vgic-mmio.c                  |  16 --
 virt/kvm/arm/vgic/vgic-v2.c                    |  29 ---
 virt/kvm/arm/vgic/vgic-v3.c                    |  38 ----
 virt/kvm/arm/vgic/vgic.h                       |  16 --
 7 files changed, 155 insertions(+), 240 deletions(-)

-- 
2.9.0
