Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22290C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 28 Jan 2022 12:20:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB4F849ED8;
	Fri, 28 Jan 2022 07:20:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id urlaeb8sIKGO; Fri, 28 Jan 2022 07:20:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA15F4B133;
	Fri, 28 Jan 2022 07:20:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94B114B118
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jan 2022 07:20:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K8C-sKolL0Gv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Jan 2022 07:20:10 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4FF9C4A1B0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jan 2022 07:20:10 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 6E1F7B82571;
 Fri, 28 Jan 2022 12:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F5CC340E0;
 Fri, 28 Jan 2022 12:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643372408;
 bh=+MtgXcNVbDZI+bNgWIG3TBTyMXnbtoWmNZ2cY3VVFQU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=ZFyCFTAukS/fbkV0Hyl1Dj1iQs8l9rNO7AfYHqm8rGd/jSq8JdEq+eWMiLMezPrPG
 vUTCorsrnhKFnbhD4E4V8Jx4uTJIVe38sv8p/qogsUSL2/0tBeLv0P8tN6yymDGuEs
 gBM+hPNypFE8vAQKTB5058WrxseKC4W1TCT/xESdkbXfv4zRYxGgOzIbwXrUP93wm/
 R9Ls5TYc9Cjufg9cIwJAkzFc2pembsG57E6wFlY8ibz9OzjH8ZK/+PFHti60AxY5me
 d3nhS5Qqegj4mAXrDrmS4CBusU/7bAKw0KQUvBO48KDQ/vn/n29SF5r8nz6ckin26b
 iQxi9D93U5Q4w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nDQE6-003njR-88; Fri, 28 Jan 2022 12:19:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v6 27/64] KVM: arm64: nv: Allow a sysreg to be hidden from
 userspace only
Date: Fri, 28 Jan 2022 12:18:35 +0000
Message-Id: <20220128121912.509006-28-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org,
 gankulkarni@os.amperecomputing.com, chase.conklin@arm.com,
 linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com,
 miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 "Russell King \(Oracle\)" <linux@armlinux.org.uk>, mihai.carabas@oracle.com,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
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

So far, we never needed to distinguish between registers hidden
from userspace and being hidden from a guest (they are always
either visible to both, or hidden from both).

With NV, we have the ugly case of the EL{0,1}2 registers, which
are only a view on the EL{0,1} registers. It makes absolutely no
sense to expose them to userspace, since it already has the
canonical view.

Add a new visibility flag (REG_HIDDEN_USER) and a new helper that
checks for it and REG_HIDDEN when checking whether to expose
a sysreg to userspace. Subsequent patches will make use of it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c |  6 +++---
 arch/arm64/kvm/sys_regs.h | 12 +++++++++++-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 31d739d59f67..0c9bbe5eee5e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3031,7 +3031,7 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 		return get_invariant_sys_reg(reg->id, uaddr);
 
 	/* Check for regs disabled by runtime config */
-	if (sysreg_hidden(vcpu, r))
+	if (sysreg_hidden_user(vcpu, r))
 		return -ENOENT;
 
 	if (r->get_user)
@@ -3056,7 +3056,7 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 		return set_invariant_sys_reg(reg->id, uaddr);
 
 	/* Check for regs disabled by runtime config */
-	if (sysreg_hidden(vcpu, r))
+	if (sysreg_hidden_user(vcpu, r))
 		return -ENOENT;
 
 	if (r->set_user)
@@ -3127,7 +3127,7 @@ static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
 	if (!(rd->reg || rd->get_user))
 		return 0;
 
-	if (sysreg_hidden(vcpu, rd))
+	if (sysreg_hidden_user(vcpu, rd))
 		return 0;
 
 	if (!copy_reg_to_user(rd, uind))
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index cc0cc95a0280..850629f083a3 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -78,7 +78,8 @@ struct sys_reg_desc {
 };
 
 #define REG_HIDDEN		(1 << 0) /* hidden from userspace and guest */
-#define REG_RAZ			(1 << 1) /* RAZ from userspace and guest */
+#define REG_HIDDEN_USER		(1 << 1) /* hidden from userspace only */
+#define REG_RAZ			(1 << 2) /* RAZ from userspace and guest */
 
 static __printf(2, 3)
 inline void print_sys_reg_msg(const struct sys_reg_params *p,
@@ -138,6 +139,15 @@ static inline bool sysreg_hidden(const struct kvm_vcpu *vcpu,
 	return r->visibility(vcpu, r) & REG_HIDDEN;
 }
 
+static inline bool sysreg_hidden_user(const struct kvm_vcpu *vcpu,
+				      const struct sys_reg_desc *r)
+{
+	if (likely(!r->visibility))
+		return false;
+
+	return r->visibility(vcpu, r) & (REG_HIDDEN | REG_HIDDEN_USER);
+}
+
 static inline bool sysreg_visible_as_raz(const struct kvm_vcpu *vcpu,
 					 const struct sys_reg_desc *r)
 {
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
