Return-Path: <SRS0=VrFD=6U=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28698C38A24
	for <kvmarm@archiver.kernel.org>; Wed,  6 May 2020 10:11:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A3E3520747
	for <kvmarm@archiver.kernel.org>; Wed,  6 May 2020 10:11:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="gV9RfLlu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A3E3520747
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E61C4B2AB;
	Wed,  6 May 2020 06:11:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UU5tCXkwZLeS; Wed,  6 May 2020 06:11:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13AC74B2B2;
	Wed,  6 May 2020 06:11:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 664824B2A7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 May 2020 06:11:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Uqt9qD7DHGNv for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 May 2020 06:11:22 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1ED4A4B275
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 May 2020 06:11:22 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id v8so4576494wma.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 May 2020 03:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=CZGxVEINRFfXco4KoTv4rMN52n6V3TJRcAbrE28fW9I=;
 b=gV9RfLluzH10SNhxg/ntUX82VqQaIDxo5hreeCRlMY9MSi58DD1Rdv8yrkNnxMUNdc
 lqqVgDIDm3KKLgwIIfqxX9p7vAryeLm1fKw2t1OPaSbqw8YrMfm1wrFSJ7BawFFe5mII
 XVVAXr9hAmR1dSQMhxBFiMv+jFhDF5JgqnK8YOlezXRMvHPp7CiEqnjwQJeUJc8TTebd
 xyl4YYbHvzEgaYk8eLDwc8AsaW5okMx3l4dFvMInLPONGXPKs4yAL1bV1he8DCSqr8sv
 7DlRNJpYJsXkdlD8kNP0c6Uo5Q58EVfFd0/sng6OXjXzWFH9lZOn8SHyFXSXYRRuDR80
 Esfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=CZGxVEINRFfXco4KoTv4rMN52n6V3TJRcAbrE28fW9I=;
 b=rLvzvrLtE4w6QK+2tvtM8alXMKOyfMuXGFnzkzLsVk8Uyr0L/1sV6oUoD0jKUQVD2i
 /Udr5Ll3cx8Mi3vhrClTjgSZPJF5HftdiIkyprr3DjuO5sNgomMAKRRTizhJ65VaJTsq
 FHLAryZkdiEed87JEDJtKKLah5qMTL0L4T3mIrPh1ESqdbHwgZwyMXAekkeo9o9v/EoY
 R01t66P4u7mvSI1dH14OgcV8v2CgcISOAj7KZQhn+jM/JleyvJGM1zIfFi+arxMCbZlx
 nK4fxN8fuDc+2kh9cr3QqXu9oau9oq49ES6DFEEp1BjWs69y2teO3ZOMRZUEVuOUbPUE
 Fhsw==
X-Gm-Message-State: AGi0Pua//l1MZ1ikFLiLR4NjyTrl+exFcItQ/RqM1c9HcFhFo84lRtMU
 OABFCSp6jZOqEYKHZx49T7y0Qw==
X-Google-Smtp-Source: APiQypID1DXJTOWcDNEDu4jVNP7gVAm/OBszOGtJjHaEN3aiIon6FlVQi2/8ZdUD+TQYi0xLYGD29A==
X-Received: by 2002:a7b:ce88:: with SMTP id q8mr3737522wmj.161.1588759880879; 
 Wed, 06 May 2020 03:11:20 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
 by smtp.gmail.com with ESMTPSA id q8sm2109623wrp.58.2020.05.06.03.11.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 May 2020 03:11:19 -0700 (PDT)
Date: Wed, 6 May 2020 11:11:15 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 05/26] arm64: Document SW reserved PTE/PMD bits in
 Stage-2 descriptors
Message-ID: <20200506101115.GF237572@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-6-maz@kernel.org>
 <20200505155916.GB237572@google.com>
 <8b399c95ca1393e63cc1077ede8a45f6@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8b399c95ca1393e63cc1077ede8a45f6@kernel.org>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
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

On Wed, May 06, 2020 at 10:39:59AM +0100, Marc Zyngier wrote:
> Hi Andrew,
> 
> On 2020-05-05 16:59, Andrew Scull wrote:
> > On Wed, Apr 22, 2020 at 01:00:29PM +0100, Marc Zyngier wrote:
> > > Advertise bits [58:55] as reserved for SW in the S2 descriptors.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/include/asm/pgtable-hwdef.h | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/arch/arm64/include/asm/pgtable-hwdef.h
> > > b/arch/arm64/include/asm/pgtable-hwdef.h
> > > index 6bf5e650da788..7eab0d23cdb52 100644
> > > --- a/arch/arm64/include/asm/pgtable-hwdef.h
> > > +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> > > @@ -177,10 +177,12 @@
> > >  #define PTE_S2_RDONLY		(_AT(pteval_t, 1) << 6)   /* HAP[2:1] */
> > >  #define PTE_S2_RDWR		(_AT(pteval_t, 3) << 6)   /* HAP[2:1] */
> > >  #define PTE_S2_XN		(_AT(pteval_t, 2) << 53)  /* XN[1:0] */
> > > +#define PTE_S2_SW_RESVD		(_AT(pteval_t, 15) << 55) /* Reserved for
> > > SW */
> > > 
> > >  #define PMD_S2_RDONLY		(_AT(pmdval_t, 1) << 6)   /* HAP[2:1] */
> > >  #define PMD_S2_RDWR		(_AT(pmdval_t, 3) << 6)   /* HAP[2:1] */
> > >  #define PMD_S2_XN		(_AT(pmdval_t, 2) << 53)  /* XN[1:0] */
> > > +#define PMD_S2_SW_RESVD		(_AT(pmdval_t, 15) << 55) /* Reserved for
> > > SW */
> > > 
> > >  #define PUD_S2_RDONLY		(_AT(pudval_t, 1) << 6)   /* HAP[2:1] */
> > >  #define PUD_S2_RDWR		(_AT(pudval_t, 3) << 6)   /* HAP[2:1] */
> > > --
> > > 2.26.1
> > > 
> > > _______________________________________________
> > > kvmarm mailing list
> > > kvmarm@lists.cs.columbia.edu
> > > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> > 
> > This is consistent with "Attribute fields in stage 1 VMSAv8-64 Block and
> > Page descriptors"
> 
> Do you mean "stage 2" instead? The reserved bits are the same, but I want
> to be sure we have looked at the same thing (ARM DDI 0487F.a, D5-2603).

My turn for the copy-paste bug, yes "Attribute fields in stage 2
VMSAv8-64 Block and Page descriptors". And conviniently the same bits
are reserved for SW in both.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
