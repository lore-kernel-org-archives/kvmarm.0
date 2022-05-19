Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C73C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:45:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4954D4B411;
	Thu, 19 May 2022 09:45:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XhMZF-SbiKvV; Thu, 19 May 2022 09:45:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 237554B3CB;
	Thu, 19 May 2022 09:45:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38B3E4086F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:45:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2OsoQA+8i5u1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:45:10 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 028FB4086C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:45:10 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 23F85B82477;
 Thu, 19 May 2022 13:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71080C34115;
 Thu, 19 May 2022 13:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967907;
 bh=2ZalBIGM7JSYFfLvIQUaX1p+ssc3QooHu98yjwP1v/w=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=eGFCCpT73KiD1pU7luVlg8x4AqHTP91+nIGFA6vsbv9NGUUUkM6+f+16s8HUDZHQV
 vib3XAT8a4KbKUo33Yk91wedCtFnD/jD+3kh4ArixrZMFbdJXggZi+fZTGobPhkxym
 HxB1fEHL+zBjjCeyswDIfjCcpZGRmcKRFq0Bg80PiA641hQBs94trYcE6W57o/mq4F
 yhgRvpnCL0gKXvKNxnsivpUBST6YKzv0AnQeKtQONM+ZFb0XmMS4hzSjLpQI/FRcfi
 YDP0BB2dBA2HFPlxYsK4f7ktQWBjEHFwSUjMbazeNcb+ekbd5pYJDAU4B+9AzBMWbm
 J1opVDsMFUTBA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 41/89] KVM: arm64: Make vcpu_{read,
 write}_sys_reg available to HYP code
Date: Thu, 19 May 2022 14:41:16 +0100
Message-Id: <20220519134204.5379-42-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

From: Marc Zyngier <maz@kernel.org>

Allow vcpu_{read,write}_sys_reg() to be called from EL2 so that nVHE hyp
code can reuse existing helper functions for operations such as
resetting the vCPU state.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 30 +++++++++++++++++++++++++++---
 arch/arm64/kvm/sys_regs.c         | 20 --------------------
 2 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9252841850e4..c55aadfdfd63 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -553,9 +553,6 @@ struct kvm_vcpu_arch {
 
 #define __vcpu_sys_reg(v,r)	(ctxt_sys_reg(&(v)->arch.ctxt, (r)))
 
-u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg);
-void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg);
-
 static inline bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
 {
 	/*
@@ -647,6 +644,33 @@ static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 	return true;
 }
 
+static inline u64 vcpu_arch_read_sys_reg(const struct kvm_vcpu_arch *vcpu_arch,
+					 int reg)
+{
+	u64 val = 0x8badf00d8badf00d;
+
+	/* sysregs_loaded_on_cpu is only used in VHE */
+	if (!is_nvhe_hyp_code() && vcpu_arch->sysregs_loaded_on_cpu &&
+	    __vcpu_read_sys_reg_from_cpu(reg, &val))
+		return val;
+
+	return ctxt_sys_reg(&vcpu_arch->ctxt, reg);
+}
+
+static inline void vcpu_arch_write_sys_reg(struct kvm_vcpu_arch *vcpu_arch,
+					   u64 val, int reg)
+{
+	/* sysregs_loaded_on_cpu is only used in VHE */
+	if (!is_nvhe_hyp_code() && vcpu_arch->sysregs_loaded_on_cpu &&
+	    __vcpu_write_sys_reg_to_cpu(val, reg))
+		return;
+
+	 ctxt_sys_reg(&vcpu_arch->ctxt, reg) = val;
+}
+
+#define vcpu_read_sys_reg(vcpu, reg) vcpu_arch_read_sys_reg(&((vcpu)->arch), reg)
+#define vcpu_write_sys_reg(vcpu, val, reg) vcpu_arch_write_sys_reg(&((vcpu)->arch), val, reg)
+
 struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
 };
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7b45c040cc27..7886989443b9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -68,26 +68,6 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
 	return false;
 }
 
-u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
-{
-	u64 val = 0x8badf00d8badf00d;
-
-	if (vcpu->arch.sysregs_loaded_on_cpu &&
-	    __vcpu_read_sys_reg_from_cpu(reg, &val))
-		return val;
-
-	return __vcpu_sys_reg(vcpu, reg);
-}
-
-void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
-{
-	if (vcpu->arch.sysregs_loaded_on_cpu &&
-	    __vcpu_write_sys_reg_to_cpu(val, reg))
-		return;
-
-	 __vcpu_sys_reg(vcpu, reg) = val;
-}
-
 /* 3 bits per cache level, as per CLIDR, but non-existent caches always 0 */
 static u32 cache_levels;
 
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
