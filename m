Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A7EC001B5
	for <kvmarm@archiver.kernel.org>; Fri,  2 Sep 2022 15:48:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FE714B621;
	Fri,  2 Sep 2022 11:48:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F3cIeFoBw-r8; Fri,  2 Sep 2022 11:48:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BED140C52;
	Fri,  2 Sep 2022 11:48:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 903E740B6C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 11:48:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id owBBEdnlxf2s for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Sep 2022 11:48:30 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 82AF640C52
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 11:48:30 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1662133709;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=/op3CBEinkvTvgamMVY4adnisAOglI/j+DprQ1jnwLs=;
 b=vSJYzQjTn5JiKKoXkIZFS6sZAL8nglhzH3m1Cc/56eVqKV0nSy+FT02abLWZ1L6hrzWu90
 z6eh3xL6WzqfhvTScyYCtYflkQOkDIV6H5YWago7Roz7+NyW2+R+fbnntKdIR6URj8iMNY
 jDvRIPaeT6UQFQOPBdmyO5uF3ll3Fvo=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: [PATCH v2 5/7] KVM: arm64: Add a visibility bit to ignore user writes
Date: Fri,  2 Sep 2022 15:48:01 +0000
Message-Id: <20220902154804.1939819-6-oliver.upton@linux.dev>
In-Reply-To: <20220902154804.1939819-1-oliver.upton@linux.dev>
References: <20220902154804.1939819-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

We're about to ignore writes to AArch32 ID registers on AArch64-only
systems. Add a bit to indicate a register is handled as write ignore
when accessed from userspace.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 3 +++
 arch/arm64/kvm/sys_regs.h | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0e20a311ea20..6d0511247df4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2775,6 +2775,9 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 	if (!r)
 		return -ENOENT;
 
+	if (sysreg_user_write_ignore(vcpu, r))
+		return 0;
+
 	if (r->set_user) {
 		ret = (r->set_user)(vcpu, r, val);
 	} else {
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index e78b51059622..e4ebb3a379fd 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -86,6 +86,7 @@ struct sys_reg_desc {
 
 #define REG_HIDDEN		(1 << 0) /* hidden from userspace and guest */
 #define REG_RAZ			(1 << 1) /* RAZ from userspace and guest */
+#define REG_USER_WI		(1 << 2) /* WI from userspace only */
 
 static __printf(2, 3)
 inline void print_sys_reg_msg(const struct sys_reg_params *p,
@@ -157,6 +158,12 @@ static inline bool sysreg_visible_as_raz(const struct kvm_vcpu *vcpu,
 	return sysreg_visibility(vcpu, r) & REG_RAZ;
 }
 
+static inline bool sysreg_user_write_ignore(const struct kvm_vcpu *vcpu,
+					    const struct sys_reg_desc *r)
+{
+	return sysreg_visibility(vcpu, r) & REG_USER_WI;
+}
+
 static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
 			      const struct sys_reg_desc *i2)
 {
-- 
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
