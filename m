Return-Path: <SRS0=Zs50=IS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1615C433E2
	for <kvmarm@archiver.kernel.org>; Sat, 20 Mar 2021 13:28:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7237761966
	for <kvmarm@archiver.kernel.org>; Sat, 20 Mar 2021 13:28:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7237761966
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46D0D4B20A;
	Sat, 20 Mar 2021 09:28:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ILzqPLOhTuLc; Sat, 20 Mar 2021 09:28:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B2AD4B2DD;
	Sat, 20 Mar 2021 09:28:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EA7F4B65D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 12:18:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3gxbM+VVBFR1 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 12:18:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FB6F4B606
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 12:18:03 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C38E9113E;
 Fri, 19 Mar 2021 09:18:02 -0700 (PDT)
Received: from yoan-MS-7758.Home (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 583FD3F718;
 Fri, 19 Mar 2021 09:18:01 -0700 (PDT)
From: Yoan Picchi <yoan.picchi@arm.com>
To: maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH 3/7] KVM: arm64: Add cached_page_invalidated counter for
 kvm_stat
Date: Fri, 19 Mar 2021 16:17:07 +0000
Message-Id: <20210319161711.24972-4-yoan.picchi@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210319161711.24972-1-yoan.picchi@arm.com>
References: <20210319161711.24972-1-yoan.picchi@arm.com>
X-Mailman-Approved-At: Sat, 20 Mar 2021 09:28:53 -0400
Cc: catalin.marinas@arm.com, Yoan Picchi <yoan.picchi@arm.com>, will@kernel.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Add some counter for when a dpage get invalidated. The counter isn't
in the function that actually do it though because it doesn't have
either a kvm or vcpu argument, so we would have no way to access the
counters. For this reason, the counter have been added to the calling
functions instead.

Signed-off-by: Yoan Picchi <yoan.picchi@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/guest.c            | 1 +
 arch/arm64/kvm/mmu.c              | 5 ++++-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 863603285..3609aa89d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -547,6 +547,7 @@ static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 
 struct kvm_vm_stat {
 	ulong remote_tlb_flush;
+	ulong cached_page_invalidated;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 1029976ca..f6b1f0b63 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -41,6 +41,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("regular_page_mapped", regular_page_mapped),
 	VCPU_STAT("huge_page_mapped", huge_page_mapped),
 	VM_STAT("remote_tlb_flush", remote_tlb_flush),
+	VM_STAT("cached_page_invalidated", cached_page_invalidated),
 	VCPU_STAT("exits", exits),
 	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
 	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 55d7fe63b..d6ddf5ab8 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -893,8 +893,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (writable)
 		prot |= KVM_PGTABLE_PROT_W;
 
-	if (fault_status != FSC_PERM && !device)
+	if (fault_status != FSC_PERM && !device) {
 		clean_dcache_guest_page(pfn, vma_pagesize);
+		kvm->stat.cached_page_invalidated++;
+	}
 
 	if (exec_fault) {
 		prot |= KVM_PGTABLE_PROT_X;
@@ -1166,6 +1168,7 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 	 * just like a translation fault and clean the cache to the PoC.
 	 */
 	clean_dcache_guest_page(pfn, PAGE_SIZE);
+	kvm->stat.cached_page_invalidated++;
 	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pfn);
 	return 0;
 }
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
