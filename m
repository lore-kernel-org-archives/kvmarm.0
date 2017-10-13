From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v1 2/2] kvm: arm64: handle single-step of userspace mmio instructions
Date: Fri, 13 Oct 2017 10:27:36 +0100
Message-ID: <87o9pb9z3r.fsf@linaro.org>
References: <20171006113921.24880-1-alex.bennee@linaro.org> <20171006113921.24880-3-alex.bennee@linaro.org> <20171013085650.GD8927@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20171013085650.GD8927@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: julien.thierry@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu


Christoffer Dall <cdall@linaro.org> writes:

> On Fri, Oct 06, 2017 at 12:39:21PM +0100, Alex Benn=C3=A9e wrote:
>> The system state of KVM when using userspace emulation is not complete
>> until we return into KVM_RUN. To handle mmio related updates we wait
>> until they have been committed and then schedule our KVM_EXIT_DEBUG.
>>
>> I've introduced a new function kvm_arm_maybe_return_debug() to wrap up
>> the differences between arm/arm64 which is currently null for arm.
>>
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> ---
>>  arch/arm/include/asm/kvm_host.h   |  2 ++
>>  arch/arm64/include/asm/kvm_host.h |  1 +
>>  arch/arm64/kvm/debug.c            | 21 +++++++++++++++++++++
>>  arch/arm64/kvm/handle_exit.c      |  9 +++------
>>  virt/kvm/arm/arm.c                |  2 +-
>>  virt/kvm/arm/mmio.c               |  3 ++-
>>  6 files changed, 30 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_=
host.h
>> index 4a879f6ff13b..aec943f6d123 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -285,6 +285,8 @@ static inline void kvm_arm_init_debug(void) {}
>>  static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
>>  static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
>>  static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
>> +static inline int  kvm_arm_maybe_return_debug(struct kvm_vcpu *vcpu,
>> +						struct kvm_run *run) {}
>>
>>  int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>>  			       struct kvm_device_attr *attr);
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/=
kvm_host.h
>> index e923b58606e2..fa67d21662f6 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -369,6 +369,7 @@ void kvm_arm_init_debug(void);
>>  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
>>  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
>>  void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
>> +int  kvm_arm_maybe_return_debug(struct kvm_vcpu *vcpu, struct kvm_run *=
run);
>>  int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>>  			       struct kvm_device_attr *attr);
>>  int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
>> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
>> index dbadfaf850a7..a10a18c55c87 100644
>> --- a/arch/arm64/kvm/debug.c
>> +++ b/arch/arm64/kvm/debug.c
>> @@ -221,3 +221,24 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
>>  		}
>>  	}
>>  }
>> +
>> +
>> +/*
>> + * When KVM has successfully emulated the instruction we might want to
>> + * return we a KVM_EXIT_DEBUG. We can only do this once the emulation
>> + * is complete though so for userspace emulations we have to wait
>> + * until we have re-entered KVM.
>> + *
>> + * Return > 0 to return to guest, 0 (and set exit_reason) on proper
>> + * exit to userspace.
>> + */
>> +
>> +int kvm_arm_maybe_return_debug(struct kvm_vcpu *vcpu, struct kvm_run *r=
un)
>> +{
>> +	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
>> +		run->exit_reason =3D KVM_EXIT_DEBUG;
>> +		run->debug.arch.hsr =3D ESR_ELx_EC_SOFTSTP_LOW << ESR_ELx_EC_SHIFT;
>> +		return 0;
>> +	}
>> +	return 1;
>> +}
>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>> index c918d291cb58..7b04f59217bf 100644
>> --- a/arch/arm64/kvm/handle_exit.c
>> +++ b/arch/arm64/kvm/handle_exit.c
>> @@ -202,13 +202,10 @@ static int handle_trap_exceptions(struct kvm_vcpu =
*vcpu, struct kvm_run *run)
>>  		handled =3D exit_handler(vcpu, run);
>>  	}
>>
>> -	if (handled && (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)) {
>> -		handled =3D 0;
>> -		run->exit_reason =3D KVM_EXIT_DEBUG;
>> -		run->debug.arch.hsr =3D ESR_ELx_EC_SOFTSTP_LOW << ESR_ELx_EC_SHIFT;
>> -	}
>> +	if (handled)
>> +		return kvm_arm_maybe_return_debug(vcpu, run);
>
> Again, this seems to override the return value of exit_handler, which
> may be something negative.
>
> Just so I'm clear: There's no intended functionality change of this
> particular hunk, it's just to share the logic in
> kvm_arm_maybe_return_debug, right?

Yes, modulo the annoying semantics in the two places of the vcpu run
ioctl loop.

>
>>
>> -	return handled;
>> +	return 0;
>>  }
>>
>>  /*
>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index b9f68e4add71..3d28fe2daa26 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -623,7 +623,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, s=
truct kvm_run *run)
>>
>>  	if (run->exit_reason =3D=3D KVM_EXIT_MMIO) {
>>  		ret =3D kvm_handle_mmio_return(vcpu, vcpu->run);
>> -		if (ret)
>> +		if (ret < 1)
>>  			return ret;
>>  	}
>>
>> diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
>> index b6e715fd3c90..e43e3bd6222f 100644
>> --- a/virt/kvm/arm/mmio.c
>> +++ b/virt/kvm/arm/mmio.c
>> @@ -117,7 +117,8 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, st=
ruct kvm_run *run)
>>  		vcpu_set_reg(vcpu, vcpu->arch.mmio_decode.rt, data);
>>  	}
>>
>> -	return 0;
>> +	/* If debugging in effect we may need to return now */
>
> Will this ever be about other types of debugging (watchpoint on a MMIO
> access?) or should we limit the text and description to
> single-stepping?

Hmm I don't think so. A hbreak should hit (via normal exception path)
before we attempt any emulation. I suspect watchpoints wouldn't hit for
emulation though - that would be trickier to do nicely though as it
would need to be checked for in both kernel and userspace emulation.

>
>> +	return kvm_arm_maybe_return_debug(vcpu, run);
>>  }
>>
>>  static int decode_hsr(struct kvm_vcpu *vcpu, bool *is_write, int *len)
>> --
>> 2.14.1
>>
>
> Thanks,
> -Christoffer


--
Alex Benn=C3=A9e
