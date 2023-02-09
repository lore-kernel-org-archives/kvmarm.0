Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F65A920
	for <kvmarm@lists.linux.dev>; Thu,  9 Feb 2023 18:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B21C433EF;
	Thu,  9 Feb 2023 18:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675966244;
	bh=6XseaYrWthAt8FZx/5o+YR98uLeMrF9a6yo8YPl3f80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3H4kdN0/fszS2dOPvPwvPxvgOzizXZp76Oq+8FEf8/T+s09wH+u8JocNHbNfj7eg
	 PcHuC/HEoo8l7MtuZVw6vhqal2FZROOe5qM6HMXYmT250qxdv3Mf28nsL4P2KAJSRN
	 q4eWlzQ83HqV00TRK7axCmR3eWjz0VjdPQAM/yxx8fGUFE2AfDEa/PzlNSR+9QrKpX
	 mMwdhn/CWaVweyeX8OsPugBDClCq9xagKDJLeSrMyXnn1uDr7hnC+0mdFAzmdYhK/s
	 rtzQ/ISQrl8gb0CnCqhd17p06UquMiD0ealcTIO40t87olxS2b0KvngQ1yBbvuUsVl
	 /hxyLGXLLzOog==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pQBC5-0093r7-IA;
	Thu, 09 Feb 2023 17:58:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 15/18] KVM: arm64: nv: Allow a sysreg to be hidden from userspace only
Date: Thu,  9 Feb 2023 17:58:17 +0000
Message-Id: <20230209175820.1939006-16-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209175820.1939006-1-maz@kernel.org>
References: <20230209175820.1939006-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, catalin.marinas@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

So far, we never needed to distinguish between registers hidden
from userspace and being hidden from a guest (they are always
either visible to both, or hidden from both).

With NV, we have the ugly case of the EL02 and EL12 registers,
which are only a view on the EL0 and EL1 registers. It makes
absolutely no sense to expose them to userspace, since it
already has the canonical view.

Add a new visibility flag (REG_HIDDEN_USER) and a new helper that
checks for it and REG_HIDDEN when checking whether to expose
a sysreg to userspace. Subsequent patches will make use of it.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c |  6 +++---
 arch/arm64/kvm/sys_regs.h | 14 ++++++++++++--
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index de209059fd34..55a14c86a455 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2980,7 +2980,7 @@ int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 	int ret;
 
 	r = id_to_sys_reg_desc(vcpu, reg->id, table, num);
-	if (!r)
+	if (!r || sysreg_hidden_user(vcpu, r))
 		return -ENOENT;
 
 	if (r->get_user) {
@@ -3024,7 +3024,7 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 		return -EFAULT;
 
 	r = id_to_sys_reg_desc(vcpu, reg->id, table, num);
-	if (!r)
+	if (!r || sysreg_hidden_user(vcpu, r))
 		return -ENOENT;
 
 	if (sysreg_user_write_ignore(vcpu, r))
@@ -3118,7 +3118,7 @@ static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
 	if (!(rd->reg || rd->get_user))
 		return 0;
 
-	if (sysreg_hidden(vcpu, rd))
+	if (sysreg_hidden_user(vcpu, rd))
 		return 0;
 
 	if (!copy_reg_to_user(rd, uind))
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index e4ebb3a379fd..6b11f2cc7146 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -85,8 +85,9 @@ struct sys_reg_desc {
 };
 
 #define REG_HIDDEN		(1 << 0) /* hidden from userspace and guest */
-#define REG_RAZ			(1 << 1) /* RAZ from userspace and guest */
-#define REG_USER_WI		(1 << 2) /* WI from userspace only */
+#define REG_HIDDEN_USER		(1 << 1) /* hidden from userspace only */
+#define REG_RAZ			(1 << 2) /* RAZ from userspace and guest */
+#define REG_USER_WI		(1 << 3) /* WI from userspace only */
 
 static __printf(2, 3)
 inline void print_sys_reg_msg(const struct sys_reg_params *p,
@@ -152,6 +153,15 @@ static inline bool sysreg_hidden(const struct kvm_vcpu *vcpu,
 	return sysreg_visibility(vcpu, r) & REG_HIDDEN;
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
2.34.1

