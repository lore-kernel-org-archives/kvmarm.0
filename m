Return-Path: <SRS0=/4+A=FV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32ABDC4361B
	for <kvmarm@archiver.kernel.org>; Thu, 17 Dec 2020 01:47:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 621DB23432
	for <kvmarm@archiver.kernel.org>; Thu, 17 Dec 2020 01:47:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 621DB23432
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 908944B210;
	Wed, 16 Dec 2020 20:47:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wm6Xk+N2SZWy; Wed, 16 Dec 2020 20:47:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 809424B29B;
	Wed, 16 Dec 2020 20:47:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D78284B210
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2020 20:47:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jjpRz9z4XaH2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Dec 2020 20:47:22 -0500 (EST)
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com
 [209.85.166.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E80814B22A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2020 20:47:22 -0500 (EST)
Received: by mail-io1-f50.google.com with SMTP id i18so25978090ioa.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2020 17:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=VZ4JZTy9+IKB/FbonfM/ldsdg2nn5Yf2TNc8FXof9Fw=;
 b=UCKfAQeBD/lJG4xTZujpMykS46OkdwA9BPik0ZiiP21lmRgJi3/09ohZX9ainMiDKI
 zRxn1vaP+CfpIESFJS/QD4RnMwzU19wODWEC1xxljKq7id5AuvYG5Dhj6VKCiWpO2Bmu
 xepCxxs/nvgAXLsdCo2asTTHWcfi0AsBbedsUSJ6VQp8rpnwvC6QtDd2SbN9Spb44SUF
 VwSXJD16Eaw04aOWV7lxsiFWYQZtc8M40srQyPH6OUeMdOAFhkyMivfM99Y42ik6mm5N
 g+0+Fxj5swtGtbxryrmlwpv3/CKawNt0PwS4A8NM3EMTCg9KLXX30DBH0v5yRbhKLl3w
 dcNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=VZ4JZTy9+IKB/FbonfM/ldsdg2nn5Yf2TNc8FXof9Fw=;
 b=f1S8RnOJBp7M2hru/W8s4rMBYdzjZ/QWmbCHYzd/iqhY6oMEz5VV5ALkaMPw0ipvDC
 +RKAQZH+qoxpxx5jkKrSVkdWCuPcYhQCZ9N8E1jqaw7+7xoyCidGYvAKsCCcjEZVRZm+
 GWH6CfWBjVuGSJ31r4dcBW9MLbrQMpAKV4NoLhcyBDEifMcq9RQJakZP0dLWWoiHX3rd
 14lItbiX+8WgWlSXtnzMfViHXvixYMo5QR3TM5W8dcLysy/wWUX+mSAlOh/ZFMTaZL8F
 GfSqopibJ2WeyG+SEzveV06YNSMV1ynTNs49Xqj/Y7BDK4pNwrD9ualOfrkqtPWkGLqO
 AtOw==
X-Gm-Message-State: AOAM5323rS+XOGn7WCpMSELRkXjkTuVr4ni3pFOuBjBIfuK94bPl0NJD
 MzBHNKvBtrGHQmm8Ng3zXkiwwOb9V8E4wFlU4voY
X-Google-Smtp-Source: ABdhPJyjbWC+MxAHpU9U15X6j6tLnLYjUbu31cSB3o9cVK1vZQtR1OSioJ1js/51Pmr9o1T76zygxv5g3/iHHIbTXNs=
X-Received: by 2002:a5e:8e05:: with SMTP id a5mr44246697ion.133.1608169642340; 
 Wed, 16 Dec 2020 17:47:22 -0800 (PST)
MIME-Version: 1.0
References: <20201119153901.53705-1-steven.price@arm.com>
 <CAFEAcA85fiqA206FuFANKbV_3GkfY1F8Gv7MP58BgTT81bs9kA@mail.gmail.com>
 <20201119184248.4bycy6ouvaxqdiiy@kamzik.brq.redhat.com>
 <db5ad775fa7cfe7defbd78d9ca6ccfd8@kernel.org>
 <c25c297e-e9b5-ab3f-e401-c21ddd4d2ad1@arm.com>
 <CAJc+Z1H7akXwDtVvQLiGVVyZ0DfmsxyJQhE7Sno6aAO9GaafEA@mail.gmail.com>
 <46fd98a2-ee39-0086-9159-b38c406935ab@arm.com>
 <CAJc+Z1EzaUjbQ0o8BSF_+PQy_KnwPp1NqO+94RMphvaUu=dnug@mail.gmail.com>
 <29a7229d-a1ff-98a5-3007-1addcc85aa04@arm.com>
In-Reply-To: <29a7229d-a1ff-98a5-3007-1addcc85aa04@arm.com>
From: Haibo Xu <haibo.xu@linaro.org>
Date: Thu, 17 Dec 2020 09:47:10 +0800
Message-ID: <CAJc+Z1E0rdWcDD1N1R=d-v8FnWSWw=Yu7qypUjRFG_pXw1xybQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] MTE support for KVM guest
To: Steven Price <steven.price@arm.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Juan Quintela <quintela@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 QEMU Developers <qemu-devel@nongnu.org>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
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

On Wed, 16 Dec 2020 at 18:23, Steven Price <steven.price@arm.com> wrote:
>
> On 16/12/2020 07:31, Haibo Xu wrote:
> [...]
> > Hi Steve,
>
> Hi Haibo
>
> > I have finished verifying the POC on a FVP setup, and the MTE test case can
> > be migrated from one VM to another successfully. Since the test case is very
> > simple which just maps one page with MTE enabled and does some memory
> > access, so I can't say it's OK for other cases.
>
> That's great progress.
>
> >
> > BTW, I noticed that you have sent out patch set v6 which mentions that mapping
> > all the guest memory with PROT_MTE was not feasible. So what's the plan for the
> > next step? Will new KVM APIs which can facilitate the tag store and recover be
> > available?
>
> I'm currently rebasing on top of the KASAN MTE patch series. My plan for
> now is to switch back to not requiring the VMM to supply PROT_MTE (so
> KVM 'upgrades' the pages as necessary) and I'll add an RFC patch on the
> end of the series to add an KVM API for doing bulk read/write of tags.
> That way the VMM can map guest memory without PROT_MTE (so device 'DMA'
> accesses will be unchecked), and use the new API for migration.
>

Great! Will have a try with the new API in my POC!

> Thanks,
>
> Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
