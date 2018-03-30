From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: Re: [RFC PATCH v2 08/15] khwasan: add tag related helper functions
Date: Fri, 30 Mar 2018 19:13:08 +0300
Message-ID: <a724eee6-7aff-df8b-de2b-8e9446e94623@virtuozzo.com>
References: <cover.1521828273.git.andreyknvl@google.com>
 <b79947167d09478d3f61d2ec8de37322c0e1fe92.1521828274.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B39CA4029E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Mar 2018 12:04:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LkmdiiE0U-p6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Mar 2018 12:04:14 -0400 (EDT)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01on0100.outbound.protection.outlook.com [104.47.0.100])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BAF2B40259
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Mar 2018 12:04:13 -0400 (EDT)
In-Reply-To: <b79947167d09478d3f61d2ec8de37322c0e1fe92.1521828274.git.andreyknvl@google.com>
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
To: Andrey Konovalov <andreyknvl@google.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christopher Li <sparse@chrisli.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Yury Norov <ynorov@caviumnetworks.com>, Nick Desaulniers <ndesaulniers@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, Punit Agrawal <punit.agrawal@arm.com>Dav
Cc: Kees Cook <keescook@google.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Jann Horn <jannh@google.com>, Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>, Lee Smith <Lee.Smith@arm.com>, Kostya Serebryany <kcc@google.com>, Mark Brand <markbrand@google.com>, Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>, Evgeniy Stepanov <eugenis@google.com>
List-Id: kvmarm@lists.cs.columbia.edu



On 03/23/2018 09:05 PM, Andrey Konovalov wrote:

> diff --git a/mm/kasan/khwasan.c b/mm/kasan/khwasan.c
> index 24d75245e9d0..da4b17997c71 100644
> --- a/mm/kasan/khwasan.c
> +++ b/mm/kasan/khwasan.c
> @@ -39,6 +39,57 @@
>  #include "kasan.h"
>  #include "../slab.h"
>  
> +int khwasan_enabled;

This is not unused (set, but never used).

> +
> +static DEFINE_PER_CPU(u32, prng_state);
> +
> +void khwasan_init(void)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		per_cpu(prng_state, cpu) = get_random_u32();
> +	}
> +	WRITE_ONCE(khwasan_enabled, 1);
> +}
> +
