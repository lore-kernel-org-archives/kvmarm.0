From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 5/5] KVM: arm64: Implement vGICv3 CPU interface access
Date: Sat, 26 Sep 2015 00:00:24 +0100
Message-ID: <20150926000024.0efbf388@arm.com>
References: <cover.1441370053.git.p.fedin@samsung.com>
 <20be17e4e8aebcd7f1a52a634f449955bef99996.1441370053.git.p.fedin@samsung.com>
 <55E9B528.50106@arm.com>
 <16a001d0f6c1$b113cbd0$133b6370$@samsung.com>
 <5605CA60.4080101@arm.com>
 <CAFEAcA8Pq2C6Mz8BGh8zSBj0THQumXVPdKXwS1WVOCAtRU1gLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26C144884D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Sep 2015 18:59:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wWvEVondjZzE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Sep 2015 18:59:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D79EA47036
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Sep 2015 18:59:01 -0400 (EDT)
In-Reply-To: <CAFEAcA8Pq2C6Mz8BGh8zSBj0THQumXVPdKXwS1WVOCAtRU1gLA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Andre Przywara <andre.przywara@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 25 Sep 2015 15:33:44 -0700
Peter Maydell <peter.maydell@linaro.org> wrote:

> On 25 September 2015 at 15:27, Andre Przywara <andre.przywara@arm.com> wrote:
> > On 24/09/15 13:08, Pavel Fedin wrote:
> >>  Hello!
> >>
> >>> The only thing that is pure 64-bit is the MRS/MSR _instruction_ in
> >>> Aarch64, which always takes a x<nn> register.
> >>> So can you model the register size according to the spec and allow
> >>> 32-bit accesses from userland?
> >>
> >>  I would like to complete the rework and respin v4, but this is, i guess, the only major issue left.
> >> Additionally, it impacts the API. So...
> >>  In order to allow 32-bit accesses we would have to drop using ARM64_SYS_REG() for building
> >> attribute ID and introduce something own, like KVM_DEV_ARM_VGIC_REG(). It will have different bits
> >> layout (actually it will be missing 'arch' and 'size' field, and instead i will use
> >> KVM_DEV_ARM_VGIC_64BIT flag for length specification, the same as for redistributor.
> >>  Will this be OK ?
> >
> > No, instead you should go with your original approach ;-)
> > Thinking about that again I see that this interface is of course modeled
> > after the architectured GICv3 system registers, where AArch32 has its
> > own, separate encoding. So it's perfectly fine to use that 64-bit
> > interface between userland and KVM now. If we later get Aarch32 support
> > for the GICv3, we can add the appropriate Aarch32 sysregs to that
> > interface and have a natural match.
> 
> Christoffer, Marc and I had a discussion about how best to handle GICv3
> state save and restore here at Linaro Connect this week, and one of the
> conclusions there was that all of it should be done via the device
> fd's save/restore interface, not via the SET/GET_ONE_REG CPU register
> interface. (Because it's much less confusing to have all of the GICv3's
> state be dealt with via the same interface, rather than splitting it;
> it's also more convenient for QEMU.)
> 
> More details to follow from one of us next week when we aren't all
> on aeroplanes, I expect.

Indeed. Another thing to consider now is (at the ITS level) the
necessity to be able to flush the ITS "caches" (basically our internal
data structures) out to guest memory so that it can be saved/restored.

That's pretty easy for the pending and property tables as well as
the command queue (where the format is fixed by the architecture), but
slightly more complicated with the device table, the collection table
and the various ITTs (we need to come up with a formal representation
that effectively becomes an ABI).

>From a flow point of view, I expect the flush to at least occur when
the VM gets suspended, ensuring that the full interrupt state can be
read out via the userspace mapping of the guest memory.

That being said, I'm off to catch that plane.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
