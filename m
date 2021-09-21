Return-Path: <SRS0=fzUG=OL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3BAC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 07:09:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0F502611C5
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 07:09:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0F502611C5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 782EC4AC78;
	Tue, 21 Sep 2021 03:09:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9RCheKYZ1NF0; Tue, 21 Sep 2021 03:09:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EE4949F5D;
	Tue, 21 Sep 2021 03:09:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52D2749E5F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 03:09:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K5nOpXoc1BhQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 03:09:22 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F75F49E57
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 03:09:22 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632208162;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=XjFX8TMy06JKFo29b5wtP7D4GUJciYA0H9pKx9SvMnM=;
 b=WUVw2YBM04u+n1R5RZxzSPXjc8JVZ8m34jvQU48kV+HuSE9AIzwAY4zopgAp57OZDcl8Qf
 k5GWj9ofPaTLpk84x/uFs8dERDUgCG5ZjItaH/MfoJHimUpm0FGcPm70qYsttpfOAaVWWT
 6Vra+p3yQE3kJ7EU0tNrsBn7g28rSTc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-7l3ddAt7NXeUlvpHS3oANQ-1; Tue, 21 Sep 2021 03:09:19 -0400
X-MC-Unique: 7l3ddAt7NXeUlvpHS3oANQ-1
Received: by mail-ed1-f70.google.com with SMTP id
 l29-20020a50d6dd000000b003d80214566cso13723780edj.21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 00:09:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=XjFX8TMy06JKFo29b5wtP7D4GUJciYA0H9pKx9SvMnM=;
 b=X5MybkYplWSTalkp67kir4lWy8b8r+zGsHDRwkMxmL1+S3hWckPN2/ku3pCtUI5X4t
 BIicdq+EF8kzpRlv6BxlTzhwiGfJOa7MP8S0JbFqYITUNBIO3SoTuSbQbv/dQqQxaygP
 Rf0Go39Qn9lQHo5tgqNBZhS2nzpz25DhVjmRbigVT1+FfULoWnHU0bpXwoLiuPtPk7wG
 1wH/+bQdik1m2k4Rms6kdgzTTrc+xlKJK7gwgbkRKxC1pUyBxvv0T4dj24R6z28ScBSm
 voRqE4iwjmpyTqj6Nl3QnwfYRuhsYroT2j9M2f/HkvNYDsZSftUx9IPfcWAjwvQefnDO
 SCwg==
X-Gm-Message-State: AOAM533nHq7+jsUx3/fx/PbitHEdGhftpZuSk85iViFftZRW7REYEziM
 yy7Ega4xyYDCP3dDdMPyIdSwX79tUw24PKZFh7AIr8yTVlR0RpVcIWDzuhJ6FdxZskB4kDLB/Ae
 TU73ywChlr0kn5ro+L5TCWJmy
X-Received: by 2002:a05:6402:5186:: with SMTP id
 q6mr34420809edd.64.1632208158778; 
 Tue, 21 Sep 2021 00:09:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyp+nqzB/L7XPOlCkV3Kf+TstkeUZIEG99Ro+U4OsVAaj3p8YvQky54QCUhsjWONz2ie8sFMw==
X-Received: by 2002:a05:6402:5186:: with SMTP id
 q6mr34420775edd.64.1632208158565; 
 Tue, 21 Sep 2021 00:09:18 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id x7sm3936808ede.86.2021.09.21.00.09.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 21 Sep 2021 00:09:17 -0700 (PDT)
Date: Tue, 21 Sep 2021 09:09:15 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 1/2] selftests: KVM: Fix compiler warning in
 demand_paging_test
Message-ID: <20210921070915.mmubmdqqkf2qsit6@gator.home>
References: <20210921010120.1256762-1-oupton@google.com>
 <20210921010120.1256762-2-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210921010120.1256762-2-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

On Tue, Sep 21, 2021 at 01:01:19AM +0000, Oliver Upton wrote:
> Building demand_paging_test.c with clang throws the following warning:
> 
> >> demand_paging_test.c:182:7: error: logical not is only applied to the left hand side of this bitwise operator [-Werror,-Wlogical-not-parentheses]
>                   if (!pollfd[0].revents & POLLIN)
> 
> Silence the warning by placing the bitwise operation within parentheses.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index e79c1b64977f..10edae425ab3 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -179,7 +179,7 @@ static void *uffd_handler_thread_fn(void *arg)
>  			return NULL;
>  		}
>  
> -		if (!pollfd[0].revents & POLLIN)
> +		if (!(pollfd[0].revents & POLLIN))

That's a bug fix. If revents was e.g. POLLPRI then this logic
wouldn't have done what it's supposed to do. Maybe we should
better call out that this is a fix in the summary and add a
fixes tag?

Anyway,

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

>  			continue;
>  
>  		r = read(uffd, &msg, sizeof(msg));
> -- 
> 2.33.0.464.g1972c5931b-goog
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
