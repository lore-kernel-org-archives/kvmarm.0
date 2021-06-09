Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4750CC48BCF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 14:46:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C6F6B6139A
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 14:46:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6F6B6139A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60872405A6;
	Wed,  9 Jun 2021 10:46:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 94uZIGlY2-ky; Wed,  9 Jun 2021 10:46:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7B9D40667;
	Wed,  9 Jun 2021 10:46:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAF32405A6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 10:46:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vYWAbrHOD8i3 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 10:46:04 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E13B340463
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 10:46:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623249964;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=AAU1zAInzx6+HrQSFp6ko34nkWsZXJD3O7CzG1wYgc4=;
 b=EStFQt0dqAL77LwDujsa1R/akqqsiPaTRf4PS0icFDOvgCcu4xAcFcLTeQcqvjGozJbg7G
 pxTFUAdi8TqWauFvkXO/d0Vj3DzkKbkynZviVw+tBGa6x5DxDcDwXuL7Nr9ei4XeDS3wFq
 mr9VfYLxg61lEqa7e8uARev+Vxw8yuw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-QvlbXqIsM2Gm98Sguhc9Uw-1; Wed, 09 Jun 2021 10:46:01 -0400
X-MC-Unique: QvlbXqIsM2Gm98Sguhc9Uw-1
Received: by mail-wm1-f69.google.com with SMTP id
 m23-20020a05600c3b17b02901b3e8a9db8eso821228wms.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Jun 2021 07:46:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:organization
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=AAU1zAInzx6+HrQSFp6ko34nkWsZXJD3O7CzG1wYgc4=;
 b=f7EeKJ9pu8+toI0JLNytkKhmOG1AfA18/WiJtpl609B7fxpocUaH0Qgr6nUAEApUB3
 xX7hw/W62IKmt2q5i3LEsG0xB8+oRWidZ/QJZM4Lvtw7GVIiyMs9zlGYq6X+s6W/gQDq
 sQ2kN+MQPzogIIkgc1FGPI+80e3Ha8RnvSu2J/Olak2R/W/KQq+Bu/vvB10wiAsg8Pyh
 5cLfpga2hWjx+013wDrypjrwzvpIsPUY50mRyyPOdgdM5m5erYMJETuYy1/wv9969Hqh
 ZLRIMZ8IDWNb7Ee0ex6nQH7YWOFONH6bMvQ5B/JV2Hm0jdJswsfcSFtvKRW6F+NirhTJ
 6cmQ==
X-Gm-Message-State: AOAM533r1c5RgbS9prmQRG9pMb6UJSeFkkZYZn603Y7CRO+LcQTFvnOU
 zQdPmsWPf5Je5CYc3dTjJnR16bhCQzcES3ERNvpXeVfnqlqIWzMO0jjT5QN8Mu0qnFzkriqFR5x
 32ZXj7MCgO4neuEUkq7dAIh+R
X-Received: by 2002:adf:e907:: with SMTP id f7mr212963wrm.112.1623249960306;
 Wed, 09 Jun 2021 07:46:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8wWl9iBsdp8NJzL7GA3JhN3F5793eKjJk9isccJu44zxan/zDVm9zk47iipTv1xUXcvDIKg==
X-Received: by 2002:adf:e907:: with SMTP id f7mr212915wrm.112.1623249959932;
 Wed, 09 Jun 2021 07:45:59 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c611d.dip0.t-ipconnect.de. [91.12.97.29])
 by smtp.gmail.com with ESMTPSA id
 u15sm6321326wmq.48.2021.06.09.07.45.59
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Jun 2021 07:45:59 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 2/7] lib: unify header guards
To: Cornelia Huck <cohuck@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Andrew Jones <drjones@redhat.com>
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-3-cohuck@redhat.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <42e29a14-3870-5289-9067-5c9c1284e7dd@redhat.com>
Date: Wed, 9 Jun 2021 16:45:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-3-cohuck@redhat.com>
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
> Standardize header guards to _LIB_HEADER_H_.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   lib/alloc_page.h       | 4 ++--
>   lib/libcflat.h         | 4 ++--
>   lib/list.h             | 4 ++--
>   lib/pci-edu.h          | 4 ++--
>   lib/pci-host-generic.h | 4 ++--
>   lib/setjmp.h           | 4 ++--
>   lib/string.h           | 6 +++---
>   lib/vmalloc.h          | 4 ++--
>   8 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/lib/alloc_page.h b/lib/alloc_page.h
> index 1af1419d49b6..eed2ba06eeaf 100644
> --- a/lib/alloc_page.h
> +++ b/lib/alloc_page.h
> @@ -5,8 +5,8 @@
>    * with byte granularity.
>    */
>   
> -#ifndef ALLOC_PAGE_H
> -#define ALLOC_PAGE_H 1
> +#ifndef _ALLOC_PAGE_H_
> +#define _ALLOC_PAGE_H_
>   
>   #include <stdbool.h>
>   #include <asm/memory_areas.h>
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index 460a1234ea6a..f40b431d1550 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -17,8 +17,8 @@
>    * Authors: Hollis Blanchard <hollisb@us.ibm.com>
>    */
>   
> -#ifndef __LIBCFLAT_H
> -#define __LIBCFLAT_H
> +#ifndef _LIBCFLAT_H_
> +#define _LIBCFLAT_H_
>   
>   #ifndef __ASSEMBLY__
>   
> diff --git a/lib/list.h b/lib/list.h
> index 7f9717ef6258..ed3e52b40075 100644
> --- a/lib/list.h
> +++ b/lib/list.h
> @@ -1,5 +1,5 @@
> -#ifndef LIST_H
> -#define LIST_H
> +#ifndef _LIST_H_
> +#define _LIST_H_
>   
>   #include <stdbool.h>
>   
> diff --git a/lib/pci-edu.h b/lib/pci-edu.h
> index 44b4ba168768..9db94aec0bc7 100644
> --- a/lib/pci-edu.h
> +++ b/lib/pci-edu.h
> @@ -12,8 +12,8 @@
>    * Edu device is a virtualized device in QEMU. Please refer to
>    * docs/specs/edu.txt in QEMU repository for EDU device manual.
>    */
> -#ifndef __PCI_EDU_H__
> -#define __PCI_EDU_H__
> +#ifndef _PCI_EDU_H_
> +#define _PCI_EDU_H_
>   
>   #include "pci.h"
>   #include "asm/io.h"
> diff --git a/lib/pci-host-generic.h b/lib/pci-host-generic.h
> index 0ffe6380ec8f..3020ee22c837 100644
> --- a/lib/pci-host-generic.h
> +++ b/lib/pci-host-generic.h
> @@ -1,5 +1,5 @@
> -#ifndef PCI_HOST_GENERIC_H
> -#define PCI_HOST_GENERIC_H
> +#ifndef _PCI_HOST_GENERIC_H_
> +#define _PCI_HOST_GENERIC_H_
>   /*
>    * PCI host bridge supporting structures and constants
>    *
> diff --git a/lib/setjmp.h b/lib/setjmp.h
> index 2c56b4c68aaa..6afdf665681a 100644
> --- a/lib/setjmp.h
> +++ b/lib/setjmp.h
> @@ -4,8 +4,8 @@
>    * This code is free software; you can redistribute it and/or modify it
>    * under the terms of the GNU Library General Public License version 2.
>    */
> -#ifndef LIBCFLAT_SETJMP_H
> -#define LIBCFLAT_SETJMP_H 1
> +#ifndef _LIBCFLAT_SETJMP_H_
> +#define _LIBCFLAT_SETJMP_H_
>   
>   typedef struct jmp_buf_tag {
>   	long int regs[8];
> diff --git a/lib/string.h b/lib/string.h
> index e1febfed7fb2..b07763eaef10 100644
> --- a/lib/string.h
> +++ b/lib/string.h
> @@ -4,8 +4,8 @@
>    * This code is free software; you can redistribute it and/or modify it
>    * under the terms of the GNU Library General Public License version 2.
>    */
> -#ifndef __STRING_H
> -#define __STRING_H
> +#ifndef _STRING_H_
> +#define _STRING_H_
>   
>   extern size_t strlen(const char *buf);
>   extern size_t strnlen(const char *buf, size_t maxlen);
> @@ -23,4 +23,4 @@ extern int memcmp(const void *s1, const void *s2, size_t n);
>   extern void *memmove(void *dest, const void *src, size_t n);
>   extern void *memchr(const void *s, int c, size_t n);
>   
> -#endif /* _STRING_H */
> +#endif /* _STRING_H_ */
> diff --git a/lib/vmalloc.h b/lib/vmalloc.h
> index 8b158f591d75..346f94f198c5 100644
> --- a/lib/vmalloc.h
> +++ b/lib/vmalloc.h
> @@ -1,5 +1,5 @@
> -#ifndef VMALLOC_H
> -#define VMALLOC_H 1
> +#ifndef _VMALLOC_H_
> +#define _VMALLOC_H_
>   
>   #include <asm/page.h>
>   
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
