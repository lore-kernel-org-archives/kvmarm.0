Return-Path: <SRS0=kREJ=EV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E9CC2D0E4
	for <kvmarm@archiver.kernel.org>; Sun, 15 Nov 2020 14:31:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C5B4520578
	for <kvmarm@archiver.kernel.org>; Sun, 15 Nov 2020 14:31:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5B4520578
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2866F4B954;
	Sun, 15 Nov 2020 09:31:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9wSmkXoK70d3; Sun, 15 Nov 2020 09:31:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 170E84BC95;
	Sun, 15 Nov 2020 09:31:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68B114BBC8
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Nov 2020 09:31:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DWkZ0zBCDq+x for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Nov 2020 09:31:41 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02E264B954
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Nov 2020 09:31:40 -0500 (EST)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CYvlb2S1Zz15JTD;
 Sun, 15 Nov 2020 22:31:23 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Sun, 15 Nov 2020 22:31:28 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
Subject: [RFC] vfio-pci/migration: Dirty logging of the Memory BAR region?
To: <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>
Message-ID: <fd18627a-e012-1af8-9d9f-9ae8a1415258@huawei.com>
Date: Sun, 15 Nov 2020 22:31:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Cc: Cornelia Huck <cohuck@redhat.com>, Kirti Wankhede <kwankhede@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi folks,

While trying the new vfio-pci migration on my arm64 server, I noticed an
error at the very beginning:

qemu-system-aarch64: kvm_set_user_memory_region: 
KVM_SET_USER_MEMORY_REGION failed, slot=5, start=0x8000000000, 
size=0x100000: Invalid argument

The reason is that we've registered the Memory BAR region as ram device
region (mr->ram_device is set) and tried to track dirty pages of this
region during migration.  QEMU tries to request tracking of it (via kvm
memory listener's log_start() callback) whilst KVM/arm64 clearly refuses
to do so [1]:

 > int kvm_arch_prepare_memory_region(struct kvm *kvm, ...)
 > {
 > 		/* IO region dirty page logging not allowed */
 > 		if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES) {
 > 			ret = -EINVAL;
 > 			goto out;
 > 		}
 > }

If I understand things correctly, the Memory BAR region generally
contains internal device-specific registers which shouldn't (and can't)
be tracked by QEMU's dirty logging mechanism.  I've patched QEMU with
the following diff and it seems work for me, but all of these still
require for comments.


diff --git a/softmmu/memory.c b/softmmu/memory.c
index 71951fe4dc..0958db1a08 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -1806,7 +1806,10 @@ bool memory_region_is_ram_device(MemoryRegion *mr)
  uint8_t memory_region_get_dirty_log_mask(MemoryRegion *mr)
  {
      uint8_t mask = mr->dirty_log_mask;
-    if (global_dirty_log && (mr->ram_block || 
memory_region_is_iommu(mr))) {
+    RAMBlock *rb = mr->ram_block;
+
+    if (global_dirty_log && ((rb && qemu_ram_is_migratable(rb)) ||
+                             memory_region_is_iommu(mr))) {
          mask |= (1 << DIRTY_MEMORY_MIGRATION);
      }
      return mask;


Thanks,
Zenghui

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/kvm/mmu.c
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
