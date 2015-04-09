From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 04/10] KVM: arm: guest debug, add stub KVM_SET_GUEST_DEBUG ioctl
Date: Thu, 09 Apr 2015 15:19:07 +0100
Message-ID: <8738491j1g.fsf@linaro.org>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org> <1427814488-28467-5-git-send-email-alex.bennee@linaro.org> <20150401175529.642f64af@thinkpad-w530> <20150409122806.GB3212@hawk.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20150409122806.GB3212@hawk.usersys.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: David Hildenbrand <dahi@linux.vnet.ibm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, r65777@freescale.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@arm.linux.org.uk>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu


Andrew Jones <drjones@redhat.com> writes:

> On Wed, Apr 01, 2015 at 05:55:29PM +0200, David Hildenbrand wrote:
>> > This commit adds a stub function to support the KVM_SET_GUEST_DEBU=
G
>> > ioctl. Currently any operation flag will return EINVAL. Actual
>>=20
>> Well it won't return -EINVAL if you push in KVM_GUESTDBG_ENABLE or 0=
=2E
>>=20
>> "Any unsupported flag will return -EINVAL. For now, only KVM_GUESTDB=
G_ENABLE is
>> supported, although it won't have any effects."
>>=20
>> > functionality will be added with further patches.
>> >=20
>> > Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>.
>> >=20
>> > ---
>> > v2
>> >   - simplified form of the ioctl (stuff will go into setup_debug)
>> >=20
>> > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/vir=
tual/kvm/api.txt
>> > index b112efc..06c5064 100644
>> > --- a/Documentation/virtual/kvm/api.txt
>> > +++ b/Documentation/virtual/kvm/api.txt
>> > @@ -2604,7 +2604,7 @@ handled.
>> >  4.87 KVM_SET_GUEST_DEBUG
>> >=20
>> >  Capability: KVM_CAP_SET_GUEST_DEBUG
>> > -Architectures: x86, s390, ppc
>> > +Architectures: x86, s390, ppc, arm64
>> >  Type: vcpu ioctl
>> >  Parameters: struct kvm_guest_debug (in)
>> >  Returns: 0 on success; -1 on error
>> > diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> > index 5560f74..445933d 100644
>> > --- a/arch/arm/kvm/arm.c
>> > +++ b/arch/arm/kvm/arm.c
>> > @@ -183,6 +183,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *k=
vm, long ext)
>> >  	case KVM_CAP_ARM_PSCI:
>> >  	case KVM_CAP_ARM_PSCI_0_2:
>> >  	case KVM_CAP_READONLY_MEM:
>> > +	case KVM_CAP_SET_GUEST_DEBUG:
>> >  		r =3D 1;
>> >  		break;
>> >  	case KVM_CAP_COALESCED_MMIO:
>> > @@ -303,10 +304,21 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu=
)
>> >  	kvm_arm_set_running_vcpu(NULL);
>> >  }
>> >=20
>> > +#define KVM_GUESTDBG_VALID (KVM_GUESTDBG_ENABLE)
>>=20
>> That makes me rather think that it is another flag.
>>=20
>> We(s390x) use VALID_GUESTDBG_FLAGS, what about that or KVM_GUESTDBG_=
VALID_MASK?
>>=20
>> > +
>> >  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>> >  					struct kvm_guest_debug *dbg)
>> >  {
>> > -	return -EINVAL;
>> > +	if (dbg->control & KVM_GUESTDBG_ENABLE) {
>> > +		if (dbg->control & ~KVM_GUESTDBG_VALID)
>> > +			return -EINVAL;
>>=20
>> I'd move that check directly to the start of the function and bail o=
ut on any
>> unsupported flag.
>>=20
>> > +
>> > +		vcpu->guest_debug =3D dbg->control;
>> > +	} else {
>> > +		/* If not enabled clear all flags */
>> > +		vcpu->guest_debug =3D 0;
>> > +	}
>> > +	return 0;
>> >  }
>> >=20
>> >=20
>>=20
>> David
>>
>
> I don't see any follow-up from Alex on this, so I feel the need to
> "+1" all David's comments here.

Yeah they make sense. Will do.

--=20
Alex Benn=C3=A9e
