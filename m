Return-Path: <SRS0=saMt=KH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 309DCC433B4
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 07:00:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 88D886193B
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 07:00:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88D886193B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAA6E4B837;
	Wed, 12 May 2021 03:00:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rH0N5c5bj3fu; Wed, 12 May 2021 03:00:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94C124B30D;
	Wed, 12 May 2021 03:00:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AB5B4B255
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 03:00:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h40NCVafG+0t for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 03:00:15 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CAE484B24D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 03:00:14 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79B9761936
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 07:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1620802813;
 bh=tOlm23mTOpNM0/BbK/ucKXhqG2RgCDl/OY+dbOJpNlE=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=TWprbVSJw/7Y52OoBeErncbDWObcKZErbEP7n9087p7QetbLh0+ddhF0dJN0VtnRn
 lhaJ4+89Tu10BwQTI91IyHahseZGISnbKtQyWPsLpVtgfIF4wpK/uY3lvV9CeqvKKs
 Qm4oX1UuNKwGsbS2+UyX7XTSMGw0C4if2NJXeWFp6J6qhUmeOqCqYiLW7HZqQaxZMD
 hzXx6rD62P4ySuu6A/z3yiTrdX+ILDtXlWY79HqfY9F2ol/tEHUqEwFXymm5jxxXK1
 3GFKD42/JceAA8vvRrC9wsMlC3bDu13YowtjQ3uvy57H47TSehrxh17TUspc5foTb2
 U853PsOiPLu5g==
Received: by mail-ot1-f43.google.com with SMTP id
 f75-20020a9d03d10000b0290280def9ab76so19695268otf.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 00:00:13 -0700 (PDT)
X-Gm-Message-State: AOAM533+nTdakbIxivhWbTSs2qICWeOlMnFq1tetJPKvg6Vm1yS8TWg8
 T1OUKJoUVIXybi5DUKS0w9wXa8kCyOFpALKisEs=
X-Google-Smtp-Source: ABdhPJxU0Rx7jp0gaYTPEDkowYZKavU9wU/cyN0P5bupNnkZT/v5SN2zcx17yX3HlQYWKlMd1elbP469y2PbHzA/c0M=
X-Received: by 2002:a9d:7cd8:: with SMTP id r24mr17652427otn.90.1620802812741; 
 Wed, 12 May 2021 00:00:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210511100550.28178-1-rppt@kernel.org>
In-Reply-To: <20210511100550.28178-1-rppt@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 12 May 2021 09:00:02 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFHLkmgZKEb8BtgGt6GQ93Qd+yv6NtiCvtgX0ex9wSeyw@mail.gmail.com>
Message-ID: <CAMj1kXFHLkmgZKEb8BtgGt6GQ93Qd+yv6NtiCvtgX0ex9wSeyw@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] arm64: drop pfn_valid_within() and simplify
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

On Tue, 11 May 2021 at 12:05, Mike Rapoport <rppt@kernel.org> wrote:
>
> From: Mike Rapoport <rppt@linux.ibm.com>
>
> Hi,
>
> These patches aim to remove CONFIG_HOLES_IN_ZONE and essentially hardwire
> pfn_valid_within() to 1.
>
> The idea is to mark NOMAP pages as reserved in the memory map and restore
> the intended semantics of pfn_valid() to designate availability of struct
> page for a pfn.
>
> With this the core mm will be able to cope with the fact that it cannot use
> NOMAP pages and the holes created by NOMAP ranges within MAX_ORDER blocks
> will be treated correctly even without the need for pfn_valid_within.
>
> The patches are boot tested on qemu-system-aarch64.
>

Did you use EFI boot when testing this? The memory map is much more
fragmented in that case, so this would be a good data point.


> I beleive it would be best to route these via mmotm tree.
>
> v4:
> * rebase on v5.13-rc1
>
> v3: Link: https://lore.kernel.org/lkml/20210422061902.21614-1-rppt@kernel.org
> * Fix minor issues found by Anshuman
> * Freshen up the declaration of pfn_valid() to make it consistent with
>   pfn_is_map_memory()
> * Add more Acked-by and Reviewed-by tags, thanks Anshuman and David
>
> v2: Link: https://lore.kernel.org/lkml/20210421065108.1987-1-rppt@kernel.org
> * Add check for PFN overflow in pfn_is_map_memory()
> * Add Acked-by and Reviewed-by tags, thanks David.
>
> v1: Link: https://lore.kernel.org/lkml/20210420090925.7457-1-rppt@kernel.org
> * Add comment about the semantics of pfn_valid() as Anshuman suggested
> * Extend comments about MEMBLOCK_NOMAP, per Anshuman
> * Use pfn_is_map_memory() name for the exported wrapper for
>   memblock_is_map_memory(). It is still local to arch/arm64 in the end
>   because of header dependency issues.
>
> rfc: Link: https://lore.kernel.org/lkml/20210407172607.8812-1-rppt@kernel.org
>
> Mike Rapoport (4):
>   include/linux/mmzone.h: add documentation for pfn_valid()
>   memblock: update initialization of reserved pages
>   arm64: decouple check whether pfn is in linear map from pfn_valid()
>   arm64: drop pfn_valid_within() and simplify pfn_valid()
>
>  arch/arm64/Kconfig              |  3 ---
>  arch/arm64/include/asm/memory.h |  2 +-
>  arch/arm64/include/asm/page.h   |  3 ++-
>  arch/arm64/kvm/mmu.c            |  2 +-
>  arch/arm64/mm/init.c            | 14 +++++++++++++-
>  arch/arm64/mm/ioremap.c         |  4 ++--
>  arch/arm64/mm/mmu.c             |  2 +-
>  include/linux/memblock.h        |  4 +++-
>  include/linux/mmzone.h          | 11 +++++++++++
>  mm/memblock.c                   | 28 ++++++++++++++++++++++++++--
>  10 files changed, 60 insertions(+), 13 deletions(-)
>
>
> base-commit: 6efb943b8616ec53a5e444193dccf1af9ad627b5
> --
> 2.28.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
