Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC7132EB859;
	Fri, 26 Jun 2026 08:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782463995; cv=none; b=t6oLeug9aisy6j0DLhSNWFoQ4LwTpBgyAkbak3AlSIiHPZppzDv4sBKFHMY4Sz46u+zPjR4ZHoSfl11wqAU3bq6niTUl5Ed0Y468idmV2e5NaPlGIyKQuVcMWQ1ZfSV46VYH9TM5vaE5C2vTw2HlQuWHu2gm6TM5BSyc/m71HEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782463995; c=relaxed/simple;
	bh=p9vOkbqaBZi9cvX5i54t8dgEDQi2LWFk1zzsZEJpODY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pHnvLJZm4EfC3rjg0BRrYgkDy+B4pNx+8ozM+0V8ydrhBkT50Yl9t09VJrPOg4FIuWLYHDxrxWRFLBx3zjWYLa5B+cQIMZdPFds7qUz2q9LEyfXnhi8t8mZcdlvMDEXUqfarXBRZLqJHzIufc1BsEynnU2+pGDOu8Qwrl4PsrK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JQR2Jx0O; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JQR2Jx0O"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F1752247;
	Fri, 26 Jun 2026 01:47:13 -0700 (PDT)
Received: from [10.57.28.79] (unknown [10.57.28.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D819B3F905;
	Fri, 26 Jun 2026 01:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782463638; bh=p9vOkbqaBZi9cvX5i54t8dgEDQi2LWFk1zzsZEJpODY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JQR2Jx0OWyoQ0O6coNwSG0GeGJhuSAJTr/ID0QDqM9rD++MHxvkPahYtcDC8vrT1I
	 CArES9Vov5l7eK0s/nZuq8ROmyxo6kDWjlW1se5CL/5VQKBPapEeN0uyQrUcZj6FIZ
	 gwXB8AZmlEq2CJhAq6Xy5+g4TdrbgoOcm5UrJ5yQ=
Message-ID: <9482dfbc-4d96-47ba-a615-f4ba0bda833f@arm.com>
Date: Fri, 26 Jun 2026 09:47:13 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 29/44] arm64: RMI: Runtime faulting of memory
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-30-steven.price@arm.com>
 <3359f788-07fa-41a1-9ac7-45c58577c1fa@redhat.com>
 <aiJ6u83O0nVUtPyv@lpieralisi>
 <ecef952b-e8c6-4102-933b-c99c46f14431@redhat.com>
 <aiLes2ecZSr17UwZ@lpieralisi>
 <1e39094f-7fa3-4ef1-be54-53d7a8643506@redhat.com>
 <98d2a0f3-b831-466a-8212-5bcf97ad9d8b@arm.com>
 <8da87878-2a5d-478a-a280-60dbed7ad1b9@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <8da87878-2a5d-478a-a280-60dbed7ad1b9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 26/06/2026 08:43, Gavin Shan wrote:
> On 6/26/26 1:58 AM, Suzuki K Poulose wrote:
>> On 25/06/2026 14:53, Gavin Shan wrote:
>>> On 6/6/26 12:35 AM, Lorenzo Pieralisi wrote:
>>>> On Fri, Jun 05, 2026 at 06:11:11PM +1000, Gavin Shan wrote:
>>>>> On 6/5/26 5:28 PM, Lorenzo Pieralisi wrote:
>>>>>> On Fri, Jun 05, 2026 at 04:23:15PM +1000, Gavin Shan wrote:
> 
> [...]
> 
>>>>>
>>>>> I tried to rebase Jean's latest QEMU series [1] to upstream QEMU, 
>>>>> and found
>>>>> that memory slots backed by THP are broken. With THP disabled on 
>>>>> the host and
>>>>> other fixes (mentioned in my prevous replies) applied on the top of 
>>>>> this (v14)
>>>>> series, I'm able to boot a realm guest with rebased QEMU series 
>>>>> [2], plus more
>>>>> fxies on the top.
>>>>>
>>>>> [1] https://git.codelinaro.org/linaro/dcap/qemu.git  (branch: cca/ 
>>>>> latest)
>>>>> [2] https://git.qemu.org/git/qemu.git                (branch: cca/ 
>>>>> gavin)
>>>>>
>>>>> Lorenzo, You may be saying there is someone making QEMU to support 
>>>>> ARM/CCA?
>>>>
>>>> Mathieu and I are working on that yes and with Steven/Suzuki to fix 
>>>> the THP
>>>> issues you pointed out above.
>>>>
>>>>> If so, I'm not sure if there is a QEMU repository for me to try?
>>>>
>>>> We should be able to submit patches by end of June - we shall let 
>>>> you know
>>>> whether we can make something available earlier.
>>>>
>>>
>>> Not sure if there are other known issues in this series. It seems the 
>>> stage2
>>> page fault handling on the shared space isn't working well. In my 
>>> test, the
>>> vring (struct vring_desc) of virtio-net-pci is updated by the guest, 
>>> and the
>>> data isn't seen by QEMU, I'm suspecting if the host-page-frame-number 
>>> is properly
>>> resolved in the s2 page fault handler for shared (unprotected) space.
>>>
>>> - I rebased Jean's latest qemu branch to the upstream qemu;
>>>
>>> - On the host, which is emulated by qemu/tcg, the THP (transparent 
>>> huge page) is
>>>    disabled.
>>>
>>> - On the guest, I can see the virtio vring (struct vring_desc) is 
>>> updated. The
>>>    S1 page-table entry looks correct because the corresponding 
>>> physical address
>>>    0x10046880000 is a sane shared (unprotected) space address.
>>>
>>>    [   52.094143] software IO TLB: Memory encryption is active and 
>>> system is using DMA bounce buffers
>>>    [   52.289746] virtqueue_add_desc_split: 
>>> desc[0]@0xffff000006880000, [00000100b983f000  00000640  0002  0001]
>>>    [   52.432150] PTE 0x00e8010046880707 at address 0xffff000006880000
>>>
>>> - On the host, the s2 page-table-entry is unmapped due to attribute 
>>> transition (private -> shared).
>>>    A subsequent S2 page fault is raised against the adress and the s2 
>>> page-table-entry is built.
>>>
>>>    [  109.259077] ====> realm_unmap_shared_range: 
>>> tracked_unprot_addr=0x10046880000
>>>    [  109.260249] realm_unmap_shared_range: unmapped shared range at 
>>> 0x10046880000
>>>    [  109.317786] realm_unmap_shared_range: unmapped shared range at 
>>> 0x10046880000
>>>    [  109.629939] ====> kvm_handle_guest_abort: 
>>> fault_ipa=0x10046880000, esr=0x92000007
>>>    [  109.630245] realm_map_non_secure: ipa=0x10046880000, 
>>> pfn=0xb8b59, size=0x1000, prot=0xf
>>>    [  109.630331] realm_map_non_secure: ipa=0x10046880000, 
>>> ipa_top=0x10046881000, flags=0x1e0001, range_desc=0xb8b59004
>>
>> Are you able to correlate the order of the transitions and the Guest
>> access with RMM log ? We haven't seen this from our end. We are aware
>> of permission fault issues with Unprotected IPA when backing the memslot
>> with MAP_PRIVATE areas. But this looks different.
>>
>> Lorenzo, have you run into this ?
>>
> 
> It's hard to correlate the order since the logs are collected from two 
> separate
> consoles. For the write permission, I add code to the host where the 
> permission
> is always added for all s2 page faults in the shared space. Otherwise, 
> qemu can
> be killed by -EFAULT or similar error.

This is the problem. We can't add WRITE permission by default. I believe
you may have MAP_PRIVATE mapping and it has to be mapped as READ only
and on a permission fault, we replace it with a writable page. By
overriding the WRITE permission, you let the guest write to a page
that may not be seen by the VMM.

We identified this as a bug in the KVM driver in this series (reported
by Lorenzo) and there is a corresponding tf-RMM change that is required
to get this working. So, please could you wait until the next series
when this will be addressed ? Or you could switch to using MAP_SHARED
for the "shared" memory in the memslot.


Suzuki


> 
> There are more findings after more experiments: this virtio-net-pci 
> device has 3
> queues or vrings (Rx/Tx/Ctrl). The Rx/Tx/Ctrl queue are populated in 
> order one after
> one. In the guest kernel, I intentionally write fixed data 
> (0x0123456789abcdef) to
> the first 8 bytes of the queue when it gets populated, and stop the 
> guest at random
> points to see if the data is gone. I found that the data written to Rx/ 
> Tx queue are
> lost after Ctrl queue is allocated.
> 
> The data written to Rx/Tx queue is lost if the guest stops (B). The data 
> written to
> Rx/Tx queue isn't lost if the guest stops at (A). I can see the pattern 
> (0x0123...cdef)
> by dumping the physcial memory through 'pmemsave' command in qemu.
> 
> DMA allocation
> ==============
> dma_alloc_coherent
>    dma_alloc_attrs
>      dma_direct_alloc
>        __dma_direct_alloc_pages
>        dma_set_decrypted                    // (A) No data lost if being 
> stopped here for the Ctrl queue
>        memset(ret, 0, size)                 // (B) Data lost after being 
> stopped after memset() for the Ctrl queue
> 
> The memset() on the Ctrl queue should trigger a stage2 page fault. It 
> seems the page
> fault enforces the shared pages for Rx/Tx queue to be dropped? I need to 
> add more
> debugging code and track it down.
> 
>> Suzuki
>>
>>
>>>
>>> - On QEMU, the updated vring (struct vring_desc) at GPA 0x46880000 
>>> isn't seen. All the
>>>    data in that adress are zeros.
>>>
>>>    ====> virtqueue_split_pop: vdev=<virtio-net>, sz=0x38, 
>>> queue_index=0x0, vq->vring.num=0x100
>>>    virtqueue_split_pop: last_avail_idx=0x0, head=0x0
>>>    address_space_read_cached_slow: cache@0xffff1c036440, addr=0x0, 
>>> buf=0xffffeee34880, len=0x10
>>>    address_space_read_cached_slow: cache: ptr=0x0, 
>>> xlat=0x10046880000, len=0x1000, mrs=<realm-dma-region>, is_write=no
>>>    address_space_read_cached_slow: translated to mr=<mach-virt.ram>, 
>>> mr_addr=0x6880000, l=0x10
>>>    flatview_read_continue_step: mr=<mach-virt.ram>, 
>>> host=0xffff23e00000, mr_addr=0x6880000, ram_ptr=0xffff2a680000
>>>    virtqueue_split_pop: desc: 0000000000000000 - 00000000 - 00000000 
>>> - 00000000
>>>    qemu-system-aarch64: virtio: zero sized buffers are not allowed
>>>
>>>
> Thanks,
> Gavin
> 

