Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E28C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 13 Dec 2021 11:14:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 354254B1CB;
	Mon, 13 Dec 2021 06:14:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BUfaolAx5NFf; Mon, 13 Dec 2021 06:14:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC7A34B1CF;
	Mon, 13 Dec 2021 06:14:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27FF84B1AF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 06:14:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k8AFpdCLaBcS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Dec 2021 06:14:50 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B956B4B1A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 06:14:50 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD5436D;
 Mon, 13 Dec 2021 03:14:49 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 76A3B3F793;
 Mon, 13 Dec 2021 03:14:47 -0800 (PST)
Date: Mon, 13 Dec 2021 11:14:48 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 0/4] KVM: arm64: Improve PMU support on heterogeneous
 systems
Message-ID: <YbcrKAE35GMzPQBt@monolith.localdoman>
References: <20211206170223.309789-1-alexandru.elisei@arm.com>
 <CAAeT=FygprcS3YxbVaW+4yUjHBm8=MxZ+j4_iVjq7ie-ppRKRg@mail.gmail.com>
 <addac215bddf0b86bf6850093d500785@kernel.org>
 <CAAeT=Fzz2UGQAWGx_4piJGng5BKpX3FQrZDA7u2PHFcTRD4G4w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=Fzz2UGQAWGx_4piJGng5BKpX3FQrZDA7u2PHFcTRD4G4w@mail.gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, mingo@redhat.com, tglx@linutronix.de,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi Reiji,

On Sun, Dec 12, 2021 at 10:36:52PM -0800, Reiji Watanabe wrote:
> On Wed, Dec 8, 2021 at 12:05 AM Marc Zyngier <maz@kernel.org> wrote:
> >
> > Reji,
> >
> > On 2021-12-08 02:36, Reiji Watanabe wrote:
> > > Hi Alex,
> > >
> > > On Mon, Dec 6, 2021 at 9:02 AM Alexandru Elisei
> > > <alexandru.elisei@arm.com> wrote:
> > >>
> > >> (CC'ing Peter Maydell in case this might be of interest to qemu)
> > >>
> > >> The series can be found on a branch at [1], and the kvmtool support at
> > >> [2].
> > >> The kvmtool patches are also on the mailing list [3] and haven't
> > >> changed
> > >> since v1.
> > >>
> > >> Detailed explanation of the issue and symptoms that the patches
> > >> attempt to
> > >> correct can be found in the cover letter for v1 [4].
> > >>
> > >> A brief summary of the problem is that on heterogeneous systems KVM
> > >> will
> > >> always use the same PMU for creating the VCPU events for *all* VCPUs
> > >> regardless of the physical CPU on which the VCPU is running, leading
> > >> to
> > >> events suddenly stopping and resuming in the guest as the VCPU thread
> > >> gets
> > >> migrated across different CPUs.
> > >>
> > >> This series proposes to fix this behaviour by allowing the user to
> > >> specify
> > >> which physical PMU is used when creating the VCPU events needed for
> > >> guest
> > >> PMU emulation. When the PMU is set, KVM will refuse to the VCPU on a
> > >> physical which is not part of the supported CPUs for the specified
> > >> PMU.
> > >
> > > Just to confirm, this series provides an API for userspace to request
> > > KVM to detect a wrong affinity setting due to a userspace bug so that
> > > userspace can get an error at KVM_RUN instead of leading to events
> > > suddenly stopping, correct ?
> >
> > More than that, it allows userspace to select which PMU will be used
> > for their guest. The affinity setting is a byproduct of the PMU's own
> > affinity.
> 
> Thank you for the clarification.
> (I overlooked the change in kvm_pmu_create_perf_event()...)
> 
> 
> > >
> > >> The default behaviour stays the same - without userspace setting the
> > >> PMU,
> > >> events will stop counting if the VCPU is scheduled on the wrong CPU.
> > >
> > > Can't we fix the default behavior (in addition to the current fix) ?
> > > (Do we need to maintain the default behavior ??)
> >
> > Of course we do. This is a behaviour that has been exposed to userspace
> > for years, and *we don't break userspace*.
> 
> I'm wondering if it might be better to have kvm_pmu_create_perf_event()
> set attr.type to pmu_id based on the current (physical) CPU by default
> on such heterogeneous systems (even if userspace don't explicitly
> specify pmu_id with the new API).  Then, by setting the CPU affinity,
> the PMU in that environment can behave predictably even with existing
> userspace (or maybe this won't be helpful at all?).

I think then you would end up with the possible mismatch between
kvm->arch.pmuver and the version of the PMU that is used for creating the
events.

Also, as VCPUs get migrated from one physical CPU to the other, the
semantics of the microarchitectural events change, even if the event ID is
the same.

Thanks,
Alex

> 
> Thanks,
> Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
