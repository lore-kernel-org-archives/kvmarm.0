From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 02/31] KVM: arm/arm64: Count guest exit due to various reasons
Date: Thu, 24 Dec 2015 11:12:10 +0000
Message-ID: <1450955559-15639-3-git-send-email-marc.zyngier@arm.com>
References: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Amit Tomar <amittomer25@gmail.com>, Gleb Natapov <gleb@kernel.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, David Binderman <dcb314@hotmail.com>, Fengguang Wu <fengguang.wu@intel.com>, Jisheng Zhang <jszhang@marvell.com>, Mark Rutland <mark.rutland@arm.com>, Pavel Fedin <p.fedin@samsung.com>, Vladimir Murzin <vladimir.murzin@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Amit Tomar <amittomer25@gmail.com>

It would add guest exit statistics to debugfs, this can be helpful
while measuring KVM performance.

  [ Renamed some of the field names - Christoffer ]

Signed-off-by: Amit Singh Tomar <amittomer25@gmail.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_host.h   | 6 ++++++
 arch/arm/kvm/arm.c                | 1 +
 arch/arm/kvm/guest.c              | 6 ++++++
 arch/arm/kvm/handle_exit.c        | 3 +++
 arch/arm/kvm/mmio.c               | 3 +++
 arch/arm64/include/asm/kvm_host.h | 6 ++++++
 arch/arm64/kvm/guest.c            | 9 +++++++++
 arch/arm64/kvm/handle_exit.c      | 3 +++
 8 files changed, 37 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 6692982..f9f2779 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -150,6 +150,12 @@ struct kvm_vcpu_stat {
 	u32 halt_successful_poll;
 	u32 halt_attempted_poll;
 	u32 halt_wakeup;
+	u32 hvc_exit_stat;
+	u64 wfe_exit_stat;
+	u64 wfi_exit_stat;
+	u64 mmio_exit_user;
+	u64 mmio_exit_kernel;
+	u64 exits;
 };
 
 int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index e06fd29..8a79a57 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -603,6 +603,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
 
 		vcpu->mode = OUTSIDE_GUEST_MODE;
+		vcpu->stat.exits++;
 		/*
 		 * Back from guest
 		 *************************************************************/
diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
index 96e935b..5fa69d7 100644
--- a/arch/arm/kvm/guest.c
+++ b/arch/arm/kvm/guest.c
@@ -33,6 +33,12 @@
 #define VCPU_STAT(x) { #x, offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU }
 
 struct kvm_stats_debugfs_item debugfs_entries[] = {
+	VCPU_STAT(hvc_exit_stat),
+	VCPU_STAT(wfe_exit_stat),
+	VCPU_STAT(wfi_exit_stat),
+	VCPU_STAT(mmio_exit_user),
+	VCPU_STAT(mmio_exit_kernel),
+	VCPU_STAT(exits),
 	{ NULL }
 };
 
diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index 95f12b2..3ede90d 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -42,6 +42,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	trace_kvm_hvc(*vcpu_pc(vcpu), *vcpu_reg(vcpu, 0),
 		      kvm_vcpu_hvc_get_imm(vcpu));
+	vcpu->stat.hvc_exit_stat++;
 
 	ret = kvm_psci_call(vcpu);
 	if (ret < 0) {
@@ -89,9 +90,11 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	if (kvm_vcpu_get_hsr(vcpu) & HSR_WFI_IS_WFE) {
 		trace_kvm_wfx(*vcpu_pc(vcpu), true);
+		vcpu->stat.wfe_exit_stat++;
 		kvm_vcpu_on_spin(vcpu);
 	} else {
 		trace_kvm_wfx(*vcpu_pc(vcpu), false);
+		vcpu->stat.wfi_exit_stat++;
 		kvm_vcpu_block(vcpu);
 	}
 
diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
index 3a10c9f..7f33b20 100644
--- a/arch/arm/kvm/mmio.c
+++ b/arch/arm/kvm/mmio.c
@@ -210,8 +210,11 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 
 	if (!ret) {
 		/* We handled the access successfully in the kernel. */
+		vcpu->stat.mmio_exit_kernel++;
 		kvm_handle_mmio_return(vcpu, run);
 		return 1;
+	} else {
+		vcpu->stat.mmio_exit_user++;
 	}
 
 	run->exit_reason	= KVM_EXIT_MMIO;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a35ce72..19504aa 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -197,6 +197,12 @@ struct kvm_vcpu_stat {
 	u32 halt_successful_poll;
 	u32 halt_attempted_poll;
 	u32 halt_wakeup;
+	u32 hvc_exit_stat;
+	u64 wfe_exit_stat;
+	u64 wfi_exit_stat;
+	u64 mmio_exit_user;
+	u64 mmio_exit_kernel;
+	u64 exits;
 };
 
 int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index d250160..115522b 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -34,7 +34,16 @@
 
 #include "trace.h"
 
+#define VM_STAT(x) { #x, offsetof(struct kvm, stat.x), KVM_STAT_VM }
+#define VCPU_STAT(x) { #x, offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU }
+
 struct kvm_stats_debugfs_item debugfs_entries[] = {
+	VCPU_STAT(hvc_exit_stat),
+	VCPU_STAT(wfe_exit_stat),
+	VCPU_STAT(wfi_exit_stat),
+	VCPU_STAT(mmio_exit_user),
+	VCPU_STAT(mmio_exit_kernel),
+	VCPU_STAT(exits),
 	{ NULL }
 };
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 15f0477..8bddae1 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -39,6 +39,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	trace_kvm_hvc_arm64(*vcpu_pc(vcpu), vcpu_get_reg(vcpu, 0),
 			    kvm_vcpu_hvc_get_imm(vcpu));
+	vcpu->stat.hvc_exit_stat++;
 
 	ret = kvm_psci_call(vcpu);
 	if (ret < 0) {
@@ -71,9 +72,11 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	if (kvm_vcpu_get_hsr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
+		vcpu->stat.wfe_exit_stat++;
 		kvm_vcpu_on_spin(vcpu);
 	} else {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
+		vcpu->stat.wfi_exit_stat++;
 		kvm_vcpu_block(vcpu);
 	}
 
-- 
2.1.4

