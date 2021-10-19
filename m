Return-Path: <SRS0=DvdR=PH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A89DDC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 10:37:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 281AF60FED
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 10:37:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 281AF60FED
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96B9B4B0BA;
	Tue, 19 Oct 2021 06:37:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0nGe3i3ivQuh; Tue, 19 Oct 2021 06:37:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AEE44B101;
	Tue, 19 Oct 2021 06:37:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BC1F4B0BA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 06:37:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KxXCZY9ZkoaN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Oct 2021 06:37:12 -0400 (EDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 470BD4B0B4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 06:37:12 -0400 (EDT)
Received: by mail-wr1-f42.google.com with SMTP id e3so46590736wrc.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 03:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=FZvIm3rqsw9MtMgTyCQhjlomP50swDXOySBREOTm/vI=;
 b=lqYGu2It0lmJamUsz5mnal87KJQz57uMl5CRfvm+18bc0CrT5eJE8uEG4IZUc6pnlA
 0sa+wUeQ53R1NMnsWdqyPTf2jltUrEtvss2u5/ih3XNjAlzXUyJaDlCgyUVnPvErq74f
 vL9rk/t1TV3G/Hds1jdViWa7qiwJT5HVmJkFCphsskZhjKZ5Tyu4gVEN61xP7ablAl9Z
 s9CFQ4xovQfHK78E7Ex3F96417dJdj95RCH9xZMUFW2r4dKqU5OKMTQBHZKkgIDjm7yK
 AhIJ6qHYOa8jtn1P1bt+NaN3tJPfyg4wE1/qN7DCSiASNquPcopCqr6Pm9P6vCeScyyP
 CFlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=FZvIm3rqsw9MtMgTyCQhjlomP50swDXOySBREOTm/vI=;
 b=4ihVMGPDcariMM1qCcfvgtpJXd6sjUH8jJ4WF5GnKqU7M4EPCiBN4OyEtYxx+3ybiZ
 DGirtZj7jkm9hj5d7dztB8dwzU20VmT4wTgZdLwxT1KoTFUxUyPKoasdaSWBcybRaCaR
 am/vKCp5hb/JQI7pBuo0iztwfOdoW+3L9Aa+ctSpUpvr7hHuEHj6UqLpAxwX1rRLqf/H
 sxuiN5t3A2CDYN9OzBzYXSVqyWlaDOPhrG4/kfDXIU2+VF+p8NykM7+MbqXmRu4mcLUz
 aGPF59YHxDqR9Lusm+2PiZ73ESVj2nJiZnOIoPiNYU38kfWjr8AewMGAPcNiKYKlNzGz
 bgnQ==
X-Gm-Message-State: AOAM530zY3PwcJyld9LknLf5Divv0uVias5KGYjE7iyfGunnqyi0R9OC
 ipFLJAMOR/RKfzmGlJDUcmJq2Q==
X-Google-Smtp-Source: ABdhPJyz22mwvAWldVTIrGk4wME1SD0IDfWLY0SLLrHbF7nyxwa1vm+zUEcoU6By6FC1N6CX2KlqsQ==
X-Received: by 2002:adf:a2d7:: with SMTP id t23mr44228280wra.156.1634639830990; 
 Tue, 19 Oct 2021 03:37:10 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:59ca:401f:83a8:de6d])
 by smtp.gmail.com with ESMTPSA id n68sm1829366wmn.13.2021.10.19.03.37.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 19 Oct 2021 03:37:10 -0700 (PDT)
Date: Tue, 19 Oct 2021 11:37:08 +0100
From: Quentin Perret <qperret@google.com>
To: Andrew Walbran <qwandor@google.com>
Subject: Re: [PATCH 01/16] KVM: arm64: Introduce do_share() helper for memory
 sharing between components
Message-ID: <YW6f1OxgsY4y16/N@google.com>
References: <20211013155831.943476-1-qperret@google.com>
 <20211013155831.943476-2-qperret@google.com>
 <CA+_y_2HnBqL4wSzxLMwxONj4wMMDT15wOAieb6moN0q474=ENQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+_y_2HnBqL4wSzxLMwxONj4wMMDT15wOAieb6moN0q474=ENQ@mail.gmail.com>
Cc: Android Kernel Team <kernel-team@android.com>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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

Hi Andrew,

On Friday 15 Oct 2021 at 16:11:49 (+0100), Andrew Walbran wrote:
> On Wed, 13 Oct 2021 at 16:58, 'Quentin Perret' via kernel-team
> > +struct pkvm_mem_transition {
> > +       u64                             nr_pages;
> > +
> > +       struct {
> > +               enum pkvm_component_id  id;
> > +               u64                     addr;
> Is this the physical address or the IPA of the initiator? It would be
> good to have a comment explaining.

That's the address in the initiator's address space. For the host and
guests that'll be an IPA (which also happens to be the same as the PA
for the host) and for the hypervisor that'll be an EL2 VA.

But yes, a comment won't hurt, so I'll add something.

<snip>
> > +static int check_share(struct pkvm_page_req *req,
> > +                      struct pkvm_page_share_ack *ack,
> > +                      struct pkvm_mem_share *share)
> > +{
> > +       if (!addr_is_memory(req->phys))
> > +               return -EINVAL;
> > +
> > +       if (req->initiator.state == PKVM_PAGE_OWNED &&
> > +           ack->completer.state == PKVM_NOPAGE) {
> > +               return 0;
> > +       }
> > +
> > +       if (req->initiator.state != PKVM_PAGE_SHARED_OWNED)
> > +               return -EPERM;
> > +
> > +       if (ack->completer.state != PKVM_PAGE_SHARED_BORROWED)
> > +               return -EPERM;
> > +
> > +       if (ack->completer.phys != req->phys)
> > +               return -EPERM;
> > +
> > +       if (ack->completer.prot != share->prot)
> > +               return -EPERM;
> I guess this is the workaround you mentioned for the fact that the
> host can share the same page twice? It might be worth adding a comment
> to explain that that's what's going on.

Yep, that's what is going on here. But FWIW I'm currently reworking the
way we refcount pages in v2, which will now become the host's
responsibility. So, that should simplify things quite a bit at EL2, and
make all of the above go away :-)

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
