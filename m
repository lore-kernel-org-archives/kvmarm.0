From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 071/189] KVM: arm/arm64: vgic: fix possible spectre-v1 in
 vgic_mmio_read_apr()
Date: Mon, 18 Jun 2018 10:12:47 +0200
Message-ID: <20180618081212.145698964@linuxfoundation.org>
References: <20180618081209.254234434@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D58349FA8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 04:20:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1TqFtie5wjRU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jun 2018 04:20:32 -0400 (EDT)
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9333440192
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 04:20:32 -0400 (EDT)
In-Reply-To: <20180618081209.254234434@linuxfoundation.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Will Deacon <will.deacon@arm.com>, stable@vger.kernel.org, Sasha Levin <alexander.levin@microsoft.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

4.14-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -320,6 +322,9 @@ static unsigned long vgic_mmio_read_apr(
 
 		if (n > vgic_v3_max_apr_idx(vcpu))
 			return 0;
+
+		n = array_index_nospec(n, 4);
+
 		/* GICv3 only uses ICH_AP1Rn for memory mapped (GICv2) guests */
 		return vgicv3->vgic_ap1r[n];
 	}
