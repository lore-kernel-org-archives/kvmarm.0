Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1ED2C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jan 2022 12:10:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CCCA49F3D;
	Fri,  7 Jan 2022 07:10:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LEvchLGv+Iiy; Fri,  7 Jan 2022 07:10:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39D884B160;
	Fri,  7 Jan 2022 07:10:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 427E149F3D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 07:10:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rNhxZY6rJknL for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jan 2022 07:10:00 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D82749F05
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 07:10:00 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 461B613D5;
 Fri,  7 Jan 2022 04:09:59 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B1D63F774;
 Fri,  7 Jan 2022 04:09:57 -0800 (PST)
Date: Fri, 7 Jan 2022 12:10:05 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH kvmtool 9/9] arm64: Add support for
 KVM_ARM_VCPU_PMU_V3_SET_PMU
Message-ID: <YdgtnQPAsy1hSOWj@monolith.localdoman>
References: <20211115165705.195736-1-alexandru.elisei@arm.com>
 <20211115165705.195736-10-alexandru.elisei@arm.com>
 <87h7ajva2o.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87h7ajva2o.wl-maz@kernel.org>
Cc: will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi Marc,

On Tue, Jan 04, 2022 at 02:39:59PM +0000, Marc Zyngier wrote:
> On Mon, 15 Nov 2021 16:57:05 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > The KVM_ARM_VCPU_PMU_V3_CTRL(KVM_ARM_VCPU_PMU_V3_SET_PMU) VCPU ioctl is
> > used to assign a physical PMU to the events that KVM creates when emulating
> > the PMU for that VCPU. This is useful on heterogeneous systems, when there
> > is more than one hardware PMU present.
> > 
> > The assumption that is made in the implementation is that the user will
> > pin the kvmtool process on a set of CPUs that share the same PMU. This
> > allows kvmtool to set the same PMU for all VCPUs from the main thread,
> > instead of in the individual VCPU threads.
> 
> May I suggest a slightly different use model? Ideally, you'd be able
> to run the vcpu threads on the CPUs matching the PMU affinity, and
> leave all the other threads to roam on other CPUs.

Right now, the only way for userspace to make kvmtool run on a particular
set of CPUs in a heterogeneous configuration is to use taskset, which means
the entire kvmtool process ends up being pinned on a subset of CPUs which
have the same PMU. I would like to keep this approach, as it's simple and
straightforward to implement in kvmtool, and it's easy to change in the
future if there's an incentive to do so.

It's also not clear to me how your suggestion would work. Add a command
line argument to pin all the VCPUs to the specified cpumask?

> 
> With your implementation, the whole of kvmtool gets stuck to a given
> CPU type, which can be problematic.

Do you have a specific use case in mind? Or is it more like a general
concern regarding, for example, the virtio-blk-io or virtio-net-* threads
competing with the VCPU threads if the VM is doing lots of I/O?

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
