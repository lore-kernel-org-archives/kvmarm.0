Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A54C43461
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 13:26:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A9A632222C
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 13:26:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Zq/tYciP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9A632222C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F26014B239;
	Tue, 15 Sep 2020 09:26:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d4Mvm2ISK2GM; Tue, 15 Sep 2020 09:26:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A55B64B23C;
	Tue, 15 Sep 2020 09:26:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FE464B225
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 09:26:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lGb9WOdb0EbM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 09:26:02 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D26324B1FB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 09:26:01 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id q9so3374738wmj.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=2yNDf9GHL0dKoxvbJXMEZsmuBxqjSPWbFWnBQ+bsVx4=;
 b=Zq/tYciPyZx9KYwYCV96moEHbfItRebhPkfpO0LbQW/pm4ZWOPgKTwHSqtz4xf23IF
 5mLTx9a+4xiKwhvKGTqoPMoPROZxwFrtrJEhKE7D4bNjmg5bpzX72Po1xTqV534clV9e
 ZbeA++nyCC+7J8RavEVg+VfkhKXYfZOnZfBNiYnu7HCUaLBTGNw4TA7Pb6tRnNDjoY/9
 LeAjodtG9Nsh1QIqlQdbH05fuJx+LioT1ONqoeFicxUtvHZOBAb5dp1K36Z5A0zq9xBV
 EwLfoQwrB7NwD6E4MteZZ6kh+7bbWaQc0iMsknkvn9pCbCz1hlb8UwYAeov4L8oTfXaj
 IZVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=2yNDf9GHL0dKoxvbJXMEZsmuBxqjSPWbFWnBQ+bsVx4=;
 b=WTMFKvRyeNCoHW+FS8QzmENwG7JJaoI2AMGdHeBSyhsu05EWNT63qIJ14qJMTm+9dQ
 PZwwhskvhmEYn1QVmP+aJklqAk0n5k4LX7Rlyxqq0pUsndXRPAD6DHlz+dkTEBcyVfXO
 NUwbA4KtshEcOzjM6CJv0SNOR2qnO8Q1D4sxlzrZiXU+optfZ7kXhPAti5Q5/mU4unuo
 Xhv39Z8IXRw4X5KjMm++jQx1FNBxdx8KTB1Fm1P77JOH3svuLcFoyc6fZHhP8UtpdaNk
 U6q91swZ24yU+AqGMGb0/SkdqbDrWVn3T83HFwkYM4Dr6lDXPMk76QZ611G7b8vXjXoY
 so9Q==
X-Gm-Message-State: AOAM5327OQtzw7jQeHYAXXbC8qGKwLEQGy+Xc9DRNqU7rX1vswXRtLAU
 +RZ6Ps9FvKsQnwybCg0Z5Snlhw==
X-Google-Smtp-Source: ABdhPJzN6BNttbXpvzOKfcQ4kcLQ5J8dw1KcLzWHa30tMiYDtHJ/9aauUZjGQ/GppbVMyFDxuvMGdA==
X-Received: by 2002:a05:600c:204e:: with SMTP id
 p14mr4555612wmg.182.1600176360601; 
 Tue, 15 Sep 2020 06:26:00 -0700 (PDT)
Received: from google.com (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id s67sm25882497wmf.38.2020.09.15.06.25.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Sep 2020 06:26:00 -0700 (PDT)
Date: Tue, 15 Sep 2020 13:25:58 +0000
From: George Popescu <georgepope@google.com>
To: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 masahiroy@kernel.org, michal.lkml@markovi.net
Subject: Re: [PATCH 05/14] KVM: arm64: Define a buffer that can pass UBSan
 data from hyp/nVHE to kernel
Message-ID: <20200915132558.GA1948537@google.com>
References: <20200914172750.852684-1-georgepope@google.com>
 <20200914172750.852684-6-georgepope@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200914172750.852684-6-georgepope@google.com>
Cc: arnd@arndb.de, elver@google.com, tglx@linutronix.de, keescook@chromium.org,
 maskray@google.com, linux-kbuild@vger.kernel.org, ndesaulniers@google.com,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 clang-built-linux@googlegroups.com, broonie@kernel.org, dvyukov@google.com,
 natechancellor@gmail.com, kvmarm@lists.cs.columbia.edu,
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

On Mon, Sep 14, 2020 at 05:27:41PM +0000, George-Aurelian Popescu wrote:
> From: George Popescu <georgepope@google.com>
 Just realized that with UBSAN disabled this code won't compile. Sorry
 for that. Had to add the two lines of code below:
> Store data, which is collected from UBSan handlers that lives inside hyp/nVHE,
> into the kvm_ubsan_buffer.
> This buffer is designed to store only UBSan data because it should not be
> preoccupied by other mechanisms data structures and functionalities.
> 
> Map the buffer and the write index before switching the control to
> hyp/nVHE.
> 
> Map the kernel .data region to read the compile time generated UBSan struct's
> data from hyp/nVHE.
> 
> Signed-off-by: George Popescu <georgepope@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h   |  3 +++
>  arch/arm64/include/asm/kvm_host.h  |  6 +++++
>  arch/arm64/include/asm/kvm_ubsan.h | 17 +++++++++++++
>  arch/arm64/kvm/Makefile            |  4 ++++
>  arch/arm64/kvm/arm.c               | 38 +++++++++++++++++++++++++++++-
>  arch/arm64/kvm/hyp/hyp-entry.S     |  4 ++++
>  arch/arm64/kvm/hyp/nvhe/ubsan.c    | 24 ++++++++++++++++++-
>  arch/arm64/kvm/kvm_ubsan_buffer.c  | 32 +++++++++++++++++++++++++
>  8 files changed, 126 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kvm_ubsan.h
>  create mode 100644 arch/arm64/kvm/kvm_ubsan_buffer.c
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 200bb8d0a720..9d4a77f08ffd 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -63,6 +63,9 @@
>  #define CHOOSE_VHE_SYM(sym)	sym
>  #define CHOOSE_NVHE_SYM(sym)	kvm_nvhe_sym(sym)
>  
> +#define this_cpu_ptr_nvhe(sym)		this_cpu_ptr(&kvm_nvhe_sym(sym))
> +#define per_cpu_ptr_nvhe(sym, cpu)	per_cpu_ptr(&kvm_nvhe_sym(sym), cpu)
> +
>  #ifndef __KVM_NVHE_HYPERVISOR__
>  /*
>   * BIG FAT WARNINGS:
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index adc8957e9321..337fd2d0f976 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -494,8 +494,14 @@ u64 __kvm_call_hyp(void *hypfn, ...);
>  		__kvm_call_hyp(kvm_ksym_ref_nvhe(f), ##__VA_ARGS__);	\
>  	})
>  
> +#ifdef CONFIG_UBSAN
> +extern void __kvm_check_ubsan_buffer(void);
 #else
 static inline void __kvm_check_ubsan_buffer(void){}
> +#endif
> +
>  #define __kvm_arm_check_debug_buffer()					\
>  {									\
> +	if (IS_ENABLED(CONFIG_UBSAN))					\
> +		__kvm_check_ubsan_buffer();				\
>  }
>  
>  /*
> diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
> new file mode 100644
> index 000000000000..af607a796376
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_ubsan.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright 2020 Google LLC
> + * Author: George Popescu <georgepope@google.com>
> + */
> +
> +#ifdef CONFIG_UBSAN
> +#include <ubsan.h>
> +
> +
> +#define UBSAN_MAX_TYPE 6
> +#define KVM_UBSAN_BUFFER_SIZE 1000
> +
> +struct kvm_ubsan_info {
> +	int type;
> +};
> +#endif
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 99977c1972cc..92f06cb5b3df 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -24,4 +24,8 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
>  	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
>  	 vgic/vgic-its.o vgic/vgic-debug.o
>  
> +CFLAGS_kvm_ubsan_buffer.o += -I $(srctree)/lib/
> +CFLAGS_arm.o += -I $(srctree)/lib
> +
> +kvm-$(CONFIG_UBSAN) += kvm_ubsan_buffer.o
>  kvm-$(CONFIG_KVM_ARM_PMU)  += pmu-emul.o
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index b588c3b5c2f0..eff57069e103 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -42,10 +42,17 @@
>  #include <kvm/arm_pmu.h>
>  #include <kvm/arm_psci.h>
>  
> +#include <asm/kvm_debug_buffer.h>
> +#include <asm/kvm_ubsan.h>
> +
>  #ifdef REQUIRES_VIRT
>  __asm__(".arch_extension	virt");
>  #endif
>  
> +#ifdef CONFIG_UBSAN
> +DECLARE_KVM_DEBUG_BUFFER(struct kvm_ubsan_info, kvm_ubsan_buff, KVM_UBSAN_BUFFER_SIZE);
> +#endif
> +
>  DEFINE_PER_CPU(kvm_host_data_t, kvm_host_data);
>  static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
>  
> @@ -1519,7 +1526,15 @@ static int init_hyp_mode(void)
>  		kvm_err("Cannot map bss section\n");
>  		goto out_err;
>  	}
> -
> +#ifdef CONFIG_UBSAN
> +	/* required by ubsan to access the handlers structures fields */
> +	err = create_hyp_mappings(kvm_ksym_ref(_data),
> +				  kvm_ksym_ref(__end_once), PAGE_HYP_RO);
> +	if (err) {
> +		kvm_err("Cannot map data section\n");
> +		goto out_err;
> +	}
> +#endif
>  	err = kvm_map_vectors();
>  	if (err) {
>  		kvm_err("Cannot map vectors\n");
> @@ -1552,6 +1567,27 @@ static int init_hyp_mode(void)
>  		}
>  	}
>  
> +#ifdef CONFIG_UBSAN
> +	for_each_possible_cpu(cpu) {
> +		/* map the write index */
> +		struct kvm_ubsan_info *buff;
> +		unsigned long *wr_ind;
> +
> +		wr_ind = per_cpu_ptr_nvhe(kvm_ubsan_buff_wr_ind, cpu);
> +		err = create_hyp_mappings(wr_ind, wr_ind + 1, PAGE_HYP);
> +		if (err) {
> +			kvm_err("Cannot map the busan buffer write index: %d\n", err);
> +			goto out_err;
> +		}
> +		buff = per_cpu_ptr(kvm_nvhe_sym(kvm_ubsan_buff), cpu);
> +		err = create_hyp_mappings(buff, buff + KVM_UBSAN_BUFFER_SIZE, PAGE_HYP);
> +		if (err) {
> +			kvm_err("Cannot map the ubsan buffer: %d\n", err);
> +			goto out_err;
> +		}
> +	}
> +#endif
> +
>  	err = hyp_map_aux_data();
>  	if (err)
>  		kvm_err("Cannot map host auxiliary data: %d\n", err);
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> index 8df0082b9ccf..bcdbab4d2e43 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -14,6 +14,7 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/mmu.h>
> +#include <asm/kvm_debug_buffer.h>
>  
>  .macro save_caller_saved_regs_vect
>  	/* x0 and x1 were saved in the vector entry */
> @@ -74,6 +75,9 @@ el1_sync:				// Guest trapped into EL2
>  	cmp	x0, #HVC_STUB_HCALL_NR
>  	b.hs	1f
>  
> +#ifdef CONFIG_UBSAN
> +	clear_kvm_debug_buffer kvm_ubsan_buff_wr_ind, x4, x5, x6
> +#endif
>  	/*
>  	 * Compute the idmap address of __kvm_handle_stub_hvc and
>  	 * jump there. Since we use kimage_voffset, do not use the
> diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
> index a5db6b61ceb2..a43c9646e1e8 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ubsan.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
> @@ -3,9 +3,31 @@
>   * Copyright 2020 Google LLC
>   * Author: George Popescu <georgepope@google.com>
>   */
> +#include <linux/bitops.h>
>  #include <linux/ctype.h>
>  #include <linux/types.h>
> -#include <ubsan.h>
> +#include <linux/percpu-defs.h>
> +#include <linux/kvm_host.h>
> +#include <asm/kvm_arm.h>
> +#include <asm/kvm_asm.h>
> +#include <asm/kvm_ubsan.h>
> +#include <asm/kvm_debug_buffer.h>
> +#include <kvm/arm_pmu.h>
> +
> +DEFINE_KVM_DEBUG_BUFFER(struct kvm_ubsan_info, kvm_ubsan_buff, KVM_UBSAN_BUFFER_SIZE);
> +
> +static inline struct kvm_ubsan_info *kvm_ubsan_buffer_next_slot(void)
> +{
> +	struct kvm_ubsan_info *res;
> +	struct kvm_ubsan_info *buff;
> +	unsigned long *buff_ind;
> +	unsigned long buff_size = KVM_UBSAN_BUFFER_SIZE;
> +	unsigned int struct_size = sizeof(struct kvm_ubsan_info);
> +
> +	init_kvm_debug_buffer(kvm_ubsan_buff, struct kvm_ubsan_info, buff, buff_ind);
> +	res = kvm_debug_buffer_next_slot(buff, buff_ind, struct_size, buff_size);
> +	return res;
> +}
>  
>  void __ubsan_handle_add_overflow(void *_data, void *lhs, void *rhs) {}
>  
> diff --git a/arch/arm64/kvm/kvm_ubsan_buffer.c b/arch/arm64/kvm/kvm_ubsan_buffer.c
> new file mode 100644
> index 000000000000..28dcf19b5706
> --- /dev/null
> +++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
> @@ -0,0 +1,32 @@
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
> +DECLARE_KVM_DEBUG_BUFFER(struct kvm_ubsan_info, kvm_ubsan_buff, KVM_UBSAN_BUFFER_SIZE);
> +
> +
> +void __kvm_check_ubsan_buffer(void)
> +{
> +	unsigned long *write_ind;
> +	unsigned long it;
> +	struct kvm_ubsan_info *slot;
> +
> +	init_kvm_debug_buffer(kvm_ubsan_buff, struct kvm_ubsan_info, slot, write_ind);
> +	for_each_kvm_debug_buffer_slot(slot, write_ind, it) {
> +		/* check ubsan data */
> +		slot->type = 0;
> +	}
> +}
> +
> -- 
> 2.28.0.618.gf4bc123cb7-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
