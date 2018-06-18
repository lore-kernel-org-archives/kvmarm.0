From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.16 107/279] KVM: arm/arm64: vgic: fix possible spectre-v1 in vgic_mmio_read_apr()
Date: Mon, 18 Jun 2018 10:11:32 +0200
Message-ID: <20180618080613.251884990@linuxfoundation.org>
References: <20180618080608.851973560@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618080608.851973560@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, Will Deacon <will.deacon@arm.com>, Sasha Levin <alexander.levin@microsoft.com>
List-Id: kvmarm@lists.cs.columbia.edu

4.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 5e1ca5e23b167987d5b6d8b08f2d5b7dd2d13f49 ]

It's possible for userspace to control n. Sanitize n when using it as an
array index.

Note that while it appears that n must be bound to the interval [0,3]
due to the way it is extracted from addr, we cannot guarantee that
compiler transformations (and/or future refactoring) will ensure this is
the case, and given this is a slow path it's better to always perform
the masking.

Found by smatch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -14,6 +14,8 @@
 #include <linux/irqchip/arm-gic.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/nospec.h>
+
 #include <kvm/iodev.h>
 #include <kvm/arm_vgic.h>
 
@@ -324,6 +326,9 @@ static unsigned long vgic_mmio_read_apr(
 
 		if (n > vgic_v3_max_apr_idx(vcpu))
 			return 0;
+
+		n = array_index_nospec(n, 4);
+
 		/* GICv3 only uses ICH_AP1Rn for memory mapped (GICv2) guests */
 		return vgicv3->vgic_ap1r[n];
 	}
