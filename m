From: Christoffer Dall <cdall@kernel.org>
Subject: [PULL 03/19] KVM: arm/arm64: vgic-irqfd: Fix MSI entry allocation
Date: Mon,  4 Dec 2017 15:03:32 +0100
Message-ID: <20171204140348.21965-1-cdall@kernel.org>
References: <20171204135637.21620-1-cdall@kernel.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171204135637.21620-1-cdall@kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

Using the size of the structure we're allocating is a good idea
and avoids any surprise... In this case, we're happilly confusing
kvm_kernel_irq_routing_entry and kvm_irq_routing_entry...

Fixes: 95b110ab9a09 ("KVM: arm/arm64: Enable irqchip routing")
Cc: <stable@vger.kernel.org> # 4.8
Reported-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
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
