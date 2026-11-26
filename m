Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.109
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795703533;
	b=UrdVJE2eCz8bG7BQx1cdraZiiOC0b5j5N48xjGo7qWBnTXDzFtnmmD9BDDYEWZHB0gxW
	 dJy0zSIw2VYEHFHiWOfwrcByRdDKnuObBe5uY1oeQt9r8lF1UuNBUEM51nlGpz0ydtiWg
	 dQziq1SUc+IpZWZbkNGxPu8CaTfX7IyV20vV81jpWR6kpQTfHhAMjmDoowOALkfID/aeE
	 /HXnkqUf6NqrLFp8vwhIJSrIy92BGGT4bUZ54A322YnKkqO+U+HKWxUm86KwtG5B098tR
	 XkuEP/Ed410IS6wtvQVwoe6JF+tVNitjI+CHdYqfQK6XJ5QRHsJm7bMGiav6O9XbujQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795703533;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=Govo4r8+nAYzJTvFpEXUjY65QbZ4bFSiu78PfI+BWQw=;
	b=Txh5FHTFHVE1QbFADlyyvKIP37LclF/S6IbNuxVXwXp24E8idlrK9CSC3chI/voMhJG0
	 AFLfhsoXqND45k12nLYI+IrpxOT175tYDlfRpJpuMmwChPz4HpVJemN9b0sDk6tbCgmZ8
	 KtYiemb3Xiy7fQshurTk7HjdU4A8FocViCMWabdJCfeafLlYZ2vED3KPIKSpqqicPv5vc
	 7yCgjt0W3FcSkiYs6tu3qp5A2pSRYaUcaH9/MSdFLgLYFI+VSWxz1eAytrkv1nub2VPyq
	 1B0LuAgWE4gBdK18C+5JYtZnBXIKHAMYn9cvkxBw95KfhSMZ1O+7qU7LOjxR4f9r6GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bG8cN2RZ;
	arc=none smtp.remote-ip=95.215.58.109
Received: from mta1.migadu.com (out-109.mta1.migadu.com [95.215.58.109])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F388606A683
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 14:32:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F388606A683
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bG8cN2RZ
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=1nwB7BJF7Q6n+CMViIulALOZVvB0xneBvfIAWGHuXzg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795703525; v=1; x=1796308325;
 b=bG8cN2RZgSdQZssj0quOHlVRRxrQmO8AxYtJTbmDv/Vp0MhaCz6+SpGb2JIzZU1dmDgcoQKC
 tKvtQNH7epqc3Td1e4j6KC8huEE7+gWSMfQKQn2qlOsnv54nHzxplDM8xpUh7dNl8gp5DdvE6FS
 ml771yolzawi3gaAr79HnBzs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 699c661509b79829;
	Thu, 26 Nov 2026 14:32:04 +0000
X-Mizu-Trace-ID: 699c661509b79829
X-Migadu-Flow: FLOW_OUT
Message-ID: <563d2406-dcfe-43b6-8f21-2a7694f1f266@linux.dev>
Date: Thu, 26 Nov 2026 14:32:04 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Reduce the stage-2 page cache on 64 KiB hosts
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com,
 seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, riel@surriel.com, shakeel.butt@linux.dev,
 kernel-team@meta.com, rkeilty@meta.com, atish.patra@linux.dev,
 dgreid@meta.com, Lorenzo Stoakes <ljs@kernel.org>
References: <20261124152842.2634495-1-usama.arif@linux.dev>
 <86wlpzycnn.wl-maz@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <86wlpzycnn.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 26/11/2026 04:56, Marc Zyngier wrote:
> On Tue, 24 Nov 2026 15:28:42 +0000,
> Usama Arif <usama.arif@linux.dev> wrote:
>>
>> When a stage-2 fault may need new page tables, KVM first tops up the
>> vCPU's page cache: if it holds fewer pages than the fault might need, it
>> is refilled to KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, which arm64 sets to
>> 40. Unused pages stay in the cache until the vCPU is destroyed.
>>
>> With 64 KiB pages, that is 2.5 MiB per vCPU, and most of it is never
>> used. Stage-2 has at most three levels and the root is preallocated, so
>> a fault needs at most two new table pages (kvm_mmu_cache_min_pages()).
>> As every last-level table covers 512 MiB, an 8 GiB guest needs just 17
>> table pages to map all of its memory, while its four vCPU caches get
>> filled with 160.
>>
>> On a production host with 64 KiB pages running 101 VMs with four vCPUs
>> each, the caches were still 86% full. The memory used:
>>
>>                         before      after
>>   per-vCPU capacity     2.5 MB     512 KB
>>   all 404 vCPUs         869 MB     <= 202 MB
>>
>> Let's lower the capacity to 8 with 64 KiB pages, In the production
>> usecase above, it frees at least 667 MB. That still covers the two-page
>> minimum and leaves room for several table allocations per refill. 4 KB
>> and 16 KB pages keep 40.
> 
> I'll glance over the use of 64kB pages, because that's definitely a
> niche configuration that hardly anyone uses. But the scale of the
> numbers strike me a bit: 808GB worth of guest memory, and you're
> complaining about 869MB? That's roughly 0.1% of the total, and the
> savings you're gaining are even less... I know memory is expensive,
> but you'd save a lot more than that by using a realistic page size.
> Just saying...
> 

Hello Marc,

Thanks for the review!

The 808 GB is what the guests were sized to, not what the host had.
Guest memory there is overcommitted (with ballooning): the host has
254 GB of RAM. v2 from [1] gives back at least 768 MB. The usecase
is very memory intensive, so saving more than 0.5G is a very good win.

The cost also scales with vCPUs, not with guest memory: up to 2.5 MB
per vCPU, whatever the guest size. On a test host of the same type
running 101 VMs with 4 vCPUs and 1 GB each, the caches held 986 MB,
while the stage-2 page tables they exist to feed took 25 MB. That is
39 times more memory held in reserve for page tables than used for
them, and 89% of all kernel memory charged to the VMs' cgroup
(1106 MB). With v2, the caches take 84 MB and the total is 204 MB.

As for the page size, 64K is the default NVIDIA recommends for Grace,
and both RHEL and Ubuntu ship 64K arm64 kernels. We use 64K base
page size for all ARM hosts in the meta fleet and see regression in
workload performance for 4K. I do know of other hyperscalers that
use it as well, so this is not a niche in server world IMO.

> I also question the assumption you are making that the guest is
> strictly using IPA contiguous memory, and that therefore a very small
> set of pages are all you need to map a guest. Guests with multiple,
> disjoint memslots are (sadly) extremely common, specially in these
> days of tiered memory and other random horrors.
> 

The patch doesn't rely on that. The 8 GB guest needing 17 table pages
was only an example of the scale. The capacity bounds how many pages
are allocated ahead of time, not how many tables a guest can have:
every translation fault tops the cache up to kvm_mmu_cache_min_pages()
before taking mmu_lock, and a single map never needs more than that.

Disjoint memslots mean more refills, not more allocations. The top-up
allocates one page per iteration either way, so a 40-page refill is
40 calls to __get_free_page(), with nothing amortised. With 4, the
total is the same or lower, and the most a single fault allocates
drops from 40 pages to 4. That also answers Wei-Lin's point.

>>
>> The temporary cache in kvm_phys_addr_ioremap() uses the same capacity,
>> but it is topped up before every page it maps, so 8 is sufficient there
>> as well. The pKVM hypervisor memcache and the eager split cache don't
>> use this capacity.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  arch/arm64/include/asm/kvm_types.h | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
>> index 9a126b9e2d7c99..28568da9ea4a7b 100644
>> --- a/arch/arm64/include/asm/kvm_types.h
>> +++ b/arch/arm64/include/asm/kvm_types.h
>> @@ -2,7 +2,12 @@
>>  #ifndef _ASM_ARM64_KVM_TYPES_H
>>  #define _ASM_ARM64_KVM_TYPES_H
>>  
>> +/* Must cover kvm_mmu_cache_min_pages(), at most 2 with 64 KiB pages. */
>> +#ifdef CONFIG_ARM64_64K_PAGES
>> +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 8
>> +#else
>>  #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
>> +#endif
> 
> Now, to the patch itself: I see no reason to special-case this. If
> kvm_mmu_cache_min_pages() is an indication of what is needed, then
> this macro should be driven by it, or the whole allocator take it into
> account. And then you adjust it by whatever fudge factor seems
> appropriate.
> 

Completely agree! [1] does that: no page-size special case, and
a capacity of KVM_PGTABLE_LAST_LEVEL - KVM_PGTABLE_FIRST_LEVEL for every
page size.  It can't track kvm_mmu_cache_min_pages()
at runtime: the vCPU's cache is shared by the canonical and NV shadow
MMUs, and its capacity must stay fixed. So it has to cover the largest
minimum, which stage-2 caps at 3, and 4 is that plus one page of fudge.

For what it's worth, my understanding is that 40 currently used here was
never derived from stage-2, it was copied from x86's KVM_NR_MEM_OBJS by the
initial port.

Thanks!
Usama

> Thanks,
> 
> 	M.

[1] https://lore.kernel.org/all/e7bdcfa9-bbd8-4649-8318-2f6dc236db15@linux.dev/
