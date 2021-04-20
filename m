Return-Path: <SRS0=sayA=JR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF5AEC43460
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 13:34:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 613F26113C
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 13:34:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 613F26113C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0F2E4B39F;
	Tue, 20 Apr 2021 09:34:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4uLPTTFEqTsx; Tue, 20 Apr 2021 09:34:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 861CE4B3D3;
	Tue, 20 Apr 2021 09:34:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FED24B342
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 09:08:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jGkopj19dKa7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Apr 2021 09:08:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBDC44B399
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 09:08:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 50B6514BF;
 Tue, 20 Apr 2021 06:08:47 -0700 (PDT)
Received: from yoan-MS-7758.Home (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EA5FB3F792;
 Tue, 20 Apr 2021 06:08:45 -0700 (PDT)
From: Yoan Picchi <yoan.picchi@arm.com>
To: maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 2/3] KVM: arm64: Add two page mapping counters for kvm_stat
Date: Tue, 20 Apr 2021 14:08:24 +0100
Message-Id: <20210420130825.15585-3-yoan.picchi@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210420130825.15585-1-yoan.picchi@arm.com>
References: <20210420130825.15585-1-yoan.picchi@arm.com>
X-Mailman-Approved-At: Tue, 20 Apr 2021 09:34:06 -0400
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

This patch adds regular_page_mapped and huge_page_mapped.
regular_page_mapped is increased when a page of the smallest granularity
is mapped. This is usually a 4k, 16k or 64k page.
huge_page_mapped is increased when a huge page of any size other than the
smallest granularity is mapped.
Those counters only count pages allocated for the data and doesn't count
the pages/blocks allocated to the page tables as I don't see where those
might be needed to be recorded

I can see two usecases for those counters :
	We can detect memory pressure in the host when the guest gets
regular pages instead of huge ones.
	May help detecting an abnormal memory usage like some recurring
allocs past the kernel and a few program starts.
With the previous patch about stage2_abort_exit, it have the added
benefit of specifying the second main cause of stage 2 page fault (the
other being mmio access)

To test this patch I did start a guest VM and monitor the page allocation.
By default it only allocate huge pages. Then I tried to disable the huge
pages with : echo never > /sys/kernel/mm/transparent_hugepage/enabled
Starting the VM, it no longer allocate any huge page, but only regular
pages.

I can't log into the guess because it doesn't recognize my keyboard. To
circumvent that I added some command to the init script that need some
memory : cat /dev/zero | head -c 1000m | tail
This take 1GiB of memory before finishing.
From memory, it allocate 525 or so huge table which is around what I would
expect with 2MB pages.

I did check the relation between stage 2 exits, mmio exits and
allocation. The mmio + allocation account for almost all the stage 2 exit
as expected. There was only about 20 exits that was neither a mmio or an
alloc during the kernel boot. I did not look what they are, but it can be
a memory permission relaxation, or resizing a page.

My main concern here is about the case where we replace a page/block by
another/resize a block. I don't fully understand the mechanism yet and
so don't know if it should be counted as an allocation or not. For now I
don't account it.

Signed-off-by: Yoan Picchi <yoan.picchi@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/kvm/guest.c            | 2 ++
 arch/arm64/kvm/hyp/pgtable.c      | 5 +++++
 3 files changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 02891ce94..8f9d27571 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -547,6 +547,8 @@ static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 
 struct kvm_vm_stat {
 	ulong remote_tlb_flush;
+	ulong regular_page_mapped;
+	ulong huge_page_mapped;
 };
 
 struct kvm_vcpu_stat {
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 82a4b6275..41316b30e 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -42,6 +42,8 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("exits", exits),
 	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
 	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
+	VM_STAT("regular_page_mapped", regular_page_mapped),
+	VM_STAT("huge_page_mapped", huge_page_mapped),
 	{ NULL }
 };
 
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 4d177ce1d..2aba2b636 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -498,6 +498,11 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	smp_store_release(ptep, new);
 	get_page(page);
 	data->phys += granule;
+	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
+		data->mmu->kvm->stat.regular_page_mapped++;
+	else
+		data->mmu->kvm->stat.huge_page_mapped++;
+
 	return 0;
 }
 
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
