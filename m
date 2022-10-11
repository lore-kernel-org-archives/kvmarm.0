Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58503C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 11 Oct 2022 03:50:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A77EC403FD;
	Mon, 10 Oct 2022 23:50:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RYNGdZ4lOdqY; Mon, 10 Oct 2022 23:50:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3D564B19F;
	Mon, 10 Oct 2022 23:50:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 499A340465
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 23:50:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J9oAkkppDbfN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Oct 2022 23:50:13 -0400 (EDT)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A4A84403FD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 23:50:13 -0400 (EDT)
Received: by mail-pj1-f41.google.com with SMTP id
 p3-20020a17090a284300b0020a85fa3ffcso14792726pjf.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 20:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:from:to
 :cc:subject:date:message-id:reply-to;
 bh=HhqceA9XVnV2jj9E6aHbcgTtQtB5Rry1ltkGlDIo+pA=;
 b=J2dNBDaHKoR12uDNtoxL90mg7ZDM/KQOl/HNokibBrEUiPwsGvgQ1E+72raQP420xc
 Dh4fvZ0KnalxEBZWvOVe5+keZ2UP2NyCCOteMva63fW7WWbmPceLlt+FhEATosOj2gJ8
 BbVpLhO3QPvE6lLn1sSlb8gef2/9iT+BiG7H0Nil5k0qp1Ef+shTC60KatBYodqF5aBt
 dNAUQs9ByDwEwuvOJYi8ix1eRwLXF1frndT3u6AkP2Tpz2urU7Jj0u3sEvoVrndPpXW/
 hliUQMouNFYxSj6Jo/XEgVVGrhH0+VgCx2fv6NWT8vIv7MKXu2InTPKJKPxJTQvZz7QY
 I9VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=HhqceA9XVnV2jj9E6aHbcgTtQtB5Rry1ltkGlDIo+pA=;
 b=KdectZMVfg8ZM/5sg4BckAuCx+nxJpi51fVFFtQvZI7DRby19Re4z5YApl6YmkIkse
 3jHLrgkAFWiOKOJ7a6FbrMNKrAL60w8ZQ69kcV0atimFGD0h0mPo81DUkBfKKwd5ybN5
 0Vm4i1+W7V74YQd4So32uQpRhDkCTLBxjLaGPdu25BUdu6KHpjQubmtANWbqCpdNvaMJ
 Q44pPUNvtppPHAVRXdwMcghXNX9aJ74BxnIdiaEr4k/UbHzGTSVkK5hFHdJJnzxfSVId
 vN5iAJO5W8OpKAcPrOeTq3NhZcriCv+NZXZ4iYssjzxLCwyJVk6vnkliKqFORUkKN/HA
 yXRA==
X-Gm-Message-State: ACrzQf0s9gSVUY7W3X2M3ti/gwhvOuWz04LMCaRPMqdTFrZtKlpYuLaF
 YCDGc0ItKvMGC4RoZgMMCd7VYg==
X-Google-Smtp-Source: AMsMyM7DCRFYQkEj/T2FjkIv61uGnwpf5X7GHkQzIRmf2Us4HuI+pNXriPXsIa+FJ/Hzh18avR2o4Q==
X-Received: by 2002:a17:90b:4d8d:b0:20a:ad78:7826 with SMTP id
 oj13-20020a17090b4d8d00b0020aad787826mr24684083pjb.237.1665460212289; 
 Mon, 10 Oct 2022 20:50:12 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 w35-20020a17090a6ba600b0020ad7678ba0sm6790553pjj.3.2022.10.10.20.50.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 10 Oct 2022 20:50:11 -0700 (PDT)
Date: Mon, 10 Oct 2022 20:50:08 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 0/3] arm: pmu: Fixes for bare metal
Message-ID: <Y0Tn8FNjsRgesMjh@google.com>
References: <20220805004139.990531-1-ricarkol@google.com>
 <89c93f1e-6e78-f679-aecb-7e506fa0cea3@redhat.com>
 <YzxmHpV2rpfaUdWi@monolith.localdoman>
 <5b69f259-4a25-18eb-6c7c-4b59e1f81036@redhat.com>
 <Yz1MiE64ZEa7twtM@monolith.localdoman>
 <2c577c0a-7bdb-81b0-f0c3-6ede3688b94d@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2c577c0a-7bdb-81b0-f0c3-6ede3688b94d@redhat.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, andrew.jones@linux.dev,
 kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Oct 05, 2022 at 11:50:09AM +0200, Eric Auger wrote:
> Hi Alexandru,
> =

> On 10/5/22 11:21, Alexandru Elisei wrote:
> > Hi Eric,
> >
> > On Tue, Oct 04, 2022 at 07:31:25PM +0200, Eric Auger wrote:
> >> Hi Alexandru,
> >>
> >> On 10/4/22 18:58, Alexandru Elisei wrote:
> >>> Hi Eric,
> >>>
> >>> On Tue, Oct 04, 2022 at 06:20:23PM +0200, Eric Auger wrote:
> >>>> Hi Ricardo, Marc,
> >>>>
> >>>> On 8/5/22 02:41, Ricardo Koller wrote:
> >>>>> There are some tests that fail when running on bare metal (includin=
g a
> >>>>> passthrough prototype).  There are three issues with the tests.  The
> >>>>> first one is that there are some missing isb()'s between enabling e=
vent
> >>>>> counting and the actual counting. This wasn't an issue on KVM as
> >>>>> trapping on registers served as context synchronization events. The
> >>>>> second issue is that some tests assume that registers reset to 0.  =
And
> >>>>> finally, the third issue is that overflowing the low counter of a
> >>>>> chained event sets the overflow flag in PMVOS and some tests fail by
> >>>>> checking for it not being set.
> >>>>>
> >>>>> Addressed all comments from the previous version:
> >>>>> https://lore.kernel.org/kvmarm/20220803182328.2438598-1-ricarkol@go=
ogle.com/T/#t
> >>>>> - adding missing isb() and fixed the commit message (Alexandru).
> >>>>> - fixed wording of a report() check (Andrew).
> >>>>>
> >>>>> Thanks!
> >>>>> Ricardo
> >>>>>
> >>>>> Ricardo Koller (3):
> >>>>>   arm: pmu: Add missing isb()'s after sys register writing
> >>>>>   arm: pmu: Reset the pmu registers before starting some tests
> >>>>>   arm: pmu: Check for overflow in the low counter in chained counte=
rs
> >>>>>     tests
> >>>>>
> >>>>>  arm/pmu.c | 56 ++++++++++++++++++++++++++++++++++++++-------------=
----
> >>>>>  1 file changed, 39 insertions(+), 17 deletions(-)
> >>>>>
> >>>> While testing this series and the related '[PATCH 0/9] KVM: arm64: P=
MU:
> >>>> Fixing chained events, and PMUv3p5 support' I noticed I have kvm unit
> >>>> test failures on some machines. This does not seem related to those
> >>>> series though since I was able to get them without. The failures hap=
pen
> >>>> on Amberwing machine for instance with the pmu-chain-promotion.
> >>>>
> >>>> While further investigating I noticed there is a lot of variability =
on
> >>>> the kvm unit test mem_access_loop() count. I can get the counter =3D=
 0x1F
> >>>> on the first iteration and 0x96 on the subsequent ones for instance.
> >>>> While running mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E) I =
was
> >>>> expecting the counter to be close to 20. It is on some HW.
> >>>>
> >>>> [..]
> >>>>
> >>>> So I come to the actual question. Can we do any assumption on the
> >>>> (virtual) PMU quality/precision? If not, the tests I originally wrote
> >>>> are damned to fail on some HW (on some other they always pass) and I
> >>>> need to make a decision wrt re-writing part of them, expecially those
> >>>> which expect overflow after a given amount of ops. Otherwise, there =
is
> >>>> either something wrong in the test (asm?) or in KVM PMU emulation.

I don't think it's the asm because in that case the counter value should
be the same every time (even if wrong).

> >>>>
> >>>> I tried to bisect because I did observe the same behavior on some ol=
der
> >>>> kernels but the bisect was not successful as the issue does not happ=
en
> >>>> always.
> >>>>
> >>>> Thoughts?
> >>> Looking at mem_access_loop(), the first thing that jumps out is the f=
act
> >>> that is missing a DSB barrier. ISB affects only instructions, not mem=
ory
> >>> accesses and without a DSB, the PE can reorder memory accesses howeve=
r it
> >>> sees fit.
> >> Following your suggestion I added a dsh ish at the end of loop and
> >> before disabling pmcr_el0 (I hope this is the place you were thinking
> >> of) but unfortunately it does not seem to fix my issue.
> > Yes, DSB ISH after "b.gt 1b\n" and before the write to PMCR_EL0 that
> > disables the PMU.
> >
> > I think you also need a DSB ISH before the write to PMCR_EL0 that enabl=
es
> > the PMU in the first instruction of the asm block. In your example, the
> > MEM_ACCESS event count is higher than expected, and one explanation for=
 the
> > large disparity that I can think of is that previous memory accesses are
> > reordered past the instruction that enables the PMU, which makes the PMU
> > add these events to the total event count.
> =

> Makes sense. I added those at the 2 locations but unfortunately it does
> not change the result for me.
> >
> >>> I also believe precise_instrs_loop() to be in the same situation, as =
the
> >>> architecture doesn't guarantee that the cycle counter increments after
> >>> every CPU cycle (ARM DDI 0487I.a, page D11-5246):
> >>>
> >>> "Although the architecture requires that direct reads of PMCCNTR_EL0 =
or
> >>> PMCCNTR occur in program order, there is no requirement that the count
> >>> increments between two such reads. Even when the counter is increment=
ing on
> >>> every clock cycle, software might need check that the difference betw=
een
> >>> two reads of the counter is nonzero."
> >> OK
> >>> There's also an entire section in ARM DDI 0487I.a dedicated to this, =
titled
> >>> "A reasonable degree of inaccuracy" (page D11-5248). I'll post some
> >>> snippets that I found interesting, but there are more examples and
> >>> explanations to be found in that chapter.
> >> yeah I saw that, hence my question about the reasonable disparity we c=
an
> >> expect from the HW/SW stack.
> >>> "In exceptional circumstances, such as a change in Security state or =
other
> >>> boundary condition, it is acceptable for the count to be inaccurate."
> >>>
> >>> PMCR writes are trapped by KVM. Is a change in exception level an
> >>> "exception circumstance"? Could be, but couldn't find anything defini=
tive.
> >>> For example, the architecture allows an implementation to drop an eve=
nt in
> >>> the case of an interrupt:
> >>>
> >>> "However, dropping a single branch count as the result of a rare
> >>> interaction with an interrupt is acceptable."
> >>>
> >>> So events could definitely be dropped because of an interrupt for the=
 host.
> >>>
> >>> And there's also this:
> >>>
> >>> "The imprecision means that the counter might have counted an event a=
round
> >>> the time the counter was disabled, but does not allow the event to be
> >>> observed as counted after the counter was disabled."
> >> In our case there seems to be a huge discrepancy.
> > I agree. There is this about the MEM_ACCESS event in the Arm ARM:
> >
> > "The counter counts each Memory-read operation or Memory-write operation
> > that the PE makes."
> >
> > As for what a Memory-read operation is (emphasis added by me):
> >
> > "A memory-read operation might be due to:
> > The result of an architecturally executed memory-reading instructions.
> > The result of a Speculatively executed memory-reading instructions <- t=
his
> > is why the DSB ISH is needed before enabling the PMU.
> > **A translation table walk**."
> >
> > Those extra memory accesses might be caused by the table walker decidin=
g to
> > walk the tables, speculatively or not. Software has no control over the
> > table walker (as long as it is enabled).
> That's indeed an interesting track. But can it be possible that for 20
> expected load instructions we end up with ~150 actual memory accesses.
> I can't help thinking this is a quite surprising amount.=A0 Also the
> pattern is surprising: the first iteration gives low counter count (~30)
> while subsequent ones bring higher and constant ones (~150). I would
> have expected the opposite, no? I will try to run the same experience on
> various HW I have access to.
> =

> Anyway there is a problem while interpreting the result of the tests.
> Either it can happen on some HW (it is a valid behavior according to the
> ARM spec) and the test is simply not runnable or it is a bug somewhere
> in the SW stack.=A0
> =

> It would be interesting to run the same tests at baremetal level on
> Amberwing and see what are the results. Ricardo/Drew, could you give
> some links about the setup?

Actually, the "bare metal" tests I performed were on a prototype
passthrough implementation:
https://github.com/ricarkol/linux/commit/c2b009e813e18e89d6945915bd3ae5787b=
be3164
Let me know how it goes.

Thanks,
Ricardo

> =

> Thanks
> =

> Eric
> >
> > Thanks,
> > Alex
> >
> >>> If you want my opinion, if it is necessary to count the number of eve=
nts
> >>> for a test instead, I would define a margin of error on the number of
> >>> events counted. Or the test could be changed to check that at least o=
ne
> >>> such event was observed.
> >> I agree with you on the fact a reasonable margin must be observed and
> >> the tests may need to be rewritten to account for the observed dispari=
ty
> >> if considered "normal". Another way to proceed is to compute the
> >> disparity before launching the main tests and if too big, skip the main
> >> tests. Again on some HW, the counts are really 'as expected' and const=
ant.
> >>
> >> Thanks!
> >>
> >> Eric
> >>> Thanks,
> >>> Alex
> >>>
> =

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
