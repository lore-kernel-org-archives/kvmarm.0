From: James Morse <james.morse@arm.com>
Subject: [PATCH 1/2] KVM: arm: Restore banked registers and physical timer
 access on hyp_panic()
Date: Tue, 25 Apr 2017 18:02:44 +0100
Message-ID: <20170425170245.4294-2-james.morse@arm.com>
References: <20170425170245.4294-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5EA440C46
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 13:01:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id whDAhxaSQTTw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Apr 2017 13:01:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEB8940CE6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 13:00:59 -0400 (EDT)
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
into the host's panic() code. This looks like it was copied from arm64,
the 32bit KVM panic code needs to restore the host's banked registers
too.

At some point panic() touches the physical timer/counter, this will
trap back to HYP. If we're lucky, we panic again.

Add a __timer_save_state() call to KVMs hyp_panic() path, this saves the
guest registers and disables the traps for the host.

Fixes: c36b6db5f3e4 ("ARM: KVM: Add panic handling code")
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm/kvm/hyp/switch.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index 92678b7bd046..c8f15bb5c8b3 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -235,8 +235,10 @@ void __hyp_text __noreturn __hyp_panic(int cause)
 
 		vcpu = (struct kvm_vcpu *)read_sysreg(HTPIDR);
 		host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+		__timer_save_state(vcpu);
 		__deactivate_traps(vcpu);
 		__deactivate_vm(vcpu);
+		__banked_restore_state(host_ctxt);
 		__sysreg_restore_state(host_ctxt);
 	}
 
-- 
2.10.1
