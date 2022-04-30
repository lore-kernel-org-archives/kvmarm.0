Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A21DC433EF
	for <kvmarm@archiver.kernel.org>; Sat, 30 Apr 2022 15:03:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E94704B1D1;
	Sat, 30 Apr 2022 11:03:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7yAYyDWVJ+IX; Sat, 30 Apr 2022 11:03:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C092E4B220;
	Sat, 30 Apr 2022 11:03:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B80E4B214
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 Apr 2022 11:03:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AbT7i2B0zQ7J for <kvmarm@lists.cs.columbia.edu>;
 Sat, 30 Apr 2022 11:03:41 -0400 (EDT)
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com
 [209.85.166.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 21CBB4B1D4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 Apr 2022 11:03:41 -0400 (EDT)
Received: by mail-il1-f173.google.com with SMTP id h11so1015668ila.5
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 Apr 2022 08:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=bN+KlP95Qh+8AzcCi+O6jrxnnkr4fpqjrAoo7JZUIrQ=;
 b=C6qrrrvEsqgjFf0tfTBiY7jTg89Sp2IS2uml7YJ6VowC8dsRhzZ/tCkleGdXdpmIe3
 bnwPgwQNjENrtPZ+7b77dZqd6+tThC3P4fVZc7B+gG9dSkZIv0rBGRfJgO39Xmrcyy0X
 U7D3aHufAIRj9Xe1NhyE+wd9bufDs7KsHRWXlEx8riPpWoXgPpwu3ICs/mpaZQCYcf4q
 F4jGI0lEmsprK9a2i2AaFf6V+6v8iVaXZISI5JOHrNAC2MV1L2K/v9Ej1j4l2ltdPOIu
 H4UPlfwV7dXiQJUyYdmOcjn0xXBpoUZmFnsUoVT35QINXgGsUDpe8P9LRIQquIhICFq2
 iwHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=bN+KlP95Qh+8AzcCi+O6jrxnnkr4fpqjrAoo7JZUIrQ=;
 b=lihKzNlFDyxbxizbhcaVrS84by/o3m1zbEVtql1BD8ka95iHJtC0/8N2oqLaO8EjVh
 rbCxXeEwginJ5WwlQzdvwREz12jko1qqAOOckwVpcrR3hu167TuTYfT5SzUlcNO2XGlM
 /3ZIBRD64LKnd1+mPIsiw4vQ8ysy072ERrYkl3a5TjCZ60JXqdZlG1ld6P3aerYxnCWS
 /7vrInMWqGj+4hHMiCLYO0tb+ceKzF3MAKK1DtLVPKjLOpta+h66wy9vfeCgcbVqNBXQ
 2ofZKErdxjsjuJK3jNbGvYPkTas6Vdmvovye1dzkD2T0ay1YGasesotsqv/K7Cys664t
 XvCg==
X-Gm-Message-State: AOAM530LC1j3AZ5DQ2NpB7Q3QYt0gYnTvs5wcRhi+G3fBIcYem2rIrtq
 5ySPjYQ/rW1Eu5vA487/ceugaA==
X-Google-Smtp-Source: ABdhPJyM5TByhnNMF+jWGfM3cRLjNBIHWo0ESp/jYAqpetPFRpUFDymt8/tMOtck9wvrr7VrV9KjLQ==
X-Received: by 2002:a05:6e02:1748:b0:2cd:a0ea:8ff4 with SMTP id
 y8-20020a056e02174800b002cda0ea8ff4mr1694967ill.269.1651331020330; 
 Sat, 30 Apr 2022 08:03:40 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 x18-20020a056602211200b0065a47e16f36sm679878iox.8.2022.04.30.08.03.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 30 Apr 2022 08:03:39 -0700 (PDT)
Date: Sat, 30 Apr 2022 15:03:36 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 06/18] KVM: arm64: Support SDEI_EVENT_CONTEXT hypercall
Message-ID: <Ym1PyIQY4m4/9IVi@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <20220403153911.12332-7-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220403153911.12332-7-gshan@redhat.com>
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Sun, Apr 03, 2022 at 11:38:59PM +0800, Gavin Shan wrote:
> This supports SDEI_EVENT_CONTEXT hypercall. It's used by the guest
> to retrieve the registers (x0 - x17) from the interrupted or preempted
> context in the event handler. The interrupted or preempted context
> is saved prior to handling the event by executing its handler and
> restored after that.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/sdei.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index 941263578b30..af5d11b8eb2f 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -140,6 +140,37 @@ static unsigned long hypercall_enable(struct kvm_vcpu *vcpu, bool enable)
>  	return ret;
>  }
>  
> +static unsigned long hypercall_context(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +	struct kvm_sdei_vcpu_context *context;
> +	unsigned long param_id = smccc_get_arg(vcpu, 1);
> +	unsigned long ret = SDEI_SUCCESS;
> +
> +	spin_lock(&vsdei->lock);
> +
> +	/* Check if we have events are being handled */
> +	context = &vsdei->context[SDEI_EVENT_PRIORITY_CRITICAL];
> +	context = context->event ? context : NULL;
> +	context = context ? : &vsdei->context[SDEI_EVENT_PRIORITY_NORMAL];
> +	context = context->event ? context : NULL;
> +	if (!context) {
> +		ret = SDEI_DENIED;
> +		goto unlock;
> +	}

Eek! You'll probably be able to drop all of this and just check the SDEI
active flag.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
