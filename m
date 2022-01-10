Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E619C43217
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 09:00:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52E3241173;
	Tue, 11 Jan 2022 04:00:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9Ye1JyGGjP7a; Tue, 11 Jan 2022 04:00:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ED9D4B256;
	Tue, 11 Jan 2022 04:00:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 840F84A369
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 18:48:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZeV5ytwpx3fF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jan 2022 18:47:59 -0500 (EST)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com
 [209.85.219.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 95ECE40F30
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 18:47:59 -0500 (EST)
Received: by mail-yb1-f182.google.com with SMTP id 127so26337101ybb.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 15:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=V7bvr9AT+ViYWBOgleDYjHyL3H3pc/v4pn7I6M0FLS4=;
 b=ej4Q05pKU/h4KDyI2NuIerKgxTlzLfgmgRTMDjGpIi04yviyVKEEzKlJjDLBIOhpov
 q8t7Q19UYQ4kIvlWeSaP1Rem1sm7GQxYmej8C0FcMpEZIPDIdcfUJorgTtsuo6e88FIu
 dvSWWPxKB+rpjda/P0xhUB/XYqm//hDLsvIaU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=V7bvr9AT+ViYWBOgleDYjHyL3H3pc/v4pn7I6M0FLS4=;
 b=bnQPbEtvqosWYEv2gMncaQGUgJEtr2YpYVGArkGlOLpqYdDvaziIb7lLVRFn5m+qTV
 Sxb0ae+DpbL7eWl8Ujh7hczDj2dnZzFlGmgCo9OafHvejvV69ZK2Cn2BrGQ0uy7TqemX
 0W6mavqLnrq+xFfZgZZ9z/0kdHPAQ5pVmZQfgdIfgNhuXdiTnEV3HeARk5htFutgNfSB
 T2LeBqJdmbHBMQEH1aywwA0WxBs98APb1KtFFrKHNvJf5ylsF85bHv1RnuEMgRot9UTW
 aktrTiCyG1l6HF0imzvu9LYrugshdXlZjEvdEDpzr5QkzxaoJGcU3SFzlxt5c1OCm8VG
 NGFQ==
X-Gm-Message-State: AOAM530xNU0b4LYrDUM8TAb8+fRf2DpN+OoB0tPISa6uu94UeYHA9fby
 LUomGnAXiYm8hD3R++utHcK4YTTcCd9WY4/Qw5/8XA==
X-Google-Smtp-Source: ABdhPJyeO7YkijDBkX0qbEZ6iIfqz7iXNkTSDHSv0/OEgOpdNsr9nTuLp7gzWE192stbi9+nPkUxIl89P+qH+bTZv5Q=
X-Received: by 2002:a05:6902:723:: with SMTP id
 l3mr2986305ybt.378.1641858479154; 
 Mon, 10 Jan 2022 15:47:59 -0800 (PST)
MIME-Version: 1.0
References: <20211129034317.2964790-1-stevensd@google.com>
 <20211129034317.2964790-5-stevensd@google.com>
 <Yc4G23rrSxS59br5@google.com>
 <CAD=HUj5Q6rW8UyxAXUa3o93T0LBqGQb7ScPj07kvuM3txHMMrQ@mail.gmail.com>
 <YdXrURHO/R82puD4@google.com> <YdXvUaBUvaRPsv6m@google.com>
 <CAD=HUj736L5oxkzeL2JoPV8g1S6Rugy_TquW=PRt73YmFzP6Jw@mail.gmail.com>
 <YdcpIQgMZJrqswKU@google.com>
 <CAD=HUj5v37wZ9NuNC4QBDvCGO2SyNG2KAiTc9Jxfg=R7neCuTw@mail.gmail.com>
 <Ydhq5aHW+JFo15UF@google.com>
In-Reply-To: <Ydhq5aHW+JFo15UF@google.com>
From: David Stevens <stevensd@chromium.org>
Date: Tue, 11 Jan 2022 08:47:47 +0900
Message-ID: <CAD=HUj62nanThBtAo2bnEh=xXp+AU0XmJeOCLb2cRkRW03pJbw@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] KVM: mmu: remove over-aggressive warnings
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Tue, 11 Jan 2022 04:00:43 -0500
Cc: Chia-I Wu <olv@chromium.org>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

> The best thing to do is probably to wait for for kvm_vcpu_map() to be eliminated,
> as described in the changelogs for commits:
>
>   357a18ad230f ("KVM: Kill kvm_map_gfn() / kvm_unmap_gfn() and gfn_to_pfn_cache")
>   7e2175ebd695 ("KVM: x86: Fix recording of guest steal time / preempted status")
>
> Once that is done, everything in KVM will either access guest memory through the
> userspace hva, or via a mechanism that is tied into the mmu_notifier, at which
> point accessing non-refcounted struct pages is safe and just needs to worry about
> not corrupting _refcount.

That does sound like the best approach. I'll put this patch series on
hold until that work is done.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
