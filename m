Return-Path: <SRS0=F5E6=BK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 275D3C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 09:06:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A11E2072A
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 09:06:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="EWh7IJaM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A11E2072A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 033CC4B32A;
	Fri, 31 Jul 2020 05:06:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bIL3DmoDP-kZ; Fri, 31 Jul 2020 05:06:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFD8F4B259;
	Fri, 31 Jul 2020 05:06:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20BC84B24E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 05:06:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uMLPCdsx7FuJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jul 2020 05:06:07 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C1754B24B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 05:06:07 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id z18so23735053wrm.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 02:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Wbqwu14CJWqaCsIPQRvM9lH8xOUyh5e7i0yP7FNWtMs=;
 b=EWh7IJaMH2S7si14BTwbKvkNHkDgvvga37eqLZbRuSkWtPVRabrA2mAXOjwTZG4y9e
 LuMgSAry3lc93ZP+8ErwAl/ChWnb35EyTzuD7CMgvz8TeXZMDw49gJGWg27uOk1R2sjJ
 RBVGnzZdS5Rg+1xfbxRAlar+5D1mcSS0Z3dLynFExv01yhEG5wuYxItT7n50+Hv7e/CH
 BI5Iexj2+6WRoVZyAtdN/UWo3J9nYB4pRZ8kDA984SDA8WbflQfc67deoA5tLxZZGa3J
 maqTJ4CEVarRx/KvLcusS1PZyD/lWnc3cSvdAbqHjVoboPYvFjbqab+gBL6YJd3ahvJs
 WsSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Wbqwu14CJWqaCsIPQRvM9lH8xOUyh5e7i0yP7FNWtMs=;
 b=jXzX95LM9bdqNitLrtAD73zwIaNjSN0nTP8d0+I7FysxoaqaBe62VnJmXQX17WWnrH
 LsfGbZiZQX5cMaLPHFd0QGSEe5bGT2oiKBcprmki5ayfAriCMnibTeKDYRPh3UY334Bx
 scMfHUWAusLafk+nCSbhZbG8XUZd6QqLQyHrUKrY49YxHIJ1P41hM40YipgRKjDA4YDT
 R6JcFuUxI6n8DuE0A8hqIIlnGlXG0j7Tbf2Z5YAGrtQM+C+uw9e02zIH1JxFGqZ4A12i
 j3mGbHwWeHAWCjTfdlEEIM9Rzs6iKUbPHJ7gNN9JOzBvoDiS/ly3DFzQIF2+IRqJv///
 qaiQ==
X-Gm-Message-State: AOAM533BOWjm06Y6a5zZLu3xphYLiw7oYezRmDk1xC+/Cn8ppIWkexCn
 AnLYH584ynk0IOzogBBWaRJBOQ==
X-Google-Smtp-Source: ABdhPJxXQ8QfkB/+PRfxHvJpWFMJFgoqCOhixmVk78g76KMFX4U5zJc8u3kPa4/aHk1cWsxpQhD7Tw==
X-Received: by 2002:a5d:6cd0:: with SMTP id c16mr2609567wrc.121.1596186365978; 
 Fri, 31 Jul 2020 02:06:05 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:110:f693:9fff:fef4:a7ef])
 by smtp.gmail.com with ESMTPSA id l7sm3329512wrf.32.2020.07.31.02.06.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 31 Jul 2020 02:06:05 -0700 (PDT)
Date: Fri, 31 Jul 2020 10:06:02 +0100
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 02/20] KVM: arm64: Add support for creating
 kernel-agnostic stage-1 page tables
Message-ID: <20200731090602.GA3233589@google.com>
References: <20200730153406.25136-1-will@kernel.org>
 <20200730153406.25136-3-will@kernel.org>
 <20200731081436.GA3201636@google.com>
 <20200731081911.GB3201636@google.com>
 <20200731082208.GA26291@willie-the-truck>
 <20200731083606.GA3213389@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200731083606.GA3213389@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Friday 31 Jul 2020 at 09:36:06 (+0100), Quentin Perret wrote:
> On Friday 31 Jul 2020 at 09:22:15 (+0100), Will Deacon wrote:
> > No, I think you're right. The hyp stage-1 PGD is always a single page, so I
> > can simplify the free() path.
> 
> OK, cool. The current code does support concatenated pgds for the hyp
> stage 1, which is what confused me. Would you mind adding something to
> the commit message explaining why this is no longer needed or something?
> Or at least mention it here so I understand :) ?

Scratch that, this makes no sense. We obviously don't support that, it's
just the current code that highly confused me. Sorry fot the noise.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
