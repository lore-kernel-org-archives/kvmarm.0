From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH 01/45] KVM: arm/arm64: add missing MMIO data write-back
Date: Fri, 25 Mar 2016 02:04:24 +0000
Message-ID: <1458871508-17279-2-git-send-email-andre.przywara@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

When the kernel was handling a guest MMIO access internally, we need
to copy the emulation result into the run->mmio structure in order
for the kvm_handle_mmio_return() function to pick it up and inject
the result back into the guest.
Currently the only user of kvm_io_bus for ARM is the VGIC, which did
this copying itself, so this was not causing issues so far.
But with upcoming kvm_io_bus users we need to do the copying here.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm/kvm/mmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
index 0f6600f..d5c2727 100644
--- a/arch/arm/kvm/mmio.c
+++ b/arch/arm/kvm/mmio.c
@@ -206,7 +206,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	run->mmio.is_write	= is_write;
 	run->mmio.phys_addr	= fault_ipa;
 	run->mmio.len		= len;
-	if (is_write)
+	if (is_write || !ret)
 		memcpy(run->mmio.data, data_buf, len);
 
 	if (!ret) {
-- 
2.7.3

