Return-Path: <SRS0=uZLN=NX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F2BC432BE
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 21:23:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8D0D760FDC
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 21:23:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8D0D760FDC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A9C24B190;
	Wed,  1 Sep 2021 17:23:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0pa5VPix21t9; Wed,  1 Sep 2021 17:23:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AA9D4B104;
	Wed,  1 Sep 2021 17:23:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C90DA4B0FC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 17:23:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4+7JAKzHqgBJ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Sep 2021 17:23:30 -0400 (EDT)
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com
 [209.85.166.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F10B54B0DF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 17:23:29 -0400 (EDT)
Received: by mail-il1-f171.google.com with SMTP id v16so705293ilo.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Sep 2021 14:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=U3KFrpxU4d2fmsa0Mn7hWzZCFQgA1sH9j0f2Swqi3I4=;
 b=fRlBbRG00Jqh6wY8ay/vacNRJwhJuS8FG/s1/thQukVdCQCJZlOxZIPolWunH7C2aS
 akm7SCr0nYZMueozliPX04kjQ92ewCY0fr31acSvPe1QwCKnJCvV1jwaL0tMxKpEVxXy
 eI48fILum/Et8BgE8VkMExuJkjWvZcaUeP5lNHCm2rhQrDTujESJAzUdlAvLZgnYpI3q
 EGr23r8la80yjaBNhhUmog5qndDRkCqe8kDmXOEP8OzSm4v6/MqhrlrTMKGOq1MCr6tH
 4YLtyc5X2l5XKqzojqkHgqdXzoz41yjcj9Z5WLNn9001mORzWwl5LchRCco5+T+7dEvp
 aNUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=U3KFrpxU4d2fmsa0Mn7hWzZCFQgA1sH9j0f2Swqi3I4=;
 b=ArfNBLkQokQWa9mEzT/4PQqtGscOJtvR3i06dODbZ/76h6nVEJI/m9MoliFNYIsVW6
 KwRwfibqpXTQJPOfLUdUirAydAVgTaMVWOFwZfNwNzhd9IgTb7ICppjikj43LTzSY9Cx
 a40dzkiePe3qwF+lwWIDAsTMmSlP2tXrlvBYlUNL5kPLXM6soDg8hl8tj7ubkC/c7U6/
 KlokP+FqwxUevK9V8HQrLUicMTSHUc+MRUM8RAjVNagzjE4eY5ndh9Pf6v4wXg+Y0Vt7
 WLKz+qpObujNqBWVd68DnWhgzTzHNhswCXpKIGMk/RBPXpzdqRe8gqDJEaN6ONhEZhm5
 1Oiw==
X-Gm-Message-State: AOAM530/QwdV6KE1VywAnEVQNIOrHaIZs4iXUqy19JjGvnyhTlRhZrun
 P5H1p5ZSu/+5Kdb0R67nVkrzdw==
X-Google-Smtp-Source: ABdhPJziw+f4QRZL4Kpj7Ibv9UlaRalcjNo2GmF90sZI6p2noJaakA4if8ogq5yuBsRPfvxTChZhRQ==
X-Received: by 2002:a05:6e02:531:: with SMTP id
 h17mr1051378ils.288.1630531409092; 
 Wed, 01 Sep 2021 14:23:29 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id k21sm443809ioh.38.2021.09.01.14.23.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Sep 2021 14:23:28 -0700 (PDT)
Date: Wed, 1 Sep 2021 21:23:25 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 01/12] KVM: arm64: selftests: Add MMIO readl/writel
 support
Message-ID: <YS/vTVPi7Iam+ZXX@google.com>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-2-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-2-rananta@google.com>
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

Is this a stray diff?

Otherwise:

Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
