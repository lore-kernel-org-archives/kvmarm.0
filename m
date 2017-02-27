From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 1/5] KVM: arm/arm64: prepare to use vcpu requests
Date: Mon, 27 Feb 2017 18:55:00 +0100
Message-ID: <20170227175504.15751-2-drjones@redhat.com>
References: <20170227175504.15751-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74A3D40C49
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Feb 2017 12:54:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EgJVcTa+lZxO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Feb 2017 12:54:02 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 40CD840C2C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Feb 2017 12:54:02 -0500 (EST)
In-Reply-To: <20170227175504.15751-1-drjones@redhat.com>
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
Cc: marc.zyngier@arm.com, ashoks@broadcom.com, imammedo@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Make sure we don't leave vcpu requests we don't intend to
handle later set in the request bitmap. If we don't clear
them, then kvm_request_pending() may return true when we
don't want it to.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/kvm/handle_exit.c   | 1 +
 arch/arm/kvm/psci.c          | 1 +
 arch/arm64/kvm/handle_exit.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index 4e40d1955e35..2ec31748fa0b 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -72,6 +72,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		trace_kvm_wfx(*vcpu_pc(vcpu), false);
 		vcpu->stat.wfi_exit_stat++;
 		kvm_vcpu_block(vcpu);
+		__kvm_request_clear(KVM_REQ_UNHALT, vcpu);
 	}
 
 	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index c2b131527a64..fd7e381b13b2 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -57,6 +57,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 	 * for KVM will preserve the register state.
 	 */
 	kvm_vcpu_block(vcpu);
+	__kvm_request_clear(KVM_REQ_UNHALT, vcpu);
 
 	return PSCI_RET_SUCCESS;
 }
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 1bfe30dfbfe7..b34971d7c30a 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -89,6 +89,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
 		vcpu->stat.wfi_exit_stat++;
 		kvm_vcpu_block(vcpu);
+		__kvm_request_clear(KVM_REQ_UNHALT, vcpu);
 	}
 
 	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
-- 
2.9.3
