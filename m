Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA2BCC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 15:37:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4CB6F61159
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 15:37:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4CB6F61159
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C11B74B30C;
	Tue,  5 Oct 2021 11:37:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PoccH5PhK4gN; Tue,  5 Oct 2021 11:37:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A29384B2DB;
	Tue,  5 Oct 2021 11:37:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 066544B2D9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 11:37:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UTiRoCsQ5xBA for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 11:37:42 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F247B4B2A1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 11:37:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633448261;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=g8VaQsv47xGVpNOlqz6W/3BMiLvJlFlGBCWNXnGhzpc=;
 b=OSnc3tGHmU1Y94wT5+2Fd0B0erDNm+MfhVbuwHzAm2bd8lo1uGiT9eOfJ5BR356ltipo78
 aiP62tKWnf80OeFP/E/CK1gCSWXaNH9Ugf7I7KRff1zrkb4CC4EO9aNKWm3Nwn/dUFhODd
 dHcP90st3ozWoGAP6LXlW1Y/mgUASCY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-_9EdL-iCNsKXOLsa7_4hhQ-1; Tue, 05 Oct 2021 11:37:38 -0400
X-MC-Unique: _9EdL-iCNsKXOLsa7_4hhQ-1
Received: by mail-wm1-f71.google.com with SMTP id
 o22-20020a1c7516000000b0030d6f9c7f5fso1938915wmc.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 08:37:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=g8VaQsv47xGVpNOlqz6W/3BMiLvJlFlGBCWNXnGhzpc=;
 b=4Mv2B8FToDEW/RXoWquj/ym9bUpI+a2YWIeHy1OGGTXla1tnw8ewDx5dYfX1TLQPRD
 vE3AHCoUOKG/WxmG328QnO0daLVHhWeGCHMxXwKvdbRj4cYL3CZaKf1RGdEZrIzK82kU
 5oj2ZapB1i9WHtJx9NaRipKdDw1qex7EJuu7O2npLf1HcBC07l9HwnLmRmA0KkBGfSz4
 +/1Pm5oRRaG4Xx7tQNi7HSkx8Ys7jYVvkpTMzaieZJ93WD7WPTRfkiCo5rLm6Z63bdf6
 6xpokjGwQX2mjISCo03D+DTFDvUSuVC/t1vOvVm0GIEkxUKoukVG/KJTIdJrmIHPbikF
 Xtrg==
X-Gm-Message-State: AOAM533G44ewm465/911EsfEHlB8aOauroCShbUbs5CWlU9CtW92VyRR
 pFnHkI8rW7+EEosL/wuVaaNqnrXQclNHUbLP+WVD+mUk8G+wjr6GIHujdJTEanXwNaHAd4JUGl/
 18/2i0WBJW46OKpZRKsEzFhkZ
X-Received: by 2002:a05:600c:288:: with SMTP id
 8mr4208694wmk.172.1633448257732; 
 Tue, 05 Oct 2021 08:37:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGIBdCendc78IIq3oVK8zaOmi7VNd1+Th3HZcWbj0tcqdqRU7djnn+V2pkLvsYwDZTZmSOXw==
X-Received: by 2002:a05:600c:288:: with SMTP id
 8mr4208665wmk.172.1633448257534; 
 Tue, 05 Oct 2021 08:37:37 -0700 (PDT)
Received: from thuth.remote.csb (p549bb2bd.dip0.t-ipconnect.de.
 [84.155.178.189])
 by smtp.gmail.com with ESMTPSA id l21sm2237622wmh.31.2021.10.05.08.37.36
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 05 Oct 2021 08:37:37 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 4/5] Use report_fail(...) instead of
 report(0/false, ...)
To: Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
 Andrew Jones <drjones@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20211005090921.1816373-1-scgl@linux.ibm.com>
 <20211005090921.1816373-5-scgl@linux.ibm.com>
From: Thomas Huth <thuth@redhat.com>
Message-ID: <f8bbb6e4-da89-59a3-1826-d87979177f1c@redhat.com>
Date: Tue, 5 Oct 2021 17:37:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211005090921.1816373-5-scgl@linux.ibm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=thuth@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 05/10/2021 11.09, Janis Schoetterl-Glausch wrote:
> Whitespace is kept consistent with the rest of the file.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>   lib/s390x/css_lib.c |  30 ++++----
>   x86/vmx.h           |  25 ++++---
>   arm/psci.c          |   2 +-
>   arm/timer.c         |   2 +-
>   s390x/css.c         |  18 ++---
>   s390x/spec_ex.c     |   7 +-
>   x86/asyncpf.c       |   4 +-
>   x86/hyperv_stimer.c |   6 +-
>   x86/hyperv_synic.c  |   2 +-
>   x86/svm_tests.c     | 163 ++++++++++++++++++++++----------------------
>   x86/vmx.c           |  17 +++--
>   x86/vmx_tests.c     | 136 ++++++++++++++++++------------------
>   12 files changed, 200 insertions(+), 212 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
