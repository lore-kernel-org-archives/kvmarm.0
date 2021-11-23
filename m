Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB427C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 23 Nov 2021 06:33:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CEBB4B15C;
	Tue, 23 Nov 2021 01:33:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WX2-PKRcHnzw; Tue, 23 Nov 2021 01:33:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED0AC4B0C3;
	Tue, 23 Nov 2021 01:33:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 713D34A531
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 01:33:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JZas5HcpLeYn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Nov 2021 01:33:39 -0500 (EST)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2A8924A19A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 01:33:39 -0500 (EST)
Received: by mail-pj1-f52.google.com with SMTP id iq11so15781988pjb.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 22:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=N1DhwfL/dAaPxWYOCXBEgHNa0iAItO0iF87qmEq8azM=;
 b=Lsx/ceq6Amb35FAv277nuefAnbs70GD9bILMPu7hXr2SQAmEIjqNyS0jwThXRqZWOB
 /c6olH5mcnpP32La6Dc4bF2RBpcBHz+J/fQyGO6uhqngE5kS/xliULNjV5MwLtXliZWz
 H7aSSwiF6GFIiv/epnQ4qMKv/XraA7ifrihKd5gxo0L8z5QnuzumcDWkt7EbUaZ+rpTM
 hw6NyCpEF6AD7cMBYs5OpO9tutG7ZRXmCAf+RS3UVF1gbMTrYhXh9yORwlAiDJzLQDfM
 wt/TDbYyzpua+rDJLRyqrrAFZnWjkCqv4iXgCxSzmPXgLe/1llfSGm7g/Vvw5XYDltje
 497g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=N1DhwfL/dAaPxWYOCXBEgHNa0iAItO0iF87qmEq8azM=;
 b=n5MaS+dLtuATu8rRO4KXT87EzqVwQq5elgH1B0XpatzMMSBwy8aGyBN1ZNe4FHwbZq
 RnhYOVtv61z/AX3n8lnBbE34NEhV18xRUIQC3ygZGV16sqxftI2QWOzX75jzkHGCz4P/
 d2CGs5tEDbIkyOU4Ir6gvX8HCzfsIrNlajtmRLU90wbIoONcHfISi+NgV7EOOiN0HbTv
 j0vx17bdWo+mzEpa/J2e71IQahbBXfM6KpvWa3hee6AUjI3vurHE+RIYrfgU4nm1rY1r
 tKPV/prf+2CVu0u3hFdFfkLDHrdM1PG/ylcvqCGDLBLvQUAgRwqDvwbTsLY3THr+v7gu
 3vKQ==
X-Gm-Message-State: AOAM532UwBx7VsmLzJJ2ZrMCabMHomNIo/potLEyasZDUbwUUvQXmCwl
 xptVjZ+yonY1CW7Z6vXUR+m6y33e6tiHr8sOHesPqg==
X-Google-Smtp-Source: ABdhPJxJGk4RZIvde1sXTurZ/i5ykabAS+rsbgQfmHlHHIvts4RAk8a4NDOxu0z5sBvZxls5rl4QLmeBeTZWsvu/lhM=
X-Received: by 2002:a17:90b:380d:: with SMTP id
 mq13mr102324pjb.110.1637649218063; 
 Mon, 22 Nov 2021 22:33:38 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-30-reijiw@google.com>
 <a695d763-b631-e639-3708-2623f4842064@redhat.com>
 <CAAeT=FwmmLJCR-WumnvxjiRuafD_7gr3JjHZWWO5O=jedh2daQ@mail.gmail.com>
 <8dfa692e-5aa1-c6b3-55f8-3c2bb83df9cd@redhat.com>
In-Reply-To: <8dfa692e-5aa1-c6b3-55f8-3c2bb83df9cd@redhat.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 22 Nov 2021 22:33:21 -0800
Message-ID: <CAAeT=FzAiM3RwyFSrTvrXPCUvM7Rr87LLVuMZ8r1pC0i2JtMFw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 29/29] KVM: arm64: selftests: Introduce id_reg_test
To: Eric Auger <eauger@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
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

Hi Eric,

> >> After fixing the mem_pages stuff I get the following error on a cavium
> >> machine.
> >>
> >> augere@virtlab-arm04:~/UPSTREAM/ML/tools/testing/selftests/kvm#
> >> ./aarch64/id_reg_test
> >> ==== Test Assertion Failure ====
> >>   aarch64/id_reg_test.c:814: fval >= min
> >>   pid=11692 tid=11692 errno=4 - Interrupted system call
> >>      1  0x00000000004028d3: test_feature at id_reg_test.c:813
> >>      2   (inlined by) test_feature_all at id_reg_test.c:863
> >>      3   (inlined by) run_test at id_reg_test.c:1073
> >>      4  0x000000000040156f: main at id_reg_test.c:1124
> >>      5  0x000003ffa9420de3: ?? ??:0
> >>      6  0x00000000004015eb: _start at :?
> >>   PERFMON field of ID_DFR0 is too small (0)
> >>
> >> Fails on
> >> test_feature: PERFMON (reg ID_DFR0)
> >>
> >> I will do my utmost to further debug
> >
> > Thank you for running it in your environment and reporting this !
> > This is very interesting...
> >
> > It implies that the host's ID_DFR0_EL1.PerfMon is zero or 0xf
> > (meaning FEAT_PMUv3 is not implemented) even though the host's
> > ID_AA64DFR0_EL1.PMUVer indicates that FEAT_PMUv3 is implemented.
> >
> > Would it be possible for you to check values of those two
> > registers on the host (not on the guest) to see if both of them
> > indicate the presence of FEAT_PMUv3 consistently ?
>
> Here are both values printed in armpmu_register()
> [   33.320901] armpmu_register perfmon=0x0 pmuver=0x4
>
>         perfmon =
> cpuid_feature_extract_unsigned_field(read_cpuid(ID_DFR0_EL1),
>                         ID_DFR0_PERFMON_SHIFT);
>         pmuver =
> cpuid_feature_extract_unsigned_field(read_cpuid(ID_AA64DFR0_EL1),
>                         ID_AA64DFR0_PMUVER_SHIFT);
>         printk("%s perfmon=0x%x pmuver=0x%x\n", __func__, perfmon, pmuver);
>
> My machine is a Gigabyte R181-T90 (ThunderX2)

Thank you for your providing the information !!

Since the test incorrectly expects that ID_DFR0_EL1.PerfMon indicates
PMUv3 on any CPUs that support PMUv3 even when they don't support
32bit EL0, I will fix the test.
(ThunderX2 doesn't seem to support 32bit EL0)

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
