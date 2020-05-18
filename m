Return-Path: <SRS0=o21O=7A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0AF2C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 16:43:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2A5A1207E8
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 16:43:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="t5kbJ8vE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A5A1207E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 863A64B151;
	Mon, 18 May 2020 12:43:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B3QIvBKWHw38; Mon, 18 May 2020 12:43:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A78E4B162;
	Mon, 18 May 2020 12:43:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68E754B150
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 12:42:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d+wAv-qFvfTf for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 May 2020 12:42:57 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F32A4B14F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 12:42:57 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id 50so12612908wrc.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 09:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:date:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=l7z6K0amO/UJk176kcJX4YeJlctfObnJzJsw8pKe4sQ=;
 b=t5kbJ8vEQ29jXrypKtW3eJgqbsxD4z/bPK/nPLvx1ZJJGdVY79R33x66hal4j53Dr3
 wfI41HluahUWCRhpDePMjy/Fmt7gXAHOX2Vj+m7i6uT7LNk1CW2NuqBhL2wnPWG8M/K6
 ZfTiJ4TzIrY9qDOmQ6u+zRo0jx9Fz6R7MJeVPtAWDHtaQmY+j6ZA0GOIcc5EPHkRjJkv
 hrsONuz0sTr4YL0NvVUVKzFickAjmDOkC5vxwPnkTV0clhri3E1bXds2SZq6FLpTAzK1
 4wI1CT8Qwnamr/v2pa27pFL0xCHq5rDzQ0JNtjk1KZxr/ikAms2TvFDyiczEIdvmOlpT
 M9eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:date:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=l7z6K0amO/UJk176kcJX4YeJlctfObnJzJsw8pKe4sQ=;
 b=lwaAf+DE568ohPwSLd6bj0SbZhWAnuXFRbv2dRpONCLv262zsJn5NRZD82B2J0kUpF
 rkHPfUhiT8YjWDlf+6IyJY2HLilWsMZkU4NosTx6DyQu/IvOWLLhNiUbFZCfZD/58fo3
 u9nPoJjpS1b9et5FMn6WJqVptps2NHPd6RpNccLGW8+MdQ/R8jhw81wiqJHy/9OEdOgG
 JG4XwZkuogU53QuhtNmO+6N8O5lr6h8vv0oLNdNbW0sOrae12M3CfJAuc7FJRZBsJkqN
 RG/Deai7K4YnMq2/Et+8AKkrJFfQ3SkXkvpgcIhuOUoH9MeftHTAU3AwnAX8ZhZR4wO8
 daDA==
X-Gm-Message-State: AOAM532UMxsaasAJLxOMd0txdw6r1yC1kl3NVDzTtStxVw4B7nPILuFM
 jmHLlM29AKyqbAf/sJtmnrL3hA==
X-Google-Smtp-Source: ABdhPJx0XDQyf7zT0sv6Q3paDSxLsaxOBCpajY4Yvk08GG2KYWSgZT6Ac/ffdWmbevL3HdDikI5PEw==
X-Received: by 2002:a05:6000:1252:: with SMTP id
 j18mr10965847wrx.3.1589820175994; 
 Mon, 18 May 2020 09:42:55 -0700 (PDT)
Received: from dbrazdil-macbookpro.roam.corp.google.com
 ([2a01:4b00:8523:2d03:4431:2de6:16f:7f90])
 by smtp.gmail.com with ESMTPSA id v24sm106645wmh.45.2020.05.18.09.42.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 May 2020 09:42:55 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
X-Google-Original-From: David Brazdil
 <dbrazdil@dbrazdil-macbookpro.roam.corp.google.com>
Date: Mon, 18 May 2020 17:42:54 +0100
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH v2 04/14] arm64: kvm: Add build rules for separate nVHE
 object files
Message-ID: <20200518164254.b26ankme6pb6ijqr@dbrazdil-macbookpro.roam.corp.google.com>
References: <20200515105841.73532-1-dbrazdil@google.com>
 <20200515105841.73532-5-dbrazdil@google.com>
 <20200518155553.GB147668@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200518155553.GB147668@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On Mon, May 18, 2020 at 04:55:53PM +0100, Andrew Scull wrote:
> On Fri, May 15, 2020 at 11:58:31AM +0100, David Brazdil wrote:
> > diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> > index 7f06ad93fc95..13850134fc28 100644
> > --- a/arch/arm64/kernel/image-vars.h
> > +++ b/arch/arm64/kernel/image-vars.h
> > @@ -51,4 +51,16 @@ __efistub__ctype		= _ctype;
> >  
> >  #endif
> >  
> > +#ifdef CONFIG_KVM
> > +
> > +/*
> > + * KVM nVHE code has its own symbol namespace prefixed by __hyp_text_, to
> > + * isolate it from the kernel proper. The following symbols are legally
> > + * accessed by it, therefore provide aliases to make them linkable.
> > + * Do not include symbols which may not be safely accessed under hypervisor
> > + * memory mappings.
> > + */
> 
> nit: the prefix is not '__kvm_nvhe_' rather than '__hyp_text_'

Thanks, will fix in v3.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
