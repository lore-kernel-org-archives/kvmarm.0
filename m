Return-Path: <SRS0=hkx2=G5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A77C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 09:18:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3866323104
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 09:18:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3866323104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B0D14B1A0;
	Tue, 26 Jan 2021 04:18:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c7Ztc+x9Fr0D; Tue, 26 Jan 2021 04:18:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F7A94B1D9;
	Tue, 26 Jan 2021 04:18:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC6784B15A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 02:39:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OvaB9adSSwiI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2021 02:39:27 -0500 (EST)
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com
 [209.85.219.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AED854B133
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 02:39:27 -0500 (EST)
Received: by mail-qv1-f47.google.com with SMTP id p5so7439561qvs.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 23:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=MuwuMM1E8EDH+ukP+fboaIDTRxHiGHEVLbQM3XUxmow=;
 b=cd/IZ7dTUOKWb4uxlB9z6AelujYZfyEijwkUXr6NM5yTwl+513pkERu6h0dMWkhdaU
 At23qG9KTayL3QvCcZJZDYJC33EhuLzzs10LzS4N9jM5ieLQ/Zc8wxRKCfQZLpi2+OSZ
 DvpfPKJ6icTje8vFQO9dFH07mj4NftWxu8Rmw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=MuwuMM1E8EDH+ukP+fboaIDTRxHiGHEVLbQM3XUxmow=;
 b=V9XdUpXvpvRLSzEa1cMSRKx4DB5Tf7RPoaLrDfrF/wiTDlQGaM1dpqNTnZDex7C9EH
 +meoFXBeg2BrFYRlSPBQ7aN4sCI9nzFixnDux74hWNFYx7Bik9GGbxRvTSDuSnTzY9d4
 E9XcHGcqDVtKKmQwKnhMjN9x2rEMlcPp2OYD+qyjBqfpmxIXoPP/oir6BJ5aC/NeyoOG
 /OX03M+qHtUfdtus+3cWhEqNFKGQmOvdW9k/1E8cy8aJlpXgQ5nQzO5Cckof7wR11jXz
 ua58Ca3X9cm+RnX1R5N9qM40/2IfLI3bC8EXJpBxHGEvpjiY3FPs/T805+1GDX+YOsDl
 QLog==
X-Gm-Message-State: AOAM532LyV2nUK0N5o276KMwZpT28WkKssLhhR0tBbA5ebQaHI9onSaX
 a8XhS7FFJOcf+cd68WQuJ1OlL+MiLdEQTnYF5RggtA==
X-Google-Smtp-Source: ABdhPJx2m2RK3FQFasvssPNmERYPUcOGckV3GmTjsOq1oZjbkp1d0L3SN2CIYmwEZ8kJTM5lEImXMaoaoAu951JMl7M=
X-Received: by 2002:a0c:a905:: with SMTP id y5mr4391981qva.55.1611646767316;
 Mon, 25 Jan 2021 23:39:27 -0800 (PST)
MIME-Version: 1.0
References: <20210125064234.2078146-1-stevensd@google.com>
 <YA8PXCEVukW0UzC5@google.com>
In-Reply-To: <YA8PXCEVukW0UzC5@google.com>
From: David Stevens <stevensd@chromium.org>
Date: Tue, 26 Jan 2021 16:39:16 +0900
Message-ID: <CAD=HUj5YMtSJY6ZO9TRXHDEfWRM1o3Lrm7nkz=G2VJ_oZ-c5mw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: consider the hva in mmu_notifer retry
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Tue, 26 Jan 2021 04:18:33 -0500
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, open list <linux-kernel@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

> > This has the secondary effect of greatly reducing the likelihood of extreme
>
> Out of curiosity, is this really the _secondary_ effect?  I would expect this
> change to primarily benefit scenarios where the invalidation has gotten
> waylaid for whatever reason.

Yeah, this is the primary benefit. I was thinking about it as the
reduction in page fault retries is the direct effect, and that in turn
leads to a secondary effect of a reduction in the chance of extreme
latency. But I guess that's not a particularly important distinction
to make. I'll reword this.

>
> This needs a comment to explicitly state that 'count > 1' cannot be done at
> this time.  My initial thought is that it would be more intuitive to check for
> 'count > 1' here, but that would potentially check the wrong wrange when count
> goes from 2->1.  The comment about persistence in invalidate_range_start() is a
> good hint, but I think it's worth being explicit to avoid bad "cleanup" in the
> future.
>
> > +     if (unlikely(kvm->mmu_notifier_count)) {
> > +             if (kvm->mmu_notifier_range_start <= hva &&
> > +                 hva < kvm->mmu_notifier_range_end)

I'm not sure I understand what you're suggesting here. How exactly
would 'count > 1' be used incorrectly here? I'm fine with adding a
comment, but I'm not sure what the comment needs to clarify.

-David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
