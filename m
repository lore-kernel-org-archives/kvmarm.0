Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 431BAC6FA82
	for <kvmarm@archiver.kernel.org>; Tue, 13 Sep 2022 09:45:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E18134BC36;
	Tue, 13 Sep 2022 05:45:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R0M0-nlPnNb5; Tue, 13 Sep 2022 05:45:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB50B4BC1C;
	Tue, 13 Sep 2022 05:45:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C5594BC1A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 05:45:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6idg1JoWluC3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2022 05:45:04 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A4964BBE3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 05:45:04 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663062303;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=z1HCozkzwfIh/WZyb+NtoFOxgqJRCNjqWxITkulBgAA=;
 b=pk7e10ybcoZrRzQTGxR3QDGPtHgnvSHBeBRinW5NVM/ySvbnetK1XSxL9PjQQBkmNm9Lg6
 BdtL3hUprSN3mgtYaGp5HlnrmTPrN96sgeIk4xMCCGZw8OgsRIBb59V/QD6An71MyJfb3e
 CgGNo4E2AaqzCmc8KwjGZGDkogbnYHY=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: [PATCH v3 4/7] KVM: arm64: Spin off helper for calling visibility hook
Date: Tue, 13 Sep 2022 09:44:37 +0000
Message-Id: <20220913094441.3957645-5-oliver.upton@linux.dev>
In-Reply-To: <20220913094441.3957645-1-oliver.upton@linux.dev>
References: <20220913094441.3957645-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

No functional change intended.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.h | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index a8c4cc32eb9a..e78b51059622 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -136,22 +136,25 @@ static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r
 	__vcpu_sys_reg(vcpu, r->reg) = r->val;
 }
 
-static inline bool sysreg_hidden(const struct kvm_vcpu *vcpu,
-				 const struct sys_reg_desc *r)
+static inline unsigned int sysreg_visibility(const struct kvm_vcpu *vcpu,
+					     const struct sys_reg_desc *r)
 {
 	if (likely(!r->visibility))
-		return false;
+		return 0;
 
-	return r->visibility(vcpu, r) & REG_HIDDEN;
+	return r->visibility(vcpu, r);
+}
+
+static inline bool sysreg_hidden(const struct kvm_vcpu *vcpu,
+				 const struct sys_reg_desc *r)
+{
+	return sysreg_visibility(vcpu, r) & REG_HIDDEN;
 }
 
 static inline bool sysreg_visible_as_raz(const struct kvm_vcpu *vcpu,
 					 const struct sys_reg_desc *r)
 {
-	if (likely(!r->visibility))
-		return false;
-
-	return r->visibility(vcpu, r) & REG_RAZ;
+	return sysreg_visibility(vcpu, r) & REG_RAZ;
 }
 
 static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
-- 
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
