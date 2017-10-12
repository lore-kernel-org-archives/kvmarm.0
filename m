From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 24/37] KVM: arm64: Prepare to handle traps on deferred EL0
 sysregs
Date: Thu, 12 Oct 2017 12:41:28 +0200
Message-ID: <20171012104141.26902-25-christoffer.dall@linaro.org>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9D5D49DA0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gMHBKokQV9Mc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 06:41:32 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7257249D31
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:31 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id b189so11865927wmd.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 03:42:15 -0700 (PDT)
In-Reply-To: <20171012104141.26902-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We can trap access to ACTLR_EL1 which we can later defer to only
save/restore during vcpu_load and vcpu_put, so let's read the value
directly from the CPU when necessary.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/sys_regs_generic_v8.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
index 969ade1..348f227 100644
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
@@ -38,7 +38,10 @@ static bool access_actlr(struct kvm_vcpu *vcpu,
 	if (p->is_write)
 		return ignore_write(vcpu, p);
 
-	p->regval = vcpu_sys_reg(vcpu, ACTLR_EL1);
+	if (vcpu->arch.sysregs_loaded_on_cpu)
+		read_sysreg(actlr_el1);
+	else
+		p->regval = vcpu_sys_reg(vcpu, ACTLR_EL1);
 	return true;
 }
 
-- 
2.9.0
