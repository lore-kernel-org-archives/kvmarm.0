Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CEAC433EF
	for <kvmarm@archiver.kernel.org>; Sat, 19 Feb 2022 04:50:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D731C49E39;
	Fri, 18 Feb 2022 23:50:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u78YP1tcaJEO; Fri, 18 Feb 2022 23:50:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 894FA49E1E;
	Fri, 18 Feb 2022 23:50:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06E9149B0C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Feb 2022 23:50:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f0JMAOmHK0FZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Feb 2022 23:50:49 -0500 (EST)
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com
 [209.85.215.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A834C411BD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Feb 2022 23:50:49 -0500 (EST)
Received: by mail-pg1-f177.google.com with SMTP id d16so9525641pgd.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Feb 2022 20:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Z9SuVj1fi5RP4o5bRwa6K8lcyqW640R9G+/Kdms/XR0=;
 b=X7S/AZ9fBPKIrVhySnCY+U7UWblLfCMaFM8lqCHiY9l7y6+mVO7sm3AZqiX46+RhS7
 GqTWzh9NBy6I5w+iswXplY/uyx2XLH/TqbxUAx5y3njh2VL8Snf4cLmnj6pNp7bFwvfZ
 YW1Fq8TUyi0cEgFTHA1ykNFD52tBgHmxgMaDIveXWKMrzgDVwZeIife1Mh6ivuPya6BH
 BiPFouxhuF51Wx0IjKNfAwnLdAF3OAghcyU6dM/lnDRX0hZO5I4wUSNcSJ4c57kabSt7
 3kc7cEtAqlG5BEJyhNtNKNGr1abUDhQf1WOg8PxtfoAeZ7TK/Myw48jFV/dcT0KXc9/A
 MZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Z9SuVj1fi5RP4o5bRwa6K8lcyqW640R9G+/Kdms/XR0=;
 b=RX7iduWoR84u/FOdAlN2TfXZzcvwWduvdAgtUe2vc72fJpH18zXUo4w25WdAHCUc1/
 GbdgVMeTxffjF/34g5J9nJq8UlJN+7ZHKWcAzAtsAFCXgEXq71ZZONIwPeHwfsJv266I
 mJinp/V4ueqRyjT2FBymUfrnbOsmAU56aAlvNfPwXZj6KcbhPtPg7iQwaB0U8O27sb/y
 25m97cToHY2GgnMevJRysVhoSoslQOXsP2BmRK1lkbRV4I1wX73g0lKLsoy/iwxM9YAc
 KKat4XZbk7Emrwex5f0SmvMYRlIjKuy3/nDXFjIHGFVAxFJNDC2cD/O9EOgP2uF8HPdC
 YqlQ==
X-Gm-Message-State: AOAM530jn42ctyxiE03+IBcKRP4vcAIHI3rMdWkNs12nPrFrN0rrjymG
 KOlviWiPzQp1HKB0jTIkSGJCLp51WXhKRMMOdBZ9rw==
X-Google-Smtp-Source: ABdhPJzzTlaezoX5387HfzWh1w/HYes2SMd46QCY6Bv5pDQwuPKmNPS1FuUAtf8Yh5hmsZI8gAHEwFlZKh5Pna/qX3c=
X-Received: by 2002:a63:de46:0:b0:364:cad7:bf3b with SMTP id
 y6-20020a63de46000000b00364cad7bf3bmr8775132pgi.491.1645246248595; Fri, 18
 Feb 2022 20:50:48 -0800 (PST)
MIME-Version: 1.0
References: <20220217034947.180935-1-reijiw@google.com>
 <20220217034947.180935-2-reijiw@google.com>
 <Yg3Uer/K6n/h6oBz@google.com> <874k4x502u.wl-maz@kernel.org>
In-Reply-To: <874k4x502u.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 18 Feb 2022 20:50:32 -0800
Message-ID: <CAAeT=FxbbBq0sxUZAOSJW_wM+6M=xQe-p+=aeqpg=-y9VbpnnA@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: Introduce get_set_regs_perf
 test
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Marc,

On Thu, Feb 17, 2022 at 1:12 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 17 Feb 2022 04:52:10 +0000,
> Oliver Upton <oupton@google.com> wrote:
> >
> > Hi Reiji,
> >
> > First off, thanks for looking into this! Seems like a very useful thing
> > to test :-)
> >
> > On Wed, Feb 16, 2022 at 07:49:47PM -0800, Reiji Watanabe wrote:
> > > Introduce a simple performance test of KVM_GET_ONE_REG/KVM_SET_ONE_REG
> > > for registers that are returned by KVM_GET_REG_LIST. This is a pseudo
> > > process of saving/restoring registers during live migration, and this
> > > test quantifies the performance of the process.
> > >
> > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > ---
> > >  tools/testing/selftests/kvm/.gitignore        |   1 +
> > >  tools/testing/selftests/kvm/Makefile          |   1 +
> > >  .../selftests/kvm/aarch64/get_set_regs_perf.c | 456 ++++++++++++++++++
> >
>
> [...]
>
> > Would it make sense to test some opt-in capabilities that expose
> > additional registers (PMU, SVE, etc.)?
>
> I think this is important. System registers are usually saved/restored

Yes, I will fix the test to include registers for opt-in features
when supported.

> in groups, and due to the way we walk the sysreg array, timings are
> unlikely to be uniform. Getting a grip on that could help restructure
> the walking if required (either per-group arrays, or maybe a tree
> structure).

The biggest system register table that I know is sys_reg_descs[],
and KVM_SET_ONE_REG/KVM_GET_ONE_REG/emulation code already uses
binary search to find the target entry.  So, the search itself
isn't that bad.  The difference between the min and the max
latency of KVM_GET_ONE_REG for the registers is always around
200nsec on Ampere Altra machine as far as I checked.


> Note that all of this could equally apply to the guest trapping (the
> walk is the same).
>
> And yes, there are a lot of commonalities with get-reg-list, so
> reusing some of the existing infrastructure would be a good thing.

I will look into that.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
