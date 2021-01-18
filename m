Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56909C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 11:06:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B0F4C221F8
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 11:06:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B0F4C221F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B0A54B26B;
	Mon, 18 Jan 2021 06:06:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GKFs-77rm9o6; Mon, 18 Jan 2021 06:06:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 562844B26D;
	Mon, 18 Jan 2021 06:06:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4F874B269
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 06:06:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GHkgmHlbF4PK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 06:06:44 -0500 (EST)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
 [209.85.221.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C17784B265
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 06:06:44 -0500 (EST)
Received: by mail-wr1-f46.google.com with SMTP id v15so12374385wrx.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 03:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=NnBFT8EP9V7MmU84deKSaC5Ci7/3yuRujoqea2uYBqU=;
 b=S0v70/XeJSnyzyiifqGs12j42+wMyVfdZmFp9vAYkXCvNspcgkhHm/aAnQRXxVKwXn
 xMc//0tppKYCReKyia6kMXMXxqRWsrWfKSwZ+LPj8fybmUm1d6i1vYA87dayQ08MyOUc
 0p6Akb3D1OU7oM6tdHFfjG3TkuwOE22g9Eqvgr8tCeZ9J9ESNatB5rJHEaL49J/XzUYf
 qe/5UI+KoiKw5ugbwxf6Dph+sNadI0zgVCRMqckEhTL5F2NEWen6hNvI4IiTIZ5yzVvT
 ko0skt3XiUtvAqGdh6+/oV51WMeZ7c1SEhK/K0YPo731oBI195bJhJXW106wUlun6yJy
 2TKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=NnBFT8EP9V7MmU84deKSaC5Ci7/3yuRujoqea2uYBqU=;
 b=WTyM3mQzKm2VH6fRRHluMOGsL1x5fBbZdZKug6wedfnfwL+y156xFNIwzbPfFPy1KI
 xHsTaHXLcvTh5SVtuuiEbqGoxkJgQGg1wsxp7U5lFI1SMaq0lXJdRgftudxfNJIwUvPs
 jdzJ1o243oKhFy8tGeOvs7Bg1mvBaW5Jpjzt2IZMN8poowE4Gx1Ss3dr6LsOGID9NnPG
 nLxKM+9HNZg+F73amowc3NwlhBaL42/UzZUOcu0xdAWG1oXjG4avPrsvOLb8FKq+pwX2
 u4H4YmBbWgE1NDRTtUdOjZd5PYRNjHPQalp/I09FKVbOZXOzeXQ7Mh6tCWHXJu1pLk+A
 Npnw==
X-Gm-Message-State: AOAM531ayyZu6xs8BC7Z+051hGeuWaPsERuDW/PjbYCV7tkyT6e9p764
 lBesvkHEN6i5bUyCU/SIQ6qUCg==
X-Google-Smtp-Source: ABdhPJwWGXCEWcvWmyWLYTOB7DQ3+9c+Y1HcC/heAJVGshcFFa64ZS5RxK5AbQjre5wgJBvYLRmsBQ==
X-Received: by 2002:a5d:40ce:: with SMTP id b14mr24876133wrq.350.1610968003510; 
 Mon, 18 Jan 2021 03:06:43 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:3d4d:985d:87b7:4d55])
 by smtp.gmail.com with ESMTPSA id g1sm29961893wrq.30.2021.01.18.03.06.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Jan 2021 03:06:42 -0800 (PST)
Date: Mon, 18 Jan 2021 11:06:41 +0000
From: David Brazdil <dbrazdil@google.com>
To: Elena Petrova <lenaptr@google.com>
Subject: Re: [PATCH v3 3/9] KVM: arm64: Enable UBSAN_BOUNDS for the both the
 kernel and hyp/nVHE
Message-ID: <20210118110641.ak4jlzu34lxzluzy@google.com>
References: <20210115171830.3602110-1-lenaptr@google.com>
 <20210115171830.3602110-4-lenaptr@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210115171830.3602110-4-lenaptr@google.com>
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

On Fri, Jan 15, 2021 at 05:18:24PM +0000, Elena Petrova wrote:
> From: George Popescu <georgepope@google.com>
> 
> If an out of bounds happens inside the hyp/nVHE code, the ubsan_out_of_bounds
> handler stores the logging data inside the kvm_ubsan_buffer. The one responsible
> for printing is the kernel ubsan_out_of_bounds handler. The process of
> decapsulating the data from the buffer is straightforward.
> 
> Signed-off-by: George Popescu <georgepope@google.com>
> Signed-off-by: Elena Petrova <lenaptr@google.com>
> ---
>  arch/arm64/include/asm/kvm_ubsan.h | 19 ++++++++++++++++++-
>  arch/arm64/kvm/hyp/nvhe/ubsan.c    | 14 ++++++++++++--
>  arch/arm64/kvm/kvm_ubsan_buffer.c  | 10 ++++++++++
>  3 files changed, 40 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_ubsan.h b/arch/arm64/include/asm/kvm_ubsan.h
> index fb32c7fd65d4..4f471acb88b0 100644
> --- a/arch/arm64/include/asm/kvm_ubsan.h
> +++ b/arch/arm64/include/asm/kvm_ubsan.h
> @@ -9,6 +9,23 @@
>  #define UBSAN_MAX_TYPE 6
>  #define KVM_UBSAN_BUFFER_SIZE 1000
>  
> +
> +struct ubsan_values {
> +	void *lval;
> +	void *rval;
> +	char op;
> +};
> +
>  struct kvm_ubsan_info {
> -	int type;
> +	enum {
> +		UBSAN_OUT_OF_BOUNDS,
> +	} type;
> +	union {
> +		struct out_of_bounds_data out_of_bounds_data;
> +	};
> +	union {
> +		struct ubsan_values u_val;
> +	};

I don't see this second union having more members later in the series.
Remove it? Even the 'struct ubsan_values' seems redundant and we could just
have those three fields directly here.

>  };
> +
> +void __ubsan_handle_out_of_bounds(void *_data, void *index);
> diff --git a/arch/arm64/kvm/hyp/nvhe/ubsan.c b/arch/arm64/kvm/hyp/nvhe/ubsan.c
> index 8a194fb1f6cf..55a8f6db8555 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ubsan.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ubsan.c
> @@ -13,7 +13,6 @@
>  #include <asm/kvm_ubsan.h>
>  #include <asm/kvm_debug_buffer.h>
>  #include <kvm/arm_pmu.h>
> -#include <ubsan.h>
>  
>  DEFINE_KVM_DEBUG_BUFFER(struct kvm_ubsan_info, kvm_ubsan_buffer,
>                  kvm_ubsan_buff_wr_ind, KVM_UBSAN_BUFFER_SIZE);
> @@ -44,7 +43,18 @@ void __ubsan_handle_type_mismatch(struct type_mismatch_data *data, void *ptr) {}
>  
>  void __ubsan_handle_type_mismatch_v1(void *_data, void *ptr) {}
>  
> -void __ubsan_handle_out_of_bounds(void *_data, void *index) {}
> +void __ubsan_handle_out_of_bounds(void *_data, void *index)
> +{
> +	struct kvm_ubsan_info *slot;
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
> index 4a1959ba9f68..a1523f86be3c 100644
> --- a/arch/arm64/kvm/kvm_ubsan_buffer.c
> +++ b/arch/arm64/kvm/kvm_ubsan_buffer.c
> @@ -17,6 +17,15 @@
>  DECLARE_KVM_DEBUG_BUFFER(struct kvm_ubsan_info, kvm_ubsan_buffer,
>  		kvm_ubsan_buff_wr_ind, KVM_UBSAN_BUFFER_SIZE);
>  
> +void __kvm_check_ubsan_data(struct kvm_ubsan_info *slot)
> +{
> +	switch (slot->type) {
> +	case UBSAN_OUT_OF_BOUNDS:
> +		__ubsan_handle_out_of_bounds(&slot->out_of_bounds_data,
> +				slot->u_val.lval);
> +		break;
> +	}
> +}
>  
>  void iterate_kvm_ubsan_buffer(unsigned long left, unsigned long right)
>  {
> @@ -26,6 +35,7 @@ void iterate_kvm_ubsan_buffer(unsigned long left, unsigned long right)
>  	slot = (struct kvm_ubsan_info *) this_cpu_ptr_nvhe_sym(kvm_ubsan_buffer);
>  	for (i = left; i < right; ++i) {
>  		/* check ubsan data */
> +		__kvm_check_ubsan_data(slot + i);

Not sure why this is breaking out into another function. The code will not
be shared with any other user.

>  		slot[i].type = 0;

This invalidation is redundant. The buffer's cursor will be reset on next
hypercall, which will implicitly invalidate all entries.

>  	}
>  }
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
