Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E75D2C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jun 2022 14:49:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44DF84B402;
	Thu, 23 Jun 2022 10:49:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tTTAF6wcw7pj; Thu, 23 Jun 2022 10:49:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19D264B3D3;
	Thu, 23 Jun 2022 10:49:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32A3D4B3D3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 10:49:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vDzr36gWBer4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jun 2022 10:49:18 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD5974B3CC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 10:49:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655995758;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=SI8xutk3gmYbsLJ8Tc+MzdPXoHGzso0b1vVVkRwkUCc=;
 b=JtOft56H30DonPit/jkRtLEbFd+kwh8GZrHOFnp8kDC4ojR0256eJ83+mOm3+2nxzg3a5X
 BaR6Qo5T5B1c6KNZXWAIiZBV5INLTIupC6ok89BzKX1DwPj+i2+QPiC7hSUVb+yPJQwV+9
 gNhH0YJlOVFMyh0+XFxsRII0yr9ccJc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-FfxTyJC3NKqaH2hff104yA-1; Thu, 23 Jun 2022 10:49:17 -0400
X-MC-Unique: FfxTyJC3NKqaH2hff104yA-1
Received: by mail-wm1-f71.google.com with SMTP id
 h125-20020a1c2183000000b003a0374f1eb8so428336wmh.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jun 2022 07:49:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=SI8xutk3gmYbsLJ8Tc+MzdPXoHGzso0b1vVVkRwkUCc=;
 b=TCKmA5ZdW58Vdlas4GTc57MnLD5L04EINBh+2qZWI56z+eM3T6oqRS9WajW5dVdul6
 z/XpS0Euoz1hXHYhru2aWdKABMnK9A6LRnFE+9oM5n4sWFNNeYiJ2t2v1I1ZNuP3FYWq
 vV1Jht5sHkmT6F8iiWzPErV9rYGTqS6fC76IX7zZzPUWITjAosqaAPK/dD6tafUdDD+5
 LN+6dboPan5CdWZwis3iZe5O2+bJjAOGeqta3shrygo5P4NNcpowCo+c64zrn7aC46o8
 BFCrlOhydAddLCZNQXQST7HJ/KwEQDbI8hmQIAfQ+IU8Ou4VFNl2++NyYtLKHmCqMHJR
 9+zQ==
X-Gm-Message-State: AJIora+CMypUdqMCZOu4fLs4A26UGDnNxYKLry9IVl0zVtr6OirqyKUt
 ZnHv+doEerTBCi55artcPsVcdS2hJiqxjIfQS/UvTs7C/ebHCWbbNnSlEHtc6fVdGOhk44eg4R3
 8vJ4xm+PCUz1Lg4R0BjNALbyB
X-Received: by 2002:a05:600c:4ca7:b0:3a0:3905:d441 with SMTP id
 g39-20020a05600c4ca700b003a03905d441mr686391wmp.159.1655995756144; 
 Thu, 23 Jun 2022 07:49:16 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v5x2JBwpH2zWRtWlZ5BKlih8mFWla4BTPBzgW9aHA88MSCt6TQqeHfutSJYLBstiVinYS4UA==
X-Received: by 2002:a05:600c:4ca7:b0:3a0:3905:d441 with SMTP id
 g39-20020a05600c4ca700b003a03905d441mr686374wmp.159.1655995755954; 
 Thu, 23 Jun 2022 07:49:15 -0700 (PDT)
Received: from [192.168.8.104] (tmo-098-39.customers.d1-online.com.
 [80.187.98.39]) by smtp.gmail.com with ESMTPSA id
 c2-20020a1c3502000000b0039c5328ad92sm3499945wma.41.2022.06.23.07.49.14
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 23 Jun 2022 07:49:15 -0700 (PDT)
Message-ID: <95b9536a-12f4-2dee-918f-c673b3d296aa@redhat.com>
Date: Thu, 23 Jun 2022 16:49:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH kvm-unit-tests] MAINTAINERS: Change drew's email address
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20220623131017.670589-1-drjones@redhat.com>
From: Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220623131017.670589-1-drjones@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=thuth@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: maz@kernel.org, qemu-devel@nongnu.org, nikos.nikoleris@arm.com,
 qemu-arm@nongnu.org, andre.przywara@arm.com, pbonzini@redhat.com
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

On 23/06/2022 15.10, Andrew Jones wrote:
> As a side effect of leaving Red Hat I won't be able to use my Red Hat
> email address anymore. I'm also changing the name of my gitlab group.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>   MAINTAINERS | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bab08e740332..5e4c7bd70786 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -55,7 +55,7 @@ Maintainers
>   -----------
>   M: Paolo Bonzini <pbonzini@redhat.com>
>   M: Thomas Huth <thuth@redhat.com>
> -M: Andrew Jones <drjones@redhat.com>
> +M: Andrew Jones <andrew.jones@linux.dev>
>   S: Supported
>   L: kvm@vger.kernel.org
>   T: https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
> @@ -64,14 +64,14 @@ Architecture Specific Code:
>   ---------------------------
>   
>   ARM
> -M: Andrew Jones <drjones@redhat.com>
> +M: Andrew Jones <andrew.jones@linux.dev>
>   S: Supported
>   L: kvm@vger.kernel.org
>   L: kvmarm@lists.cs.columbia.edu
>   F: arm/
>   F: lib/arm/
>   F: lib/arm64/
> -T: https://gitlab.com/rhdrjones/kvm-unit-tests.git
> +T: https://gitlab.com/drew-jones/kvm-unit-tests.git
>   
>   POWERPC
>   M: Laurent Vivier <lvivier@redhat.com>

Acked-by: Thomas Huth <thuth@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
