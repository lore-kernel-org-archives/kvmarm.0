Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BB13DBD55
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 11:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474200; cv=none; b=sHyw2yUloQ55qgg8Qwxu1gZ+qCaJTreRn/pj6o8TeASAFQUF5RhQBB5vG7njYq3f+xNNeBn7EvCDqshup6wPqSrFLCe7lgRXdfvwhY3i0zpRJy6oj99L5kU1GyhXbqNiYpPJ/6W7V2p+dbFJO8EldSsOv6Bt9s9R3WJmvNVYn4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474200; c=relaxed/simple;
	bh=xW+BL81td0NoKYkE3Cd7vg2N4s0NFsoCr7K+SBFKbok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iF3OgpMsiQCWK5fDR9a4eRTCRp0uQFhGe4rUTmq+wIg46ZpwPcQ8DegVbaMPYBLXdE4zb+RSuFTqUknICip1f9uCwbodp8ZvtueD+FJclLMhTVlXPi7ZnW5a+YQh7aVG6AZo/o0Zklxmm+TNGql93v0pA0M6Cw4NZ6OS2T8JGLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tkm+rl0I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tkm+rl0I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782474198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N1xry/9Vu0APEb/gAq9NvEMqCHHr10KqvQ0Ln8sHSPw=;
	b=Tkm+rl0Iv+wV86MpjijxhlpJrlxf7TFZ9/1uUxRH0e5k9+jHV+Ov+r7utgDrv73hic7J4r
	ZBEnuO6Bd/EVCD4wXmNU+49qcJI7iTZUW5kIyFdA0MtIHSHjKdsO3DKwCzXeYc8KQzL1fB
	nA02xJjlxSbOMBQwdo0CnMO0ZJ9t0Yg=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-BlXY1nk4Nmm6s2JpfA7nKA-1; Fri, 26 Jun 2026 07:43:17 -0400
X-MC-Unique: BlXY1nk4Nmm6s2JpfA7nKA-1
X-Mimecast-MFC-AGG-ID: BlXY1nk4Nmm6s2JpfA7nKA_1782474196
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-37de6edd915so678677a91.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 04:43:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782474196; x=1783078996;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N1xry/9Vu0APEb/gAq9NvEMqCHHr10KqvQ0Ln8sHSPw=;
        b=LiODzmceGcm9pGGG7PR9Y6cYnmzlSD+lfw1se1m5qUJ6O9FPr5V4do3yWz1BHo5Mrz
         sEcO9KnLMM7pHiEKIjoPdFtwoshTRJsJ0BapoDWbYCvS8MNiruAEcTYALr+centkzLOh
         nJ5AZLgsPyJ4SR0d+A+m+AnTWv5J7WyKGOzrE1d90Z3Ui8wNefLZb3IGJUpvRclIFtO4
         aks7nZ2t8NZQyRWxjjFTBJiERPDFzRQCeMunJNkCzAOwZ2yXZJ3Os12kXCuUrzEP4xGh
         FECeC5hWVWQ7pDgnzqo/L5H8z7jeAtlqfL+bccfCRxkhN4QPd7VKw56o70nr5wYVK6cN
         IM+A==
X-Forwarded-Encrypted: i=1; AHgh+RqSVG2WwUUOdIP6xqSuf72evhBaojv8Qn/+VdRCTpY3rSwDY4A95YmD/ziOr6hwxQBIRA+QpLQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwU1wFeSdvlX/aFedGCbC+QQLdd9AE/km/03w6q20gFB61hzV5D
	RQXZzeWO9s3SFY0CSW04gDXT5v87UQcUKBJPxr6GkB5tTCIy3QfAqFo2AQuSbSPnP9KIowPnBOu
	9aQMjAIw3gQdul8VmpSnwQGp3/QFthNC+ClVPtZsXnB3oG9BRXdw+VFc9EQ==
X-Gm-Gg: AfdE7cnT/pzsF0GohR51NL2qzUMeSoL4AXxZnwpszIfawK6P/ES0HFrUucWpDGk1F6g
	FOeeJsfbEtZO9e/dHHlztDGqYPE6Y9zVY4wAKO2mxbHzNz8dWvXdihC8IT6SnZX6OXrD1y9qE2A
	tYp4ejO/B7wy30uAcs+Ed2UI1W7uMVYFcWJHV0DApmWQLiOh4GaDJudagLwBcNJXyJRSt/RKkmU
	b8lhXpR1k9XOBjIX3jCnYQA5X5mgjlbFjZ8KKCyEA4GxZ8bPjfj312mpL654mCRcI9w6wstxmy6
	pS3MvR/lfofLpjO/euhsZ7LaXPGjILP+EwYn8Rpe61qk06VVgHLwPtgXVUnwziSXILJMDRCWQyV
	DWtJZ2nPLh8gIqZRfD3SRo2ct3Oir1nJNmakX2ePhyVwEbn1GPEXi3Q==
X-Received: by 2002:a17:90b:58cb:b0:36b:7c2a:263e with SMTP id 98e67ed59e1d1-37dfa2a229amr6235473a91.20.1782474195886;
        Fri, 26 Jun 2026 04:43:15 -0700 (PDT)
X-Received: by 2002:a17:90b:58cb:b0:36b:7c2a:263e with SMTP id 98e67ed59e1d1-37dfa2a229amr6235429a91.20.1782474195355;
        Fri, 26 Jun 2026 04:43:15 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37df39dc707sm3703588a91.3.2026.06.26.04.43.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2026 04:43:14 -0700 (PDT)
Message-ID: <8f81ed99-c53a-4196-baa2-adea9239a000@redhat.com>
Date: Fri, 26 Jun 2026 21:43:03 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 29/44] arm64: RMI: Runtime faulting of memory
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
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
 <9482dfbc-4d96-47ba-a615-f4ba0bda833f@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <9482dfbc-4d96-47ba-a615-f4ba0bda833f@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2rmgXHy08nfNQdekJ-F27aWhJEsX1OwOzCpc8gaQsho_1782474196
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/26/26 6:47 PM, Suzuki K Poulose wrote:
> On 26/06/2026 08:43, Gavin Shan wrote:
>> On 6/26/26 1:58 AM, Suzuki K Poulose wrote:
>>> On 25/06/2026 14:53, Gavin Shan wrote:
>>>> On 6/6/26 12:35 AM, Lorenzo Pieralisi wrote:
>>>>> On Fri, Jun 05, 2026 at 06:11:11PM +1000, Gavin Shan wrote:
>>>>>> On 6/5/26 5:28 PM, Lorenzo Pieralisi wrote:
>>>>>>> On Fri, Jun 05, 2026 at 04:23:15PM +1000, Gavin Shan wrote:
>>
>> [...]
>>
>>>>>>
>>>>>> I tried to rebase Jean's latest QEMU series [1] to upstream QEMU, and found
>>>>>> that memory slots backed by THP are broken. With THP disabled on the host and
>>>>>> other fixes (mentioned in my prevous replies) applied on the top of this (v14)
>>>>>> series, I'm able to boot a realm guest with rebased QEMU series [2], plus more
>>>>>> fxies on the top.
>>>>>>
>>>>>> [1] https://git.codelinaro.org/linaro/dcap/qemu.git  (branch: cca/ latest)
>>>>>> [2] https://git.qemu.org/git/qemu.git                (branch: cca/ gavin)
>>>>>>
>>>>>> Lorenzo, You may be saying there is someone making QEMU to support ARM/CCA?
>>>>>
>>>>> Mathieu and I are working on that yes and with Steven/Suzuki to fix the THP
>>>>> issues you pointed out above.
>>>>>
>>>>>> If so, I'm not sure if there is a QEMU repository for me to try?
>>>>>
>>>>> We should be able to submit patches by end of June - we shall let you know
>>>>> whether we can make something available earlier.
>>>>>
>>>>
>>>> Not sure if there are other known issues in this series. It seems the stage2
>>>> page fault handling on the shared space isn't working well. In my test, the
>>>> vring (struct vring_desc) of virtio-net-pci is updated by the guest, and the
>>>> data isn't seen by QEMU, I'm suspecting if the host-page-frame-number is properly
>>>> resolved in the s2 page fault handler for shared (unprotected) space.
>>>>
>>>> - I rebased Jean's latest qemu branch to the upstream qemu;
>>>>
>>>> - On the host, which is emulated by qemu/tcg, the THP (transparent huge page) is
>>>>    disabled.
>>>>
>>>> - On the guest, I can see the virtio vring (struct vring_desc) is updated. The
>>>>    S1 page-table entry looks correct because the corresponding physical address
>>>>    0x10046880000 is a sane shared (unprotected) space address.
>>>>
>>>>    [   52.094143] software IO TLB: Memory encryption is active and system is using DMA bounce buffers
>>>>    [   52.289746] virtqueue_add_desc_split: desc[0]@0xffff000006880000, [00000100b983f000  00000640  0002  0001]
>>>>    [   52.432150] PTE 0x00e8010046880707 at address 0xffff000006880000
>>>>
>>>> - On the host, the s2 page-table-entry is unmapped due to attribute transition (private -> shared).
>>>>    A subsequent S2 page fault is raised against the adress and the s2 page-table-entry is built.
>>>>
>>>>    [  109.259077] ====> realm_unmap_shared_range: tracked_unprot_addr=0x10046880000
>>>>    [  109.260249] realm_unmap_shared_range: unmapped shared range at 0x10046880000
>>>>    [  109.317786] realm_unmap_shared_range: unmapped shared range at 0x10046880000
>>>>    [  109.629939] ====> kvm_handle_guest_abort: fault_ipa=0x10046880000, esr=0x92000007
>>>>    [  109.630245] realm_map_non_secure: ipa=0x10046880000, pfn=0xb8b59, size=0x1000, prot=0xf
>>>>    [  109.630331] realm_map_non_secure: ipa=0x10046880000, ipa_top=0x10046881000, flags=0x1e0001, range_desc=0xb8b59004
>>>
>>> Are you able to correlate the order of the transitions and the Guest
>>> access with RMM log ? We haven't seen this from our end. We are aware
>>> of permission fault issues with Unprotected IPA when backing the memslot
>>> with MAP_PRIVATE areas. But this looks different.
>>>
>>> Lorenzo, have you run into this ?
>>>
>>
>> It's hard to correlate the order since the logs are collected from two separate
>> consoles. For the write permission, I add code to the host where the permission
>> is always added for all s2 page faults in the shared space. Otherwise, qemu can
>> be killed by -EFAULT or similar error.
> 
> This is the problem. We can't add WRITE permission by default. I believe
> you may have MAP_PRIVATE mapping and it has to be mapped as READ only
> and on a permission fault, we replace it with a writable page. By
> overriding the WRITE permission, you let the guest write to a page
> that may not be seen by the VMM.
> 
> We identified this as a bug in the KVM driver in this series (reported
> by Lorenzo) and there is a corresponding tf-RMM change that is required
> to get this working. So, please could you wait until the next series
> when this will be addressed ? Or you could switch to using MAP_SHARED
> for the "shared" memory in the memslot.
> 

Exactly. the syntax for MAP_PRIVATE is broken if the write permission is
enforced for a read fault in the shared space. In my case, the host page can
be the zero page and eventually multiple s2 page-table entries (for multiple
unprotected or shared pages) point to the zero page. It's why clearing the
3rd queue (Ctrl queue) also clears the first queue (Rx queue) in my case.

Yes, this issue can be avoid by using a shared memory backend in qemu, something
like below. With this, I'm able to see virtio-net-pci starts to work...

     -object memory-backend-ram,id=mem0,size=2G,share=yes

Thanks,
Gavin

> 
> Suzuki
> 
> 
>>
>> There are more findings after more experiments: this virtio-net-pci device has 3
>> queues or vrings (Rx/Tx/Ctrl). The Rx/Tx/Ctrl queue are populated in order one after
>> one. In the guest kernel, I intentionally write fixed data (0x0123456789abcdef) to
>> the first 8 bytes of the queue when it gets populated, and stop the guest at random
>> points to see if the data is gone. I found that the data written to Rx/ Tx queue are
>> lost after Ctrl queue is allocated.
>>
>> The data written to Rx/Tx queue is lost if the guest stops (B). The data written to
>> Rx/Tx queue isn't lost if the guest stops at (A). I can see the pattern (0x0123...cdef)
>> by dumping the physcial memory through 'pmemsave' command in qemu.
>>
>> DMA allocation
>> ==============
>> dma_alloc_coherent
>>    dma_alloc_attrs
>>      dma_direct_alloc
>>        __dma_direct_alloc_pages
>>        dma_set_decrypted                    // (A) No data lost if being stopped here for the Ctrl queue
>>        memset(ret, 0, size)                 // (B) Data lost after being stopped after memset() for the Ctrl queue
>>
>> The memset() on the Ctrl queue should trigger a stage2 page fault. It seems the page
>> fault enforces the shared pages for Rx/Tx queue to be dropped? I need to add more
>> debugging code and track it down.
>>
>>> Suzuki
>>>
>>>
>>>>
>>>> - On QEMU, the updated vring (struct vring_desc) at GPA 0x46880000 isn't seen. All the
>>>>    data in that adress are zeros.
>>>>
>>>>    ====> virtqueue_split_pop: vdev=<virtio-net>, sz=0x38, queue_index=0x0, vq->vring.num=0x100
>>>>    virtqueue_split_pop: last_avail_idx=0x0, head=0x0
>>>>    address_space_read_cached_slow: cache@0xffff1c036440, addr=0x0, buf=0xffffeee34880, len=0x10
>>>>    address_space_read_cached_slow: cache: ptr=0x0, xlat=0x10046880000, len=0x1000, mrs=<realm-dma-region>, is_write=no
>>>>    address_space_read_cached_slow: translated to mr=<mach-virt.ram>, mr_addr=0x6880000, l=0x10
>>>>    flatview_read_continue_step: mr=<mach-virt.ram>, host=0xffff23e00000, mr_addr=0x6880000, ram_ptr=0xffff2a680000
>>>>    virtqueue_split_pop: desc: 0000000000000000 - 00000000 - 00000000 - 00000000
>>>>    qemu-system-aarch64: virtio: zero sized buffers are not allowed
>>>>
>>>>
>> Thanks,
>> Gavin
>>
> 

