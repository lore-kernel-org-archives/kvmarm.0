Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 865FF24A078
	for <kvmarm@lists.linux.dev>; Sun, 12 Jul 2026 14:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783867838; cv=none; b=jWT4fcNQPZQO0BioowHKH7bsKgSOorGtJE0PSZpZzXpK3bM0IFw6iApyXShrKjGza4yGbnOZGTRDVBXe9Z9WhlQyDRNevvbQjD/Jo7hekSS/AoofgDLxrguaypBfOTRLLtyTxgT1NHughxG/aZwKe1g3SsqA36fYMYwsgVM2xzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783867838; c=relaxed/simple;
	bh=O6mKBMmKqYsfl7n4c5R+GT1oCANMK99LD9U/tz2vSjw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kO5PA2lbk+lPa9+jZfDO4juHpn0Fq9jS4N4obRpiKti5DZitfekW8Rm051SGoNihqwl4+IhlYivpM1y9a8k7jFLvXxMGCzgCRvH/7ga4yk4RCNiB7ACxJDTg3c0I4qtzuCCbcn6VT7+AG8aIHN9BLxZiZdGVNY5l2IDfOq6dDxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=D/jWB2/e; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="D/jWB2/e"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 500E71684;
	Sun, 12 Jul 2026 07:50:31 -0700 (PDT)
Received: from [10.163.128.224] (unknown [10.163.128.224])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9E9B23F7B4;
	Sun, 12 Jul 2026 07:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783867835; bh=O6mKBMmKqYsfl7n4c5R+GT1oCANMK99LD9U/tz2vSjw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=D/jWB2/eTX0HY+XgoYivSzjTMakYQ0k7CVE0G5XpJ+MxvFhPF7nSiytewu45QmGOz
	 360fT3M1HJrX0we4eSyeQTDq6NC88sSMQcuyqHhbFnS0qH2JZqmns5weuMHQgn0eDA
	 B/vPu9fywGIpXIncX4dtKf2iNYtASgE5Dh6AXxyc=
Message-ID: <3cb5f1d7-f1cb-44bc-925c-85b5b6909b64@arm.com>
Date: Sun, 12 Jul 2026 20:20:28 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] Optimize S2 page splitting
To: Leonardo Bras <leo.bras@arm.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
 Raghavendra Rao Ananta <rananta@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260708134101.2514759-1-leo.bras@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260708134101.2514759-1-leo.bras@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 08/07/26 7:10 pm, Leonardo Bras wrote:
> While playing with dirty-bit tracking, I decided to take a look on how page
> splitting works. Found out all entries are walked, even though we can infer,
> for instance that:
> - If a level-3 entry is walked, it means the parent level-2 entry is split
> - If a split just succeeded in an table entry, it means all children nodes
>   are already split

That does not happen for force_pte = false right? Or is it guaranteed that
in your case that force_pte = true always?
> 
> This patches' idea is to introduce new walking flags to skip pagetable
> levels 0-3.
> 
> The idea of skipping child nodes was also tested, but it was marginally
> slower than just skipping levels, so it was discarted.
> 
> Optimization measured on two scenarios involving eager-splitting on a
> VM with 32 memslot of 2GB (total 64GB), and vcpu per slot:
> - Scenario 1: No manual protect, whole memslot split at dirty-track enable
>   (KVM_SET_USER_MEMORY_REGION2 ioctl with KVM_MEM_LOG_DIRTY_PAGES)
>   - Split happens only once, whole region
>   - Evalutes improved batch performance of splitting
> - Scenario 2: Manual protect, split happens during every dirty-bit clean
>   (KVM_CLEAR_DIRTY_LOG ioctl), average for 2 iterations.
>   - Split called multiple times, for smaller 64-page sections.
>   - Evaluate improved performance for multiple calls
> 
> Scenario 1, improvement on dirty-track enable ioctl for the memslot:
> - Memory was already split (4k pages):  -43.18% runtime (stdev 3.87%)
> - THP backed memory:                    -25.77% runtime (stdev 1.01%)
> - 64x1GB hugetlb memory:                -25.62% runtime (stdev 1.09%)
> 
> Scenario 2, improvement on dirty-log clean ioctl for the memslot:
> - Memory was already split (4k pages):  -39.88% runtime (stdev 2.71%)
> - THP backed memory:                    -25.18% runtime (stdev 0.32%)
> - 64x1GB hugetlb memory:                -49.17% runtime (stdev 1.86%)
> 
> For collecting above numbers, the following script was ran in both vanilla
> and patched kernels, with kernel parameter 'default_hugepagesz=1G', on an
> TX2 with 128GB RAM.
> 
> --- dirty_test.sh
> #!/bin/bash
> filename=$(uname -r |cut -d'-' -f 4-)
> 
> run_test(){
>   base_test="./dirty_log_perf_test -b 2G -v 32 -m 6 -m 8"
> 
>   # Manual cleaning disable
>   ${base_test} -g
>   ${base_test} -g -s anonymous_thp
>   echo 64 > /proc/sys/vm/nr_hugepages  
>   ${base_test} -g -s shared_hugetlb
>   echo 0 > /proc/sys/vm/nr_hugepages
> 
>   # Manual cleaning enable
>   ${base_test}
>   ${base_test} -s anonymous_thp
>   echo 64 > /proc/sys/vm/nr_hugepages  
>   ${base_test} -s shared_hugetlb
>   echo 0 > /proc/sys/vm/nr_hugepages
> }
> 
> run_test 2>&1 | tee ${filename}
> ---
> 
> Above dirty_log_perf_test command is the standard kvm selftest found in the
> kernel tree. It tested the following guest modes:
> Testing guest mode: PA-bits:40,  VA-bits:48,  4K pages
> Testing guest mode: PA-bits:40,  VA-bits:48, 64K pages
> (Modes with PA-bits:36 were discarted in this version, given the amount
> of RAM being used for testing, and the similarity of previous results)
> 
> Performance numbers from above modes were used to calculate average and
> stdev showed in the optimization results.
> 
> Changes since v2:
> - Rebased on top of v7.2-rc1
> - Improved testing, added more memory, re-tested
>   - Now: 32 vcpus @ total of 64G
>   - Before: 1cpu @ 16G
> 
> Changes since v1:
> - Fixed inverted flag verification priority (Sashiko)
> - Fixed incorrectly skipping POST call if level was skipped (Sashiko), and to that
> - New pre-patch that changes goto-out -> return to avoid re-testing walk_continue 
> v1 Link: https://lore.kernel.org/lkml/20260610202112.2695205-2-leo.bras@arm.com/
> 
> Changes since RFC:
> - Changed approach from return value to walk flags (Will Deacon)
> - Discarted skip_child approach (Oliver Upton)
> - Measured in real hardware, and from userspace perspective (Marc Zyngier)
> - Better explanation of what and how numbers were collected
> RFC Link: https://lore.kernel.org/all/20260515195904.2466381-1-leo.bras@arm.com/
> 
> Thanks!
> Leo
> 
> 
> Leonardo Bras (3):
>   KVM: arm64: Avoid re-testing walk_continue
>   KVM: arm64: Introduce KVM_PGTABLE_WALK_SKIP_LEVEL* walk flags
>   KVM: arm64: Make stage2_split_walker() skip unnecessary walks
> 
>  arch/arm64/include/asm/kvm_pgtable.h | 13 +++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 28 +++++++++++++++++++++-------
>  2 files changed, 34 insertions(+), 7 deletions(-)
> 
> 
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482

