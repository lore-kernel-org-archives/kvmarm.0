From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 33/37] KVM: arm/arm64: vgic: Move DEBUG_SPINLOCK_BUG_ON to
 vgic.h
Date: Mon, 13 Aug 2018 15:57:51 +0100
Message-ID: <20180813145755.16566-34-marc.zyngier@arm.com>
References: <20180813145755.16566-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77D074A22C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 11:00:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gy9KxZhKyWPY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Aug 2018 11:00:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F85F4A216
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 11:00:35 -0400 (EDT)
In-Reply-To: <20180813145755.16566-1-marc.zyngier@arm.com>
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
Cc: Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Andre Przywara <andre.przywara@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Jia He <jia.he@hxt-semitech.com>, Catalin Marinas <catalin.marinas@arm.com>, Jia He <hejianet@gmail.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Jia He <hejianet@gmail.com>

DEBUG_SPINLOCK_BUG_ON can be used with both vgic-v2 and vgic-v3,
so let's move it to vgic.h

Signed-off-by: Jia He <jia.he@hxt-semitech.com>
[maz: commit message tidy-up]
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic.c | 6 ------
 virt/kvm/arm/vgic/vgic.h | 6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 33c8325c8f35..c22cea678a66 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -28,12 +28,6 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
-#ifdef CONFIG_DEBUG_SPINLOCK
-#define DEBUG_SPINLOCK_BUG_ON(p) BUG_ON(p)
-#else
-#define DEBUG_SPINLOCK_BUG_ON(p)
-#endif
-
 struct vgic_global kvm_vgic_global_state __ro_after_init = {
 	.gicv3_cpuif = STATIC_KEY_FALSE_INIT,
 };
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index ed9d9d9e2fc5..a90024718ca4 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -103,6 +103,12 @@
 #define KVM_VGIC_V3_RDIST_COUNT_MASK	GENMASK_ULL(63, 52)
 #define KVM_VGIC_V3_RDIST_COUNT_SHIFT	52
 
+#ifdef CONFIG_DEBUG_SPINLOCK
+#define DEBUG_SPINLOCK_BUG_ON(p) BUG_ON(p)
+#else
+#define DEBUG_SPINLOCK_BUG_ON(p)
+#endif
+
 /* Requires the irq_lock to be held by the caller. */
 static inline bool irq_is_pending(struct vgic_irq *irq)
 {
-- 
2.18.0
