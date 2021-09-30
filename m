Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C9AC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 21:27:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C68C961A0B
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 21:27:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C68C961A0B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1431F4B08B;
	Thu, 30 Sep 2021 17:27:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q2FkcBMfwyVI; Thu, 30 Sep 2021 17:27:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C2294B08E;
	Thu, 30 Sep 2021 17:27:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 053B84B08A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 17:27:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e2SIUgzg03zZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 17:27:45 -0400 (EDT)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 22B10407ED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 17:27:45 -0400 (EDT)
Received: by mail-pf1-f176.google.com with SMTP id g2so6148655pfc.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 14:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=r0i+4oh5ttmvKzGJaF4duXEtIwD8cGanxYr+JafZRCc=;
 b=Lepz8HOPy8gYGMfKpd+iWWTvMcOMxwafkPOVcPvRlPcbhH7cbzDgC6rXgoDcB+zVgB
 Ff3KhLPBGGD3uVIja2Dm3jbPkzC+TeUU8IrXKlsd3i5Zeah4yYApRrNVxE5PepUh/zlo
 tkV+otCyCWwkHESL4eOLtedqPje8r8uYpgjKn4zlF+aynH+jiFhv8hGsPGXohQefpwnx
 kCEUKtsw2XiAqQ4B1eW8J1udWHntxC5pW0LHt518UNkkS5HK1bIfRaONCerOCQvBsNiW
 4kALVECg/PGMffjjw+V2LK2jp5wiSqNJ5/XaWD36qrHeXxtzdBFgKL7KX7HcOWcKVklx
 gE4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=r0i+4oh5ttmvKzGJaF4duXEtIwD8cGanxYr+JafZRCc=;
 b=W+ak9HyBK1d9QTSCKajHCJwV6s01zVO2PGuPlmaEfZ20eW3HAM54yztreoNdU0H7Y6
 toktprwfVwiLc4cD/ACHNxm59ij1uGQ0bqmjLVv4KTYCI55whe4ujUOUkBTyYTJqPPyj
 cPz1uluzHmNyuBxF5Sd8DJswmQ54QWduWaxL/sadw108bf+ESjqpGgQpEPyEmjhBWbsM
 7NLgumr1P8zjs8ar4aOjl1uyH+E04iWw67O9x32ItF8Yc9psDgnKNWLIu4OjaWfHN4u0
 AZSzdzKeLy5AZ2uOUDvYeQbMbvaIBrR4DO6ZbQLB0pCoplOclULkJSOScJJDcwXBmkp6
 uaJA==
X-Gm-Message-State: AOAM530wL6frLJfC4ZuDEC1nwLgCEj+519zfmXft7X6TqiPk9x+pv6Yu
 Rvtyx0ykk5dIBD5u2HXcaCXjjA==
X-Google-Smtp-Source: ABdhPJwokKb25gzszvdtUECo3bG3lRZr0uuSLd4XCMxKvvZtnpPLwddgYcgZEB3a0Ltdd5ZnEaTyGQ==
X-Received: by 2002:a63:40c:: with SMTP id 12mr6830835pge.406.1633037263905;
 Thu, 30 Sep 2021 14:27:43 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id n3sm5723593pjv.15.2021.09.30.14.27.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Sep 2021 14:27:43 -0700 (PDT)
Date: Thu, 30 Sep 2021 14:27:39 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 05/10] KVM: arm64: selftests: Make vgic_init gic
 version agnostic
Message-ID: <YVYrywHjwhzgfmBz@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-6-ricarkol@google.com>
 <a629c99e-cb41-fb2d-d551-6397774ba765@redhat.com>
 <87ee96trnl.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87ee96trnl.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, shuah@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 30, 2021 at 09:05:18AM +0100, Marc Zyngier wrote:
> On Wed, 29 Sep 2021 18:12:59 +0100,
> Eric Auger <eric.auger@redhat.com> wrote:
> > 
> > If the GICv3 supports compat with GICv2, I think you could be able to
> > run both tests consecutively. So maybe don't return?
> 
> You'll need to recreate a full VM though. Even if the HW supports the
> compat mode, our GICv3 emulation doesn't.

I'm not sure how much work would that entail, but sounds like it might
be too much for a selftest.

Thanks,
Ricardo

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
