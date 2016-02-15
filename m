From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 00/23] arm64: Virtualization Host Extension support
Date: Mon, 15 Feb 2016 10:23:25 +0000
Message-ID: <20160215102324.GD13683@e104818-lin.cambridge.arm.com>
References: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
 <20160211190701.GA4842@cbox>
 <56BCDCBA.5080202@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56BCDCBA.5080202@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 11, 2016 at 07:10:50PM +0000, Marc Zyngier wrote:
> On 11/02/16 19:07, Christoffer Dall wrote:
> > On Thu, Feb 11, 2016 at 06:39:41PM +0000, Marc Zyngier wrote:
> >> ARMv8.1 comes with the "Virtualization Host Extension" (VHE for
> >> short), which enables simpler support of Type-2 hypervisors.
> >>
> >> This extension allows the kernel to directly run at EL2, and
> >> significantly reduces the number of system registers shared between
> >> host and guest, reducing the overhead of virtualization.
> >>
> >> In order to have the same kernel binary running on all versions of the
> >> architecture, this series makes heavy use of runtime code patching.
> >>
> >> The first 22 patches massage the KVM code to deal with VHE and enable
> >> Linux to run at EL2. The last patch catches an ugly case when VHE
> >> capable CPUs are paired with some of their less capable siblings. This
> >> should never happen, but hey...
> >>
> >> I have deliberately left out some of the more "advanced"
> >> optimizations, as they are likely to distract the reviewer from the
> >> core infrastructure, which is what I care about at the moment.
> >>
> >> Note: GDB is currently busted on VHE systems, as it checks for version
> >>       6 on the debug architecture, while VHE is version 7. The
> >>       binutils people are on the case.
> >>
> >> This has been tested on the FVP_Base_SLV-V8-A model, and based on
> >> v4.5-rc3 + kvmarm/master. I've put a branch out on:
> >>
> >> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/vhe
> > 
> > I'm happy with this series as it stands, we just need someone to take a
> > look at that debug patch and be happy with it.
> 
> I think Will is planning to have a go at it shortly. Once he and Catalin
> are happy with the thing, I'll throw it into -next for a good shake.

Fine by me but it would be good for Will to have a look, especially on
the debug and perf stuff.

-- 
Catalin
