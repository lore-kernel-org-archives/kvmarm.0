Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85076C48BD1
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 14:45:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0BC8E60C41
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 14:45:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0BC8E60C41
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 878C640821;
	Wed,  9 Jun 2021 10:45:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hRAINJP3vqZ0; Wed,  9 Jun 2021 10:45:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90B6149D50;
	Wed,  9 Jun 2021 10:45:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D25E407F4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 10:45:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FGKlABjgkq16 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 10:45:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 742AA407F1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 10:45:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623249939;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=tnzGT8LB+qqMPyhJStfYGlKykN8fg6Vcl9Y43OphKvE=;
 b=Sq+itjkFBZPFId/bIcVt4IqoLHlguHDNEioKmxDqDrvmDAqjE/ClZG+90GBQBAP+9eF3D3
 i53D3A+Pk41bv4Ord6odAazrDQMZd4OxfrffQEtTaUNfTgyuxS8pnn+IYBLOhJ4dmNCBvl
 RnyV98/9v8imDj4WezPWEf1sLVFQSEw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-3ex2twymPJqXrE_QV27dYg-1; Wed, 09 Jun 2021 10:45:35 -0400
X-MC-Unique: 3ex2twymPJqXrE_QV27dYg-1
Received: by mail-wm1-f70.google.com with SMTP id
 h9-20020a05600c3509b02901b985251fdcso767376wmq.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Jun 2021 07:45:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:organization
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=tnzGT8LB+qqMPyhJStfYGlKykN8fg6Vcl9Y43OphKvE=;
 b=VvSTanQXAx8gqXxFM0NUvkTgeI5B/G0R7bfCKgTrkjVzC+mQyEJgzyfmejpahLRuWZ
 dvj2omDApYoiEjx+3eGQ98RBK/IiJRE+RomLIgqRW51KuJI+5uoI2Yej/eYJXyvfHsxq
 Kh5Uj0UcAdSwERrvXyDU3SBMfhzD16UgWJqbZVeOGtiLrGH/MHKqRS+qQlIpOTfO2qKh
 Bi6ozU7T9IQYKgweKnv+fjHiLPB/eqMPKfQ8uIG5Wvf5kM0/kNXI3SDZDue6zBG0VDMg
 7DS1S9qcaILqgD1breHcHEpv36BUADPuX3LvpdmuBmDqPsSu5fGYFs+6n693iM7LL1C5
 oCtA==
X-Gm-Message-State: AOAM5333IX9/hMGYs6fhJuj5NSq5r2LqbKA0Pv8iJuSE1PHUAGfm6dvr
 tTHZNmNdMjXtVvZDclVAZVWn1LaQmORASYFkVsEYaqpGBOX+esKJrqyIjqoVP+sKZBYjI8EMjQ0
 KgIKHaz8Ul94IV483tZ3o2c7j
X-Received: by 2002:a05:6000:188d:: with SMTP id
 a13mr166312wri.61.1623249934285; 
 Wed, 09 Jun 2021 07:45:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBlt+Qd2SzrFOQD3lcTBbx/uITEZdEoScRy5/tAvd6+BgUrQgY42qMDWZ4IPIP1cvrcUECgg==
X-Received: by 2002:a05:6000:188d:: with SMTP id
 a13mr166282wri.61.1623249934070; 
 Wed, 09 Jun 2021 07:45:34 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c611d.dip0.t-ipconnect.de. [91.12.97.29])
 by smtp.gmail.com with ESMTPSA id
 k82sm6877536wmf.11.2021.06.09.07.45.33
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Jun 2021 07:45:33 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 1/7] README.md: add guideline for header
 guards format
To: Cornelia Huck <cohuck@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Andrew Jones <drjones@redhat.com>
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-2-cohuck@redhat.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <4884a501-939e-a343-7cb3-a31d2f59914f@redhat.com>
Date: Wed, 9 Jun 2021 16:45:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-2-cohuck@redhat.com>
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
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   README.md | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/README.md b/README.md
> index 24d4bdaaee0d..687ff50d0af1 100644
> --- a/README.md
> +++ b/README.md
> @@ -156,6 +156,15 @@ Exceptions:
>   
>     - While the kernel standard requires 80 columns, we allow up to 120.
>   
> +Header guards:
> +
> +Please try to adhere to adhere to the following patterns when adding
> +"#ifndef <...> #define <...>" header guards:
> +    ./lib:             _HEADER_H_
> +    ./lib/<ARCH>:      _ARCH_HEADER_H_
> +    ./lib/<ARCH>/asm:  _ASMARCH_HEADER_H_

I'd have used _ARCH_ASM_HEADER_H_

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
