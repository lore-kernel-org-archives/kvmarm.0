From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC] KVM API extensions for SVE
Date: Mon, 11 Dec 2017 14:51:36 +0000
Message-ID: <20171211145135.GK22781@e103592.cambridge.arm.com>
References: <20171121134913.GI22781@e103592.cambridge.arm.com>
 <20171122195230.GT28855@cbox>
 <20171123184050.GM22781@e103592.cambridge.arm.com>
 <20171124144538.GG28855@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63A6649D63
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 09:48:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hc805P7ncsbD for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Dec 2017 09:48:13 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9385E49D62
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 09:48:13 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171124144538.GG28855@cbox>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 24, 2017 at 03:45:38PM +0100, Christoffer Dall wrote:
> On Thu, Nov 23, 2017 at 06:40:50PM +0000, Dave Martin wrote:
> > On Wed, Nov 22, 2017 at 08:52:30PM +0100, Christoffer Dall wrote:
> > > Hi Dave,
> > > 
> > > On Tue, Nov 21, 2017 at 01:49:16PM +0000, Dave Martin wrote:
> > > > Hi all,
> > > > 
> > > > SVE adds some new registers, and their size depends on the hardware ando
> > > > on runtime sysreg settings.
> > > > 
> > > > Before coding something, I'd like to get people's views on my current
> > > > approach here.
> > > > 
> > > > --8<--
> > > > 
> > > > New vcpu feature flag:
> > > > /*
> > > >  * userspace can support regs up to at least 2048 bits in size via ioctl,
> > > >  * and will honour the size field in the reg iD
> > > >  */
> > > > #define KVM_ARM_VCPU_LARGE_REGS	4
> > > > 
> > > > Should we just error out of userspace fails to set this on a system that
> > > > supports SVE, or is that too brutal?  
> > > 
> > > That would break older userspace on newer kernels on certain hardware,
> > > which would certainly not be acceptable.  Or did I misunderstand?
> > 
> > Yes, which is probably bad.
> > 
> > I'm still trying to gauge the policy regarding backwards compatibility.
> > 
> 
> Think if QEMU as any other userspace application.  We should really
> never regress userspace.
> 
> > 
> > So, I guess you're saying is that we should disable SVE for the guest
> > but still run it in this case.
> > 
> 
> That's slightly more debatable, but doing it any other way would break
> any form of migration that relies on the guest configuration of SVE and
> userspace would have no way to know.  I think this sounds like a bad
> idea.
> 
> > 
> > This creates another issue: if SVE is supported by the host kernel
> > but not enabled for the guest, do I need to hist the SVE regs from
> > KVM_GET_REG_LIST?
> 
> I don't think so.  We should check with QEMU and kvmtool, but I think
> the way it works is that userspace matches the KVM list with its own
> internal list, and matches up anything it knows about, and discards the
> rest.  Certainly in the past we haven't been afraid of adding registers
> to KVM_GET_REG_LIST.
> 
> > 
> > If not, a guest that doesn't have SVE created on a host that supports
> > SVE would not be migratable to a host kernel that doesn't support SVE
> > but otherwise could run the guest:  as I understand it, the attempt to
> > restore the SVE regs on the target node would fail because the host
> > kernel doesn't recognise those regs.
> > 
> > Or do we not claim to support backwards compatibility for migration?
> > 
> 
> I think QEMU and higher level tools like libvirt would have the
> knowledge to figure this out and implement what they want, so from the
> kernel's point of view, I think we can simply export the registers when
> SVE is supported.
> 
> > > 
> > > > If we do treat that as an error,
> > > > then we can unconditionally enable SVE for the guest when the host
> > > > supports it -- which cuts down on unnecessary implementation complexity.
> > > 
> > > I think it makes sense to be able to disable SVE, especially if there's
> > > high overhead related to context switching the state.  Since you say the
> > > implementation complexity is unnecessary, I may be missing some larger
> > > point?
> > 
> > I don't think it's all that bad, but there doesn't seem to be any
> > example of an optional architecture feature for a guest today --
> > so I wanted to check before setting a precedent here.
> 
> We don't enable the GIC unless userspace asks for it, same with the
> PMU...
> 
> > 
> > Would "SVE enabled" be better as an attribute, rather than a
> > feature, or does it not really matter?
> > 
> 
> Doesn't matter.  It's a question of what you need in terms of the ABI.
> 
> > > > 
> > > > Alternatively, we would need logic to disable SVE if userspace is too
> > > > old, i.e., doesn't set this flag.  Then we might need to enforce that
> > > > the flag is set the same on every vcpu -- but from the kernel's PoV
> > > > it probably doesn't matter.
> > > 
> > > Not sure I understand why it doesn't matter from the kernel's PoV.
> > > 
> > > I think SVE should be disabled by default (as it is now) and then we
> > > should expose a capability (potentially simply via the vcpu attributes
> > > being present), and let userspace enable SVE and set a vector length.
> > 
> > Yes, but aren't all the attributes/features per-vcpu?
> > 
> 
> Yes, so the kernel should check that everything is configured
> consistently across all VCPUs.
> 
> > > It makes sense that userspace needs to know about SVE for VMs to use it,
> > > doesn't it?
> > 
> > Yes and no.  Except for debug purposes I don't see why userspace needs
> > to know anything execpt how to handle large registers through the ioctl
> > interface.
> > 
> 
> Migration is another reason.
> 
> > > I assume SVE systems will have SVE on all CPUs in an SMP system, or am I
> > > being way too optimistic about the ARM ecosystem here?  Just like we
> > > don't model big.LITTLE, I think we should enforce in the kernel, that
> > 
> > The kernel follows the same policy: if SVE is not present on all
> > physical CPUs we disable it completely and hide it from guests and
> > userspace.
> > 
> > For vector length I'm a little more permissive: the max vector length
> > would be clamped to the minimum commonly supported vector length.
> > 
> 
> Ok, so KVM could implement the same.  Or we could just be reasonable and
> require userspace to configure all VCPUs the same.
> 
> > > userspace configures all VCPUs with the same SVE properties.
> > 
> > OK, so long as you think it's not superfluous to do it, then I'm happy
> > to do it.
> > 
> > > > 
> > > > /*
> > > >  * For the SVE regs, we add some new reg IDs.
> > > >  * Zn are presented in 2048-bit slices; Pn, FFR are presented in 256-bit
> > > >  * slices.  This is sufficient for only a single slice to be required
> > > >  * per register for SVE, but ensures expansion room in case future arch
> > > >  * versions grow the maximum size.
> > > >  */
> > > 
> > > I don't understand the last part of this comment?
> > 
> > This may be explained better in by response below.
> > 
> > > > #define KVM_REG_SIZE_U2048 (ULL(8) << KVM_REG_SIZE_MASK)
> > > 
> > > Shift left by KVM_REG_SIZE_MASK?  I'm confused.
> > > 
> > > > #define KVM_REG_ARM64_SVE_Z(n, i) /* Zn[2048 * (i + 1) - 1 : 2048 * i] */ \
> > > > 	((0x0014 << KVM_REG_ARM_COPROC_SHIFT) | KVM_REG_SIZE_U2048 |	\
> > > > 		((n) << 5) | (i))
> > > > #define KVM_REG_ARM64_SVE_P(n, i) /* Pn[256 * (i + 1) - 1 : 256 * i] */	\
> > > > 	((0x0014 << KVM_REG_ARM_COPROC_SHIFT) | KVM_REG_SIZE_U256 |	\
> > > > 		(((n) + 32) << 5) | (i))
> > > > #define KVM_REG_ARM64_SVE_FFR(i) /* FFR[256 * (i + 1) - 1 : 256 * i] */	\
> > > > 	 KVM_REG_ARM64_SVE_P(16, i)
> > > > 
> > > > For j in [0,3], KVM_REG_ARM64_SVE_Z(n, 0) bits [32(j + 1) - 1 : 32 * j]
> > > > 	alias KVM_REG_ARM_CORE_REG(fp_regs.vregs[n]) + j
> > > > 
> > > 
> > > This is hard to read and understand the way presented here.  I would
> > > suggest you formulate this suggestion in the form of an RFC patch to
> > > Documentation/virtual/kvm/api.txt plus the header definitions.
> > 
> > Sure, I hadn't figured out the best way to present this: I was thinking
> > aloud.
> > 
> > > (I'm not sure where to look to look to decode the "<< 5" and the
> > > " + 32) << 5)" stuff above.
> > 
> > The idea here is that we have 49 registers: Z0-Z31, P0-P15 and FFR.
> > They are numbered serially.
> > 
> > However, the SVE architecture leaves the possibility of future
> > expansion open, up to 32 times the current maximum.
> > 
> > The KVM reg API doesn't support such ridiculously huge registers,
> > so my proposal is to slice them up, indexed by the value in the
> > bottom 5 bits of the reg ID.  This requires the "register ID"
> > field to be shifted up by 5 bits.
> > 
> > If the regs are not oversized (never, for the current architecture),
> > then we simply don't list those extra slices via KVM_GET_REG_LIST.
> > 
> > > > Bits above the max vector length could be
> > > 
> > > Which bits are these and where are they, and why do we have them?
> > 
> > The KVM register size via ioctl is fixed at 2048 bits here.  Since
> > the system might not support vectors that large, then bits 2047:1024
> > in the ioctl payload wouldn't map to any register bits in the hardware.
> > Should KVM still store them somewhere?  Should they logically exist
> > for the purpose of the ioctl() API?
> > 
> > Making the size dynamic to avoid surplus bits doesn't work, because KVM
> > only supports power-of-two reg sizes, whereas SVE can support non-power-
> > of-two sizes.
> > 
> > > Is the max vector length the max architecturally (current version)
> > > defined length, or what is chosen for this VM?
> > 
> > For now, that's an open question.
> > 
> > > >  * don't care (or not copied at all) on read; ignored on write
> > > >  * zero on read; ignored on write
> > > >  * zero on read; must be zero on write
> > > > 
> > > > Bits between the current and max vector length are trickier to specify:
> > > > the "current" vector length for ioctl access is ill-defined, because
> > > > we would need to specify ordering dependencies between Zn/Pn/FFR access
> > > > and access to ZCR_EL1.
> > > 
> > > I think you want userspace to be able to read/write these values in any
> > > order compared to configuring SVE for the VM, and then fix up whatever
> > > needs masking etc. in the kernel later, if possible.  Ordering
> > > requirements to userspace accesses have shown to be hard to enforce and
> > > get right in the past.
> > 
> > So I've heard from other people.
> > 
> > > What happens on hardware if you give a certain vector length to EL0, EL0
> > > writes a value of the full length, and then EL1 restricts the length to
> > > something smaller, and subsequently expands it again?  Is the original
> > > full value visible or are some bits potentially lost?  IOW, can't we
> > > rely on what the architecture says here?
> > 
> > The architecture says that bits that are hidden and then revealed again
> > are either preserved whilst hidden, or zeroed.
> > 
> > Opinion differs on whether that's a good thing to expose in ABI: Will
> > considered it unacceptable to expose this kind of behaviour around
> > syscalls from userspace for example, so I currently always zero the
> > bits in that case even though it's slightly more expensive.
> > 
> > The concern here was that userspace might unintentionally rely on
> > the affected register bits being preserved around syscalls when this
> > is not guaranteed by the implementation.
> > 
> > This does not mean that similar design considerations apply to the KVM
> > ioctl interface though.
> > 
> 
> It sounds to me that the most simple thing is that the register
> interface to userspace exposes the full possible register width in both
> directions, and we apply a mask whenever we need to.
> 
> > > > 
> > > > So, it may be simpler to expose the full maximum supported vector size
> > > > unconditionally through ioctl, and pack/unpack as necessary.
> > > 
> > > yes, I think this was what I tried to say.
> > > 
> > > > 
> > > > Currently, data is packed in the vcpu struct in a vector length
> > > > dependent format, since this seems optimal for low-level save/restore,
> > > > so there will be potential data loss / zero padding when converting.
> > > > 
> > > > This may cause some unexpected effects.  For example:
> > > > 
> > > > KVM_SET_ONE_REG(ZCR_EL1, 0) 
> > > > /* Guest's current vector length will be 128 bits when started */
> > > > 
> > > > KVM_SET_ONE_REG(Z0, (uint256_t)1 << 128)
> > > > KVM_GET_ONE_REG(Z0) /* yields (uint256_t)1 << 128 */
> > > > 
> > > > KVM_RUN /* reg data packed down to 128-bit in vcpu struct */
> > > > 
> > > > KVM_GET_ONE_REG(Z0) /* yields 0 even if guest doesn't use SVE */
> > > > 
> > > 
> > > I really don't know how to parse this or what the point here is?  Sorry.
> > 
> > It means that for the ioctl interface, "obvious" guarantees like "if you
> > read a register you get back the last value written" don't work quite as
> > expected.  Some bits may have disappeared, or not, depending on the
> > precise scenario.
> > 
> > > > 
> > > > Since the guest should be treated mostly as a black box, I'm not sure
> > > > how big a deal this is.  The guest _might_ have explicitly set those
> > > > bits to 0... who are we to say?
> > > 
> > > How big a deal what is?  I'm lost.
> > > 
> > > > 
> > > > Can anyone think of a scenario where effects like this would matter?
> > > > 
> > > 
> > > I think we need more information.
> > 
> > See if my comments above throw any light on this.
> > 
> 
> So you're saying even if we try the "expose full width and read back
> hidden values" approach, those hidden values may be changed when
> executing the guest, due to the KVM implementation or the way hardware
> works, is that the point?

Basically yes.

> I think the KVM interface should be designed similarly to being able to
> probe a hardware CPU's register state at various stages of execution.
> 
> So, for example, if you write content to hidden bits in the SVE
> registers from EL2 on real hardware and limit the length using ZCR_EL2,
> and then run a bunch of code in EL1/0, and then come back to EL2 and
> examine the registers again, then we should model that behavior in
> software.
> 
> In other words, I think we have to model this more closely to what
> guarantees ZCR_EL2 gives us, and not ZCR_EL1, and choose something
> architecturally compliant which is reasonable to implement.

So, we imagine that provided the vcpu is not run in the meantime,
all accesses to SVE regs via the KVM reg API act like they are executed
at EL2?

That doesn't seem unreasonable, and it removes any ordering requirement
between ZCR_EL1 and the SVE regs providing that the vcpu isn't set
running in the meantime.  There is no userspace access to ZCR_EL2 at
all, if we go with the model of configuring that via attributes that
must be configured before vcpu startup -- in which case there is no
ordering requirement there.

The extra bits beyond ZCR_EL1.LEN may disappear as soon as the vcpu
is run, but that is architecturally consistent behaviour at least.

Cheers
---Dave
