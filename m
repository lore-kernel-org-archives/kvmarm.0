Return-Path: <SRS0=u/VZ=KG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30495C433ED
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 10:23:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7A56D61925
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 10:23:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A56D61925
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E48CC4B4BA;
	Tue, 11 May 2021 06:23:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6VT1g-+ztApf; Tue, 11 May 2021 06:22:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5470B4B4B4;
	Tue, 11 May 2021 06:22:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E83374B499
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 06:22:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jgu2UWVI5-RS for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 May 2021 06:22:56 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BB134B495
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 06:22:56 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DB9C61932
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 10:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1620728575;
 bh=8K5/RKVsB4hbF+2S3xYY+Sls7rLDAQAlNlhNK+wAOxM=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=kfmrEf4UUPFdXmN4bONIkgTnNm+NvLIuA5PwA2CwaYTxb1dDjpb/EJj7jzf3G1lQD
 nIb8iuIIEgctX84nf+w+HM4ez8mJ8I2el3imHgPUbBrVOHBIYCSrUucrRCUYBIl5sR
 oj7JeBjGYixV3xnxSGHcew4MdO2AoktCyJG9i3pn4u1nluL9dFAELEUbHsASk0gW3n
 NYTY2RE4iLWxmPJ9fLRQxFO5luOuFnQa0bVAyXfp9XdxBSCMB/iragnXUtE0mnpeGU
 RnKVF8Y9kKxgCuDKNkB/rFZ2rYHoOR7Bniz1tPOY9GSnS5n+Of6gvZc4a0k4tcauPY
 lK2AvxnMfA6Sg==
Received: by mail-oi1-f174.google.com with SMTP id l6so18607069oii.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 03:22:55 -0700 (PDT)
X-Gm-Message-State: AOAM531fzw9TmiiTC8MnsK9jiqexOhbyivS+63roDdGZrj1L7cwOCx50
 3TzjnOrYk6Kgxa5wfOZInFdi5nrZne4XkdQ9qY4=
X-Google-Smtp-Source: ABdhPJz3X7/zsLxW0acYDilZnZffpfuhhEzj9r12Onr6R0a3ZrPbcEC3CSWgseEdH8CiwuI/0vKICdQkV3hdFyMavwI=
X-Received: by 2002:aca:4056:: with SMTP id n83mr2975600oia.47.1620728574417; 
 Tue, 11 May 2021 03:22:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210511100550.28178-1-rppt@kernel.org>
 <20210511100550.28178-2-rppt@kernel.org>
In-Reply-To: <20210511100550.28178-2-rppt@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 11 May 2021 12:22:43 +0200
X-Gmail-Original-Message-ID: <CAMj1kXER_hsior1uoy3=7Sca4nD_n1s8PRoN4JMbOjzgL6g+Hg@mail.gmail.com>
Message-ID: <CAMj1kXER_hsior1uoy3=7Sca4nD_n1s8PRoN4JMbOjzgL6g+Hg@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] include/linux/mmzone.h: add documentation for
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
> Add comment describing the semantics of pfn_valid() that clarifies that
> pfn_valid() only checks for availability of a memory map entry (i.e. struct
> page) for a PFN rather than availability of usable memory backing that PFN.
>
> The most "generic" version of pfn_valid() used by the configurations with
> SPARSEMEM enabled resides in include/linux/mmzone.h so this is the most
> suitable place for documentation about semantics of pfn_valid().
>
> Suggested-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  include/linux/mmzone.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 0d53eba1c383..e5945ca24df7 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1427,6 +1427,17 @@ static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
>  #endif
>
>  #ifndef CONFIG_HAVE_ARCH_PFN_VALID
> +/**
> + * pfn_valid - check if there is a valid memory map entry for a PFN
> + * @pfn: the page frame number to check
> + *
> + * Check if there is a valid memory map entry aka struct page for the @pfn.
> + * Note, that availability of the memory map entry does not imply that
> + * there is actual usable memory at that @pfn. The struct page may
> + * represent a hole or an unusable page frame.
> + *
> + * Return: 1 for PFNs that have memory map entries and 0 otherwise
> + */
>  static inline int pfn_valid(unsigned long pfn)
>  {
>         struct mem_section *ms;
> --
> 2.28.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
