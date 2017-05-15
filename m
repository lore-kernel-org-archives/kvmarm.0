From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH 11/11] KVM: arm64: Delegate support for SDEI to userspace
Date: Mon, 15 May 2017 18:43:59 +0100
Message-ID: <20170515174400.29735-12-james.morse@arm.com>
References: <20170515174400.29735-1-james.morse@arm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170515174400.29735-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

The Software Delegated Exception Interface allows firmware to notify
the OS of system events by returning into registered handlers, even
if the OS has interrupts masked.

While we could support this in KVM, we would need to expose an API for
the user space hypervisor to inject events, (and decide what to do it
the event isn't registered or all the CPUs have SDE events masked). We
already have an API for guest 'hypercalls', so use this to push the
problem onto userspace.

Advertise a new capability 'KVM_CAP_ARM_SDEI_1_0' and when any SDEI
call comes in, exit to userspace with exit_reason = KVM_EXIT_HYPERCALL.

N.B. There is no enable/feature bit for SDEI exits as telling the guest
the interface exists via DT/ACPI should be sufficient.

Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>

---
While I'm in here, why does KVM_CAP_ARM_SET_DEVICE_ADDR have a separate
entry for r=1;break?

 arch/arm64/kvm/handle_exit.c | 10 +++++++++-
 include/uapi/linux/kvm.h     |  1 +
 virt/kvm/arm/arm.c           |  5 +++--
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index fa1b18e364fc..2bed62fbdc00 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -21,6 +21,7 @@
 
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/sdei.h>
 
 #include <asm/esr.h>
 #include <asm/kvm_asm.h>
@@ -42,7 +43,14 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			    kvm_vcpu_hvc_get_imm(vcpu));
 	vcpu->stat.hvc_exit_stat++;
 
-	ret = kvm_psci_call(vcpu);
+	if (IS_SDEI_CALL(vcpu_get_reg(vcpu, 0))) {
+		/* SDEI is handled by userspace */
+		run->exit_reason = KVM_EXIT_HYPERCALL;
+		ret = 0;
+	} else {
+		ret = kvm_psci_call(vcpu);
+	}
+
 	if (ret < 0) {
 		kvm_inject_undefined(vcpu);
 		return 1;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 577429a95ad8..e9ebfed9d624 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -895,6 +895,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_SPAPR_TCE_VFIO 142
 #define KVM_CAP_X86_GUEST_MWAIT 143
 #define KVM_CAP_ARM_USER_IRQ 144
+#define KVM_CAP_ARM_SDEI_1_0 145
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 3a776ec99181..0bf2d923483c 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -206,8 +206,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_MP_STATE:
 	case KVM_CAP_IMMEDIATE_EXIT:
-		r = 1;
-		break;
+#ifdef CONFIG_ARM_SDE_INTERFACE
+	case KVM_CAP_ARM_SDEI_1_0:
+#endif
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
 		r = 1;
 		break;
-- 
2.10.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
