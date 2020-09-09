Return-Path: <SRS0=Sq8/=CS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7679C43461
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 15:53:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 19CC42064B
	for <kvmarm@archiver.kernel.org>; Wed,  9 Sep 2020 15:53:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RfcRjoln"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19CC42064B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E9294B4B8;
	Wed,  9 Sep 2020 11:53:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M8Rh6cVD+XGw; Wed,  9 Sep 2020 11:53:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 838784B39F;
	Wed,  9 Sep 2020 11:53:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBB534B39F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 11:53:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id egzbu2b8fOOi for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2020 11:53:15 -0400 (EDT)
Received: from mail-ed1-f66.google.com (mail-ed1-f66.google.com
 [209.85.208.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CBB584B388
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2020 11:53:14 -0400 (EDT)
Received: by mail-ed1-f66.google.com with SMTP id l17so3140098edq.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Sep 2020 08:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=tYTAx4l6f2u8KbHrEy5Rn6tgANLlely6K9NrAKkKaD4=;
 b=RfcRjolnslna7osjOO1TXCoghzNi2fKgyFZPEMSQax8YEU8v4535p5x6dM2zbOIX8K
 aGJX4vT0l4XB4cYXiNDKH+3JzRNjm3eijcTc7SfI9q1BpSt79VwY8JZjA17Leq2ZJjYD
 tOpHiKVDtUz2jt2C6HN0AItE24CYkZLmi72A1fJlHm2sL3JbaocWOehxQ156RbPQE4DY
 LBdCPb63BwhCd9tiQqsumCNyOc414IoPmrhnv6Dx6RngxPr4gNNW9DYbjhlC3gMkccSL
 0WNDOoOdeaTUr5BMaP0jEDoAul/y2Yq5eI7X8LXVuiR4Tsj+mAF5IlR5CJZySYjOgH/B
 gTbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=tYTAx4l6f2u8KbHrEy5Rn6tgANLlely6K9NrAKkKaD4=;
 b=B0EGzXRhr7n8F5N9TPvxIm2tfyPD9mWK4ZhsWijDyPmqU114FCCGJXatlx4asjmTph
 kDrM5CfIv6/5AA0b/goXRNnNmCX2OB35MjNg6cF05wj6eQPR0ZZl22ryM4loKX9sYB0r
 vrHccd7nGIfRAbWoAZao9Ox3c/YtwP5ZCdeQYOGdfeipDSoQkUchgnIrFZZ0e4VuLYol
 x8+gJ3n73g3lxSewGTKyxPypQ1NhaCHAWZf9XRv3bHVxbkjoP+mRbhon4pE948+eY1hQ
 YjmAwcIl6C7oGn48OgXxeIK8+g4/jenA7MpAVkj3u/aeN/Yx+JvpfMHB/U19leXsRuPy
 sHoA==
X-Gm-Message-State: AOAM530puJaVnjFX2Mal9cd17BkbptECidjG4a+UPY9ICHOk7gum9Uqm
 EJrrKR1hDLFgYBFkfvKjBSwX4PVLk0CrdXMW8EJaMQ==
X-Google-Smtp-Source: ABdhPJw/klL8m+jTWg8TN2b2YPUs5PNhV2M3PAJmM/yRQZlC76+0uLWD3k61ammc5irNXocl1b/iC7V5ejqeyp86R9g=
X-Received: by 2002:aa7:dd4b:: with SMTP id o11mr4647541edw.251.1599666793751; 
 Wed, 09 Sep 2020 08:53:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200904160018.29481-1-steven.price@arm.com>
 <20200904160018.29481-3-steven.price@arm.com>
 <20200909154804.mide6szbzgdy7jju@kamzik.brq.redhat.com>
In-Reply-To: <20200909154804.mide6szbzgdy7jju@kamzik.brq.redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 9 Sep 2020 16:53:02 +0100
Message-ID: <CAFEAcA_1YnBg3HVmtrSMP8u7GqHY8mtDAJwVcZuNUhwA+q9q=w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] arm64: kvm: Introduce MTE VCPU feature
To: Andrew Jones <drjones@redhat.com>
Cc: Peter Maydell <Peter.Maydell@arm.com>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Juan Quintela <quintela@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 QEMU Developers <qemu-devel@nongnu.org>, Steven Price <steven.price@arm.com>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 Dave Martin <Dave.Martin@arm.com>
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

On Wed, 9 Sep 2020 at 16:48, Andrew Jones <drjones@redhat.com> wrote:
> We either need a KVM cap or a new CPU feature probing interface to avoid
> making userspace try features one at a time. It's too bad that VCPU_INIT
> doesn't clear all offending features from the feature set when returning
> EINVAL, because then userspace could create a scratch VCPU with everything
> it supports in order to see what KVM also supports in one go.

You could add one if you wanted -- add a new feature bit
TELL_ME_WHAT_YOU_HAVE. If the kernel sees that then on filure
it clears out feature bits it doesn't support and also clears
TELL_ME_WHAT_YOU_HAVE. If QEMU sees EINVAL and TELL_ME_WHAT_YOU_HAVE
is still set, then it knows it's dealing with an old kernel
and has to do one-at-a-time probing. If it sees EINVAL but not
TELL_ME_WHAT_YOU_HAVE then it knows it has a new kernel and
has just got all the info.

-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
