From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v5 12/14] KVM: arm64: Remove redundant *exit_code changes in
 fpsimd_guest_exit()
Date: Fri,  4 May 2018 17:05:33 +0100
Message-ID: <1525449935-31424-13-git-send-email-Dave.Martin@arm.com>
References: <1525449935-31424-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F217D4A088
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 May 2018 11:56:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vmClN+0TzFxf for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 May 2018 11:56:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD94549FEB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 May 2018 11:56:09 -0400 (EDT)
In-Reply-To: <1525449935-31424-1-git-send-email-Dave.Martin@arm.com>
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

This patch removes the redundant assignments simplifies some if-
nesting that becomes trivial as a result.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/kvm/hyp/switch.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 8009126..39e9166 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -401,12 +401,8 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
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
@@ -428,12 +424,8 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
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
