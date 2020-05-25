Return-Path: <SRS0=u+QM=7H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B159DC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 11:25:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4258020787
	for <kvmarm@archiver.kernel.org>; Mon, 25 May 2020 11:25:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4258020787
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A15BB4B1D8;
	Mon, 25 May 2020 07:25:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q4MGKmtwFz7x; Mon, 25 May 2020 07:25:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7336E4B1C3;
	Mon, 25 May 2020 07:25:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 080374B1C1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 07:25:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7PeZP5nwPAkl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 May 2020 07:25:08 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 502414B1BC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 May 2020 07:25:08 -0400 (EDT)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 5A106A0EB3F34B6CB6FB;
 Mon, 25 May 2020 19:25:04 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.173.221.230) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Mon, 25 May 2020 19:24:54 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
Subject: [RFC PATCH 0/7] kvm: arm64: Support stage2 hardware DBM
Date: Mon, 25 May 2020 19:23:59 +0800
Message-ID: <20200525112406.28224-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Alexios Zavras <alexios.zavras@intel.com>, Mark Brown <broonie@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Thomas
 Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
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

This patch series add support for stage2 hardware DBM, and it is only
used for dirty log for now.

It works well under some migration test cases, including VM with 4K
pages or 2M THP. I checked the SHA256 hash digest of all memory and
they keep same for source VM and destination VM, which means no dirty
pages is missed under hardware DBM.

However, there are some known issues not solved.

1. Some mechanisms that rely on "write permission fault" become invalid,
   such as kvm_set_pfn_dirty and "mmap page sharing".

   kvm_set_pfn_dirty is called in user_mem_abort when guest issues write
   fault. This guarantees physical page will not be dropped directly when
   host kernel recycle memory. After using hardware dirty management, we
   have no chance to call kvm_set_pfn_dirty.

   For "mmap page sharing" mechanism, host kernel will allocate a new
   physical page when guest writes a page that is shared with other page
   table entries. After using hardware dirty management, we have no chance
   to do this too.

   I need to do some survey on how stage1 hardware DBM solve these problems.
   It helps if anyone can figure it out.

2. Page Table Modification Races: Though I have found and solved some data
   races when kernel changes page table entries, I still doubt that there
   are data races I am not aware of. It's great if anyone can figure them out.

3. Performance: Under Kunpeng 920 platform, for every 64GB memory, KVM
   consumes about 40ms to traverse all PTEs to collect dirty log. It will
   cause unbearable downtime for migration if memory size is too big. I will
   try to solve this problem in Patch v1.

Keqian Zhu (7):
  KVM: arm64: Add some basic functions for hw DBM
  KVM: arm64: Set DBM bit of PTEs if hw DBM enabled
  KVM: arm64: Traverse page table entries when sync dirty log
  KVM: arm64: Steply write protect page table by mask bit
  kvm: arm64: Modify stage2 young mechanism to support hw DBM
  kvm: arm64: Save stage2 PTE dirty info if it is coverred
  KVM: arm64: Enable stage2 hardware DBM

 arch/arm64/include/asm/kvm_host.h     |   1 +
 arch/arm64/include/asm/kvm_mmu.h      |  44 +++++-
 arch/arm64/include/asm/pgtable-prot.h |   1 +
 arch/arm64/include/asm/sysreg.h       |   2 +
 arch/arm64/kvm/reset.c                |   9 +-
 virt/kvm/arm/arm.c                    |   6 +-
 virt/kvm/arm/mmu.c                    | 202 ++++++++++++++++++++++++--
 7 files changed, 246 insertions(+), 19 deletions(-)

-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
