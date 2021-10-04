Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E10C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 10:05:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 35B7D61425
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 10:05:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 35B7D61425
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D2694B262;
	Mon,  4 Oct 2021 06:05:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K72GbgQKlUtI; Mon,  4 Oct 2021 06:05:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C8E94B264;
	Mon,  4 Oct 2021 06:05:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AE5D4B256
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 06:05:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q+HewEKPg455 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 06:05:18 -0400 (EDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
 [209.85.128.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CFDE64B205
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 06:05:17 -0400 (EDT)
Received: by mail-wm1-f45.google.com with SMTP id
 m14-20020a05600c3b0e00b0030d4dffd04fso7284347wms.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 03:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=vbaYN6Cj0naTpTKsC/ilkJz/q62BHSUwgRaYb1zy820=;
 b=LluNYf2Z05QVWW3ZMGQu7ViGnKRokxh8x9obFg78/LobCRNeHuSjcYtPJ8nsGZ7Y3a
 oSErIdBzV56H4zULb8mhOSjzbHshp2yY/bbB1Ckja475D5j27k9cpbv4SqaKqOrSR106
 K5uwNEZobD09+yLG0U8fGSijBJLNmaiHW8pGKM0ZDc+Nc4NVFkhg9eVxEoimDsmjUAUW
 5SnFBm7ycmllCe9LrxSMfJTbgawR/68sw41PAZa1BungeaKMjD2rC7cXR0GjePmdYpo1
 hfxUumMppw/hJxPsrh8wIaAVleboSvxMSBPzKwoL1RZOcQrCxmUAnAe+CBFw6QufGT93
 ncGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=vbaYN6Cj0naTpTKsC/ilkJz/q62BHSUwgRaYb1zy820=;
 b=qoVirU7r6JVE1dWqGbp5FJQusYXem1wD2b1oGmiZOxxEMRtK59AgsL3HIGToS3dwBC
 LzApbIc4Ei1Al8uznv7eScqj5THcXbtUa6tDHTP93+UBmBWMmtfIHXgwyl8HdkctyNFS
 mMrePV0Qr+5dfuFmrBJgwXqP5vcRUY+CxRYNbITJQbaUS0OtN55LWnGwBe61yRuuQnqS
 NPpP2G3A8SZkG8OpUFsYCvbnTl2++u0ZvgWRxHC6pB2wRbqK/LOGZVHa1SGRcL9++i+Z
 Os9eqj7nrSIoQrTrooG5yslm8m1VC0o8rhoI3Cdy3xw5yyeqfvSA/UYXK05htvTVcTHG
 6z0A==
X-Gm-Message-State: AOAM531YRLBLqMI2s3Qpy64DGI/K3eM1u5UNqftW17unFLR9u3Dx5v1Y
 58T+1wipw61cVkcKXF6vLQ6r3A==
X-Google-Smtp-Source: ABdhPJzctEI2RjiPKdjlUZAMqkTfZuBtvB97o4FGjBX56pMR2EnD7CcYgItKQi/sFeYGsYqR7QX98w==
X-Received: by 2002:a1c:f70a:: with SMTP id v10mr18110666wmh.3.1633341916520; 
 Mon, 04 Oct 2021 03:05:16 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:669b:5b16:60b7:a3d4])
 by smtp.gmail.com with ESMTPSA id d2sm8169477wrs.73.2021.10.04.03.05.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Oct 2021 03:05:16 -0700 (PDT)
Date: Mon, 4 Oct 2021 11:05:12 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/2] KVM: arm64: Fix host stage-2 PGD refcount
Message-ID: <YVrR2M8OmU6ug1Yk@google.com>
References: <20211004090328.540941-1-qperret@google.com>
 <20211004090328.540941-2-qperret@google.com>
 <87bl45ru66.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87bl45ru66.wl-maz@kernel.org>
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

Hey Marc,

On Monday 04 Oct 2021 at 10:55:13 (+0100), Marc Zyngier wrote:
> Hi Quentin,
> 
> On Mon, 04 Oct 2021 10:03:13 +0100,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > The KVM page-table library refcounts the pages of concatenated stage-2
> > PGDs individually. However, the host's stage-2 PGD is currently managed
> > by EL2 as a single high-order compound page, which can cause the
> > refcount of the tail pages to reach 0 when they really shouldn't, hence
> > corrupting the page-table.
> 
> nit: this comment only applies to the protected mode, right? As far as
> I can tell, 'classic' KVM is just fine.

Correct, this really only applies to the host stage-2, which implies
we're in protected mode. I'll make that a bit more explicit.

> > Fix this by introducing a new hyp_split_page() helper in the EL2 page
> > allocator (matching EL1's split_page() function), and make use of it
> 
> uber nit: split_page() is not an EL1 function. more of a standard
> kernel function.

Fair enough :)

> > from host_s2_zalloc_page().
> > 
> > Fixes: 1025c8c0c6ac ("KVM: arm64: Wrap the host with a stage 2")
> > Suggested-by: Will Deacon <will@kernel.org>
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/gfp.h |  1 +
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 +++++-
> >  arch/arm64/kvm/hyp/nvhe/page_alloc.c  | 14 ++++++++++++++
> >  3 files changed, 20 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> > index fb0f523d1492..0a048dc06a7d 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
> > @@ -24,6 +24,7 @@ struct hyp_pool {
> >  
> >  /* Allocation */
> >  void *hyp_alloc_pages(struct hyp_pool *pool, unsigned short order);
> > +void hyp_split_page(struct hyp_page *page);
> >  void hyp_get_page(struct hyp_pool *pool, void *addr);
> >  void hyp_put_page(struct hyp_pool *pool, void *addr);
> >  
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index bacd493a4eac..93a79736c283 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -35,7 +35,11 @@ const u8 pkvm_hyp_id = 1;
> >  
> >  static void *host_s2_zalloc_pages_exact(size_t size)
> >  {
> > -	return hyp_alloc_pages(&host_s2_pool, get_order(size));
> > +	void *addr = hyp_alloc_pages(&host_s2_pool, get_order(size));
> > +
> > +	hyp_split_page(hyp_virt_to_page(addr));
> 
> The only reason this doesn't lead to a subsequent memory leak is that
> concatenated page tables are always a power of two, right?

Indeed, and also because the host stage-2 is _never_ freed, so that's
not memory we're going to reclaim anyway -- we don't have an
implementation of ->free_pages_exact() in the host stage-2 mm_ops.

> If so, that deserves a comment, because I don't think this works in
> the general case unless you actively free the pages that are between
> size and (1 << order).

Ack, that'll probably confuse me too in a few weeks, so a comment won't
hurt. I'll re-spin shortly.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
