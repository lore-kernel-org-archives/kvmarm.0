From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 08/19] arm64: KVM: Inject a Virtual SError if it was pending
Date: Tue,  6 Sep 2016 14:02:06 +0100
Message-ID: <1473166937-15271-9-git-send-email-marc.zyngier@arm.com>
References: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1722949B67
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 08:54:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2Z+EyZkIJ2jS for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 08:54:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54D1C49B81
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 08:54:07 -0400 (EDT)
In-Reply-To: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

If we have caught an SError whilst exiting, we've tagged the
exit code with the pending information. In that case, let's
re-inject the error into the guest, after having adjusted
the PC if required.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/handle_exit.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 08afc69a..a204adf 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -170,6 +170,26 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 {
 	exit_handle_fn exit_handler;
 
+	if (ARM_SERROR_PENDING(exception_index)) {
+		u8 hsr_ec = ESR_ELx_EC(kvm_vcpu_get_hsr(vcpu));
+
+		/*
+		 * HVC/SMC already have an adjusted PC, which we need
+		 * to correct in order to return to after having
+		 * injected the SError.
+		 */
+		if (hsr_ec == ESR_ELx_EC_HVC32 || hsr_ec == ESR_ELx_EC_HVC64 ||
+		    hsr_ec == ESR_ELx_EC_SMC32 || hsr_ec == ESR_ELx_EC_SMC64) {
+			u32 adj =  kvm_vcpu_trap_il_is32bit(vcpu) ? 4 : 2;
+			*vcpu_pc(vcpu) -= adj;
+		}
+
+		kvm_inject_vabt(vcpu);
+		return 1;
+	}
+
+	exception_index = ARM_EXCEPTION_CODE(exception_index);
+
 	switch (exception_index) {
 	case ARM_EXCEPTION_IRQ:
 		return 1;
-- 
2.1.4
