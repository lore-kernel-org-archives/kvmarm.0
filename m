From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v2 1/3] KVM: arm: Fix NULL pointer dereference if KVM is used
 without in-kernel irqchip
Date: Tue, 14 Jul 2015 15:06:03 +0300
Message-ID: <644bce2849b89bc8520c7efcb7752c92e31f9ccd.1436874248.git.p.fedin@samsung.com>
References: <cover.1436874248.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <cover.1436874248.git.p.fedin@samsung.com>
In-reply-to: <cover.1436874248.git.p.fedin@samsung.com>
References: <cover.1436874248.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Makes qemu working again with kernel-irqchip=off option

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 arch/arm/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index d9631ec..5668c4e 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -450,7 +450,7 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	 * Map the VGIC hardware resources before running a vcpu the first
 	 * time on this VM.
 	 */
-	if (unlikely(!vgic_ready(kvm))) {
+	if (irqchip_in_kernel(kvm) && unlikely(!vgic_ready(kvm))) {
 		ret = kvm_vgic_map_resources(kvm);
 		if (ret)
 			return ret;
-- 
2.4.4

