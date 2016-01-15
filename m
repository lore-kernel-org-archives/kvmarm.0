From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH] help guest boot up on AArch64 host with GICv2
Date: Fri, 15 Jan 2016 15:02:48 -0500
Message-ID: <56995068.9050207@ezchip.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060409010300010002020105"
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

--------------060409010300010002020105
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

We are using GICv2 compatibility mode in the Fast Models/Foundation 
Models simulations we are running because the boot code (ATF/UEFI) 
doesn't support GICv3 in our system at the moment.

However, starting with kernel 4.2, the guest couldn't boot up because it 
wasn't getting timer interrupts.  I tracked this down to a kernel commit 
that switched to using the "alternatives" mechanism -- rather than 
seeing either a GICv2 or GICv3 and configuring appropriately, the KVM 
code just configured the code that saves/restores the vgic state based 
on the presence of the system register interface to the GIC CPU 
interface.  See the attached patch for a fix that manages this 
differently and allows me to boot up the guest in this configuration.

However, even assuming this patch can be taken into an upstream tree, I 
still have a couple of additional problems:

- I can boot up with the Foundation Models using this change, but not 
with the Fast Models (again, using a v3 GIC but in v2 compatibility mode 
in the device tree).  The Fast Models dts looks like it has the same 
configuration for the GIC and the timers so I'm not sure what's going on 
here.  Any suggestions appreciated.

- Without this change, I could only boot kernels up to 4.1.  With the 
change, I can boot kernels up to 4.3.  But 4.4 won't boot for me either; 
I haven't bisected it down yet.  So any suggestions on what might be 
going wrong here would also be appreciated.

We are planning to eventually use GICv3 mode in our software stack but 
for the time being I assume it is interesting to resolve issues with GIC 
v2 compatibility mode on GIC v3.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com


--------------060409010300010002020105
Content-Type: text/x-patch;
	name="0001-gic-update-save-restore-pointers-only-when-gic-v3-de.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-gic-update-save-restore-pointers-only-when-gic-v3-de.pa";
	filename*1="tch"

>From 3dcb529de23adb918b9a4d6eca717c737f380bc3 Mon Sep 17 00:00:00 2001
From: Chris Metcalf <cmetcalf@ezchip.com>
Date: Fri, 15 Jan 2016 13:18:06 -0500
Subject: [PATCH] gic: update save/restore pointers only when gic v3 detected

The original code set up the VGIC save/restore calls in
__kvm_vcpu_run() based on whether the GIC had been detected as v2 or
v3. Commit 8a14849b4a35 ("arm64: KVM: Switch vgic save/restore to
alternative_insn") switched to making that choice based on whether
the processor feature register reports that the system register
interface to the GIC CPU interface is supported.

However, booting up with the GIC v3 in v2 compatibility mode (in
this case on the Linaro Foundation Model simulator) we find that
the v3 save/restore isn't the right thing, since we end up with no
timer interrupts being delivered to the KVM guest.  Reverting to
a model where we set up the VGIC save/restore calls based on the
actual GIC type fixes this.

To do this and still keep the simplicity of the "alternatives"
model, we instead leave the v2 branch-and-link instruction in place,
but patch it dynamically to be a branch-and-link to the v3 routines
if we detect a v3 GIC.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
 arch/arm/include/asm/kvm_host.h   |  5 +++++
 arch/arm64/include/asm/kvm_host.h | 37 +++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp.S              | 14 ++++----------
 virt/kvm/arm/vgic.c               |  3 +++
 4 files changed, 49 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index c4072d9f32c7..a34ce4d73498 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -216,6 +216,11 @@ static inline int kvm_arch_dev_ioctl_check_extension(long ext)
 	return 0;
 }
 
+static inline void vgic_arch_setup(const struct vgic_params *vgic)
+{
+	BUG_ON(vgic->type != VGIC_V2);
+}
+
 int kvm_perf_init(void);
 int kvm_perf_teardown(void);
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ed039688c221..9ce98e69b5ec 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -27,6 +27,7 @@
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmio.h>
+#include <asm/insn.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
 
@@ -244,6 +245,42 @@ static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
 		     hyp_stack_ptr, vector_ptr);
 }
 
+#ifdef CONFIG_ARM_GIC_V3
+/* Write a 'bl FUNC' instruction at address CALLSITE. */
+static inline void vgic_patch(char *callsite, char *func)
+{
+	aarch64_insn_patch_text_nosync(
+		callsite,
+		aarch64_insn_gen_branch_imm((long)callsite, (long)func,
+					    AARCH64_INSN_BRANCH_LINK));
+}
+#endif
+
+static inline void vgic_arch_setup(const struct vgic_params *vgic)
+{
+	switch(vgic->type)
+	{
+	case VGIC_V2:
+		break;
+
+#ifdef CONFIG_ARM_GIC_V3
+	case VGIC_V3:
+	{
+		extern char __save_vgic_state_insn[];
+		extern char __save_vgic_v3_state[];
+		extern char __restore_vgic_state_insn[];
+		extern char __restore_vgic_v3_state[];
+		vgic_patch(__save_vgic_state_insn, __save_vgic_v3_state);
+		vgic_patch(__restore_vgic_state_insn, __restore_vgic_v3_state);
+		break;
+	}
+#endif
+
+	default:
+		BUG();
+	}
+}
+
 static inline void kvm_arch_hardware_disable(void) {}
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index e5836138ec42..6b1eded53051 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -518,11 +518,8 @@
  * Call into the vgic backend for state saving
  */
 .macro save_vgic_state
-alternative_if_not ARM64_HAS_SYSREG_GIC_CPUIF
-	bl	__save_vgic_v2_state
-alternative_else
-	bl	__save_vgic_v3_state
-alternative_endif
+ENTRY(__save_vgic_state_insn)
+	bl	__save_vgic_v2_state // may update to __save_vgic_v3_state
 	mrs	x24, hcr_el2
 	mov	x25, #HCR_INT_OVERRIDE
 	neg	x25, x25
@@ -539,11 +536,8 @@ alternative_endif
 	orr	x24, x24, #HCR_INT_OVERRIDE
 	orr	x24, x24, x25
 	msr	hcr_el2, x24
-alternative_if_not ARM64_HAS_SYSREG_GIC_CPUIF
-	bl	__restore_vgic_v2_state
-alternative_else
-	bl	__restore_vgic_v3_state
-alternative_endif
+ENTRY(__restore_vgic_state_insn)
+	bl	__restore_vgic_v2_state // may update to __restore_vgic_v3_state
 .endm
 
 .macro save_timer_state
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 66c66165e712..8b4215414d11 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2502,6 +2502,9 @@ int kvm_vgic_hyp_init(void)
 		goto out_free_irq;
 	}
 
+	/* Callback into for arch code for setup */
+	vgic_arch_setup(vgic);
+
 	on_each_cpu(vgic_init_maintenance_interrupt, NULL, 1);
 
 	return 0;
-- 
2.1.2


--------------060409010300010002020105
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--------------060409010300010002020105--
