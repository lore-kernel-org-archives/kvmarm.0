From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 04/10] KVM: arm: guest debug, add stub
 KVM_SET_GUEST_DEBUG ioctl
Date: Thu, 9 Apr 2015 14:28:07 +0200
Message-ID: <20150409122806.GB3212@hawk.usersys.redhat.com>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-5-git-send-email-alex.bennee@linaro.org>
 <20150401175529.642f64af@thinkpad-w530>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A127E4BE23
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 08:21:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IZQQBdi3xDWA for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2015 08:21:04 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C457F4BE21
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 08:21:03 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20150401175529.642f64af@thinkpad-w530>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, marc.zyngier@arm.com, jan.kiszka@siemens.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@kernel.org>, linux-arm-kernel@lists.infradead.org, zhichao.huang@linaro.org, r65777@freescale.com, pbonzini@redhat.com, bp@suse.de, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 01, 2015 at 05:55:29PM +0200, David Hildenbrand wrote:
> > This commit adds a stub function to support the KVM_SET_GUEST_DEBUG
> > ioctl. Currently any operation flag will return EINVAL. Actual
> =

> Well it won't return -EINVAL if you push in KVM_GUESTDBG_ENABLE or 0.
> =

> "Any unsupported flag will return -EINVAL. For now, only KVM_GUESTDBG_ENA=
BLE is
> supported, although it won't have any effects."
> =

> > functionality will be added with further patches.
> > =

> > Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>.
> > =

> > ---
> > v2
> >   - simplified form of the ioctl (stuff will go into setup_debug)
> > =

> > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/=
kvm/api.txt
> > index b112efc..06c5064 100644
> > --- a/Documentation/virtual/kvm/api.txt
> > +++ b/Documentation/virtual/kvm/api.txt
> > @@ -2604,7 +2604,7 @@ handled.
> >  4.87 KVM_SET_GUEST_DEBUG
> > =

> >  Capability: KVM_CAP_SET_GUEST_DEBUG
> > -Architectures: x86, s390, ppc
> > +Architectures: x86, s390, ppc, arm64
> >  Type: vcpu ioctl
> >  Parameters: struct kvm_guest_debug (in)
> >  Returns: 0 on success; -1 on error
> > diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> > index 5560f74..445933d 100644
> > --- a/arch/arm/kvm/arm.c
> > +++ b/arch/arm/kvm/arm.c
> > @@ -183,6 +183,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
> >  	case KVM_CAP_ARM_PSCI:
> >  	case KVM_CAP_ARM_PSCI_0_2:
> >  	case KVM_CAP_READONLY_MEM:
> > +	case KVM_CAP_SET_GUEST_DEBUG:
> >  		r =3D 1;
> >  		break;
> >  	case KVM_CAP_COALESCED_MMIO:
> > @@ -303,10 +304,21 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >  	kvm_arm_set_running_vcpu(NULL);
> >  }
> > =

> > +#define KVM_GUESTDBG_VALID (KVM_GUESTDBG_ENABLE)
> =

> That makes me rather think that it is another flag.
> =

> We(s390x) use VALID_GUESTDBG_FLAGS, what about that or KVM_GUESTDBG_VALID=
_MASK?
> =

> > +
> >  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
> >  					struct kvm_guest_debug *dbg)
> >  {
> > -	return -EINVAL;
> > +	if (dbg->control & KVM_GUESTDBG_ENABLE) {
> > +		if (dbg->control & ~KVM_GUESTDBG_VALID)
> > +			return -EINVAL;
> =

> I'd move that check directly to the start of the function and bail out on=
 any
> unsupported flag.
> =

> > +
> > +		vcpu->guest_debug =3D dbg->control;
> > +	} else {
> > +		/* If not enabled clear all flags */
> > +		vcpu->guest_debug =3D 0;
> > +	}
> > +	return 0;
> >  }
> > =

> > =

> =

> David
>

I don't see any follow-up from Alex on this, so I feel the need to
"+1" all David's comments here.

drew
