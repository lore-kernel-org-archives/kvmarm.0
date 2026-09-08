Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873F152FE2C
	for <kvmarm@lists.linux.dev>; Tue,  8 Sep 2026 15:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788882256; cv=none; b=AREtuxTiNpLpNGPYqrqN2LTPZKmm2QmANvsQ+ckxsp1XYs5g98/cRiikdWti7e7q4iibSoegYCo8T9soqE+tAhITbgB/2xwyZOd2YU2LQnn3YKOELVl0J0HBChe+c95XM3FY132o0xfVIoS4ORcqhQsodHiDXZbkTktskcdWtNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788882256; c=relaxed/simple;
	bh=00wfOUVVmDGin75fzlCubPsIZG4mioA3oUnp9bRd8Uk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AUoTez4ttGYj0ssNAZTbkL4Wshh+TmumkYkkU26SJMKs8I+mvv16wqXBWkt0js+xzg1LgEu+fokt6T02tN6qsEZUYDm0gzbmzY11pxuzekJ0QfuYouOpbITuRfwlZcnn1D2ckRXQ3DjOy8GiccKEnXURssGZ/W+dirg4W4RWU3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=nWkVz4a/; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="nWkVz4a/"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788882249; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=moIJ5L+bC2j2KH91p1KtXumkwr+nJGgByBSZyudvL6g=;
	b=nWkVz4a/QKtrC6ucanv+3TjZGWRujcncEXHHDnghV314qQHYIAcVArm/NEuTu/HJXSoX0ou+9Ro8JQldHbaY5Dbq6606ZlhENiCRYP1+6cyn63sx8DjxcBaAz21/dvBXQD4auuPrzKTCnpoyQilz8I7MBwtxFYaJkITAMDvW/08=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XAcGtEq_1788882246;
Received: from 30.120.99.168(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0XAcGtEq_1788882246 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 08 Sep 2026 23:44:07 +0800
Message-ID: <6e004ee1-1daa-4165-966a-fe60a3fbd443@linux.alibaba.com>
Date: Tue, 8 Sep 2026 23:44:05 +0800
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
> 
> This is even more important once you run an L2, as L1 will also
> perform its own TLB invalidation, and we want to avoid having trapping
> pointlessly. This also propagates in the way we handle TLB emulation.
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


Hi Marc, Wei-Lin,

I have completed a controlled A/B test of Marc's
kvm-arm64/unmap-vmall branch and a local port of Wei-Lin's v5
interval-tree series on top of it.

TL;DR
=====

Marc's series successfully removes the per-chunk TLBI amplification:
no range TLBI is issued while walking the shadow stage-2, and each
completed full unmap ends with a single VMID-wide invalidation.

However, the reported soft lockup still reproduced in 13 out of 15
Marc-only rounds.

The remaining problem is that each small canonical MMU-notifier
invalidation is still promoted to a full-IPA software iteration. On
this 48-bit/4KB system, this means 262,144 no-TLBI chunks per valid
shadow MMU. Under frequent NUMA migrations, multiple full-unmap calls
become outstanding and are interleaved as stage2_apply_range()
periodically drops and reacquires mmu_lock.

With Wei-Lin's precise cIPA-to-NIPA lookup enabled, the same test
completed 15 out of 15 rounds without a soft lockup, while exercising
more than four million cIPA notifier calls.

Test setup
==========

Both variants used:

   - the same read-only golden L1 image;
   - a fresh qcow2 overlay and writable pflash copy for every round;
   - the same kernel configuration;
   - QEMU 10.2.3;
   - an 8-vCPU / 32-GiB L1;
   - automatic NUMA balancing enabled;
   - numad active;
   - no additional memory-pressure workload;
   - 15 rounds of 600 seconds per variant.

Every round verified the kernel commit, config and installed Image,
QEMU version, golden-image manifest, guest login, trace accounting,
BPF stderr, disk integrity and result manifest.

The tested revisions were:

   Marc-only:
     3b46d91c9aac2f9e8f0be58d0834b9932667af92

   Marc + Wei-Lin:
     d3fca181b5fadb86aeb35437c359dc09ad233f05

The latter is a local conflict-resolved validation port of Wei-Lin's
v5 interval-tree series on top of Marc's branch.

A/B results
===========

   Metric                            Marc-only        Marc + Wei-Lin
   ------------------------------------------------------------------
   Test rounds                       15               15
   Soft-lockup rounds                13               0
   Guest soft-lockup lines           71               0
   Guest RCU-stall lines             5                0
   L0 hung-task/soft-lockup lines    0                0

   kvm_nested_s2_unmap calls         776,896          0
   kvm_stage2_unmap_all calls        775,067          0
   Precise cIPA notifier calls       0                4,176,635

   Completed full-unmap intervals    773,911          0
   Total VMID-wide flush calls       773,937          0
   Range TLBI inside full unmap      0 (*)            N/A

   Successfully migrated pages       2,411,259        5,342,515
   Harness/manifest failures         0                0

(*) The absence of range TLBI inside Marc's full-unmap path was
     confirmed separately with function-graph tracing. The formal
     low-overhead batch correlated full-unmap completion with the final
     VMID-wide flush instead of probing the hot range-TLBI symbol.

Marc-only full-unmap behaviour
==============================

The formal trace records kvm_stage2_unmap_all() entry and correlates it
with the final __kvm_tlb_flush_vmid() on the same TID. Only successfully
paired intervals are used for latency and concurrency calculations.

The minimum per-round completion-pairing coverage was 99.3175%, and all
15 rounds passed the trace-accounting gate.

The following comparison separates the 13 lockup rounds from the two
rounds that completed 600 seconds without a lockup:

   Metric                         13 lockup rounds    2 non-lockup rounds
   -----------------------------------------------------------------------
   Completed full unmaps          551,786             222,125

   Peak outstanding unmaps        5--9                2--4
   Median peak                    7                   3

   Time with >=2 outstanding      1,115.3 s           5.94 s
   Fraction of activity window    37.4%               0.49%

   Time with >=4 outstanding      356.4 s             0.06 s
   Fraction of activity window    11.9%               ~0.005%

   Time with >=6 outstanding      34.74 s             0

   Mean completed duration        9.91 ms             5.46 ms
   Completed unmaps >=100 ms      8,514 (1.543%)      14 (0.006%)
   Completed unmaps >=250 ms      5,372 (0.974%)      0
   Completed unmaps >=500 ms      135                 0
   Maximum completed duration     946.97 ms           179.12 ms

In 12 of the 13 lockup rounds, the peak outstanding set included both
numad and QEMU threads. One of those rounds also included kcompactd1.
In the remaining lockup round, the peak consisted of six QEMU threads.

"Outstanding" does not mean that these threads held mmu_lock
simultaneously. kvm_stage2_unmap_all() is entered with the write lock
held, but stage2_apply_range() calls cond_resched_rwlock_write() between
chunks. This permits another waiting invocation to acquire the lock and
start or continue its own full-IPA operation before the previous
invocation has completed.

The trace therefore shows a full-unmap hand-off convoy, rather than a
single kvm_stage2_unmap_all() invocation remaining stuck for the entire
watchdog interval. This also explains why removing the expensive
per-chunk TLBIs substantially reduces individual work but does not
eliminate the soft lockup under a sufficiently high notifier rate.

Combined-kernel behaviour
=========================

With Wei-Lin's interval-tree path, every observed canonical notifier
invalidation used kvm_nested_unmap_cipa_range(). None entered
kvm_nested_s2_unmap(), kvm_stage2_unmap_all(), or the final VMALL path.

All 15 rounds completed without a guest soft lockup or RCU stall. Three
rounds successfully migrated approximately 2.106 million, 2.091 million
and 1.130 million pages respectively, so the notifier path was heavily
exercised.

My interpretation
=================

The results distinguish two separate amplification problems:

1. A true full shadow-stage-2 invalidation was implemented as many
    range TLBIs.

    Marc's series fixes this as intended by clearing the page tables
    without per-chunk TLBI and issuing one final VMID-wide invalidation.

2. A small canonical MMU-notifier invalidation is promoted to a full
    invalidation of every valid shadow stage-2.

    Marc's series does not change this policy. After the TLBI cost is
    removed, the repeated full-IPA software iteration and resulting
    overlap are still sufficient to reproduce the soft lockup.

For this workload, Wei-Lin's reverse map removes the second
amplification by translating the invalidated canonical IPA range into
only the affected nested IPA ranges.

I therefore think the two approaches are complementary:

   - use precise reverse-map invalidation for canonical MMU-notifier
     ranges; and
   - retain Marc's no-TLBI walk plus one VMALL for operations that
     genuinely require the complete shadow stage-2 to be invalidated.

The combined runs did not exercise the full-unmap/MMU-reuse paths, so
I am treating them as evidence for the notifier-path behaviour, not as
complete validation of every interaction between the two series.

I can provide the per-round summaries, manifests and raw BPF timelines
if useful.

Thanks,
Shuai
