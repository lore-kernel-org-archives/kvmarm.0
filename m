From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: Re: [RFC PATCH v2 13/15] khwasan: add hooks implementation
Date: Thu, 12 Apr 2018 20:20:47 +0300
Message-ID: <a29d22c7-bcae-ec8d-1810-95eef013e699@virtuozzo.com>
References: <cover.1521828273.git.andreyknvl@google.com>
 <ba4a74ba1bc48dd66a3831143c3119d13c291fe3.1521828274.git.andreyknvl@google.com>
 <805d1e85-2d3c-2327-6e6c-f14a56dc0b67@virtuozzo.com>
 <CAAeHK+yg5ODeDy7k9fako5mcCLLnBrO729Zp_-UtDuzh3hZgZA@mail.gmail.com>
 <0c4397da-e231-0044-986f-b8468314be76@virtuozzo.com>
 <CAAeHK+xmCLe85_QNDam_BVTp9wVzjxgvko2+0JapJCzmciGa5g@mail.gmail.com>
 <0857f052-a27a-501e-8923-c6f31510e4fe@virtuozzo.com>
 <CAAeHK+xnHeznZwofNQVDcBCCMnaEQ6fcRxOcrFM-qQFUsZ51Rg@mail.gmail.com>
 <0f448799-3a06-a25d-d604-21db3e8577fc@virtuozzo.com>
 <CAAeHK+wWN=phNZgC_g5SMf61sCAVM7SGX9GdF1X4v+P3mK=uZA@mail.gmail.com>
 <bfc3da50-66df-c6ed-ad6a-a285efe617ec@virtuozzo.com>
 <CAAeHK+wzwXnJh1bbhUN6bm788q52BA2EfC+Q3dMS=peP7Px4Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2C794A0A3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Apr 2018 13:11:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VYGQvMLOekUh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Apr 2018 13:11:12 -0400 (EDT)
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-eopbgr00118.outbound.protection.outlook.com [40.107.0.118])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E2ACA4A09C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Apr 2018 13:11:11 -0400 (EDT)
In-Reply-To: <CAAeHK+wzwXnJh1bbhUN6bm788q52BA2EfC+Q3dMS=peP7Px4Rg@mail.gmail.com>
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



On 04/12/2018 07:45 PM, Andrey Konovalov wrote:
> On Tue, Apr 10, 2018 at 6:31 PM, Andrey Ryabinin
> <aryabinin@virtuozzo.com> wrote:
>>
>>
>> On 04/10/2018 07:07 PM, Andrey Konovalov wrote:
>>> On Fri, Apr 6, 2018 at 2:27 PM, Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
>>>> On 04/06/2018 03:14 PM, Andrey Konovalov wrote:
>>>>> On Thu, Apr 5, 2018 at 3:02 PM, Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
>>>>>> Nevertheless, this doesn't mean that we should ignore *all* accesses to !slab memory.
>>>>>
>>>>> So you mean we need to find a way to ignore accesses via pointers
>>>>> returned by page_address(), but still check accesses through all other
>>>>> pointers tagged with 0xFF? I don't see an obvious way to do this. I'm
>>>>> open to suggestions though.
>>>>>
>>>>
>>>> I'm saying that we need to ignore accesses to slab objects if pointer
>>>> to slab object obtained via page_address() + offset_in_page() trick, but don't ignore
>>>> anything else.
>>>>
>>>> So, save tag somewhere in page struct and poison shadow with that tag. Make page_address() to
>>>> return tagged address for all !PageSlab() pages. For PageSlab() pages page_address() should return
>>>> 0xff tagged address, so we could ignore such accesses.
>>>
>>> Which pages do you mean by !PageSlab()?
>>
>> Literally the "PageSlab(page) == false" pages.
>>
>>> The ones that are allocated and freed by pagealloc, but mot managed by the slab allocator?
>>
>> Yes.
>>
>>> Perhaps we should then add tagging to the pagealloc hook instead?
>>>
>>
>> Of course the tagging would be in kasan_alloc_pages(), where else that could be? And instead of what?
> 
> I think I misunderstood your suggestion twice already :)
> 
> To make it clear, you're suggesting:
> 
> 1. Tag memory with a random tag in kasan_alloc_pages() and returned a
> tagged pointer from pagealloc.
 
Tag memory with a random tag in kasan_alloc_pages() and store that tag in page struct (that part is also in kasan_alloc_pages()).
page_address(page) will retrieve that tag from struct page to return tagged address.

I've no idea what do you mean by "returning a tagged pointer from pagealloc".
Once again, the page allocator (__alloc_pages_nodemask()) returns pointer to *struct page*,
not the address in the linear mapping where is that page mapped (or not mapped at all if this is highmem).
One have to call page_address()/kmap() to use that page.


> 2. Restore the tag for the pointers returned from page_address for
> !PageSlab() pages.
> 

Right.

> 3. Set the tag to 0xff for the pointers returned from page_address for
> PageSlab() pages.
> 

Right.

> Is this correct?
> 
> In 2 instead of storing the tag in page_struct, we can just recover it
> from the shadow memory that corresponds to that page. What do you
> think about this?

Sounds ok. Don't see any problem with that.
