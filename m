Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DB9C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 17 Nov 2022 01:21:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 725534B82F;
	Wed, 16 Nov 2022 20:21:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QZZyDVM9DPVx; Wed, 16 Nov 2022 20:21:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3647A4B79B;
	Wed, 16 Nov 2022 20:21:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34B8D4B79B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 20:21:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N-KxQYBOo2jy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 20:21:03 -0500 (EST)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
 [209.85.210.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0164D4B778
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 20:21:02 -0500 (EST)
Received: by mail-pf1-f179.google.com with SMTP id 130so283651pfu.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 17:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=Z9RXOutukKu5blPlWvexAz9n9/ERlHayplCb37e/A/4=;
 b=BCJ2yFn1tsn53sy1KM+C8Zdkm82sOpVH7Y2IEhdM8rEe13KY0+JzJibXQNw49jtg0F
 YJpEGHLSia5ik4xDLNtUdQIGQn0Mnvq5shG/tD+yC5C36OKusWOkmEEIIWPLzDz+LDeJ
 +EbWB3TGbfUThJkJrUqfMhcfj7xrboNt4Z3Q1/VY4vEMS6ja/gEVrEgQtOn4PLLnvf0+
 Dknem1k3dNWoBkp4GT9fG6BrZjEyaqrE8zcMCpiFHFeZs/CeijWHWxsjzlujxeDGbT4a
 ZNQETjJ5XpC/A7xD7UgpSEMubrDNSt+PhkWikvJsLXLMyToq6DkALWrxQCrz4tbZ83dw
 bSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=Z9RXOutukKu5blPlWvexAz9n9/ERlHayplCb37e/A/4=;
 b=GVm6c/4esaBeZqfkdsT640Xg4o72xvLQGT4Y2cLwgr++EA1pXC2MAZ2zddBeOcgx1v
 xzd6Lh04USQmm8ral+kAAdt+QYyMo27lhCYcFTtJZSh2gCnj15GZx0U7NVLWKFkbvTvZ
 UY1Hq7A9a+5pnKTSGCRFrcyIkQLbRjSCmlrD0CjZ9nTjdln6QBDjColTH9WAFZGMBX2S
 Izw54Uu2+Ad/lP5OA+tvNmXWi2Ltte3ZbN1s9PkR7RUFYj1bkhAC2+qFH8H+0UqUIITD
 605VOOkmPn/RUSurGu3A51Dw3d4U9yHlU5mBtFfWMS3k7ck6uhPPeycFj79jJNOoF6kn
 ew0g==
X-Gm-Message-State: ANoB5pkI48zjPgdMBDqTaq7vwwHBvLlkAFfXGp68BHHBkMTC4Qd9Qnsr
 B2ouUJFGAoxhUHwH48CF3JsLsQ==
X-Google-Smtp-Source: AA0mqf5o9XatuCWD5GyO3XSpaGxhhYlntr2oFTRpGlCI7pnvkOwR1rcY7hYGwMMPWemsdnVer00SUA==
X-Received: by 2002:aa7:9518:0:b0:56c:8c13:24fd with SMTP id
 b24-20020aa79518000000b0056c8c1324fdmr778700pfp.2.1668648061959; 
 Wed, 16 Nov 2022 17:21:01 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 e12-20020a63544c000000b0047048c201e3sm4864960pgm.33.2022.11.16.17.21.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Nov 2022 17:21:01 -0800 (PST)
Date: Thu, 17 Nov 2022 01:20:58 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: Disable single-step without
 relying on ucall()
Message-ID: <Y3WMeovid9z1qOjD@google.com>
References: <20221117002350.2178351-1-seanjc@google.com>
 <20221117002350.2178351-3-seanjc@google.com>
 <Y3WF8YlvFm8NGYHd@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y3WF8YlvFm8NGYHd@google.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

On Thu, Nov 17, 2022, Oliver Upton wrote:
> On Thu, Nov 17, 2022 at 12:23:50AM +0000, Sean Christopherson wrote:
> > Automatically disable single-step when the guest reaches the end of the
> > verified section instead of using an explicit ucall() to ask userspace to
> > disable single-step.  An upcoming change to implement a pool-based scheme
> > for ucall() will add an atomic operation (bit test and set) in the guest
> > ucall code, and if the compiler generate "old school" atomics, e.g.
> 
> Off topic, but I didn't ask when we were discussing this issue. What is
> the atomic used for in the pool-based ucall implementation?

To avoid having to plumb an "id" into the guest, vCPUs grab a ucall entry from
the pool on a first-come first-serve basis, and then release the entry when the
ucall is complete.  The current implementation is a bitmap, e.g. every possible
entry has a bit in the map, and vCPUs do an atomic bit-test-and-set to claim an
entry.

Ugh.  And there's a bug.  Of course I notice it after sending the pull request.
Depsite being defined in atomic.h, and despite clear_bit() being atomic in the
kernel, tools' clear_bit() isn't actually atomic.  Grr.

Doesn't cause problems because there are so few multi-vCPU selftests, but that
needs to be fixed.  Best thing would be to fix clear_bit() itself.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
