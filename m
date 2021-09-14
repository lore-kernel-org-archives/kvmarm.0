Return-Path: <SRS0=7Ft5=OE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71257C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 16:55:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E735B610CE
	for <kvmarm@archiver.kernel.org>; Tue, 14 Sep 2021 16:55:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E735B610CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66FDF4B1E9;
	Tue, 14 Sep 2021 12:55:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i5885WUZMsCg; Tue, 14 Sep 2021 12:55:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6405B4B126;
	Tue, 14 Sep 2021 12:55:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B660F4B0E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 12:55:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VDzv9RTu5lDa for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Sep 2021 12:55:29 -0400 (EDT)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com
 [209.85.219.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D1A0B4B0DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 12:55:29 -0400 (EDT)
Received: by mail-yb1-f173.google.com with SMTP id c6so29734811ybm.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Sep 2021 09:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=CiT20f+n/K0wwGy2+rqWqUjT0xmQpOS21TTyMD2zlmE=;
 b=nMdL8uCTiQIMJh57mn76kJI1SjOunTniqob8xg06HjQHvwabBbiIEUoG1V/HxhbDRi
 B/xog7mzfm9my23apb9v85KQrza1TrtowTXKcScTJZ4+X30PxKKrUOYeTVD2fdrTQ2g/
 Pvq3Xd26dcI4NrPFe19pW1JvJMSQPv+FQM+wJPukchgr69OHjF+2wQwuSkDaWOtI3vC1
 4Fr7bjTmPKHnXsWIOqLwYPx1kYWVZFo4Ly2/tUV7HDmL2DWyYfQQ9iqgfRPK8yNidZJo
 EqqHurEf2kxlJDesWikVmli4MC0W3p/P7EdB3SdSe7MrTM8DJiYprZc2u2fgAqABTu27
 g4uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=CiT20f+n/K0wwGy2+rqWqUjT0xmQpOS21TTyMD2zlmE=;
 b=gZhvLDyFvW2IaXjBcBB5a5OWo1rlXLthBw6j04m8YN10HvQbdOYsQZOPzZyp8tKqvx
 koq1/xMA+IEuvxnwVGReuyofZEBbb12cjqG6qdfVLHWFl0nO/LaX2IAs3glhhcj/cF14
 R+PVBm/zDr7z63gbIhgYeA9r5AzYjMO1ki00oWtuipADI5Oj0xmNOgydr/ghNnr/N+iG
 SAb4BTY+RL2WLG5BoPt0SvJ8VUfjPs1sr4FLUMTYJNVUcByW3JUfdqqs0qLOOjZsMUgn
 U5eMISuLFANOA0eNApUJuzGNTUOYJIdxFtkK+FwfFbEoh2E6q/tbPvzVC1QHCgaRHu+a
 C7pA==
X-Gm-Message-State: AOAM531x5EE0aL5xPgHYD1p4Aj7eEyreDTK4EezTv0Wbup0Ba/jXa8YU
 WYynF8kJD8gVJjLJtK6Hts1X/9dpPPae4QmEnjw+wg==
X-Google-Smtp-Source: ABdhPJy03PrI5vpf60tAG6fNSu3/OBlIZAi3gAIVabPc0hL49cirqfjGeryObR3PamSArsD9t9I5ApbE0cHps48WO0Y=
X-Received: by 2002:a25:c504:: with SMTP id v4mr202049ybe.308.1631638529167;
 Tue, 14 Sep 2021 09:55:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210913230955.156323-1-rananta@google.com>
 <20210913230955.156323-3-rananta@google.com>
 <20210914064845.4kdsn4h4r6ebdhsb@gator.home>
In-Reply-To: <20210914064845.4kdsn4h4r6ebdhsb@gator.home>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 14 Sep 2021 09:55:18 -0700
Message-ID: <CAJHc60z_712Q2pZGBYMx1XJ29++3LrO=TCczHCsoQFb1qWEw5Q@mail.gmail.com>
Subject: Re: [PATCH v6 02/14] tools: arm64: Import sysreg.h
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Mon, Sep 13, 2021 at 11:48 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, Sep 13, 2021 at 11:09:43PM +0000, Raghavendra Rao Ananta wrote:
> > Bring-in the kernel's arch/arm64/include/asm/sysreg.h
> > into tools/ for arm64 to make use of all the standard
> > register definitions in consistence with the kernel.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  tools/arch/arm64/include/asm/sysreg.h | 1296 +++++++++++++++++++++++++
> >  1 file changed, 1296 insertions(+)
> >  create mode 100644 tools/arch/arm64/include/asm/sysreg.h
>
> Looks like an older version than what is available now (v5.15-rc1?)
> was used, but it's expected that these tools copies go out of date
> quickly and it doesn't matter.
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>
While I'm sending out a new patchset anyways, I'll pull-in the latest copy.

Regards,
Raghavendra
> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
