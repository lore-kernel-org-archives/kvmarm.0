Return-Path: <SRS0=g2+W=L5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7390FC07E99
	for <kvmarm@archiver.kernel.org>; Mon,  5 Jul 2021 10:18:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E49AB60200
	for <kvmarm@archiver.kernel.org>; Mon,  5 Jul 2021 10:18:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E49AB60200
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 426B24A483;
	Mon,  5 Jul 2021 06:18:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CAxtle1nd4bo; Mon,  5 Jul 2021 06:18:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BAAA409DD;
	Mon,  5 Jul 2021 06:18:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FB0E40623
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jul 2021 05:57:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LY8sQZKpjvaq for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Jul 2021 05:57:22 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 462E140629
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jul 2021 05:57:22 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1625479042;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=TT9vJEoaVxuLffb3JgMy8FhvtJ+ac7w2RFyRIaNwv0E=;
 b=EQk31/jtj/S4gbxeTCTXa5LwylM2UACmkOjXvBTOSLHU2NCWRzo6umeT7I0z+fahZ/ll3O
 mGQu4CQi6YbUFXSaiu0IT2Yfwb0WXVeW4/wCg49sO+6m6uWqAd3cZ/FyWwFr3itcfdkoAO
 mD4IYXYXAhLsiYKtl6vr7Su7SpkqJpQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-1-AkCN0WNWaBB9zR0286ng-1; Mon, 05 Jul 2021 05:57:20 -0400
X-MC-Unique: 1-AkCN0WNWaBB9zR0286ng-1
Received: by mail-wm1-f70.google.com with SMTP id
 p3-20020a05600c3583b02901f55d71e34aso4664067wmq.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 05 Jul 2021 02:57:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=TT9vJEoaVxuLffb3JgMy8FhvtJ+ac7w2RFyRIaNwv0E=;
 b=TAiAJ6Lim7HYg4m2rTVMuwv3nhhVMqBNZLAxq9zw8XNmIS1sHMUu3eLH6QAxi6pr1t
 S//MbiI1wDN5tIH+MmulWKjW26Pg6tNa5dw9GoHOu5aqvJlVJfNpNpgxzaS9qteU+xfo
 HP+1n+zXFFJ+8l2XvwZfXtuxYUx9qgJwZxKvuWfaMwH0MIwpxcsAi3RKUN65fyYYC8s4
 nRNJMUn0adnaeJmuXkGJaTCuFY8h6/Eek2oPXP0JSpAy1Kyh6nqXTGVPdsEGuy6Gd37k
 nYf/x+31rKoS7Zsv9GsE3bznUKhUYhHBendTrFQS4ccKTv0dpRXWKuRtk9Mloq8KPC4l
 WFYw==
X-Gm-Message-State: AOAM530y0+celZvzMDkLJfUsPijFlNbGSucTzj1XOwyZC+MCP/DUWJFr
 Kx2KjN4YJcKl9JkIaJL2/9ICEj8JblIv4TF2tND7NS1e3XAVAQG60gcqCqEZqE5x3Z+5Xz3DUAw
 TpBQzy22u2Ehvdr1xqN32l5uCw5MkSYcL7e9r9AxmMQx34A8cpLZHIzwdzJH3M7/bfYGsVBAynw
 ==
X-Received: by 2002:a1c:cc02:: with SMTP id h2mr13572374wmb.39.1625479039120; 
 Mon, 05 Jul 2021 02:57:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUUJkycBN1IGxatVRV8AT19lHi23ORSBLStzRwyll5y4tv8tW5FBc57g3oPpWeWfi+32GUYA==
X-Received: by 2002:a1c:cc02:: with SMTP id h2mr13572348wmb.39.1625479038812; 
 Mon, 05 Jul 2021 02:57:18 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id v15sm21840814wmj.39.2021.07.05.02.57.17
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 05 Jul 2021 02:57:18 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: Address extra memslot parameters in
 vm_vaddr_alloc
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org
References: <20210702201042.4036162-1-ricarkol@google.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <441f3230-7d31-8a14-f100-a0c6063e3d07@redhat.com>
Date: Mon, 5 Jul 2021 11:57:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210702201042.4036162-1-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
X-Mailman-Approved-At: Mon, 05 Jul 2021 06:18:39 -0400
Cc: maz@kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
 seanjc@google.com
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

Hi Ricardo,

On 7/2/21 10:10 PM, Ricardo Koller wrote:
> Commit a75a895e6457 ("KVM: selftests: Unconditionally use memslot 0 for
> vaddr allocations") removed the memslot parameters from vm_vaddr_alloc.
> It addressed all callers except one under lib/aarch64/, due to a race
> with commit e3db7579ef35 ("KVM: selftests: Add exception handling
> support for aarch64")
> 
> Fix the vm_vaddr_alloc call in lib/aarch64/processor.c.
> 
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  tools/testing/selftests/kvm/lib/aarch64/processor.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 9f49f6caafe5..632b74d6b3ca 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -401,7 +401,7 @@ void route_exception(struct ex_regs *regs, int vector)
>  void vm_init_descriptor_tables(struct kvm_vm *vm)
>  {
>  	vm->handlers = vm_vaddr_alloc(vm, sizeof(struct handlers),
> -			vm->page_size, 0, 0);
> +			vm->page_size);
>  
>  	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
>  }
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
