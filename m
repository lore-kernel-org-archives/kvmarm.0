From: Christoffer Dall <cdall@kernel.org>
Subject: [PULL 04/19] KVM: arm/arm64: vgic: Preserve the revious read from the pending table
Date: Mon,  4 Dec 2017 15:03:33 +0100
Message-ID: <20171204140348.21965-2-cdall@kernel.org>
References: <20171204135637.21620-1-cdall@kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171204135637.21620-1-cdall@kernel.org>
Sender: stable-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

The current pending table parsing code assumes that we keep the
previous read of the pending bits, but keep that variable in
the current block, making sure it is discarded on each loop.

We end-up using whatever is on the stack. Who knows, it might
just be the right thing...

Fixes: 280771252c1ba ("KVM: arm64: vgic-v3: KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES")
Cc: <stable@vger.kernel.org> # 4.12
Reported-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-v3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 2f05f732d3fd..f47e8481fa45 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -327,13 +327,13 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 	int last_byte_offset = -1;
 	struct vgic_irq *irq;
 	int ret;
+	u8 val;
 
 	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
 		int byte_offset, bit_nr;
 		struct kvm_vcpu *vcpu;
 		gpa_t pendbase, ptr;
 		bool stored;
-		u8 val;
 
 		vcpu = irq->target_vcpu;
 		if (!vcpu)
-- 
2.14.2
