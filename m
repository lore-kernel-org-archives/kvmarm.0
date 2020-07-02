Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB416C433DF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 13:57:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 79F7F20772
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 13:57:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79F7F20772
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32ABB4B45E;
	Thu,  2 Jul 2020 09:57:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8-RQ9EPMknAK; Thu,  2 Jul 2020 09:57:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 129884B608;
	Thu,  2 Jul 2020 09:57:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB4274B47D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 09:57:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CuMtuOGeJ7Vo for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 09:57:12 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 881B64B589
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 09:57:11 -0400 (EDT)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 913E96BE24CEBCEA50BE;
 Thu,  2 Jul 2020 21:56:10 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Jul 2020 21:56:00 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
Subject: [PATCH v2 0/8] KVM: arm64: Support HW dirty log based on DBM
Date: Thu, 2 Jul 2020 21:55:48 +0800
Message-ID: <20200702135556.36896-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Steven Price <steven.price@arm.com>, liangpeng10@huawei.com,
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

This patch series add support for dirty log based on HW DBM.

It works well under some migration test cases, including VM with 4K
pages or 2M THP. I checked the SHA256 hash digest of all memory and
they keep same for source VM and destination VM, which means no dirty
pages is missed under hardware DBM.

Some key points:

1. Only support hardware updates of dirty status for PTEs. PMDs and PUDs
   are not involved for now.

2. About *performance*: In RFC patch, I have mentioned that for every 64GB
   memory, KVM consumes about 40ms to scan all PTEs to collect dirty log.
   This patch solves this problem through two ways: HW/SW dynamic switch
   and Multi-core offload.

   HW/SW dynamic switch: Give userspace right to enable/disable hw dirty
   log. This adds a new KVM cap named KVM_CAP_ARM_HW_DIRTY_LOG. We can
   achieve this by change the kvm->arch.vtcr value and kick vCPUs out to
   reload this value to VCTR_EL2. Then userspace can enable hw dirty log
   at the begining and disable it when dirty pages is little and about to
   stop VM, so VM downtime is not affected.

   Multi-core offload: Offload the PT scanning workload to multi-core can
   greatly reduce scanning time. To promise we can complete in time, I use
   smp_call_fuction to realize this policy, which utilize IPI to dispatch
   workload to other CPUs. Under 128U Kunpeng 920 platform, it just takes
   about 5ms to scan PTs of 256 RAM (use mempress and almost all PTs have
   been established). And We dispatch workload iterately (every CPU just
   scan PTs of 512M RAM for each iteration), so it won't affect physical
   CPUs seriously.

3. About correctness: Only add DBM bit when PTE is already writable, so
   we still have readonly PTE and some mechanisms which rely on readonly
   PTs are not broken.

4. About PTs modification races: There are two kinds of PTs modification.
   
   The first is adding or clearing specific bit, such as AF or RW. All
   these operations have been converted to be atomic, avoid covering
   dirty status set by hardware.
   
   The second is replacement, such as PTEs unmapping or changement. All
   these operations will invoke kvm_set_pte finally. kvm_set_pte have
   been converted to be atomic and we save the dirty status to underlying
   bitmap if dirty status is coverred.

Change log:

v2:
 - Address Steven's comments.
 - Add support of parallel dirty log sync.
 - Simplify and merge patches of v1.

v1:
 - Address Catalin's comments.

Keqian Zhu (8):
  KVM: arm64: Set DBM bit for writable PTEs
  KVM: arm64: Scan PTEs to sync dirty log
  KVM: arm64: Modify stage2 young mechanism to support hw DBM
  KVM: arm64: Save stage2 PTE dirty status if it is covered
  KVM: arm64: Steply write protect page table by mask bit
  KVM: arm64: Add KVM_CAP_ARM_HW_DIRTY_LOG capability
  KVM: arm64: Sync dirty log parallel
  KVM: Omit dirty log sync in log clear if initially all set

 arch/arm64/include/asm/kvm_host.h |   5 +
 arch/arm64/include/asm/kvm_mmu.h  |  43 ++++-
 arch/arm64/kvm/arm.c              |  45 ++++-
 arch/arm64/kvm/mmu.c              | 307 ++++++++++++++++++++++++++++--
 arch/arm64/kvm/reset.c            |   5 +
 include/uapi/linux/kvm.h          |   1 +
 tools/include/uapi/linux/kvm.h    |   1 +
 virt/kvm/kvm_main.c               |   3 +-
 8 files changed, 389 insertions(+), 21 deletions(-)

-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
