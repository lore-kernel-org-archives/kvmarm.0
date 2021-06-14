Return-Path: <SRS0=Qgx2=LI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9835C49EA3
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 09:01:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 634116138C
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 09:01:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 634116138C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC70349F82;
	Mon, 14 Jun 2021 05:01:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vAlmYNSYPVNB; Mon, 14 Jun 2021 05:01:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0EE540C88;
	Mon, 14 Jun 2021 05:01:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6754D40C88
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 05:01:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8BR4pWkjBYax for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Jun 2021 05:01:51 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88D9B405EE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 05:01:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623661311;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Vu71pFISFQB26ccLvg0CQj6wZuEmNrd515lFL21+3Sk=;
 b=RvnSh2DpZMK5F3QUJKqt3fsa5jCwoR2iPGzRU3NR+3IV2hg6VUAjq6KbrvMr6Qtgpc9lOT
 WcCPghD8lVLb0GEDb3d5wodYlALm+EQ96d6t5Pb4QXKcvbAsrDskPrgxcS0Hc6KeC5dvyN
 xB5HrRa6VsE9oik8+Dbv1Il9xPP9oC0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-xZqpFdR3OkyT6UBrVBjaeQ-1; Mon, 14 Jun 2021 05:01:47 -0400
X-MC-Unique: xZqpFdR3OkyT6UBrVBjaeQ-1
Received: by mail-ej1-f72.google.com with SMTP id
 e11-20020a170906080bb02903f9c27ad9f5so2769616ejd.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 02:01:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Vu71pFISFQB26ccLvg0CQj6wZuEmNrd515lFL21+3Sk=;
 b=sR+PKvQ/vmJiys5GFmzKIG25xvrGaCLagwpsuL+snLONVmodE5/GkPheiIE2o2Pzj3
 ds+iCWpZmwAcXveh+sSNjCzCewuBdQvYmodZyw5O2UEa37BBpePOGMP7OydbLN0KIkYh
 X6MGUgv01taXccZhUPZ/BO8uJv9qKNdNjAASUwGf/3w5PDoJWmGQulaohe4RfCu4/KUM
 l/23T+CYhxawK+S2LtGEkfGt0ysLreu21ZrWAV78sCzsBtPnSl829x7O0bE16cde9XhI
 eBUnbum8gKo2+7tsP6l6TqBT1fXC0t8Tla5h2Cp4flHVGFWiJ/L0hMAim93JlUb+B1jf
 s7jg==
X-Gm-Message-State: AOAM531lHW2fW02lhvii2PwKoZh4DWuT/zXjKTR7YCInDggoBgGXhHGB
 fr8Daw35am/OQY+JBHc6zAyEG8mfIfAsjMuHArQxKC1XsEl4Kcqp+Ey444OEa6WFHK+CcMiwuwO
 T3BJX9cQtDRbMZj5APXF6zE1D
X-Received: by 2002:a17:906:919:: with SMTP id
 i25mr13807849ejd.171.1623661306845; 
 Mon, 14 Jun 2021 02:01:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+fLbnuHGety/JfKAcniNuROzvJXDxZM4MObP9ZDsQ/Xs26Tw0DmHFHnS/gasdb1Ql3S2RTg==
X-Received: by 2002:a17:906:919:: with SMTP id
 i25mr13807831ejd.171.1623661306669; 
 Mon, 14 Jun 2021 02:01:46 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id h22sm8094337edv.0.2021.06.14.02.01.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 14 Jun 2021 02:01:46 -0700 (PDT)
Date: Mon, 14 Jun 2021 11:01:44 +0200
From: Andrew Jones <drjones@redhat.com>
To: Cornelia Huck <cohuck@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/7] README.md: add guideline for
 header guards format
Message-ID: <20210614090144.q76g5mgmuno47snj@gator.home>
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-2-cohuck@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-2-cohuck@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Laurent Vivier <lvivier@redhat.com>, linux-s390@vger.kernel.org,
 Thomas Huth <thuth@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 kvm-ppc@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu
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

On Wed, Jun 09, 2021 at 04:37:06PM +0200, Cornelia Huck wrote:
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  README.md | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/README.md b/README.md
> index 24d4bdaaee0d..687ff50d0af1 100644
> --- a/README.md
> +++ b/README.md
> @@ -156,6 +156,15 @@ Exceptions:
>  
>    - While the kernel standard requires 80 columns, we allow up to 120.
>  
> +Header guards:
> +
> +Please try to adhere to adhere to the following patterns when adding

Double 'to adhere'

Thanks,
drew

> +"#ifndef <...> #define <...>" header guards:
> +    ./lib:             _HEADER_H_
> +    ./lib/<ARCH>:      _ARCH_HEADER_H_
> +    ./lib/<ARCH>/asm:  _ASMARCH_HEADER_H_
> +    ./<ARCH>:          ARCH_HEADER_H
> +
>  ## Patches
>  
>  Patches are welcome at the KVM mailing list <kvm@vger.kernel.org>.
> -- 
> 2.31.1
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
