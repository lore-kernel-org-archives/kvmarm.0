Return-Path: <SRS0=u/VZ=KG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F46CC433B4
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 10:26:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E169961935
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 10:26:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E169961935
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 509DB4B4B4;
	Tue, 11 May 2021 06:26:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u3F4DX3LNkMm; Tue, 11 May 2021 06:26:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18EE34B2D0;
	Tue, 11 May 2021 06:26:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C7A24B2D0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 06:26:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nqf4LmfeRaeh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 May 2021 06:26:23 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4FEA84B2CE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 06:26:23 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2848D610C9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 10:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1620728782;
 bh=95zZVK7qfIh+tOUiU4moyxlDwWV95Vmvl6IczEmpWaQ=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=jB28dGoEQZhWVX4kG3NoWMrOUOJqKxtGnVTy20zjRDxZSYi5HDoH9X4KG04ToeloA
 cDtUs47l0amh5owyQHo9Y71oQ4LjdMeLKiJKekCv6EqMBcFAvE6kFY+zLTpnzK2c02
 7NweGlJAUMef4+eX+40tudEHBQhgb9TWfDjReYJgblgVGGMr9/GmZ/91vitXEd782t
 g9xjaa2eZafJ5DzGUi2oT6AyQqRubnfU9TEwg5H9ElYCJfxuOahiwURSuGFYl4ZES1
 rQXX3sG+FHbaG+SB1zpITPkwnC4j3iSe7CdYaT/+XuyT3ovBDEvX1eDXOge37ZUbm5
 6GXvX4c06Mn7w==
Received: by mail-ot1-f45.google.com with SMTP id
 i23-20020a9d68d70000b02902dc19ed4c15so13082223oto.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 03:26:22 -0700 (PDT)
X-Gm-Message-State: AOAM5312xq5SFRfxKkVn5UIDC0nUXK8JF5zFnnI38WRMwCZ0eg7740XL
 olKIPyo093ZJZO9chbQeBv+GJe6bQA7mpkYDiww=
X-Google-Smtp-Source: ABdhPJx7OAWZjUg75AH1MONFkX/rKqoEq6W+l0O8JhjgsRoszXYlOPWDD3ytFXdgmlzvdYrIN3iUwS6soQhwbypE0Tw=
X-Received: by 2002:a9d:7cd8:: with SMTP id r24mr13558179otn.90.1620728781371; 
 Tue, 11 May 2021 03:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210511100550.28178-1-rppt@kernel.org>
 <20210511100550.28178-5-rppt@kernel.org>
In-Reply-To: <20210511100550.28178-5-rppt@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 11 May 2021 12:26:10 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE=XMhr6WB+DUZYN9Fr95azn6t_B7VS3BckMPNTn_ohkg@mail.gmail.com>
Message-ID: <CAMj1kXE=XMhr6WB+DUZYN9Fr95azn6t_B7VS3BckMPNTn_ohkg@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] arm64: drop pfn_valid_within() and simplify
 pfn_valid()
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
> The arm64's version of pfn_valid() differs from the generic because of two
> reasons:
>
> * Parts of the memory map are freed during boot. This makes it necessary to
>   verify that there is actual physical memory that corresponds to a pfn
>   which is done by querying memblock.
>
> * There are NOMAP memory regions. These regions are not mapped in the
>   linear map and until the previous commit the struct pages representing
>   these areas had default values.
>
> As the consequence of absence of the special treatment of NOMAP regions in
> the memory map it was necessary to use memblock_is_map_memory() in
> pfn_valid() and to have pfn_valid_within() aliased to pfn_valid() so that
> generic mm functionality would not treat a NOMAP page as a normal page.
>
> Since the NOMAP regions are now marked as PageReserved(), pfn walkers and
> the rest of core mm will treat them as unusable memory and thus
> pfn_valid_within() is no longer required at all and can be disabled by
> removing CONFIG_HOLES_IN_ZONE on arm64.
>
> pfn_valid() can be slightly simplified by replacing
> memblock_is_map_memory() with memblock_is_memory().
>
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> Acked-by: David Hildenbrand <david@redhat.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

... and many thanks for cleaning this up.


> ---
>  arch/arm64/Kconfig   | 3 ---
>  arch/arm64/mm/init.c | 2 +-
>  2 files changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 9f1d8566bbf9..d7dc8698cf8e 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1052,9 +1052,6 @@ config NEED_PER_CPU_EMBED_FIRST_CHUNK
>         def_bool y
>         depends on NUMA
>
> -config HOLES_IN_ZONE
> -       def_bool y
> -
>  source "kernel/Kconfig.hz"
>
>  config ARCH_SPARSEMEM_ENABLE
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index 798f74f501d5..fb07218da2c0 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -251,7 +251,7 @@ int pfn_valid(unsigned long pfn)
>         if (!early_section(ms))
>                 return pfn_section_valid(ms, pfn);
>
> -       return memblock_is_map_memory(addr);
> +       return memblock_is_memory(addr);
>  }
>  EXPORT_SYMBOL(pfn_valid);
>
> --
> 2.28.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
