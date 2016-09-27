From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 09/50] arm64: KVM: VHE: reset PSTATE.PAN on entry to EL2
Date: Tue, 27 Sep 2016 20:05:17 +0200
Message-ID: <20160927180558.14699-10-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3B1A49B67
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5X-vOFo696x2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:56:32 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A0D4449B62
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:32 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id b130so27053234wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:05:56 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, "# v4 . 6+" <stable@vger.kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Vladimir Murzin <vladimir.murzin@arm.com>

SCTLR_EL2.SPAN bit controls what happens with the PSTATE.PAN bit on an
exception. However, this bit has no effect on the PSTATE.PAN when
HCR_EL2.E2H or HCR_EL2.TGE is unset. Thus when VHE is used and
exception taken from a guest PSTATE.PAN bit left unchanged and we
continue with a value guest has set.

To address that always reset PSTATE.PAN on entry from EL1.

Fixes: 1f364c8c48a0 ("arm64: VHE: Add support for running Linux in EL2 mode")

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Cc: <stable@vger.kernel.org> # v4.6+
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/entry.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 3967c231..b5926ee 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -96,6 +96,8 @@ ENTRY(__guest_exit)
 
 	add	x1, x1, #VCPU_CONTEXT
 
+	ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
+
 	// Store the guest regs x2 and x3
 	stp	x2, x3,   [x1, #CPU_XREG_OFFSET(2)]
 
-- 
2.9.0
