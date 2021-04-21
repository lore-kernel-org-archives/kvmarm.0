Return-Path: <SRS0=bsip=JS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DABC43460
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 07:49:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B2F261436
	for <kvmarm@archiver.kernel.org>; Wed, 21 Apr 2021 07:49:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B2F261436
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C72F4B4A1;
	Wed, 21 Apr 2021 03:49:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B9Ik8X3XRBgp; Wed, 21 Apr 2021 03:49:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AEC14B4B4;
	Wed, 21 Apr 2021 03:49:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 601E14B4AD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 03:49:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0yNphpx2Muq8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Apr 2021 03:49:07 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3B564B4A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 03:49:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1618991346;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=yo0aeP/gZ7xIL1Br7EZck8Ru/9tRz4VORS9chdtNmnw=;
 b=KQrDT+q35jKv8xnO82y8isMWTMGp2ydKtga/3QuAG/4DI+OxLqFHgf8vPGMklBWltkF3OF
 jzSRHeVTbuLM20aCaVMp14iAUF2A9XFnO+qD0sbuT5BeB0jl7qtmItBKhdwyTtVaOYFCOs
 RVdr1Wr0Pfvng5nAJbyxeqLuhQUH0Xw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-wRM_POvXMK-lvXFLC8pZIA-1; Wed, 21 Apr 2021 03:49:04 -0400
X-MC-Unique: wRM_POvXMK-lvXFLC8pZIA-1
Received: by mail-ej1-f69.google.com with SMTP id
 ji8-20020a1709079808b029037c921a9ea0so5586803ejc.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Apr 2021 00:49:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:organization
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=yo0aeP/gZ7xIL1Br7EZck8Ru/9tRz4VORS9chdtNmnw=;
 b=TuA0OyVTf/mzdfZahNopZNqHSM5an4kRdCrn3v67mYEj7ANzVrLSI/8R6wvkcNIJrh
 dmTkti2mCSkFKdsRGyjhjqsrpf33zTTe0PZVFUA477oG8/DVKQl3Z3bCX9llgUE8rtUO
 CS3kGlglcjOGTkVUTmO4DV4s4hfjgRgTlCxcX76sDb6fXzcx/sjDASrjumzocmXSYDsl
 XhjB5XOkcjPwG/XO2at82WwByfJJ88rsliXHmnO5XrVXLi9t6H/2Gbfrx5oVfXruapfa
 R9neKZKggfQx57IddXW+v1LxeJ0btQkIXsw1c0vhArESgPFVQF2TAgsNqmjD73AgJlyM
 CqrA==
X-Gm-Message-State: AOAM532qGYVPe3cwdrIuCgoMh2J2UlEYxK73+qmYW7xk5U+hYLYGgt5i
 2o/wEHoT2nu1e+JaxtT0xV4BLlOPp7XOqbu0WRueql8DkBx3tW51dFrW/M09+wa6yFEQp33UGiR
 SVEFY8zanZu/dQOjhlomfKtoN
X-Received: by 2002:a17:906:a0c2:: with SMTP id
 bh2mr30655406ejb.394.1618991343752; 
 Wed, 21 Apr 2021 00:49:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCI5v3IslAnTd1D5vuwywZ+19uA0jnaa9i2DYeKnzLSV7LTGXv7KAxF6ZWHxxr+Z98bKaYGg==
X-Received: by 2002:a17:906:a0c2:: with SMTP id
 bh2mr30655371ejb.394.1618991343356; 
 Wed, 21 Apr 2021 00:49:03 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c64b8.dip0.t-ipconnect.de. [91.12.100.184])
 by smtp.gmail.com with ESMTPSA id ju23sm1495102ejc.17.2021.04.21.00.49.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 21 Apr 2021 00:49:03 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] arm64: drop pfn_valid_within() and simplify
 pfn_valid()
To: Mike Rapoport <rppt@kernel.org>, linux-arm-kernel@lists.infradead.org
References: <20210421065108.1987-1-rppt@kernel.org>
 <20210421065108.1987-5-rppt@kernel.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <24edab0c-226c-7ff6-2151-7a8b218c7c44@redhat.com>
Date: Wed, 21 Apr 2021 09:49:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210421065108.1987-5-rppt@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 21.04.21 08:51, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> The arm64's version of pfn_valid() differs from the generic because of two
> reasons:
> 
> * Parts of the memory map are freed during boot. This makes it necessary to
>    verify that there is actual physical memory that corresponds to a pfn
>    which is done by querying memblock.
> 
> * There are NOMAP memory regions. These regions are not mapped in the
>    linear map and until the previous commit the struct pages representing
>    these areas had default values.
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
> ---
>   arch/arm64/Kconfig   | 3 ---
>   arch/arm64/mm/init.c | 4 ++--
>   2 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index e4e1b6550115..58e439046d05 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1040,9 +1040,6 @@ config NEED_PER_CPU_EMBED_FIRST_CHUNK
>   	def_bool y
>   	depends on NUMA
>   
> -config HOLES_IN_ZONE
> -	def_bool y
> -
>   source "kernel/Kconfig.hz"
>   
>   config ARCH_SPARSEMEM_ENABLE
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index dc03bdc12c0f..eb3f56fb8c7c 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -243,7 +243,7 @@ int pfn_valid(unsigned long pfn)
>   
>   	/*
>   	 * ZONE_DEVICE memory does not have the memblock entries.
> -	 * memblock_is_map_memory() check for ZONE_DEVICE based
> +	 * memblock_is_memory() check for ZONE_DEVICE based
>   	 * addresses will always fail. Even the normal hotplugged
>   	 * memory will never have MEMBLOCK_NOMAP flag set in their
>   	 * memblock entries. Skip memblock search for all non early
> @@ -254,7 +254,7 @@ int pfn_valid(unsigned long pfn)
>   		return pfn_section_valid(ms, pfn);
>   }
>   #endif
> -	return memblock_is_map_memory(addr);
> +	return memblock_is_memory(addr);
>   }
>   EXPORT_SYMBOL(pfn_valid);
>   
> 

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
