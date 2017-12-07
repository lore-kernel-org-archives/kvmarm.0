From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 23/36] KVM: arm64: Prepare to handle traps on deferred EL0
 sysregs
Date: Thu,  7 Dec 2017 18:06:17 +0100
Message-ID: <20171207170630.592-24-christoffer.dall@linaro.org>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40F0040EA6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:04:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YNnw-KqziSLU for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Dec 2017 12:04:02 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2744449DD1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:04:02 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id 64so14099182wme.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Dec 2017 09:07:18 -0800 (PST)
In-Reply-To: <20171207170630.592-1-christoffer.dall@linaro.org>
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

Notes:
    Changes since v1:
     - Fix bug in access_actlr that read the actlr_el1 and threw away the
       value.  Whoops.

 arch/arm64/kvm/sys_regs_generic_v8.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
index 969ade1d333d..8df4b4301696 100644
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
@@ -38,7 +38,10 @@ static bool access_actlr(struct kvm_vcpu *vcpu,
 	if (p->is_write)
 		return ignore_write(vcpu, p);
 
-	p->regval = vcpu_sys_reg(vcpu, ACTLR_EL1);
+	if (vcpu->arch.sysregs_loaded_on_cpu)
+		p->regval = read_sysreg(actlr_el1);
+	else
+		p->regval = vcpu_sys_reg(vcpu, ACTLR_EL1);
 	return true;
 }
 
-- 
2.14.2
