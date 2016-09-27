From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 41/50] KVM: arm: vgic: Fix compiler warnings when built for
 32-bit
Date: Tue, 27 Sep 2016 20:05:49 +0200
Message-ID: <20160927180558.14699-42-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A97B49B85
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1fQbCr5FGcnt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:57:08 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2768149BD7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:04 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id l132so26961204wmf.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:27 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Vladimir Murzin <vladimir.murzin@arm.com>

Well, this patch is looking ahead of time, but we'll get following
compiler warnings as soon as we introduce vgic-v3 to 32-bit world

  CC      arch/arm/kvm/../../../virt/kvm/arm/vgic/vgic-mmio-v3.o
arch/arm/kvm/../../../virt/kvm/arm/vgic/vgic-mmio-v3.c: In function 'vgic_mmio_read_v3r_typer':
arch/arm/kvm/../../../virt/kvm/arm/vgic/vgic-mmio-v3.c:184:35: warning: left shift count >= width of type [-Wshift-count-overflow]
  value = (mpidr & GENMASK(23, 0)) << 32;
                                   ^
In file included from ./include/linux/kernel.h:10:0,
                 from ./include/asm-generic/bug.h:13,
                 from ./arch/arm/include/asm/bug.h:59,
                 from ./include/linux/bug.h:4,
                 from ./include/linux/io.h:23,
                 from ./arch/arm/include/asm/arch_gicv3.h:23,
                 from ./include/linux/irqchip/arm-gic-v3.h:411,
                 from arch/arm/kvm/../../../virt/kvm/arm/vgic/vgic-mmio-v3.c:14:
arch/arm/kvm/../../../virt/kvm/arm/vgic/vgic-mmio-v3.c: In function 'vgic_v3_dispatch_sgi':
./include/linux/bitops.h:6:24: warning: left shift count >= width of type [-Wshift-count-overflow]
 #define BIT(nr)   (1UL << (nr))
                        ^
arch/arm/kvm/../../../virt/kvm/arm/vgic/vgic-mmio-v3.c:614:20: note: in expansion of macro 'BIT'
  broadcast = reg & BIT(ICC_SGI1R_IRQ_ROUTING_MODE_BIT);
                    ^
Let's fix them now.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index acbe691..6385ed5 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -181,7 +181,7 @@ static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
 	int target_vcpu_id = vcpu->vcpu_id;
 	u64 value;
 
-	value = (mpidr & GENMASK(23, 0)) << 32;
+	value = (u64)(mpidr & GENMASK(23, 0)) << 32;
 	value |= ((target_vcpu_id & 0xffff) << 8);
 	if (target_vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1)
 		value |= GICR_TYPER_LAST;
@@ -611,7 +611,7 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
 	bool broadcast;
 
 	sgi = (reg & ICC_SGI1R_SGI_ID_MASK) >> ICC_SGI1R_SGI_ID_SHIFT;
-	broadcast = reg & BIT(ICC_SGI1R_IRQ_ROUTING_MODE_BIT);
+	broadcast = reg & BIT_ULL(ICC_SGI1R_IRQ_ROUTING_MODE_BIT);
 	target_cpus = (reg & ICC_SGI1R_TARGET_LIST_MASK) >> ICC_SGI1R_TARGET_LIST_SHIFT;
 	mpidr = SGI_AFFINITY_LEVEL(reg, 3);
 	mpidr |= SGI_AFFINITY_LEVEL(reg, 2);
-- 
2.9.0
