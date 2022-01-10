Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6CEFC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jan 2022 23:07:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3065B4B0EF;
	Mon, 10 Jan 2022 18:07:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ivfO1NGYKRwq; Mon, 10 Jan 2022 18:07:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E84B04B0F1;
	Mon, 10 Jan 2022 18:07:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D992F4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 18:07:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eV-FwsdPcCue for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jan 2022 18:07:24 -0500 (EST)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com
 [209.85.219.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC6534A0FF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 18:07:24 -0500 (EST)
Received: by mail-yb1-f178.google.com with SMTP id g14so13825310ybs.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 15:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=WXezCkJjRPkDROjmNSEXw8KrMNSVatQHflVa4NcIBZ4=;
 b=lT7ThlTt++QvhmmkculwEqKL3uXY7KHRlY1gZM6+NQiGlRD9ipXMMx4+mWy7E0i6H2
 YFeTMNWGyf/XiOMdm8cZbbHWziX6fKd2IX5qBjQCbpvC07ja4ugEzBJKzn05hpgC1SRR
 AekdfWmGnZEjHKsImuXfvSQZ+rOmhk9vwUrAEUMpqVXfV6b9OOJ/ps8P9VpNpvoHUrbT
 BzHh3EIH2sdChxnhiwiBSPlCNDGMnSqOv2qNVaeHVb7nIwPjGi/tvwQnkAh8FxtL726/
 Y35AUh+AK0fQZVMkhY7LAhlUFPIqR4ls8dFOHnDz2cos6MHdV42xAgbIurK7je8UGI33
 1ONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=WXezCkJjRPkDROjmNSEXw8KrMNSVatQHflVa4NcIBZ4=;
 b=rQIEwZmfAJskre5cN7ffvjvDXN/ztu8cMZ12eHWpshd5okBk1jlG7SMYOYM1FoKunS
 kn3lKcjujcP/qaqf9q+YiMJlmi/A/WrZpLtFYXpR/cMsl0bd/Dz3DXJY4FC7SN8VwRQv
 zW5X3tRVzTjY8gzDhiTNVgq5m0jIGJhijGjvZie4zUwWjVqaLqPP1p85tD0bFkSDQ9sM
 gucCgHiofv3pEezDwqfCshXGf3Ku0FyOIXt8DMkpgd9E2ECJTSYX+2ibNHBFA3Nna+cB
 +2m35cRCOspW1J4OmJhULIGebZgV74EOZz8s2d1B3NNYPhWTHlSHowgSfT4n7GEK+ZVP
 tYCw==
X-Gm-Message-State: AOAM533rRZAC5dGzorbL8q90Ra3qaEAKngsjSQp2kVKjqCVOG1s3wgWF
 obx3g7y1hVz0vnaHLqCYeCjMM4iNxlKWzFklarvYRQ==
X-Google-Smtp-Source: ABdhPJzBJzORsUZLGXrxCBMovCLT/oathXNs3w20UB7mc6qHjBQPdClWy2y/DJ7ReGsZVPvGVSjnvALfMbExKTvbbuk=
X-Received: by 2002:a25:b9d2:: with SMTP id y18mr1128156ybj.615.1641856044191; 
 Mon, 10 Jan 2022 15:07:24 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-2-rananta@google.com>
 <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
 <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
In-Reply-To: <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 10 Jan 2022 15:07:13 -0800
Message-ID: <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To: Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Fri, Jan 7, 2022 at 4:05 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Jan 7, 2022 at 3:43 PM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Hi Reiji,
> >
> > On Thu, Jan 6, 2022 at 10:07 PM Reiji Watanabe <reijiw@google.com> wrote:
> > >
> > > Hi Raghu,
> > >
> > > On Tue, Jan 4, 2022 at 11:49 AM Raghavendra Rao Ananta
> > > <rananta@google.com> wrote:
> > > >
> > > > Capture the start of the KVM VM, which is basically the
> > > > start of any vCPU run. This state of the VM is helpful
> > > > in the upcoming patches to prevent user-space from
> > > > configuring certain VM features after the VM has started
> > > > running.
>
> What about live migration, where the VM has already technically been
> started before the first call to KVM_RUN?

My understanding is that a new 'struct kvm' is created on the target
machine and this flag should be reset, which would allow the VMM to
restore the firmware registers. However, we would be running KVM_RUN
for the first time on the target machine, thus setting the flag.
So, you are right; It's more of a resume operation from the guest's
point of view. I guess the name of the variable is what's confusing
here.

Thanks,
Raghavendra
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
