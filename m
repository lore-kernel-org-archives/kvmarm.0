From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 10/21] arm64: KVM: VHE: Split save/restore of sysregs
 shared between EL1 and EL2
Date: Tue, 2 Feb 2016 16:46:45 +0100
Message-ID: <20160202154645.GE6190@cbox>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-11-git-send-email-marc.zyngier@arm.com>
 <20160201135438.GL1478@cbox>
 <56B07ADD.60300@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56B07ADD.60300@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 02, 2016 at 09:46:05AM +0000, Marc Zyngier wrote:
> On 01/02/16 13:54, Christoffer Dall wrote:
> > On Mon, Jan 25, 2016 at 03:53:44PM +0000, Marc Zyngier wrote:
> >> A handful of system registers are still shared between EL1 and EL2,
> >> even while using VHE. These are tpidr*_el[01], actlr_el1, sp0, elr,
> >> and spsr.
> > 
> > So by shared registers you mean registers that do both have an EL0/1
> > version as well as an EL2 version, but where accesses aren't rewritten
> > transparently?
> 
> No, I mean that these registers do *not* have a separate banked version.
> There is only a single set of registers, which have to be save/restored
> the old way.

huh, ARMv8 clearly specifies the existence of TPIDR_EL0, TPIDR_EL1, and
TPIDR_EL2, for example.

I cannot seem to find anywhere in the VHE spec that says that the
TPIDR_EL2 goes away.  I'm confused now.

> 
> > 
> > also, by sp0 do you mean sp_el0, and by elr you mean elr_el1, and by
> > spsr you mean spsr_el1 ?
> 
> sp0 -> sp_el0 indeed. elr and spsr really are the guest PC and PSTATE,
> so I should really reword this commit message, it is utterly confusing.
> 
I guess I don't understand the definition of a 'shared' register given
your comments here...

Thanks,
-Christoffer
