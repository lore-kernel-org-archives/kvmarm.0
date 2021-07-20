Return-Path: <SRS0=KNUW=MM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A4C0C07E9B
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 14:06:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B0A66113A
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 14:06:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B0A66113A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EDB64A19F;
	Tue, 20 Jul 2021 10:06:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0t1Iu7GrgH+T; Tue, 20 Jul 2021 10:06:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ABFE4B0BE;
	Tue, 20 Jul 2021 10:06:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C1C44B0B3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 10:06:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JjOIor6-xrBv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 10:06:51 -0400 (EDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E9AD4A19F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 10:06:51 -0400 (EDT)
Received: by mail-wr1-f48.google.com with SMTP id f9so26136326wrq.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 07:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=4Y7wO3FmEg9E/e/M3ZFiJFbsJXbUsTlhUr/Aisk4F7w=;
 b=lu1K4wCxmYTUEOAY0h4I+WRyY+GjDf9LqwrVn+apJAj+WQ78hw81zzGUFuz1g6DyzD
 3qjJUaBpmVOpkjVoLyrsJ2/Kc4LH4ZGWlBAJBu8wuvbeO9zuoda9yFQQPBdkmxhJI57J
 9VQmX8jPbHoZj/VB7XrOzE3R+N9O+zOSAI7IxpF0zzQLSaRhHjq8GzHtSuJWqOGYohS5
 iImsZnRyOb/OjnPNtGHUwhR/fTpzZYbAWb8D6BlLVXBC2tA6VvwBF6tRNsDr7dRJvWtC
 LPJTPTIGzM5jGa8K4Ylulif0sIoiFM/LeO/syFCA9ksIL6oJCzEirXmlegbA9itahNlu
 HDMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=4Y7wO3FmEg9E/e/M3ZFiJFbsJXbUsTlhUr/Aisk4F7w=;
 b=NDa32lGKvE5+YzvcBTxccRaGAlkP9g7nPLBqYUxpEqrUY/vFsyOxwMM+53lQhlVr6P
 X1KCybpLRqLknWeHzrFqGMyqLC83+saKeo81mA6gln62P2sk1XxVuiqcU7cMz6chK5Wv
 Gi2X4oUrReZLgXiah1/vCMvXhTJhsViCiL+O7lcJAPfn5r6USp9H5YNUI71xJzAfrC6M
 H2tgUjF7z7dEYU9MlP8isZKzmU5TuGMB538gdCbKcOzj5jjU2zhuOwQmYJBrXefS4jNh
 gQWs3LcSSQh9fgKK8E/vusK0atSGtY44O/BlTP1PUoogG4Svbduo8DPKnKXgV49UHpSo
 ktug==
X-Gm-Message-State: AOAM531u0X6OGanPC5qG9W/gzIQcjgUT7rDbUR/hnWa8vZbl3cYKkV9W
 xD8LBg2PWz1NDyR99Mqd9hWgvQ==
X-Google-Smtp-Source: ABdhPJxjEWqFqQoktHsVZL6arngMcaaXABAJUgOrUrQFloZHgHwZpBl3SXOVE0HVVWN1F/G91ZiY9Q==
X-Received: by 2002:a05:6000:154c:: with SMTP id
 12mr36606989wry.393.1626790009958; 
 Tue, 20 Jul 2021 07:06:49 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:ffa2:b757:e72a:11dd])
 by smtp.gmail.com with ESMTPSA id d8sm24562783wrv.20.2021.07.20.07.06.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 20 Jul 2021 07:06:49 -0700 (PDT)
Date: Tue, 20 Jul 2021 15:06:46 +0100
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 08/14] KVM: arm64: Add support for tagging shared pages
 in page-table
Message-ID: <YPbYdtRx6dMH52oO@google.com>
References: <20210719104735.3681732-1-qperret@google.com>
 <20210719104735.3681732-9-qperret@google.com>
 <CA+EHjTwmmV6EooG+Ykbso3G6nkjq=sbRzXH3vetazzPF5mO02g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+EHjTwmmV6EooG+Ykbso3G6nkjq=sbRzXH3vetazzPF5mO02g@mail.gmail.com>
Cc: kernel-team@android.com, qwandor@google.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tuesday 20 Jul 2021 at 14:48:09 (+0100), Fuad Tabba wrote:
> This might tie in to Marc's comments for using enums, but
> consolidating the translation between prot and ignored/software bits
> in one place would be good: thinking about patch 10 as well, where you
> get the prot from the ignored bits. Even though you have documented
> it, I'm finding the part where a field can be borrowed and shared as
> opposed to being only shared not very intuitive, and I need to reread
> the comment here to remember the difference while going through the
> code.
> 
> You also mention lending as potentially reserved for the future, but I
> think that lending is the other side of borrowing (depends on who's
> doing the giving/taking). I wonder if in this case it would be clearer
> to describe it in terms of whether it's exclusively owned vs owned but
> shared (for the owner), and just shared for the sharer...

Argh so I actually found the encoding pretty neat :/
The idea is the following:

  - an entity that has a page mapped as SHARED in its PT means it
    doesn't have exclusive access to the page;

  - an entity that has a page mapped as BORROWED in its PT means it has
    access to a page it doesn't own;

From that we can build the states we need:

  - when an entity shares a page with another, the original owner gets a
    SHARED mapping, and the recipient a SHARED+BORROWED mapping.

  - and in the future when/if we implement lending (which means an
    entity gives exclusive access to a page to another entity, but
    retains ownership) we can map the page in the recipient as
    'BORROWED' only, but not 'SHARED'. And the original owner will have
    an invalid mapping with a new state 'LENT', which is encoded with
    both SW bits set.

How does that sound? Did you have something else in mind?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
