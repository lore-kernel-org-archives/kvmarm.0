Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C408DC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 12:02:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2430A4B287;
	Thu, 16 Jun 2022 08:02:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z6Vbn1VJJwZo; Thu, 16 Jun 2022 08:02:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFA114B28B;
	Thu, 16 Jun 2022 08:02:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F30174B250
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 08:02:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Io2q8cQKiHF9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 08:02:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA7DF4B25D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 08:02:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655380959;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=a1YqFst/wCS3dV9U1tom4IUI5FqJmZTxEQ7sGvmyW7Q=;
 b=Yh2TVVS9fMyv+cLj92t6L4ilWN0TjeRdBV1U/55reCcIExqUCNVeJQ0J1gvwx2Wyb3cSYr
 Sp7N/uZXYTCKA9N4BSxSfIzM+DVvkjdiyKmAKd8CJFYIoRDcwiGVUun80N/lwoabQi3GOE
 xfz8kpAZqbBXYKfRz4wiQ/B/BL+bjO8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-8e0LGArSPRmvOf0ikWZpow-1; Thu, 16 Jun 2022 08:02:36 -0400
X-MC-Unique: 8e0LGArSPRmvOf0ikWZpow-1
Received: by mail-ed1-f69.google.com with SMTP id
 y13-20020a056402358d00b0042dfb820070so1119269edc.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 05:02:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=a1YqFst/wCS3dV9U1tom4IUI5FqJmZTxEQ7sGvmyW7Q=;
 b=VI4O5ggIY8zw4WFqs07NF5zeb4k2EbiDbP09O2J74gQKzexLqag3/qsAI8wd/V4q0E
 X0KmyfJFOmQF9qbBt/9jDnDo9R1BN9uYex5LXe2RtAx5fbDpjnQElaXYrDpc24qfjvOn
 0aGe6YcBct5gZGQqgU4T4fPkWPm1fTVup1SN/4vJHAxMCdYTraZdgMd5508AgDdkp3IZ
 bFYl8FfeF4GLwXz0TFF6MaCcHiVaVHGuQuQ2VxCjeioTgknrg5QbY404lzq5m4ICHPU6
 EaB+LOqlfXY/CaLLgbyC0Fc5MgV2u7kjxFGzG/yftYGhEYIBpjWw1d+qYS5RJMalsHCe
 /8sw==
X-Gm-Message-State: AJIora9/x6tq5Y0O76nfV3A5o13/aWmMoi5cTQnXvvMXJNFQ8qJDgzjB
 Oiiq7dNGl3jUectKJHeS6CoRKAmrkXvC5Jr5JKy2gn/dHTJcRng/DC6Mve0r7HGZ3yp2U1Y9m/R
 FnsqoicROXgHkGftlrcX7Ncbo
X-Received: by 2002:a17:906:7489:b0:712:2a98:d36 with SMTP id
 e9-20020a170906748900b007122a980d36mr4185837ejl.340.1655380955126; 
 Thu, 16 Jun 2022 05:02:35 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sEH/in2gBn+9ByhlZfqVmDXWc4YuaZczo9onOWmlO+Y4/lrgYkHIWOHfH8wVylG+qd74/UKg==
X-Received: by 2002:a17:906:7489:b0:712:2a98:d36 with SMTP id
 e9-20020a170906748900b007122a980d36mr4185795ejl.340.1655380954888; 
 Thu, 16 Jun 2022 05:02:34 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
 by smtp.gmail.com with ESMTPSA id
 u22-20020a17090617d600b006f3ef214dc0sm709130eje.38.2022.06.16.05.02.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Jun 2022 05:02:34 -0700 (PDT)
Date: Thu, 16 Jun 2022 14:02:32 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH] selftests: KVM: Handle compiler optimizations in ucall
Message-ID: <20220616120232.ctkekviusrozqpru@gator>
References: <20220615185706.1099208-1-rananta@google.com>
MIME-Version: 1.0
In-Reply-To: <20220615185706.1099208-1-rananta@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>,
 linux-kselftest@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

On Wed, Jun 15, 2022 at 06:57:06PM +0000, Raghavendra Rao Ananta wrote:
> The selftests, when built with newer versions of clang, is found
> to have over optimized guests' ucall() function, and eliminating
> the stores for uc.cmd (perhaps due to no immediate readers). This
> resulted in the userspace side always reading a value of '0', and
> causing multiple test failures.
> 
> As a result, prevent the compiler from optimizing the stores in
> ucall() with WRITE_ONCE().
> 
> Suggested-by: Ricardo Koller <ricarkol@google.com>
> Suggested-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/testing/selftests/kvm/lib/aarch64/ucall.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> index e0b0164e9af8..be1d9728c4ce 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
> @@ -73,20 +73,19 @@ void ucall_uninit(struct kvm_vm *vm)
>  
>  void ucall(uint64_t cmd, int nargs, ...)
>  {
> -	struct ucall uc = {
> -		.cmd = cmd,
> -	};
> +	struct ucall uc = {};
>  	va_list va;
>  	int i;
>  
> +	WRITE_ONCE(uc.cmd, cmd);
>  	nargs = nargs <= UCALL_MAX_ARGS ? nargs : UCALL_MAX_ARGS;
>  
>  	va_start(va, nargs);
>  	for (i = 0; i < nargs; ++i)
> -		uc.args[i] = va_arg(va, uint64_t);
> +		WRITE_ONCE(uc.args[i], va_arg(va, uint64_t));
>  	va_end(va);
>  
> -	*ucall_exit_mmio_addr = (vm_vaddr_t)&uc;
> +	WRITE_ONCE(*ucall_exit_mmio_addr, (vm_vaddr_t)&uc);
>  }
>  
>  uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
> -- 
> 2.36.1.476.g0c4daa206d-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
