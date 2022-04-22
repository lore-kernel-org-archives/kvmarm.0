Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A0FC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 22 Apr 2022 16:00:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51EAE4A0FD;
	Fri, 22 Apr 2022 12:00:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qR9juji4JA9b; Fri, 22 Apr 2022 12:00:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65FE14B099;
	Fri, 22 Apr 2022 12:00:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD3344A0FD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 12:00:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hqFxnAQEWCOV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Apr 2022 12:00:50 -0400 (EDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com
 [209.85.208.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A982649F5A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 12:00:50 -0400 (EDT)
Received: by mail-ed1-f43.google.com with SMTP id 21so10972609edv.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 09:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Z64NNLHkcUmTZj8rPBl+zXy5wRD3qI9VqCl/OwwNbD8=;
 b=B59WmKOmyKLqObKAYrr0Nd3oMvb1zTXWY8Y55DCWA51Dtj5KPWN31pUm7Q6DECCdEw
 KSBHAQvXsR06UMbAZIJjb6TqDEKsIcKHrJnrAdzGN2mPvXyKv8ml7ZlPDaYMxu6qFgn0
 r7guBuL6nmDnu3nFX9pV0W6PtphTRWDjb3GgBrYKV+TmCx8DCE4cEE87S3p85fu+f3T1
 gFjfRCMjOpVD5ZYAj3a3MkL/glhUssHZyZmJBI+2J3EhuJfHC8S8Xnut8x3y3OfzgHBZ
 sJ9g5lhUeJgpBdgiwgxZmB/w5IOt/tc53uzl7T9nLQTLnGgfK3HVb5t/LejD/QZbZKCN
 YYag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Z64NNLHkcUmTZj8rPBl+zXy5wRD3qI9VqCl/OwwNbD8=;
 b=ARtSgmH4uvBPNrE//KvzkS/ZDv230BjCugX23xXpxsq2k7GtdGAku2QbqaRr766B1q
 EPPnYI57VvKpqapbpz7A/3YeOOJ3ivB+bCa4zdPXH485zGe7lTesIrgRpJVuWaI2vecX
 MY5QBg5Vuw5DAdNBQAD88wgCvnFpx2qns1R2xbC0W2ELQbeOl7m0l7WJmvYQbrn9BC5s
 iyyCBGSYEBjaj7nJykYcVYKN7ANICZkeaKa/6sFGcr82J+vknqu3V6UL7H89/ruf+q8e
 voIWxC8PSyL0Rk8IonU6C6g3roo6lIM5ulPDWL4TmoFxCE346aoFejusGVs6gI914DFn
 TvMw==
X-Gm-Message-State: AOAM530sRFOSPH8oT7DGi1sW7UiafujO5WkrEswuMckfYBXlcclMgSZm
 7n3BR4SPAWdUTXfamCvX1RFLI0Wp7Ap2lA==
X-Google-Smtp-Source: ABdhPJwgTmz6DWsAH0vuu2Cgkvp4em5pC8WwDnJP/+KeAYOH3MbagaEyjkznZqW7nPRo1eklhTXx2w==
X-Received: by 2002:a05:6402:5ca:b0:423:f330:f574 with SMTP id
 n10-20020a05640205ca00b00423f330f574mr5714790edx.116.1650643249420; 
 Fri, 22 Apr 2022 09:00:49 -0700 (PDT)
Received: from google.com (30.171.91.34.bc.googleusercontent.com.
 [34.91.171.30]) by smtp.gmail.com with ESMTPSA id
 q7-20020a170906540700b006d5eca5c9cfsm867968ejo.191.2022.04.22.09.00.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 22 Apr 2022 09:00:49 -0700 (PDT)
Date: Fri, 22 Apr 2022 16:00:45 +0000
From: Quentin Perret <qperret@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [RFC PATCH 09/17] KVM: arm64: Tear down unlinked page tables in
 parallel walk
Message-ID: <YmLRLf2GQSgA97Kr@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-10-oupton@google.com>
 <YmFactP0GnSp3vEv@google.com> <YmGJGIrNVmdqYJj8@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YmGJGIrNVmdqYJj8@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Ben Gardon <bgardon@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Thursday 21 Apr 2022 at 16:40:56 (+0000), Oliver Upton wrote:
> The other option would be to not touch the subtree at all until the rcu
> callback, as at that point software will not tweak the tables any more.
> No need for atomics/spinning and can just do a boring traversal.

Right that is sort of what I had in mind. Note that I'm still trying to
make my mind about the overall approach -- I can see how RCU protection
provides a rather elegant solution to this problem, but this makes the
whole thing inaccessible to e.g. pKVM where RCU is a non-starter. A
possible alternative that comes to mind would be to have all walkers
take references on the pages as they walk down, and release them on
their way back, but I'm still not sure how to make this race-safe. I'll
have a think ...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
