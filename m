Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29AACC433DB
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 11:49:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A3A22371F
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 11:49:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A3A22371F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDB0A4B19C;
	Fri, 15 Jan 2021 06:49:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jmmpmklNrkbe; Fri, 15 Jan 2021 06:49:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A59B4B17B;
	Fri, 15 Jan 2021 06:49:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE62F4B17B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 06:49:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2FNSG7rGPZLw for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 06:49:30 -0500 (EST)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com
 [209.85.128.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 378264B16D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 06:49:30 -0500 (EST)
Received: by mail-wm1-f49.google.com with SMTP id r4so7332979wmh.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 03:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=3Y7sMMgPPU0z1BRwF7VpVGZTbQ0iTQO/E15b+IMgvcU=;
 b=FBPnFTN4YjNwGEPEgPPb/GKxLm/dByez2tgxihH2QTOTy8WmfoPhVGgCzfn0uuGa8M
 le7S8lSWf3kb+z9kHtBc5PVcqBfHBeT7ib2PNxJY2Zq+w1uLPC3x0ahHXedS8w9r/zSt
 Vr7XG2oq+iz7SGe/QZ797LMLcSlB+4xePegN1OGrgG0MDR0Zv5lR+pIpgvNZDk7aJ/Mb
 hryGKVORma3fI+fujyOofhDDF3qhRqxZnI9GwL3OcFimO/VS6sVPQwpfJAv1jFGmP4Lv
 Q2N79aIUB9MLyG1XUJCCpN+9Hmp8uqgyfbmnUaRhTyj3f6drUti+D/pRLLBEe0/rMZ/F
 u5kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=3Y7sMMgPPU0z1BRwF7VpVGZTbQ0iTQO/E15b+IMgvcU=;
 b=CpMarho7SZS/kvpF2RXYKauXXCdsiEsHDvArj50709BoLPPTCN7vH+dZilEODt5456
 qAbJb8tx8K/UbR1XGpX/TGGhh4+818BX7FVQb4jgw9oMH8YfhKtJzhpc8eh02cURgEll
 MeYYywmXmbY0qDpMYVoWDL24f4tm7PCdmAAvSH6vcqgTyoLGDJFxdgmplzaT8lv3LGMH
 +RUXB5Mw0oadvmTx8S55edtOdipcXlwFTgDFDNm63nJo+g4OKFUZsFrXiANHN4rSathw
 0OsTJ8p93lOi6W/B9Ha6IEBell7kSwqVaVIUphK7+NjYrVXcJZ54K/YOIUY+mC5aTv7k
 QXZA==
X-Gm-Message-State: AOAM533/HIrC+y8VqwfGeNQjG9Zog2soLHlcIklON0n2GF5mM9qPTs+a
 nrvbNhX72hhdqvVGOcKyXbsE2g==
X-Google-Smtp-Source: ABdhPJwWgFLEVnJBIPMEZOTOrpwlHUua4mJ1YrDg7puiVZE13rx4b9mevJ5cGcZlLYSVVXMXEmG+Hw==
X-Received: by 2002:a05:600c:2292:: with SMTP id
 18mr2114867wmf.133.1610711369083; 
 Fri, 15 Jan 2021 03:49:29 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id v20sm15758301wra.19.2021.01.15.03.49.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 15 Jan 2021 03:49:28 -0800 (PST)
Date: Fri, 15 Jan 2021 11:49:25 +0000
From: Quentin Perret <qperret@google.com>
To: Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC PATCH v2 15/26] of/fdt: Introduce
 early_init_dt_add_memory_hyp()
Message-ID: <YAGBRVxOFO+ghZXT@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-16-qperret@google.com>
 <CAL_JsqLmzFWmTc=6JSRMofSEVRx9GCrwGxEsYog9dC16EMGdvQ@mail.gmail.com>
 <X/1xN2UxiUxkzAiN@google.com>
 <CAL_Jsq+5d+Ox_-m_Rd83R9xoZb6e2cxCNfbL8YPzKdwj=y0M8Q@mail.gmail.com>
 <X/2xlxx9Ucp4UZvL@google.com>
 <CAL_Jsq+o+t4YYXEW_nYqMsT4ubYJWe6Kdhu614RtrCqsHBtfLw@mail.gmail.com>
 <X/3LIGgx83XJ+U0F@google.com>
 <CAL_Jsq+SeOrn4qFyFuPUmXdnM1oMNMLWLsDzrYgUt9Ts3hyoNg@mail.gmail.com>
 <X/3TRIkakv9mSHSQ@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <X/3TRIkakv9mSHSQ@google.com>
Cc: devicetree@vger.kernel.org, Android Kernel Team <kernel-team@android.com>,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On Tuesday 12 Jan 2021 at 16:50:12 (+0000), Quentin Perret wrote:
> On Tuesday 12 Jan 2021 at 10:45:56 (-0600), Rob Herring wrote:
> > Umm, yes you are right. But both are dealing with nomap. So someone
> > needs to sort out what the right thing to do here is. No one cared
> > enough to follow up in a year and a half.
> 
> Fair enough, happy to do that. I'll send a small series with these two
> patches independently from this series which may take a while to land.

Now sent:

https://lore.kernel.org/lkml/20210115114544.1830068-1-qperret@google.com/

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
