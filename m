From: James Morse <james.morse@arm.com>
Subject: [PATCH v2] arm64: vgic-v2: Fix proxying of cpuif access
Date: Fri,  4 May 2018 16:19:24 +0100
Message-ID: <20180504151924.13696-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0691749FA9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 May 2018 11:13:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fR9X5AueVxFJ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 May 2018 11:12:37 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4371B49EA2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 May 2018 11:12:37 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Proxying the cpuif accesses at EL2 makes use of vcpu_data_guest_to_host
and co, which check the endianness, which call into vcpu_read_sys_reg...
which isn't mapped at EL2 (it was inlined before, and got moved OoL
with the VHE optimizations).

The result is of course a nice panic. Let's add some specialized
cruft to keep the broken platforms that require this hack alive.

But, this code used vcpu_data_guest_to_host(), which expected us to
write the value to host memory, instead we have trapped the guest's
read or write to an mmio-device, and are about to replay it using the
host's readl()/writel() which also perform swabbing based on the host
endianness. This goes wrong when both host and guest are big-endian,
as readl()/writel() will undo the guest's swabbing, causing the
big-endian value to be written to device-memory.

What needs doing?
A big-endian guest will have pre-swabbed data before storing, undo this.
If its necessary for the host, writel() will re-swab it.

For a read a big-endian guest expects to swab the data after the load.
The hosts's readl() will correct for host endianness, giving us the
device-memory's value in the register. For a big-endian guest, swab it
as if we'd only done the load.

For a little-endian guest, nothing needs doing as readl()/writel() leave
the correct device-memory value in registers.

Tested on Juno with that rarest of things: a big-endian 64K host.
Based on a patch from Marc Zyngier.

Reported-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Fixes: bf8feb39642b ("arm64: KVM: vgic-v2: Add GICV access from HYP")
CC: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
This patch doesn't apply before 8a43a2b34b7d
("KVM: arm/arm64: Move arm64-only vgic-v2-sr.c file to arm64"), but the
backport is straightforward.

 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 86801b6055d6..39be799d0417 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -18,11 +18,20 @@
 #include <linux/compiler.h>
 #include <linux/irqchip/arm-gic.h>
 #include <linux/kvm_host.h>
+#include <linux/swab.h>
 
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+static bool __hyp_text __is_be(struct kvm_vcpu *vcpu)
+{
+	if (vcpu_mode_is_32bit(vcpu))
+		return !!(read_sysreg_el2(spsr) & COMPAT_PSR_E_BIT);
+
+	return !!(read_sysreg(SCTLR_EL1) & SCTLR_ELx_EE);
+}
+
 /*
  * __vgic_v2_perform_cpuif_access -- perform a GICV access on behalf of the
  *				     guest.
@@ -64,14 +73,19 @@ int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	addr += fault_ipa - vgic->vgic_cpu_base;
 
 	if (kvm_vcpu_dabt_iswrite(vcpu)) {
-		u32 data = vcpu_data_guest_to_host(vcpu,
-						   vcpu_get_reg(vcpu, rd),
-						   sizeof(u32));
+		u32 data = vcpu_get_reg(vcpu, rd);
+		if (__is_be(vcpu)) {
+			/* guest pre-swabbed data, undo this for writel() */
+			data = swab32(data);
+		}
 		writel_relaxed(data, addr);
 	} else {
 		u32 data = readl_relaxed(addr);
-		vcpu_set_reg(vcpu, rd, vcpu_data_host_to_guest(vcpu, data,
-							       sizeof(u32)));
+		if (__is_be(vcpu)) {
+			/* guest expects swabbed data */
+			data = swab32(data);
+		}
+		vcpu_set_reg(vcpu, rd, data);
 	}
 
 	return 1;
-- 
2.16.2
