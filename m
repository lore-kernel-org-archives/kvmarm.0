Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663613803DF
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 06:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789368269; cv=none; b=qb3fiWZspoB7Hg2DikgmJh/MFtCYdP46XKGDdhUp5Py6UtL2P9MmNu9W5fr0WGm5bDO3s8vldgDn9sBLI2FEXPCW6oXu1ppp4QlQcfysxZeub7MajWbTMxNhnicQYu52l7/py1oS4DhCm8BE/6LWcpCCB5x3oTNNniFf5CdeGa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789368269; c=relaxed/simple;
	bh=Wd+IhzUMNqudeorIJuhR9ZmngqyRXrIKFSbROvJ+2+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qy02OBAyo/QaGDbXbw0/ExG2ARrBNB6hnUNJIR/IPhqYokXGgU/Dwrqm2ynU4mgTnRivm5ZRzdjEnZWMvATwVB01HKnj4REF6+KRXWn2bor6aIo5uEU/689J8Pj0Io6LCbdsCHdxjuyOJZg+3IEmNytJhhsIxejDWSQ1U4cP/yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=UHhgVyfl; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="UHhgVyfl"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789368257; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=R1MRlh6AE092pgDrBOK7zH37nTa3jlHIh7copY4WYSo=;
	b=UHhgVyfl/lrgx0RaZ5SrQ+rkICOx0jSrMqVwzU0J8YKeWaP/aihUhF7CgBlA1QJFpaF9JZvzy762pNZLarDGyH+00tcKcRVKuSZLsYoH7MtmfLR8NrmgZgPPL0yu5VX5gOCXdxrVViGMN7c3wf3YTDRV7zv8gvOxdo371ChbD7Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0XArjucF_1789368256;
Received: from 30.246.177.179(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0XArjucF_1789368256 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 14 Sep 2026 14:44:16 +0800
Message-ID: <8bf3f266-06fd-49e0-8de8-33c7a044e997@linux.alibaba.com>
Date: Mon, 14 Sep 2026 14:44:15 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] KVM: arm64: Reduce overhead of full S2 teardown
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: Wei-Lin Chang <weilin.chang@arm.com>, Wang Han
 <wanghan@linux.alibaba.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
 Fuad Tabba <fuad.tabba@linux.dev>
References: <20260912104834.3093878-1-maz@kernel.org>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <20260912104834.3093878-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/12/26 6:48 PM, Marc Zyngier wrote:
> Tearing down a full S2 is a pretty involved process, resulting in a
> lot of TLB invalidation. These TLBIs are either on a per leaf basis if
> the HW doesn't support range invalidation, or by top-level range if it
> does. Amusingly, the latter occurs even when nothing has been
> unmapped.
> 
> Things are made worse with NV, as we have a bucket-load of shadow S2s,
> and the need to invalidate them all on the back of an MMU notifier.
> The latter will eventually be solved by the reverse-map tracking that
> Wei-Lin is working on, but we need to be better at full-S2 teardown.
> 
> This small series adds a "no TLBI" unmapping primitive, which allows
> the caller to then whack the TLBs using a VMID-wide invalidation. This
> results in far fewer TLBIs, and a better recursive virtualisation as
> we get far fewer traps as a consequence.
> 
> This applies on top of my shadow-s2 lifetime fixes, and is expected to
> be a prefix to Wei-Lin's series.
> 
> Marc Zyngier (4):
>    KVM: arm64: pgtable: Add Stage-2 unmap without TLBI primitive
>    KVM: arm64: MMU: Add kvm_stage2_unmap_all() helper
>    KVM: arm64: nv: Move full s2_mmu unmap over to kvm_stage2_unmap_all()
>    KVM: arm64: nv: Move TLBI VMALLS12E1* emulation over to
>      kvm_stage2_unmap_all()
> 
>   arch/arm64/include/asm/kvm_mmu.h     |  1 +
>   arch/arm64/include/asm/kvm_pgtable.h | 17 +++++++++++++
>   arch/arm64/include/asm/kvm_pkvm.h    |  1 +
>   arch/arm64/kvm/hyp/pgtable.c         | 38 +++++++++++++++++++++-------
>   arch/arm64/kvm/mmu.c                 | 15 +++++++++++
>   arch/arm64/kvm/nested.c              |  4 +--
>   arch/arm64/kvm/pkvm.c                |  2 ++
>   arch/arm64/kvm/sys_regs.c            | 18 ++++++-------
>   8 files changed, 75 insertions(+), 21 deletions(-)
> 


Hi Marc,

Thanks for putting this series together. I reviewed the four patches
and revisited the traces from my earlier Marc-only tests.

I have a correctness concern about child page-table reclamation.

1. Child page-table reclamation before the final TLBI

In patch 1, SKIP_S2_TLBI suppresses invalidation for both leaf and table
descriptors, while stage2_unmap_walker() still immediately releases
empty child tables.

For a child table with page_count(childp) == 1, the sequence is:

   stage2_unmap_walker()
     stage2_unmap_put_pte()
       clear the parent table descriptor
       skip its TLBI
     mm_ops->put_page(childp)
       kvm_s2_put_page()
         put_page()              /* drop the child's last reference */

   ... process the remaining address ranges ...

   __kvm_tlb_flush_vmid()         /* final invalidation in patch 2 */

This path does not use the free_unlinked_table()/call_rcu() deferred
reclamation mechanism. The existing deferred-range-TLBI path still
invalidates table descriptors immediately; the new flag skips that
invalidation too.

Patch 4 provides a caller operating on active shadow MMUs:
kvm_s2_mmu_iterate_by_vmid() holds mmu_lock for write and visits valid
matching shadow MMUs, but does not require refcnt == 0 or wait for
other vCPUs using the MMU to exit.

Another vCPU can therefore still use that shadow S2. The write lock
excludes software page-table updates, not hardware table walks.
The following interleaving is allowed:

   vCPU B / hardware walker        vCPU A
   ------------------------        ----------------------------
   Holds an old reference to T
                                   Clears parent, skips TLBI
                                   Drops T's last reference
                                   T is reused by the allocator
   Accesses T via the old reference
                                   Performs final VMID-wide TLBI

The final flush barriers cannot retroactively protect a table that
has already been freed and reused.

Is there a lifetime guarantee for these active-MMU callers that I
have missed? Otherwise, the corresponding invalidation needs to
complete before the child table's memory can be reused.

Retaining table-descriptor TLBI looks like a smaller correction
that would still remove empty-range TLBI amplification. Batching
those invalidations as well would require deferred child-table
reclamation, accounting for the lock drop/reacquisition boundaries
in the may_block path.

Thanks.
Shuai
