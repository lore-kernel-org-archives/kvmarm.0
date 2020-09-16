Return-Path: <SRS0=cLXx=CZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB524C433E2
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 12:40:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 216D622240
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 12:40:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="QehNvtX2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 216D622240
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 783A84B387;
	Wed, 16 Sep 2020 08:40:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cNc0sIdAQ6UQ; Wed, 16 Sep 2020 08:40:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 933F64B3DD;
	Wed, 16 Sep 2020 08:40:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71D124B2E2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 08:40:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M9NRHROWQ54U for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2020 08:40:48 -0400 (EDT)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com
 [209.85.128.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 74A164B23A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 08:40:48 -0400 (EDT)
Received: by mail-wm1-f54.google.com with SMTP id w2so2638506wmi.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 05:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=SHWTqsRrpvdPx0tBOPELgE5HkWuQTwHGc/3aI5QE1HY=;
 b=QehNvtX2SryaVlrh3oRpLKvQXaA321J8J2rWE9nBVHLPUgI50PzqYEAcIABF380PtC
 9NDRWzgncEP4mNNOlban8PDvDL3FswoMuuayj43rhl2+HUxXOjVL4XW+VclSGMdA2Og8
 GE1XRR+LNnVc2sBlNMBhTJ+mGrWaZtP+tSLTYIP3RQRjsEmctstJK2cuxjdbE6gjknON
 q/PrKStFzGteU3RCiUUzijYZu4vWgo2JYbOm/2xX9M5Y6ptZZzPkdW7aN380hBPAbV/n
 5nqrdkvrNbRtueRtfWsbTNFvSh6Qx9L7B7C5Q5gMhhctF8cYq9ZRRPQMNzZD6znaGJK8
 xjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=SHWTqsRrpvdPx0tBOPELgE5HkWuQTwHGc/3aI5QE1HY=;
 b=SsrEk9vOiCvY3TRncURSAUcr6Hai2sPNTPw7gkCF3MgbqEin6fQZY5Acfbxmp2VuGN
 3l6wg4PEDMVePipcGX/0j4uY4JuZdZEzUPeKHk6jYG1t7Re1qa/I2AyNFx+9mw+QHk5L
 KXRUh2oO9gRq/HuM70ni9qjLIF124PAOCzLs3B+sMSFony1BDLDFjrgLRgqCtSJJ1+fi
 ti1YV3do0yZrRb42/OW1EBF7I91w0t31ECNI6vWlTaORxXKxCR9DOk7RAmVDbX4OJ35U
 FsHkyh8KQX2fnPEv9K8Wb42sUFpcrVtZ6bsl1M0ooaN63mxj7LGnczRnwWAcaCl5Rz8x
 IYEA==
X-Gm-Message-State: AOAM531zYfq8h0Hw4oQoBZOoWF6MZHnAN+GnMetg9Z/xUSFJlS15iR9Z
 WwOFA/RJ9WiMWVWIUeY2ShuJZw==
X-Google-Smtp-Source: ABdhPJwA4P8SpiiyN27RMOw1Mmmvb2s4C9MzoRrI8V/f6GP5+OmiwBGeC9tuLCDkSa/+obWc5Z4Rmg==
X-Received: by 2002:a1c:f415:: with SMTP id z21mr4520772wma.88.1600260047425; 
 Wed, 16 Sep 2020 05:40:47 -0700 (PDT)
Received: from google.com ([2a01:4b00:8523:2d03:e49d:f6be:d31b:ad3c])
 by smtp.gmail.com with ESMTPSA id 10sm5250595wmi.37.2020.09.16.05.40.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Sep 2020 05:40:46 -0700 (PDT)
Date: Wed, 16 Sep 2020 13:40:45 +0100
From: David Brazdil <dbrazdil@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 00/10] Independent per-CPU data section for nVHE
Message-ID: <20200916124045.stlrdh5lvedpzab4@google.com>
References: <20200903091712.46456-1-dbrazdil@google.com>
 <20200914174008.GA25238@willie-the-truck>
 <20200916115404.rhv4dkyjz35e4x25@google.com>
 <20200916122412.elxfxbdygvmdgrj5@google.com>
 <20200916123913.GA28056@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200916123913.GA28056@willie-the-truck>
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

> >  SECTIONS {
> >         HYP_SECTION(.text)
> > -       HYP_SECTION(.data..percpu)
> > -       HYP_SECTION(.data..percpu..first)
> > -       HYP_SECTION(.data..percpu..page_aligned)
> > -       HYP_SECTION(.data..percpu..read_mostly)
> > -       HYP_SECTION(.data..percpu..shared_aligned)
> > +
> > +       .hyp..data..percpu : {
> 
> Too many '.'s here?
Oops

> 
> > +               __per_cpu_load = .;
> 
> I don't think we need this symbol.
True

> 
> Otherwise, idea looks good to me. Can you respin like this, but also
> incorporating some of the cleanup in the diff I posted, please?

On it! :)

David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
