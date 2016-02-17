From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] arm/arm64: KVM: vgic: Handle out-of-bound MMIO access
Date: Wed, 17 Feb 2016 15:34:41 +0000
Message-ID: <1455723281-23846-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

When performing a MMIO access via a KVM IO bus, it is possible
that the access will actually be out-of-bounds (the redistributor
handlers do not cover the whole device, for example). In this case,
we return an error code, which leads to escaping to userspace
to handle it. Not that good.

Instead, let's just treat it like any other OOB access, by either
ignoring the write, or by returning a bunch of zeroes.

And let's keep the code quiet while we're at it, as nobody likes
it when a guest can generate zillions on messages on the host's
console...

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 043032c..2358272 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -830,8 +830,11 @@ static int vgic_handle_mmio_access(struct kvm_vcpu *vcpu,
 	offset = addr - iodev->addr;
 	range = vgic_find_range(iodev->reg_ranges, len, offset);
 	if (unlikely(!range || !range->handle_mmio)) {
-		pr_warn("Unhandled access %d %08llx %d\n", is_write, addr, len);
-		return -ENXIO;
+		/* Treat an OOR access as RAZ/WI. */
+		if (!is_write)
+			memset(val, 0, len);
+		pr_debug("Unhandled access %d %08llx %d\n", is_write, addr, len);
+		return 0;
 	}
 
 	mmio.phys_addr = addr;
-- 
2.1.4

