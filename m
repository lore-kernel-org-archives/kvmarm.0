From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: [RFC PATCH v2 13/15] khwasan: add hooks implementation
Date: Tue, 10 Apr 2018 18:07:39 +0200
Message-ID: <CAAeHK+wWN=phNZgC_g5SMf61sCAVM7SGX9GdF1X4v+P3mK=uZA@mail.gmail.com>
References: <cover.1521828273.git.andreyknvl@google.com>
 <ba4a74ba1bc48dd66a3831143c3119d13c291fe3.1521828274.git.andreyknvl@google.com>
 <805d1e85-2d3c-2327-6e6c-f14a56dc0b67@virtuozzo.com>
 <CAAeHK+yg5ODeDy7k9fako5mcCLLnBrO729Zp_-UtDuzh3hZgZA@mail.gmail.com>
 <0c4397da-e231-0044-986f-b8468314be76@virtuozzo.com>
 <CAAeHK+xmCLe85_QNDam_BVTp9wVzjxgvko2+0JapJCzmciGa5g@mail.gmail.com>
 <0857f052-a27a-501e-8923-c6f31510e4fe@virtuozzo.com>
 <CAAeHK+xnHeznZwofNQVDcBCCMnaEQ6fcRxOcrFM-qQFUsZ51Rg@mail.gmail.com>
 <0f448799-3a06-a25d-d604-21db3e8577fc@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9132B49FD2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Apr 2018 11:59:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MPwPjP6kfupL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Apr 2018 11:58:56 -0400 (EDT)
Received: from mail-it0-f44.google.com (mail-it0-f44.google.com
 [209.85.214.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20A5D49EAD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Apr 2018 11:58:56 -0400 (EDT)
Received: by mail-it0-f44.google.com with SMTP id 19-v6so15482933itw.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Apr 2018 09:07:41 -0700 (PDT)
In-Reply-To: <0f448799-3a06-a25d-d604-21db3e8577fc@virtuozzo.com>
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

On Fri, Apr 6, 2018 at 2:27 PM, Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
> On 04/06/2018 03:14 PM, Andrey Konovalov wrote:
>> On Thu, Apr 5, 2018 at 3:02 PM, Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
>>> Nevertheless, this doesn't mean that we should ignore *all* accesses to !slab memory.
>>
>> So you mean we need to find a way to ignore accesses via pointers
>> returned by page_address(), but still check accesses through all other
>> pointers tagged with 0xFF? I don't see an obvious way to do this. I'm
>> open to suggestions though.
>>
>
> I'm saying that we need to ignore accesses to slab objects if pointer
> to slab object obtained via page_address() + offset_in_page() trick, but don't ignore
> anything else.
>
> So, save tag somewhere in page struct and poison shadow with that tag. Make page_address() to
> return tagged address for all !PageSlab() pages. For PageSlab() pages page_address() should return
> 0xff tagged address, so we could ignore such accesses.

Which pages do you mean by !PageSlab()? The ones that are allocated
and freed by pagealloc, but mot managed by the slab allocator? Perhaps
we should then add tagging to the pagealloc hook instead?
