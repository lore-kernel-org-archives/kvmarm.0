From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 15/20] kvm: arm/arm64: Allow tuning the physical
 address size for VM
Date: Tue, 10 Jul 2018 18:03:30 +0100
Message-ID: <20180710170330.GJ9486@e103592.cambridge.arm.com>
References: <1530270944-11351-16-git-send-email-suzuki.poulose@arm.com>
 <20180704155104.GN4828@arm.com>
 <12d1832a-1a13-7dd4-662b-addf58400789@arm.com>
 <fe9f5aa5-b283-07e0-5f0e-e97d96b780e7@arm.com>
 <9f1af26e-2913-2b0b-1352-63160096f78f@arm.com>
 <f3463d0a-c6a3-c34d-acb3-13c99fc61c5a@arm.com>
 <20180709112326.GD9486@e103592.cambridge.arm.com>
 <17f8d585-3489-ab6f-6ee1-4d8d337dcf9c@arm.com>
 <20180709133750.GE9486@e103592.cambridge.arm.com>
 <377420ce-97a8-4359-6224-273d91f37247@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07C5A49FA8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jul 2018 12:50:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MIQ2++cb7LmR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Jul 2018 12:50:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96F86402AA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jul 2018 12:50:51 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <377420ce-97a8-4359-6224-273d91f37247@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: cdall@kernel.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, catalin.marinas@arm.com, punit.agrawal@arm.com, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 10, 2018 at 05:38:39PM +0100, Suzuki K Poulose wrote:
> On 09/07/18 14:37, Dave Martin wrote:
> >On Mon, Jul 09, 2018 at 01:29:42PM +0100, Marc Zyngier wrote:
> >>On 09/07/18 12:23, Dave Martin wrote:

[...]

> >>>Wedging arguments into a few bits in the type argument feels awkward,
> >>>and may be regretted later if we run out of bits, or something can't be
> >>>represented in the chosen encoding.
> >>
> >>I think that's a pretty convincing argument for a "better" CREATE_VM,
> >>one that would have a clearly defined, structured (and potentially
> >>extensible) argument.
> >>
> >>I've quickly hacked the following:
> >>
> >>diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> >>index b6270a3b38e9..3e76214034c2 100644
> >>--- a/include/uapi/linux/kvm.h
> >>+++ b/include/uapi/linux/kvm.h
> >>@@ -735,6 +735,20 @@ struct kvm_ppc_resize_hpt {
> >>  	__u32 pad;
> >>  };
> >>
> >>+struct kvm_create_vm2 {
> >>+	__u64	version;	/* Or maybe not */
> >>+	union {
> >>+		struct {
> >>+#define KVM_ARM_SVE_CAPABLE	(1 << 0)
> >>+#define KVM_ARM_SELECT_IPA	{1 << 1)
> >>+			__u64	capabilities;
> >>+			__u16	sve_vlen;
> >>+			__u8	ipa_size;
> >>+		} arm64;
> >>+		__u64	dummy[15];
> >>+	};
> >>+};
> >>+
> >>  #define KVMIO 0xAE
> >>
> >>  /* machine type bits, to be used as argument to KVM_CREATE_VM */
> >>
> >>Other architectures could fill in their own bits if they need to.
> >>
> >>Thoughts?
> >
> >This kind of thing should work, but it may still get messy when we
> >add additional fields.
> 
> 
> Marc, Dave,
> 
> I like Dave's approach. Some comments below.
> 
> >
> >It we want this to work cross-arch, would it make sense to go
> >for a more generic approach, say
> >
> >struct kvm_create_vm_attr_any {
> >         __u32   type;
> >};
> >
> >#define KVM_CREATE_VM_ATTR_ARCH_CAPABILITIES 1
> >struct kvm_create_vm_attr_arch_capabilities {
> >         __u32   type;
> >         __u16   size; /* support future expansion of capabilities[] */
> >         __u16   reserved;
> >         __u64   capabilities[1];
> >};
> 
> We also need to advertise which attributes are supported by the host,
> so that the user can tune the available ones. That would make a bit mask
> like the above trickier, unless we return the supported values back
> in the argument ptr for the "probe" call. And this scheme in general
> can be useful for passing back a non-boolean result specific to the
> attribute, without having a per-attribute ioctl. (e.g, maximum limit
> for IPA).

Maybe, but this could quickly become bloated.  (My approach already
feels a bit bloated...)

I'm not sure that arbitrarily complex negotiation will really be
needed, but userspace might want to change its mind if setting a
particular propertiy fails.

An alternative might be to have a bunch of per-VM ioctls to configure
different things, like x86 has.  There's at least precedent for that.
For arm, we currently only have a few.  That allows for easy extension,
at the cost of adding ioctls.

There may be some ioctls we can reuse, like KVM_ENABLE_CAP for per-
vm capability flags.


[...]

> >union kvm_create_vm_attr {
> >         struct kvm_create_vm_attr_any;
> >         struct kvm_create_vm_attr_arch_capabilities;
> >         struct kvm_create_vm_attr_arm64_physaddr_size;
> >         /* ... */
> >};
> 
> nit: Could we simply do s/kvm_create_vm_attr/kvm_vm_attr/ everywhere ?
> While I agree that the kvm_create_vm_attr makes it implicit that the attributes
> are valid only "create" ioctl, the lack of an ioctl to set the VM attribute
> should be sufficient to indicate the same.

I just randomly came up with some names.  The precise naming scheme
isn't that important, so long as it unlikely to result in name
collisions and so long as it's reasonablu clear (or compiler-checkable,
or preferably both) which things can be used where.

I wouldn't have a problem with something a bit terser.

> 
> >
> >struct kvm_create_vm2 {
> >         __u32   version;        /* harmless, even if not useful */
> >         __u16   nr_attrs;       /* or could just terminate attrs with a
> >                                    NULL entry */
> >         union kvm_create_vm_attr __user *__user *attrs;
> >};
> >
> >
> >This is quite flexible, but obviously a bit heavy.
> >
> >However, if we're adding a new interface due to lack of extensibility,
> >it may be worth going for something that's freely extensible.
> 
> True. I could hack something up along the lines above and send it here.

Sure, but best to keep it fairly rough for now.

Cheers
---Dave
