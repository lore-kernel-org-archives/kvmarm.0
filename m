From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 08/79] KVM: arm64: add SYS_DESC()
Date: Sun, 23 Apr 2017 19:08:18 +0200
Message-ID: <20170423170929.27334-9-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6D5349C9D
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:06:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nDKDfXJuagZm for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:06:54 -0400 (EDT)
Received: from mail-wr0-f175.google.com (mail-wr0-f175.google.com
 [209.85.128.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE69349C5C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:06:53 -0400 (EDT)
Received: by mail-wr0-f175.google.com with SMTP id z52so37728416wrc.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:09:39 -0700 (PDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

This patch adds a macro enabling us to initialise sys_reg_desc
structures based on common sysreg encoding definitions in
<asm/sysreg.h>. Subsequent patches will use this to simplify the KVM
code.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/kvm/sys_regs.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 9c6ffd0..66859a5 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -147,4 +147,9 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
 #define CRm(_x) 	.CRm = _x
 #define Op2(_x) 	.Op2 = _x
 
+#define SYS_DESC(reg)					\
+	Op0(sys_reg_Op0(reg)), Op1(sys_reg_Op1(reg)),	\
+	CRn(sys_reg_CRn(reg)), CRm(sys_reg_CRm(reg)),	\
+	Op2(sys_reg_Op2(reg))
+
 #endif /* __ARM64_KVM_SYS_REGS_LOCAL_H__ */
-- 
2.9.0
