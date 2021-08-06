Return-Path: <SRS0=sKrJ=M5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC9CC4338F
	for <kvmarm@archiver.kernel.org>; Fri,  6 Aug 2021 11:31:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A2C6960FE7
	for <kvmarm@archiver.kernel.org>; Fri,  6 Aug 2021 11:31:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A2C6960FE7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 413114B0E0;
	Fri,  6 Aug 2021 07:31:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aCCp4-YcJVNd; Fri,  6 Aug 2021 07:31:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C56EC4B0C1;
	Fri,  6 Aug 2021 07:31:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 822044B0CB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Aug 2021 07:31:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id meGdpR6V+zZa for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Aug 2021 07:31:34 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5ACFC4B0D0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Aug 2021 07:31:34 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5675761050;
 Fri,  6 Aug 2021 11:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628249491;
 bh=M9UB+bjgdI6GkTumogq6PmtB5wmIP3agM0PRxyG7pzs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=d99YBEzt7kgHJGXAqHCa0xdR9wp3Ia4JNvUYZgbwVAnr1+j3UI7DUz5N/PnFO6Dvg
 G/Lel3sJ23OXZk2Rqp91807gWTJ4dR+VLIEOnSvxWOGZeztENE1OjfljYjyA/G3ODJ
 H6ZBhMl8nIivSnxz9anaDw2QHJorMpPn+SZSFQID2kI0OWOUAblpuTjb86R1qCQuCn
 WHzUrXMvfiGIu9Z7hJMuCa5zZDQ9LcsPsrWomvQtBQvamPwpSj23f1IKKIyIH+H6PS
 aY3vnrawjp509cZqN4+n3o0fiBn8yWn0OZpnCN51tw7UuA/BV5ohyjzaJHtvTfbsNr
 KADY24c/a0nSw==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/4] KVM: arm64: Upgrade VMID accesses to {READ,WRITE}_ONCE
Date: Fri,  6 Aug 2021 12:31:08 +0100
Message-Id: <20210806113109.2475-6-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210806113109.2475-1-will@kernel.org>
References: <20210806113109.2475-1-will@kernel.org>
MIME-Version: 1.0
Cc: linux-arch@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Jade Alglave <jade.alglave@arm.com>
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

Since TLB invalidation can run in parallel with VMID allocation,
we need to be careful and avoid any sort of load/store tearing.
Use {READ,WRITE}_ONCE consistently to avoid any surprise.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jade Alglave <jade.alglave@arm.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_mmu.h      | 7 ++++++-
 arch/arm64/kvm/arm.c                  | 2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 4 ++--
 arch/arm64/kvm/mmu.c                  | 2 +-
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 934ef0deff9f..5828dd8fa738 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -252,6 +252,11 @@ static inline int kvm_write_guest_lock(struct kvm *kvm, gpa_t gpa,
 
 #define kvm_phys_to_vttbr(addr)		phys_to_ttbr(addr)
 
+/*
+ * When this is (directly or indirectly) used on the TLB invalidation
+ * path, we rely on a previously issued DSB so that page table updates
+ * and VMID reads are correctly ordered.
+ */
 static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
 {
 	struct kvm_vmid *vmid = &mmu->vmid;
@@ -259,7 +264,7 @@ static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
 	u64 cnp = system_supports_cnp() ? VTTBR_CNP_BIT : 0;
 
 	baddr = mmu->pgd_phys;
-	vmid_field = (u64)vmid->vmid << VTTBR_VMID_SHIFT;
+	vmid_field = (u64)READ_ONCE(vmid->vmid) << VTTBR_VMID_SHIFT;
 	return kvm_phys_to_vttbr(baddr) | vmid_field | cnp;
 }
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e9a2b8f27792..658f76067f46 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -571,7 +571,7 @@ static void update_vmid(struct kvm_vmid *vmid)
 		kvm_call_hyp(__kvm_flush_vm_context);
 	}
 
-	vmid->vmid = kvm_next_vmid;
+	WRITE_ONCE(vmid->vmid, kvm_next_vmid);
 	kvm_next_vmid++;
 	kvm_next_vmid &= (1 << kvm_get_vmid_bits()) - 1;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d4e74ca7f876..55ae97a144b8 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -109,8 +109,8 @@ int kvm_host_prepare_stage2(void *pgt_pool_base)
 	mmu->pgd_phys = __hyp_pa(host_kvm.pgt.pgd);
 	mmu->arch = &host_kvm.arch;
 	mmu->pgt = &host_kvm.pgt;
-	mmu->vmid.vmid_gen = 0;
-	mmu->vmid.vmid = 0;
+	WRITE_ONCE(mmu->vmid.vmid_gen, 0);
+	WRITE_ONCE(mmu->vmid.vmid, 0);
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3155c9e778f0..b1a6eaec28ff 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -485,7 +485,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	mmu->arch = &kvm->arch;
 	mmu->pgt = pgt;
 	mmu->pgd_phys = __pa(pgt->pgd);
-	mmu->vmid.vmid_gen = 0;
+	WRITE_ONCE(mmu->vmid.vmid_gen, 0);
 	return 0;
 
 out_destroy_pgtable:
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
