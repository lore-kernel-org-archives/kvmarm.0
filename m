Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1682C38A2B
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:46:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 842ED4B3D9;
	Thu, 19 May 2022 09:46:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yWTIxCUz1aKW; Thu, 19 May 2022 09:46:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6604F4B447;
	Thu, 19 May 2022 09:46:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 184654B3B8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:46:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JgcVsKkSW1Ol for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:46:13 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF1BB4B44E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:46:13 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D1E38B824D9;
 Thu, 19 May 2022 13:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E8FC385B8;
 Thu, 19 May 2022 13:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967971;
 bh=gNfFOi6pd5y/KMC1EENc0l08zoMIj4rMl1P1lAcHzmI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=u6nFRAbTKYWiGRYq2O+qFR9S7ODm9TBeMw0yMLdLvLR/o74yXsoLWW4DrFBKaSsT1
 0vsUeJ2J5x3lKmZDM3DzioeP03cx9RPsw4ayjkiazraeWQUPpTssdRZoZkAnQWplWJ
 IGrc6LSRZSXv6xum3n3ZBXvddcMIRhK6yXDbCbKEyRoCNwR5xwfMMYElYbbIiKW4DE
 aGwDDY8rDzdvBJ+hPY3BBZJq2fiIDkR1n0vaS7ObwSB1jFR3ViSsYmzo0ISSwIhX+w
 h96nvNClKHlT7x0CSd29JeyzM5Jai4cwvnVa7Zbc1hfw6O94eQP+YNvqmR0BHHfEC/
 lCuQ55bVYcFsw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 57/89] KVM: arm64: Trap debug break and watch from guest
Date: Thu, 19 May 2022 14:41:32 +0100
Message-Id: <20220519134204.5379-58-will@kernel.org>
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

Debug and trace are not currently supported for protected guests, so
trap accesses to the related registers and emulate them as RAZ/WI.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c     |  2 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index c0403416ce1d..cd0712e13ab0 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -108,7 +108,7 @@ static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
 
 	/* Trap Debug */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), feature_ids))
-		mdcr_set |= MDCR_EL2_TDRA | MDCR_EL2_TDA | MDCR_EL2_TDE;
+		mdcr_set |= MDCR_EL2_TDRA | MDCR_EL2_TDA;
 
 	/* Trap OS Double Lock */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_DOUBLELOCK), feature_ids))
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index ddea42d7baf9..e732826f9624 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -356,6 +356,17 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	/* Cache maintenance by set/way operations are restricted. */
 
 	/* Debug and Trace Registers are restricted. */
+	RAZ_WI(SYS_DBGBVRn_EL1(0)),
+	RAZ_WI(SYS_DBGBCRn_EL1(0)),
+	RAZ_WI(SYS_DBGWVRn_EL1(0)),
+	RAZ_WI(SYS_DBGWCRn_EL1(0)),
+	RAZ_WI(SYS_MDSCR_EL1),
+	RAZ_WI(SYS_OSLAR_EL1),
+	RAZ_WI(SYS_OSLSR_EL1),
+	RAZ_WI(SYS_OSDLR_EL1),
+
+	/* Group 1 ID registers */
+	RAZ_WI(SYS_REVIDR_EL1),
 
 	/* AArch64 mappings of the AArch32 ID registers */
 	/* CRm=1 */
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
