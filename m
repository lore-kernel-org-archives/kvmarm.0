Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B065AC433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 18:24:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 24A0B64F53
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 18:24:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24A0B64F53
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCB5B4B252;
	Thu,  4 Feb 2021 13:24:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wp-EVUqulUPf; Thu,  4 Feb 2021 13:24:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B68984B2FC;
	Thu,  4 Feb 2021 13:24:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C43374B2FA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 13:24:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kwtEDPlo9R0Y for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 13:24:28 -0500 (EST)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B001F4B28C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 13:24:28 -0500 (EST)
Received: by mail-wr1-f49.google.com with SMTP id g10so4738045wrx.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Feb 2021 10:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=bqhKJeoVgC8X9omnqAQFhGwn7i6vcm5biCu8hCuSmsc=;
 b=mS1F26WRUDL/2eC6m6CaQ7EFMSsdGeTCCOhzSMDCjGT93wLceWJ9el78YcVG2XqT5i
 UqVytoukFRxRQT8DHQOcZSdezf6aZfm4cMHxWtUBL914wTBeCU3B+7bROExs5LUwFrCJ
 WXe2PCmgsr4VArHc42+FuL7ILIXzXBFQv0oVLONVawbLaWqcC6hgjXQBMZBD6TX8J8dJ
 3TrqtrEJZ117lGENT5OWBVyBNmhfhsO2lc4Ev0t3lQ+xJX2ZNI9xwHK76j1T8+bfINfz
 SSnuRec1a0u+Fgv5p1JNHOiDUnNYpC3ZZM4JebJW5CZizUNezhin4g67sF9QjV0HpO74
 meWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=bqhKJeoVgC8X9omnqAQFhGwn7i6vcm5biCu8hCuSmsc=;
 b=gVviseLgaKEM72NEHAe1uBW9lQuYn97TCKCC7hrPPlCSeOsDziY+a+QsliFz9ZMPdv
 QIczeXHZeL1p4roF874ZZ7m+EUhPQkPdl1OOTAzmTpebIhp9v1znNIZExPO7Cc5d0vZ8
 7p7x1EZmDBhBu0RiQadZJgFWp0ub0vFgFA2PGNkHZlWtapPkB6V2SN6CcSY7QgFrpTQQ
 Wa4MYgDL1au7BFJal5dbINRCUHCG2RPOD/uwKzIlg9z+OCMUt0Jf0XPuuk07cVXAI5XP
 +5Jmi8gIU7C25tESL9B7A1oE2C2Ul3etBoPZvStAM6OzxwZkczhAc6+vNCgv2hw93zW4
 D/dw==
X-Gm-Message-State: AOAM530QxdIqyU3XlhMGHb88V1y3x0QRoIHueMTBNY8vBEXgYxRSOmDz
 euOWfyC3oneV0whr0Ttg1Y1NcA==
X-Google-Smtp-Source: ABdhPJyY9kiYlOPf8laxHOlhG16GwuGMkScM8L4Dj0rm/ARmDfAXf85n5/++3N6RBc9bsoayAr8Ncg==
X-Received: by 2002:adf:e642:: with SMTP id b2mr668852wrn.221.1612463067694;
 Thu, 04 Feb 2021 10:24:27 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id g14sm9650047wru.45.2021.02.04.10.24.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Feb 2021 10:24:27 -0800 (PST)
Date: Thu, 4 Feb 2021 18:24:24 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH v2 12/26] KVM: arm64: Introduce a Hyp buddy page
 allocator
Message-ID: <YBw72KeLQ5dzSoJi@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-13-qperret@google.com>
 <20210202181307.GA17311@willie-the-truck>
 <YBrsep4xK1F4YRWb@google.com>
 <20210204143106.GA20792@willie-the-truck>
 <YBwKRM3uHDMC9S0U@google.com>
 <20210204174849.GA21303@willie-the-truck>
 <YBw2aIr/Ktx1dsOT@google.com>
 <20210204181317.GE21303@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210204181317.GE21303@willie-the-truck>
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
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

On Thursday 04 Feb 2021 at 18:13:18 (+0000), Will Deacon wrote:
> I was going from memory, but the loop in __hyp_alloc_pages() searches up to
> HYP_MAX_ORDER, whereas this is _never_ going to succeed beyond some per-pool
> order determined by the size of the pool. But I doubt it matters -- I
> thought we did more than just check a list.

Ah, I see -- I was looking at the __hyp_attach_page() loop.

I think it's a good point, I should be able to figure out a max order
based on the size and alignment of the pool, and cache that in struct
hyp_pool to optimize cases where this is < HYP_MAX_ORDER.
Should be easy enough, I'll see what I can do in v3.

Thanks!
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
