Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 456F7C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 11:39:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3FE64B1F1;
	Tue, 14 Dec 2021 06:39:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 191nNL67uGeQ; Tue, 14 Dec 2021 06:39:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D4DA4B174;
	Tue, 14 Dec 2021 06:39:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB07A4B174
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 06:39:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id okChFHd5dAYZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 06:39:02 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 787764B164
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 06:39:02 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1639481942;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0j8FhG3Pdijo+JlLzqQ4wiB6x9V3flBlZRvgbDc00+M=;
 b=OcPMK34HRGnZSkyndtCMK7nyX9U9M6v0K44X8/tD4YWMRjtYVVaaSTJEZ0cVf5mmRpAf8j
 nEWdXEoHAinw2WPjyg3HMKFdSKGtVKHZOJ5JCZrOtopmIFsW5iM82rU9WKhf5/4/2QpO+G
 4h11n1QPMMI9ONeIq+5ehKxYTpR222A=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203--8zXv2LNO-ygSk9mAnNZOg-1; Tue, 14 Dec 2021 06:36:16 -0500
X-MC-Unique: -8zXv2LNO-ygSk9mAnNZOg-1
Received: by mail-ed1-f70.google.com with SMTP id
 v1-20020aa7cd41000000b003e80973378aso16743964edw.14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 03:36:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=0j8FhG3Pdijo+JlLzqQ4wiB6x9V3flBlZRvgbDc00+M=;
 b=L8PId+tkAAkEHQiE0Pvz+fd0sHo8PoCanf6AEMDZm0+3NXIndDlwtsH12NudPdfIlh
 bj/SepWTKIm9IaxJJkJY3vlb6G36zascj8CHGnij0UTem5MPzY1UpCcEbj4RkNT+cTLv
 55TA00HJVDTGC66BsfqmFRNonlpUHRSi2M6HEhdt9KMP6xcrolxPppBY9UDuEcavJ8cQ
 QA5BmZf7CVibE1ymC+pzm1dDZGWn4HQdAQDvoNp4UUMUWb5RaUvfYCz3PjNaxbqvYdyQ
 rbBTYPDGQOC2DJSL28qYpBraGAsJ4woMxGGGgURvKuFq2Miq63SHIdFwr1SAmB+jNwzK
 ScLw==
X-Gm-Message-State: AOAM532zjk2BFUU1YNejlKGXXnV022doMPqGpiFE3l2knNETdTv1e9Rf
 /eI1u/rRuMwR7CIWjLEbNcW/u2Cy1hrjBK+MmKCDA5yBzMWpaXAh7eEbQLfRDQGIJz+lMbSo+PU
 GnB1Wqr9O42fn8IYvHcvKclYZ
X-Received: by 2002:a17:906:9b92:: with SMTP id
 dd18mr5231694ejc.425.1639481775731; 
 Tue, 14 Dec 2021 03:36:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy17sRiPWDlXNBUvaRGW9SLydlz3ExkOE8Neh75tU8W0vHEviUmeW4FhT9rtciIvEhPs0GjWg==
X-Received: by 2002:a17:906:9b92:: with SMTP id
 dd18mr5231671ejc.425.1639481775578; 
 Tue, 14 Dec 2021 03:36:15 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id ck12sm4885009edb.53.2021.12.14.03.36.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 14 Dec 2021 03:36:14 -0800 (PST)
Date: Tue, 14 Dec 2021 12:36:12 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v9 3/9] Makefile: add GNU global tags
 support
Message-ID: <20211214113612.u7g6n3ye4auj56s7@gator.home>
References: <20211202115352.951548-1-alex.bennee@linaro.org>
 <20211202115352.951548-4-alex.bennee@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20211202115352.951548-4-alex.bennee@linaro.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: thuth@redhat.com, kvm@vger.kernel.org, maz@kernel.org,
 christoffer.dall@arm.com, qemu-arm@nongnu.org, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Dec 02, 2021 at 11:53:46AM +0000, Alex Benn=E9e wrote:
> If you have ctags you might as well offer gtags as a target.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> Message-Id: <20211118184650.661575-4-alex.bennee@linaro.org>
> ---
>  Makefile | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> =

> diff --git a/Makefile b/Makefile
> index b80c31f8..0b7c03ac 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -122,6 +122,9 @@ cscope:
>  		-name '*.[chsS]' -exec realpath --relative-base=3D$(CURDIR) {} \; | so=
rt -u > ./cscope.files
>  	cscope -bk
>  =

> -.PHONY: tags
> +.PHONY: tags gtags
>  tags:
>  	ctags -R
> +
> +gtags:
> +	gtags
> -- =

> 2.30.2
>

We should also add gtags' generated files to .gitignore

Thanks,
drew =


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
