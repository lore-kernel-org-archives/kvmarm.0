From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 25/55] arm64: KVM: Clean up a condition
Date: Fri, 22 Jul 2016 18:28:42 +0100
Message-ID: <1469208552-4155-26-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5778949B5C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j7-sJ8rpFGQC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:24:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A465849BB8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:18 -0400 (EDT)
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Dan Carpenter <dan.carpenter@oracle.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Dan Carpenter <dan.carpenter@oracle.com>

My static checker complains that this condition looks like it should be
== instead of =.  This isn't a fast path, so we don't need to be fancy.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a57d650..b0b225c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1546,7 +1546,7 @@ static void unhandled_cp_access(struct kvm_vcpu *vcpu,
 				struct sys_reg_params *params)
 {
 	u8 hsr_ec = kvm_vcpu_trap_get_class(vcpu);
-	int cp;
+	int cp = -1;
 
 	switch(hsr_ec) {
 	case ESR_ELx_EC_CP15_32:
@@ -1558,7 +1558,7 @@ static void unhandled_cp_access(struct kvm_vcpu *vcpu,
 		cp = 14;
 		break;
 	default:
-		WARN_ON((cp = -1));
+		WARN_ON(1);
 	}
 
 	kvm_err("Unsupported guest CP%d access at: %08lx\n",
-- 
2.8.1
