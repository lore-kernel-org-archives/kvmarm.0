Return-Path: <SRS0=vB6B=MO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A5AEC63797
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 15:42:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EEF5F6120C
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 15:42:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EEF5F6120C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E0B24A3B4;
	Thu, 22 Jul 2021 11:42:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ans10XZVTiJD; Thu, 22 Jul 2021 11:42:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50DD94081C;
	Thu, 22 Jul 2021 11:42:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1D1E406D3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 11:42:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 61hdvhU6FPug for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Jul 2021 11:42:40 -0400 (EDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com
 [209.85.167.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E519402DB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 11:42:40 -0400 (EDT)
Received: by mail-lf1-f45.google.com with SMTP id 8so9150792lfp.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 08:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ANvQO69/axclvlEpOBS3JYuVDXJ+POO8G/3hSlcgFno=;
 b=ZCQIvI4CvSnxNpx6lz8iiRE9/A0ehdWfvnifDXdKU5GRMYs5au4LS8oXXzExqmnzdQ
 0VZJJ98I26UL9irET8phzbbWjxkz/itByeXcfPUhxKCjq8BgQeTmDXpvZrGcnQyi0iLn
 0m7HVs1Zn7d67nQGFkRmeMRmdwDc6/1WOf7TEJ8ruDEYQSCKBw/G/wfyoD1D8CoUnmOX
 VOiYiEEiNrYjmlOFG/eqPWN0sFMS0iXgSWR0nuDZCoO5e51tK5FP1Awpu/kuPcGhYrIK
 5Kr/JF9Xfaq8ogw8guhDye8k/+O7l+GQUyJfHR1sSImISI0OBsmA+7I0/DTPOOrXlPgQ
 G6EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ANvQO69/axclvlEpOBS3JYuVDXJ+POO8G/3hSlcgFno=;
 b=dincwr8PnORWkUlGaELZ7AKxJZPm41H4iyK14OCquBEaveebLSVYCQY46+vq4yBrGX
 IpdMmEGi6LzOjTR/D7kzos72IDxCbgNSScsHq75CTixzfx/jpmwOdF25BFx/pyV4OO14
 NsoSqKRh6NeKzQCvPDCTSA8nANvQY3QiM9e8gRpjipdoNej7o2YVGhc0ufhfxlsm/TP/
 HwJUA7qZ52yHGM8I8+1ynnRzZCs+sfZX7jSvYCLOou0Wv+LPrM2htYdDFVmqmUVHb7Vc
 gR0+rysxvUnQec4P0i+xp8puVYDvo3kipfRsaHonLGvoyJGeQAiwvK3lGZF/XDropVla
 PQVQ==
X-Gm-Message-State: AOAM5312AgNEMrwImOPmMVwqg2x20ZHI2GI8IYFfNsNmbpb10T7Sdod2
 Qa2EN6LJxViRumb1dkIEjV/EBqqxU6dqEdyO31Z0qA==
X-Google-Smtp-Source: ABdhPJzic6y0tc96cyVlm1JL6/pJubrETKp8vY7wnwkX0MfRUL8ys308oj6FoydX4iDwhZmV4nZUXQ2juj4W/TRGsAY=
X-Received: by 2002:ac2:555b:: with SMTP id l27mr86978lfk.57.1626968558415;
 Thu, 22 Jul 2021 08:42:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210716212629.2232756-1-oupton@google.com>
 <20210721152808.lsnphkl3urz6bu3v@gator>
In-Reply-To: <20210721152808.lsnphkl3urz6bu3v@gator>
From: Oliver Upton <oupton@google.com>
Date: Thu, 22 Jul 2021 08:42:27 -0700
Message-ID: <CAOQ_Qshr__rtVSk-QUbDxJpjhUW=OAf2=hpAK=ZOEA_NCFpZoQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] KVM: Add idempotent controls for migrating
 system counter state
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Wed, Jul 21, 2021 at 8:28 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Jul 16, 2021 at 09:26:17PM +0000, Oliver Upton wrote:
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
> > introduces new vCPU device attributes to provide userspace access to the
> > vCPU's system counter offset.
> >
> > Patch 1 adopts Paolo's suggestion, augmenting the KVM_{GET,SET}_CLOCK
> > ioctls to provide userspace with a (host_tsc, realtime) instant. This is
> > essential for a VMM to perform precise migration of the guest's system
> > counters.
> >
> > Patches 2-3 add support for x86 by shoehorning the new controls into the
> > pre-existing synchronization heuristics.
> >
> > Patches 4-5 implement a test for the new additions to
> > KVM_{GET,SET}_CLOCK.
> >
> > Patches 6-7 implement at test for the tsc offset attribute introduced in
> > patch 3.
> >
> > Patch 8 adds a device attribute for the arm64 virtual counter-timer
> > offset.
> >
> > Patch 9 extends the test from patch 7 to cover the arm64 virtual
> > counter-timer offset.
> >
> > Patch 10 adds a device attribute for the arm64 physical counter-timer
> > offset. Currently, this is implemented as a synthetic register, forcing
> > the guest to trap to the host and emulating the offset in the fast exit
> > path. Later down the line we will have hardware with FEAT_ECV, which
> > allows the hypervisor to perform physical counter-timer offsetting in
> > hardware (CNTPOFF_EL2).
> >
> > Patch 11 extends the test from patch 7 to cover the arm64 physical
> > counter-timer offset.
> >
> > Patch 12 introduces a benchmark to measure the overhead of emulation in
> > patch 10.
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
> > This series applies cleanly to the following commit:
> >
> > 1889228d80fe ("KVM: selftests: smm_test: Test SMM enter from L2")
> >
> > v1 -> v2:
> >   - Reimplemented as vCPU device attributes instead of a distinct ioctl.
> >   - Added the (realtime, host_tsc) instant support to
> >     KVM_{GET,SET}_CLOCK
> >   - Changed the arm64 implementation to broadcast counter offset values
> >     to all vCPUs in a guest. This upholds the architectural expectations
> >     of a consistent counter-timer across CPUs.
> >   - Fixed a bug with traps in VHE mode. We now configure traps on every
> >     transition into a guest to handle differing VMs (trapped, emulated).
> >
>
> Oops, I see there's a v3 of this series. I'll switch to reviewing that. I
> think my comments / r-b's apply to that version as well though.

Hey Drew,

Thanks for the review. I'll address your comments from both v2 and v3
in the next series.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
