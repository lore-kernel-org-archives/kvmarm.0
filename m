Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED86BC48BCD
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 15:11:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5CC656128A
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 15:11:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CC656128A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9C014083E;
	Wed,  9 Jun 2021 11:11:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ainK9eICQUIr; Wed,  9 Jun 2021 11:11:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C45140C88;
	Wed,  9 Jun 2021 11:11:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D8724083E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 11:11:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tZTRjKQtrq9c for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 11:11:45 -0400 (EDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com
 [209.85.208.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B2AB40821
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 11:11:45 -0400 (EDT)
Received: by mail-lj1-f178.google.com with SMTP id 131so304957ljj.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Jun 2021 08:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=JGUUCTtXTTeYEECuVevk8FQeH2xp0FWF48S+xEf+80E=;
 b=PQfwLDjbofmW9Ahl4Xw3X8MHKyFvvBaielxhyyLoexE2kFNa6Wa68I+LFzVD4TqY4H
 XB0LXx6c0FctXFKycXQaRobS67G+J2comWM2i9a0QGG/6yIL15t5Cqemv6PTgsha8DQV
 MKeAOYjwG/vlh3FWLlM/BtNQmPyLswJdWBBt4SNWjRyZ++g69wPpT6+N0pq5vd0t1lYH
 fX40q7Z8HX1htlFk9kx/4ZaXSheQwAgvQL2FAwVsyBckwqZWEUDPRaXDYwzzA8LTAHpM
 fb/pozSB4V3WPgvEiynEomCs56kveGZgSrMcrlyw0XbqkTd6ok81cTDlLqS2x1p7NGRj
 IBHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=JGUUCTtXTTeYEECuVevk8FQeH2xp0FWF48S+xEf+80E=;
 b=Ftnmu/8qIylQ+sY1c69BOFON+fdt/4QNTHpncHT4AreP5h4dVlYvljZiYELjADzLx2
 ov0GqTlb3ekUZTzcB0Pl6YPvp0uFFGxaEjIq9tq9Adti5K/M+E7qr0uttx2emyuTJ8UI
 1TAFTqmBnsdlxFcJ/gD8YYA5mysUB0/ZDZEREv0e6nGWRUC3Pr4TfHKI1h0H/HdA4420
 74TVbjB4ImF2oio3jBIWPjuPB60hb+RYr1uBrV9P5sZTice4U68PO/WrOa6Tyj4qGVIf
 dF7Z7kraWFoJsRZIeWfNNVAlGEbNwMDpT2WPwcAoFeVz1xlJPGqJ6oTmW/Bg1K5mDnAP
 jkgw==
X-Gm-Message-State: AOAM533p/IIt6qkxJ1HNYPTsj23+JjxFtQB7xH2g21GHyNx8aBSUE/kS
 GqbiDHXELMrRBW/VdwAKcCqCdY4AZF1RnqnJ54iZgA==
X-Google-Smtp-Source: ABdhPJzDC3/C1q9lhv5RzcnKGHEbvuFjt2/BpMm446NEtxECFSiu0Y2oJ55X7bPQrCWKUf1iQTYNh7DBrzWXrkDfPFA=
X-Received: by 2002:a05:651c:a0a:: with SMTP id
 k10mr357832ljq.22.1623251503619; 
 Wed, 09 Jun 2021 08:11:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com>
 <63db3823-b8a3-578d-4baa-146104bb977f@redhat.com>
In-Reply-To: <63db3823-b8a3-578d-4baa-146104bb977f@redhat.com>
From: Oliver Upton <oupton@google.com>
Date: Wed, 9 Jun 2021 10:11:32 -0500
Message-ID: <CAOQ_QsgPHAUuzeLy5sX=EhE8tKs7yEF3rxM47YeM_Pk3DUXMcg@mail.gmail.com>
Subject: Re: [PATCH 00/10] KVM: Add idempotent controls for migrating system
 counter state
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm list <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On Wed, Jun 9, 2021 at 8:06 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 08/06/21 23:47, Oliver Upton wrote:
> > KVM's current means of saving/restoring system counters is plagued with
> > temporal issues. At least on ARM64 and x86, we migrate the guest's
> > system counter by-value through the respective guest system register
> > values (cntvct_el0, ia32_tsc). Restoring system counters by-value is
> > brittle as the state is not idempotent: the host system counter is still
> > oscillating between the attempted save and restore. Furthermore, VMMs
> > may wish to transparently live migrate guest VMs, meaning that they
> > include the elapsed time due to live migration blackout in the guest
> > system counter view. The VMM thread could be preempted for any number of
> > reasons (scheduler, L0 hypervisor under nested) between the time that
> > it calculates the desired guest counter value and when KVM actually sets
> > this counter state.
> >
> > Despite the value-based interface that we present to userspace, KVM
> > actually has idempotent guest controls by way of system counter offsets.
> > We can avoid all of the issues associated with a value-based interface
> > by abstracting these offset controls in new ioctls. This series
> > introduces KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls, meant to provide
> > userspace with idempotent controls of the guest system counter.
>
> Hi Oliver,
>
> I wonder how this compares to the idea of initializing the TSC via a
> synchronized (nanoseconds, TSC) pair.
> (https://lore.kernel.org/r/20201130133559.233242-2-mlevitsk@redhat.com),
> and whether it makes sense to apply that idea to ARM as well.  If so, it
> certainly is a good idea to use the same capability and ioctl, even
> though the details of the struct would be architecture-dependent.

Hey Paolo,

Yeah, great question, I had actually alluded to this on [02/10] in
talking to Marc about this.

Really the issue we want to avoid is sampling the host counter twice,
which at least based on the existing means of counter migration is
impossible as the VMM must account for elapsed time. Maxim's patches
appear to address that very issue as well.

Perhaps this will clarify the motivation for my approach: what if the
kernel wasn't the authoritative source for wall time in a system?
Furthermore, VMMs may wish to define their own heuristics for counter
migration (e.g. we only allow the counter to 'jump' by X seconds
during migration blackout). If a VMM tried to assert its whims on the
TSC state before handing it down to the kernel, we would inadvertently
be sampling the host counter twice again. And, anything can happen
between the time we assert elapsed time is within SLO and KVM
computing the TSC offset (scheduling, L0 hypervisor preemption).

So, Maxim's changes would address my concerns in the general case, but
maybe not as much in edge cases where an operator may make decisions
about how much time can elapse while the guest hasn't had CPU time.

--
Thanks,
Oliver

> In your patches there isn't much architecture dependency in struct
> kvm_system_counter_state.  However,  Maxim's also added an
> MSR_IA32_TSC_ADJUST value to the struct, thus ensuring that the host
> could write not just an arbitrary TSC value, but also tie it to an
> arbitrary MSR_IA32_TSC_ADJUST value.  Specifying both in the same ioctl
> simplifies the userspace API.
>
> Paolo
>
> > Patch 1 defines the ioctls, and was separated from the two provided
> > implementations for the sake of review. If it is more intuitive, this
> > patch can be squashed into the implementation commit.
> >
> > Patch 2 realizes initial support for ARM64, migrating only the state
> > associated with the guest's virtual counter-timer. Patch 3 introduces a
> > KVM selftest to assert that userspace manipulation via the
> > aforementioned ioctls produces the expected system counter values within
> > the guest.
> >
> > Patch 4 extends upon the ARM64 implementation by adding support for
> > physical counter-timer offsetting. This is currently backed by a
> > trap-and-emulate implementation, but can also be virtualized in hardware
> > that fully implements ARMv8.6-ECV. ECV support has been elided from this
> > series out of convenience for the author :) Patch 5 adds some test cases
> > to the newly-minted kvm selftest to validate expectations of physical
> > counter-timer emulation.
> >
> > Patch 6 introduces yet another KVM selftest for aarch64, intended to
> > measure the effects of physical counter-timer emulation. Data for this
> > test can be found below, but basically there is some tradeoff of
> > overhead for the sake of correctness, but it isn't too bad.
> >
> > Patches 7-8 add support for the ioctls to x86 by shoehorning the
> > controls into the pre-existing synchronization heuristics. Patch 7
> > provides necessary helper methods for the implementation to play nice
> > with those heuristics, and patch 8 actually implements the ioctls.
> >
> > Patch 9 adds x86 test cases to the system counter KVM selftest. Lastly,
> > patch 10 documents the ioctls for both x86 and arm64.
> >
> > All patches apply cleanly to kvm/next at the following commit:
> >
> > a4345a7cecfb ("Merge tag 'kvmarm-fixes-5.13-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD")
> >
> > Physical counter benchmark
> > --------------------------
> >
> > The following data was collected by running 10000 iterations of the
> > benchmark test from Patch 6 on an Ampere Mt. Jade reference server, A 2S
> > machine with 2 80-core Ampere Altra SoCs. Measurements were collected
> > for both VHE and nVHE operation using the `kvm-arm.mode=` command-line
> > parameter.
> >
> > nVHE
> > ----
> >
> > +--------------------+--------+---------+
> > |       Metric       | Native | Trapped |
> > +--------------------+--------+---------+
> > | Average            | 54ns   | 148ns   |
> > | Standard Deviation | 124ns  | 122ns   |
> > | 95th Percentile    | 258ns  | 348ns   |
> > +--------------------+--------+---------+
> >
> > VHE
> > ---
> >
> > +--------------------+--------+---------+
> > |       Metric       | Native | Trapped |
> > +--------------------+--------+---------+
> > | Average            | 53ns   | 152ns   |
> > | Standard Deviation | 92ns   | 94ns    |
> > | 95th Percentile    | 204ns  | 307ns   |
> > +--------------------+--------+---------+
> >
> > Oliver Upton (10):
> >    KVM: Introduce KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls
> >    KVM: arm64: Implement initial support for KVM_CAP_SYSTEM_COUNTER_STATE
> >    selftests: KVM: Introduce system_counter_state_test
> >    KVM: arm64: Add userspace control of the guest's physical counter
> >    selftests: KVM: Add test cases for physical counter offsetting
> >    selftests: KVM: Add counter emulation benchmark
> >    KVM: x86: Refactor tsc synchronization code
> >    KVM: x86: Implement KVM_CAP_SYSTEM_COUNTER_STATE
> >    selftests: KVM: Add support for x86 to system_counter_state_test
> >    Documentation: KVM: Document KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls
> >
> >   Documentation/virt/kvm/api.rst                |  98 +++++++
> >   Documentation/virt/kvm/locking.rst            |  11 +
> >   arch/arm64/include/asm/kvm_host.h             |   6 +
> >   arch/arm64/include/asm/sysreg.h               |   1 +
> >   arch/arm64/include/uapi/asm/kvm.h             |  17 ++
> >   arch/arm64/kvm/arch_timer.c                   |  84 +++++-
> >   arch/arm64/kvm/arm.c                          |  25 ++
> >   arch/arm64/kvm/hyp/include/hyp/switch.h       |  31 +++
> >   arch/arm64/kvm/hyp/nvhe/timer-sr.c            |  16 +-
> >   arch/x86/include/asm/kvm_host.h               |   1 +
> >   arch/x86/include/uapi/asm/kvm.h               |   8 +
> >   arch/x86/kvm/x86.c                            | 176 +++++++++---
> >   include/uapi/linux/kvm.h                      |   5 +
> >   tools/testing/selftests/kvm/.gitignore        |   2 +
> >   tools/testing/selftests/kvm/Makefile          |   3 +
> >   .../kvm/aarch64/counter_emulation_benchmark.c | 209 ++++++++++++++
> >   .../selftests/kvm/include/aarch64/processor.h |  24 ++
> >   .../selftests/kvm/system_counter_state_test.c | 256 ++++++++++++++++++
> >   18 files changed, 926 insertions(+), 47 deletions(-)
> >   create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
> >   create mode 100644 tools/testing/selftests/kvm/system_counter_state_test.c
> >
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
