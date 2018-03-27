From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: [RFC PATCH v2 11/15] khwasan, mm: perform untagged pointers
 comparison in krealloc
Date: Tue, 27 Mar 2018 14:20:49 +0200
Message-ID: <CAAeHK+xUBOt0hh-r5JhjVFcjYDOOyjUKGeN8OxSfnMpOnaWvFQ@mail.gmail.com>
References: <cover.1521828273.git.andreyknvl@google.com>
 <6eb08c160ae23eb890bd937ddf8346ba211df09f.1521828274.git.andreyknvl@google.com>
 <20180324082947.3isostkpsjraefqt@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B0D749FAC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Mar 2018 08:13:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ISp84N2icNvG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Mar 2018 08:12:43 -0400 (EDT)
Received: from mail-it0-f66.google.com (mail-it0-f66.google.com
 [209.85.214.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 973F3400D4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Mar 2018 08:12:43 -0400 (EDT)
Received: by mail-it0-f66.google.com with SMTP id e98-v6so15015251itd.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Mar 2018 05:20:51 -0700 (PDT)
In-Reply-To: <20180324082947.3isostkpsjraefqt@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ingo Molnar <mingo@kernel.org>
Cc: Julien Thierry <julien.thierry@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christopher Li <sparse@chrisli.org>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Paul Lawrence <paullawrence@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Yury Norov <ynorov@caviumnetworks.com>, Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Michael Weiser <michael.weiser@gmx.de>, kvmarm@lists.cs.columbia.edu, Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, Mark Brand <markbrand@google.com>, kasan-dev <kasan-dev@googlegroups.com>, linux-sparse@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, David Rientjes <rientjes@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Ramana Radhakrishnan <Ramana.>
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Mar 24, 2018 at 9:29 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Andrey Konovalov <andreyknvl@google.com> wrote:
>
>> The krealloc function checks where the same buffer was reused or a new one
>> allocated by comparing kernel pointers. KHWASAN changes memory tag on the
>> krealloc'ed chunk of memory and therefore also changes the pointer tag of
>> the returned pointer. Therefore we need to perform comparison on untagged
>> (with tags reset) pointers to check whether it's the same memory region or
>> not.
>>
>> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
>> ---
>>  mm/slab_common.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index a33e61315ca6..5911f2194cf7 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -1494,7 +1494,7 @@ void *krealloc(const void *p, size_t new_size, gfp_t flags)
>>       }
>>
>>       ret = __do_krealloc(p, new_size, flags);
>> -     if (ret && p != ret)
>> +     if (ret && khwasan_reset_tag(p) != khwasan_reset_tag(ret))
>>               kfree(p);
>
> Small nit:
>
> If 'reset' here means an all zeroes tag (upper byte) then khwasan_clear_tag()
> might be a slightly easier to read primitive?

'Reset' means to set the upper byte to the value that is native for
kernel pointers, and that is 0xFF. So it sets the tag to all ones, not
all zeroes. I can still rename it to khwasan_clear_tag(), if you think
that makes sense in this case as well.
