From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 4/8] arm/arm64: KVM: vgic: Check for !irqchip_in_kernel() when mapping resources
Date: Thu, 17 Sep 2015 15:46:07 +0100
Message-ID: <1442501171-24484-5-git-send-email-marc.zyngier@arm.com>
References: <1442501171-24484-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1442501171-24484-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Pavel Fedin <p.fedin@samsung.com>, Christoffer Dall <christoffer.dall@linaro.org>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Marek Majtyka <marek.majtyka@tieto.com>, Ming Lei <ming.lei@canonical.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Pavel Fedin <p.fedin@samsung.com>

Until b26e5fdac43c ("arm/arm64: KVM: introduce per-VM ops"),
kvm_vgic_map_resources() used to include a check on irqchip_in_kernel(),
and vgic_v2_map_resources() still has it.

But now vm_ops are not initialized until we call kvm_vgic_create().
Therefore kvm_vgic_map_resources() can being called without a VGIC,
and we die because vm_ops.map_resources is NULL.

Fixing this restores QEMU's kernel-irqchip=off option to a working state,
allowing to use GIC emulation in userspace.

Fixes: b26e5fdac43c ("arm/arm64: KVM: introduce per-VM ops")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
[maz: reworked commit message]
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index ce404a5..dc017ad 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -446,7 +446,7 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	 * Map the VGIC hardware resources before running a vcpu the first
 	 * time on this VM.
 	 */
-	if (unlikely(!vgic_ready(kvm))) {
+	if (unlikely(irqchip_in_kernel(kvm) && !vgic_ready(kvm))) {
 		ret = kvm_vgic_map_resources(kvm);
 		if (ret)
 			return ret;
-- 
2.1.4

