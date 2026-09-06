Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E242E7623
	for <kvmarm@lists.linux.dev>; Sun,  6 Sep 2026 13:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788699736; cv=none; b=imY3nfuX0Onw2AdoMUi6TbqNgla2qV4LBTuA7GyL0LAXP1htaoPPBrXstiHy0iPXBnvLGPH0t/nCalnwtdKT/nK+m/rAtvRpk2Jq+SCZNDAe6OBDsc6VtjYrhjhz8ii5wPC696uSPd40INInb604E0yoSO9oLXrV8wTGm8IWkYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788699736; c=relaxed/simple;
	bh=SL7KSLOVnOiXvOm2ScZarE9e8mOLSuHEMTpnQa02NWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y3EcCd3FGQv+LY4BlCzjeRsJ1vwsDKKNoaEkwIXvfa1K9BSIJnFacu41p3YIIt+1vUZEdfh83rrLPfKyvG2R/4quSrb8IGjquVyMD14v5aYzlhhj9wtVs0wd1CmjgO0sPreeajr4jZUcH35Cok4rXYboREKHFzAM/A/0RRoOgUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=H7HH1kbR; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="H7HH1kbR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788699724; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nWlIJmD0HPwJ35ujSThXX3BByP+6GX+If6pUuoC+n4M=;
	b=H7HH1kbR1DJxvSZoMDqq5uKwSpt76UnNlfda2s/Rr6hm96Axg+WFWZMWOUZwyKc6NqFfrks1wTpX5mwzf/+bWvpUpWhPKbRvNJjol0TvOxkq3GSHXyrc/4MqQ64ZyC1S1G6LmmdzOeyDp4bQzj+hvGqTrAIPG/nxr6Y3xWST+/s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XAN1JSC_1788699722;
Received: from 30.100.134.114(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0XAN1JSC_1788699722 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 06 Sep 2026 21:02:03 +0800
Message-ID: <1cca51a6-4315-43da-8400-837ee2196d15@linux.alibaba.com>
Date: Sun, 6 Sep 2026 21:02:01 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/6] KVM: arm64: nv: Implement nested stage-2 reverse
 map (new data structure)
To: Marc Zyngier <maz@kernel.org>
Cc: Wei-Lin Chang <weilin.chang@arm.com>, Wang Han
 <wanghan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, oupton@kernel.org,
 tabba@google.com, joey.gouly@arm.com, seiden@linux.ibm.com,
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org,
 ljs@kernel.org, itaru.kitayama@fujitsu.com
References: <20260810205038.118843-1-weilin.chang@arm.com>
 <20260902163500.1841671-1-wanghan@linux.alibaba.com>
 <877bl26aqg.wl-maz@kernel.org>
 <wsnf276xrun3g4hjr3t6alprapctg5z4kpj422v3hujqdjnrsa@swq4blkqvvj5>
 <46342b48-550e-42c1-9d9f-e800c72269c2@linux.alibaba.com>
 <874ig55u5h.wl-maz@kernel.org>
 <f2357ad9-ece1-4331-844d-5911baaf571f@linux.alibaba.com>
 <87o6ea4q67.wl-maz@kernel.org>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <87o6ea4q67.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/6/26 6:42 PM, Marc Zyngier wrote:
> On Sat, 05 Sep 2026 16:35:01 +0100,
> Shuai Xue <xueshuai@linux.alibaba.com> wrote:
>>
>>
>>
>> On 9/4/26 3:54 PM, Marc Zyngier wrote:
>>> On Fri, 04 Sep 2026 08:01:24 +0100,
>>> Shuai Xue <xueshuai@linux.alibaba.com> wrote:
>>>>
>>>>
>>>>
>>>> On 9/3/26 9:28 PM, Wei-Lin Chang wrote:
>>>>> On Thu, Sep 03, 2026 at 08:43:35AM +0100, Marc Zyngier wrote:
>>>>>> On Wed, 02 Sep 2026 17:35:00 +0100,
>>>>>> Wang Han <wanghan@linux.alibaba.com> wrote:
>>>>>>>
>>>>>>> Hi Wei-Lin,
>>>>>>>
>>>>>>> I tested this series on a Yitian 710 system with an ARM Neoverse-N2 CPU
>>>>>>> (128 CPUs, 2 NUMA nodes).
>>>>>>>
>>>>>>> Test environment
>>>>>>> ----------------
>>>>>>>
>>>>>>>      L0 kernel: Linux v7.2-rc6
>>>>>>>      L1 guest: Ubuntu 26.04 LTS, kernel 7.0.0-27-generic (aarch64)
>>>>>>>      QEMU: 10.2.3
>>>>>>>
>>>>>>> L0 NUMA balancing was enabled (`/proc/sys/kernel/numa_balancing=1`).
>>>>>>> The host was booted with `kvm_arm.mode=nested`.
>>>>>>>
>>>>>>> This series fixes a functional hang that is exposed when NUMA balancing is
>>>>>>> enabled.  The previous nested stage-2 unmap path is too slow for this
>>>>>>> workload, making the performance problem user-visible: NUMA balancing can
>>>>>>> leave the L1 guest unable to make progress and eventually hang during boot.
>>>>>>>
>>>>>>> The L1 was started with 8 vCPUs and 32 GiB of RAM using:
>>>>>>>
>>>>>>>      qemu-system-aarch64 -smp 8 -m 32G \
>>>>>>>        -machine virt,accel=kvm,gic-version=3,virtualization=on \
>>>>>>>        -cpu host -nographic -enable-kvm \
>>>>>>>        -drive if=pflash,format=raw,readonly=on,file=pflash0_bak.img \
>>>>>>>        -drive if=pflash,format=raw,file=pflash1_bak.img \
>>>>>>>        -drive file=./ubuntu-vm.qcow2,format=qcow2,if=virtio,cache=none,aio=native \
>>>>>>>        -nic user,model=virtio-net-pci,hostfwd=tcp::11234-:22 \
>>>>>>>        -serial mon:stdio
>>>>>>>
>>>>>>
>>>>>> Puzzling. If you are only running an L1 in VHE mode, there is no
>>>>>> shadow S2, and therefore nothing to unmap. For shadow S2s to be built
>>>>>> and affect the MMU notifiers, you need to run an L2.
>>>>>
>>>>> I was thinking the same at first, but realized even with L1 in VHE mode
>>>>> there is a small period of time where L1 runs in its EL1 during boot, so
>>>>> one nested MMU will become valid for each vCPU. That causes
>>>>> kvm_nested_s2_unmap() to iterate through the entire IPA space 8 times
>>>>> (-smp 8).
>>>>>
>>>>> What I am curious about is whether one single notifier unmap is enough
>>>>> to hang L1, or were there multiple notifier unmaps.
>>>>>
>>>>> QEMU with -machine virt uses 40 IPA bits only, unmapping that takes:
>>>>> 1024  (4KB pages,  unmapping 1GB per iteration)
>>>>> 32768 (16KB pages, unmapping 32MB per iteration)
>>>>> 2048  (64KB pages, unmapping 512MB per iteration)
>>>>> iterations for each page size. There aren't many mappings in each
>>>>> iteration too. Does this really take that long on real hardware (even if
>>>>> this must be done 8 times)?
>>>>>
>>>>> Thanks,
>>>>> Wei-Lin Chang
>>>>>
>>>>>>
>>>>>> So what are your actual test conditions?
>>>>>>
>>>>>> 	M.
>>>>>>
>>>>
>>>> Hi, Wei-Lin and Marc,
>>>>
>>>> I was able to reproduce this issue and capture ftrace evidence that confirms
>>>> the root cause. Below is the analysis, trace log, and timing data.
>>>
>>> [...]
>>>
>>>> Each set_migration_pte line is a single-page NUMA migration. Yet each
>>>> migration triggers one full kvm_nested_s2_unmap() that takes 877 ms.
>>>
>>> And why is it taking so long? It should be *empty* after the first
>>> iteration.
>>
>> Good question.
>>
>> After dive into the details trace, let to try to answer the question.
>>
>> Yes, it is empty -- and that is exactly the point: the 877ms is paid *for*
>> an empty table.
>>
>> The cost is not in the walk and not in clearing PTEs;
>> **it is 262,144 broadcast TLB invalidations**, one at the end of every
>> 1GB chunk, each ~3.3us. Since v6.6 the cost of an unmap is
>> proportional to the size of the IPA range, not to the number of
>> mappings; an empty table pays in full.
>>
>>>
>>> [...]
>>>
>>>> ## Conclusion
>>>>
>>>> The root cause is confirmed: kvm_nested_s2_unmap() performs a full IPA space
>>>> unmap in the MMU notifier path instead of unmapping only the affected
>>>> GPA/CPAI range. The interval-tree-based precise range unmap approach is the
>>>> right fix.
>>>
>>> No. This just indicates that this is papering over a bigger problem,
>>> and your AI is jumping to conclusions.
>>
>> Sorry for the jumping up.
>>
>> The culprit is 7657ea920c54 ("KVM: arm64: Use TLBI range-based
>> instructions for unmap", v6.6). kvm_pgtable_stage2_unmap() ends
>> *every* call with an unconditional kvm_tlb_flush_vmid_range(), whether
>> or not the walk cleared a single PTE:
>>
>>          ret = kvm_pgtable_walk(pgt, addr, size, &walker);
>>          if (stage2_unmap_defer_tlb_flush(pgt))
>>                  /* Perform the deferred TLB invalidations */
>>                  kvm_tlb_flush_vmid_range(pgt->mmu, addr, size);
>>
>> stage2_apply_range() calls it once per 1GB chunk, and the nested MMU
>> covers the guest PARange -- 48 bits here, so 262,144 calls per
>> kvm_nested_s2_unmap(). Each broadcast is one IPAS2E1IS (range) plus one VMALLE1IS
>> plus two DSB(ish), ~3.2-3.4us without ftrace:
>>
>>          877ms / 262,144 chunks = 3.35us per chunk
>>
>> which is exactly the per-broadcast cost.
> 
> Right. That's pretty compelling, thanks for digging into this. Your
> proposed approach (counting the invalidated regions) is interesting,
> but I don't think it is the correct one.
> 
> The real issue here is that we treat a full S2 unmap as if it was a
> set of ranges. This is what needs fixing, because we can invalidate
> the whole thing with exactly *ONE* TLBI.

Aha, I see your point. Nice insight.

> 
> This is even more important once you run an L2, as L1 will also
> perform its own TLB invalidation, and we want to avoid having trapping
> pointlessly. This also propagates in the way we handle TLB emulation.

Quite agree.

> 
> [...]
> 
>> The candidate fix is below. Table entries
>> (KVM_PGTABLE_WALK_TABLE_POST) are unaffected: stage2_unmap_put_pte()
>> keeps issuing the immediate __kvm_tlb_flush_vmid_ipa() for them, and
>> their child leaves are counted as leaves within the same walk, so any
>> call that clears something still flushes a superset of what it
>> cleared. This restores the pre-v6.6 semantics -- cost proportional to
>> what is mapped. With it, an empty nested unmap costs ~110ms
>> instrumented (the pure walk); getting to "exactly zero" would
>> additionally require kvm_nested_s2_unmap() to skip nested MMUs that
>> are valid but empty.
> 
> That's an interesting remark. I guess we could add some extra tracking
> for that, but let's see what we can do about the above first.
> 
> I've hacked something together and pushed the result at [1]
> (compile-tested only). I'd appreciate it if you could put it to the
> test with your setup.
> 
> Thanks,
> 
> 	M.
> 
> [1] https://web.git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/unmap-vmall


Sure, I will test your proposed approach and update latter.

Thanks.
Shuai

