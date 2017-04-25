From: James Morse <james.morse@arm.com>
Subject: [PATCH 2/2] KVM: arm64: Restore host physical timer access on
 hyp_panic()
Date: Tue, 25 Apr 2017 18:02:45 +0100
Message-ID: <20170425170245.4294-3-james.morse@arm.com>
References: <20170425170245.4294-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44B2740C46
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 13:01:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LBrHnmPLYZjx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Apr 2017 13:01:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F2CF40C8B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 13:01:01 -0400 (EDT)
In-Reply-To: <20170425170245.4294-1-james.morse@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

When KVM panics, it hurridly restores the host context and parachutes
into the host's panic() code. At some point panic() touches the physical
timer/counter. Unless we are an arm64 system with VHE, this traps back
to EL2. If we're lucky, we panic again.

Add a __timer_save_state() call to KVMs hyp_panic() path, this saves the
guest registers and disables the traps for the host.

Fixes: 53fd5b6487e4 ("arm64: KVM: Add panic handling")
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kvm/hyp/switch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index aede1658aeda..e5f089de6526 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -422,6 +422,7 @@ void __hyp_text __noreturn __hyp_panic(void)
 
 		vcpu = (struct kvm_vcpu *)read_sysreg(tpidr_el2);
 		host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+		__timer_save_state(vcpu);
 		__deactivate_traps(vcpu);
 		__deactivate_vm(vcpu);
 		__sysreg_restore_host_state(host_ctxt);
-- 
2.10.1
