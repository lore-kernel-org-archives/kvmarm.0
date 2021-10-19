Return-Path: <SRS0=DvdR=PH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F0CC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 21:18:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 857756134F
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 21:18:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 857756134F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0FF54B133;
	Tue, 19 Oct 2021 17:17:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tmo4WzJMeFta; Tue, 19 Oct 2021 17:17:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8C514B0B4;
	Tue, 19 Oct 2021 17:17:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A7134B0B4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 17:17:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kU1-huPdcTCS for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Oct 2021 17:17:56 -0400 (EDT)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
 [209.85.215.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 623CD4B0AC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 17:17:56 -0400 (EDT)
Received: by mail-pg1-f181.google.com with SMTP id t184so7568667pgd.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 14:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Oc0/+tVwK7K9nmz3ZCCVI0OnaV+/2goNVxH4SiWbdQY=;
 b=n/KgdwdBsIwUUylWrPRFshJHpCoQZrnOOHfYOc5/rMLQ8wuZKohdWeupQF1jMimzvb
 AIDP/6JoNxEWdsFJeXJQ9n1E/nR84Bvb4GS9Ron8aQSE5SlChfI/McpudJFpBiEAiq7u
 c0LTUpn88XqeZZR68Twh6qRkL90+VSMsQVD5a6UonW4RyfY/ps6p3bnnZc2jPb+i4xsZ
 +b6aOS+mevs/Ziu1ZT6F6eC/NCRz8ClKtNcfTJZcLh539e9ABJEpFtCnyvQO7g8/BfN5
 10QS+xNtPDeW5t5ZzyTWZDyR2BFDpnVn8/cMWxvdpCg8cfiiifFozI6/vPMmy+/4t1Os
 mfvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Oc0/+tVwK7K9nmz3ZCCVI0OnaV+/2goNVxH4SiWbdQY=;
 b=00MjXDKRbMYwPUOKsArEJ4vB1fB8Xm2hu2K6zn7eMvsF8OX/AU6+o7P4e+KYV5xFOb
 nJ1+gYOK5RhojkPxAwyI9Mp1xShK5yRAvvLOmiPDW16ByMnScdv/hLDYxp5cc+UU8XOx
 0gXaAA4PnMcJjWBjTcr3XOIqhsZ9fehxg8JjMaXQ+DqgbTmfgIxS9EZY08BKh2G6DLa7
 YMCJox/Y8Zi/LPj1bUjgQleLQChjgBu0p7rBMV2mpz1ZXTWqSf1P9KOs0EOnUYuw9cpO
 LAH7Mu0JtjdDN3gpb+PSnFoN01gbQyTYO+SmGpmmjdX1UMoXUXZHT4T2oHTr6OE/uDdN
 m+aA==
X-Gm-Message-State: AOAM531u6i8rq7BWMm8FT+lkeGdOgRz88OMF7+3TkFHntPX6DAo6Df7x
 4DE8v5pI6noHNqLtVDPWW19v7Q==
X-Google-Smtp-Source: ABdhPJx97+XMR9DaIQZAIqX4jy+cJjWfmQD3Dd0awGykaOoZQzlV7bhMqYiRM0qW49c0pxK2/TRSlQ==
X-Received: by 2002:a05:6a00:2311:b0:431:c19f:2a93 with SMTP id
 h17-20020a056a00231100b00431c19f2a93mr2263470pfh.11.1634678275358; 
 Tue, 19 Oct 2021 14:17:55 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id nv5sm95571pjb.10.2021.10.19.14.17.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 19 Oct 2021 14:17:54 -0700 (PDT)
Date: Tue, 19 Oct 2021 14:17:51 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 0/2] KVM: selftests: enable the memslot tests in ARM64
Message-ID: <YW81/4/DiAgELq09@google.com>
References: <20210907180957.609966-1-ricarkol@google.com>
 <20210907181737.jrg35l3d342zgikt@gator.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210907181737.jrg35l3d342zgikt@gator.home>
Cc: kvm@vger.kernel.org, maz@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, maciej.szmigiero@oracle.com,
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

On Tue, Sep 07, 2021 at 08:17:37PM +0200, Andrew Jones wrote:
> On Tue, Sep 07, 2021 at 11:09:55AM -0700, Ricardo Koller wrote:
> > Enable memslot_modification_stress_test and memslot_perf_test in ARM64
> > (second patch). memslot_modification_stress_test builds and runs in
> > aarch64 without any modification. memslot_perf_test needs some nits
> > regarding ucalls (first patch).
> > 
> > Can anybody try these two tests in s390, please?
> > 
> > Changes:
> > v2: Makefile tests in the right order (from Andrew).
> 
> Hi Ricardo,
> 
> You could have collected all the r-b's too.
> 
> Thanks,
> drew
> 

Friendly ping on this one, please.

> > 
> > Ricardo Koller (2):
> >   KVM: selftests: make memslot_perf_test arch independent
> >   KVM: selftests: build the memslot tests for arm64
> > 
> >  tools/testing/selftests/kvm/Makefile          |  2 +
> >  .../testing/selftests/kvm/memslot_perf_test.c | 56 +++++++++++--------
> >  2 files changed, 36 insertions(+), 22 deletions(-)
> > 
> > -- 
> > 2.33.0.153.gba50c8fa24-goog
> > 
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
