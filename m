Return-Path: <SRS0=F5E6=BK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D63C5C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 08:36:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6154020663
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 08:36:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="k0JNm5l+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6154020663
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1CAF4B4C0;
	Fri, 31 Jul 2020 04:36:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f4I7hjoGbd95; Fri, 31 Jul 2020 04:36:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C74804B435;
	Fri, 31 Jul 2020 04:36:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A61FD4B411
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 04:36:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fhVx+cLESzbT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jul 2020 04:36:11 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A536F4B3F6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 04:36:11 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id c80so7867646wme.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 01:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=1i12+x9sAajBXVkYs2kk3lSatTN+twSEPgSSI9Cw0jU=;
 b=k0JNm5l+BC/f3BEyvIRbZVT4kgSe2xXD0n33/nT65AxJzgXp1/v43uJ/SFHgjjg7mO
 CFFlfaJQNhOPWQc1fzDe/SwbancbzxgFcCX/LF2hitT3+QJ8Svmt9R8brUz6zey6cBZw
 PttTj6oVWrcPmwz9MLNJPNR+ZY/wY5mM4g14Ymn73hC5NjOHHyabTXl3vDimu78aFanl
 qiQyhB2r0buGj7ik3LNoTkYxZz7jl9JuVOA6b6jn/k9PH1PSSBcbDQwzj+SxS1tSMhHM
 RBfn4I0tRz215O1WRT32p/yF1hXL0twb6mX9UffHAH741kFIbBVPsa7mIFTBJ5dhyukE
 UpqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=1i12+x9sAajBXVkYs2kk3lSatTN+twSEPgSSI9Cw0jU=;
 b=MjCRMcnPr/CebrPUpx19nN7FoebY8sD4eru9DvyrRaKbhH5NV60wf6s99AR95yi9zy
 qh5ue/3AzT7j3apJ4iTQuersZ1l0ZyNgTi11Z1BLiWli1L8ugvksE7plqH5qcSPgb5Qs
 jOoH+ldDPNQluuDxnS/9MkwZdNZ9Iha8FX5+IuhQrjdbetMKgb8GMDWxMFX1JUxidKIl
 1VE7+mN9jLvyIzT0FPk3RxAZwHZR5PS++sk84uOYAylXOiXDDbN22IhFzGsQx3bHrHbb
 zE88CgxlsymRH3/Fy8AB2ykJIeEX3B0S9BguTv6Qkq57jXwuLduWIfmaTYVnYVKwcPvu
 ZagA==
X-Gm-Message-State: AOAM533LMkNQ0klMq16df6+4pwUz786CMyoZ4B70UJci4G3twfKL+I/O
 DRCrIZWE26E43ZPsdYNf2skWtw==
X-Google-Smtp-Source: ABdhPJxAfdB+rX+zmqNuwo0EkTqS+dEqxJvUq8wuo1WYJcB9nd/M5N0dst+qSxkjPDhJrDsaMnNhug==
X-Received: by 2002:a1c:c90d:: with SMTP id f13mr2948544wmb.107.1596184570558; 
 Fri, 31 Jul 2020 01:36:10 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:110:f693:9fff:fef4:a7ef])
 by smtp.gmail.com with ESMTPSA id x11sm11139507wmc.33.2020.07.31.01.36.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 31 Jul 2020 01:36:10 -0700 (PDT)
Date: Fri, 31 Jul 2020 09:36:06 +0100
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 02/20] KVM: arm64: Add support for creating
 kernel-agnostic stage-1 page tables
Message-ID: <20200731083606.GA3213389@google.com>
References: <20200730153406.25136-1-will@kernel.org>
 <20200730153406.25136-3-will@kernel.org>
 <20200731081436.GA3201636@google.com>
 <20200731081911.GB3201636@google.com>
 <20200731082208.GA26291@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200731082208.GA26291@willie-the-truck>
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

On Friday 31 Jul 2020 at 09:22:15 (+0100), Will Deacon wrote:
> No, I think you're right. The hyp stage-1 PGD is always a single page, so I
> can simplify the free() path.

OK, cool. The current code does support concatenated pgds for the hyp
stage 1, which is what confused me. Would you mind adding something to
the commit message explaining why this is no longer needed or something?
Or at least mention it here so I understand :) ?

> At one point, I had a common free() path for
> stage-1 and stage-2, but that didn't last very long, as the stage-2
> page-table pages are refcounted so you end up having to deal with them
> differently anyway.

Right, though refcounting the pages for stage 1 might be a good idea
too. The current code does it, and I think we'll need it later on for
the Protected KVM stuff as unmap() will be needed for stage 1 as well.
I'm fine if this is done in a separate series, though. I don't think we
need any of that just yet, so we can definitely start 'simple'.

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
