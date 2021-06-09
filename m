Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E25C48BE0
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 14:47:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BBC32613BC
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 14:47:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBC32613BC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49CCA40CF9;
	Wed,  9 Jun 2021 10:47:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HXxHmkjsZRWg; Wed,  9 Jun 2021 10:47:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EF384086A;
	Wed,  9 Jun 2021 10:47:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AEDA407B0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 10:47:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lQjd1WUEbccy for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 10:47:12 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13EE940291
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 10:47:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623250031;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=r7p3iSSBeE9IsLDvewBcO4q2lNyiQ1LDLULJ0BkngOw=;
 b=RgIarz+RAQ9YTJfm8/fZvoXdZ6Fh5rF3zZkMdiCjvmcPNOMzUvJPYSCmonTsegTRLksQDD
 IO6HTqNl+U98+P7saKIrwU8+as6OzdKqG6ye8X1wCyAqpx9S5XzkAX594M6CnL+yhOFnpA
 cPgUBZ8KCpAZ4PteCoFgk+aDV7wnu9U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-MngmMwZoNRG7Kj_RaT0wGg-1; Wed, 09 Jun 2021 10:47:09 -0400
X-MC-Unique: MngmMwZoNRG7Kj_RaT0wGg-1
Received: by mail-wm1-f71.google.com with SMTP id
 z19-20020a7bc1530000b02901ab5fafdcb4so900531wmi.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Jun 2021 07:47:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:organization
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=r7p3iSSBeE9IsLDvewBcO4q2lNyiQ1LDLULJ0BkngOw=;
 b=LII7M3/tA4VM5+a17bOWq1qkjixCg9YJ3QlNrJW8SCxmdlW+fzMBMzgEPg6eK3XYYu
 qv6W3cUGWle34UlL5RyvhjMrPDxbqeTqKXSoSyDFTBnHgEKPMjsCZ8HqB8csXauugiwm
 J4BHszcUgpAytneovKsLIq7h5+dspq7ie4PcHLSPQXGVDUiXBOYH1UN5I62RyGFT1q0r
 M1ln+2XElg0O090gkudIplnQyIm7f5VQkGeHIh1+VwTl45vqxVlbOmH/xgw7AxiGeGcA
 y6FxIFbj7Wn01PmKFGc2fywEaPkXLwyXiXpXA4pwi1kfHcKp5ILrLhxdyVILVqyBdz8Z
 niLw==
X-Gm-Message-State: AOAM5336WdTuyf8fiThGPPP1Q1YtUlO9Uq6g1eyegO+kpvDCzT9++xb3
 91E1ZPTZ94rcarAEva4KjNAFm5rBwFGy8TxySEvcjV+hu/04aQa4CtWU55Q8kBLxofhFcHifsle
 5nyjul/+NdrLBdMkdAYsplmb3
X-Received: by 2002:adf:a195:: with SMTP id u21mr137229wru.367.1623250028742; 
 Wed, 09 Jun 2021 07:47:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJweqEQec2chpibdCqZRkKANHtLLkFIjRh58mELPpwoK9PTJW2sYNOXC6gBVGIEq5Mnyq5WnhA==
X-Received: by 2002:adf:a195:: with SMTP id u21mr137211wru.367.1623250028562; 
 Wed, 09 Jun 2021 07:47:08 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c611d.dip0.t-ipconnect.de. [91.12.97.29])
 by smtp.gmail.com with ESMTPSA id
 l16sm6741263wmj.47.2021.06.09.07.47.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Jun 2021 07:47:08 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 5/7] powerpc: unify header guards
To: Cornelia Huck <cohuck@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Andrew Jones <drjones@redhat.com>
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-6-cohuck@redhat.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <2eefe369-2eeb-17dc-0aec-cc262485c4e3@redhat.com>
Date: Wed, 9 Jun 2021 16:47:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-6-cohuck@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Laurent Vivier <lvivier@redhat.com>, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 kvm-ppc@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu
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

On 09.06.21 16:37, Cornelia Huck wrote:
> Only spapr.h needed a tweak.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   powerpc/spapr.h | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/powerpc/spapr.h b/powerpc/spapr.h
> index b41aece07968..3a29598be44f 100644
> --- a/powerpc/spapr.h
> +++ b/powerpc/spapr.h
> @@ -1,6 +1,6 @@
> -#ifndef _ASMPOWERPC_SPAPR_H_
> -#define _ASMPOWERPC_SPAPR_H_
> +#ifndef POWERPC_SPAPR_H
> +#define POWERPC_SPAPR_H
>   
>   #define SPAPR_KERNEL_LOAD_ADDR 0x400000
>   
> -#endif /* _ASMPOWERPC_SPAPR_H_ */
> +#endif /* POWERPC_SPAPR_H */
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
