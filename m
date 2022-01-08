Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED7A5C433F5
	for <kvmarm@archiver.kernel.org>; Sat,  8 Jan 2022 11:38:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FB5749EC5;
	Sat,  8 Jan 2022 06:38:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KBRzFzmcRP-o; Sat,  8 Jan 2022 06:38:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A9BE49EE3;
	Sat,  8 Jan 2022 06:38:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F4584B244
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 19:05:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7GrJAqZZTXVD for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jan 2022 19:05:01 -0500 (EST)
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com
 [209.85.210.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BFADE4B227
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 19:05:01 -0500 (EST)
Received: by mail-ot1-f53.google.com with SMTP id
 s21-20020a05683004d500b0058f585672efso8358342otd.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Jan 2022 16:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=xIQIMAF9RLT+C4D5YuRDhHVaZflXIUIUiQfqwkcoWZc=;
 b=ikRLN/s+6VutL3/OAv9/D8Jt2GzaaDDFBTBjvFaNhLcP59xDsK76CcNlzc4oMBOwvc
 UodXoB8hp54v4YFwcJxBfHQoyZOxoD1KzRVhLjlrtXjMZ0kC/iGoTZH/bl4fz0ea+ER3
 Dd6O6lLHatYVKexOUaY4+UdpkbMut0ZQWhp+xoET0+ViFkHdL9PAOTCEnOnGuUhRVAYq
 5xd7e0TjW+HC1AYlN3jhHqlHe+wD8UU3lli7sEi6wuM8YwejdHniz5x1YpypSMC+KP4N
 bza8pbAUy1ess2KEkKTP8RDE1JvFMBkG3bWqEnfOBv4UnBRMOkZdssMMEE+iUi6lxhsD
 FCiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=xIQIMAF9RLT+C4D5YuRDhHVaZflXIUIUiQfqwkcoWZc=;
 b=y8OFHYo2Xm658c9CJ4+uqc/wIsRx8fh3Wkd2oBzeb7EiWfvLVqAGYOJqyAS4/mIATL
 4WMC4uocL9aZnklyAV7UIDWXL2vHXayZbZZzhyGSzQOixSNum4HyPWGg9tIdbUVhB/SD
 7MYF9mPfc6OEwNi6WiKCNYeD4qgoZASTQbWGKxTk1Ag3jLG4ZSpVfUhfMe9KUUN5BMMY
 S5MiLJ5pOdCal0H6/jL2IGM08rbdPxtYhSiK4n0d4U6Yex8ve/wJ3wUx5taohnAU8DF1
 qBQEs7ArDvW2e/suEK903Vz0XMcre5/LsyLs2/2/k9KUDlETabPkZaFidizE6YM2JANm
 S8vw==
X-Gm-Message-State: AOAM533pkFYd85+9CUJxxJKuesk1WZD/LHkhQPbxnmA/r0NOiGqckH7P
 LUSCSn2Afgj/9xSGTwbsG1IegLDk+CJFALHqHU7TKA==
X-Google-Smtp-Source: ABdhPJyvaiFT2G34coGt3czDQ/iLkIq+EgyiHgmZSbvDmR6/D06mxLvwlCBW5kXpWCbVDzlXbPJqPLrmwno45hzKJ4M=
X-Received: by 2002:a05:6830:4a9:: with SMTP id
 l9mr44223760otd.75.1641600300700; 
 Fri, 07 Jan 2022 16:05:00 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-2-rananta@google.com>
 <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
In-Reply-To: <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 7 Jan 2022 16:04:49 -0800
Message-ID: <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To: Raghavendra Rao Ananta <rananta@google.com>
X-Mailman-Approved-At: Sat, 08 Jan 2022 06:38:34 -0500
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

On Fri, Jan 7, 2022 at 3:43 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Hi Reiji,
>
> On Thu, Jan 6, 2022 at 10:07 PM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Raghu,
> >
> > On Tue, Jan 4, 2022 at 11:49 AM Raghavendra Rao Ananta
> > <rananta@google.com> wrote:
> > >
> > > Capture the start of the KVM VM, which is basically the
> > > start of any vCPU run. This state of the VM is helpful
> > > in the upcoming patches to prevent user-space from
> > > configuring certain VM features after the VM has started
> > > running.

What about live migration, where the VM has already technically been
started before the first call to KVM_RUN?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
