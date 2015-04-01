From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 03/10] KVM: arm: guest debug, define API headers
Date: Wed, 01 Apr 2015 17:01:26 +0100
Message-ID: <87h9szyh0p.fsf@linaro.org>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org> <1427814488-28467-4-git-send-email-alex.bennee@linaro.org> <20150401174646.74f695bd@thinkpad-w530>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20150401174646.74f695bd@thinkpad-w530>
Sender: kvm-owner@vger.kernel.org
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, r65777@freescale.com, bp@suse.de, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu


David Hildenbrand <dahi@linux.vnet.ibm.com> writes:

>> This commit defines the API headers for guest debugging. There are t=
wo
>> architecture specific debug structures:
>>=20
>>   - kvm_guest_debug_arch, allows us to pass in HW debug registers
>>   - kvm_debug_exit_arch, signals the exact debug exit and pc
>>=20
>> The type of debugging being used is control by the architecture spec=
ific
>
> s/control/controlled/

good catch

>
>> control bits of the kvm_guest_debug->control flags in the ioctl
>> structure.
>>=20
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>=20
>> ---
>> v2
>>    - expose hsr and pc directly to user-space
>>=20
>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/=
uapi/asm/kvm.h
>> index 3ef77a4..6ee70a0 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -100,10 +100,24 @@ struct kvm_sregs {
>>  struct kvm_fpu {
>>  };
>>=20
>> +/*
>> + * See ARM ARM D7.3: Debug Registers
>
> Maybe drop one ARM

Well technically it is the ARM Architecture Reference Manual but that's
quite long winded.

>
>> + *
>> + * The control registers are architecturally defined as 32 bits but=
 are
>> + * stored as 64 bit values along side the value registers and align=
ed
>> + * with the rest 64 bit registers in the normal CPU context.
>> + */
>> +#define KVM_ARM_NDBG_REGS 16
>>  struct kvm_guest_debug_arch {
>> +	__u64 dbg_bcr[KVM_ARM_NDBG_REGS];
>> +	__u64 dbg_bvr[KVM_ARM_NDBG_REGS];
>> +	__u64 dbg_wcr[KVM_ARM_NDBG_REGS];
>> +	__u64 dbg_wvr[KVM_ARM_NDBG_REGS];
>>  };
>>=20
>>  struct kvm_debug_exit_arch {
>> +	__u64 pc;
>> +	__u32 hsr;
>>  };
>>=20
>>  struct kvm_sync_regs {
>> @@ -207,4 +221,11 @@ struct kvm_arch_memory_slot {
>>=20
>>  #endif
>>=20
>> +/*
>> + * Architecture related debug defines - upper 16 bits of
>> + * kvm_guest_debug->control
>> + */
>> +#define KVM_GUESTDBG_USE_SW_BP	        __KVM_GUESTDBG_USE_SW_BP
>> +#define KVM_GUESTDBG_USE_HW_BP		__KVM_GUESTDBG_USE_HW_BP
>> +
>>  #endif /* __ARM_KVM_H__ */
>
> Looks good to me!

Is that a Reviewed-by?

>
> David

--=20
Alex Benn=C3=A9e
