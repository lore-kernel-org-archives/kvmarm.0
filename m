Return-Path: <SRS0=ZMJ6=GP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB00C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 16:50:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 697DA2311B
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 16:50:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 697DA2311B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B6E64B212;
	Tue, 12 Jan 2021 11:50:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wRo7rTTya96h; Tue, 12 Jan 2021 11:50:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8F4A4B21A;
	Tue, 12 Jan 2021 11:50:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E12204B212
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 11:50:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UzZqo4IczyfV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jan 2021 11:50:16 -0500 (EST)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6AAB4B1CC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 11:50:16 -0500 (EST)
Received: by mail-wr1-f47.google.com with SMTP id r3so3243546wrt.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 08:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=90x7bSE6XP8JZlzynOLHF7U7UF119XCh3OM9LGBjMTs=;
 b=VeV7Bhbi83JAOnTWd71Dy939nVpu0J42s1sPM4bsu44fgHA910w59T24ByGjHj2k7B
 WWcR3YELkWLB8XK50PnnLR4gfbh2NKfaOsRVUn+dnMDddWD94eB53iViry2J/gyWkcs0
 iJrpCk9E/iZdoRBdsSr9jcGh+i1jdxEbRpW0iuqqpLPYkphnlVHvQJvcrnltVRybFdOn
 CeiDSnZKMNQkaEQtyGiNRx725KRfnaSPh9WtwkAxESUeeR0pz2L2tqZWhAy0q+Vck8Sb
 fQIfk204viOE/LY5i8CJlXl4RXPqVJXSoZKPs933VKUmcHwgdQIcOmDmjiDThspf0U0c
 /gCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=90x7bSE6XP8JZlzynOLHF7U7UF119XCh3OM9LGBjMTs=;
 b=l66gfL/e5dv0NLpxHs18m1GO6doiQ2Ed5yvTfXIRKdlI+Ql/DupWfxaN0insv7oFPY
 +h5luMx4cFQd7iu39WnBjs/n+xbxxif0AdfngIkWpZkSTuGlCm3uICE+WdBabLIBS+eh
 OlNd4A0Mj43civ/8h22SYVy8VnxBZ+kKqkkyLPTZwNMYWW0++Dx7Et9AtV6LsRsQ1j4k
 LR33MJa2aokHjL1ILS6NldgJZ0/lVRHOkdM4+lzH2LFVnoF5loecNdT+JGTZGVb0DVdq
 KaXr3uplF1dykqWSl9h81KeNqBCjuo/Lx6EF3RP07toYpVkd5TJIrkSbYDQ7J8lIRrDd
 lUgA==
X-Gm-Message-State: AOAM532XIu4nL8dty+6A0V9ddBoeffnkJOqpwzLO2SgbFQQ2WbMmpY30
 rygc1CepBC8qX+P9hVFxC+u1fA==
X-Google-Smtp-Source: ABdhPJzS5AdRFcljD6Jz7OxKl5NJ+IEYr2nuZgQOpFTfBMfhhk81jA6ozUI57bPy8UvCQiWftyNS0g==
X-Received: by 2002:a05:6000:2c1:: with SMTP id
 o1mr5334917wry.264.1610470215396; 
 Tue, 12 Jan 2021 08:50:15 -0800 (PST)
Received: from google.com (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id n10sm4133998wrx.21.2021.01.12.08.50.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 12 Jan 2021 08:50:14 -0800 (PST)
Date: Tue, 12 Jan 2021 16:50:12 +0000
From: Quentin Perret <qperret@google.com>
To: Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC PATCH v2 15/26] of/fdt: Introduce
 early_init_dt_add_memory_hyp()
Message-ID: <X/3TRIkakv9mSHSQ@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-16-qperret@google.com>
 <CAL_JsqLmzFWmTc=6JSRMofSEVRx9GCrwGxEsYog9dC16EMGdvQ@mail.gmail.com>
 <X/1xN2UxiUxkzAiN@google.com>
 <CAL_Jsq+5d+Ox_-m_Rd83R9xoZb6e2cxCNfbL8YPzKdwj=y0M8Q@mail.gmail.com>
 <X/2xlxx9Ucp4UZvL@google.com>
 <CAL_Jsq+o+t4YYXEW_nYqMsT4ubYJWe6Kdhu614RtrCqsHBtfLw@mail.gmail.com>
 <X/3LIGgx83XJ+U0F@google.com>
 <CAL_Jsq+SeOrn4qFyFuPUmXdnM1oMNMLWLsDzrYgUt9Ts3hyoNg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+SeOrn4qFyFuPUmXdnM1oMNMLWLsDzrYgUt9Ts3hyoNg@mail.gmail.com>
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

On Tuesday 12 Jan 2021 at 10:45:56 (-0600), Rob Herring wrote:
> Umm, yes you are right. But both are dealing with nomap. So someone
> needs to sort out what the right thing to do here is. No one cared
> enough to follow up in a year and a half.

Fair enough, happy to do that. I'll send a small series with these two
patches independently from this series which may take a while to land.

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
