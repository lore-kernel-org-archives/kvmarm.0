From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] kvm: arm: Fix handling of stage2 huge mappings
Date: Wed, 20 Mar 2019 17:31:54 +0000
Message-ID: <20190320173154.6cfc7072@why.wild-wind.fr.eu.org>
References: <1553093839-29317-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553093839-29317-1-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will.deacon@arm.com, catalin.marinas@arm.com, james.morse@arm.com, julien.thierry@arm.com, wanghaibin.wang@huawei.com, lious.lilei@hisilicon.com, lishuo1@hisilicon.com, zhengxiang9@huawei.com, yuzenghui@huawei.com, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 20 Mar 2019 14:57:19 +0000
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> We rely on the mmu_notifier call backs to handle the split/merge
> of huge pages and thus we are guaranteed that, while creating a
> block mapping, either the entire block is unmapped at stage2 or it
> is missing permission.
> 
> However, we miss a case where the block mapping is split for dirty
> logging case and then could later be made block mapping, if we cancel the
> dirty logging. This not only creates inconsistent TLB entries for
> the pages in the the block, but also leakes the table pages for
> PMD level.
> 
> Handle this corner case for the huge mappings at stage2 by
> unmapping the non-huge mapping for the block. This could potentially
> release the upper level table. So we need to restart the table walk
> once we unmap the range.
> 
> Fixes : ad361f093c1e31d ("KVM: ARM: Support hugetlbfs backed huge pages")
> Reported-by: Zheng Xiang <zhengxiang9@huawei.com>
> Cc: Zheng Xiang <zhengxiang9@huawei.com>
> Cc: Zhenghui Yu <yuzenghui@huawei.com>
       ^
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Applied, with Zenghui's name fixed.

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
