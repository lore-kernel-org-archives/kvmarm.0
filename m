From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v3 1/3] Fix NULL pointer dereference if KVM is used without
 in-kernel irqchip
Date: Wed, 05 Aug 2015 13:53:57 +0300
Message-ID: <34464c9cb7c603a22bb6849b78575ee286368936.1438770954.git.p.fedin@samsung.com>
References: <cover.1438770954.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C4895A0CA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2015 06:41:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dqVL8sTeTMC2 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2015 06:41:22 -0400 (EDT)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D806A5A0CF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2015 06:41:22 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NSL002X7VM8A910@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 05 Aug 2015 11:54:08 +0100 (BST)
In-reply-to: <cover.1438770954.git.p.fedin@samsung.com>
In-reply-to: <cover.1438770954.git.p.fedin@samsung.com>
References: <cover.1438770954.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Makes qemu working again with kernel-irqchip=off option, allowing to use
GIC emulation in userspace.

Previously kvm_vgic_map_resources() used to include irqchip_in_kernel()
check, and vgic_v2_map_resources() still has it, but now vm_ops are not
initialized before kvm_vgic_create(). Therefore kvm_vgic_map_resources()
call without vGIC instantiation attempts to call
vm_ops.map_resources == NULL

The bug was introduced in b26e5fdac43c1b7c394502917e42e3b91f3aa1a3

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 arch/arm/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 483b5d1..199a50a 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -449,7 +449,7 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	 * Map the VGIC hardware resources before running a vcpu the first
 	 * time on this VM.
 	 */
-	if (unlikely(!vgic_ready(kvm))) {
+	if (unlikely(irqchip_in_kernel(kvm) && !vgic_ready(kvm))) {
 		ret = kvm_vgic_map_resources(kvm);
 		if (ret)
 			return ret;
-- 
2.4.4
