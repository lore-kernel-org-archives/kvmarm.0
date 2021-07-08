Return-Path: <SRS0=6kC2=MA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B886C07E99
	for <kvmarm@archiver.kernel.org>; Thu,  8 Jul 2021 17:16:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 83FE8616EA
	for <kvmarm@archiver.kernel.org>; Thu,  8 Jul 2021 17:16:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83FE8616EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01E464B0C1;
	Thu,  8 Jul 2021 13:16:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OmBOnpPQTGN8; Thu,  8 Jul 2021 13:16:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5B504B0C5;
	Thu,  8 Jul 2021 13:16:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B61BB4B0C1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jul 2021 13:16:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QNNS9FBEEDh4 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Jul 2021 13:16:21 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9B194A4E5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jul 2021 13:16:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1625764581;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=+NjBGd/4T9twKgX/ZHNdm+93Uf3nnJPB993PVyrBW5E=;
 b=GleDX/IDgJAdw7BZlXSOaZG0vbxfpWGFnSY0NrJUjqwGM79IwzCyjEvOCYhIMAjDe3yXl+
 K/Aws7Kd3vKyLJ7XjYTMjVFFS7gHanKyULk0FVClavW3WtOb1dN3AH2o45N2A8xC2igb+k
 Ow6EgbrnFd92O/HoDd5ly7r83a2gawg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-tBt0iF9gNGODgSvvJ-Jd8A-1; Thu, 08 Jul 2021 13:16:20 -0400
X-MC-Unique: tBt0iF9gNGODgSvvJ-Jd8A-1
Received: by mail-ed1-f71.google.com with SMTP id
 i19-20020a05640200d3b02903948b71f25cso3676142edu.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Jul 2021 10:16:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=+NjBGd/4T9twKgX/ZHNdm+93Uf3nnJPB993PVyrBW5E=;
 b=s7zeIZngnPWjKqgmQyGeSGl3oCrcwtKYWr+lwy8clMr7VpW4/uF9r6gwKQgQK+sZ0E
 iLF2ozlbGWZuVZ5I9REkFM7Po5sHD9CxpfzjJdKgbv0RZqq8r6fwtLxH3BBfW5Opxebj
 hQMEft8HeuxlJ5M8aLVKYLHFwPBNnSuOmbOs9x8+4p5amZ0Xc7+nyljvCRwgSC/MU6T3
 2+GAl49SEM9UbLUyRfEg8jnelqGSS1CJX6zgaJW9kCcF+X5bWAQfOFcHNVJlHy9GWZO6
 TvohFgT5sQgr0Ks7zQCoKk2q6kmfQQFZA3AMTg6hLwl+zpV1Q+7yX9/IaWjEO9svvgyp
 Km5g==
X-Gm-Message-State: AOAM531vG6J/oHFvAqISdyCqp+HO5AkU0fxvkE2i87azolZKqHLPVVRJ
 s6uRKCEGzAjHNL8frzB9XimPIv7ebzcraFKCsppCltPDHcRbW7qrWQnT+gP29LPg5LdwbbB9cP1
 7m+wAiCtJPOwWgKRIrFdBIxRT
X-Received: by 2002:a05:6402:419:: with SMTP id
 q25mr40332859edv.331.1625764579275; 
 Thu, 08 Jul 2021 10:16:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQVvnmaFFbGkreLluH7iRVwQq7iwQchIQvrtFvvU2a0y+JUwjav42PUgwI1804W02tpXYMtA==
X-Received: by 2002:a05:6402:419:: with SMTP id
 q25mr40332821edv.331.1625764578995; 
 Thu, 08 Jul 2021 10:16:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id e24sm1138632ejx.100.2021.07.08.10.16.17
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 08 Jul 2021 10:16:18 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: Address extra memslot parameters in
 vm_vaddr_alloc
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org
References: <20210702201042.4036162-1-ricarkol@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <eebf14e1-cd5c-a55d-cd68-620df1c9bcf0@redhat.com>
Date: Thu, 8 Jul 2021 19:16:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210702201042.4036162-1-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: seanjc@google.com, kvmarm@lists.cs.columbia.edu, maz@kernel.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 02/07/21 22:10, Ricardo Koller wrote:
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
> ---
>   tools/testing/selftests/kvm/lib/aarch64/processor.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 9f49f6caafe5..632b74d6b3ca 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -401,7 +401,7 @@ void route_exception(struct ex_regs *regs, int vector)
>   void vm_init_descriptor_tables(struct kvm_vm *vm)
>   {
>   	vm->handlers = vm_vaddr_alloc(vm, sizeof(struct handlers),
> -			vm->page_size, 0, 0);
> +			vm->page_size);
>   
>   	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
>   }
> 

Queued, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
