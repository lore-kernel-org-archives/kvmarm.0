Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024A9C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 10:37:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4341922241
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 10:37:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4341922241
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7491C4B100;
	Mon, 18 Jan 2021 05:37:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IqthNfy7AQGZ; Mon, 18 Jan 2021 05:37:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B84174B1F2;
	Mon, 18 Jan 2021 05:37:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89D984B16F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 05:37:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CodPSI+CrrRU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 05:37:49 -0500 (EST)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BCE424B100
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 05:37:49 -0500 (EST)
Received: by mail-wr1-f47.google.com with SMTP id 7so8694265wrz.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 02:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=8RXkrFRFJwJ+oqCkXLgdONP2D6hTU8qpkCbMpSj9WH0=;
 b=OhObTyOoxSMRWrfcNrTccJedaKdnx+PkZW8hkA3Nhksao0r9R5CyAx2p0WOwzsu/hp
 8XswgsCkqkdhri9K5twqBgerq1kg1J6EECSqMn2Hasib1YCZXszwR1hG8qoZdeTaPAMI
 qUrUfGrU4UbdzoOQAvzimXKEcCgFBlCVt12Ykh58Ajm1HlwmYr72u24pJfXgLB4qdyvu
 NqQ4bRbb9Yh0vMWOuaDd6dDQAN38+sM0Zs4vZp+5ysqdBxjUmuvEp7rbDiU0VY5icDf2
 74HRq16H5sO35IsYdo9GcnONS8W58IehOpKcHLkfqqMdJoJkCGAiWRxDY/L0OQNn6l81
 tu6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=8RXkrFRFJwJ+oqCkXLgdONP2D6hTU8qpkCbMpSj9WH0=;
 b=FUxSMNQ5WuwVxDVckg9m1hR4B9cSc5sbgNBHMB40GsWPMtnG0SHSlG8oiIsU9ngZLi
 nkkoYHhfLGl4rEs+cfs1lpB/Ug+n8Sjk2J5i43+76dAGRWpytJGNHvTLbQH0UIAuav9B
 rCmpUrPCOwianSW8DSuTPPYYXa1cufSxUb5QGhUj8UynD9QWuaWp5zy4PYFv0mUJUcEc
 2Kc48gf/yvU19UPkkluUxjcd5nO61mU6IqS91k1vFtKP4P4cdF4nUTbB8fMf7RgnkB4y
 1GkqxZad7yg8BlIdP8uGsjaTPzXUyixAsQNlmFcAcSF42ngUBDFajlnrnKZOS/6qj9We
 vhPQ==
X-Gm-Message-State: AOAM533euBeHLql1plFs9xDQXhm01/VGPeyA9QTHmJRJL7HOGLRo0Wx4
 BxXkDBm0AVeJLS/vtrMuIHTkCg==
X-Google-Smtp-Source: ABdhPJysKE8lBWCShK+bM2jqC3yLfqUFGuDKvVf+C6aF24rTM535yOPc8akXpH9HIWrOLgV6YvS9jg==
X-Received: by 2002:a5d:690d:: with SMTP id t13mr25129837wru.410.1610966268608; 
 Mon, 18 Jan 2021 02:37:48 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:3d4d:985d:87b7:4d55])
 by smtp.gmail.com with ESMTPSA id s13sm30502983wra.53.2021.01.18.02.37.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Jan 2021 02:37:47 -0800 (PST)
Date: Mon, 18 Jan 2021 10:37:46 +0000
From: David Brazdil <dbrazdil@google.com>
To: Elena Petrova <lenaptr@google.com>
Subject: Re: [PATCH v3 2/9] KVM: arm64: Add a buffer that can pass UBSan data
 from hyp/nVHE to kernel
Message-ID: <20210118103746.hnmx2eqhubx6ekni@google.com>
References: <20210115171830.3602110-1-lenaptr@google.com>
 <20210115171830.3602110-3-lenaptr@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210115171830.3602110-3-lenaptr@google.com>
Cc: George Popescu <georgepope@google.com>, Marc Zyngier <maz@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
 George Popescu <george.apopescu97@gmail.com>,
 linux-arm-kernel@lists.infradead.org
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

On Fri, Jan 15, 2021 at 05:18:23PM +0000, Elena Petrova wrote:
> From: George Popescu <georgepope@google.com>
> 
> Share a buffer between the kernel and the hyp/nVHE code by using the
> macros from kvm_debug_buffer.h.
> The hyp/nVHE code requires a write index which counts how many elements
> have been writtens inside the buffer and the kernel requires a read
> index which counts how many elements have been read from the buffer.
> The write index and the buffer are shared with the kernel in read-only.
> 
> The kvm_debug_buffer_ind returns the reading and writing points of the
> circular buffer and updates the reading index.
> 
> Data collected from UBSan handlers inside hyp/nVHE is stored in the
> kvm_ubsan_buffer.
> This buffer stores only UBSan data because it should not be preoccupied
> by other mechanisms data structures and functionalities.
> 
> Also, for the moment the buffer is mapped inside .bss, where both the kernel
> and the hyp/nVHE code have Read/Write rights, but in the future this will change
> and the kernel will not be able to acess hyp/nVHE's .bss. At that point the buffer
> will only need to be mapped in order for this patch to work.
> 
> Signed-off-by: Elena Petrova <lenaptr@google.com>
> ---
>  arch/arm64/include/asm/assembler.h        | 11 +++++++
>  arch/arm64/include/asm/kvm_debug_buffer.h | 36 ++++++++++++++++++++
>  arch/arm64/include/asm/kvm_host.h         |  8 ++++-
>  arch/arm64/include/asm/kvm_ubsan.h        | 14 ++++++++
>  arch/arm64/kvm/Makefile                   |  2 ++
>  arch/arm64/kvm/arm.c                      |  9 +++++
>  arch/arm64/kvm/hyp/nvhe/host.S            |  4 +++
>  arch/arm64/kvm/hyp/nvhe/ubsan.c           | 23 +++++++++++++
>  arch/arm64/kvm/kvm_ubsan_buffer.c         | 40 +++++++++++++++++++++++
>  9 files changed, 146 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/include/asm/kvm_debug_buffer.h
>  create mode 100644 arch/arm64/include/asm/kvm_ubsan.h
>  create mode 100644 arch/arm64/kvm/kvm_ubsan_buffer.c
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index bf125c591116..ebc18a8a0e1f 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -258,6 +258,17 @@ alternative_endif
>  	ldr	\dst, [\dst, \tmp]
>  	.endm
>  
> +	/*
> +         * @sym: The name of the per-cpu variable
> +         * @reg: value to store
> +         * @tmp1: scratch register
> +         * @tmp2: scratch register
> +         */
> +        .macro str_this_cpu sym, reg, tmp1, tmp2
> +        adr_this_cpu \tmp1, \sym, \tmp2
> +        str \reg, [\tmp1]
> +        .endm
> +
>  /*
>   * vma_vm_mm - get mm pointer from vma pointer (vma->vm_mm)
>   */
> diff --git a/arch/arm64/include/asm/kvm_debug_buffer.h b/arch/arm64/include/asm/kvm_debug_buffer.h
> new file mode 100644
> index 000000000000..e5375c2cff1a
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_debug_buffer.h
> @@ -0,0 +1,36 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright 2020 Google LLC
> + * Author: George Popescu <georgepope@google.com>
> + */
> +
> +#include <linux/percpu-defs.h>
> +
> +
> +#define KVM_DEBUG_BUFFER_SIZE 1000
nit: unused?

> +
> +#ifdef __KVM_NVHE_HYPERVISOR__
> +#define DEFINE_KVM_DEBUG_BUFFER(type_name, buffer_name, write_ind, size)\
> +	DEFINE_PER_CPU(type_name, buffer_name)[size];			\
> +	DEFINE_PER_CPU(unsigned long, write_ind) = 0;

This is subjective but I would:
  * stop calling the second variable a "write index" and instead call it
    "cursor" - I think this is a leftover from George's early two-cursor
    implementation
  * wrap these two variables in a struct; that is a bit tricky given that each
    instantiation defines its own size (the macros would have to generate that
    struct), so bar that I would at least generate the name of the cursor
    variable as buffer_name##suffix.

> +
> +#define DECLARE_KVM_DEBUG_BUFFER(type_name, buffer_name, write_ind, size)\
> +	DECLARE_PER_CPU(type_name, buffer_name)[size];			\
> +	DECLARE_PER_CPU(unsigned long, write_ind);
> +#else
> +#define DECLARE_KVM_DEBUG_BUFFER(type_name, buffer_name, write_ind, size)\
> +	DECLARE_KVM_NVHE_PER_CPU(type_name, buffer_name)[size]; 	\
> +        DECLARE_KVM_NVHE_PER_CPU(unsigned long, write_ind);
> +#endif //__KVM_NVHE_HYPERVISOR__
> +
> +#ifdef __ASSEMBLY__
> +#include <asm/assembler.h>
> +
> +.macro clear_buffer tmp1, tmp2, tmp3
> +        mov \tmp1, 0
> +#ifdef CONFIG_UBSAN
> +        str_this_cpu kvm_ubsan_buff_wr_ind, \tmp1, \tmp2, \tmp3
> +#endif //CONFIG_UBSAN
> +.endm

I find this macro odd. Everything else in this file is about a generic buffer
data structure, yet this macro enumerates all instantiations of it (currently
just one). Please keep this generic and pass the name of the buffer cursor
as a parameter.

> +
> +#endif
> \ No newline at end of file
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 8fcfab0c2567..905ca0d7c52c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -592,6 +592,12 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
>  void kvm_arm_halt_guest(struct kvm *kvm);
>  void kvm_arm_resume_guest(struct kvm *kvm);
>  
> +
nit: Two empty lines

> +#ifdef CONFIG_UBSAN
> +extern void __kvm_check_ubsan_buffer(void);
> +#else
> +static inline void __kvm_check_ubsan_buffer(void) {}
> +#endif /* CONFIG_UBSAN */
nit: An empty line here would be nice.

>  #define kvm_call_hyp_nvhe(f, ...)						\
>  	({								\
>  		struct arm_smccc_res res;				\
> @@ -599,7 +605,7 @@ void kvm_arm_resume_guest(struct kvm *kvm);
>  		arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(f),		\
>  				  ##__VA_ARGS__, &res);			\
>  		WARN_ON(res.a0 != SMCCC_RET_SUCCESS);			\
> -									\
> +		__kvm_check_ubsan_buffer();				\
>  		res.a1;							\
>  	})
>  
> diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
> new file mode 100644
> index 000000000000..fb32c7fd65d4
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_ubsan.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright 2020 Google LLC
> + * Author: George Popescu <georgepope@google.com>
> + */
> +
> +#include <ubsan.h>
> +
> +#define UBSAN_MAX_TYPE 6
nit: How about you make this the last entry in the `type` enum in
`kvm_ubsan_info`.

> +#define KVM_UBSAN_BUFFER_SIZE 1000
> +
> +struct kvm_ubsan_info {
> +	int type;
> +};
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 13b017284bf9..ab3a9c402550 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -4,6 +4,7 @@
>  #
>  
>  ccflags-y += -I $(srctree)/$(src)
> +CFLAGS_kvm_ubsan_buffer.o += -I $(srctree)/lib/
>  
>  KVM=../../../virt/kvm
>  
> @@ -25,3 +26,4 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
>  	 vgic/vgic-its.o vgic/vgic-debug.o
>  
>  kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o
> +kvm-$(CONFIG_UBSAN) += kvm_ubsan_buffer.o
nit: Can we just name this kvm_ubsan.c?

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 04c44853b103..63f0495550b8 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1784,6 +1784,15 @@ static int init_hyp_mode(void)
>  			goto out_err;
>  		}
>  	}
> +#ifdef CONFIG_UBSAN
> +	/* required by ubsan to access the handlers structures fields */
nit: capital R, grammar "handlers structures fields"

> +	err = create_hyp_mappings(kvm_ksym_ref(_data),
> +				  kvm_ksym_ref(__end_once), PAGE_HYP_RO);
> +	if (err) {
> +		kvm_err("Cannot map data section\n");
> +		goto out_err;
> +	}
> +#endif

The hypervisor currently doesn't use the .data section, so this approach works
fine at the moment. But this will stop working as soon as somebody starts using
.data for other purposes. It would be nice to do this properly now rather than
fix it later as part of some unrelated series. What you'd need to do:

  * add .data to arch/arm64/kvm/hyp/nvhe/hyp.lds.S; that will rename
    hypervisor's .data to .hyp.data
  * add .hyp.data to arch/arm64/kernel/vmlinux.lds.S
  * add new entries to arch/arm64/include/asm/sections.h
  * map .hyp.data here

Related, this currently relies on the fact that all pointers in .data are the
kernel VAs. That means later in this series it is safe to just copy the event
description to the buffer without any conversion. my series "Relocate absolute
hyp VAs" will convert all pointers in .hyp.* sections to the hypervisor VAs.
So once we do introduce .hyp.data, the hypervisor's ubsan.c will also have to
convert all pointers.

>  
>  	/*
>  	 * Map Hyp percpu pages
> diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> index a820dfdc9c25..0967906265d3 100644
> --- a/arch/arm64/kvm/hyp/nvhe/host.S
> +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> @@ -8,6 +8,7 @@
>  
>  #include <asm/assembler.h>
>  #include <asm/kvm_asm.h>
> +#include <asm/kvm_debug_buffer.h>
>  #include <asm/kvm_mmu.h>
>  
>  	.text
> @@ -34,6 +35,9 @@ SYM_FUNC_START(__host_exit)
>  	/* Store the host regs x18-x29, lr */
>  	save_callee_saved_regs x0
>  
> +	/* when entering the host clear the buffers */
nit: capital W

> +   	clear_buffer    x4, x5, x6  
> +
>  	/* Save the host context pointer in x29 across the function call */
>  	mov	x29, x0
>  	bl	handle_trap
> diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
> index a5db6b61ceb2..8a194fb1f6cf 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ubsan.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
> @@ -3,10 +3,33 @@
>   * Copyright 2020 Google LLC
>   * Author: George Popescu <georgepope@google.com>
>   */
> +#include <linux/bitops.h>
>  #include <linux/ctype.h>
>  #include <linux/types.h>
> +#include <linux/percpu-defs.h>
> +#include <linux/kvm_host.h>
> +#include <asm/kvm_arm.h>
> +#include <asm/kvm_asm.h>
> +#include <asm/kvm_ubsan.h>
> +#include <asm/kvm_debug_buffer.h>
> +#include <kvm/arm_pmu.h>
>  #include <ubsan.h>
>  
> +DEFINE_KVM_DEBUG_BUFFER(struct kvm_ubsan_info, kvm_ubsan_buffer,
> +                kvm_ubsan_buff_wr_ind, KVM_UBSAN_BUFFER_SIZE);
> +
> +static inline struct kvm_ubsan_info *kvm_ubsan_buffer_next_slot(void)
> +{
> +	struct kvm_ubsan_info *res = NULL;
> +	unsigned long write_ind = __this_cpu_read(kvm_ubsan_buff_wr_ind);
nit: checkpatch will want an empty line between declarations and code

> +	if (write_ind < KVM_UBSAN_BUFFER_SIZE) {
> +		res = this_cpu_ptr(&kvm_ubsan_buffer[write_ind]);
> +		++write_ind;
> +		__this_cpu_write(kvm_ubsan_buff_wr_ind, write_ind);
nit: Could save a line by just writing write_ind+1

> +	}
> +	return res;
> +}
> +
>  void __ubsan_handle_add_overflow(void *_data, void *lhs, void *rhs) {}
>  
>  void __ubsan_handle_sub_overflow(void *_data, void *lhs, void *rhs) {}
> diff --git a/arch/arm64/kvm/kvm_ubsan_buffer.c b/arch/arm64/kvm/kvm_ubsan_buffer.c
> new file mode 100644
> index 000000000000..4a1959ba9f68
> --- /dev/null
> +++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
> @@ -0,0 +1,40 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright 2020 Google LLC
> + * Author: George Popescu <georgepope@google.com>
> + */
> +
> +#include <linux/ctype.h>
> +#include <linux/types.h>
> +#include <asm/kvm_debug_buffer.h>
> +#include <asm/kvm_arm.h>
> +#include <asm/kvm_asm.h>
> +#include <kvm/arm_pmu.h>
> +
> +#include <ubsan.h>
> +#include <asm/kvm_ubsan.h>
> +
> +DECLARE_KVM_DEBUG_BUFFER(struct kvm_ubsan_info, kvm_ubsan_buffer,
> +		kvm_ubsan_buff_wr_ind, KVM_UBSAN_BUFFER_SIZE);
> +
> +
> +void iterate_kvm_ubsan_buffer(unsigned long left, unsigned long right)
> +{
> +	unsigned long i;
> +	struct kvm_ubsan_info *slot;
> +
> +	slot = (struct kvm_ubsan_info *) this_cpu_ptr_nvhe_sym(kvm_ubsan_buffer);
nit: no whitespace after bracket?

> +	for (i = left; i < right; ++i) {
> +		/* check ubsan data */
> +		slot[i].type = 0;
> +	}
> +}
> +
> +void __kvm_check_ubsan_buffer(void)
> +{
> +	unsigned long *write_ind;
> +
> +	write_ind = (unsigned long *) this_cpu_ptr_nvhe_sym(kvm_ubsan_buff_wr_ind);
> +	iterate_kvm_ubsan_buffer(0, *write_ind);

I think this is another remnant of George's previous implementation. The first
argument will always be zero, so I don't see the point in splitting this into
two functions any more.

> +}
> +
> -- 
> 2.30.0.296.g2bfb1c46d8-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
