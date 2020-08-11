Return-Path: <SRS0=6J9q=BV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5900C433DF
	for <kvmarm@archiver.kernel.org>; Tue, 11 Aug 2020 14:43:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 20F09206C3
	for <kvmarm@archiver.kernel.org>; Tue, 11 Aug 2020 14:43:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="CIvG2e2O"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20F09206C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 702974B5AF;
	Tue, 11 Aug 2020 10:43:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xYdad8tPsIsw; Tue, 11 Aug 2020 10:43:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 715854B5B1;
	Tue, 11 Aug 2020 10:43:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 452B64B5B1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2020 10:43:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2RPkQOieQRBy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Aug 2020 10:43:11 -0400 (EDT)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 372F24B5AF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2020 10:43:11 -0400 (EDT)
Received: by mail-wr1-f66.google.com with SMTP id a15so11697892wrh.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2020 07:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=IWyJnO5S862BoK672zrKi6xDfjCQI+aKpH0XfhIVW/4=;
 b=CIvG2e2OY18vbNS69gX3b3IxrfstEOKKJUtD9t1/iVMCwC6eKt6YTLDBa8RU8vMfeC
 PC5XrAtUlj+3iEM06pDKWGcVuuOQXKdIg0sKriw7pb+ovZcHQXy6JymgvXq5U3uClaSP
 vMczZoV47csK94rAzQ9rt4NWRFCiKxl1FCm5l/nR6QYVwSkg1D1dY7MPbhkZMa091/gO
 7yPKiWe0gC840khQz6sXxMwZZF7dajnZMcCrdjTQW2HyfYFOcqWwEYDYzPl9PwGXwh6O
 fYasU3j2OX0dh4GbseRzubUcSgScghG7uC8W+SJjaHKrM43tvnI17yWamB4EfUZYnQts
 phyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=IWyJnO5S862BoK672zrKi6xDfjCQI+aKpH0XfhIVW/4=;
 b=cRirvkP08ZjcUeoTh2LC987Vl3Du1qvUxQVz3S5QDMt3vD2mrSy4DygUuPJZTa4fTL
 NJz4b787GA9rvkdBiaeVfOD/wuZWUn8EMvQMHtOBxXUMZauOg4yqQIROcTSHvQUn42Sq
 fkg2UEAzm8rpVXgpUSaRrntMOQ7oOzgpQX+oyWmj758t5bEsPSkM4L/8f+3LWbA2JsrB
 P6SethpOCYdrrL4PYWQCznSgiZj9O2DlzppMImeK6ZIOz23qnd6IwSQEhWzY/Q213dWt
 360tGsYnYe5rMg9oWLbyq7Fy190rHV99dUP/t79acd7WCwiq4ciFMvBxASm2QaSUjCYu
 8zmg==
X-Gm-Message-State: AOAM531dwzQkRPwpsgT/nxpwS5shgFcU2aQ4/VPQ//i74nl+MrRFwRfd
 8xwyuX5rQkOGqk+HpkA/fRi04Q==
X-Google-Smtp-Source: ABdhPJwzmsPtn2u1xgXFRPm4sJcVx0ge9+cPb4n+3sXTYU6WaD0seLZSCVz5tpl3RFd0EZVfYKfmbg==
X-Received: by 2002:adf:9ed4:: with SMTP id b20mr29729026wrf.206.1597156989956; 
 Tue, 11 Aug 2020 07:43:09 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id l11sm5403059wme.11.2020.08.11.07.43.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 11 Aug 2020 07:43:08 -0700 (PDT)
Date: Tue, 11 Aug 2020 15:43:04 +0100
From: Andrew Scull <ascull@google.com>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 2/2] KVM: arm64: nVHE: Don't consume host SErrors with RAS
Message-ID: <20200811144304.GA2917393@google.com>
References: <20200730151823.1414808-1-ascull@google.com>
 <20200730151823.1414808-2-ascull@google.com>
 <0cbb075a-ab5b-92a2-35bb-c3abb292ac84@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0cbb075a-ab5b-92a2-35bb-c3abb292ac84@arm.com>
Cc: kernel-team@android.com, catalin.marinas@arm.com, maz@kernel.org,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Wed, Aug 05, 2020 at 03:33:22PM +0100, James Morse wrote:
> Hi Andrew,
> 
> On 30/07/2020 16:18, Andrew Scull wrote:
> > The ESB at the start of the vectors causes any SErrors to be consumed to
> > DISR_EL1. If the exception came from the host and the ESB caught an
> > SError, it would not be noticed until a guest exits and DISR_EL1 is
> > checked. Further, the SError would be attributed to the guest and not
> > the host.
> 
> Yup, this happens because the world has moved underneath this code:

That's understandable!

> Previously any v8.2 RAS capable system would have been crazy to turn off VHE, so v8.0 and
> v8.1 systems had a nop here instead, and v8.2 systems had VHE, so there were no 'from the
> host' EL2 vectors.

RAS with nVHE is a buildable config and we're being foolish enough to
think about it so hopefully we can work something out :)

> > To avoid these problems, use a different exception vector for the host
> > that does not use an ESB but instead leaves any host SError pending. A
> > guest will not be entered if an SError is pending so it will always be
> > the host that will receive and handle it.
> > 
> > Hyp initialization is now passed the vector that is used for the host
> > and the vector for guests is stored in a percpu variable as
> > kvm_get_hyp_vector() is not suitable for calling from nVHE hyp.
> 
> > Fixes: 0e5b9c085dce ("KVM: arm64: Consume pending SError as early as possible")
> 
> Surely this can only happen if you had turned VHE off?

Correct, I'll make that clearer in the description.

> Thanks,
> 
> James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
