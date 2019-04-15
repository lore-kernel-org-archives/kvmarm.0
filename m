From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v4 2/2] KVM: doc: add API documentation on the
 KVM_REG_ARM_WORKAROUNDS register
Date: Mon, 15 Apr 2019 13:34:37 +0100
Message-ID: <20190415133353.04304c45@donnerap.cambridge.arm.com>
References: <20190228234334.20456-1-andre.przywara@arm.com>
 <20190228234334.20456-3-andre.przywara@arm.com>
 <60c2e180-03aa-1b9e-f19c-90d890b99d15@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 869E84A4A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 08:34:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hKztRzg6dYEq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Apr 2019 08:34:43 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D477D4A480
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 08:34:42 -0400 (EDT)
In-Reply-To: <60c2e180-03aa-1b9e-f19c-90d890b99d15@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Dave Martin <dave.martin@arm.com>, Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 21 Mar 2019 13:33:18 +0100
Auger Eric <eric.auger@redhat.com> wrote:

Hi Eric,

many thanks for the feedback, turns out that this description here is
somewhat tricky. We only really care about the guest's view, but the
various host states (support configured out, disabled on the command line,
not supported by firmware, not needed on this CPU) play into this as well.
So in my understanding the information presented here does not necessarily
copy the information returned by the firmware interface, it just presents
what the guest can expect from the firmware interface.

I tried to reword the description in v5 to address any ambiguities,
meanwhile trying to answer your specific questions below.
Please have a look at v5 and tell me if that is clearer now.

> On 3/1/19 12:43 AM, Andre Przywara wrote:
> > Add documentation for the newly defined firmware registers to save and
> > restore any vulnerability migitation status.  
> s/migitation/mitigation
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  Documentation/virtual/kvm/arm/psci.txt | 25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> > 
> > diff --git a/Documentation/virtual/kvm/arm/psci.txt b/Documentation/virtual/kvm/arm/psci.txt
> > index aafdab887b04..1ed0f0515cd8 100644
> > --- a/Documentation/virtual/kvm/arm/psci.txt
> > +++ b/Documentation/virtual/kvm/arm/psci.txt
> > @@ -28,3 +28,28 @@ The following register is defined:
> >    - Allows any PSCI version implemented by KVM and compatible with
> >      v0.2 to be set with SET_ONE_REG
> >    - Affects the whole VM (even if the register view is per-vcpu)
> > +
> > +* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
> > +  Holds the state of the firmware controlled workaround to mitigate
> > +  CVE-2017-5715, as described under SMCCC_ARCH_WORKAROUND_1 in [1].> +  Accepted values are:
> > +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL: Workaround not available.
> > +      The mitigation status for the guest is unknown.
> > +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL: The workaround HVC call is
> > +      available to the guest and required for the mitigation.  
> It is unclear to me why we don't report the actual enable status too as
> for WA2. Assuming the mitigation is not applied on the source (ie. AVAIL
> but SMCCC_ARCH_WORKAROUND_1 not called), do we need it on the destination?

In contrast to WORKAROUND_2 this one here is stateless. KVM potentially
offers the HVC call and says whether it's needed or not: What the guest
makes out of it, is up to the guest's discretion. The guest has to call
this HVC every time it wants to mitigate the issue. KVM needs to maintain
continuity on migration regarding offering this HVC call and its effect.

> > +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_UNAFFECTED: The workaround HVC call
> > +      is available to the guest, but it is not needed on this VCPU.
> > +
> > +* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
> > +  Holds the state of the firmware controlled workaround to mitigate
> > +  CVE-2018-3639, as described under SMCCC_ARCH_WORKAROUND_2 in [1].  
> This does not really match the terminology used in [1]. At least it is
> not straightforward to me.

Not really sure what you mean by this, exactly?

> > +  Accepted values are:
> > +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL: Workaround not available.
> > +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN: Workaround state unknown.  
> both included in NOT_SUPPORTED. By the way why did we need to be more
> precise here? Seems WA1 also has the UNKNOWN state as part of
> UNSUPPORTED. Why isn't it homogeneous?

Most differences originate in the statelessness of WORKAROUND_1. Also we
have this information here in the host kernel: NOT_AVAIL is returned when
the workaround has been explicitly disabled on the command line, UNKNOWN
is used when the workaround has been configured out.
We use this to avoid migration to a "worse place": UNKNOWN is never worse
than "not available".

> > +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL: Workaround available, and can
> > +      be disabled by a vCPU. If KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED is
> > +      set, it is active for this vCPU.
> > +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED: Workaround always active  
> NOT_REQUIRED or 1?

I think we don't care. KVM always offers this HVC call. I think the trick
here is that is not the firmware interface, but a description of it. It
just tells what the guest is able to call, we don't copy the results of
the firmware call in here.

Cheers,
Andre.


> > +      or not needed.
> > +
> > +[1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
> >   
> Thanks
> 
> Eric
