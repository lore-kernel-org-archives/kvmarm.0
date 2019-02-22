From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 2/2] KVM: doc: add API documentation on the
 KVM_REG_ARM_WORKAROUNDS register
Date: Fri, 22 Feb 2019 18:44:13 +0000
Message-ID: <20190222184413.460753b7@donnerap.cambridge.arm.com>
References: <20190222121818.30164-1-andre.przywara@arm.com>
 <20190222121818.30164-3-andre.przywara@arm.com>
 <20190222172743.GD3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34A4A4A2AC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 13:44:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QKnpRYNuImm9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 13:44:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95A3E4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 13:44:18 -0500 (EST)
In-Reply-To: <20190222172743.GD3567@e103592.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 22 Feb 2019 17:27:44 +0000
Dave Martin <Dave.Martin@arm.com> wrote:

> On Fri, Feb 22, 2019 at 12:18:18PM +0000, Andre Przywara wrote:
> > Add documentation for the newly defined firmware registers to save and
> > restore any vulnerability migitation status.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  Documentation/virtual/kvm/arm/psci.txt | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> > 
> > diff --git a/Documentation/virtual/kvm/arm/psci.txt b/Documentation/virtual/kvm/arm/psci.txt
> > index aafdab887b04..fe8930765cc7 100644
> > --- a/Documentation/virtual/kvm/arm/psci.txt
> > +++ b/Documentation/virtual/kvm/arm/psci.txt
> > @@ -28,3 +28,27 @@ The following register is defined:
> >    - Allows any PSCI version implemented by KVM and compatible with
> >      v0.2 to be set with SET_ONE_REG
> >    - Affects the whole VM (even if the register view is per-vcpu)  
> 
> Doh, ignore my comments about undescribed semantics in the last patch.
> 
> > +
> > +* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> > +  Holds the state of the firmware controlled workaround to mitigate
> > +  CVE-2017-5715, as described under SMCCC_ARCH_WORKAROUND_1 in [1].
> > +  Accepted values are:
> > +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL: Workaround not available.
> > +      The mitigation status for the guest is unknown.
> > +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL: Workaround active for the guest.
> > +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_UNAFFECTED: The workaround is not
> > +      available and not needed.
> > +
> > +* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> > +  Holds the state of the firmware controlled workaround to mitigate
> > +  CVE-2018-3639, as described under SMCCC_ARCH_WORKAROUND_2 in [1].
> > +  Accepted values are:
> > +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL: Workaround not available.
> > +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN: Workaround state unknown.
> > +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL: Workaround available, and can
> > +      be disabled by a vCPU. If KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED is
> > +      set, it is active for this vCPU.  
> 
> Ah, so this is really not supposed to be set except for _AVAIL?

Yes, it's only used if the kernel offers the switch. The reason is to
allow the guest to turn it *off*, actually.

> > +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED: Workaround always active
> > +      or not needed.  
> 
> But is the workaround available (i.e., SMCCC interface implemented?)

Yes, that mirrors return value 1 of the actual firmware interface
permanently enable or not require, but safe to call the firmware).

> The code assumes it is, IIUC -- i.e., it will happily upgrade _AVAIL
> to _UNAFFECTED.  That's bad if it means the SMCCC call disappears under
> the guest's feet.

I think migrating to a "better" system is an important use case, so we
should make it possible.
 
> (Not saying it does, just that I'm not sure.)
> 
> 
> For KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1, we apply an == check, avoiding
> this subtlety.

Because we only have two cases there at the moment, and NOT_AVAIL could
mean not protected. Since we require guest interaction for WORKAROUND_1,
we can't allow any change at the moment. This will change with the
introduction of UNAFFECTED.

Cheers,
Andre
