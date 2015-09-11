From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v2 05/22] KVM: ARM64: Add a helper for CP15 registers reset to
 UNKNOWN
Date: Fri, 11 Sep 2015 16:54:58 +0800
Message-ID: <1441961715-11688-6-git-send-email-zhaoshenglong@huawei.com>
References: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C253C4130A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NhgpmrxP0twM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2015 04:55:30 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B13041022
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:28 -0400 (EDT)
In-Reply-To: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index d411e25..a0b3811 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -104,6 +104,14 @@ static inline void reset_unknown(struct kvm_vcpu *vcpu,
 	vcpu_sys_reg(vcpu, r->reg) = 0x1de7ec7edbadc0deULL;
 }
 
+static inline void reset_unknown_cp15(struct kvm_vcpu *vcpu,
+				      const struct sys_reg_desc *r)
+{
+	BUG_ON(!r->reg);
+	BUG_ON(r->reg >= NR_COPRO_REGS);
+	vcpu_cp15(vcpu, r->reg) = 0xdecafbad;
+}
+
 static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	BUG_ON(!r->reg);
-- 
2.0.4
