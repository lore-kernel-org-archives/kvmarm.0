Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85CFC43334
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 12:10:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 272254B134;
	Thu, 16 Jun 2022 08:10:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OIM1V3GEIB9U; Thu, 16 Jun 2022 08:10:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12C4049EBC;
	Thu, 16 Jun 2022 08:10:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CB6049EBC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 08:10:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KNu6jx6wEKw8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 08:10:11 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9B5549EAE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 08:10:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655381411;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=fnbFANRgoRclz/nSGpz08wiygYjL/K249VvGKPTLsfU=;
 b=VOSkStcVNOCYtYPBWbHbaSuQKti/vm5iHzQAVx03Id0bO0i6mLzGaB6BxAYCnSOGNdOUGT
 39WZ+TtYbcai5ZMlUSf9s41AgwjRdo3zIA++eiep2YalW7sV/dEOUwp4Nwjb9Aa5DUWG8h
 f4mA9EeiCjRbIQwlVj+1w/WFWWn5UPU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-yl5wTbpZODKHPV2nOPRj3w-1; Thu, 16 Jun 2022 08:10:10 -0400
X-MC-Unique: yl5wTbpZODKHPV2nOPRj3w-1
Received: by mail-ed1-f69.google.com with SMTP id
 x8-20020a056402414800b0042d8498f50aso1099796eda.23
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 05:10:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fnbFANRgoRclz/nSGpz08wiygYjL/K249VvGKPTLsfU=;
 b=OZX7do1dMyFgGnR8skCFMaDhy7+KLuWh2+4ljPHWuikXGIyYTBIe+/M0hChivOOyY7
 VH7FDOQ4Q58spoMWkyzqlCVwowm8nipogs753/puMY/Y48oRyvAlAwjjKXTnQDOVQ1Uy
 MAYOrIYh20ANbRntqblIB2oJbXV/IbW8f2l+3j0E9yFIJEt72WtBJWBNFQ+WjgoEkOcP
 MX2BfmRgMFR9S8ZKoK8zq95RMMnoV8zM7vtBXMiYbrVlGwjn6elOKmIeE02G5XdNTx3B
 69Zkn2n4xSbdnLkyvVqdcA8gKjNlGbFWXQHtF4VFdfjSCh5zH10roW5hk8+Vp4SXASYz
 pivQ==
X-Gm-Message-State: AJIora+OL4BeqCjlnoB7DSQvN/C/MzJprRBvhHX8rjML1bmsJFdaW1/W
 N7gDustnce/1moQz1rPyKsVWoe2cHj6iImH1J/iIvSYe+oQBzG6/HVuGDmNR0KygTsPJ0q/XUZo
 bJszFBKcUuuK6T03HB8d1sd1R
X-Received: by 2002:a05:6402:ea7:b0:433:6141:840e with SMTP id
 h39-20020a0564020ea700b004336141840emr6109535eda.266.1655381409580; 
 Thu, 16 Jun 2022 05:10:09 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1shrqTcIAQx5WuqolRTdcuV69UIK8NkIrhIplpkXUIdvASi2H8d4HpaeyriLBogszA7USoIuA==
X-Received: by 2002:a05:6402:ea7:b0:433:6141:840e with SMTP id
 h39-20020a0564020ea700b004336141840emr6109506eda.266.1655381409416; 
 Thu, 16 Jun 2022 05:10:09 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
 by smtp.gmail.com with ESMTPSA id
 o17-20020aa7dd51000000b0042df0c7deccsm1628311edw.78.2022.06.16.05.10.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Jun 2022 05:10:08 -0700 (PDT)
Date: Thu, 16 Jun 2022 14:10:06 +0200
From: Andrew Jones <drjones@redhat.com>
To: Colton Lewis <coltonlewis@google.com>
Subject: Re: [PATCH 2/4] KVM: selftests: Increase UCALL_MAX_ARGS to 7
Message-ID: <20220616121006.ch6x7du6ycevjo5m@gator>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-3-coltonlewis@google.com>
MIME-Version: 1.0
In-Reply-To: <20220615193116.806312-3-coltonlewis@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: thuth@redhat.com, kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
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

On Wed, Jun 15, 2022 at 07:31:14PM +0000, Colton Lewis wrote:
> Increase UCALL_MAX_ARGS to 7 to allow GUEST_ASSERT_4 to pass 3 builtin
> ucall arguments specified in guest_assert_builtin_args plus 4
> user-specified arguments.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  tools/testing/selftests/kvm/include/ucall_common.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index dbe872870b83..568c562f14cd 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -16,7 +16,7 @@ enum {
>  	UCALL_UNHANDLED,
>  };
>  
> -#define UCALL_MAX_ARGS 6
> +#define UCALL_MAX_ARGS 7
>  
>  struct ucall {
>  	uint64_t cmd;
> -- 
> 2.36.1.476.g0c4daa206d-goog
>

We probably want to ensure all architectures are good with this. afaict,
riscv only expects 6 args and uses UCALL_MAX_ARGS to cap the ucall inputs,
for example.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
