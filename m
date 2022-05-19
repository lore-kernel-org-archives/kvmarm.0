Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2182C47080
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:46:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57DB44B448;
	Thu, 19 May 2022 09:46:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aBTbRqyZBW1h; Thu, 19 May 2022 09:46:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A6FC4B3D9;
	Thu, 19 May 2022 09:46:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C36AF4B440
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:46:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qqRLAxOCHC7H for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:46:05 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 884464B424
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:46:05 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id BA7C9B824AE;
 Thu, 19 May 2022 13:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F12C36AE3;
 Thu, 19 May 2022 13:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967963;
 bh=7ZFIfc31Ljwo59UHFdAV6Hez2rIIXtc9xnETxzvgDvc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=hNozO7SAuAmOJdzhDHTWB9npt/YWIKfntAwQlt+/2AvOsFzCQNebP/51xqpn41wk1
 96KzcgKZXipkIg24qNupD07sJ2r64RuIRxqqo1tJ2a32q2UXrSAldrnfIb98VURoY5
 YUYDNmr873wEVy0bboxF855tUenGFoqND3EUw0sweETF5f59IHlF51rMLc61GSPmvT
 WPb1ZTT5+2GypfGQPtEo94PyYFeAAyMP4yA+Gg6VuN1n8ZAyngEJ+zHZK0izgZbvRi
 W8oSNpgO9c0UAULEJ5YJQY0ncWOdyZtoKVrCaIJwwq6kStQ/pz+YT2diOGExHV+yM/
 nfjt/yA+6Accw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 55/89] KVM: arm64: Do not pass the vcpu to
 __pkvm_host_map_guest()
Date: Thu, 19 May 2022 14:41:30 +0100
Message-Id: <20220519134204.5379-56-will@kernel.org>
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

__pkvm_host_map_guest() always applies to the loaded vcpu in hyp, and
should not trust the host to provide the vcpu.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 15 ++++-----------
 arch/arm64/kvm/mmu.c               |  6 +++---
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e82c0faf6c81..0f1c9d27f6eb 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -445,20 +445,15 @@ static void handle___pkvm_host_map_guest(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(u64, pfn, host_ctxt, 1);
 	DECLARE_REG(u64, gfn, host_ctxt, 2);
-	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 3);
-	struct kvm_shadow_vcpu_state *shadow_state;
+	struct kvm_vcpu *host_vcpu;
 	struct kvm_vcpu *shadow_vcpu;
-	struct kvm *host_kvm;
-	unsigned int handle;
+	struct kvm_shadow_vcpu_state *shadow_state;
 	int ret = -EINVAL;
 
 	if (!is_protected_kvm_enabled())
 		goto out;
 
-	host_vcpu = kern_hyp_va(host_vcpu);
-	host_kvm = kern_hyp_va(host_vcpu->kvm);
-	handle = host_kvm->arch.pkvm.shadow_handle;
-	shadow_state = pkvm_load_shadow_vcpu_state(handle, host_vcpu->vcpu_idx);
+	shadow_state = pkvm_loaded_shadow_vcpu_state();
 	if (!shadow_state)
 		goto out;
 
@@ -468,11 +463,9 @@ static void handle___pkvm_host_map_guest(struct kvm_cpu_context *host_ctxt)
 	/* Topup shadow memcache with the host's */
 	ret = pkvm_refill_memcache(shadow_vcpu, host_vcpu);
 	if (ret)
-		goto out_put_state;
+		goto out;
 
 	ret = __pkvm_host_share_guest(pfn, gfn, shadow_vcpu);
-out_put_state:
-	pkvm_put_shadow_vcpu_state(shadow_state);
 out:
 	cpu_reg(host_ctxt, 1) =  ret;
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c74c431588a3..137d4382ed1c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1143,9 +1143,9 @@ static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 	return 0;
 }
 
-static int pkvm_host_map_guest(u64 pfn, u64 gfn, struct kvm_vcpu *vcpu)
+static int pkvm_host_map_guest(u64 pfn, u64 gfn)
 {
-	int ret = kvm_call_hyp_nvhe(__pkvm_host_map_guest, pfn, gfn, vcpu);
+	int ret = kvm_call_hyp_nvhe(__pkvm_host_map_guest, pfn, gfn);
 
 	/*
 	 * Getting -EPERM at this point implies that the pfn has already been
@@ -1211,7 +1211,7 @@ static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	write_lock(&kvm->mmu_lock);
 	pfn = page_to_pfn(page);
-	ret = pkvm_host_map_guest(pfn, fault_ipa >> PAGE_SHIFT, vcpu);
+	ret = pkvm_host_map_guest(pfn, fault_ipa >> PAGE_SHIFT);
 	if (ret) {
 		if (ret == -EAGAIN)
 			ret = 0;
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
