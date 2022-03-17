Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0632C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 16:57:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0924A49F33;
	Thu, 17 Mar 2022 12:57:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6lgIl0QabxzH; Thu, 17 Mar 2022 12:57:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B87449F24;
	Thu, 17 Mar 2022 12:57:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B69BB49F26
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 12:57:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pH9f3WGSVJzN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Mar 2022 12:57:02 -0400 (EDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
 [209.85.167.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 89BF949E3A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 12:57:02 -0400 (EDT)
Received: by mail-lf1-f43.google.com with SMTP id p6so2839177lfh.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 09:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=pZZ/ZyntFdWScxN0lJA199RTWytNkCmmcoJKmHk/hjk=;
 b=gbdQipZOFrTwzaoaQKXuF1cVYywNS5cx6uxjMvJK45dmeHcY0RTKHbhS1YUJ6eXtLA
 97q32bVRoxct754KWnKMkA0vDtBGYBSoS1qNdRor1SKiPrsL67V/qrNFzIgjkIDaz3Ev
 Q1vbLFU3eIFfjfn3AnfKotT/5jA7qDmpTLsOi0dfeBJ8W0Alb0Es/F+PanYf9dDWgzh+
 sE6Rz7L9NQTm5ihfAyrsejGL2w5YsWHQO/u8nw9/yPGVgOLmSqSR0bGJKsCmmn1QMD9D
 MySFq0BzkSUXZka1nyVk/TP8t1dCVhZWY+gEcZMmjV0eXQFn56rz7ZL1wugfB3x3pt8O
 2Oag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=pZZ/ZyntFdWScxN0lJA199RTWytNkCmmcoJKmHk/hjk=;
 b=kjdRnEzXfQcL5LF2z+iNGl+UwP3RIJOKAmILkTbhrBisp60JG4aFigqC+ACmsEYZrN
 usMyNOAWGuNiD/D5d5zixVadsYhjSZHiJQF2VFF6av7W9JZEp9y/tW+vMwcGtDW7O1N0
 L+nLneB0eIFFFUwgWo5o1Gbm5IxqBwt6ZvyK2/dsCknwjZGWJVo59+Nnlqtu9npu6P5v
 eDGUWN/cnh1Z0SdEKg/qAbCgAZ7J95GLH3vqci+yBN28Gz0i0b9uQJumAdaklbT77Dch
 XdlJEtMd03dqD2dodKnvKOuazSz+2UQEOKFr5I+l5Ef0ZEaMCMpliNO59ttPCcPrlK2b
 CdqQ==
X-Gm-Message-State: AOAM5308DFfBNAfU9uGup8tMNhnL+JzGW5Eob5/2om1+g93T92JYwoJ9
 4y69FydHcNaqFlcO2S05pKRIZWCEbEvgHtvNFQnuVA==
X-Google-Smtp-Source: ABdhPJwsXGlU/FnpHan4++A1rSsngYWgp/BRajvKK2N0EEge5WE2sBFGiJk6DyI6iKDH0wVg7SYX3iAQQk+9//WuqoM=
X-Received: by 2002:a05:6512:3043:b0:447:b909:b868 with SMTP id
 b3-20020a056512304300b00447b909b868mr3565134lfb.286.1647536220930; Thu, 17
 Mar 2022 09:57:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220317045127.124602-1-ricarkol@google.com>
 <20220317045127.124602-3-ricarkol@google.com>
 <YjLY5y+KObV0AR9g@google.com> <5fe2be916e1dcfe491fd3b40466d1932@kernel.org>
In-Reply-To: <5fe2be916e1dcfe491fd3b40466d1932@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Thu, 17 Mar 2022 09:56:49 -0700
Message-ID: <CAOQ_Qsgnc=WkHfWiQ40HZDdXOtcRCb2-sRG3HCp7ua9VYJ3+DA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: selftests: add arch_timer_edge_cases
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Thu, Mar 17, 2022 at 1:52 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On 2022-03-17 06:44, Oliver Upton wrote:
> > On Wed, Mar 16, 2022 at 09:51:26PM -0700, Ricardo Koller wrote:
> >> Add an arch_timer edge-cases selftest. For now, just add some basic
> >> sanity checks, and some stress conditions (like waiting for the timers
> >> while re-scheduling the vcpu). The next commit will add the actual
> >> edge
> >> case tests.
> >>
> >> This test fails without a867e9d0cc1 "KVM: arm64: Don't miss pending
> >> interrupts for suspended vCPU".
> >>
> >> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> >> Reviewed-by: Raghavendra Rao Ananta <rananta@google.com>
> >> Signed-off-by: Ricardo Koller <ricarkol@google.com>
>
> [...]
>
> >> +            asm volatile("wfi\n"
> >> +                         "msr daifclr, #2\n"
> >> +                         /* handle IRQ */
> >
> > I believe an isb is owed here (DDI0487G.b D1.13.4). Annoyingly, I am
> > having a hard time finding the same language in the H.a revision of the
> > manual :-/
>
> D1.3.6 probably is what you are looking for.
>
> "Context synchronization event" is the key phrase to remember
> when grepping through the ARM ARM. And yes, the new layout is
> a nightmare (as if we really needed an additional 2800 pages...).

Thanks! I have yet to find a PDF viewer that can chew through such a
document for a search term at a decent clip. And all the extra pages
just made the problem even worse.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
