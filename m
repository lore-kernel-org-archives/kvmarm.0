From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 05/10] arm64: KVM: Survive unknown traps from guests
Date: Thu,  9 Mar 2017 09:55:34 +0000
Message-ID: <20170309095539.14512-6-marc.zyngier@arm.com>
References: <20170309095539.14512-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 19A42408EB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 04:55:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mvYdP057y0wZ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 04:55:01 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39AB540992
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 04:55:01 -0500 (EST)
In-Reply-To: <20170309095539.14512-1-marc.zyngier@arm.com>
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
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Linu Cherian <linu.cherian@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

Currently we BUG() if we see an ESR_EL2.EC value we don't recognise. As
configurable disables/enables are added to the architecture (controlled
by RES1/RES0 bits respectively), with associated synchronous exceptions,
it may be possible for a guest to trigger exceptions with classes that
we don't recognise.

While we can't service these exceptions in a manner useful to the guest,
we can avoid bringing down the host. Per ARM DDI 0487A.k_iss10775, page
D7-1937, EC values within the range 0x00 - 0x2c are reserved for future
use with synchronous exceptions, and EC values within the range 0x2d -
0x3f may be used for either synchronous or asynchronous exceptions.

The patch makes KVM handle any unknown EC by injecting an UNDEFINED
exception into the guest, with a corresponding (ratelimited) warning in
the host dmesg. We could later improve on this with with a new (opt-in)
exit to the host userspace.

Cc: Dave Martin <dave.martin@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/handle_exit.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 1bfe30dfbfe7..fa1b18e364fc 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -135,7 +135,19 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return ret;
 }
 
+static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	u32 hsr = kvm_vcpu_get_hsr(vcpu);
+
+	kvm_pr_unimpl("Unknown exception class: hsr: %#08x -- %s\n",
+		      hsr, esr_get_class_string(hsr));
+
+	kvm_inject_undefined(vcpu);
+	return 1;
+}
+
 static exit_handle_fn arm_exit_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]	= kvm_handle_unknown_ec,
 	[ESR_ELx_EC_WFx]	= kvm_handle_wfx,
 	[ESR_ELx_EC_CP15_32]	= kvm_handle_cp15_32,
 	[ESR_ELx_EC_CP15_64]	= kvm_handle_cp15_64,
@@ -162,13 +174,6 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
 	u32 hsr = kvm_vcpu_get_hsr(vcpu);
 	u8 hsr_ec = ESR_ELx_EC(hsr);
 
-	if (hsr_ec >= ARRAY_SIZE(arm_exit_handlers) ||
-	    !arm_exit_handlers[hsr_ec]) {
-		kvm_err("Unknown exception class: hsr: %#08x -- %s\n",
-			hsr, esr_get_class_string(hsr));
-		BUG();
-	}
-
 	return arm_exit_handlers[hsr_ec];
 }
 
-- 
2.11.0
