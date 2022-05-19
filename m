Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA3CC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:46:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 072904B463;
	Thu, 19 May 2022 09:46:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NgCfF8QxESNF; Thu, 19 May 2022 09:46:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D57AD4B451;
	Thu, 19 May 2022 09:46:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4E094B439
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:46:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G37jeubXNHSf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:46:25 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4FD1F4B3B8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:46:25 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 780F5B824B1;
 Thu, 19 May 2022 13:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA50BC34115;
 Thu, 19 May 2022 13:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967983;
 bh=cg4GGkz5VYYPNfvIkui5Wg//bUy2NhL/r1SMWT/4qu0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=RC/YM0rrlPAWNXrjxTqesx/9CykjZXla6WqnKSun5FTL1+uWRcBQ9cenJlHQBRHZR
 tQGQXJ/ppFFPr6ROExzf/VRelMZyGGW51NRdP0ymjPI+XojertlUu46l/ZOgBkE5vb
 RVUIdv57Iui2Vt1raoanPXux+g4GObELiXuxPqiiycM6Ld/PvP5gWZbuVA8pgvsbsV
 kiyISHfLFvhz+EN39iFiw7MbWnfNSdo5bVmmM+eywI7HDy9JS5gd2jsfIp2XUwy5Wp
 sjv+F/58jBe8qGkJN+o4UlT6nJjYcVgQk7UFeIWzB6cTOuBnwE4/uYQtr+kTOIFypD
 zMQVMgQUEHiAg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 60/89] KVM: arm64: Refactor reset_mpidr to extract its
 computation
Date: Thu, 19 May 2022 14:41:35 +0100
Message-Id: <20220519134204.5379-61-will@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

Move the computation of the mpidr to its own function in a shared
header, as the computation will be used by hyp in protected mode.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/sys_regs.c | 14 +-------------
 arch/arm64/kvm/sys_regs.h | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7886989443b9..d2b1ad662546 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -598,19 +598,7 @@ static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 
 static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
-	u64 mpidr;
-
-	/*
-	 * Map the vcpu_id into the first three affinity level fields of
-	 * the MPIDR. We limit the number of VCPUs in level 0 due to a
-	 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
-	 * of the GICv3 to be able to address each CPU directly when
-	 * sending IPIs.
-	 */
-	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
-	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
-	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
-	vcpu_write_sys_reg(vcpu, (1ULL << 31) | mpidr, MPIDR_EL1);
+	vcpu_write_sys_reg(vcpu, calculate_mpidr(vcpu), MPIDR_EL1);
 }
 
 static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index cc0cc95a0280..9b32772f398e 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -183,6 +183,25 @@ find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
 	return __inline_bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
 }
 
+static inline u64 calculate_mpidr(const struct kvm_vcpu *vcpu)
+{
+	u64 mpidr;
+
+	/*
+	 * Map the vcpu_id into the first three affinity level fields of
+	 * the MPIDR. We limit the number of VCPUs in level 0 due to a
+	 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
+	 * of the GICv3 to be able to address each CPU directly when
+	 * sending IPIs.
+	 */
+	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
+	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
+	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
+	mpidr |= (1ULL << 31);
+
+	return mpidr;
+}
+
 const struct sys_reg_desc *find_reg_by_id(u64 id,
 					  struct sys_reg_params *params,
 					  const struct sys_reg_desc table[],
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
