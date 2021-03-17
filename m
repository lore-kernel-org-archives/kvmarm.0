Return-Path: <SRS0=pwNx=IP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CAAC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 09:02:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 05EAC64F33
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 09:02:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05EAC64F33
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EAC24B610;
	Wed, 17 Mar 2021 05:02:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FbKnBFbirkPC; Wed, 17 Mar 2021 05:02:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54DB34B578;
	Wed, 17 Mar 2021 05:02:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA23B4B4F1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 05:02:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E4X2m4mQR+yU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Mar 2021 05:02:13 -0400 (EDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
 [209.85.128.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC5924B3FF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 05:02:13 -0400 (EDT)
Received: by mail-wm1-f48.google.com with SMTP id
 y124-20020a1c32820000b029010c93864955so2916881wmy.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 02:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=QwuxtgiCCCuVkfcX8LM9ZlMzlOT2xbL3vCInW5yBpfg=;
 b=HsNDgrTfHb6lenOiS0yb3OIwab0Slx0F9OO942wg+fn+VlF4z18b5ZjUwJ5ayQLqBw
 1cz9cCd1Nv+02O1Rqqjepf1YSKlqAh0hYm9nIVh7SbxX4Wg/JU0BYAkuNWhzdrhQeATV
 XibT9bPRb/CpKBHxXIPKH+whD+T+vjYz0aBBC0pzwSPl4RX5m+qV+z9OkK8tjsNVZEKY
 +pXJcZCtdNMJpuEDhLRYniinjapSEsGfkadsD11XQg7ZFr9csC42N6vMQTY0etWdwe3v
 5vk0Ig3JaHNCU4LAjWpkrkmh4iDxgHMukVezMg07LTrKr3QdI9t+lDSOKJdxppyMxUyH
 buMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=QwuxtgiCCCuVkfcX8LM9ZlMzlOT2xbL3vCInW5yBpfg=;
 b=VLUfS5nJAj9sfTDKF6iB/ofgXT2GKpQg1CknlLFvg3yacC5c0g0M4L8u9woz0I191P
 xvfNYZuGZh7f5xnC+rKpNwivkQnA9qbigXnVR+6JA/J+B5YKUFengYOVvqMbVQJh9pl8
 nU0pqT0jjN4+AfK7H5oK1KMKiJh89LutgH3mwIKbFUKVZH5+n7T9CsmoTpJs2VhHPDvO
 LjxyhwN2thS+Bm9scJpJ4atvNyDnrJBL53uUMsN3TOz3CMHAp7+0+aOOWS8f7Z/MLEfe
 c8aqGipXVTF28uB0SZiivS6MqGGrQYr33pYh6jQTaYZFOjdCizMdq0x8b4PexJv9vY6K
 UFLQ==
X-Gm-Message-State: AOAM533QUbLGo7CWLcFg27ngRoVDc1eabuHrtJkc1vdBUjuFscFIAlqI
 kHfh2ns/O38ME8PbthmsSLMstg==
X-Google-Smtp-Source: ABdhPJzFjLJUUKNKs+1TXyYF2RPilOCv4q5TrU8XPy3DPss8s4W20rOFuDvU8NaXimf62US3JuyGtw==
X-Received: by 2002:a05:600c:4112:: with SMTP id
 j18mr2656665wmi.143.1615971732589; 
 Wed, 17 Mar 2021 02:02:12 -0700 (PDT)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id u2sm2315302wmm.5.2021.03.17.02.02.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 17 Mar 2021 02:02:12 -0700 (PDT)
Date: Wed, 17 Mar 2021 09:02:09 +0000
From: Quentin Perret <qperret@google.com>
To: Mate Toth-Pal <mate.toth-pal@arm.com>
Subject: Re: [PATCH v5 33/36] KVM: arm64: Wrap the host with a stage 2
Message-ID: <YFHFkaKZyAEheWZV@google.com>
References: <20210315143536.214621-1-qperret@google.com>
 <20210315143536.214621-34-qperret@google.com>
 <ec9df9a4-a419-089c-469f-1a1509597dd9@arm.com>
 <YFCqYT3Ib8kAN7/c@google.com> <YFDAyhjPEsnZ4N3P@google.com>
 <eb70a071-4d4a-885f-36a7-3b20358e5513@arm.com>
 <YFDvAqgimPvpgiwQ@google.com>
 <da9e7839-6d12-c69d-9f23-a091219e1da8@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <da9e7839-6d12-c69d-9f23-a091219e1da8@arm.com>
Cc: nd@arm.com, kernel-team@android.com, android-kvm@google.com,
 catalin.marinas@arm.com, seanjc@google.com, tabba@google.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

On Wednesday 17 Mar 2021 at 09:41:09 (+0100), Mate Toth-Pal wrote:
> On 2021-03-16 18:46, Quentin Perret wrote:
> > On Tuesday 16 Mar 2021 at 16:16:18 (+0100), Mate Toth-Pal wrote:
> > > On 2021-03-16 15:29, Quentin Perret wrote:
> > > > On Tuesday 16 Mar 2021 at 12:53:53 (+0000), Quentin Perret wrote:
> > > > > On Tuesday 16 Mar 2021 at 13:28:42 (+0100), Mate Toth-Pal wrote:
> > > > > > Changing the value of MT_S2_FWB_NORMAL to 7 would change this behavior, and
> > > > > > the resulting memory type would be device.
> > > > > 
> > > > > Sounds like the correct fix here -- see below.
> > > > 
> > > > Just to clarify this, I meant this should be the configuration for the
> > > > host stage-2. We'll want to keep the existing behaviour for guests I
> > > > believe.
> > > 
> > > I Agree.
> > 
> > OK, so the below seems to boot on my non-FWB-capable hardware and should
> > fix the issue. Could you by any chance give it a spin?
> > 
> 
> Sure, I can give it a go. I was trying to apply the patch on top of https://android-kvm.googlesource.com/linux/+/refs/heads/qperret/host-stage2-v5
> but it seems that your base is significantly different. Can you give some
> hints what should I use as base?

Oh interesting, it _should_ apply on v5. I just pushed a branch with
everything applied if that helps:

  https://android-kvm.googlesource.com/linux qperret/wip/fix-fwb-host-stage2

Thanks again!
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
