Return-Path: <SRS0=ZMJ6=GP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 659CFC433E0
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 08:03:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE0E622D58
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 08:03:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE0E622D58
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 017D34B21A;
	Tue, 12 Jan 2021 03:03:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PJJFHMiL6z-k; Tue, 12 Jan 2021 03:03:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D01004B22F;
	Tue, 12 Jan 2021 03:03:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F4E74B209
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 03:03:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D5VcdbFW4O7R for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jan 2021 03:03:12 -0500 (EST)
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com
 [209.85.166.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 566304B204
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 03:03:12 -0500 (EST)
Received: by mail-io1-f53.google.com with SMTP id w18so2231108iot.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 00:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=VnTxaX+GcY6DoNNSvT9wnlvYtM3nEO/7XTuG0gI1XWs=;
 b=hfewghNPsFHp0mZQ+UZ+OAL6KYCEVjtoKn/ofJLXtxK6bQR+/fPOXumwrsQQi8qJ1F
 Oo3BSdV4VqTSYKQIR9PnRXSRwtmzHLvfv5Ebx1RfISFIHbv3FHeeZQpcRl6GDsVBxceY
 LV77Cc/ErsL6i4hIERPP2pFaBijUtp4eo3X5agAzm2qNoBhFDKsUS6xa16s/UrPQ2Ffw
 drLRvW4lPdFCJFacI1SaQZ2PyCUeIBaChFvvcVq57U6q9CXW5LXSb+ZJDA1fhzJBEGiz
 MVB0FECGgX/Wdbl3M2FpmLJ6TK+brHfJaZm5PbQwna1/aSmmm2awr6d4hoVpwBXzVhJE
 J63Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=VnTxaX+GcY6DoNNSvT9wnlvYtM3nEO/7XTuG0gI1XWs=;
 b=DyiSTxh4yqH7PhoIjpZVvfROxXhLXqa7ewiwjhzapO6gL+R3JO4pvEJwGVhiAUiL/3
 oJWssNWM6i7Qq2Ax0cJH78d4xoSaCuun5JbWoHdtWnzMsym51tJT5RMjtsda/Mai0qgo
 /rOSUbP4BY82iqiMEVXcL57hbdpSzSGpgWXrQs/NRtGHx3iaq31RtoriONZ4Xn1adMDp
 EbUGj8l9EVXp0jMYnmRWb/UmHtM5BaTzkyTwlpW4A73E7eFHs7fgEWAT8uxOZfoD1uPh
 Kmr9Ib4h778Ns0x7xfLhBptc2QwQveB/Gw3Qf/u/VdXSO/dAy9DV0d9OJQq4e77m4Iv6
 Ph1g==
X-Gm-Message-State: AOAM532KgXWb3A/4p3R5JC94NabmclMvOp3L2MWl8o/Y1fOo4dEOPd16
 D/dVN1G/wFp/5Gn0qwXGiMJh9OXTEnVhf602g2Rz
X-Google-Smtp-Source: ABdhPJxHFSudvR9q1GJeSbnDqoM/WeTWTAEfSjcQMZGj5ZF/7oNNSYxbVsaGYPUrJ4AVt1YeEp6bTXyLDMfDN4l9iVY=
X-Received: by 2002:a92:98db:: with SMTP id a88mr2851932ill.106.1610438591803; 
 Tue, 12 Jan 2021 00:03:11 -0800 (PST)
MIME-Version: 1.0
References: <20201210160002.1407373-1-maz@kernel.org>
 <CAJc+Z1GFHp17+ROTyDnfS4QLs0kCEVBCD7+OBkHZA53q-zmiLQ@mail.gmail.com>
 <47c1fd0431cb6dddcd9e81213b84c019@kernel.org>
In-Reply-To: <47c1fd0431cb6dddcd9e81213b84c019@kernel.org>
From: Haibo Xu <haibo.xu@linaro.org>
Date: Tue, 12 Jan 2021 16:02:59 +0800
Message-ID: <CAJc+Z1FCQ483Rye9mL=2v2RB+5UMfGRm6WNnKYXxg7Lb=cqPaw@mail.gmail.com>
Subject: Re: [PATCH v3 00/66] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
To: Marc Zyngier <maz@kernel.org>
Cc: Andre Przywara <andre.przywara@arm.com>, kernel-team@android.com,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm@vger.kernel.org
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

On Mon, 11 Jan 2021 at 16:59, Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Haibo,
>
> On 2021-01-11 07:20, Haibo Xu wrote:
> > On Fri, 11 Dec 2020 at 00:00, Marc Zyngier <maz@kernel.org> wrote:
> >>
> >> This is a rework of the NV series that I posted 10 months ago[1], as a
> >> lot of the KVM code has changed since, and the series apply anymore
> >> (not that anybody really cares as the the HW is, as usual, made of
> >> unobtainium...).
> >>
> >> From the previous version:
> >>
> >> - Integration with the new page-table code
> >> - New exception injection code
> >> - No more messing with the nVHE code
> >> - No AArch32!!!!
> >> - Rebased on v5.10-rc4 + kvmarm/next for 5.11
> >>
> >> From a functionality perspective, you can expect a L2 guest to work,
> >> but don't even think of L3, as we only partially emulate the
> >> ARMv8.{3,4}-NV extensions themselves. Same thing for vgic, debug, PMU,
> >> as well as anything that would require a Stage-1 PTW. What we want to
> >> achieve is that with NV disabled, there is no performance overhead and
> >> no regression.
> >>
> >> The series is roughly divided in 5 parts: exception handling, memory
> >> virtualization, interrupts and timers for ARMv8.3, followed by the
> >> ARMv8.4 support. There are of course some dependencies, but you'll
> >> hopefully get the gist of it.
> >>
> >> For the most courageous of you, I've put out a branch[2]. Of course,
> >> you'll need some userspace. Andre maintains a hacked version of
> >> kvmtool[3] that takes a --nested option, allowing the guest to be
> >> started at EL2. You can run the whole stack in the Foundation
> >> model. Don't be in a hurry ;-).
> >>
> >
> > Hi Marc,
> >
> > I got a kernel BUG message when booting the L2 guest kernel with the
> > kvmtool on a FVP setup.
> > Could you help have a look about the BUG message as well as my
> > environment configuration?
> > I think It probably caused by some local configurations of the FVP
> > setup.
>
> No, this is likely a bug in your L1 guest, which was fixed in -rc3:
>
> 2a5f1b67ec57 ("KVM: arm64: Don't access PMCR_EL0 when no PMU is
> available")
>
> and was found in the exact same circumstances. Alternatively, and if
> you don't want to change your L1 guest, you can just pass the --pmu
> option to kvmtool when starting the L1 guest.

After passing --pmu when starting a L1 guest, I can successfully run a
L2 guest now!
Thanks so much for the help!

Haibo

>
> Hope this helps,
>
>          M.
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
