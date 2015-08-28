From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 00/13] arm64: Virtualization Host Extension support
Date: Fri, 28 Aug 2015 08:04:25 +0100
Message-ID: <20150828080425.4fb41861@arm.com>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
	<55DD82FB.60903@huawei.com>
	<55DD851B.4040106@siemens.com>
	<55DD8DEF.9080301@arm.com>
	<55DDA024.8040303@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55DDA024.8040303@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Antonios Motakis <antonios.motakis@huawei.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Claudio Fontana <claudio.fontana@huawei.com>, jani.kokkonen@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 26 Aug 2015 13:16:52 +0200
Antonios Motakis <antonios.motakis@huawei.com> wrote:
> On 26-Aug-15 11:59, Marc Zyngier wrote:

[...]

> > Unfortunately, there is more to downgrading to EL1 than just interrupts.
> > You need to migrate the whole VM context from EL2 to EL1 in an atomic
> > fashion, clear the HCR_EL2.E2H and HCR_EL2.TGE bits while running at EL2
> > (which is a bit like pulling the rug from under your own feet so you
> > need to transition via a low mapping or an idmap), reinstall the EL2
> > stub and do an exception return into EL1.
> 
> When enabling Jailhouse, we already do most of that. We already use
> identity mapping, since we need to switch on the MMU for EL2, switch
> the exception level, etc. Jailhouse entry looks a lot like
> initializing a new kernel; we just save the state of what was running
> before it and restore it as the "root cell".
> 
> So I think we could handle the cpu context switch, with changes only
> in the Jailhouse entry code. But then of course, Linux would be
> expecting to be in EL2, while it is running in EL1, so we would have
> to emulate the differences in behavior. But...

There would be (almost) no difference in behaviour - VHE is designed
for the kernel to be unchanged, and the only difference is the timer
interrupt as you noticed.

What is really tricky is to perform the downgrade, because you're
completely changing the way the code is executed *while running it*.
This is not just about changing the memory map, but also changing the
effect of most system registers.

> 
> > 
> > And that's only for the CPU. Downgrading to EL1 has other fun
> > consequences at the system level (SMMUs listening to TLB traffic
> > would need to be reconfigured on the flight - it's a joke, don't
> > even think of it).
> 
> ...but then there's that.
> 
> Hm... even if the kernel is running in EL2, it will still be
> configuring stage 1 on the SMMU, no? I wonder if this could still be
> handled somehow... The root cell would be restored with identity
> mapping, too... Just thinking out loud :)

Stage-1 and EL2 are two vastly unrelated concept. The main issue is
that it is likely that your SMMU knows about VHE as well (it listens to
EL2-VHE DVM messages), and need to be reconfigured as well. Good luck
with that.

[...]

> > As far as I can see, the only practical solution to this is to have
> > a VHE config option, and Jailhouse that can be set to conflict it
> > (depends on !VHE).
> 
> Having a toggle to turn VHE off at build time would definitely be the
> easy way out. Then we can just tell the user that we only support
> kernels built without it (the Jailhouse driver is out of tree atm).
> 
> I don't have access to a VHE model though. Are you considering to add
> a config option for VHE in the next version of your patches?

Yes, that's the plan.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
