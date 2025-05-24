Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337011A288;
	Sat, 24 May 2025 11:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748085559; cv=none; b=GHrNqzb4l29oTd0f1kAyRHGopq80MbzQ9DcZTDKJxZc6wSCPrZX7us+KqGOPc/+7i6zTmhLIu/e6BqQU3yxJI8RCVGtQqYcdjrTLoEnknpv/M7/uaPb5adq7dlvwuB4kIg6kPNRhpNqACcqD1CFPipkPiml8EQYXQOr/j2JwrlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748085559; c=relaxed/simple;
	bh=ZeM+da8JfZ8lnROmjH/nTyqDodwA3mKLYrHfnIhGZ/A=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-Version:Content-Type; b=Q4YcaqGR9AsAwxBwdBVoukCH5mRYPUwenYLG8c0JxOHsrJlZ0xNxaJAaMvTyB6GUW6U6Te7DZ+Hghi0pGC29GOB4Nd2DsQg+9GcRayO/6G/awFgaBzOHE2DIUZCKWQQnHwpM5KIC6UpHf9MfCd5e/Yzlu8VjDxr63m/c8xfH0xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TFg84diE; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TFg84diE"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7399838db7fso605986b3a.0;
        Sat, 24 May 2025 04:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748085556; x=1748690356; darn=lists.linux.dev;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=rScpXVbASUqjAgnv8asCUXuGu69m7xK2h2FjiRqoUxs=;
        b=TFg84diEAR06tPgIxhcxvKm84ho3pIz+clLDwwjNuq3tONEyRu6S64n5yOSGUQG5h/
         E+c+SKJJKD+FnEgBns8u2xxMiIShj8lMIb8EgtFfP4QoDQjavRWgRTSwduoXAGqR0x+v
         ttrYB+oYdmIwKd65zm65yfAVW2umaLWrQVQ+Eu9UQzJpsEenMFmRRJCmSkq9njTUtKiR
         GemymKM7QcSVBwIYQ85xVkeq4negty+LQxAAOpcPzmUu8JNatDkvtzzFcor2awTtsS9H
         k+dwny7PlCKWv3USb7ke1A9htTfPC31l7Q36wlf7MzqokCR1rIbz4ucwywTv+Qwg057r
         O/Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748085556; x=1748690356;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rScpXVbASUqjAgnv8asCUXuGu69m7xK2h2FjiRqoUxs=;
        b=FzAwgXJ6g2pbpxDuntW2JYtzmxTMrwQfpQnpHK6jQuvwXUUdhDc/u7w4fHG4XEbOTk
         lfITd9qe7ZEhIOJsJJf57NKmrVe2fHW4ZemeK7tNfzhRCV06pdYYGzCd92XA9lr7feHg
         yd9fHoN07b38ZBDSOPZBa+pltLtALgKX+BeyG9nl8oABE39yDckX+JwUyteKBTXUpFnx
         TUMzYTBSZukkFKpqmuy0kCUcxVdifAaOlrHYn1YW0OlTsSV3sYIdFYXtR2F4gycAv6C+
         6+OlU8XiZ45E1uO2PLzYwUaLetxCY3VeOrT3/iIIN+7C4bwWa8hXu5xtsk99zeqQo42f
         fQYA==
X-Forwarded-Encrypted: i=1; AJvYcCUII0lfTP3HMHY+cj7JP/D5EZwjLPJmhgnAWMG8qZdaLnApe+DCXJeN26KHOcumQiqgQXwNHFM=@lists.linux.dev, AJvYcCWpNFM4OFEvhjq4pWkqf1JR5PMrecumN+so7GGmuATnMBbhUZIlUCENHewIHqIIKv/NHKCp/g==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0YLvZpIxl8oRHEZeztJS3K5BpI9zG2gC13xr7eNDtBWuSLNB5
	l+523/XkUoXeY33X8GRRsK4AzogX5nK2W1F6RsWin2VaeCIymWV/fEwMMMNnJQ==
X-Gm-Gg: ASbGncvzuT7MFdNCjbfH3XPyLss1Ih4H6wkBYmXEDqzq5T0Xjt8mMmqSCXWqWk0Ybbo
	dNDy4IUjOtYZxfei3hboCu100zcdA9XYs51iWgbn3NAkL5EJ9Kj2sX/IDlR3KuYZZuvwup+dVSD
	s6lXvttmKpwHC3hFCh70yT+bHko8Wt5SRU9R7sKCiR7Mv0SKGfcyJ2HtQB1mvP1u5LSEOlvIwGd
	tb7JVLMIX1HK3R7/avLgMj+nNJV8YmwKHHc9OFIN/KyPe6LQgy4mnukViyz0Xh5HW5MaKg9ua2p
	5y08k/WDRsasBg7IIIpnrlDugdr1lvK9dQx3ZHaD8Bh4YLwjjADQZ5A=
X-Google-Smtp-Source: AGHT+IHzgyF4RMk4/VcB/ult2huesDrd3BktU05/6T5tjhGyNb1hL3EGlpy4BVyGxnMoNfwEQoYJDQ==
X-Received: by 2002:a05:6a00:1903:b0:73e:2367:c914 with SMTP id d2e1a72fcca58-745fe068d61mr3795551b3a.7.1748085556260;
        Sat, 24 May 2025 04:19:16 -0700 (PDT)
Received: from dw-tp ([49.205.218.89])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a96dfacesm14024380b3a.5.2025.05.24.04.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 May 2025 04:19:15 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <kees@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linuxppc-dev@lists.ozlabs.org, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	Christoph Hellwig <hch@lst.de>, Marco Elver <elver@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Masahiro Yamada <masahiroy@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas.schier@linux.dev>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	kasan-dev@googlegroups.com, linux-doc@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-efi@vger.kernel.org, linux-hardening@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, sparclinux@vger.kernel.org, 
	llvm@lists.linux.dev
Subject: Re: [PATCH v2 08/14] powerpc: Handle KCOV __init vs inline mismatches
In-Reply-To: <20250523043935.2009972-8-kees@kernel.org>
Date: Sat, 24 May 2025 16:13:02 +0530
Message-ID: <87jz662ssp.fsf@gmail.com>
References: <20250523043251.it.550-kees@kernel.org> <20250523043935.2009972-8-kees@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Kees Cook <kees@kernel.org> writes:

> When KCOV is enabled all functions get instrumented, unless
> the __no_sanitize_coverage attribute is used. To prepare for
> __no_sanitize_coverage being applied to __init functions, we have to
> handle differences in how GCC's inline optimizations get resolved. For
> s390 this requires forcing a couple functions to be inline with
> __always_inline.
>
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Naveen N Rao <naveen@kernel.org>
> Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
> Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: <linuxppc-dev@lists.ozlabs.org>
> ---
>  arch/powerpc/mm/book3s64/hash_utils.c    | 2 +-
>  arch/powerpc/mm/book3s64/radix_pgtable.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
> index 5158aefe4873..93f1e1eb5ea6 100644
> --- a/arch/powerpc/mm/book3s64/hash_utils.c
> +++ b/arch/powerpc/mm/book3s64/hash_utils.c
> @@ -409,7 +409,7 @@ static DEFINE_RAW_SPINLOCK(linear_map_kf_hash_lock);
>  
>  static phys_addr_t kfence_pool;
>  
> -static inline void hash_kfence_alloc_pool(void)
> +static __always_inline void hash_kfence_alloc_pool(void)
>  {
>  	if (!kfence_early_init_enabled())
>  		goto err;
> diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
> index 9f764bc42b8c..3238e9ed46b5 100644
> --- a/arch/powerpc/mm/book3s64/radix_pgtable.c
> +++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
> @@ -363,7 +363,7 @@ static int __meminit create_physical_mapping(unsigned long start,
>  }
>  
>  #ifdef CONFIG_KFENCE
> -static inline phys_addr_t alloc_kfence_pool(void)
> +static __always_inline phys_addr_t alloc_kfence_pool(void)
>  {
>  	phys_addr_t kfence_pool;
>  

I remember seeing a warning msg around .init.text section. Let me dig
that...

... Here it is: https://lore.kernel.org/oe-kbuild-all/202504190552.mnFGs5sj-lkp@intel.com/

I am not sure why it only complains for hash_debug_pagealloc_alloc_slots().
I believe there should me more functions to mark with __init here.
Anyways, here is the patch of what I had in mind.. I am not a compiler expert,
so please let me know your thoughts on this.

-ritesh


From 59d64dc0014ccb4ae13ed08ab596738628ee23b1 Mon Sep 17 00:00:00 2001
Message-Id: <59d64dc0014ccb4ae13ed08ab596738628ee23b1.1748084756.git.ritesh.list@gmail.com>
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Date: Sat, 24 May 2025 16:14:08 +0530
Subject: [RFC] powerpc/mm/book3s64: Move few kfence & debug_pagealloc
 related calls to __init section

Move few kfence and debug_pagealloc related functions in hash_utils.c
and radix_pgtable.c to __init sections since these are only invoked once
by an __init function during system initialization.

i.e.
- hash_debug_pagealloc_alloc_slots()
- hash_kfence_alloc_pool()
- hash_kfence_map_pool()
  The above 3 functions only gets called by __init htab_initialize().

- alloc_kfence_pool()
- map_kfence_pool()
  The above 2 functions only gets called by __init radix_init_pgtable()

This should also help fix warning msgs like:

>> WARNING: modpost: vmlinux: section mismatch in reference:
hash_debug_pagealloc_alloc_slots+0xb0 (section: .text) ->
memblock_alloc_try_nid (section: .init.text)

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202504190552.mnFGs5sj-lkp@intel.com/
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/mm/book3s64/hash_utils.c    | 6 +++---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
index 5158aefe4873..4693c464fc5a 100644
--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -343,7 +343,7 @@ static inline bool hash_supports_debug_pagealloc(void)
 static u8 *linear_map_hash_slots;
 static unsigned long linear_map_hash_count;
 static DEFINE_RAW_SPINLOCK(linear_map_hash_lock);
-static void hash_debug_pagealloc_alloc_slots(void)
+static __init void hash_debug_pagealloc_alloc_slots(void)
 {
 	if (!hash_supports_debug_pagealloc())
 		return;
@@ -409,7 +409,7 @@ static DEFINE_RAW_SPINLOCK(linear_map_kf_hash_lock);
 
 static phys_addr_t kfence_pool;
 
-static inline void hash_kfence_alloc_pool(void)
+static __init void hash_kfence_alloc_pool(void)
 {
 	if (!kfence_early_init_enabled())
 		goto err;
@@ -445,7 +445,7 @@ static inline void hash_kfence_alloc_pool(void)
 	disable_kfence();
 }
 
-static inline void hash_kfence_map_pool(void)
+static __init void hash_kfence_map_pool(void)
 {
 	unsigned long kfence_pool_start, kfence_pool_end;
 	unsigned long prot = pgprot_val(PAGE_KERNEL);
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 311e2112d782..ed226ee1569a 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -363,7 +363,7 @@ static int __meminit create_physical_mapping(unsigned long start,
 }
 
 #ifdef CONFIG_KFENCE
-static inline phys_addr_t alloc_kfence_pool(void)
+static __init phys_addr_t alloc_kfence_pool(void)
 {
 	phys_addr_t kfence_pool;
 
@@ -393,7 +393,7 @@ static inline phys_addr_t alloc_kfence_pool(void)
 	return 0;
 }
 
-static inline void map_kfence_pool(phys_addr_t kfence_pool)
+static __init void map_kfence_pool(phys_addr_t kfence_pool)
 {
 	if (!kfence_pool)
 		return;
-- 
2.39.5

