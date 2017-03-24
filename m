From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 28/28] arm/arm64: Add hyp-stub API documentation
Date: Fri, 24 Mar 2017 17:03:35 +0100
Message-ID: <20170324160335.GI25903@cbox>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
 <20170321192058.9300-29-marc.zyngier@arm.com>
 <20170324143316.GA25903@cbox>
 <ff4fe929-98f0-de0e-2f1a-d06c7969d5e0@arm.com>
 <20170324152340.GG25903@cbox>
 <ea653ce3-e85a-a42a-9b4f-a5d1daabf871@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FD9040A14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 12:01:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LBf4vCOLqwUE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Mar 2017 12:01:46 -0400 (EDT)
Received: from mail-wr0-f176.google.com (mail-wr0-f176.google.com
 [209.85.128.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0F6BF40969
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 12:01:45 -0400 (EDT)
Received: by mail-wr0-f176.google.com with SMTP id u1so4684280wra.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 09:03:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <ea653ce3-e85a-a42a-9b4f-a5d1daabf871@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, Keerthy <j-keerthy@ti.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 24, 2017 at 03:57:41PM +0000, Marc Zyngier wrote:
> On 24/03/17 15:23, Christoffer Dall wrote:
> > On Fri, Mar 24, 2017 at 02:42:13PM +0000, Marc Zyngier wrote:
> >> On 24/03/17 14:33, Christoffer Dall wrote:
> >>> On Tue, Mar 21, 2017 at 07:20:58PM +0000, Marc Zyngier wrote:
> >>>> In order to help people understanding the hyp-stub API that exists
> >>>> between the host kernel and the hypervisor mode (whether a hypervisor
> >>>> has been installed or not), let's document said API.
> >>>>
> >>>> As with any form of documentation, I expect it to become obsolete
> >>>> and completely misleading within 20 minutes after having being merged.
> >>>
> >>> I don't think this last sentence belongs in the commit message.
> >>>
> >>>>
> >>>> Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
> >>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >>>> ---
> >>>>  Documentation/virtual/kvm/arm/hyp-abi.txt | 45 +++++++++++++++++++++++++++++++
> >>>>  1 file changed, 45 insertions(+)
> >>>>  create mode 100644 Documentation/virtual/kvm/arm/hyp-abi.txt
> >>>>
> >>>> diff --git a/Documentation/virtual/kvm/arm/hyp-abi.txt b/Documentation/virtual/kvm/arm/hyp-abi.txt
> >>>> new file mode 100644
> >>>> index 000000000000..a1e0314d2249
> >>>> --- /dev/null
> >>>> +++ b/Documentation/virtual/kvm/arm/hyp-abi.txt
> >>>> @@ -0,0 +1,45 @@
> >>>> +* Internal ABI between the kernel and HYP
> >>>> +
> >>>> +This file documents the interaction between the Linux kernel and the
> >>>> +hypervisor layer when running Linux as a hypervisor (for example
> >>>> +KVM). It doesn't cover the interaction of the kernel with the
> >>>> +hypervisor when running as a guest (under Xen, KVM or any other
> >>>> +hypervisor), or any hypervisor-specific interaction when the kernel is
> >>>> +used as a host.
> >>>> +
> >>>> +On arm and arm64 (without VHE), the kernel doesn't run in hypervisor
> >>>> +mode, but still needs to interact with it, allowing a built-in
> >>>> +hypervisor to be either installed or torn down.
> >>>> +
> >>>> +In order to achieve this, the kernel must be booted at HYP (arm) or
> >>>> +EL2 (arm64), allowing it to install a set of stubs before dropping to
> >>>> +SVC/EL1. These stubs are accessible by using a 'hvc #0' instruction,
> >>>> +and only act on individual CPUs.
> >>>> +
> >>>> +Unless specified otherwise, any built-in hypervisor must implement
> >>>> +these functions (see arch/arm{,64}/include/asm/virt.h):
> >>>> +
> >>>> +* r0/x0 = HVC_SET_VECTORS
> >>>> +  r1/x1 = vectors
> >>>> +
> >>>> +  Set HVBAR/VBAR_EL2 to 'vectors' to enable a hypervisor. 'vectors'
> >>>> +  must be a physical address, and respect the alignment requirements
> >>>> +  of the architecture. Only implemented by the initial stubs.
> >>>
> >>> Does this last sentence mean that KVM doesn't implement this function?
> >>
> >> Indeed. 
> > 
> > I think the wording could be improved to "Only implemented by the
> > initial stubs, not by Linux hypervisors."
> 
> Looks good to me, I'll use that.
> 
> >> Directly setting the vectors is inherently unsafe (MMU could
> >> still be ON, for example), hence the HVC_SET_VECTORS operation that
> >> allow this to be done safely (RESET followed by SET).
> >>
> > 
> > Hmm, is it any less safe than setting the vectors using the hyp stubs?
> > In the initial case, we're relying on the caller knowing that the MMU is
> > off, and that the stubs are in place, otherwise it doesn't make sense.
> 
> That's why I was implying here that RESET+SET is the safe way of doing
> it. Another solution may be to make SET imply RESET, and keep it
> implemented always?
> 

Meh, I think these patches are as stable as is required for the use
cases at hand, so let's not introduce more churn in these patches.

> > But I think the point is just that we don't have a need to change the
> > vector from within KVM; we only have a need to set the vector when going
> > from stub->kvm, and we have a need to reset the whole thing (including
> > turning off the MMU) when going from kvm->stub.
> 
> Exactly. The current API doesn't try to cater for all possible cases. It
> just make sure that KVM can be installed and torn down safely.
> 

Fair enough.

> > Anyhow, my comment was just about the wording, as I had some nagging
> > doubt when I read the patch.
> > 
> >>>
> >>>> +
> >>>> +* r0/x0 = HVC_RESET_VECTORS
> >>>> +
> >>>> +  Turn HYP/EL2 MMU off, and reset HVBAR/VBAR_EL2 to the default
> >>>> +  value. This effectively disables an existing hypervisor.
> >>>
> >>> What's the 'default value' ?  Could we say to the physical address of
> >>> the hypervisor stub's exception vector?
> >>
> >> Shouldn't that be the kernel stub's exception vector?
> >>
> > 
> > Yeah, the "initials stubs' exception vector" is probably the most
> > coherent thing we can use here.
> 
> I'll use that when respinning it.
> 

Thanks,
-Christoffer
