Return-Path: <SRS0=sayA=JR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2606C433ED
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 09:23:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3EBBF613AB
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 09:23:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EBBF613AB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E82B4B0C3;
	Tue, 20 Apr 2021 05:23:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kSofgj1xi8g9; Tue, 20 Apr 2021 05:23:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D03064B35B;
	Tue, 20 Apr 2021 05:23:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6580D4B0C3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 05:23:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qnBs0M2WRcgn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Apr 2021 05:23:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63E344B0BB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 05:23:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1618910582;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ix5YDMmXJ3C1/BneKisaiFbJVja4N1CpmLxhrOr+FWA=;
 b=T1xvWNeIyPYaVf+bM3mQQVaoA6vxGazYBlLgonCy4muMVFcRrWzpfN8StGG3MScwQIVM/V
 QApTTDlHR1L0OWW3miL0omBknCOXRpuBTPjuOaQlOFYiAlfGTcDf37dJ1tw2A1amfLZUKQ
 P1qfmiK/AZ1pQRvHvPCOE8kZTM9ZYI4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-T3TGDtlRPD22U9m-IoJDjQ-1; Tue, 20 Apr 2021 05:22:55 -0400
X-MC-Unique: T3TGDtlRPD22U9m-IoJDjQ-1
Received: by mail-wm1-f72.google.com with SMTP id
 g199-20020a1c9dd00000b02901355dd71edaso1150379wme.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 02:22:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:organization
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=ix5YDMmXJ3C1/BneKisaiFbJVja4N1CpmLxhrOr+FWA=;
 b=UTm/PkhhBJxhfZf1GbtPQPBf72TZ6RMKMUlmvLgFgymwemc3wuT8d1OBf6I3abqCjD
 4OE1R8xy/kE8DdQo4mM0lnBgVn9q5wriNMMYpwd7ZJ4NNs24lAWFLYqTrGetoF01yo13
 yO7/WGsZYmwIJZwM9f7+vQ3wHY+3ppyyMn0NEz6oxA5kyJkCYLpeo6Rl+cxCt1o/Sh9P
 yGPXICMMcbzET2ZXXn2Wc9Wv9j19sCyKj3GLjo/MQ/JCDTeaq7rs62UmK5gq4L1+Ot7C
 nVxoh7/WV8pP99t4/T9BI6mB+DdvnktSIcRuYhsf2mnCsgVIJgs+NFwG6LzMh58bdhNc
 PzLw==
X-Gm-Message-State: AOAM533RwmODMYy3BybVLguUbY8YpUg7n8mZ1A0lUGlnlu02c0U5VBWi
 lb0FE/0fFhJsGm8gWhK5FV1qSnQFnpUOmaSR5QL0rbp+ksqASq3n3JSfVTlQwbAAhL3AEt9DhUj
 voeWv0Mb6OnSCUujG2pCFM0PF
X-Received: by 2002:a1c:c911:: with SMTP id f17mr3456345wmb.45.1618910574453; 
 Tue, 20 Apr 2021 02:22:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyds3aZGiGfNhY717LR9Fd18v+z+0WjKZswcFhDMLESmpRmh8l/f3c9okYjlf6HDlj+DWj7Ug==
X-Received: by 2002:a1c:c911:: with SMTP id f17mr3456313wmb.45.1618910574180; 
 Tue, 20 Apr 2021 02:22:54 -0700 (PDT)
Received: from [192.168.3.132] (p4ff2390a.dip0.t-ipconnect.de. [79.242.57.10])
 by smtp.gmail.com with ESMTPSA id
 g13sm30774192wrr.9.2021.04.20.02.22.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 20 Apr 2021 02:22:53 -0700 (PDT)
Subject: Re: [PATCH v1 1/4] include/linux/mmzone.h: add documentation for
 pfn_valid()
To: Mike Rapoport <rppt@kernel.org>, linux-arm-kernel@lists.infradead.org
References: <20210420090925.7457-1-rppt@kernel.org>
 <20210420090925.7457-2-rppt@kernel.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <f900f889-f059-7d48-dfc7-145c8cd54cf6@redhat.com>
Date: Tue, 20 Apr 2021 11:22:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210420090925.7457-2-rppt@kernel.org>
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
> ---
>   include/linux/mmzone.h | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 47946cec7584..961f0eeefb62 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1410,6 +1410,17 @@ static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
>   #endif
>   
>   #ifndef CONFIG_HAVE_ARCH_PFN_VALID
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
>   static inline int pfn_valid(unsigned long pfn)
>   {
>   	struct mem_section *ms;
> 

I'd rephrase all "there is a valid memory map" to "there is a memory 
map" and add "pfn_valid() does to indicate whether the memory map as 
actually initialized -- see pfn_to_online_page()."

pfn_valid() means that we can do a pfn_to_page() and don't get a fault 
when accessing the "struct page". It doesn't state anything about the 
content.

-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
