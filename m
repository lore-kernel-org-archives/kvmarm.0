Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63558C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 11:53:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D05D561401
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 11:53:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D05D561401
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 523854B2D9;
	Tue,  5 Oct 2021 07:53:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VtzQgTsjZ9og; Tue,  5 Oct 2021 07:53:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CD224B2DA;
	Tue,  5 Oct 2021 07:53:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 248CF4B2D7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 07:53:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GZtcaqTzmUiu for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 07:53:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C6A54B2D3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 07:53:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633434832;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ipJvJT+v6yt9zU5Ii84mTzCzbNo7bGPcsz8IZtbMm48=;
 b=ZxqEVFbMWsECC3B5BKGHLJi7TOns+1JCLWFSpQ7SL3oicF7MG6B5CTc75yXr3HRqLBbTQN
 tTPon3mvTQR7wGRWnK2Uv6Xvx+ZpzcVQFi1nV3Nrnnr1LOfn5VZr20awZ9PTusORSz7Jer
 GHP/X5bM2QOEuKskMwm6FaMKwOe/UWY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-vxSNHP7mPbCgmfETUH6JKw-1; Tue, 05 Oct 2021 07:53:51 -0400
X-MC-Unique: vxSNHP7mPbCgmfETUH6JKw-1
Received: by mail-ed1-f71.google.com with SMTP id
 r11-20020aa7cfcb000000b003d4fbd652b9so20359030edy.14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 04:53:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ipJvJT+v6yt9zU5Ii84mTzCzbNo7bGPcsz8IZtbMm48=;
 b=JfTTVYcQO6rQO8SvbaGHBG+OJj0TN7gaTK5dIbDX6Kzh7PZzgQxA+wYSywT9GGuYzS
 5T7HviZp76M4nyK+Gl8YfEseQuwnu3SniiyAFHJ4S9zNC/nckPAwiL6ULLRACTq+8gH2
 yJVtKnFwprzsUjwh/wJFKOLVxsKVzxe9E7Ivgl8lEa+b5TJESsZDF+x/lXj2Nx1dbmtm
 UXOOSzvljfwYZttMYmdup1K+PbMNhbX1QppFd4hnoIFpH0AR3N6x3w1X1DZ1bTVt7xkX
 k2fA6gdY0VOvJP6pJngiwjs5x6DkKNex0Z0vgy3cmGb1jSF0lRWVpJSMqhGH//RSBHw5
 3qdw==
X-Gm-Message-State: AOAM530yQoA48hf1za3pkIi0KNQ3dve8PZagzEvmhlzLSopqhYxLvC2E
 jxpMUyQ1DuSBDW6enpxl9jcj7fmJnizA5VszBb3A4JvbkzQXRgzL9WVTYrkNNWFmoWtlh2nTgRc
 E3o0kleqS8aDCfFwaIB78Z/7z
X-Received: by 2002:a17:907:2896:: with SMTP id
 em22mr10275627ejc.365.1633434829524; 
 Tue, 05 Oct 2021 04:53:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7NZJRS3nsuSLLPnAGmTBCi5hvPKn3TAype/v0D2huOK2oa40DJK7oTvG3x1UAoFyI07HuFw==
X-Received: by 2002:a17:907:2896:: with SMTP id
 em22mr10275596ejc.365.1633434829202; 
 Tue, 05 Oct 2021 04:53:49 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id t20sm7636612ejc.105.2021.10.05.04.53.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 05 Oct 2021 04:53:48 -0700 (PDT)
Date: Tue, 5 Oct 2021 13:53:47 +0200
From: Andrew Jones <drjones@redhat.com>
To: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 4/5] Use report_fail(...) instead of
 report(0/false, ...)
Message-ID: <20211005115347.palt5njjhopxvtsg@gator.home>
References: <20211005090921.1816373-1-scgl@linux.ibm.com>
 <20211005090921.1816373-5-scgl@linux.ibm.com>
MIME-Version: 1.0
In-Reply-To: <20211005090921.1816373-5-scgl@linux.ibm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: linux-s390@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Oct 05, 2021 at 11:09:20AM +0200, Janis Schoetterl-Glausch wrote:
> Whitespace is kept consistent with the rest of the file.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  lib/s390x/css_lib.c |  30 ++++----
>  x86/vmx.h           |  25 ++++---
>  arm/psci.c          |   2 +-
>  arm/timer.c         |   2 +-
>  s390x/css.c         |  18 ++---
>  s390x/spec_ex.c     |   7 +-
>  x86/asyncpf.c       |   4 +-
>  x86/hyperv_stimer.c |   6 +-
>  x86/hyperv_synic.c  |   2 +-
>  x86/svm_tests.c     | 163 ++++++++++++++++++++++----------------------
>  x86/vmx.c           |  17 +++--
>  x86/vmx_tests.c     | 136 ++++++++++++++++++------------------
>  12 files changed, 200 insertions(+), 212 deletions(-)
>

Hi Janis,

Thank you for this cleanup.

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
