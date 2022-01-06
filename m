Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649CCC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 12:07:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E09814B190;
	Thu,  6 Jan 2022 07:07:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 50IMVLuyHIbb; Thu,  6 Jan 2022 07:07:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2B084B16E;
	Thu,  6 Jan 2022 07:07:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6593E4B168
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jan 2022 07:07:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HIpF89wkoFwJ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Jan 2022 07:07:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1670449F4D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jan 2022 07:07:34 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 81CB312FC;
 Thu,  6 Jan 2022 04:07:33 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6FAF43F774;
 Thu,  6 Jan 2022 04:07:31 -0800 (PST)
Date: Thu, 6 Jan 2022 12:07:38 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 0/4] KVM: arm64: Improve PMU support on heterogeneous
 systems
Message-ID: <Ydbbivoqo3vUxB4j@monolith.localdoman>
References: <20211213152309.158462-1-alexandru.elisei@arm.com>
 <87bl0xzwu1.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87bl0xzwu1.wl-maz@kernel.org>
Cc: mingo@redhat.com, tglx@linutronix.de, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Marc,

On Thu, Dec 30, 2021 at 08:01:10PM +0000, Marc Zyngier wrote:
> Alex,
> 
> On Mon, 13 Dec 2021 15:23:05 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > (CC'ing Peter Maydell in case this might be of interest to qemu)
> > 
> > The series can be found on a branch at [1], and the kvmtool support at [2].
> > The kvmtool patches are also on the mailing list [3] and haven't changed
> > since v1.
> > 
> > Detailed explanation of the issue and symptoms that the patches attempt to
> > correct can be found in the cover letter for v1 [4].
> > 
> > A summary of the problem is that on heterogeneous systems KVM will always
> > use the same PMU for creating the VCPU events for *all* VCPUs regardless of
> > the physical CPU on which the VCPU is running, leading to events suddenly
> > stopping and resuming in the guest as the VCPU thread gets migrated across
> > different CPUs.
> > 
> > This series proposes to fix this behaviour by allowing the user to specify
> > which physical PMU is used when creating the VCPU events needed for guest
> > PMU emulation. When the PMU is set, KVM will refuse to the VCPU on a
> > physical which is not part of the supported CPUs for the specified PMU. The
> > restriction is that all VCPUs must use the same PMU to avoid emulating an
> > asymmetric platform.
> > 
> > The default behaviour stays the same - without userspace setting the PMU,
> > events will stop counting if the VCPU is scheduled on the wrong CPU.
> > 
> > Tested with a hacked version of kvmtool that does the PMU initialization
> > from the VCPU thread as opposed to from the main thread. Tested on
> > rockpro64 by testing what happens when all VCPUs having the same PMU, one
> > random VCPU having a different PMU than the other VCPUs and one random VCPU
> > not having the PMU set (each test was run 1,000 times on the little cores
> > and 1,000 times on the big cores).
> > 
> > Also tested on an Altra by testing all VCPUs having the same PMU, all VCPUs
> > not having a PMU set, and one random VCPU not having the PMU set; the VM
> > had 64 threads in each of the tests and each test was run 10,000 times.
> 
> Came back to this series, and found more problems. On top of the
> remarks I had earlier (the per-CPU data structures that really should
> per VM, the disappearing attribute size), what happens when event
> filters are already registered and that you set a specific PMU?

This is a good point. When I looked at how the PMU event filter works, I
saw that KVM doesn't attempt to check that the events are actually
implemented on the PMU, but somehow skipped over the fact that the PMU
affects the total number of events available.

Thanks,
Alex

> 
> I took the matter in my own hands (the joy of being in quarantine) and
> wrote whatever fixes I thought were necessary[1].
> 
> Please have a look.
> 
> 	M.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pmu-bl
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
