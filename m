Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53084A13
	for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 23:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666048255;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HK/sOYAOUF+Wgu2q9ChioZOCXwS8WyiwOj38FtjnWoQ=;
	b=fD7nlNEzIB2J9CXW8HlRODVqqF2UIswc4QF86H5aSFZL87Xz9c6RKk907He/CtHXqHQXor
	J/QxrdE3OTC2VOs+ulAfRUUfFrsAF/5Dr59GW8eH5Y6TI7UHeD/G5kGTnsqlWR31Prr80u
	hvtnNW546tjpWvm0NruQwrzKu4eIbaE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-QxuXVbsQMOqllH4t79Mxvg-1; Mon, 17 Oct 2022 19:10:54 -0400
X-MC-Unique: QxuXVbsQMOqllH4t79Mxvg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D745811E75;
	Mon, 17 Oct 2022 23:10:53 +0000 (UTC)
Received: from [10.64.54.70] (vpn2-54-70.bne.redhat.com [10.64.54.70])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 522972027064;
	Mon, 17 Oct 2022 23:10:47 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate memory
 sizes
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
 Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, ajones@ventanamicro.com,
 pbonzini@redhat.com, maz@kernel.org, shuah@kernel.org,
 oliver.upton@linux.dev, peterx@redhat.com, ricarkol@google.com,
 zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
 <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
 <Y03ScGUUCA1KwlLF@google.com>
 <9781c88f-06f9-4d17-8fa6-3cd82a739ccb@redhat.com>
 <93529fb7-f558-cc5f-d5bd-7923eb4b492c@maciej.szmigiero.name>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <fd6287fc-c56f-4c08-0885-8ab32fdfeb7e@redhat.com>
Date: Tue, 18 Oct 2022 07:10:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <93529fb7-f558-cc5f-d5bd-7923eb4b492c@maciej.szmigiero.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Message-ID: <20221017231044.4h56fct4QMUrvTdCQ-BgT04AgN2fL1z2pqocaLTMPH8@z>

On 10/18/22 6:56 AM, Maciej S. Szmigiero wrote:
> On 18.10.2022 00:51, Gavin Shan wrote:
>> On 10/18/22 6:08 AM, Sean Christopherson wrote:
>>> On Mon, Oct 17, 2022, Maciej S. Szmigiero wrote:
>>>>> +#define MEM_EXTRA_SIZE        0x10000
>>>>
>>>> Also, an expression like "(64 << 10)" is more readable than a "1"
>>>> with a tail of zeroes (it's easy to add one zero too many or be one
>>>> zero short).
>>>
>>> +1 to not open coding raw numbers.
>>>
>>> I think it's high time KVM selftests add #defines for the common sizes, e.g. SIZE_4KB,
>>> 16KB, 64K, 2MB, 1GB, etc...
>>>
>>> Alternatively (or in addition), just #define 1KB, 1MB, 1GB, and 1TB, and then do
>>> math off of those.
>>>
>>
>> Ok. I will have one separate patch to define those sizes in kvm_util_base.h,
>> right after '#define NSEC_PER_SEC 1000000000L'. Sean, could you let me know
>> if it looks good to you?
>>
>>      #define KB         (1UL << 10)
>>      #define MB         (1UL << 20)
>>      #define GB         (1UL << 30)
>>      #define TB         (1UL << 40)
>>
>>      /* Base page and huge page size */
>>      #define SIZE_4KB   (  4 * KB)
>>      #define SIZE_16KB  ( 16 * KB)
>>      #define SIZE_64KB  ( 64 * KB)
>>      #define SIZE_2MB   (  2 * MB)
>>      #define SIZE_32MB  ( 32 * MB)
>>      #define SIZE_512MB (512 * MB)
>>      #define SIZE_1GB   (  1 * GB)
>>      #define SIZE_16GB  ( 16 * GB)
> 
> FYI, QEMU uses KiB, MiB, GiB, etc., see [1].
> 

Right. I checked QEMU's definitions and it makes sense to use
KiB, MiB, GiB, TiB. I don't think we need PiB and EiB because
our tests don't use that large memory.

> 
> [1]: https://git.qemu.org/?p=qemu.git;a=blob;f=include/qemu/units.h;hb=HEAD
> 

Thanks,
Gavin

