From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 05/10] KVM: arm: introduce kvm_arch_setup/clear_debug()
Date: Thu, 09 Apr 2015 15:18:03 +0100
Message-ID: <874mop1j38.fsf@linaro.org>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org> <1427814488-28467-6-git-send-email-alex.bennee@linaro.org> <20150401182855.4650b14a@thinkpad-w530> <20150409125607.GD3212@hawk.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20150409125607.GD3212@hawk.usersys.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: David Hildenbrand <dahi@linux.vnet.ibm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, r65777@freescale.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andre Przywara <andre.przywara@arm.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu


Andrew Jones <drjones@redhat.com> writes:

> On Wed, Apr 01, 2015 at 06:28:55PM +0200, David Hildenbrand wrote:
>> > This is a precursor for later patches which will need to do more t=
o
>> > setup debug state before entering the hyp.S switch code. The exist=
ing
>> > functionality for setting mdcr_el2 has been moved out of hyp.S and=
 now
>> > uses the value kept in vcpu->arch.mdcr_el2.
>> >=20
>> > This also moves the conditional setting of the TDA bit from the hy=
p code
>> > into the C code.
>> >=20
>> > Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> >=20
>> >  create mode 100644 arch/arm64/kvm/debug.c
>> >=20
>> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/as=
m/kvm_host.h
>> > index 41008cd..8c01c97 100644
>> > --- a/arch/arm/include/asm/kvm_host.h
>> > +++ b/arch/arm/include/asm/kvm_host.h
>> > @@ -242,5 +242,7 @@ static inline void kvm_arch_hardware_unsetup(v=
oid) {}
>> >  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>> >  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>> >  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int c=
pu) {}
>> > +static inline void kvm_arch_setup_debug(struct kvm_vcpu *vcpu) {}
>> > +static inline void kvm_arch_clear_debug(struct kvm_vcpu *vcpu) {}
>>=20
>> Do you really want to call these functions "kvm_arch.." although the=
y are not
>> defined for other arch and not triggered by common code?
>>
>
> Agreed. If other arches want something similar we can rename/refactor
> later. If these are arm-only functions, then we don't need the generi=
c
> prefix, which is actually even a bit confusing.

They are arm only but I was keeping in mind the need to add guest debug
to ARMv7 at some point.

>
> drew=20

--=20
Alex Benn=C3=A9e
