Return-Path: <SRS0=3b8a=HV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E9EC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 17:57:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 78C4364EB1
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 17:57:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78C4364EB1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E58954B31A;
	Fri, 19 Feb 2021 12:57:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B6jgcWHRlBNB; Fri, 19 Feb 2021 12:57:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1A714B31E;
	Fri, 19 Feb 2021 12:57:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30D274B31A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 12:57:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kYtiurhr-KiP for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Feb 2021 12:57:21 -0500 (EST)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
 [209.85.128.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DB044B258
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 12:57:21 -0500 (EST)
Received: by mail-wm1-f50.google.com with SMTP id o15so7763493wmq.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 09:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=wSDGwoocflGRIUHKyKkTZr409vUlF3AWV+fTAIOXUPE=;
 b=AbfIdFqm4xyNtnKCriEj3ztzc1Gjd0MbqggKgNzwhkA6aOPx4NDOMFXEbkrYmINjj+
 OQJPGkY1UUu8x/fxguDXcyrrmF49OM/RHXgd6Sx3aZHa+CJl4T/2OnbwQ5L7ekAc6M1O
 IfRGreUXZxsoxJV/XuAcGQ5c12V3pS5+ymb4O66tkz8SnvrOu2D2h3sp4vwdnkn8oEMK
 bPmvFRBOLUC1OospurDh44uj/mV8ZMWnixELHFmVBA6m46hKDa389j7U9f2+T3BROkpm
 lj+fo31DFiEsNYIWeNVM0CIqFRZj4Kv5LO2Ngx2paI/QjR7ITufSwvouov6dBeZcBdQU
 Lhyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=wSDGwoocflGRIUHKyKkTZr409vUlF3AWV+fTAIOXUPE=;
 b=X0mprD8X1WOmHtbF6EWcbuujvpJTc+wOgZXLNq8BXrE+EBTiJeRQdDD99TP79PAF1h
 /iJ57mc+xRCvxquu1Di1hinFdHWaxdhAhvnEpX5YrURahes2ipFvw10d9f4o5GnNY4Hb
 za/iyc3hwHtCWHbJHopip1iIKdGDN/Y7pp+qFCAY8HSFE7YEyE5OgpyvS9B7CS2N0Abr
 U2X5DbkKW46+J8ItplG4S0XYEZzJPSjQ09xC5FNhNe0ueYL0lFuJ6QphPKDAj12ZGHs9
 gnHubANEvO9I26cYYSI+B/1MzqGERWL10awLKABcEItvbqxADIZmAwl9pMBhdOvIQNH3
 oL+w==
X-Gm-Message-State: AOAM533B6ui4yGHsfKb1zQvIKqQbZA/y0+YsxKSUWTZQtJLZR1aYkno9
 Zhg5ZQjty9PBtiTD9Kjz9+y/YA==
X-Google-Smtp-Source: ABdhPJxsiiByL8wUUfnZSNR07gNAM/FJ7VrbvCTpRolHBc5LKfAskVcQmZEzfpvfHkY0MiFCvM+Z4Q==
X-Received: by 2002:a05:600c:48a8:: with SMTP id
 j40mr9105297wmp.57.1613757439910; 
 Fri, 19 Feb 2021 09:57:19 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id c2sm14302124wrx.70.2021.02.19.09.57.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 19 Feb 2021 09:57:19 -0800 (PST)
Date: Fri, 19 Feb 2021 17:57:17 +0000
From: Quentin Perret <qperret@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v2 00/26] KVM/arm64: A stage 2 for the host
Message-ID: <YC/7/fOJ7IAfo61D@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <YC/7XuB30N8C3sNx@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YC/7XuB30N8C3sNx@google.com>
Cc: devicetree@vger.kernel.org, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
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

On Friday 19 Feb 2021 at 09:54:38 (-0800), Sean Christopherson wrote:
> On Fri, Jan 08, 2021, Quentin Perret wrote:
> > [2] https://kvmforum2020.sched.com/event/eE24/virtualization-for-the-masses-exposing-kvm-on-android-will-deacon-google
> 
> I couldn't find any slides on the official KVM forum site linked above.  I was
> able to track down a mirror[1] and the recorded presentation[2].
> 
> [1] https://mirrors.edge.kernel.org/pub/linux/kernel/people/will/slides/kvmforum-2020-edited.pdf
> [2] https://youtu.be/wY-u6n75iXc

Much nicer, I'll make sure to link those in the next cover letter.

Thanks Sean!
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
