Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F17FFC43217
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 13:51:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4816E4B1C0;
	Tue, 19 Apr 2022 09:51:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6y9DOt0wqjyX; Tue, 19 Apr 2022 09:51:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B7674B205;
	Tue, 19 Apr 2022 09:51:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F264F4B204
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 09:51:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WPlqvyQ0YIpG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 09:51:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE1F04B1AA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 09:51:13 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E1E71063;
 Tue, 19 Apr 2022 06:51:13 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EDB6F3F766;
 Tue, 19 Apr 2022 06:51:11 -0700 (PDT)
Date: Tue, 19 Apr 2022 14:51:05 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu
Subject: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead of
 pinning VM memory
Message-ID: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
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

The approach I've taken so far in adding support for SPE in KVM [1] relies
on pinning the entire VM memory to avoid SPE triggering stage 2 faults
altogether. I've taken this approach because:

1. SPE reports the guest VA on an stage 2 fault, similar to stage 1 faults,
and at the moment KVM has no way to resolve the VA to IPA translation.  The
AT instruction is not useful here, because PAR_EL1 doesn't report the IPA
in the case of a stage 2 fault on a stage 1 translation table walk.

2. The stage 2 fault is reported asynchronously via an interrupt, which
means there will be a window where profiling is stopped from the moment SPE
triggers the fault and when the PE taks the interrupt. This blackout window
is obviously not present when running on bare metal, as there is no second
stage of address translation being performed.

I've been thinking about this approach and I was considering translating
the VA reported by SPE to the IPA instead, thus treating the SPE stage 2
data aborts more like regular (MMU) data aborts. As I see it, this approach
has several merits over memory pinning:

- The stage 1 translation table walker is also needed for nested
  virtualization, to emulate AT S1* instructions executed by the L1
  guest hypervisor.

- Walking the guest's translation tables is less of a departure from the
  way KVM manages physical memory for a virtual machine today.

I had a discussion with Mark offline about this approach and he expressed a
very sensible concern: when a guest is profiling, there is a blackout
window where profiling is stopped which doesn't happen on bare metal (point
2 above).

My questions are:

1. Is having this blackout window, regardless of its size, unnacceptable?
If it is, then I'll continue with the memory pinning approach.

2. If having a blackout window is acceptable, how large can this window be
before it becomes too much? I can try to take some performance measurements
to evaluate the blackout window when using a stage 1 walker in relation to
the buffer write speed on different hardware. I have access to an N1SDP
machine and an Ampere Altra for this.

[1] https://lore.kernel.org/all/20211117153842.302159-1-alexandru.elisei@arm.com/

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
