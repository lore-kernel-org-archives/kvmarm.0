Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96448C48BCF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 15:25:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0517E61042
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 15:25:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0517E61042
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8295D40874;
	Wed,  9 Jun 2021 11:25:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3dX+DU82B3Ge; Wed,  9 Jun 2021 11:25:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C5E74079A;
	Wed,  9 Jun 2021 11:25:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B317940667
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 11:25:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J3iGqr0e6b9Y for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 11:25:05 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D484B402DB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 11:25:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623252305;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=45evuK65yCNrp+U7R4sBiNRjQAaI/1aj6wt5ojrV/8Q=;
 b=O6bhudeAK153p7Ql01Lgci8o6yrnXEkdxcLYcpDRPxXJRxCv9XQ1v8ObZMbcBHjDAMdDZw
 SQUrHUIckSRw1/MC36uIJEfkrTH5UfTr60QgV5hKuvLGO3KW4QUpEeD8tWKA9bxsM3NUG2
 asQXzNpvcoRsFDFp6d8f5IiklaLrVzY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-Ng2t_B11PT2rvKAo_NxKDQ-1; Wed, 09 Jun 2021 11:25:00 -0400
X-MC-Unique: Ng2t_B11PT2rvKAo_NxKDQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E8EE8015A4;
 Wed,  9 Jun 2021 15:24:59 +0000 (UTC)
Received: from [10.36.112.148] (ovpn-112-148.ams2.redhat.com [10.36.112.148])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 3CE0F1656A;
 Wed,  9 Jun 2021 15:24:53 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 4/7] arm: unify header guards
To: Cornelia Huck <cohuck@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Andrew Jones <drjones@redhat.com>
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-5-cohuck@redhat.com>
From: Laurent Vivier <lvivier@redhat.com>
Message-ID: <8399161a-ef26-7d4f-19fb-c54ca40fe6c3@redhat.com>
Date: Wed, 9 Jun 2021 17:24:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-5-cohuck@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
> The assembler.h files were the only ones not already following
> the convention.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  lib/arm/asm/assembler.h   | 6 +++---
>  lib/arm64/asm/assembler.h | 6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)

What about lib/arm/io.h?

I think you can remove the guard from

lib/arm/asm/memory_areas.h

as the other files including directly a header doesn't guard it.

Missing lib/arm/asm/mmu-api.h, lib/arm/asm/mmu.h, lib/arm64/asm/mmu.h

Thanks,
Laurent

> 
> diff --git a/lib/arm/asm/assembler.h b/lib/arm/asm/assembler.h
> index dfd3c51bf6ad..4200252dd14d 100644
> --- a/lib/arm/asm/assembler.h
> +++ b/lib/arm/asm/assembler.h
> @@ -8,8 +8,8 @@
>  #error "Only include this from assembly code"
>  #endif
>  
> -#ifndef __ASM_ASSEMBLER_H
> -#define __ASM_ASSEMBLER_H
> +#ifndef _ASMARM_ASSEMBLER_H_
> +#define _ASMARM_ASSEMBLER_H_
>  
>  /*
>   * dcache_line_size - get the minimum D-cache line size from the CTR register
> @@ -50,4 +50,4 @@
>  	dsb	\domain
>  	.endm
>  
> -#endif	/* __ASM_ASSEMBLER_H */
> +#endif	/* _ASMARM_ASSEMBLER_H_ */
> diff --git a/lib/arm64/asm/assembler.h b/lib/arm64/asm/assembler.h
> index 0a6ab9720bdd..a271e4ceefe6 100644
> --- a/lib/arm64/asm/assembler.h
> +++ b/lib/arm64/asm/assembler.h
> @@ -12,8 +12,8 @@
>  #error "Only include this from assembly code"
>  #endif
>  
> -#ifndef __ASM_ASSEMBLER_H
> -#define __ASM_ASSEMBLER_H
> +#ifndef _ASMARM64_ASSEMBLER_H_
> +#define _ASMARM64_ASSEMBLER_H_
>  
>  /*
>   * raw_dcache_line_size - get the minimum D-cache line size on this CPU
> @@ -51,4 +51,4 @@
>  	dsb	\domain
>  	.endm
>  
> -#endif	/* __ASM_ASSEMBLER_H */
> +#endif	/* _ASMARM64_ASSEMBLER_H_ */
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
