From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [GIT PULL 2/2] arm/arm64: KVM: Add exit reaons to kvm_exit event tracing
Date: Sun, 15 Feb 2015 21:22:43 +0100
Message-ID: <1424031763-9534-3-git-send-email-christoffer.dall@linaro.org>
References: <1424031763-9534-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1424031763-9534-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Wei Huang <wei@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Wei Huang <wei@redhat.com>

This patch extends trace_kvm_exit() to include KVM exit reasons
(i.e. EC of HSR). The tracing function then dumps both exit reason
and PC of vCPU, shown as the following. Tracing tools can use this
new exit_reason field to better understand the behavior of guest VMs.

886.301252: kvm_exit:             HSR_EC: 0x0024, PC: 0xfffffe0000506b28

Signed-off-by: Wei Huang <wei@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c   |  2 +-
 arch/arm/kvm/trace.h | 10 +++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 0b0d58a..4a00131 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -533,7 +533,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		vcpu->mode = OUTSIDE_GUEST_MODE;
 		kvm_guest_exit();
-		trace_kvm_exit(*vcpu_pc(vcpu));
+		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
 		/*
 		 * We may have taken a host interrupt in HYP mode (ie
 		 * while executing the guest). This interrupt is still
diff --git a/arch/arm/kvm/trace.h b/arch/arm/kvm/trace.h
index b6a6e71..89fd80a6 100644
--- a/arch/arm/kvm/trace.h
+++ b/arch/arm/kvm/trace.h
@@ -25,18 +25,22 @@ TRACE_EVENT(kvm_entry,
 );
 
 TRACE_EVENT(kvm_exit,
-	TP_PROTO(unsigned long vcpu_pc),
-	TP_ARGS(vcpu_pc),
+	TP_PROTO(unsigned int exit_reason, unsigned long vcpu_pc),
+	TP_ARGS(exit_reason, vcpu_pc),
 
 	TP_STRUCT__entry(
+		__field(	unsigned int,	exit_reason	)
 		__field(	unsigned long,	vcpu_pc		)
 	),
 
 	TP_fast_assign(
+		__entry->exit_reason		= exit_reason;
 		__entry->vcpu_pc		= vcpu_pc;
 	),
 
-	TP_printk("PC: 0x%08lx", __entry->vcpu_pc)
+	TP_printk("HSR_EC: 0x%04x, PC: 0x%08lx",
+		  __entry->exit_reason,
+		  __entry->vcpu_pc)
 );
 
 TRACE_EVENT(kvm_guest_fault,
-- 
2.1.2.330.g565301e.dirty

