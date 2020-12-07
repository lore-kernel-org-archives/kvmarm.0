Return-Path: <SRS0=wPN+=FL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11997C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 11:40:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 45F4C23356
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 11:40:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 45F4C23356
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 867C24B270;
	Mon,  7 Dec 2020 06:40:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G2wRBaorPO6T; Mon,  7 Dec 2020 06:40:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 767824B272;
	Mon,  7 Dec 2020 06:40:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1C154B261
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 06:14:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GaW2kB4kyY-K for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 06:14:58 -0500 (EST)
Received: from mail-ot1-f67.google.com (mail-ot1-f67.google.com
 [209.85.210.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F46B4B259
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 06:14:58 -0500 (EST)
Received: by mail-ot1-f67.google.com with SMTP id b62so12092930otc.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Dec 2020 03:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=CDa/bzky3vYFC4xxSuOCp3ghimMh4GECLA5nY8N/fUQ=;
 b=hx+OgTRg5lMLP/kziSxsNaPlM9h2bc2RfQU1/rtzHESa+ND7aVRNCI71QM0YImfqD0
 Yo7+sxC3NskWKOJ5qtEaRy2IkavFgsVP3/elyHZ54eLjZ8ivjJEFr9e1y4ZbnrR+PluY
 jU+fxcy5C4KfEcCdZ4ldf+gfP4A4lNdwAGts4GanpY6rH8TLvlhbeziXFP3AURCQkk6o
 qxxaLHefzbURt+R16gnQNPuw2WmUkWUwSLLEjU11anroQQoRnhfat/5vzTKg/ecIuDIk
 tbkw0HoB/eycgrorYAdbZg16XToNfwuGPO3grCwFsE3nEnA1CrxjrY9Y+OcPpzc2fxh+
 R36Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=CDa/bzky3vYFC4xxSuOCp3ghimMh4GECLA5nY8N/fUQ=;
 b=IXOHHcJf0fmxEuOC5Q6pFGIYT56KOTygVRos0Ghx4NqKgiV5WyZET7QXMXaRorahoD
 VR0EggPCk49a+NlGTC6R9jsaepyfpExZLc+M/mNSnpxXgBPnm5Frp/vjXCjHzqXvb6Ue
 H76UGUQFHwRTkrYZh7OrHJenyzMeGTY9ljk3pME2XmTyYbUejefcflJPI0ZasA9SpGkL
 Cmvg1wNFfdfDrk/KDs65US2gib3Aox51SCRb4SR9/K3S/md+H1xirEZMdfzBVsKCsIxX
 STz3jFBtXXAz/I7XqOR5ej14iWaATcLlvdbooi+Nnw0d50JZ2y5dX764SsLXJQLEQAFj
 zfAw==
X-Gm-Message-State: AOAM533LWu5zvDZ9NWRh7lMc14AtP5sC6tRak+cedV9z3cm9f5XvJRhh
 GouE2sPMuVQh/gcLjSXISApRy8u/2znC+te/+HQqrA==
X-Google-Smtp-Source: ABdhPJwk058/GoMNmNv+Cj4Gd61prkxnZJl7VLyI6OsONWjVjNF7OnNL2pO01+T+Vs49sYtWvkNtfDJkxu+1vSquZbE=
X-Received: by 2002:a05:6830:117:: with SMTP id
 i23mr12717618otp.365.1607339697581; 
 Mon, 07 Dec 2020 03:14:57 -0800 (PST)
MIME-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-17-qperret@google.com>
 <CA+EHjTyJnZ8e=AN7H_k+oZb0VTWAgMicMY8Rqe2Di_3A87hm0A@mail.gmail.com>
 <X8p5kLSIq2MoQZ24@google.com> <20201207102002.GA3825@willie-the-truck>
 <20201207110528.GA18365@C02TD0UTHF1T.local>
In-Reply-To: <20201207110528.GA18365@C02TD0UTHF1T.local>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 7 Dec 2020 11:14:21 +0000
Message-ID: <CA+EHjTwp7Kndg7-qT=Q0V-wOK+EuUf_K_efMfFe-qo-4dY91Bw@mail.gmail.com>
Subject: Re: [RFC PATCH 16/27] KVM: arm64: Prepare Hyp memory protection
To: Mark Rutland <mark.rutland@arm.com>
X-Mailman-Approved-At: Mon, 07 Dec 2020 06:40:40 -0500
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, Android KVM <android-kvm@google.com>,
 Will Deacon <will@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 Rob Herring <robh+dt@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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

On Mon, Dec 7, 2020 at 11:05 AM Mark Rutland <mark.rutland@arm.com> wrote:
>
> On Mon, Dec 07, 2020 at 10:20:03AM +0000, Will Deacon wrote:
> > On Fri, Dec 04, 2020 at 06:01:52PM +0000, Quentin Perret wrote:
> > > On Thursday 03 Dec 2020 at 12:57:33 (+0000), Fuad Tabba wrote:
> > > <snip>
> > > > > +SYM_FUNC_START(__kvm_init_switch_pgd)
> > > > > +       /* Turn the MMU off */
> > > > > +       pre_disable_mmu_workaround
> > > > > +       mrs     x2, sctlr_el2
> > > > > +       bic     x3, x2, #SCTLR_ELx_M
> > > > > +       msr     sctlr_el2, x3
> > > > > +       isb
> > > > > +
> > > > > +       tlbi    alle2
> > > > > +
> > > > > +       /* Install the new pgtables */
> > > > > +       ldr     x3, [x0, #NVHE_INIT_PGD_PA]
> > > > > +       phys_to_ttbr x4, x3
> > > > > +alternative_if ARM64_HAS_CNP
> > > > > +       orr     x4, x4, #TTBR_CNP_BIT
> > > > > +alternative_else_nop_endif
> > > > > +       msr     ttbr0_el2, x4
> > > > > +
> > > > > +       /* Set the new stack pointer */
> > > > > +       ldr     x0, [x0, #NVHE_INIT_STACK_HYP_VA]
> > > > > +       mov     sp, x0
> > > > > +
> > > > > +       /* And turn the MMU back on! */
> > > > > +       dsb     nsh
> > > > > +       isb
> > > > > +       msr     sctlr_el2, x2
> > > > > +       isb
> > > > > +       ret     x1
> > > > > +SYM_FUNC_END(__kvm_init_switch_pgd)
> > > > > +
> > > >
> > > > Should the instruction cache be flushed here (ic iallu), to discard
> > > > speculatively fetched instructions?
> > >
> > > Hmm, Will? Thoughts?
> >
> > The I-cache is physically tagged, so not sure what invalidation would
> > achieve here. Fuad -- what do you think could go wrong specifically?
>
> While the MMU is off, instruction fetches can be made from the PoC
> rather than the PoU, so where instructions have been modified/copied and
> not cleaned to the PoC, it's possible to fetch stale copies into the
> I-caches. The physical tag doesn't prevent that.
>
> In the regular CPU boot paths, __enabble_mmu() has an IC IALLU after
> enabling the MMU to ensure that we get rid of anything stale (e.g. so
> secondaries don't miss ftrace patching, which is only cleaned to the
> PoU).
>
> That might not be a problem here, if things are suitably padded and
> never dynamically patched, but if so it's probably worth a comment.
>
> Fuad, is that the sort of thing you were considering, or did you have
> additional concerns?

No other concerns. Thanks Mark.
/fuad
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
