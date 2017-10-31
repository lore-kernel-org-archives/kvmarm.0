From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 00/21] SError rework + RAS&IESB for firmware first
 support
Date: Tue, 31 Oct 2017 10:08:29 +0000
Message-ID: <20171031100829.GC5584@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171031063535.GA2166@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F34C49D09
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 06:07:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IPn-RdhrIEGs for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Oct 2017 06:06:53 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEC8440795
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 06:06:53 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20171031063535.GA2166@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 31, 2017 at 07:35:35AM +0100, Christoffer Dall wrote:
> Hi James, Catalin, and Will,
> 
> On Thu, Oct 19, 2017 at 03:57:46PM +0100, James Morse wrote:
> > Hello,
> > 
> > The aim of this series is to enable IESB and add ESB-instructions to let us
> > kick any pending RAS errors into firmware to be handled by firmware-first.
> > 
> > Not all systems will have this firmware, so these RAS errors will become
> > pending SErrors. We should take these as quickly as possible and avoid
> > panic()ing for errors where we could have continued.
> > 
> > This first part of this series reworks the DAIF masking so that SError is
> > unmasked unless we are handling a debug exception.
> > 
> > The last part provides the same minimal handling for SError that interrupt
> > KVM. KVM is currently unable to handle SErrors during world-switch, unless
> > they occur during a magic single-instruction window, it hyp-panics. I suspect
> > this will be easier to fix once the VHE world-switch is further optimised.
> > 
> > KVMs kvm_inject_vabt() needs updating for v8.2 as now we can specify an ESR,
> > and all-zeros has a RAS meaning.
> > 
> > KVM's existing 'impdef SError to the guest' behaviour probably needs revisiting.
> > These are errors where we don't know what they mean, they may not be
> > synchronised by ESB. Today we blame the guest.
> > My half-baked suggestion would be to make a virtual SError pending, but then
> > exit to user-space to give Qemu the change to quit (for virtual machines that
> > don't generate SError), pend an SError with a new Qemu-specific ESR, or blindly
> > continue and take KVMs default all-zeros impdef ESR.
> 
> The KVM side of this series is looking pretty good.
> 
> What are the merge plans for this?  I am fine if you will take this via
> the arm64 tree with our acks from the KVM side.  Alternatively, I
> suppose you can apply all the arm64 patches and provide us with a stable
> branch for that?

I'll take a look this afternoon, but we haven't had a linux next release
since the 18th so I'm starting to get nervous about conflicts if I end up
pulling in new trees now.

Will
