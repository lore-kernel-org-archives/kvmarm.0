From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v7 14/16] KVM: arm64: Remove redundant *exit_code changes in
 fpsimd_guest_exit()
Date: Wed,  9 May 2018 17:13:03 +0100
Message-ID: <1525882385-29181-15-git-send-email-Dave.Martin@arm.com>
References: <1525882385-29181-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1351402C7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 May 2018 12:04:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yEp6Z4C5taZM for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 May 2018 12:04:20 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 998F14A0E5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 May 2018 12:04:10 -0400 (EDT)
In-Reply-To: <1525882385-29181-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

In fixup_guest_exit(), there are a couple of cases where after
checking what the exit code was, we assign it explicitly with the
value it already had.

Assuming this is not indicative of a bug, these assignments are not
needed.

This patch removes the redundant assignments, and simplifies some
if-nesting that becomes trivial as a result.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/switch.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index a6a8c7d..18d0faa 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -403,12 +403,8 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 		if (valid) {
 			int ret = __vgic_v2_perform_cpuif_access(vcpu);
 
-			if (ret == 1) {
-				if (__skip_instr(vcpu))
-					return true;
-				else
-					*exit_code = ARM_EXCEPTION_TRAP;
-			}
+			if (ret ==  1 && __skip_instr(vcpu))
+				return true;
 
 			if (ret == -1) {
 				/* Promote an illegal access to an
@@ -430,12 +426,8 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	     kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_CP15_32)) {
 		int ret = __vgic_v3_perform_cpuif_access(vcpu);
 
-		if (ret == 1) {
-			if (__skip_instr(vcpu))
-				return true;
-			else
-				*exit_code = ARM_EXCEPTION_TRAP;
-		}
+		if (ret == 1 && __skip_instr(vcpu))
+			return true;
 	}
 
 	/* Return to the host kernel and handle the exit */
-- 
2.1.4
