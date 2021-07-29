Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE697C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 20:29:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 14D1860F4A
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 20:29:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 14D1860F4A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 713D24B0D3;
	Thu, 29 Jul 2021 16:29:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iKdas9pat4J5; Thu, 29 Jul 2021 16:29:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 689C64B09B;
	Thu, 29 Jul 2021 16:29:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 873C14B0C5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 14:15:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e8la-b3pK6AT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 14:15:33 -0400 (EDT)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2A2324B0B2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 14:15:33 -0400 (EDT)
Received: by mail-pj1-f44.google.com with SMTP id
 ds11-20020a17090b08cbb0290172f971883bso16999288pjb.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 11:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=1VgSvIUg18Pmu6bXQr/jLLZHZW93wmUUl7jcbNMrRlE=;
 b=c7Xg5u/SFv0fecvDSkWBz6Or6adxwzBui7Dq/4a59U/xMEjg8w8P/kAEQXWhvAovjQ
 mih0wxsqaaPUB38HpOf6y50jYJ1C6e8XQM9falOaY4Fd0q17yJ/nhIkfIDEuzVcsxbRz
 kvROAVdZuCjR8xG4APDxgAbdiPartFPWfak43cWy4fPI+1UJB5FUXt+eLbQsvvXBFlfp
 B4KDcEVK3fIjhSOHocLlUFwNxs/i6Dp7v1xyvKf9Drcyw2B00s539e59q+vyeXJnKl6W
 O1sHXA7YJOKy+Vsb8WiCC5HtnjMZRby+Aq/UMM4dG8IMO5uDH8jNlPd1eWPoHzr0e+QL
 ppyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=1VgSvIUg18Pmu6bXQr/jLLZHZW93wmUUl7jcbNMrRlE=;
 b=s/uwhBDzhHzTI+gMRVVfRZIMNcezjfIECUDzZqUtx/tKCz47ybv65M9Dle5zMKoISO
 DD1trBLB+SHf1RxWQsbiMGEZLMJc4dZo10fzbubzefekxrwbZ7vO627+2NgOv20Lc/P6
 4380YqfvrNXM7QPiezf5pC73DhCoNU4lbwkecZdhsvlJ6+Vs4nhJxS2qVbQ7UMlhFOCc
 6WjXc4QyQ8cqmePACLdG5Xfnm5G5GSWuV/hkM+dA0UnDfuY0q5corP71MZY5rn6sfyoD
 dmR9qYbO4d0Z20gdAK2yItCWHdc4+OB9y5F39jiewkaMx7x4Gf/gIEk6+dw+ew4Heb42
 UNiw==
X-Gm-Message-State: AOAM533XiMa5ayEwB2uLEzUSCbnyC2Yf+CQJdwJCzgnLB8II2aoYhqUJ
 +B+8Sl6uhasB94j2PVhrtVxRrQ==
X-Google-Smtp-Source: ABdhPJxeL54Xfvacu7ArTo3B5iH93qHeEnG4cdgRdD0aAvS5WWEXUwctrS4C2oSGWKL/TIsmgOIT0A==
X-Received: by 2002:a17:902:c402:b029:12b:5175:1ddd with SMTP id
 k2-20020a170902c402b029012b51751dddmr5870494plk.67.1627582531986; 
 Thu, 29 Jul 2021 11:15:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id i8sm4638520pfk.18.2021.07.29.11.15.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 29 Jul 2021 11:15:31 -0700 (PDT)
Date: Thu, 29 Jul 2021 18:15:27 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v4 3/6] KVM: selftests: Introduce UCALL_UNHANDLED for
 unhandled vector reporting
Message-ID: <YQLwP9T4hevAqa7w@google.com>
References: <20210611011020.3420067-1-ricarkol@google.com>
 <20210611011020.3420067-4-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210611011020.3420067-4-ricarkol@google.com>
X-Mailman-Approved-At: Thu, 29 Jul 2021 16:29:47 -0400
Cc: kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
 vkuznets@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Thu, Jun 10, 2021, Ricardo Koller wrote:
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index fcd8e3855111..beb76d6deaa9 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -349,6 +349,7 @@ enum {
>  	UCALL_SYNC,
>  	UCALL_ABORT,
>  	UCALL_DONE,
> +	UCALL_UNHANDLED,
>  };

...

> @@ -1254,16 +1254,13 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
>  
>  void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
>  {
> -	if (vcpu_state(vm, vcpuid)->exit_reason == KVM_EXIT_IO
> -		&& vcpu_state(vm, vcpuid)->io.port == UNEXPECTED_VECTOR_PORT
> -		&& vcpu_state(vm, vcpuid)->io.size == 4) {
> -		/* Grab pointer to io data */
> -		uint32_t *data = (void *)vcpu_state(vm, vcpuid)
> -			+ vcpu_state(vm, vcpuid)->io.data_offset;
> -
> -		TEST_ASSERT(false,
> -			    "Unexpected vectored event in guest (vector:0x%x)",
> -			    *data);
> +	struct ucall uc;
> +
> +	if (get_ucall(vm, vcpuid, &uc) == UCALL_UNHANDLED) {

UCALL_UNHANDLED is a bit of an odd name.  Without the surrounding context, I would
have no idea that it's referring to an unhandled event, e.g. my gut reaction would
be that it means the ucall itself was unhandled.  Maybe UCALL_UNHANDLED_EVENT?
It's rather long, but I don't think that will be problematic for any of the code.


> +		uint64_t vector = uc.args[0];
> +
> +		TEST_FAIL("Unexpected vectored event in guest (vector:0x%lx)",
> +			  vector);
>  	}
>  }
>  
> -- 
> 2.32.0.272.g935e593368-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
