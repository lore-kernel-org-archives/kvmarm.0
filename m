Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF024AF666
	for <kvmarm@lists.linux.dev>; Sat,  5 Sep 2026 15:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788622515; cv=none; b=ty+NRgtQNAFLJvbQcHLxm9U23udtZ9TW3NIw2kC2vOqWQS48yBffWMPK9dgm0rK0DFlRm9byK1HUwJX2pE/fBLtMfT/5efU6i3O9V5+qqwv/lwx3jMW+6faldmctICt+rpJAvTZ9Vak85iQVmE6Chwgi2ECeK2nHKdd3Hx+uGdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788622515; c=relaxed/simple;
	bh=SHdefSodIO7MzjKBdZ9aZERx/SO0uN8oMowo9phT/zw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Obdxw+5a7yxtcg2OMaM9Cxp50xHBpupv6t8kgE2bJ6Ebwe773GuAJNUBiExA5bSsot9Yxen5flDn3a5b2IOza0JGnxrJVdiFjooN0dJc2d0bmfM4z53BuvkppE61K6ExGQnXVoGPvZOJ5WCszRF7k+wfwL+RQ49HwFCM8GFlRe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=CC7Dbjze; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="CC7Dbjze"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788622503; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UYVjswq1RMR0z0XOex2YFUtZECzTttw9BI75rZybL+c=;
	b=CC7DbjzeiuBgRDvvdmPLEQVKrTD4HOjJoxGioVpb0+NFHuM4aoDRAdUp9nn63koEZ+rjh0YC138ig3aVJHl4Tw7dq2hCEdU3iBY0VPFZXPHKPNpovNXX99c6FE2+XRUep2V0GEVb7TzeIi5gTsQ3IPVFyDGsxUcC442kOf6m9no=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XALGi4E_1788622501;
Received: from 30.100.134.114(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0XALGi4E_1788622501 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 05 Sep 2026 23:35:02 +0800
Message-ID: <f2357ad9-ece1-4331-844d-5911baaf571f@linux.alibaba.com>
Date: Sat, 5 Sep 2026 23:35:01 +0800
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
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <874ig55u5h.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/4/26 3:54 PM, Marc Zyngier wrote:
> On Fri, 04 Sep 2026 08:01:24 +0100,
> Shuai Xue <xueshuai@linux.alibaba.com> wrote:
>>
>>
>>
>> On 9/3/26 9:28 PM, Wei-Lin Chang wrote:
>>> On Thu, Sep 03, 2026 at 08:43:35AM +0100, Marc Zyngier wrote:
>>>> On Wed, 02 Sep 2026 17:35:00 +0100,
>>>> Wang Han <wanghan@linux.alibaba.com> wrote:
>>>>>
>>>>> Hi Wei-Lin,
>>>>>
>>>>> I tested this series on a Yitian 710 system with an ARM Neoverse-N2 CPU
>>>>> (128 CPUs, 2 NUMA nodes).
>>>>>
>>>>> Test environment
>>>>> ----------------
>>>>>
>>>>>     L0 kernel: Linux v7.2-rc6
>>>>>     L1 guest: Ubuntu 26.04 LTS, kernel 7.0.0-27-generic (aarch64)
>>>>>     QEMU: 10.2.3
>>>>>
>>>>> L0 NUMA balancing was enabled (`/proc/sys/kernel/numa_balancing=1`).
>>>>> The host was booted with `kvm_arm.mode=nested`.
>>>>>
>>>>> This series fixes a functional hang that is exposed when NUMA balancing is
>>>>> enabled.  The previous nested stage-2 unmap path is too slow for this
>>>>> workload, making the performance problem user-visible: NUMA balancing can
>>>>> leave the L1 guest unable to make progress and eventually hang during boot.
>>>>>
>>>>> The L1 was started with 8 vCPUs and 32 GiB of RAM using:
>>>>>
>>>>>     qemu-system-aarch64 -smp 8 -m 32G \
>>>>>       -machine virt,accel=kvm,gic-version=3,virtualization=on \
>>>>>       -cpu host -nographic -enable-kvm \
>>>>>       -drive if=pflash,format=raw,readonly=on,file=pflash0_bak.img \
>>>>>       -drive if=pflash,format=raw,file=pflash1_bak.img \
>>>>>       -drive file=./ubuntu-vm.qcow2,format=qcow2,if=virtio,cache=none,aio=native \
>>>>>       -nic user,model=virtio-net-pci,hostfwd=tcp::11234-:22 \
>>>>>       -serial mon:stdio
>>>>>
>>>>
>>>> Puzzling. If you are only running an L1 in VHE mode, there is no
>>>> shadow S2, and therefore nothing to unmap. For shadow S2s to be built
>>>> and affect the MMU notifiers, you need to run an L2.
>>>
>>> I was thinking the same at first, but realized even with L1 in VHE mode
>>> there is a small period of time where L1 runs in its EL1 during boot, so
>>> one nested MMU will become valid for each vCPU. That causes
>>> kvm_nested_s2_unmap() to iterate through the entire IPA space 8 times
>>> (-smp 8).
>>>
>>> What I am curious about is whether one single notifier unmap is enough
>>> to hang L1, or were there multiple notifier unmaps.
>>>
>>> QEMU with -machine virt uses 40 IPA bits only, unmapping that takes:
>>> 1024  (4KB pages,  unmapping 1GB per iteration)
>>> 32768 (16KB pages, unmapping 32MB per iteration)
>>> 2048  (64KB pages, unmapping 512MB per iteration)
>>> iterations for each page size. There aren't many mappings in each
>>> iteration too. Does this really take that long on real hardware (even if
>>> this must be done 8 times)?
>>>
>>> Thanks,
>>> Wei-Lin Chang
>>>
>>>>
>>>> So what are your actual test conditions?
>>>>
>>>> 	M.
>>>>
>>
>> Hi, Wei-Lin and Marc,
>>
>> I was able to reproduce this issue and capture ftrace evidence that confirms
>> the root cause. Below is the analysis, trace log, and timing data.
> 
> [...]
> 
>> Each set_migration_pte line is a single-page NUMA migration. Yet each
>> migration triggers one full kvm_nested_s2_unmap() that takes 877 ms.
> 
> And why is it taking so long? It should be *empty* after the first
> iteration.

Good question.

After dive into the details trace, let to try to answer the question.

Yes, it is empty -- and that is exactly the point: the 877ms is paid *for*
an empty table.

The cost is not in the walk and not in clearing PTEs;
**it is 262,144 broadcast TLB invalidations**, one at the end of every
1GB chunk, each ~3.3us. Since v6.6 the cost of an unmap is
proportional to the size of the IPA range, not to the number of
mappings; an empty table pays in full.

> 
> [...]
> 
>> ## Conclusion
>>
>> The root cause is confirmed: kvm_nested_s2_unmap() performs a full IPA space
>> unmap in the MMU notifier path instead of unmapping only the affected
>> GPA/CPAI range. The interval-tree-based precise range unmap approach is the
>> right fix.
> 
> No. This just indicates that this is papering over a bigger problem,
> and your AI is jumping to conclusions.

Sorry for the jumping up.

The culprit is 7657ea920c54 ("KVM: arm64: Use TLBI range-based
instructions for unmap", v6.6). kvm_pgtable_stage2_unmap() ends
*every* call with an unconditional kvm_tlb_flush_vmid_range(), whether
or not the walk cleared a single PTE:

         ret = kvm_pgtable_walk(pgt, addr, size, &walker);
         if (stage2_unmap_defer_tlb_flush(pgt))
                 /* Perform the deferred TLB invalidations */
                 kvm_tlb_flush_vmid_range(pgt->mmu, addr, size);

stage2_apply_range() calls it once per 1GB chunk, and the nested MMU
covers the guest PARange -- 48 bits here, so 262,144 calls per
kvm_nested_s2_unmap(). Each broadcast is one IPAS2E1IS (range) plus one VMALLE1IS
plus two DSB(ish), ~3.2-3.4us without ftrace:

         877ms / 262,144 chunks = 3.35us per chunk

which is exactly the per-broadcast cost.

All numbers below are from
ftrace function_graph on the same workload as Wang Han reported
(Yitian 710, 128 CPUs, Neoverse-N2, L0 v7.2-rc6 with
kvm_arm.mode=nested, QEMU virt machine, 8 vCPUs / 32G, 4K host
pages), and can be checked against the trace (pre-change kernel, ~90s
window):

   $ grep -c 'kvm_nested_s2_unmap() {' trace.txt
   31                                        # callbacks in the window
   $ grep -c 'kvm_pgtable_stage2_unmap() {' trace.txt
   8476033                                   # one call per 1GB chunk
   $ grep -c '__kvm_tlb_flush_vmid_range();' trace.txt
   8476033                                   # one broadcast per chunk

The chunk count and the broadcast count are *equal*: every chunk call
ends in a broadcast, mapped or not. Per chunk, instrumented:

   kvm_pgtable_stage2_unmap()          median 5.097us
     kvm_tlb_flush_vmid_range()        median 4.645us
       __kvm_tlb_flush_vmid_range()    p50 4.0us / p90 5.0 / p99 6.25us

so ~4.6us of every ~5.1us chunk is the flush; the walk of the empty
chunk is ~0.4us. A representative uncontended episode, from the numad
thread that executes the unmap itself: 1312ms total, of which 1147ms
(87%) inside kvm_tlb_flush_vmid_range() and 106ms (8%) walking. And
only 289 of the 8,476,033 chunk calls (0.003%) exceed 20us -- there is
nothing in this table.

Raw sample, pre-change kernel (every chunk is a frame, because it
contains the traced flush):

   13)   numad-1888   |               |        kvm_pgtable_stage2_unmap() {
   13)   numad-1888   |               |          kvm_tlb_flush_vmid_range() {
   13)   numad-1888   |   3.240 us    |            __kvm_tlb_flush_vmid_range();
   13)   numad-1888   |   3.660 us    |          }
   13)   numad-1888   |   4.060 us    |        }


To confirm that the table is empty, we made the flush conditional on
the walk having actually cleared a valid leaf PTE (candidate fix
below; nothing else changes). The flush count then becomes a direct
detector of "did this chunk clear anything?":

- The first full-IPA unmap of the boot issued 2 flushes -- the
   boot-time EL1-period mappings, the few dozen pages you predicted,
   living in two 1GB chunks.
- All 35 subsequent full-IPA unmaps in that run issued *zero*
   flushes. So yes: empty after the first iteration, exactly as you
   say. Before the change, each of those empty iterations still cost
   877ms, because the broadcast does not depend on the walk having
   cleared anything.
- The same empty walk now measures 0.208us per chunk (median), i.e.
   ~55ms of traced chunk time for a full 48-bit sweep:

   24) qemu-sy-25907  |               |    kvm_nested_s2_unmap() {
   24) qemu-sy-25907  |               |      kvm_stage2_unmap_range() {
   24) qemu-sy-25907  |   2.740 us    |        kvm_pgtable_stage2_unmap();
   24) qemu-sy-25907  |   0.300 us    |        kvm_pgtable_stage2_unmap();
   24) qemu-sy-25907  |   0.260 us    |        kvm_pgtable_stage2_unmap();
   24) qemu-sy-25907  |   0.240 us    |        kvm_pgtable_stage2_unmap();

   while a canonical-S2 chunk that really does clear the migrated page
   still flushes:

   13) qemu-sy-25900  |               |  kvm_stage2_unmap_range() {
   13) qemu-sy-25900  |               |    kvm_pgtable_stage2_unmap() {
   13) qemu-sy-25900  |               |      kvm_tlb_flush_vmid_range() {
   13) qemu-sy-25900  |   4.180 us    |        __kvm_tlb_flush_vmid_range();
   13) qemu-sy-25900  |   4.780 us    |      }



The candidate fix is below. Table entries
(KVM_PGTABLE_WALK_TABLE_POST) are unaffected: stage2_unmap_put_pte()
keeps issuing the immediate __kvm_tlb_flush_vmid_ipa() for them, and
their child leaves are counted as leaves within the same walk, so any
call that clears something still flushes a superset of what it
cleared. This restores the pre-v6.6 semantics -- cost proportional to
what is mapped. With it, an empty nested unmap costs ~110ms
instrumented (the pure walk); getting to "exactly zero" would
additionally require kvm_nested_s2_unmap() to skip nested MMUs that
are valid but empty.

Not proposing to apply anything as-is -- this is the measurement that
answers "why is it taking so long", plus the minimal change that
confirms it.

Happy to share the full traces if that is useful.

Thanks,
Shuai


---8<---
Subject: [PATCH] KVM: arm64: Skip deferred TLB invalidation for empty unmaps

kvm_pgtable_stage2_unmap() issues kvm_tlb_flush_vmid_range()
unconditionally at the end of every call, whether or not the walk
cleared any PTE. As stage2_apply_range() calls it once per 1GB chunk,
unmapping a sparse (or empty) range costs one broadcast per chunk:
for a 48-bit IPA space that is 262,144 broadcasts, ~0.9s on a
Neoverse-N2, paid by every mmu-notifier callback. This is the
dominant cost of kvm_nested_s2_unmap() in the NUMA-balancing
workload, where the nested shadow S2 is all but empty.

Only perform the deferred invalidation when the walk actually
cleared a valid leaf PTE, restoring the pre-v6.6 semantics of the
cost being proportional to what is mapped. Table entries keep the
immediate __kvm_tlb_flush_vmid_ipa() issued from
stage2_unmap_put_pte(), and their child leaves are counted within
the same walk, so any call that clears anything still flushes a
superset of the range it cleared.

Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>

--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -891,11 +891,17 @@ static bool stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
  	return system_supports_tlb_range() && cpus_have_final_cap(ARM64_HAS_STAGE2_FWB);
  }

+struct stage2_unmap_data {
+	struct kvm_pgtable	*pgt;
+	u64			unmapped_leaves;
+};
+
  static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
  				struct kvm_s2_mmu *mmu,
  				struct kvm_pgtable_mm_ops *mm_ops)
  {
-	struct kvm_pgtable *pgt = ctx->arg;
+	struct stage2_unmap_data *data = ctx->arg;
+	struct kvm_pgtable *pgt = data->pgt;

  	/*
  	 * Clear the existing PTE, and perform break-before-make if it was
@@ -1155,7 +1161,8 @@ int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
  static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
  			       enum kvm_pgtable_walk_flags visit)
  {
-	struct kvm_pgtable *pgt = ctx->arg;
+	struct stage2_unmap_data *data = ctx->arg;
+	struct kvm_pgtable *pgt = data->pgt;
  	struct kvm_s2_mmu *mmu = pgt->mmu;
  	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
  	kvm_pte_t *childp = NULL;
@@ -1183,6 +1190,9 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
  	 * block entry and rely on the remaining portions being faulted
  	 * back lazily.
  	 */
+	if (kvm_pte_valid(ctx->old) && !kvm_pte_table(ctx->old, ctx->level))
+		data->unmapped_leaves++;
+
  	stage2_unmap_put_pte(ctx, mmu, mm_ops);

  	if (need_flush && mm_ops->dcache_clean_inval_poc)
@@ -1198,14 +1208,18 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
  int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
  {
  	int ret;
+	struct stage2_unmap_data data = {
+		.pgt			= pgt,
+		.unmapped_leaves	= 0,
+	};
  	struct kvm_pgtable_walker walker = {
  		.cb	= stage2_unmap_walker,
-		.arg	= pgt,
+		.arg	= &data,
  		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
  	};

  	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
-	if (stage2_unmap_defer_tlb_flush(pgt))
+	if (stage2_unmap_defer_tlb_flush(pgt) && data.unmapped_leaves)
  		/* Perform the deferred TLB invalidations */
  		kvm_tlb_flush_vmid_range(pgt->mmu, addr, size);
