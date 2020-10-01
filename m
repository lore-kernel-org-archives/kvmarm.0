Return-Path: <SRS0=046z=DI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 679F4C47423
	for <kvmarm@archiver.kernel.org>; Thu,  1 Oct 2020 10:08:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C47B121531
	for <kvmarm@archiver.kernel.org>; Thu,  1 Oct 2020 10:08:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="hWAwHmbv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C47B121531
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EB6C4B109;
	Thu,  1 Oct 2020 06:08:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hP4emWkESObt; Thu,  1 Oct 2020 06:07:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D83AB4B220;
	Thu,  1 Oct 2020 06:07:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14D494B219
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2020 06:07:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zoEIsBGMpAD3 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Oct 2020 06:07:57 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB2FE4B109
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2020 06:07:56 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id t10so4987803wrv.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Oct 2020 03:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=NUXTaxsY7NaXachlgBjQGlyIz9BkJJJNfphdb55Lwns=;
 b=hWAwHmbvpL/fUYlWSvL43XM6O7kxQXolhLytRW4KP0Z6zlw+30mFb+/NKei2wkyFjW
 AFJtE+PMI/8r5JP1ykHUGVR4ysFO99EDr4a4/9WUldbEdf+iWIoIG2MyvVu/GGNvk/q9
 CwVZ7wkgPJe+3LCECgMYFCtBvbG7Z3EYknif+gIIDLkj+/ir0S1ToxC9pmbjg1Bfgm14
 i1ARfg5oRTR6difVdGKpxvzYyyEubV3G0o9JxizzDMIQuHMmG1K87BjB2Wtc9BlxKcIQ
 wyzQjihFjT1hNaUUEMeAKf4Etzh4HG37dmxP+26a9fblWLk5m9/ErrxU1igmKfxxYVD8
 KMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=NUXTaxsY7NaXachlgBjQGlyIz9BkJJJNfphdb55Lwns=;
 b=F2Zin4g2H2FHSrBpxR9vQHF54cRTzZHxxXlU3dfdE+Ia9uyhoXmSn4MOoTGtUHVqM2
 +wTv8XmsApdfG6zTgTPYfxqEK9ed29th+LiofNT62xhA72/MV/z9Q5mniBmUFuNzgzvb
 Z3ne+V62BM/dHwa7SNJ3gIjyc7itqp0mmt49TiEtOQfNnmb5f4DF2BRWXgpZjw5OgX09
 Tt0UmZejM78ZNaZyB+DZEzaxf6osaoGGQirJetdWSPXm2E6bBvV6rLEymp/awcAsYWl+
 m6xTUHXI7Y7Sbjsg6w4B2Tg5vdpD/bbnk2XYcJLuFNkUAkAy063ncsE9o0bPHoromqVn
 lNRg==
X-Gm-Message-State: AOAM530JCS9egaWZ0b9fqPL2uFrUnZptkALdX6CCwgLJL5v04qJIj0L0
 4gkTDKR6AEResaayU2aIX7jS/g==
X-Google-Smtp-Source: ABdhPJw+OAQXeCZAgHYba/uf4iegthEQioEJaaLoGJ3ir7TtqURdZbSjpiI/+z+XYaADHTW1Un++OQ==
X-Received: by 2002:adf:f750:: with SMTP id z16mr7697659wrp.377.1601546875447; 
 Thu, 01 Oct 2020 03:07:55 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id p14sm8281917wmc.8.2020.10.01.03.07.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Oct 2020 03:07:54 -0700 (PDT)
Date: Thu, 1 Oct 2020 11:07:50 +0100
From: Andrew Scull <ascull@google.com>
To: George-Aurelian Popescu <georgepope@google.com>
Subject: Re: [PATCH 03/14] KVM: arm64: Add support for creating and checking
 a logging buffer inside hyp/nVHE
Message-ID: <20201001100750.GA541087@google.com>
References: <20200914172750.852684-1-georgepope@google.com>
 <20200914172750.852684-4-georgepope@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200914172750.852684-4-georgepope@google.com>
Cc: tglx@linutronix.de, catalin.marinas@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, maskray@google.com, maz@kernel.org,
 masahiroy@kernel.org, clang-built-linux@googlegroups.com,
 linux-arm-kernel@lists.infradead.org, elver@google.com, keescook@chromium.org,
 arnd@arndb.de, linux-kbuild@vger.kernel.org, broonie@kernel.org,
 natechancellor@gmail.com, dvyukov@google.com, michal.lkml@markovi.net,
 ndesaulniers@google.com, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org
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

On Mon, Sep 14, 2020 at 05:27:39PM +0000, George-Aurelian Popescu wrote:
> From: George Popescu <georgepope@google.com>
> 
> Share a buffer between the kernel and the hyp/nVHE code by using the
> macros from kvm_debug_buffer.h.
> 
> The buffer is composed of a writing index and a statically allocated
> array. The writing index counts how many elements have been written inside
> the buffer and should be set to zero whenever the code goes back to
> EL2 with the clear_kvm_debug_buffer macro.
> 
> To avoid consistency problems the buffer is defined per_cpu and is designed
> to be read-only from the kernel perspective.
> 
> Check if there is any logging data from hyp/nVHE code.
> 
> Every time when the state returns back to the kernel after an hvc call,
> the __kvm_arm_check_debug_buffer macro checks if there is any data inside
> one of the predefined buffers.
> 
> Signed-off-by: George Popescu <georgepope@google.com>
> ---
>  arch/arm64/include/asm/kvm_debug_buffer.h | 34 +++++++++++++++++++++++
>  arch/arm64/include/asm/kvm_host.h         |  6 ++++
>  arch/arm64/kvm/hyp/hyp-entry.S            |  2 +-
>  3 files changed, 41 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/include/asm/kvm_debug_buffer.h
> 
> diff --git a/arch/arm64/include/asm/kvm_debug_buffer.h b/arch/arm64/include/asm/kvm_debug_buffer.h
> new file mode 100644
> index 000000000000..30c9b0b1a7bf
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_debug_buffer.h
> @@ -0,0 +1,34 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright 2020 Google LLC
> + * Author: George Popescu <georgepope@google.com>
> + */
> +#ifndef __ASSEMBLY__
> +
> +#include <linux/percpu-defs.h>
> +#include <asm/kvm_asm.h>
> +
> +#ifdef __KVM_NVHE_HYPERVISOR__
> +#define DEFINE_KVM_DEBUG_BUFFER(type_name, buff_name, size)             \
> +	DEFINE_PER_CPU(type_name, buff_name)[(size)];	                \
> +	DEFINE_PER_CPU(unsigned long, buff_name##_wr_ind) = 0
> +
> +#define DECLARE_KVM_DEBUG_BUFFER(type_name, buff_name, size)            \
> +	DECLARE_PER_CPU(type_name, buff_name)[(size)];                  \
> +	DECLARE_PER_CPU(unsigned long, buff_name##_wr_ind)
> +
> +#else
> +
> +#define DECLARE_KVM_DEBUG_BUFFER(type_name, buff_name, size)            \
> +	DECLARE_PER_CPU(type_name, kvm_nvhe_sym(buff_name))[(size)];    \
> +	DECLARE_PER_CPU(unsigned long, kvm_nvhe_sym(buff_name##_wr_ind))
> +#endif //__KVM_NVHE_HYPERVISOR__

nit: comment style, here and below

> +
> +#else
> +
> +.macro clear_kvm_debug_buffer sym tmp1, tmp2, tmp3
> +	mov \tmp1, 0
> +	hyp_str_this_cpu \sym, \tmp1, \tmp2, \tmp3
> +.endm

Can you can use xzr (zero register) directly rather than moving the
constant 0 into a temporary?

	hyp_str_this_cpu \sym, xzr, \tmp1, \tmp2

> +
> +#endif // __ASSEMBLY__
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 905c2b87e05a..adc8957e9321 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -494,6 +494,10 @@ u64 __kvm_call_hyp(void *hypfn, ...);
>  		__kvm_call_hyp(kvm_ksym_ref_nvhe(f), ##__VA_ARGS__);	\
>  	})
>  
> +#define __kvm_arm_check_debug_buffer()					\
> +{									\
> +}
> +
>  /*
>   * The couple of isb() below are there to guarantee the same behaviour
>   * on VHE as on !VHE, where the eret to EL1 acts as a context
> @@ -506,6 +510,7 @@ u64 __kvm_call_hyp(void *hypfn, ...);
>  			isb();						\
>  		} else {						\
>  			kvm_call_hyp_nvhe(f, ##__VA_ARGS__);		\
> +			__kvm_arm_check_debug_buffer();			\
>  		}							\
>  	} while(0)
>  
> @@ -518,6 +523,7 @@ u64 __kvm_call_hyp(void *hypfn, ...);
>  			isb();						\
>  		} else {						\
>  			ret = kvm_call_hyp_nvhe_ret(f, ##__VA_ARGS__);	\
> +			__kvm_arm_check_debug_buffer();			\

As Will was pointing out earlier, does the checking need to have
preemption disabled in case there is another call into hyp that corrupts
the buffer while it is being checked?

>  		}							\
>  									\
>  		ret;							\
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> index 46b4dab933d0..8df0082b9ccf 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -68,7 +68,7 @@ el1_sync:				// Guest trapped into EL2
>  	cbnz	x1, el1_hvc_guest	// called HVC
>  
>  	/* Here, we're pretty sure the host called HVC. */
> -	ldp	x0, x1, [sp], #16
> +	ldp	x0, x1,	[sp], #16

Is this a whitespace change? Maybe drop from this patch if it isn't
related.

>  
>  	/* Check for a stub HVC call */
>  	cmp	x0, #HVC_STUB_HCALL_NR
> -- 
> 2.28.0.618.gf4bc123cb7-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
