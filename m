From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH v2 11/15] khwasan, mm: perform untagged pointers
 comparison in krealloc
Date: Sat, 24 Mar 2018 09:29:47 +0100
Message-ID: <20180324082947.3isostkpsjraefqt@gmail.com>
References: <cover.1521828273.git.andreyknvl@google.com>
 <6eb08c160ae23eb890bd937ddf8346ba211df09f.1521828274.git.andreyknvl@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C99B4A045
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Mar 2018 04:22:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QP6xxj7Po5a5 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 24 Mar 2018 04:21:54 -0400 (EDT)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D96C74A01F
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Mar 2018 04:21:53 -0400 (EDT)
Received: by mail-wm0-f68.google.com with SMTP id t6so7263312wmt.5
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Mar 2018 01:29:52 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <6eb08c160ae23eb890bd937ddf8346ba211df09f.1521828274.git.andreyknvl@google.com>
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
Cc: Julien Thierry <julien.thierry@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christopher Li <sparse@chrisli.org>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Paul Lawrence <paullawrence@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Yury Norov <ynorov@caviumnetworks.com>, Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Michael Weiser <michael.weiser@gmx.de>, kvmarm@lists.cs.columbia.edu, Kees Cook <keescook@google.com>, Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, Mark Brand <markbrand@google.com>, kasan-dev@googlegroups.com, linux-sparse@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, linux-arm-kernel@lists.infradead.org, David Rientjes <rientjes@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Ramana
List-Id: kvmarm@lists.cs.columbia.edu


* Andrey Konovalov <andreyknvl@google.com> wrote:

> The krealloc function checks where the same buffer was reused or a new one
> allocated by comparing kernel pointers. KHWASAN changes memory tag on the
> krealloc'ed chunk of memory and therefore also changes the pointer tag of
> the returned pointer. Therefore we need to perform comparison on untagged
> (with tags reset) pointers to check whether it's the same memory region or
> not.
> 
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> ---
>  mm/slab_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index a33e61315ca6..5911f2194cf7 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1494,7 +1494,7 @@ void *krealloc(const void *p, size_t new_size, gfp_t flags)
>  	}
>  
>  	ret = __do_krealloc(p, new_size, flags);
> -	if (ret && p != ret)
> +	if (ret && khwasan_reset_tag(p) != khwasan_reset_tag(ret))
>  		kfree(p);

Small nit:

If 'reset' here means an all zeroes tag (upper byte) then khwasan_clear_tag() 
might be a slightly easier to read primitive?

Thanks,

	Ingo
