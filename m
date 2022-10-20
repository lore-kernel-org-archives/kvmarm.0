Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B56E2C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 09:16:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D70B4B90D;
	Thu, 20 Oct 2022 05:16:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 943+JScNyJ8z; Thu, 20 Oct 2022 05:16:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E5094B942;
	Thu, 20 Oct 2022 05:16:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66DB94B90D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 05:16:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GlMgIOvdjvmm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 05:16:31 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D5384B861
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 05:16:31 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id E964C61A78;
 Thu, 20 Oct 2022 09:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1E0C4314A;
 Thu, 20 Oct 2022 09:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666257389;
 bh=RmR/p9NMvWhySJcBYEuynetHT+9duFiGXLr3+FZK1/4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=RB0hdNECSeaieJ80Nn9f3b8+CaPE17k9Woel2LsDOIq41t8uL04vyXJdsgbqNiNyE
 Kpt2A1lNhDJE9u6Dkzo/TT1BKEyTBuclvLGTRdfRRnK9ycUqinK5sU6ZkU6u0C9G8n
 CqZ1pdalst+mqnbcofYvYJP4Vmm+Hx89W5vlmEGTLpfaiMx+KuWIHBiicAB6KAKzlW
 Iaop7Ly1mG596bs6amO2tbJUkSSNMWY9aBDkqbVTMtNwAsUdzgIEy6hxLM15V3cGGe
 C6e95JibgX1NpZaqih9JuQBbdEcTN9oPCpW0rNNE5py1mFXNfom6QtkdHiQFBSy25I
 IGhzSl6WKBGLQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1olRWc-000Buf-C7;
 Thu, 20 Oct 2022 10:07:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 15/17] KVM: arm64: Force HCR_E2H in guest context when
 ARM64_KVM_HVHE is set
Date: Thu, 20 Oct 2022 10:07:25 +0100
Message-Id: <20221020090727.3669908-16-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090727.3669908-1-maz@kernel.org>
References: <20221020090727.3669908-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>
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

Also make sure HCR_EL2.E2H is set when switching HCR_EL2 in guest
context.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c       | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 82a9af885f2e..9fd952361d2e 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -64,7 +64,7 @@ static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
-	if (is_kernel_in_hyp_mode())
+	if (has_vhe() || has_hvhe())
 		vcpu->arch.hcr_el2 |= HCR_E2H;
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN)) {
 		/* route synchronous external abort exceptions to EL2 */
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index d58314461595..2864037eaf8b 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -35,6 +35,9 @@ static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
 	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AdvSIMD),
 				PVM_ID_AA64PFR0_ALLOW));
 
+	if (has_hvhe())
+		hcr_set |= HCR_E2H;
+
 	/* Trap RAS unless all current versions are supported */
 	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_RAS), feature_ids) <
 	    ID_AA64PFR0_EL1_RAS_V1P1) {
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
