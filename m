Return-Path: <SRS0=uZLN=NX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A36C432BE
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 21:29:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4F56861054
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 21:29:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4F56861054
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D634C4B129;
	Wed,  1 Sep 2021 17:29:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ouwsWKX5LETO; Wed,  1 Sep 2021 17:29:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07F4E4B134;
	Wed,  1 Sep 2021 17:29:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 240D44B12F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 17:29:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EOz3qXNsjaTq for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Sep 2021 17:29:43 -0400 (EDT)
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com
 [209.85.166.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F9614B129
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 17:29:43 -0400 (EDT)
Received: by mail-io1-f42.google.com with SMTP id g9so976454ioq.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Sep 2021 14:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=KGjRFCzfFxSnSrNaojtITxfWpjAOQrO+uEsac7dWTTA=;
 b=qjLS/Lwo+l0y/xWgb9Yqx3gwHHIqKU/h+4CZY2e91pjpHo2fM2km+R+Aq1kPhbzrnZ
 9qQlZ6aVuw/V8/m7LWoa9oAT13KmdbzLWMNmSSSK1j+h8xUuBVM3U75RfhDXnSCLx56l
 e50E1QwY4UL8edEAGNbUGfdr70SvdMu3IPDdZkNiQHr+/mypm6nHNYFwljYmDPTznfY6
 CAdSB9tO3n2qGOn4DB8Zi0LQ1+0R1iPSeFN/+weC7GkYwQede6i4CDzK8ATXfeahkA/b
 7rKQEF2qEPrKFEaL6vftzbbGLeCOo2drtmjnuxEOup5KXei3+jcr/OWCRJCHnHicLRIJ
 Rzyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=KGjRFCzfFxSnSrNaojtITxfWpjAOQrO+uEsac7dWTTA=;
 b=Tgo2M5pWSWa4LrwObzYQKLYLkWlUGjpwI0bocsqF6B9ut+pKOgDpH5XDj0CkBm8lCO
 6MJAij094FHuwM70WxyHWM7a3jTAxmKmcCqercqxtoC6Q/QaPX9NKsjTIooeYnNIQybx
 mrFOgDZJ8p1wBrpUiYlN9YdNPNCbX9oN2WIessVIheBZZDuXsGjqoFSwTDel32n2HMSf
 6WYTft+QwRpW/b3zsS5HhknlJxU3aZRooJA5oLtxl3AGkH4u9joNlSd7D9WEhbP8DMX9
 w0bVoQly+6qunes12SPUG3QjagmmmD1ZzkYjMr0jCYBscj4dbIQx2IUyRw/qAXH0zed+
 ZZig==
X-Gm-Message-State: AOAM533XEghJELEbFEhQEi222XoUtU/TuzX6nGZzuPTPHZNsbPzZKJUu
 n28S1RI0QjL2vvRwoaTiGh36vQ==
X-Google-Smtp-Source: ABdhPJwpRXLaA5TjrnDxM/2gBhOTGH/MNrIduQT/kt54RpISuyy9Ge37m9qgVMQ0ILHqKPUEOUwsTw==
X-Received: by 2002:a02:908a:: with SMTP id x10mr1409251jaf.30.1630531782445; 
 Wed, 01 Sep 2021 14:29:42 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id g12sm416700iok.32.2021.09.01.14.29.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Sep 2021 14:29:41 -0700 (PDT)
Date: Wed, 1 Sep 2021 21:29:38 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 03/12] KVM: arm64: selftests: Add support for cpu_relax
Message-ID: <YS/wwkZu4lfqtmYx@google.com>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-4-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-4-rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Wed, Sep 01, 2021 at 09:14:03PM +0000, Raghavendra Rao Ananta wrote:
> Implement the guest helper routine, cpu_relax(), to yield
> the processor to other tasks.
> 
> The function was derived from
> arch/arm64/include/asm/vdso/processor.h.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  tools/testing/selftests/kvm/include/aarch64/processor.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 082cc97ad8d3..78df059dc974 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -191,6 +191,11 @@ asm(
>  	val;								  \
>  })
>  
> +static inline void cpu_relax(void)
> +{
> +	asm volatile("yield" ::: "memory");
> +}
> +
>  #define isb()		asm volatile("isb" : : : "memory")
>  #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
>  #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
