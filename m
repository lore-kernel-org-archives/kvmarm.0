From: Christoffer Dall <cdall@kernel.org>
Subject: [PULL 05/19] KVM: arm/arm64: vgic-its: Preserve the revious read from the pending table
Date: Mon,  4 Dec 2017 15:03:34 +0100
Message-ID: <20171204140348.21965-3-cdall@kernel.org>
References: <20171204135637.21620-1-cdall@kernel.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171204135637.21620-1-cdall@kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

The current pending table parsing code assumes that we keep the
previous read of the pending bits, but keep that variable in
the current block, making sure it is discarded on each loop.

We end-up using whatever is on the stack. Who knows, it might
just be the right thing...

Fixes: 33d3bc9556a7d ("KVM: arm64: vgic-its: Read initial LPI pending table")
Cc: <stable@vger.kernel.org> # 4.8
Reported-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 1f761a9991e7..cb2d0a2dbe5a 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -421,6 +421,7 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 	u32 *intids;
 	int nr_irqs, i;
 	unsigned long flags;
+	u8 pendmask;
 
 	nr_irqs = vgic_copy_lpi_list(vcpu, &intids);
 	if (nr_irqs < 0)
@@ -428,7 +429,6 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < nr_irqs; i++) {
 		int byte_offset, bit_nr;
-		u8 pendmask;
 
 		byte_offset = intids[i] / BITS_PER_BYTE;
 		bit_nr = intids[i] % BITS_PER_BYTE;
-- 
2.14.2
