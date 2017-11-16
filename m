From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/7] KVM: arm/arm64: vgic-irqfd: Fix MSI entry allocation
Date: Thu, 16 Nov 2017 17:58:15 +0000
Message-ID: <20171116175821.26544-2-marc.zyngier@arm.com>
References: <20171116175821.26544-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 893CB406D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Nov 2017 12:56:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KDK+ojBO3+L7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Nov 2017 12:56:16 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 612D349D14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Nov 2017 12:56:16 -0500 (EST)
In-Reply-To: <20171116175821.26544-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Using the size of the structure we're allocating is a good idea
and avoids any surprise... In this case, we're happilly confusing
kvm_kernel_irq_routing_entry and kvm_irq_routing_entry...

Fixes: 95b110ab9a09 ("KVM: arm/arm64: Enable irqchip routing")
Cc: stable@vger.kernel.org # 4.8
Reported-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-irqfd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
index b7baf581611a..99e026d2dade 100644
--- a/virt/kvm/arm/vgic/vgic-irqfd.c
+++ b/virt/kvm/arm/vgic/vgic-irqfd.c
@@ -112,8 +112,7 @@ int kvm_vgic_setup_default_irq_routing(struct kvm *kvm)
 	u32 nr = dist->nr_spis;
 	int i, ret;
 
-	entries = kcalloc(nr, sizeof(struct kvm_kernel_irq_routing_entry),
-			  GFP_KERNEL);
+	entries = kcalloc(nr, sizeof(*entries), GFP_KERNEL);
 	if (!entries)
 		return -ENOMEM;
 
-- 
2.14.2
