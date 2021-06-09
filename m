Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3576C48BCF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 15:14:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 52B606139A
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 15:14:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52B606139A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0D5A49E93;
	Wed,  9 Jun 2021 11:14:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TQiQ5cFl+EKn; Wed,  9 Jun 2021 11:14:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1624409DD;
	Wed,  9 Jun 2021 11:14:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B02A4083E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 11:14:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TtRTJMmzRHXT for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 11:14:03 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8003B40821
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 11:14:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623251642;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=c/K7Lb66sqKExnO65jP5KpqY/atLTY2xOiqgK1khPHE=;
 b=PDyy/U+/q+MsETkQOuZCF+CjhHzQ5z4AfjYVeLQu9iZmH7hm7ftdtSaqVqt7qmTvNfnsGo
 FynswIZem4HMAuJcD8T1LR653MiLnvIj4P5UIzknz1Ea6JbWWv3Lp12ay7TbZX0SKS32gL
 7HvQpo/js54eSKKZTioWVEv8qyMLv7g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-AIS5kmEbMCmpZyNZmT_tvg-1; Wed, 09 Jun 2021 11:14:01 -0400
X-MC-Unique: AIS5kmEbMCmpZyNZmT_tvg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4C51107ACF6;
 Wed,  9 Jun 2021 15:14:00 +0000 (UTC)
Received: from [10.36.112.148] (ovpn-112-148.ams2.redhat.com [10.36.112.148])
 by smtp.corp.redhat.com (Postfix) with ESMTP id C2D3863B8C;
 Wed,  9 Jun 2021 15:13:54 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 2/7] lib: unify header guards
To: Cornelia Huck <cohuck@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Andrew Jones <drjones@redhat.com>
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-3-cohuck@redhat.com>
From: Laurent Vivier <lvivier@redhat.com>
Message-ID: <f20b32d0-9272-66d5-e106-a0af4340b95a@redhat.com>
Date: Wed, 9 Jun 2021 17:13:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-3-cohuck@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 09/06/2021 16:37, Cornelia Huck wrote:
> Standardize header guards to _LIB_HEADER_H_.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  lib/alloc_page.h       | 4 ++--
>  lib/libcflat.h         | 4 ++--
>  lib/list.h             | 4 ++--
>  lib/pci-edu.h          | 4 ++--
>  lib/pci-host-generic.h | 4 ++--
>  lib/setjmp.h           | 4 ++--
>  lib/string.h           | 6 +++---
>  lib/vmalloc.h          | 4 ++--
>  8 files changed, 17 insertions(+), 17 deletions(-)

What about lib/argv.h and lib/pci.h?

And there is also this instance of CONFIG_H in lib/config.h generated by configure.

Thanks,
Laurent


> 
> diff --git a/lib/alloc_page.h b/lib/alloc_page.h
> index 1af1419d49b6..eed2ba06eeaf 100644
> --- a/lib/alloc_page.h
> +++ b/lib/alloc_page.h
> @@ -5,8 +5,8 @@
>   * with byte granularity.
>   */
>  
> -#ifndef ALLOC_PAGE_H
> -#define ALLOC_PAGE_H 1
> +#ifndef _ALLOC_PAGE_H_
> +#define _ALLOC_PAGE_H_
>  
>  #include <stdbool.h>
>  #include <asm/memory_areas.h>
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index 460a1234ea6a..f40b431d1550 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -17,8 +17,8 @@
>   * Authors: Hollis Blanchard <hollisb@us.ibm.com>
>   */
>  
> -#ifndef __LIBCFLAT_H
> -#define __LIBCFLAT_H
> +#ifndef _LIBCFLAT_H_
> +#define _LIBCFLAT_H_
>  
>  #ifndef __ASSEMBLY__
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
>  #include <stdbool.h>
>  
> diff --git a/lib/pci-edu.h b/lib/pci-edu.h
> index 44b4ba168768..9db94aec0bc7 100644
> --- a/lib/pci-edu.h
> +++ b/lib/pci-edu.h
> @@ -12,8 +12,8 @@
>   * Edu device is a virtualized device in QEMU. Please refer to
>   * docs/specs/edu.txt in QEMU repository for EDU device manual.
>   */
> -#ifndef __PCI_EDU_H__
> -#define __PCI_EDU_H__
> +#ifndef _PCI_EDU_H_
> +#define _PCI_EDU_H_
>  
>  #include "pci.h"
>  #include "asm/io.h"
> diff --git a/lib/pci-host-generic.h b/lib/pci-host-generic.h
> index 0ffe6380ec8f..3020ee22c837 100644
> --- a/lib/pci-host-generic.h
> +++ b/lib/pci-host-generic.h
> @@ -1,5 +1,5 @@
> -#ifndef PCI_HOST_GENERIC_H
> -#define PCI_HOST_GENERIC_H
> +#ifndef _PCI_HOST_GENERIC_H_
> +#define _PCI_HOST_GENERIC_H_
>  /*
>   * PCI host bridge supporting structures and constants
>   *
> diff --git a/lib/setjmp.h b/lib/setjmp.h
> index 2c56b4c68aaa..6afdf665681a 100644
> --- a/lib/setjmp.h
> +++ b/lib/setjmp.h
> @@ -4,8 +4,8 @@
>   * This code is free software; you can redistribute it and/or modify it
>   * under the terms of the GNU Library General Public License version 2.
>   */
> -#ifndef LIBCFLAT_SETJMP_H
> -#define LIBCFLAT_SETJMP_H 1
> +#ifndef _LIBCFLAT_SETJMP_H_
> +#define _LIBCFLAT_SETJMP_H_
>  
>  typedef struct jmp_buf_tag {
>  	long int regs[8];
> diff --git a/lib/string.h b/lib/string.h
> index e1febfed7fb2..b07763eaef10 100644
> --- a/lib/string.h
> +++ b/lib/string.h
> @@ -4,8 +4,8 @@
>   * This code is free software; you can redistribute it and/or modify it
>   * under the terms of the GNU Library General Public License version 2.
>   */
> -#ifndef __STRING_H
> -#define __STRING_H
> +#ifndef _STRING_H_
> +#define _STRING_H_
>  
>  extern size_t strlen(const char *buf);
>  extern size_t strnlen(const char *buf, size_t maxlen);
> @@ -23,4 +23,4 @@ extern int memcmp(const void *s1, const void *s2, size_t n);
>  extern void *memmove(void *dest, const void *src, size_t n);
>  extern void *memchr(const void *s, int c, size_t n);
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
>  #include <asm/page.h>
>  
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
