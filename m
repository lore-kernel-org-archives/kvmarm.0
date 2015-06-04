From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v5 03/12] KVM: arm64: guest debug, define API headers
Date: Thu, 04 Jun 2015 14:49:17 +0100
Message-ID: <878ubzbn36.fsf@linaro.org>
References: <1432891828-4816-1-git-send-email-alex.bennee@linaro.org> <1432891828-4816-4-git-send-email-alex.bennee@linaro.org> <20150604110732.GG7657@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20150604110732.GG7657@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>David Hildenbrand <dahi@linux.vnet.ibm.com>
List-Id: kvmarm@lists.cs.columbia.edu


Christoffer Dall <christoffer.dall@linaro.org> writes:

> On Fri, May 29, 2015 at 10:30:19AM +0100, Alex Benn=C3=A9e wrote:
>> This commit defines the API headers for guest debugging. There are t=
wo
>> architecture specific debug structures:
>>=20
>>   - kvm_guest_debug_arch, allows us to pass in HW debug registers
>>   - kvm_debug_exit_arch, signals exception and possible faulting add=
ress
>>=20
>> The type of debugging being used is controlled by the architecture
>> specific control bits of the kvm_guest_debug->control flags in the i=
octl
>> structure.
>>=20
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
>> Reviewed-by: Andrew Jones <drjones@redhat.com>
>> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
>
> I can re-confirm my ack despite the changes in v4, but this really is
> borderline to keep exiting r-b and a-b tags around from previous patc=
hes
> I would think, but ok.

I was wondering how much a patch has to change for the r-b tags to
become invalid. The meat of the API hasn't changed much though.

Drew/David,

Are you still happy with this patch?

>
> -Christoffer
>
>>=20
>> ---
>> v2
>>    - expose hsr and pc directly to user-space
>> v3
>>    - s/control/controlled/ in commit message
>>    - add v8 to ARM ARM comment (ARM Architecture Reference Manual)
>>    - add rb tag
>>    - rm pc, add far
>>    - re-word comments on alignment
>>    - rename KVM_ARM_NDBG_REGS -> KVM_ARM_MAX_DBG_REGS
>> v4
>>    - now uses common HW/SW BP define
>>    - add a-b-tag
>>    - use u32 for control regs
>> v5
>>    - revert to have arch specific KVM_GUESTDBG_USE_SW/HW_BP
>>    - rm stale comments dbgctrl was stored as u64
>> ---
>>  arch/arm64/include/uapi/asm/kvm.h | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>=20
>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/=
uapi/asm/kvm.h
>> index d268320..43758e7 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -100,12 +100,32 @@ struct kvm_sregs {
>>  struct kvm_fpu {
>>  };
>> =20
>> +/*
>> + * See v8 ARM ARM D7.3: Debug Registers
>> + *
>> + * The architectural limit is 16 debug registers of each type altho=
ugh
>> + * in practice there are usually less (see ID_AA64DFR0_EL1).
>> + */
>> +#define KVM_ARM_MAX_DBG_REGS 16
>>  struct kvm_guest_debug_arch {
>> +	__u32 dbg_bcr[KVM_ARM_MAX_DBG_REGS];
>> +	__u64 dbg_bvr[KVM_ARM_MAX_DBG_REGS];
>> +	__u32 dbg_wcr[KVM_ARM_MAX_DBG_REGS];
>> +	__u64 dbg_wvr[KVM_ARM_MAX_DBG_REGS];
>>  };
>> =20
>>  struct kvm_debug_exit_arch {
>> +	__u32 hsr;
>> +	__u64 far;
>>  };
>> =20
>> +/*
>> + * Architecture specific defines for kvm_guest_debug->control
>> + */
>> +
>> +#define KVM_GUESTDBG_USE_SW_BP		(1 << 16)
>> +#define KVM_GUESTDBG_USE_HW_BP		(1 << 17)
>> +
>>  struct kvm_sync_regs {
>>  };
>> =20
>> --=20
>> 2.4.1
>>=20

--=20
Alex Benn=C3=A9e
