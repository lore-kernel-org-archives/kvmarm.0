Return-Path: <SRS0=/m9d=NY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F975C432BE
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 13:21:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0F59B60EE3
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 13:21:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0F59B60EE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 749C64B105;
	Thu,  2 Sep 2021 09:21:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QMwJP6S234Yg; Thu,  2 Sep 2021 09:21:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BDB44B11A;
	Thu,  2 Sep 2021 09:21:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2572B4B105
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 09:21:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xy-QutPRgBud for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Sep 2021 09:21:20 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40FDD4B137
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 09:21:20 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1630588880;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=6tJf5xIvKDCnRwuvzEhUuuc4fd9eQkxx1PjNi93Vu3s=;
 b=WU7aG3r64Z0LaItlhnEJiRXnyJk92uI5GC1C9Xd4MZ2Iz3X3uD1IlRbqXhGV0takvDjA87
 3Nc+hV75Unat26IumsmgLUGgS5eodGTVrRojbn7a9e4YF61PaEZAvfweLDVNKaq1uBOVwk
 xxCHuftdxtWh9IEwT5+P8K00XxjukQU=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-7z3bAJNgP9epjY8KW5mGOg-1; Thu, 02 Sep 2021 09:21:17 -0400
X-MC-Unique: 7z3bAJNgP9epjY8KW5mGOg-1
Received: by mail-qv1-f71.google.com with SMTP id
 jz9-20020a0562140e6900b0037795ee01abso1504219qvb.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Sep 2021 06:21:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=6tJf5xIvKDCnRwuvzEhUuuc4fd9eQkxx1PjNi93Vu3s=;
 b=jZ/KfVKNiTI1/dorbm9Col9azpOs4VsIWdHwVeDQe5WGlsQnqsM708nR6epUsrMnJE
 7tmw+g41pXZqr7JTkXF9smgdP0/1DPxein0BRwPc+ez19t2auyDc97D1atiECzp+aIZW
 aGj7K1/zrl9Co9+WvWcHDy1I53AiL4HO8hUkeAc2c4kZo2/3Q7swbw2Ot1zax0LJLPAE
 gTMLwjicJWxvmu+2BgfQ3TjdUJvi0d5pTHMGOTE7HaylnBdvCBPheGu+buXhRxM8kPzL
 4NIZNM+rgn1jHuQCI0bbaj3R9UmIpTpu+UB2vrhFFaCi9Iybpz5YBOxqD4zqX1OrxVhj
 KJjg==
X-Gm-Message-State: AOAM533G91s71lQLc8sE0dIvhohj82cJIUYEAVEmFn4M7im2uPCNhq5o
 q5YNzzD1fdR3qnrAqdb/XnjCVLZLDnj+utH+v1sKkE3Idb6HBjJvHpv3BMNh51Mkcsn0cMPaDh4
 S7WNUgcME29wGJhOW9jxGDzAU
X-Received: by 2002:ad4:562c:: with SMTP id cb12mr1587973qvb.6.1630588877116; 
 Thu, 02 Sep 2021 06:21:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxG9JfvU8t2EsYROxxRPXPNKTs00M8PoYMUrrQVfghePFKxWKnhmt6JBf3fCTGn9rsZbouzrg==
X-Received: by 2002:ad4:562c:: with SMTP id cb12mr1587947qvb.6.1630588876898; 
 Thu, 02 Sep 2021 06:21:16 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id g8sm1319814qkm.25.2021.09.02.06.21.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Sep 2021 06:21:16 -0700 (PDT)
Date: Thu, 2 Sep 2021 15:21:12 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 01/12] KVM: arm64: selftests: Add MMIO readl/writel
 support
Message-ID: <20210902132112.yyz7iiqims3nlmmi@gator>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-2-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20210901211412.4171835-2-rananta@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
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

On Wed, Sep 01, 2021 at 09:14:01PM +0000, Raghavendra Rao Ananta wrote:
> Define the readl() and writel() functions for the guests to
> access (4-byte) the MMIO region.
> 
> The routines, and their dependents, are inspired from the kernel's
> arch/arm64/include/asm/io.h and arch/arm64/include/asm/barrier.h.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h | 45 ++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index c0273aefa63d..3cbaf5c1e26b 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -130,6 +130,49 @@ void vm_install_sync_handler(struct kvm_vm *vm,
>  	val;								  \
>  })
>  
> -#define isb()	asm volatile("isb" : : : "memory")
> +#define isb()		asm volatile("isb" : : : "memory")
> +#define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
> +#define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
> +
> +#define dma_wmb()	dmb(oshst)
> +#define __iowmb()	dma_wmb()
> +
> +#define dma_rmb()	dmb(oshld)
> +
> +#define __iormb(v)							\
> +({									\
> +	unsigned long tmp;						\
> +									\
> +	dma_rmb();							\
> +									\
> +	/*								\
> +	 * Courtesy of arch/arm64/include/asm/io.h:			\
> +	 * Create a dummy control dependency from the IO read to any	\
> +	 * later instructions. This ensures that a subsequent call	\
> +	 * to udelay() will be ordered due to the ISB in __delay().	\

We don't have udelay or __delay yet, but I assume they're coming soon.

> +	 */								\
> +	asm volatile("eor	%0, %1, %1\n"				\
> +		     "cbnz	%0, ."					\
> +		     : "=r" (tmp) : "r" ((unsigned long)(v))		\
> +		     : "memory");					\
> +})
> +
> +static __always_inline void __raw_writel(u32 val, volatile void *addr)
> +{
> +	asm volatile("str %w0, [%1]" : : "rZ" (val), "r" (addr));
> +}
> +
> +static __always_inline u32 __raw_readl(const volatile void *addr)
> +{
> +	u32 val;
> +	asm volatile("ldr %w0, [%1]" : "=r" (val) : "r" (addr));
> +	return val;
> +}
> +
> +#define writel_relaxed(v,c)	((void)__raw_writel((__force u32)cpu_to_le32(v),(c)))
> +#define readl_relaxed(c)	({ u32 __r = le32_to_cpu((__force __le32)__raw_readl(c)); __r; })

Might want to explicitly include linux/types.h for these __force symbols.

> +
> +#define writel(v,c)		({ __iowmb(); writel_relaxed((v),(c));})
> +#define readl(c)		({ u32 __v = readl_relaxed(c); __iormb(__v); __v; })
>  
>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> -- 
> 2.33.0.153.gba50c8fa24-goog


Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
