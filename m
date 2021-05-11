Return-Path: <SRS0=u/VZ=KG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B41C433B4
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 10:23:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B90C06192C
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 10:23:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B90C06192C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 069234B4B2;
	Tue, 11 May 2021 06:23:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XaFJ48LdAr9Y; Tue, 11 May 2021 06:23:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 807214B499;
	Tue, 11 May 2021 06:23:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65EEA4B499
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 06:23:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v0q7AUPDrd3F for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 May 2021 06:23:51 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 174D24B495
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 06:23:51 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5B3B610C9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 10:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1620728629;
 bh=LgxMI8vj288DChfG7lFtdchD2fE1dwuejwGWa+sggCk=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=R+bdeO7MezX3F1V357elWgM4sW2CkCVIxT5pTuXNHE83llBmmysMYE1tPhjgxT5QO
 aJFMU2497UdjGOOwTRnyBD2OMm6mxSBZAKnFlXT82UDFCmr480DibvrwbWGAxADB2c
 JjJpSvsQE1Uo2vYSGpS8Atj/L0lFn8Y6SHyAK4ZeueE59BlcPNR1mUK9YF2mNKQQJm
 DKmqRYwotraRpe1onAVNgbXbiIV0Ktw9oRHtHgJt8Fc0JXzZt5L0vP1T8F6ehuLlli
 CHnIMaF9xCSZU0u2O7F5giJeKSJxMKr26C2osLg2kXY41OhksE0I60Oob3MMiuOIsf
 K1D4M9wUcqVaA==
Received: by mail-oi1-f174.google.com with SMTP id w22so4699572oiw.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 03:23:49 -0700 (PDT)
X-Gm-Message-State: AOAM5313/wcstUMClDyWF4ls/xKlH2bAW+GpH9Co7nzWHrsoY8VEX9a9
 p6anNvIFkw74Ws0isPyfRBLW2WaQeDhDNaikLGk=
X-Google-Smtp-Source: ABdhPJyaKNLfHKqYziYG6xr+MMNfOFcPMyPRkI4YOXyAGKtGLduxWKsNWMu7qKDSpiPSpDef4WSFbSD7BiuPJbAkYdA=
X-Received: by 2002:aca:4056:: with SMTP id n83mr2978231oia.47.1620728629131; 
 Tue, 11 May 2021 03:23:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210511100550.28178-1-rppt@kernel.org>
 <20210511100550.28178-3-rppt@kernel.org>
In-Reply-To: <20210511100550.28178-3-rppt@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 11 May 2021 12:23:38 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGTDAryboM-xQuFTXDQ9eiauOyPPdWcYfeMT2fcyMcKSw@mail.gmail.com>
Message-ID: <CAMj1kXGTDAryboM-xQuFTXDQ9eiauOyPPdWcYfeMT2fcyMcKSw@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] memblock: update initialization of reserved pages
To: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mike Rapoport <rppt@linux.ibm.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Marc Zyngier <maz@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, 11 May 2021 at 12:06, Mike Rapoport <rppt@kernel.org> wrote:
>
> From: Mike Rapoport <rppt@linux.ibm.com>
>
> The struct pages representing a reserved memory region are initialized
> using reserve_bootmem_range() function. This function is called for each
> reserved region just before the memory is freed from memblock to the buddy
> page allocator.
>
> The struct pages for MEMBLOCK_NOMAP regions are kept with the default
> values set by the memory map initialization which makes it necessary to
> have a special treatment for such pages in pfn_valid() and
> pfn_valid_within().
>
> Split out initialization of the reserved pages to a function with a
> meaningful name and treat the MEMBLOCK_NOMAP regions the same way as the
> reserved regions and mark struct pages for the NOMAP regions as
> PageReserved.
>
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  include/linux/memblock.h |  4 +++-
>  mm/memblock.c            | 28 ++++++++++++++++++++++++++--
>  2 files changed, 29 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index 5984fff3f175..1b4c97c151ae 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -30,7 +30,9 @@ extern unsigned long long max_possible_pfn;
>   * @MEMBLOCK_NONE: no special request
>   * @MEMBLOCK_HOTPLUG: hotpluggable region
>   * @MEMBLOCK_MIRROR: mirrored region
> - * @MEMBLOCK_NOMAP: don't add to kernel direct mapping
> + * @MEMBLOCK_NOMAP: don't add to kernel direct mapping and treat as
> + * reserved in the memory map; refer to memblock_mark_nomap() description
> + * for further details
>   */
>  enum memblock_flags {
>         MEMBLOCK_NONE           = 0x0,  /* No special request */
> diff --git a/mm/memblock.c b/mm/memblock.c
> index afaefa8fc6ab..3abf2c3fea7f 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -906,6 +906,11 @@ int __init_memblock memblock_mark_mirror(phys_addr_t base, phys_addr_t size)
>   * @base: the base phys addr of the region
>   * @size: the size of the region
>   *
> + * The memory regions marked with %MEMBLOCK_NOMAP will not be added to the
> + * direct mapping of the physical memory. These regions will still be
> + * covered by the memory map. The struct page representing NOMAP memory
> + * frames in the memory map will be PageReserved()
> + *
>   * Return: 0 on success, -errno on failure.
>   */
>  int __init_memblock memblock_mark_nomap(phys_addr_t base, phys_addr_t size)
> @@ -2002,6 +2007,26 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
>         return end_pfn - start_pfn;
>  }
>
> +static void __init memmap_init_reserved_pages(void)
> +{
> +       struct memblock_region *region;
> +       phys_addr_t start, end;
> +       u64 i;
> +
> +       /* initialize struct pages for the reserved regions */
> +       for_each_reserved_mem_range(i, &start, &end)
> +               reserve_bootmem_region(start, end);
> +
> +       /* and also treat struct pages for the NOMAP regions as PageReserved */
> +       for_each_mem_region(region) {
> +               if (memblock_is_nomap(region)) {
> +                       start = region->base;
> +                       end = start + region->size;
> +                       reserve_bootmem_region(start, end);
> +               }
> +       }
> +}
> +
>  static unsigned long __init free_low_memory_core_early(void)
>  {
>         unsigned long count = 0;
> @@ -2010,8 +2035,7 @@ static unsigned long __init free_low_memory_core_early(void)
>
>         memblock_clear_hotplug(0, -1);
>
> -       for_each_reserved_mem_range(i, &start, &end)
> -               reserve_bootmem_region(start, end);
> +       memmap_init_reserved_pages();
>
>         /*
>          * We need to use NUMA_NO_NODE instead of NODE_DATA(0)->node_id
> --
> 2.28.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
