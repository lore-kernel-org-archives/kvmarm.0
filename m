From: Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH] KVM: arm/arm64: vgic: make vgic_io_ops static
Date: Thu, 12 Nov 2015 19:59:14 +0800
Message-ID: <1447329554-1500-1-git-send-email-jszhang@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, gleb@kernel.org, pbonzini@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Jisheng Zhang <jszhang@marvell.com>
List-Id: kvmarm@lists.cs.columbia.edu

vgic_io_ops is only referenced within vgic.c, so it can be declared
static.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 virt/kvm/arm/vgic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 5335383..8ef7279 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -878,7 +878,7 @@ static int vgic_handle_mmio_write(struct kvm_vcpu *vcpu,
 				       true);
 }
 
-struct kvm_io_device_ops vgic_io_ops = {
+static struct kvm_io_device_ops vgic_io_ops = {
 	.read	= vgic_handle_mmio_read,
 	.write	= vgic_handle_mmio_write,
 };
-- 
2.6.2
