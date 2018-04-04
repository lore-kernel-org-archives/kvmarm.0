From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: [RFC PATCH v2 13/15] khwasan: add hooks implementation
Date: Wed, 4 Apr 2018 19:00:35 +0200
Message-ID: <CAAeHK+xmCLe85_QNDam_BVTp9wVzjxgvko2+0JapJCzmciGa5g@mail.gmail.com>
References: <cover.1521828273.git.andreyknvl@google.com>
 <ba4a74ba1bc48dd66a3831143c3119d13c291fe3.1521828274.git.andreyknvl@google.com>
 <805d1e85-2d3c-2327-6e6c-f14a56dc0b67@virtuozzo.com>
 <CAAeHK+yg5ODeDy7k9fako5mcCLLnBrO729Zp_-UtDuzh3hZgZA@mail.gmail.com>
 <0c4397da-e231-0044-986f-b8468314be76@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D92C40357
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Apr 2018 12:52:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oJAEEppiD5oB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Apr 2018 12:52:09 -0400 (EDT)
Received: from mail-io0-f172.google.com (mail-io0-f172.google.com
 [209.85.223.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B19E3402E7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Apr 2018 12:52:09 -0400 (EDT)
Received: by mail-io0-f172.google.com with SMTP id y128so27172598iod.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Apr 2018 10:00:38 -0700 (PDT)
In-Reply-To: <0c4397da-e231-0044-986f-b8468314be76@virtuozzo.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Julien Thierry <julien.thierry@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christopher Li <sparse@chrisli.org>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Paul Lawrence <paullawrence@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Yury Norov <ynorov@caviumnetworks.com>, Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Michael Weiser <michael.weiser@gmx.de>, Ingo Molnar <mingo@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, Mark Brand <markbrand@google.com>, kasan-dev <kasan-dev@googlegroups.com>, kvmarm@lists.cs.columbia.edu, linux-sparse@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, David Rientjes <rientjes@google.com>, Ramana Radhakrishnan <Ramana.Radhakrishna>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 4, 2018 at 2:39 PM, Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
>>>
>>> You can save tag somewhere in page struct and make page_address() return tagged address.
>>>
>>> I'm not sure it might be even possible to squeeze the tag into page->flags on some configurations,
>>> see include/linux/page-flags-layout.h
>>
>> One page can contain multiple objects with different tags, so we would
>> need to save the tag for each of them.
>
> What do you mean? Slab page? The per-page tag is needed only for !PageSlab pages.
> For slab pages we have kmalloc/kmem_cache_alloc() which already return properly tagged address.
>
> But the page allocator returns a pointer to struct page. One has to call page_address(page)
> to use that page. Returning 'ignore-me'-tagged address from page_address() makes the whole
> class of bugs invisible to KHWASAN. This is a serious downside comparing to classic KASAN which can
> detect missuses of page allocator API.

Yes, slab page. Here's an example:

1. do_get_write_access() allocates frozen_buffer with jbd2_alloc,
which calls kmem_cache_alloc, and then saves the result to
jh->b_frozen_data.

2. jbd2_journal_write_metadata_buffer() takes the value of
jh_in->b_frozen_data and calls virt_to_page() (and offset_in_page())
on it.

3. jbd2_journal_write_metadata_buffer() then calls kmap_atomic(),
which calls page_address(), on the resulting page address.

The tag gets erased. The page belongs to slab and can contain multiple
objects with different tags.

>>> I don't see any possible way of khwasan_enabled being 0 here.
>>
>> Can't kmem_cache_alloc be called for the temporary caches that are
>> used before the slab allocator and kasan are initialized?
>
> kasan_init() runs before allocators are initialized.
> slab allocator obviously has to be initialized before it can be used.

Checked the code, it seems you are right. Boot caches are created
after kasan_init() is called. I will remove khwasan_enabled.

Thanks!
