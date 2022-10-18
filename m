Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCE94C8A
	for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 15:56:45 +0000 (UTC)
Received: from MUA
	by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.94.2)
	(envelope-from <mail@maciej.szmigiero.name>)
	id 1okoxF-0006rH-E8; Tue, 18 Oct 2022 17:56:33 +0200
Message-ID: <a1a8664c-4d06-89e7-8cfa-b730969bb841@maciej.szmigiero.name>
Date: Tue, 18 Oct 2022 17:56:27 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US, pl-PL
To: Gavin Shan <gshan@redhat.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 zhenyzha@redhat.com, shan.gavin@gmail.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-5-gshan@redhat.com>
 <3eecebca-a526-d10a-02d3-496ce919d577@maciej.szmigiero.name>
 <bd5df92c-6870-8053-0b35-a2ad993970bd@redhat.com>
 <da2b7db0-509a-c9e0-c36b-6487a265a779@redhat.com>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 4/6] KVM: selftests: memslot_perf_test: Support variable
 guest page size
In-Reply-To: <da2b7db0-509a-c9e0-c36b-6487a265a779@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Message-ID: <20221018155627.hg-dRGI2FdrhNY7BQiBiR2DOXPxH8vM26XWxcb_vt_M@z>

On 18.10.2022 02:51, Gavin Shan wrote:
> On 10/18/22 8:46 AM, Gavin Shan wrote:
>> On 10/18/22 5:31 AM, Maciej S. Szmigiero wrote:
>>> On 14.10.2022 09:19, Gavin Shan wrote:
>>>> The test case is obviously broken on aarch64 because non-4KB guest
>>>> page size is supported. The guest page size on aarch64 could be 4KB,
>>>> 16KB or 64KB.
>>>>
>>>> This supports variable guest page size, mostly for aarch64.
>>>>
>>>>    - The host determines the guest page size when virtual machine is
>>>>      created. The value is also passed to guest through the synchronization
>>>>      area.
>>>>
>>>>    - The number of guest pages are unknown until the virtual machine
>>>>      is to be created. So all the related macros are dropped. Instead,
>>>>      their values are dynamically calculated based on the guest page
>>>>      size.
>>>>
>>>>    - The static checks on memory sizes and pages becomes dependent
>>>>      on guest page size, which is unknown until the virtual machine
>>>>      is about to be created. So all the static checks are converted
>>>>      to dynamic checks, done in check_memory_sizes().
>>>>
>>>>    - As the address passed to madvise() should be aligned to host page,
>>>>      the size of page chunk is automatically selected, other than one
>>>>      page.
>>>>
>>>>    - All other changes included in this patch are almost mechanical
>>>>      replacing '4096' with 'guest_page_size'.
>>>>
>>>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>>>> ---
>>>>   .../testing/selftests/kvm/memslot_perf_test.c | 191 +++++++++++-------
>>>>   1 file changed, 115 insertions(+), 76 deletions(-)
>>>>
>>>> diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
>>>> index d5aa9148f96f..d587bd952ff9 100644
>>>> --- a/tools/testing/selftests/kvm/memslot_perf_test.c
>>>> +++ b/tools/testing/selftests/kvm/memslot_perf_test.c
(...)
>>>> @@ -77,8 +61,7 @@ static_assert(MEM_TEST_UNMAP_SIZE_PAGES %
>>>>    * for the total size of 25 pages.
>>>>    * Hence, the maximum size here is 50 pages.
>>>>    */
>>>> -#define MEM_TEST_MOVE_SIZE_PAGES    (50)
>>>> -#define MEM_TEST_MOVE_SIZE        (MEM_TEST_MOVE_SIZE_PAGES * 4096)
>>>> +#define MEM_TEST_MOVE_SIZE        0x32000
>>>
>>> The above number seems less readable than an explicit value of 50 pages.
>>>
>>> In addition to that, it's 50 pages only with 4k page size, so at least
>>> the comment above needs to be updated to reflect this fact.
>>>
>>
>> Yeah, I will change the comments like below in next revision.
>>
>>   /*
>>    * When running this test with 32k memslots, actually 32763 excluding
>>    * the reserved memory slot 0, the memory for each slot is 0x4000 bytes.
>>    * The last slot contains 0x19000 bytes memory. Hence, the maximum size
>>    * here is 0x32000 bytes.
>>    */
>>
> 
> I will replace those numbers with readable ones like below :)
> 
> /*
>   * When running this test with 32k memslots, actually 32763 excluding
>   * the reserved memory slot 0, the memory for each slot is 16KB. The
>   * last slot contains 100KB memory with the remaining 84KB. Hence,
>   * the maximum size is double of that (200KB)
>   */

Still, these numbers are for x86, which has KVM_INTERNAL_MEM_SLOTS
defined as 3.

As far as I can see aarch64 has KVM_INTERNAL_MEM_SLOTS equal to 0, so
this arch has 32766 slot available for the test memory.

Quick calculations show that this will result in 112 KiB of memory in
the last slot for 4 KiB page size (while for 64 KiB page size the
maximum slot count for this test is 8192 anyway - not counting slot 0).

> Thanks,
> Gavin
> 

Thanks,
Maciej

