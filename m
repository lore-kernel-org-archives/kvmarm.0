From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 01/59] kvm: arm64: Fix EC field in inject_abt64
Date: Tue, 24 May 2016 11:08:55 +0200
Message-ID: <1464080993-10884-2-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53A6849B4E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5pqPY1RT-liU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 05:06:23 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57FEC49B43
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:23 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id z87so11867807wmh.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 02:09:56 -0700 (PDT)
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, Matt Evans <matt.evans@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Matt Evans <matt.evans@arm.com>

The EC field of the constructed ESR is conditionally modified by ORing in
ESR_ELx_EC_DABT_LOW for a data abort.  However, ESR_ELx_EC_SHIFT is missing
from this condition.

Signed-off-by: Matt Evans <matt.evans@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/inject_fault.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 4d1ac81..e9e0e6d 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -162,7 +162,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 		esr |= (ESR_ELx_EC_IABT_CUR << ESR_ELx_EC_SHIFT);
 
 	if (!is_iabt)
-		esr |= ESR_ELx_EC_DABT_LOW;
+		esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
 
 	vcpu_sys_reg(vcpu, ESR_EL1) = esr | ESR_ELx_FSC_EXTABT;
 }
-- 
2.1.2.330.g565301e.dirty
