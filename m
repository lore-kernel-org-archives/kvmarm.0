From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v4 1/3] Fix NULL pointer dereference if KVM is used without
 in-kernel irqchip
Date: Mon, 17 Aug 2015 12:43:38 +0300
Message-ID: <5f02857b6bbb68cef13bdf5a776e0b7ee0c8ccba.1439804074.git.p.fedin@samsung.com>
References: <cover.1439804074.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <cover.1439804074.git.p.fedin@samsung.com>
In-reply-to: <cover.1439804074.git.p.fedin@samsung.com>
References: <cover.1439804074.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
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
index 7a7b26f..fddaa2e 100644
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

