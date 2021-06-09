Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E1AC48BCD
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 14:46:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A2B8D613CA
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 14:46:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2B8D613CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4353840291;
	Wed,  9 Jun 2021 10:46:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vHo+M3tLzDB4; Wed,  9 Jun 2021 10:46:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3652F402DB;
	Wed,  9 Jun 2021 10:46:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5573D402DB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 10:46:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hF2soV5mnLv4 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 10:46:54 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74A0440291
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 10:46:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623250014;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=t0hZQMWWxDl7Xi8l29AWO8IasO+rf5yU93tb5RzLQ7g=;
 b=hQp5IV7fTOiU7oEAh9Gq1XUQ0s8bg4UC8Af9hkh4tuVGo7P24gJ+HJhULDqXnt/o0vLxwC
 oI1PRtjIXmD1zyS7yLA7QFtHfFrscEy1JUspv384DNdvDztwqWf1hJ3dKg+cV034yRDBj1
 FNFjrWzIhG+fcMznWVLgOWnRAojzfVQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-daPVkllqNTecaf5ooZH3Xg-1; Wed, 09 Jun 2021 10:46:53 -0400
X-MC-Unique: daPVkllqNTecaf5ooZH3Xg-1
Received: by mail-wm1-f70.google.com with SMTP id
 l18-20020a05600c4f12b02901921c0f2098so1053248wmq.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Jun 2021 07:46:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:organization
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=t0hZQMWWxDl7Xi8l29AWO8IasO+rf5yU93tb5RzLQ7g=;
 b=NwCRlOfpka1YkYu3i2CJubwYTulRqM+sYSKAW4h/c+LWuvAsTYakBxuRUuxnf5DQ/i
 9jAfng1JREveIgW9GFxK5QwrCifc/4oYKmWLwsQxaNQWb6Pmdg93diZRmWlMQWQF76WY
 mGABTGGwBgZQzWJJSfhTay69Cb+Bq6/9WyRf3ICQmX8yGiWEn+NbjTxI/dGvb2ha6FCT
 WZlxqDnm666t9kJoBHN46e7Dq80tKo3YkZxBxYn4ePPcm56XX2dghUMMqJ/SlHzvfWBf
 eGLs5x1TxV67eJnyqtt3zx3d6HrVF0H3m0kx5GLQgIgs5jxhAMEdJAmGbGuZTpstPt3J
 XhvA==
X-Gm-Message-State: AOAM533CE649mesPOhQZ1BiMYvGA/B50xVKwGi1T2UFr0oqd/Nu+id9L
 HcZRPrPiGU+nMkteeurzoqt/19qS7YcaHW2jaT6NIxXx8264TwXK+jsixk6p1VzWqJds1rAKIJx
 gbpUHLivr01SEvIarmxsmzrQF
X-Received: by 2002:a05:600c:19d1:: with SMTP id
 u17mr10383514wmq.31.1623250011984; 
 Wed, 09 Jun 2021 07:46:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzboBk7WBqh0GgSbryL8mzgfVK8EI4S6S8GDygMVs49zQtyl7XBe/7JeBQTIe1GgwDVwlYqzQ==
X-Received: by 2002:a05:600c:19d1:: with SMTP id
 u17mr10383492wmq.31.1623250011775; 
 Wed, 09 Jun 2021 07:46:51 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c611d.dip0.t-ipconnect.de. [91.12.97.29])
 by smtp.gmail.com with ESMTPSA id
 e16sm175080wrw.49.2021.06.09.07.46.51
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Jun 2021 07:46:51 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 4/7] arm: unify header guards
To: Cornelia Huck <cohuck@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Andrew Jones <drjones@redhat.com>
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-5-cohuck@redhat.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <97d532a5-af52-c2f6-0f0f-7334299aef1a@redhat.com>
Date: Wed, 9 Jun 2021 16:46:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-5-cohuck@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Laurent Vivier <lvivier@redhat.com>, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 kvm-ppc@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu
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

On 09.06.21 16:37, Cornelia Huck wrote:
> The assembler.h files were the only ones not already following
> the convention.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   lib/arm/asm/assembler.h   | 6 +++---
>   lib/arm64/asm/assembler.h | 6 +++---
>   2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/arm/asm/assembler.h b/lib/arm/asm/assembler.h
> index dfd3c51bf6ad..4200252dd14d 100644
> --- a/lib/arm/asm/assembler.h
> +++ b/lib/arm/asm/assembler.h
> @@ -8,8 +8,8 @@
>   #error "Only include this from assembly code"
>   #endif
>   
> -#ifndef __ASM_ASSEMBLER_H
> -#define __ASM_ASSEMBLER_H
> +#ifndef _ASMARM_ASSEMBLER_H_
> +#define _ASMARM_ASSEMBLER_H_
>   
>   /*
>    * dcache_line_size - get the minimum D-cache line size from the CTR register
> @@ -50,4 +50,4 @@
>   	dsb	\domain
>   	.endm
>   
> -#endif	/* __ASM_ASSEMBLER_H */
> +#endif	/* _ASMARM_ASSEMBLER_H_ */
> diff --git a/lib/arm64/asm/assembler.h b/lib/arm64/asm/assembler.h
> index 0a6ab9720bdd..a271e4ceefe6 100644
> --- a/lib/arm64/asm/assembler.h
> +++ b/lib/arm64/asm/assembler.h
> @@ -12,8 +12,8 @@
>   #error "Only include this from assembly code"
>   #endif
>   
> -#ifndef __ASM_ASSEMBLER_H
> -#define __ASM_ASSEMBLER_H
> +#ifndef _ASMARM64_ASSEMBLER_H_
> +#define _ASMARM64_ASSEMBLER_H_
>   
>   /*
>    * raw_dcache_line_size - get the minimum D-cache line size on this CPU
> @@ -51,4 +51,4 @@
>   	dsb	\domain
>   	.endm
>   
> -#endif	/* __ASM_ASSEMBLER_H */
> +#endif	/* _ASMARM64_ASSEMBLER_H_ */
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
