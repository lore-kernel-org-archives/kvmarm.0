From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 33/79] arm64: KVM: Do not corrupt registers on failed 64bit CP
 read
Date: Sun, 23 Apr 2017 19:08:43 +0200
Message-ID: <20170423170929.27334-34-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFD7749C8A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dg5lpN2Jfzky for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:23 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03F3D49CBD
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:20 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id r190so4711610wme.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:06 -0700 (PDT)
In-Reply-To: <20170423170929.27334-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

If we fail to emulate a mrrc instruction, we:
1) deliver an exception,
2) spit a nastygram on the console,
3) write back some garbage to Rt/Rt2

While 1) and 2) are perfectly acceptable, 3) is out of the scope of
the architecture... Let's mimick the code in kvm_handle_cp_32 and
be more cautious.

Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2f4418e..582d68e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1678,20 +1678,25 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 		params.regval |= vcpu_get_reg(vcpu, Rt2) << 32;
 	}
 
-	if (!emulate_cp(vcpu, &params, target_specific, nr_specific))
-		goto out;
-	if (!emulate_cp(vcpu, &params, global, nr_global))
-		goto out;
-
-	unhandled_cp_access(vcpu, &params);
+	/*
+	 * Try to emulate the coprocessor access using the target
+	 * specific table first, and using the global table afterwards.
+	 * If either of the tables contains a handler, handle the
+	 * potential register operation in the case of a read and return
+	 * with success.
+	 */
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
2.9.0
