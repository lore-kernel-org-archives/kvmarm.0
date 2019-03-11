From: Zheng Xiang <zhengxiang9@huawei.com>
Subject: [RFC] Question about TLB flush while set Stage-2 huge pages
Date: Tue, 12 Mar 2019 00:31:10 +0800
Message-ID: <5f712cc6-0874-adbe-add6-46f5de24f36f@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA4294A3FE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Mar 2019 12:31:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9OYbyGkz6HbU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Mar 2019 12:31:39 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 82E554A321
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Mar 2019 12:31:39 -0400 (EDT)
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, suzuki.poulose@arm.com, james.morse@arm.com
Cc: lishuo1@hisilicon.com, linux-kernel@vger.kernel.org, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, lious.lilei@hisilicon.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi all,

While a page is merged into a transparent huge page, KVM will invalidate Stage-2 for
the base address of the huge page and the whole of Stage-1.
However, this just only invalidates the first page within the huge page and the other
pages are not invalidated, see bellow:

    +---------------+--------------+
    |abcde       2MB-Page          |
    +---------------+--------------+

    TLB before setting new pmd:
    +---------------+--------------+
    |      VA       |    PAGESIZE  |
    +---------------+--------------+
    |      a        |      4KB     |
    +---------------+--------------+
    |      b        |      4KB     |
    +---------------+--------------+
    |      c        |      4KB     |
    +---------------+--------------+
    |      d        |      4KB     |
    +---------------+--------------+

    TLB after setting new pmd:
    +---------------+--------------+
    |      VA       |    PAGESIZE  |
    +---------------+--------------+
    |      a        |      2MB     |
    +---------------+--------------+
    |      b        |      4KB     |
    +---------------+--------------+
    |      c        |      4KB     |
    +---------------+--------------+
    |      d        |      4KB     |
    +---------------+--------------+

When VM access *b* address, it will hit the TLB and result in TLB conflict aborts or other potential exceptions.

For example, we need to keep tracking of the VM memory dirty pages when VM is in live migration.
KVM will set the memslot READONLY and split the huge pages.
After live migration is canceled and abort, the pages will be merged into THP.
The later access to these pages which are READONLY will cause level-3 Permission Fault until they are invalidated.

So should we invalidate the tlb entries for all relative pages(e.g a,b,c,d), like __flush_tlb_range()?
Or we can call __kvm_tlb_flush_vmid() to invalidate all tlb entries.



-- 

Thanks,
Xiang
