Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5B6384CED
	for <kvmarm@lists.linux.dev>; Sat,  5 Sep 2026 15:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788623384; cv=none; b=mICX/vtGZy9qiGaAzb3AfANBWD9I6s2+b5Zc6Qgi5H1e329IRnYOD9pRGkEBvrGTbL6S8uV6yopAneQyZqaVyKD9lmz/76u9SILmz9W7opDLSO0Q4e7AK4y14FAGmvah+QLmxdqMFi06qweGVKWlM4B3oQeKm+WW7PHa+opPU7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788623384; c=relaxed/simple;
	bh=1raF9hKpxW1taHQ74FAdyWBZETQB2ZuJx53fgvEryjk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jl7vPSdoPK+dZVM26qcjHL2qTRIb8pvb4DgEA10I2kietjPErBSGyPw0CCg2SIJRFviKfZODXL40j4NGGWeNvK4fCZizrAgG/Kb6tWcdC7BN2lu3ftLnFSQ9RShjmshaH7ZZu5/Dy5FXqfOGSqWc7BV+RGagwOwymz+a3h9k6gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BKH11Yn+; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BKH11Yn+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788623375; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WkTxrdiPtb120sX9TKnjMh5DPVxZ2gJIoYJu4yxR7vI=;
	b=BKH11Yn+rEdlb8oN8xYjmwsyKLLXBG+0jMulc3nO/gRl/OCpXWicmp7AxMrvaBwTEkJ81gYp0yTmbm3EI/IGCN2qdeyEnVu6F2rpUj/io4vsRFUwsYlk3OL2sMkIv0gkpTKZf1Izyxhl5JGo523yg+8PLt3CANDtSXXoRcmD+fc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XALG-eb_1788623373;
Received: from 30.100.134.114(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0XALG-eb_1788623373 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 05 Sep 2026 23:49:34 +0800
Message-ID: <2bde734c-eb86-4c7a-958d-b431e6d13671@linux.alibaba.com>
Date: Sat, 5 Sep 2026 23:49:32 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/6] KVM: arm64: nv: Implement nested stage-2 reverse
 map (new data structure)
To: Wei-Lin Chang <weilin.chang@arm.com>, Marc Zyngier <maz@kernel.org>
Cc: Wang Han <wanghan@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, oupton@kernel.org, tabba@google.com,
 joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, ljs@kernel.org,
 itaru.kitayama@fujitsu.com
References: <20260810205038.118843-1-weilin.chang@arm.com>
 <20260902163500.1841671-1-wanghan@linux.alibaba.com>
 <877bl26aqg.wl-maz@kernel.org>
 <wsnf276xrun3g4hjr3t6alprapctg5z4kpj422v3hujqdjnrsa@swq4blkqvvj5>
 <875x0l5udh.wl-maz@kernel.org>
 <eylfcgxs2xzu57czyuhkpmum45lpxyccyu2yh3mipr67aq3xo6@xinygxzavoja>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <eylfcgxs2xzu57czyuhkpmum45lpxyccyu2yh3mipr67aq3xo6@xinygxzavoja>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/5/26 6:42 AM, Wei-Lin Chang wrote:
> On Fri, Sep 04, 2026 at 08:49:14AM +0100, Marc Zyngier wrote:
> 
> [...]
> 
>>>>>
>>>>> The L1 was started with 8 vCPUs and 32 GiB of RAM using:
>>>>>
>>>>>    qemu-system-aarch64 -smp 8 -m 32G \
>>>>>      -machine virt,accel=kvm,gic-version=3,virtualization=on \
>>>>>      -cpu host -nographic -enable-kvm \
>>>>>      -drive if=pflash,format=raw,readonly=on,file=pflash0_bak.img \
>>>>>      -drive if=pflash,format=raw,file=pflash1_bak.img \
>>>>>      -drive file=./ubuntu-vm.qcow2,format=qcow2,if=virtio,cache=none,aio=native \
>>>>>      -nic user,model=virtio-net-pci,hostfwd=tcp::11234-:22 \
>>>>>      -serial mon:stdio
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
>>
>> It should be one nested MMU for the whole VM, not one per vcpu.
>> That's assuming they share the same VMID+VTCR.
>>
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
>>
>> This should be close to being at zero cost, so something else is
>> amiss.
>>
> 
> Guess what? I am completely wrong once again.
> 
> The complete range of the nested mmus isn't about the value
> supplied by KVM_VM_TYPE_ARM_IPA_SIZE. Instead it is the PARange exposed
> to the guest. That's because the guest hypervisor is allowed to expose
> whatever memory map it likes to its nested guests, as long as it is
> within the guest's PARange. This is explained clearly in
> init_nested_s2_mmu().
> 
> Now the PARange exposed to guests should be much larger than 40bits. On
> the neoverse-n2 it should be 48bits (256TB), therefore the iterations
> required for each unmapping would be 256x:
> 
> 262144  (4KB pages,  unmapping 1GB per iteration)
> 8388608 (16KB pages, unmapping 32MB per iteration)
> 524288  (64KB pages, unmapping 512MB per iteration)
> 
> I think these numbers match the hang time Shuai have shown.
> 
> Just to demonstrate the difference I have tried manually limiting
> kvm_ipa_limit to 40, and tested with software emulation. Before the
> manual change a kvm_nested_s2_unmap() finished after 42 seconds, after
> limiting kvm_ipa_limit kvm_nested_s2_unmap() can finish in less than a
> second.

Hi Wei-Lin,

Your PARange analysis is what this whole diagnosis rests on -- the
48-bit/256x arithmetic is exactly right, and our ftrace data confirms
it to the chunk: every full-IPA kvm_nested_s2_unmap() in our traces
walks precisely 262,144 1GB chunks, the number from your table. The
kvm_ipa_limit=40 experiment also pointed straight at the answer. I'd
only push back on the last sentence:

> 
> With this, I think there aren't other underlying issues, it just is that
> slow unfortunately..


I don't think it is "just that slow" -- I think it is a specific
regression, and your own data localizes it better than the conclusion
suggests.

The thing is, kvm_ipa_limit=40 cannot tell *what* each chunk spends
its ~3.3us on, because the walk is also per-chunk: cutting the chunk
count by 256x shrinks both terms together, whichever one dominates.
The experiment that separates them is one where the chunk count does
not change at all.

We ran that experiment. Details are in my reply to Marc, but the
short version:

   - Before: 877ms per callback, 262,144 chunk calls, 262,144
     broadcasts. Chunk count and broadcast count are exactly equal
     (8,476,033 = 8,476,033 over the trace window) -- every chunk
     ends in a broadcast, mapped or not. Per chunk, ~4.6us of the
     ~5.1us is inside kvm_tlb_flush_vmid_range(); the walk of an
     empty chunk is ~0.2us. In an uncontended numad episode, 87% of
     the 1312ms is flush time and 8% is walk time.

   - After conditioning the flush on the walk having actually cleared
     a valid leaf (the candidate fix in my other mail): same 262,144
     chunks, same walk, ~110ms instrumented. Nothing about the walk
     changed -- ~3.1us of the per-chunk 3.3us was the broadcast.

   - And the table really is empty, as Marc says: with the flush
     count acting as a detector, the first full-IPA unmap of the boot
     issues 2 flushes (the EL1-boot-period mappings, a few dozen
     pages in two 1GB chunks); all 35 subsequent ones issue zero.

The code history agrees. Before 7657ea920c54, the TLBI lived inside
stage2_put_pte()'s 'if (kvm_pte_valid(ctx->old))' -- an empty walk
issued zero invalidations, ever. v6.6 hoisted the invalidation out
to the end of kvm_pgtable_stage2_unmap() to batch it into one range
TLBI per call, but the condition got dropped on the way. So "since
v6.6, the cost is proportional to the IPA range, not to the number
of mappings" -- which is precisely why the empty table pays in full,
and why I'd frame it as a fixable regression rather than an inherent
cost.

None of this subtracts from your PARange finding -- it depends on
it. The 42s -> <1s result was the 256x chunk scaling; the remaining
<1s is what the conditional flush removes.

Thanks,
Shuai


