From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH v2 11/15] khwasan, mm: perform untagged pointers
 comparison in krealloc
Date: Tue, 27 Mar 2018 22:01:50 +0200
Message-ID: <20180327200150.cadizr7wsfjnfta7@gmail.com>
References: <cover.1521828273.git.andreyknvl@google.com>
 <6eb08c160ae23eb890bd937ddf8346ba211df09f.1521828274.git.andreyknvl@google.com>
 <20180324082947.3isostkpsjraefqt@gmail.com>
 <CAAeHK+xUBOt0hh-r5JhjVFcjYDOOyjUKGeN8OxSfnMpOnaWvFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D4CA49DAB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Mar 2018 15:54:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WxpBHeLN1Tt9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Mar 2018 15:53:48 -0400 (EDT)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02FCD49EA2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Mar 2018 15:53:47 -0400 (EDT)
Received: by mail-wm0-f67.google.com with SMTP id l201so987141wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Mar 2018 13:01:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAAeHK+xUBOt0hh-r5JhjVFcjYDOOyjUKGeN8OxSfnMpOnaWvFQ@mail.gmail.com>
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
Cc: Julien Thierry <julien.thierry@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christopher Li <sparse@chrisli.org>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Paul Lawrence <paullawrence@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Yury Norov <ynorov@caviumnetworks.com>, Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Michael Weiser <michael.weiser@gmx.de>, kvmarm@lists.cs.columbia.edu, Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, Mark Brand <markbrand@google.com>, kasan-dev <kasan-dev@googlegroups.com>, linux-sparse@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, David Rientjes <rientjes@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Ramana Radhakrishnan <Ramana.>
List-Id: kvmarm@lists.cs.columbia.edu


* Andrey Konovalov <andreyknvl@google.com> wrote:

> On Sat, Mar 24, 2018 at 9:29 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Andrey Konovalov <andreyknvl@google.com> wrote:
> >
> >> The krealloc function checks where the same buffer was reused or a new one
> >> allocated by comparing kernel pointers. KHWASAN changes memory tag on the
> >> krealloc'ed chunk of memory and therefore also changes the pointer tag of
> >> the returned pointer. Therefore we need to perform comparison on untagged
> >> (with tags reset) pointers to check whether it's the same memory region or
> >> not.
> >>
> >> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> >> ---
> >>  mm/slab_common.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/mm/slab_common.c b/mm/slab_common.c
> >> index a33e61315ca6..5911f2194cf7 100644
> >> --- a/mm/slab_common.c
> >> +++ b/mm/slab_common.c
> >> @@ -1494,7 +1494,7 @@ void *krealloc(const void *p, size_t new_size, gfp_t flags)
> >>       }
> >>
> >>       ret = __do_krealloc(p, new_size, flags);
> >> -     if (ret && p != ret)
> >> +     if (ret && khwasan_reset_tag(p) != khwasan_reset_tag(ret))
> >>               kfree(p);
> >
> > Small nit:
> >
> > If 'reset' here means an all zeroes tag (upper byte) then khwasan_clear_tag()
> > might be a slightly easier to read primitive?
> 
> 'Reset' means to set the upper byte to the value that is native for
> kernel pointers, and that is 0xFF. So it sets the tag to all ones, not
> all zeroes. I can still rename it to khwasan_clear_tag(), if you think
> that makes sense in this case as well.

Ok, if it's not 0 then I agree that 'reset' is the better name. 'clear' would in 
fact be actively confusing.

Thanks,

	Ingo
