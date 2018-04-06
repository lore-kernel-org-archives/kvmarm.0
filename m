From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: Re: [RFC PATCH v2 13/15] khwasan: add hooks implementation
Date: Fri, 6 Apr 2018 15:27:55 +0300
Message-ID: <0f448799-3a06-a25d-d604-21db3e8577fc@virtuozzo.com>
References: <cover.1521828273.git.andreyknvl@google.com>
 <ba4a74ba1bc48dd66a3831143c3119d13c291fe3.1521828274.git.andreyknvl@google.com>
 <805d1e85-2d3c-2327-6e6c-f14a56dc0b67@virtuozzo.com>
 <CAAeHK+yg5ODeDy7k9fako5mcCLLnBrO729Zp_-UtDuzh3hZgZA@mail.gmail.com>
 <0c4397da-e231-0044-986f-b8468314be76@virtuozzo.com>
 <CAAeHK+xmCLe85_QNDam_BVTp9wVzjxgvko2+0JapJCzmciGa5g@mail.gmail.com>
 <0857f052-a27a-501e-8923-c6f31510e4fe@virtuozzo.com>
 <CAAeHK+xnHeznZwofNQVDcBCCMnaEQ6fcRxOcrFM-qQFUsZ51Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72E5449EA2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Apr 2018 08:19:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UFCrmiiXIRZm for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Apr 2018 08:18:40 -0400 (EDT)
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr50091.outbound.protection.outlook.com [40.107.5.91])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 76792400D4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Apr 2018 08:18:40 -0400 (EDT)
In-Reply-To: <CAAeHK+xnHeznZwofNQVDcBCCMnaEQ6fcRxOcrFM-qQFUsZ51Rg@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Julien Thierry <julien.thierry@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christopher Li <sparse@chrisli.org>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Paul Lawrence <paullawrence@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Yury Norov <ynorov@caviumnetworks.com>, Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Michael Weiser <michael.weiser@gmx.de>, Ingo Molnar <mingo@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, Mark Brand <markbrand@google.com>, kasan-dev <kasan-dev@googlegroups.com>, kvmarm@lists.cs.columbia.edu, linux-sparse@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, David Rientjes <rientjes@google.com>, Ramana Radhakrishnan <Ramana.Radhakrishna>
List-Id: kvmarm@lists.cs.columbia.edu



On 04/06/2018 03:14 PM, Andrey Konovalov wrote:
> On Thu, Apr 5, 2018 at 3:02 PM, Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
>> On 04/04/2018 08:00 PM, Andrey Konovalov wrote:
>>> On Wed, Apr 4, 2018 at 2:39 PM, Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
>>>>>>
>>>>>> You can save tag somewhere in page struct and make page_address() return tagged address.
>>>>>>
>>>>>> I'm not sure it might be even possible to squeeze the tag into page->flags on some configurations,
>>>>>> see include/linux/page-flags-layout.h
>>>>>
>>>>> One page can contain multiple objects with different tags, so we would
>>>>> need to save the tag for each of them.
>>>>
>>>> What do you mean? Slab page? The per-page tag is needed only for !PageSlab pages.
>>>> For slab pages we have kmalloc/kmem_cache_alloc() which already return properly tagged address.
>>>>
>>>> But the page allocator returns a pointer to struct page. One has to call page_address(page)
>>>> to use that page. Returning 'ignore-me'-tagged address from page_address() makes the whole
>>>> class of bugs invisible to KHWASAN. This is a serious downside comparing to classic KASAN which can
>>>> detect missuses of page allocator API.
>>>
>>> Yes, slab page. Here's an example:
>>>
>>> 1. do_get_write_access() allocates frozen_buffer with jbd2_alloc,
>>> which calls kmem_cache_alloc, and then saves the result to
>>> jh->b_frozen_data.
>>>
>>> 2. jbd2_journal_write_metadata_buffer() takes the value of
>>> jh_in->b_frozen_data and calls virt_to_page() (and offset_in_page())
>>> on it.
>>>
>>> 3. jbd2_journal_write_metadata_buffer() then calls kmap_atomic(),
>>> which calls page_address(), on the resulting page address.
>>>
>>> The tag gets erased. The page belongs to slab and can contain multiple
>>> objects with different tags.
>>>
>>
>> I see. Ideally that kind of problem should be fixed by reworking/redesigning such code,
>> however jbd2_journal_write_metadata_buffer() is far from the only place which
>> does that trick. Fixing all of them would be a huge task probably, so ignoring such
>> accesses seems to be the only choice we have.
>>
>> Nevertheless, this doesn't mean that we should ignore *all* accesses to !slab memory.
> 
> So you mean we need to find a way to ignore accesses via pointers
> returned by page_address(), but still check accesses through all other
> pointers tagged with 0xFF? I don't see an obvious way to do this. I'm
> open to suggestions though.
> 

I'm saying that we need to ignore accesses to slab objects if pointer
to slab object obtained via page_address() + offset_in_page() trick, but don't ignore
anything else.

So, save tag somewhere in page struct and poison shadow with that tag. Make page_address() to
return tagged address for all !PageSlab() pages. For PageSlab() pages page_address() should return
0xff tagged address, so we could ignore such accesses.
