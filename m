From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH v2 3/9] KVM: arm/arm64: prepare to use vcpu requests
Date: Fri, 31 Mar 2017 18:06:52 +0200
Message-ID: <20170331160658.4331-4-drjones@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170331160658.4331-1-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: cdall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Make sure we don't leave vcpu requests we don't intend to
handle later set in the request bitmap. If we don't clear
them, then kvm_request_pending() may return true when we
don't want it to.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Acked-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/kvm/handle_exit.c   | 1 +
 arch/arm/kvm/psci.c          | 1 +
 arch/arm64/kvm/handle_exit.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index 96af65a30d78..ffb2406e5905 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -72,6 +72,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		trace_kvm_wfx(*vcpu_pc(vcpu), false);
 		vcpu->stat.wfi_exit_stat++;
 		kvm_vcpu_block(vcpu);
+		clear_bit(KVM_REQ_UNHALT, &vcpu->requests);
 	}
 
 	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index c2b131527a64..82fe7eb5b6a7 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -57,6 +57,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 	 * for KVM will preserve the register state.
 	 */
 	kvm_vcpu_block(vcpu);
+	clear_bit(KVM_REQ_UNHALT, &vcpu->requests);
 
 	return PSCI_RET_SUCCESS;
 }
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index fa1b18e364fc..e4937fb2fb89 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -89,6 +89,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
 		vcpu->stat.wfi_exit_stat++;
 		kvm_vcpu_block(vcpu);
+		clear_bit(KVM_REQ_UNHALT, &vcpu->requests);
 	}
 
 	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
-- 
2.9.3
