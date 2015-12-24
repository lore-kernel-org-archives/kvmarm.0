From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 01/31] KVM: arm/arm64: vgic: make vgic_io_ops static
Date: Thu, 24 Dec 2015 11:12:09 +0000
Message-ID: <1450955559-15639-2-git-send-email-marc.zyngier@arm.com>
References: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jisheng Zhang <jszhang@marvell.com>, Gleb Natapov <gleb@kernel.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Amit Singh Tomar <amittomer25@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, David Binderman <dcb314@hotmail.com>, Fengguang Wu <fengguang.wu@intel.com>, Mark Rutland <mark.rutland@arm.com>, Pavel Fedin <p.fedin@samsung.com>, Vladimir Murzin <vladimir.murzin@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Jisheng Zhang <jszhang@marvell.com>

vgic_io_ops is only referenced within vgic.c, so it can be declared
static.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 65461f8..0c739a7 100644
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
2.1.4

