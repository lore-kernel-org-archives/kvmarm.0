From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: [RFC PATCH v2 08/15] khwasan: add tag related helper functions
Date: Tue, 3 Apr 2018 16:45:26 +0200
Message-ID: <CAAeHK+w9T8dTKP8tuw+B2MojvzRE6YQ1=O1FddZA62cYaeLV2g@mail.gmail.com>
References: <cover.1521828273.git.andreyknvl@google.com>
 <b79947167d09478d3f61d2ec8de37322c0e1fe92.1521828274.git.andreyknvl@google.com>
 <a724eee6-7aff-df8b-de2b-8e9446e94623@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AF3449F88
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Apr 2018 10:37:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5I9WD6+Y9mNw for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Apr 2018 10:37:04 -0400 (EDT)
Received: from mail-it0-f66.google.com (mail-it0-f66.google.com
 [209.85.214.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6DED8402E7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Apr 2018 10:37:04 -0400 (EDT)
Received: by mail-it0-f66.google.com with SMTP id 142-v6so23632531itl.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Apr 2018 07:45:30 -0700 (PDT)
In-Reply-To: <a724eee6-7aff-df8b-de2b-8e9446e94623@virtuozzo.com>
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

On Fri, Mar 30, 2018 at 6:13 PM, Andrey Ryabinin
<aryabinin@virtuozzo.com> wrote:
>
>
> On 03/23/2018 09:05 PM, Andrey Konovalov wrote:
>
>> diff --git a/mm/kasan/khwasan.c b/mm/kasan/khwasan.c
>> index 24d75245e9d0..da4b17997c71 100644
>> --- a/mm/kasan/khwasan.c
>> +++ b/mm/kasan/khwasan.c
>> @@ -39,6 +39,57 @@
>>  #include "kasan.h"
>>  #include "../slab.h"
>>
>> +int khwasan_enabled;
>
> This is not unused (set, but never used).

It's used in the "khwasan: add hooks implementation" patch. I'll move
it's declaration there as well.

Thanks!

>
>> +
>> +static DEFINE_PER_CPU(u32, prng_state);
>> +
>> +void khwasan_init(void)
>> +{
>> +     int cpu;
>> +
>> +     for_each_possible_cpu(cpu) {
>> +             per_cpu(prng_state, cpu) = get_random_u32();
>> +     }
>> +     WRITE_ONCE(khwasan_enabled, 1);
>> +}
>> +
>
