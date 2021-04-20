Return-Path: <SRS0=sayA=JR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4EB2C43460
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 16:01:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E6E98613C4
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 16:01:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6E98613C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A5EE4B39C;
	Tue, 20 Apr 2021 12:01:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yzjqRVnbpuW6; Tue, 20 Apr 2021 12:01:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB8D24B3BF;
	Tue, 20 Apr 2021 12:01:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BF5B4B3A2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 12:01:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BsTJJHPfDr0z for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Apr 2021 12:01:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 202874B39C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 12:01:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1618934462;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=1VLwDHA1T1kECXFVXDoESN93Xu3CIGiC8uj+j3Bh2ag=;
 b=OVJt8vxLRxX1RPh2uCKKaBjF/u8knBUuGmri9JdijQj8jHZM6tvLm/gt57XZI2Nud4OWUW
 G8D+/NCn/T8frXvVC2k5qNB11iPw5rUT/ucb6JRJvjdh4GpI2jNe2Pat4Y6JkTjR2vqDEv
 pglPVvKfuanWK1QpUxYPt9qTcLypdkU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-1RmknzwwPy25pL0HWbaYgA-1; Tue, 20 Apr 2021 12:00:57 -0400
X-MC-Unique: 1RmknzwwPy25pL0HWbaYgA-1
Received: by mail-wm1-f70.google.com with SMTP id
 y82-20020a1ce1550000b02901262158f1e9so5844797wmg.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 09:00:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:organization
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=1VLwDHA1T1kECXFVXDoESN93Xu3CIGiC8uj+j3Bh2ag=;
 b=nl4ybj6ASsbB1g9+GhBt2ObBZ6O7nFxffRTSYGaxxfKDY9iVwl2vvFAge52dBeNSlQ
 vbzMiJS2QUf28a6byiLVdrOS3Lkgh4j5P6AlKGIy+VwYXf+Ja32mqDzXvQBVZ4XrFijF
 jRvaWXh5d42/if3nneAQB6AwF1219BPmwPb1YHm/mmIHPhfcmR2/8SLHt7P/LZ98vD0y
 uTQ0NScdnVP3jGqE92B0C/GS5Do8SsNN7RLBEmdKURDOkA19i1k9qoKa7H04r15CtVEN
 wM2JHJV5ALuZsbK9jYsYaCKofhiLYb+wQlNW5wSEL01JWo7IMdHo74D5caH/RNe8o1XL
 UkTQ==
X-Gm-Message-State: AOAM532QfcDeT6PAxMz0lgqn6ncLZk6Ak9PMOaY+FhtdWbOTzz5tcRlU
 HcqFJ4JhHuVL6ibG4et5f+9jSo3dY/be9SuSp56NmapxOwVIKnztD2hMH/4SiaCcMTPtXvISADv
 m8XR2Tr/Er2ChMA70Bjhnv8gA
X-Received: by 2002:adf:d0cc:: with SMTP id z12mr21739747wrh.18.1618934456651; 
 Tue, 20 Apr 2021 09:00:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxr5kh0sjqy8wW7F/IAJRwsgXm3O7rTTKuYEi9XNs0Np8ms/WxZijQLIJublkxDKy/HuPS98A==
X-Received: by 2002:adf:d0cc:: with SMTP id z12mr21739705wrh.18.1618934456321; 
 Tue, 20 Apr 2021 09:00:56 -0700 (PDT)
Received: from [192.168.3.132] (p4ff2390a.dip0.t-ipconnect.de. [79.242.57.10])
 by smtp.gmail.com with ESMTPSA id
 o4sm9592968wrn.81.2021.04.20.09.00.55
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 20 Apr 2021 09:00:56 -0700 (PDT)
Subject: Re: [PATCH v1 4/4] arm64: drop pfn_valid_within() and simplify
 pfn_valid()
To: Mike Rapoport <rppt@kernel.org>, linux-arm-kernel@lists.infradead.org
References: <20210420090925.7457-1-rppt@kernel.org>
 <20210420090925.7457-5-rppt@kernel.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <8e7171e7-a85c-6066-4ab6-d2bc98ec103b@redhat.com>
Date: Tue, 20 Apr 2021 18:00:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210420090925.7457-5-rppt@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
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

On 20.04.21 11:09, Mike Rapoport wrote:
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
> index c54e329aca15..370f33765b64 100644
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

What are the steps needed to get rid of custom pfn_valid() completely?

I'd assume we would have to stop freeing parts of the mem map during 
boot. How relevant is that for arm64 nowadays, especially with reduced 
section sizes?

-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
