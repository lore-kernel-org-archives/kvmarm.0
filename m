From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 04/28] KVM: arm/arm64: Log PSTATE for unhandled sysregs
Date: Wed, 19 Dec 2018 18:03:25 +0000
Message-ID: <20181219180349.242681-5-marc.zyngier@arm.com>
References: <20181219180349.242681-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BB9F4A327
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:04:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pxMTRQGO6MLH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Dec 2018 13:04:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 509304A3A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:04:21 -0500 (EST)
In-Reply-To: <20181219180349.242681-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Lukas Braun <koomi@moshbit.net>
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

When KVM traps an unhandled sysreg/coproc access from a guest, it logs
the guest PC. To aid debugging, it would be helpful to know which
exception level the trap came from, along with other PSTATE/CPSR bits,
so let's log the PSTATE/CPSR too.

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/coproc.c     | 4 ++--
 arch/arm64/kvm/sys_regs.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index cb094e55dc5f..222c1635bc7a 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -602,8 +602,8 @@ static int emulate_cp15(struct kvm_vcpu *vcpu,
 		}
 	} else {
 		/* If access function fails, it should complain. */
-		kvm_err("Unsupported guest CP15 access at: %08lx\n",
-			*vcpu_pc(vcpu));
+		kvm_err("Unsupported guest CP15 access at: %08lx [%08lx]\n",
+			*vcpu_pc(vcpu), *vcpu_cpsr(vcpu));
 		print_cp_instr(params);
 		kvm_inject_undefined(vcpu);
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 22fbbdbece3c..ecbf67ccabf5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1912,8 +1912,8 @@ static void unhandled_cp_access(struct kvm_vcpu *vcpu,
 		WARN_ON(1);
 	}
 
-	kvm_err("Unsupported guest CP%d access at: %08lx\n",
-		cp, *vcpu_pc(vcpu));
+	kvm_err("Unsupported guest CP%d access at: %08lx [%08lx]\n",
+		cp, *vcpu_pc(vcpu), *vcpu_cpsr(vcpu));
 	print_sys_reg_instr(params);
 	kvm_inject_undefined(vcpu);
 }
@@ -2063,8 +2063,8 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 	if (likely(r)) {
 		perform_access(vcpu, params, r);
 	} else {
-		kvm_err("Unsupported guest sys_reg access at: %lx\n",
-			*vcpu_pc(vcpu));
+		kvm_err("Unsupported guest sys_reg access at: %lx [%08lx]\n",
+			*vcpu_pc(vcpu), *vcpu_cpsr(vcpu));
 		print_sys_reg_instr(params);
 		kvm_inject_undefined(vcpu);
 	}
-- 
2.19.2
