Return-Path: <SRS0=046z=DI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 273BCC4727C
	for <kvmarm@archiver.kernel.org>; Thu,  1 Oct 2020 10:57:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 796F72085B
	for <kvmarm@archiver.kernel.org>; Thu,  1 Oct 2020 10:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="N8ey+Ycu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 796F72085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9B4D4B1C7;
	Thu,  1 Oct 2020 06:57:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0xGvjF1dHoJA; Thu,  1 Oct 2020 06:57:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96BC64B1FE;
	Thu,  1 Oct 2020 06:57:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18B744B1FE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2020 06:57:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4RJkFpAXd+Hr for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Oct 2020 06:57:36 -0400 (EDT)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E95B64B1C7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2020 06:57:35 -0400 (EDT)
Received: by mail-wm1-f67.google.com with SMTP id j136so1239549wmj.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Oct 2020 03:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=uIC7dj7oltWe68l04x0L6fWnaqmGQcvXiQBbnnS12XU=;
 b=N8ey+YcuMPXshManX3zPwywfOqeeNx1A+UcGWlWQ42qMYLsZxU5gVninqb376OrTab
 tNm3q9DB534M24+asCWHSsEssHzbplzSFsBkc/pCgsZEtnQ3elRGtE/Q5IObT50DijC3
 UmLLTpgJ4lUr0H3OJqpDW9aKOBWB0RZ5DmvrxumWfUN1rm//1CbPYTGxeQc1Uw8Lz7VG
 ZKeffsRrg8mjPPKf3ixhWmGOQCKOIMLPWb1x7KTnlxYxloWGwEZphXYNeZxt64BP0cn8
 pj2+tCmKLs0ZV7qNvGV4xuQNOpINkqV75Nc+NtD3jroYMhe+0So6sTTrTI+FvV0K3nRF
 FE0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uIC7dj7oltWe68l04x0L6fWnaqmGQcvXiQBbnnS12XU=;
 b=SqumNNtdyFDJSbeY8+VutUVf9jgWSSYX8z2Ump8E/4PJrRJzztIUdDvh3GAqHH0mQI
 O4hAFZu7PqMuW5UF1bhpH9HqcBVHG1bEn3oLpKimQZioZMtaKlZuyl1kRoJAx7FFDnFZ
 q/OcX7Icw1lEj2nIfBFUbeq214zuPwa21Csx4orvflpC7PR3IQJNVR5z6yEuF8a7STzi
 jdaqWVR18jC7vkojEbaSHINqjXCjQ7S3j9zgoZIKaNbppcvw6sE8V4RAaw8XJ4ddQDcX
 nLp41JgVFAMjHJzZd+A11KaBKUvHqOp8jO0D8c1ZXIjVq7+OtmqXyHNqPnqTO7wK7B/h
 miHA==
X-Gm-Message-State: AOAM531Nvlz9PUpjOURCH0DY+qLE/HY5AKMbD6Y+RRffUXemQk1Hz9NA
 kvr0HNvzlplVasYMkgrvQwrO1Q==
X-Google-Smtp-Source: ABdhPJzH81yvoV14kh0UBrupVwtAp8vc2BgwRUJ/AgiG5QgwEW8w4M550SI7tTEK9mrDCKojnPs7wA==
X-Received: by 2002:a1c:f612:: with SMTP id w18mr7636314wmc.47.1601549854655; 
 Thu, 01 Oct 2020 03:57:34 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id z13sm8267476wro.97.2020.10.01.03.57.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Oct 2020 03:57:33 -0700 (PDT)
Date: Thu, 1 Oct 2020 11:57:29 +0100
From: Andrew Scull <ascull@google.com>
To: George-Aurelian Popescu <georgepope@google.com>
Subject: Re: [PATCH 07/14] KVM: arm64: Enable UBSAN_BOUNDS for the both the
 kernel and hyp/nVHE
Message-ID: <20201001105729.GA632887@google.com>
References: <20200914172750.852684-1-georgepope@google.com>
 <20200914172750.852684-8-georgepope@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200914172750.852684-8-georgepope@google.com>
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

On Mon, Sep 14, 2020 at 05:27:43PM +0000, George-Aurelian Popescu wrote:
> From: George Popescu <georgepope@google.com>
> 
> If an out of bounds happens inside the hyp/nVHE code, the
> ubsan_out_of_bounds handler stores the logging data inside the
> kvm_ubsan_buffer. The one responsible for printing is the kernel
> ubsan_out_of_bounds handler. The process of decapsulating the data happens
> in kvm_ubsan_buffer.c.
> 
> The struct kvm_ubsan_info contains three main components:
> -enum type, which is used to identify which handler to call from the
> kernel.
> -struct ubsan_values, which stores the operands involved during the
> undefined behaviours, which can be one, two or zero, depending on what
> undefiend behaviour is reported. As an example for: out_of_bounds there
> is only one operand (the index).
> 
> Accessing a slot with no type should do nothing. Each slot is marked
> with the UBSAN_NONE tag after it's first usage.
> 
> Signed-off-by: George Popescu <georgepope@google.com>
> ---
>  arch/arm64/include/asm/kvm_ubsan.h | 19 ++++++++++++++++++-
>  arch/arm64/kvm/hyp/nvhe/ubsan.c    | 13 ++++++++++++-
>  arch/arm64/kvm/kvm_ubsan_buffer.c  | 13 ++++++++++++-
>  3 files changed, 42 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
> index af607a796376..575881e0bd5f 100644
> --- a/arch/arm64/include/asm/kvm_ubsan.h
> +++ b/arch/arm64/include/asm/kvm_ubsan.h
> @@ -11,7 +11,24 @@
>  #define UBSAN_MAX_TYPE 6
>  #define KVM_UBSAN_BUFFER_SIZE 1000
>  
> +struct ubsan_values {
> +	void *lval;
> +	void *rval;
> +	char op;
> +};
> +
>  struct kvm_ubsan_info {
> -	int type;
> +	enum {
> +		UBSAN_NONE,
> +		UBSAN_OUT_OF_BOUNDS
> +	} type;
> +	union {
> +		struct out_of_bounds_data out_of_bounds_data;
> +	};
> +	union {
> +		struct ubsan_values u_val;
> +	};
>  };
>  #endif
> +
> +void __ubsan_handle_out_of_bounds(void *_data, void *index);
> diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
> index a43c9646e1e8..b2d3404f6215 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ubsan.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
> @@ -43,7 +43,18 @@ void __ubsan_handle_type_mismatch(struct type_mismatch_data *data, void *ptr) {}
>  
>  void __ubsan_handle_type_mismatch_v1(void *_data, void *ptr) {}
>  
> -void __ubsan_handle_out_of_bounds(void *_data, void *index) {}
> +void __ubsan_handle_out_of_bounds(void *_data, void *index)
> +{
> +	struct kvm_ubsan_info *slot = NULL;
> +	struct out_of_bounds_data *data = _data;
> +
> +	slot = kvm_ubsan_buffer_next_slot();
> +	if (slot) {
> +		slot->type = UBSAN_OUT_OF_BOUNDS;
> +		slot->out_of_bounds_data = *data;
> +		slot->u_val.lval = index;
> +	}
> +}
>  
>  void __ubsan_handle_shift_out_of_bounds(void *_data, void *lhs, void *rhs) {}
>  
> diff --git a/arch/arm64/kvm/kvm_ubsan_buffer.c b/arch/arm64/kvm/kvm_ubsan_buffer.c
> index 28dcf19b5706..ce796bdd027e 100644
> --- a/arch/arm64/kvm/kvm_ubsan_buffer.c
> +++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
> @@ -16,6 +16,17 @@
>  
>  DECLARE_KVM_DEBUG_BUFFER(struct kvm_ubsan_info, kvm_ubsan_buff, KVM_UBSAN_BUFFER_SIZE);
>  
> +void __kvm_check_ubsan_data(struct kvm_ubsan_info *slot)
> +{
> +	switch (slot->type) {
> +	case UBSAN_NONE:
> +		break;
> +	case UBSAN_OUT_OF_BOUNDS:
> +		__ubsan_handle_out_of_bounds(&slot->out_of_bounds_data,
> +				slot->u_val.lval);
> +		break;
> +	}
> +}
>  
>  void __kvm_check_ubsan_buffer(void)
>  {
> @@ -25,7 +36,7 @@ void __kvm_check_ubsan_buffer(void)
>  
>  	init_kvm_debug_buffer(kvm_ubsan_buff, struct kvm_ubsan_info, slot, write_ind);
>  	for_each_kvm_debug_buffer_slot(slot, write_ind, it) {
> -		/* check ubsan data */
> +		__kvm_check_ubsan_data(slot);
>  		slot->type = 0;

0's called UBSAN_NONE now

>  	}
>  }
> -- 
> 2.28.0.618.gf4bc123cb7-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
