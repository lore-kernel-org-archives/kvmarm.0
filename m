Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8023C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 06:25:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AEF94B225;
	Tue, 14 Dec 2021 01:25:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 60TqLt+HOgcB; Tue, 14 Dec 2021 01:24:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABF804B215;
	Tue, 14 Dec 2021 01:24:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 975614B210
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 01:24:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id reoXjyjQF2ej for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 01:24:56 -0500 (EST)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F075B4B177
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 01:24:55 -0500 (EST)
Received: by mail-pl1-f172.google.com with SMTP id u11so12862626plf.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 22:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=LoaZQigL18c3k3q4GoPMVus3bLTxY9Gu+xIYAfRjgXM=;
 b=TBQBu93ueCZ0dgA1hMyK5FIsG3hyd/ak9XxzVNr4ju+N5bfJPqbw5dOpnc265jqcu9
 tI5TQQE9D+WWjvLNb02wDyvW8w5gve2+gE5ze7+qNxZW+eyQAFkBaIe9ZFR7kZ8zN5lb
 2QuXMfvgzyE6xytkvz1fkRigOhJ6QV1me2sLD9zCNKOC0kvYD5Kx+Dmj1rGASI9+Sv0v
 lce0Lr5GmFji9sCCanRQDn9ge0UK00WyhPfp1xMWogVyKbJJLOtaoJkk+axPQCzfSS5b
 jpCw4an+mMaEmYCNorXR09sJnj47UZLudSQA0UnNxnN0aQSuKz6lY5rW2on7kNBKgkaq
 K16Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=LoaZQigL18c3k3q4GoPMVus3bLTxY9Gu+xIYAfRjgXM=;
 b=0Pc361WTpKfJVh64rA46mYeWjo73DKU/1WKL170+QMBPM6KL0ZIBXHrO15st9aX1Wz
 bf67kEwrOdd4cuRkJd1hAPvqac9gA8h29Pb0YcxVQZ8bHzjIRQePKUjRURahMnRfyV1L
 GTxmVzYqB8VQMWfYI4V4HjVuqSpGopNKPBBspydZfonHgKUg/SFdd2UZGF/MNe8JNJE1
 shKG8kS8YLKtOGpnpog97C8ozSgvsydm1I2V2X0+bwJ4JxebCzyYWEpgbFadHVoWVQ1g
 0A/XnBhj5k/nUqNKs6piG34DErv3W+VHqr00fr2rbR6OQrXZkCA4107Q6PCd4cNJag54
 5qFw==
X-Gm-Message-State: AOAM5311nMgUFl6D4GPAR0YYpnEVTGhL1WjPBF2tKSQG4WipQOvK4umA
 R3958oOv6iydXDv1Q18Kd746OQxrcm3T1ywwmvt/Zw==
X-Google-Smtp-Source: ABdhPJwECv9Wy0PclvJ4Iad7r2fi5mZLdFeXKGlmDlK8WbnuxzUj2qmR+8NIi7Wlnjs1XErFEhQRH1oJPYIU3l9w7ug=
X-Received: by 2002:a17:90b:4acd:: with SMTP id
 mh13mr3598115pjb.230.1639463094882; 
 Mon, 13 Dec 2021 22:24:54 -0800 (PST)
MIME-Version: 1.0
References: <20211206170223.309789-1-alexandru.elisei@arm.com>
 <CAAeT=FygprcS3YxbVaW+4yUjHBm8=MxZ+j4_iVjq7ie-ppRKRg@mail.gmail.com>
 <addac215bddf0b86bf6850093d500785@kernel.org>
 <CAAeT=Fzz2UGQAWGx_4piJGng5BKpX3FQrZDA7u2PHFcTRD4G4w@mail.gmail.com>
 <YbcrKAE35GMzPQBt@monolith.localdoman>
In-Reply-To: <YbcrKAE35GMzPQBt@monolith.localdoman>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 13 Dec 2021 22:24:38 -0800
Message-ID: <CAAeT=FxK2F+GUdJ_0z6rb4F5ttjW5ZyD7Sa_eyiaKc=xxDdMkg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] KVM: arm64: Improve PMU support on heterogeneous
 systems
To: Alexandru Elisei <alexandru.elisei@arm.com>
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

Hi Alex,

On Mon, Dec 13, 2021 at 3:14 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi Reiji,
>
> On Sun, Dec 12, 2021 at 10:36:52PM -0800, Reiji Watanabe wrote:
> > On Wed, Dec 8, 2021 at 12:05 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > Reji,
> > >
> > > On 2021-12-08 02:36, Reiji Watanabe wrote:
> > > > Hi Alex,
> > > >
> > > > On Mon, Dec 6, 2021 at 9:02 AM Alexandru Elisei
> > > > <alexandru.elisei@arm.com> wrote:
> > > >>
> > > >> (CC'ing Peter Maydell in case this might be of interest to qemu)
> > > >>
> > > >> The series can be found on a branch at [1], and the kvmtool support at
> > > >> [2].
> > > >> The kvmtool patches are also on the mailing list [3] and haven't
> > > >> changed
> > > >> since v1.
> > > >>
> > > >> Detailed explanation of the issue and symptoms that the patches
> > > >> attempt to
> > > >> correct can be found in the cover letter for v1 [4].
> > > >>
> > > >> A brief summary of the problem is that on heterogeneous systems KVM
> > > >> will
> > > >> always use the same PMU for creating the VCPU events for *all* VCPUs
> > > >> regardless of the physical CPU on which the VCPU is running, leading
> > > >> to
> > > >> events suddenly stopping and resuming in the guest as the VCPU thread
> > > >> gets
> > > >> migrated across different CPUs.
> > > >>
> > > >> This series proposes to fix this behaviour by allowing the user to
> > > >> specify
> > > >> which physical PMU is used when creating the VCPU events needed for
> > > >> guest
> > > >> PMU emulation. When the PMU is set, KVM will refuse to the VCPU on a
> > > >> physical which is not part of the supported CPUs for the specified
> > > >> PMU.
> > > >
> > > > Just to confirm, this series provides an API for userspace to request
> > > > KVM to detect a wrong affinity setting due to a userspace bug so that
> > > > userspace can get an error at KVM_RUN instead of leading to events
> > > > suddenly stopping, correct ?
> > >
> > > More than that, it allows userspace to select which PMU will be used
> > > for their guest. The affinity setting is a byproduct of the PMU's own
> > > affinity.
> >
> > Thank you for the clarification.
> > (I overlooked the change in kvm_pmu_create_perf_event()...)
> >
> >
> > > >
> > > >> The default behaviour stays the same - without userspace setting the
> > > >> PMU,
> > > >> events will stop counting if the VCPU is scheduled on the wrong CPU.
> > > >
> > > > Can't we fix the default behavior (in addition to the current fix) ?
> > > > (Do we need to maintain the default behavior ??)
> > >
> > > Of course we do. This is a behaviour that has been exposed to userspace
> > > for years, and *we don't break userspace*.
> >
> > I'm wondering if it might be better to have kvm_pmu_create_perf_event()
> > set attr.type to pmu_id based on the current (physical) CPU by default
> > on such heterogeneous systems (even if userspace don't explicitly
> > specify pmu_id with the new API).  Then, by setting the CPU affinity,
> > the PMU in that environment can behave predictably even with existing
> > userspace (or maybe this won't be helpful at all?).
>
> I think then you would end up with the possible mismatch between
> kvm->arch.pmuver and the version of the PMU that is used for creating the
> events.

Yes, but, I would think we can have kvm_pmu_create_perf_event()
set vcpu->arch.pmu.arm_pmu based on the current physical CPU
when vcpu->arch.pmu.arm_pmu is null (then, the pmuver is handled
as if KVM_ARM_VCPU_PMU_V3_SET_PMU was done implicitly).


> Also, as VCPUs get migrated from one physical CPU to the other, the
> semantics of the microarchitectural events change, even if the event ID is
> the same.

Yes, I understand.  As mentioned, this can work only when the
CPU affinity is set for vCPU threads appropriately (, which could
be done even without changing userspace).

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
