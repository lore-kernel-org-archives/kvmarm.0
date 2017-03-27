From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 7/9] arm64: KVM: Do not corrupt registers on failed 64bit
 CP read
Date: Mon, 27 Mar 2017 17:03:43 +0100
Message-ID: <20170327160345.12402-8-marc.zyngier@arm.com>
References: <20170327160345.12402-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46BDA40C4E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 12:02:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yJOneMeVCCcO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Mar 2017 12:02:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8462840C74
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Mar 2017 12:02:10 -0400 (EDT)
In-Reply-To: <20170327160345.12402-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Shannon Zhao <shannon.zhao@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

If we fail to emulate a mrrc instruction, we:
1) deliver an exception,
2) spit a nastygram on the console,
3) write back some garbage to Rt/Rt2

While 1) and 2) are perfectly acceptable, 3) is out of the scope of
the architecture... Let's mimick the code in kvm_handle_cp_32 and
be more cautious.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4e5d4eee8cec..1080a76e960f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1678,20 +1678,18 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 		params.regval |= vcpu_get_reg(vcpu, Rt2) << 32;
 	}
 
-	if (!emulate_cp(vcpu, &params, target_specific, nr_specific))
-		goto out;
-	if (!emulate_cp(vcpu, &params, global, nr_global))
-		goto out;
-
-	unhandled_cp_access(vcpu, &params);
+	if (!emulate_cp(vcpu, &params, target_specific, nr_specific) ||
+	    !emulate_cp(vcpu, &params, global, nr_global)) {
+		/* Split up the value between registers for the read side */
+		if (!params.is_write) {
+			vcpu_set_reg(vcpu, Rt, lower_32_bits(params.regval));
+			vcpu_set_reg(vcpu, Rt2, upper_32_bits(params.regval));
+		}
 
-out:
-	/* Split up the value between registers for the read side */
-	if (!params.is_write) {
-		vcpu_set_reg(vcpu, Rt, lower_32_bits(params.regval));
-		vcpu_set_reg(vcpu, Rt2, upper_32_bits(params.regval));
+		return 1;
 	}
 
+	unhandled_cp_access(vcpu, &params);
 	return 1;
 }
 
-- 
2.11.0
