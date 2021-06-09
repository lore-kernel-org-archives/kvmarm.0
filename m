Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF9EC48BCD
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 14:48:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9C726613B9
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 14:48:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C726613B9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F43549DE3;
	Wed,  9 Jun 2021 10:48:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sdxiRQuY6qHS; Wed,  9 Jun 2021 10:48:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 913454086A;
	Wed,  9 Jun 2021 10:48:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6532C4075E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 10:48:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hxKVbwJv0SfX for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 10:48:11 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05F1240291
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 10:48:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623250090;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=PrOeqvJMoWtJVe96cJvl1hmhzN8DEs8cwTbNUGz6wOA=;
 b=FCBpuamxI60vjdDrduhelISvX8wn2JqylW406U8MoHXG/kykavBVqfbgJomVAZUsNeqMnA
 jugb01TugKBHFc/kjhL2pX+oieA6nPqpMloFqLR1eO9Qj8RGMnRV3M5JPyqZHuRMVPGWhw
 K+G6NrNBYiVqLqR5snojsI1Z28teTdc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-LG5v_y3ANyejdc24tfGiiQ-1; Wed, 09 Jun 2021 10:48:09 -0400
X-MC-Unique: LG5v_y3ANyejdc24tfGiiQ-1
Received: by mail-wr1-f72.google.com with SMTP id
 u20-20020a0560001614b02901115c8f2d89so10795314wrb.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Jun 2021 07:48:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:organization
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=PrOeqvJMoWtJVe96cJvl1hmhzN8DEs8cwTbNUGz6wOA=;
 b=lGH9LU5UQnYCTj7iVRCEdcjicvc9n8l9gBEEdyngRw1rwC9c2HcmIhue0YcNwswSLr
 FyiGo5r21grg9OCGQDUVuhiMu6uE0s/Rv3ykNWZ5cQhtK2vG56VaXHIfIMtjP8+/TS/E
 AooU46uFV1021n1ZTO2otjRAjLBJSkYh/wu6s0I3XhOc6LCGV65q1raBb2Mcr2cftR2E
 B2jx1sjkM9RvfZ8gX0Pt8IXxtyiEw/xOv90AqVNTJf6/MEi7BWugPprKI6pySp07xEVi
 BiJjDkicmFDWjtMc9VDNIzFAvslfiWe4exWATC7yyic9/Vi/aU3T5+B+Cy7mM0j2gbFF
 K9Rg==
X-Gm-Message-State: AOAM533LUpRgkYlknLyyQxDlUtbu4knH5anIghH97Daqn0FCu7nFXKW1
 YGBWloafe9gbrejTDvfQe8p/+Qr6tdkgs/yDs2jVEkWO3YHlCB4bJPsmGIbr6TkjMlMMQoELMlw
 7o/u1QhD6KzsAwKF6+5kChZdE
X-Received: by 2002:a05:600c:3650:: with SMTP id
 y16mr229982wmq.92.1623250088436; 
 Wed, 09 Jun 2021 07:48:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCAiBsFuiMWwt/1SzyiXo2fJvC+um3AdJEpxL4Sag96x9kAuMU05DHDft/XTl7ffMxHOyY7g==
X-Received: by 2002:a05:600c:3650:: with SMTP id
 y16mr229941wmq.92.1623250088100; 
 Wed, 09 Jun 2021 07:48:08 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c611d.dip0.t-ipconnect.de. [91.12.97.29])
 by smtp.gmail.com with ESMTPSA id j34sm27041wms.7.2021.06.09.07.48.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Jun 2021 07:48:07 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 6/7] s390x: unify header guards
To: Cornelia Huck <cohuck@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Andrew Jones <drjones@redhat.com>
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-7-cohuck@redhat.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <e3fb2f65-fb36-d882-4b3b-f433d557f45a@redhat.com>
Date: Wed, 9 Jun 2021 16:48:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-7-cohuck@redhat.com>
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
> Standardize header guards to _ASMS390X_HEADER_H_, _S390X_HEADER_H_,
> and S390X_HEADER_H, respectively.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   lib/s390x/asm/arch_def.h | 4 ++--
>   lib/s390x/asm/barrier.h  | 4 ++--
>   lib/s390x/asm/cpacf.h    | 6 +++---
>   lib/s390x/asm/facility.h | 4 ++--
>   lib/s390x/asm/float.h    | 4 ++--
>   lib/s390x/asm/mem.h      | 4 ++--
>   lib/s390x/asm/sigp.h     | 6 +++---
>   lib/s390x/asm/spinlock.h | 4 ++--
>   lib/s390x/asm/time.h     | 4 ++--
>   lib/s390x/asm/uv.h       | 4 ++--
>   lib/s390x/css.h          | 4 ++--
>   lib/s390x/interrupt.h    | 4 ++--
>   lib/s390x/mmu.h          | 4 ++--
>   lib/s390x/sclp.h         | 6 +++---
>   lib/s390x/sie.h          | 6 +++---
>   lib/s390x/smp.h          | 4 ++--
>   lib/s390x/uv.h           | 4 ++--
>   lib/s390x/vm.h           | 6 +++---
>   s390x/sthyi.h            | 4 ++--
>   19 files changed, 43 insertions(+), 43 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 7e2c5e623ab2..76f9e3862965 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -5,8 +5,8 @@
>    * Authors:
>    *  David Hildenbrand <david@redhat.com>
>    */
> -#ifndef _ASM_S390X_ARCH_DEF_H_
> -#define _ASM_S390X_ARCH_DEF_H_
> +#ifndef _ASMS390X_ARCH_DEF_H_
> +#define _ASMS390X_ARCH_DEF_H_
>   
>   struct stack_frame {
>   	struct stack_frame *back_chain;
> diff --git a/lib/s390x/asm/barrier.h b/lib/s390x/asm/barrier.h
> index 8e2fd6d90034..9534f9e8fa96 100644
> --- a/lib/s390x/asm/barrier.h
> +++ b/lib/s390x/asm/barrier.h
> @@ -6,8 +6,8 @@
>    *  Thomas Huth <thuth@redhat.com>
>    *  David Hildenbrand <david@redhat.com>
>    */
> -#ifndef _ASM_S390X_BARRIER_H_
> -#define _ASM_S390X_BARRIER_H_
> +#ifndef _ASMS390X_BARRIER_H_
> +#define _ASMS390X_BARRIER_H_
>   
>   #include <asm-generic/barrier.h>
>   
> diff --git a/lib/s390x/asm/cpacf.h b/lib/s390x/asm/cpacf.h
> index 805fcf1a2d71..685262b0ff62 100644
> --- a/lib/s390x/asm/cpacf.h
> +++ b/lib/s390x/asm/cpacf.h
> @@ -8,8 +8,8 @@
>    *	      Harald Freudenberger (freude@de.ibm.com)
>    *	      Martin Schwidefsky <schwidefsky@de.ibm.com>
>    */
> -#ifndef _ASM_S390_CPACF_H
> -#define _ASM_S390_CPACF_H
> +#ifndef _ASMS390X_CPACF_H_
> +#define _ASMS390X_CPACF_H_
>   
>   #include <asm/facility.h>
>   #include <linux/compiler.h>
> @@ -471,4 +471,4 @@ static inline void cpacf_pckmo(long func, void *param)
>   		: "cc", "memory");
>   }
>   
> -#endif	/* _ASM_S390_CPACF_H */
> +#endif	/* _ASMS390X_CPACF_H_ */
> diff --git a/lib/s390x/asm/facility.h b/lib/s390x/asm/facility.h
> index 95d4a15fe34f..ef0fd037ed35 100644
> --- a/lib/s390x/asm/facility.h
> +++ b/lib/s390x/asm/facility.h
> @@ -5,8 +5,8 @@
>    * Authors:
>    *  David Hildenbrand <david@redhat.com>
>    */
> -#ifndef _ASM_S390X_FACILITY_H_
> -#define _ASM_S390X_FACILITY_H_
> +#ifndef _ASMS390X_FACILITY_H_
> +#define _ASMS390X_FACILITY_H_
>   
>   #include <libcflat.h>
>   #include <asm/facility.h>
> diff --git a/lib/s390x/asm/float.h b/lib/s390x/asm/float.h
> index 136794475849..eb752050b162 100644
> --- a/lib/s390x/asm/float.h
> +++ b/lib/s390x/asm/float.h
> @@ -5,8 +5,8 @@
>    * Authors:
>    *  David Hildenbrand <david@redhat.com>
>    */
> -#ifndef _ASM_S390X_FLOAT_H_
> -#define _ASM_S390X_FLOAT_H_
> +#ifndef _ASMS390X_FLOAT_H_
> +#define _ASMS390X_FLOAT_H_
>   
>   static inline void set_fpc(uint32_t fpc)
>   {
> diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
> index 281390ebd816..1963cef7ec03 100644
> --- a/lib/s390x/asm/mem.h
> +++ b/lib/s390x/asm/mem.h
> @@ -5,8 +5,8 @@
>    * Copyright IBM Corp. 2018
>    * Author(s): Janosch Frank <frankja@de.ibm.com>
>    */
> -#ifndef _ASM_S390_MEM_H
> -#define _ASM_S390_MEM_H
> +#ifndef _ASMS390X_MEM_H_
> +#define _ASMS390X_MEM_H_
>   
>   #define SKEY_ACC	0xf0
>   #define SKEY_FP		0x08
> diff --git a/lib/s390x/asm/sigp.h b/lib/s390x/asm/sigp.h
> index 00844d26d15a..61d2c6256fed 100644
> --- a/lib/s390x/asm/sigp.h
> +++ b/lib/s390x/asm/sigp.h
> @@ -5,8 +5,8 @@
>    * Copied from the Linux kernel file arch/s390/include/asm/sigp.h
>    */
>   
> -#ifndef ASM_S390X_SIGP_H
> -#define ASM_S390X_SIGP_H
> +#ifndef _ASMS390X_SIGP_H_
> +#define _ASMS390X_SIGP_H_
>   
>   /* SIGP order codes */
>   #define SIGP_SENSE			1
> @@ -73,4 +73,4 @@ static inline int sigp_retry(uint16_t addr, uint8_t order, unsigned long parm,
>   }
>   
>   #endif /* __ASSEMBLER__ */
> -#endif /* ASM_S390X_SIGP_H */
> +#endif /* _ASMS390X_SIGP_H_ */
> diff --git a/lib/s390x/asm/spinlock.h b/lib/s390x/asm/spinlock.h
> index 677d2cd6e287..22d4d3899569 100644
> --- a/lib/s390x/asm/spinlock.h
> +++ b/lib/s390x/asm/spinlock.h
> @@ -6,8 +6,8 @@
>    *  Thomas Huth <thuth@redhat.com>
>    *  David Hildenbrand <david@redhat.com>
>    */
> -#ifndef __ASMS390X_SPINLOCK_H
> -#define __ASMS390X_SPINLOCK_H
> +#ifndef _ASMS390X_SPINLOCK_H_
> +#define _ASMS390X_SPINLOCK_H_
>   
>   #include <asm-generic/spinlock.h>
>   
> diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
> index 0d67f7231992..7652a151e87a 100644
> --- a/lib/s390x/asm/time.h
> +++ b/lib/s390x/asm/time.h
> @@ -8,8 +8,8 @@
>    * Copied from the s390/intercept test by:
>    *  Pierre Morel <pmorel@linux.ibm.com>
>    */
> -#ifndef ASM_S390X_TIME_H
> -#define ASM_S390X_TIME_H
> +#ifndef _ASMS390X_TIME_H_
> +#define _ASMS390X_TIME_H_
>   
>   #define STCK_SHIFT_US	(63 - 51)
>   #define STCK_MAX	((1UL << 52) - 1)
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index b22cbaa87109..dc3e02dea1b4 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -9,8 +9,8 @@
>    * This code is free software; you can redistribute it and/or modify it
>    * under the terms of the GNU General Public License version 2.
>    */
> -#ifndef ASM_S390X_UV_H
> -#define ASM_S390X_UV_H
> +#ifndef _ASMS390X_UV_H_
> +#define _ASMS390X_UV_H_
>   
>   #define UVC_RC_EXECUTED		0x0001
>   #define UVC_RC_INV_CMD		0x0002
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 7e3d2613402e..d644971fb2b7 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -6,8 +6,8 @@
>    * Author: Pierre Morel <pmorel@linux.ibm.com>
>    */
>   
> -#ifndef CSS_H
> -#define CSS_H
> +#ifndef _S390X_CSS_H_
> +#define _S390X_CSS_H_
>   
>   #define lowcore_ptr ((struct lowcore *)0x0)
>   
> diff --git a/lib/s390x/interrupt.h b/lib/s390x/interrupt.h
> index 1973d267c2f1..99fa0beee9ad 100644
> --- a/lib/s390x/interrupt.h
> +++ b/lib/s390x/interrupt.h
> @@ -1,5 +1,5 @@
> -#ifndef INTERRUPT_H
> -#define INTERRUPT_H
> +#ifndef _S390X_INTERRUPT_H_
> +#define _S390X_INTERRUPT_H_
>   #include <asm/interrupt.h>
>   
>   int register_io_int_func(void (*f)(void));
> diff --git a/lib/s390x/mmu.h b/lib/s390x/mmu.h
> index 603f289e8e00..b995f85b839f 100644
> --- a/lib/s390x/mmu.h
> +++ b/lib/s390x/mmu.h
> @@ -7,8 +7,8 @@
>    * Authors:
>    *	Janosch Frank <frankja@de.ibm.com>
>    */
> -#ifndef _ASMS390X_MMU_H_
> -#define _ASMS390X_MMU_H_
> +#ifndef _S390X_MMU_H_
> +#define _S390X_MMU_H_
>   
>   void protect_page(void *vaddr, unsigned long prot);
>   void protect_range(void *start, unsigned long len, unsigned long prot);
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 7abf1038f5ee..28e526e2c915 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -10,8 +10,8 @@
>    * Author: Christian Borntraeger <borntraeger@de.ibm.com>
>    */
>   
> -#ifndef SCLP_H
> -#define SCLP_H
> +#ifndef _S390X_SCLP_H_
> +#define _S390X_SCLP_H_
>   
>   #define SCLP_CMD_CODE_MASK                      0xffff00ff
>   
> @@ -329,4 +329,4 @@ void sclp_memory_setup(void);
>   uint64_t get_ram_size(void);
>   uint64_t get_max_ram_size(void);
>   
> -#endif /* SCLP_H */
> +#endif /* _S390X_SCLP_H_ */
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index 518613baf1fa..db30d6164ab6 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -1,6 +1,6 @@
>   /* SPDX-License-Identifier: GPL-2.0-or-later */
> -#ifndef SIE_H
> -#define SIE_H
> +#ifndef _S390X_SIE_H_
> +#define _S390X_SIE_H_
>   
>   #define CPUSTAT_STOPPED    0x80000000
>   #define CPUSTAT_WAIT       0x10000000
> @@ -195,4 +195,4 @@ extern void sie_entry(void);
>   extern void sie_exit(void);
>   extern void sie64a(struct kvm_s390_sie_block *sblk, struct vm_save_area *save_area);
>   
> -#endif /* SIE_H */
> +#endif /* _S390X_SIE_H_ */
> diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
> index 67ff16ca3c52..a2609f11e40b 100644
> --- a/lib/s390x/smp.h
> +++ b/lib/s390x/smp.h
> @@ -7,8 +7,8 @@
>    * Authors:
>    *  Janosch Frank <frankja@linux.ibm.com>
>    */
> -#ifndef SMP_H
> -#define SMP_H
> +#ifndef _S390X_SMP_H_
> +#define _S390X_SMP_H_
>   
>   #include <asm/arch_def.h>
>   
> diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
> index 42608a967a03..2b23407a2fcf 100644
> --- a/lib/s390x/uv.h
> +++ b/lib/s390x/uv.h
> @@ -1,6 +1,6 @@
>   /* SPDX-License-Identifier: GPL-2.0-or-later */
> -#ifndef UV_H
> -#define UV_H
> +#ifndef _S390X_UV_H_
> +#define _S390X_UV_H_
>   
>   bool uv_os_is_guest(void);
>   bool uv_os_is_host(void);
> diff --git a/lib/s390x/vm.h b/lib/s390x/vm.h
> index 16722760cb46..7abba0ccae3d 100644
> --- a/lib/s390x/vm.h
> +++ b/lib/s390x/vm.h
> @@ -5,9 +5,9 @@
>    * Copyright (c) 2020 Red Hat Inc
>    */
>   
> -#ifndef S390X_VM_H
> -#define S390X_VM_H
> +#ifndef _S390X_VM_H_
> +#define _S390X_VM_H_
>   
>   bool vm_is_tcg(void);
>   
> -#endif  /* S390X_VM_H */
> +#endif  /* _S390X_VM_H_ */
> diff --git a/s390x/sthyi.h b/s390x/sthyi.h
> index bbd74c6197c3..0a47c2385dc7 100644
> --- a/s390x/sthyi.h
> +++ b/s390x/sthyi.h
> @@ -7,8 +7,8 @@
>    * Authors:
>    *    Janosch Frank <frankja@linux.vnet.ibm.com>
>    */
> -#ifndef _STHYI_H_
> -#define _STHYI_H_
> +#ifndef S390X_STHYI_H
> +#define S390X_STHYI_H
>   
>   #include <stdint.h>
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
