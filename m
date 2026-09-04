Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E7B3A6B9A
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 07:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788505292; cv=none; b=YBy/vh3SmqGUGdVmuUxAM4GcLFLu3XDeDld8hK4+meUe1dOqhbwT8tJZTwCX60bwfXS1HpFISkZPVRKaUPQVDPNgOS+yMscVu3wMqrYn8KuG939683UCvcOS9QyIIFpTk1f6ya80VxycilEPoZjX8+rP9LZTCZh76Bk9n5Yyguw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788505292; c=relaxed/simple;
	bh=fnQDIjjX21nOJR6vDXwyI8ruFKygzvOidjThFbQlgbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DI7oToVBxbwlM7xkss/GnpXrOATi/XTyQqKZUn19FZbjKYFt9NeTf/riLhfnU6a74TJ1dOixQxoVxODBXAitNlZ3mmAz415onPjv4WnVCWlMQ/u/juRakmQfzQJ7YfoSqQu7shp33g/IEjkBYfCTTYZJUgbzVMESZS1rYkeK02c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Vx+A0nWH; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Vx+A0nWH"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788505286; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GtHiZDCuXeYFDJzlyfIddR3dnZAvYDkV/Xg1utvI214=;
	b=Vx+A0nWHMMECTYcOaoWEV9tmdTTKnp3QQQh5rrz7lnkEaHnfOAL6ZwFMVyXO7UPphaOIg3qTtW3epofW35MdJIq+FKIbnBV1LgQNp60DKXI0XI3sg5HkyBxtIz5Hfw1EtWIUc83i5s43ADUL8MxjpnKcwyO2MMx/dP6C+ZsSqxs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XAHyf4B_1788505284;
Received: from 30.246.160.252(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0XAHyf4B_1788505284 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 15:01:25 +0800
Message-ID: <46342b48-550e-42c1-9d9f-e800c72269c2@linux.alibaba.com>
Date: Fri, 4 Sep 2026 15:01:24 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/6] KVM: arm64: nv: Implement nested stage-2 reverse
 map (new data structure)
To: Wei-Lin Chang <weilin.chang@arm.com>, Marc Zyngier <maz@kernel.org>,
 Wang Han <wanghan@linux.alibaba.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, oupton@kernel.org, tabba@google.com,
 joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, ljs@kernel.org,
 itaru.kitayama@fujitsu.com
References: <20260810205038.118843-1-weilin.chang@arm.com>
 <20260902163500.1841671-1-wanghan@linux.alibaba.com>
 <877bl26aqg.wl-maz@kernel.org>
 <wsnf276xrun3g4hjr3t6alprapctg5z4kpj422v3hujqdjnrsa@swq4blkqvvj5>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <wsnf276xrun3g4hjr3t6alprapctg5z4kpj422v3hujqdjnrsa@swq4blkqvvj5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/3/26 9:28 PM, Wei-Lin Chang wrote:
> On Thu, Sep 03, 2026 at 08:43:35AM +0100, Marc Zyngier wrote:
>> On Wed, 02 Sep 2026 17:35:00 +0100,
>> Wang Han <wanghan@linux.alibaba.com> wrote:
>>>
>>> Hi Wei-Lin,
>>>
>>> I tested this series on a Yitian 710 system with an ARM Neoverse-N2 CPU
>>> (128 CPUs, 2 NUMA nodes).
>>>
>>> Test environment
>>> ----------------
>>>
>>>    L0 kernel: Linux v7.2-rc6
>>>    L1 guest: Ubuntu 26.04 LTS, kernel 7.0.0-27-generic (aarch64)
>>>    QEMU: 10.2.3
>>>
>>> L0 NUMA balancing was enabled (`/proc/sys/kernel/numa_balancing=1`).
>>> The host was booted with `kvm_arm.mode=nested`.
>>>
>>> This series fixes a functional hang that is exposed when NUMA balancing is
>>> enabled.  The previous nested stage-2 unmap path is too slow for this
>>> workload, making the performance problem user-visible: NUMA balancing can
>>> leave the L1 guest unable to make progress and eventually hang during boot.
>>>
>>> The L1 was started with 8 vCPUs and 32 GiB of RAM using:
>>>
>>>    qemu-system-aarch64 -smp 8 -m 32G \
>>>      -machine virt,accel=kvm,gic-version=3,virtualization=on \
>>>      -cpu host -nographic -enable-kvm \
>>>      -drive if=pflash,format=raw,readonly=on,file=pflash0_bak.img \
>>>      -drive if=pflash,format=raw,file=pflash1_bak.img \
>>>      -drive file=./ubuntu-vm.qcow2,format=qcow2,if=virtio,cache=none,aio=native \
>>>      -nic user,model=virtio-net-pci,hostfwd=tcp::11234-:22 \
>>>      -serial mon:stdio
>>>
>>
>> Puzzling. If you are only running an L1 in VHE mode, there is no
>> shadow S2, and therefore nothing to unmap. For shadow S2s to be built
>> and affect the MMU notifiers, you need to run an L2.
> 
> I was thinking the same at first, but realized even with L1 in VHE mode
> there is a small period of time where L1 runs in its EL1 during boot, so
> one nested MMU will become valid for each vCPU. That causes
> kvm_nested_s2_unmap() to iterate through the entire IPA space 8 times
> (-smp 8).
> 
> What I am curious about is whether one single notifier unmap is enough
> to hang L1, or were there multiple notifier unmaps.
> 
> QEMU with -machine virt uses 40 IPA bits only, unmapping that takes:
> 1024  (4KB pages,  unmapping 1GB per iteration)
> 32768 (16KB pages, unmapping 32MB per iteration)
> 2048  (64KB pages, unmapping 512MB per iteration)
> iterations for each page size. There aren't many mappings in each
> iteration too. Does this really take that long on real hardware (even if
> this must be done 8 times)?
> 
> Thanks,
> Wei-Lin Chang
> 
>>
>> So what are your actual test conditions?
>>
>> 	M.
>>

Hi, Wei-Lin and Marc,

I was able to reproduce this issue and capture ftrace evidence that confirms
the root cause. Below is the analysis, trace log, and timing data.

## Problem

Environment:
- Host (L0): ARM64, KVM with virtualization=on (nested virtualization)
- Guest (L1): Ubuntu 26.04, 8 vCPUs / 32 GB
- Host NUMA balancing enabled, numad active

When booting the L1 QEMU guest, the L1 kernel hits a soft lockup during
early boot (~45 s):

  [   45.646468] watchdog: BUG: soft lockup - CPU#0 stuck for 32s!
  [kworker/0:2:330]
  [   45.646882] watchdog: BUG: soft lockup - CPU#2 stuck for 29s!
  [snap:1146]
  [   45.647093] watchdog: BUG: soft lockup - CPU#3 stuck for 29s!
  [snap:1141]
  [   45.647242] watchdog: BUG: soft lockup - CPU#7 stuck for 29s!
  [snap:1144]

At the same time, L0 dmesg reports the QEMU main thread blocked in D-state
for more than 120 s:

  [11239.341817] INFO: task qemu-system-aar:170799 blocked in I/O wait for
  more than 120 seconds.
  ...
    softleaf_entry_wait_on_locked+0x280/0x2d0
    migration_entry_wait+0xdc/0x140
    do_swap_page+0x834/0xd80
    handle_pte_fault+0x208/0x2b8
    __handle_mm_fault+0x228/0x528
    handle_mm_fault+0xdc/0x2d8
    do_page_fault+0x244/0x790
    do_translation_fault+0x4c/0x88
    do_mem_abort+0x4c/0xa0
    el1_abort+0x50/0x80
    el1h_64_sync_handler+0x50/0x108
    el1h_64_sync+0x80/0x88
    do_sys_poll+0x224/0x290
    __arm64_sys_ppoll+0xa4/0x130

Note: This is not a 100% reproducible failure. In my automated loop the hang
reproduced on the 2nd boot attempt, but other attempts ran for 6–9 minutes
without hitting it. The bug is clearly timing-dependent on NUMA migration
activity during the L1 boot window.

## Root cause

The issue is in arch/arm64/kvm/nested.c:
  void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
  {
      int i;

      lockdep_assert_held_write(&kvm->mmu_lock);

      if (!kvm->arch.nested_mmus_size)
          return;

      for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
          struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];

          if (kvm_s2_mmu_valid(mmu))
              kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
      }

      kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
  }

When L0 NUMA balancing migrates a page belonging to the QEMU process, the
MMU notifier path calls kvm_unmap_gfn_range():

  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
  {
      ...
      __unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
                           (range->end - range->start) << PAGE_SHIFT,
                           range->may_block);

      kvm_nested_s2_unmap(kvm, range->may_block);   /* full unmap */
      return false;
  }

kvm_handle_hva_range() takes kvm->mmu_lock for writing before invoking the
handler and releases it only after the handler returns
(virt/kvm/kvm_main.c:622-642). Therefore, the entire kvm_nested_s2_unmap()
runs under kvm->mmu_lock.

The problem is that kvm_nested_s2_unmap() does not unmap only the affected
GPA range. Instead, it unmaps the entire IPA space (0 to kvm_phys_size(mmu))
for every nested S2 MMU. With nested virtualization enabled, this is very
expensive.

## Trace evidence

I captured function_graph traces for kvm_unmap_gfn_range,
kvm_nested_s2_unmap, and kvm_stage2_unmap_range, plus mm_migrate_pages
tracepoints.

1. numad-triggered full unmap
    64)   numad-1888   |               |  /* set_migration_pte:
  addr=fff790579000, pte=3040c319d9680 order=0 */
    64)   numad-1888   |               |  kvm_unmap_gfn_range() {
    64)   numad-1888   |               |    kvm_nested_s2_unmap() {
    64)   numad-1888   | @ 877415.7 us |      kvm_stage2_unmap_range();
    64)   numad-1888   | @ 877418.2 us |    }
    64)   numad-1888   | @ 877422.0 us |  }

Each set_migration_pte line is a single-page NUMA migration. Yet each
migration triggers one full kvm_nested_s2_unmap() that takes 877 ms.

Subsequent calls show per-page unmap durations between 841 ms and 1.16 s.

2. QEMU threads blocked as well
    23) qemu-sy-227844 |               |  kvm_unmap_gfn_range() {
    23) qemu-sy-227844 |               |    kvm_nested_s2_unmap() {
    23) qemu-sy-227844 | $ 1170521 us  |      kvm_stage2_unmap_range();
    23) qemu-sy-227844 | $ 1170529 us |    }
    23) qemu-sy-227844 | $ 1170542 us |  }

QEMU's own threads also get stuck in the same full unmap, with one call
reaching 6.67 s.

3. Statistics
┌──────────────┬───────┬──────────────────────────────────────┐
│ Thread       │ Calls │ kvm_nested_s2_unmap duration         │
├──────────────┼───────┼──────────────────────────────────────┤
│ numad-1888   │ 59    │ min 0.84 s / avg 1.02 s / max 1.16 s │
├──────────────┼───────┼──────────────────────────────────────┤
│ QEMU threads │ 34    │ min 1.14 s / avg 5.14 s / max 6.67 s │
└──────────────┴───────┴──────────────────────────────────────┘

numad migrates pages one after another; each page holds kvm->mmu_lock for
about one second. QEMU vCPU threads cannot acquire mmu_lock and also block
on migration_entry_wait. The L1 guest vCPUs make no forward progress, and
the watchdog fires.

Soft lockup threshold check

Read directly inside the L1 guest:

  root@ubuntu-vm:~# cat /proc/sys/kernel/watchdog_thresh
  10

So the soft lockup threshold is 2 * watchdog_thresh = 20 s.

The L1 guest reported stuck times of 29~32 s, which exceeds the 20 s
threshold.

## Conclusion

The root cause is confirmed: kvm_nested_s2_unmap() performs a full IPA space
unmap in the MMU notifier path instead of unmapping only the affected
GPA/CPAI range. The interval-tree-based precise range unmap approach is the
right fix.

Please consider applying the patch that replaces the full unmap with
kvm_nested_unmap_cipa_range() to avoid scanning the entire nested stage-2
page table on every NUMA migration.

Thanks,
Shuai

