From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 01/12] KVM: arm64: Document PV-time interface
Date: Mon, 3 Dec 2018 14:18:25 +0000
Message-ID: <4ec62f53-9c3f-14cb-f1bb-c8b9aadb9bdd@arm.com>
References: <20181128144527.44710-1-steven.price@arm.com>
 <20181128144527.44710-2-steven.price@arm.com>
 <20181203135042.v52wawfz4nc27fna@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 656D14A331
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 09:18:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MO5eUQl3x1S6 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Dec 2018 09:18:28 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E2054A200
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 09:18:28 -0500 (EST)
In-Reply-To: <20181203135042.v52wawfz4nc27fna@kamzik.brq.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, Steven Price <steven.price@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Drew,

On 03/12/2018 13:50, Andrew Jones wrote:
> On Wed, Nov 28, 2018 at 02:45:16PM +0000, Steven Price wrote:
>> We introduce a paravirtualization interface for KVM/arm64 based on the
>> "Arm Paravirtualized Time for Arm-Base Systems" specification DEN 0057A.
>>
>> User space can specify a reserved area of memory for the guest and
>> inform KVM to populate the memory with information on stolen time and
>> Live Physical Time (LPT) that can be used to derive a stable
>> counter/timer for a guest subject to migration between hosts with
>> different counter frequencies.
>>
>> A hypercall interface is provided for the guest to interrogate the
>> hypervisor's support for this interface and the location of the shared
>> memory structures.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  Documentation/virtual/kvm/arm/pvtime.txt | 169 +++++++++++++++++++++++
>>  1 file changed, 169 insertions(+)
>>  create mode 100644 Documentation/virtual/kvm/arm/pvtime.txt
>>
>> diff --git a/Documentation/virtual/kvm/arm/pvtime.txt b/Documentation/virtual/kvm/arm/pvtime.txt
>> new file mode 100644
>> index 000000000000..1870b904075b
>> --- /dev/null
>> +++ b/Documentation/virtual/kvm/arm/pvtime.txt
>> @@ -0,0 +1,169 @@
>> +Paravirtualized time support for arm64
>> +======================================
>> +
>> +Arm specification DEN0057/A defined a standard for paravirtualised time
>> +support for Aarch64 guests:
>> +
>> +https://developer.arm.com/docs/den0057/a
>> +
>> +KVM/Arm64 implements this specification by providing some hypervisor service
>> +calls to support a paravirtualized guest obtaining a view of the amount of
>> +time stolen from its execution and a concept of Live Physical Time (LPT) which
>> +represents time during which the guest is running and works across migrations.
>> +
>> +Three new SMCCC compatible hypercalls are defined:
>> +
>> +PV_FEATURES 0xC5000020
>> +PV_TIME_LPT 0xC5000021
>> +PV_TIME_ST  0xC5000022
>> +
>> +These are only available in the SMC64/HVC64 calling convention as
>> +paravirtualized time is not available to 32 bit Arm guests.
>> +
>> +PV_FEATURES
>> +    Function ID:  (uint32)  : 0xC5000020
>> +    PV_func_id:   (uint32)  : Either PV_TIME_LPT or PV_TIME_ST
>> +    Return value: (int32)   : NOT_SUPPORTED (-1) or SUCCESS (0) if the relevant
>> +                              PV-time feature is supported by the hypervisor.
> 
> What happens when a new guest tries this hypercall on an old host? Why not
> return a bitmap of all supported features so the guest doesn't have to
> do multiple hypercalls to build its bitmap?

A guest doesn't call this directly. It first checks that the service is
implemented, and only if it is, it can call it. It is the exact same
mechanism we use for other hypercalls (such as the Spectre mitigation
services). If the guest bypasses the discovery mechanism, tough.

> 
>> +
>> +PV_TIME_LPT
>> +    Function ID:  (uint32)  : 0xC5000021
>> +    Flags:        (uint32)  : Bit[0]: Request migration interrupts
>> +                                      (not currently supported by KVM)
>> +    Return value: (int64)   : IPA of the shared live physical time data
>> +                              structure or negative error code on failure:
>> +                              NOT_SUPPORTED (-1)
>> +                              INVALID_PARAMETERS (-2)
>> +
>> +PV_TIME_ST
>> +    Function ID:  (uint32)  : 0xC5000022
>> +    Return value: (int64)   : IPA of the stolen time data structure for this
>> +                              (V)CPU. On failure:
>> +                              NOT_SUPPORTED (-1)
>> +
>> +Live Physical Time
>> +------------------
>> +
>> +The structure pointed to by the PV_TIME_LPT hypercall is as follows:
>> +
>> +  Field           | Byte Length | Byte Offset | Description
>> +  --------------- | ----------- | ----------- | -------------------------------
>> +  Revision        |      4      |      0      | Must be 0 for this revision
>> +  Attributes      |      4      |      4      | Must be 0
>> +  sequence_number |      8      |      8      | Bit 0: reserved
>> +                  |             |             | Bits 1:63 number of migrations
>> +  scale_mult      |      8      |      16     | Multiplier to scale from native
>> +                  |             |             | frequency to PV frequency
>> +  shift           |      4      |      24     | Shift applied before multiplier
>> +  Reserved        |      4      |      28     | Must be 0
>> +  Fn              |      8      |      32     | Native frequency
>> +  Fpv             |      8      |      40     | Paravirtualized frequency seen
>> +                  |             |             | by guest
>> +  div_by_fpv_mult |      8      |      48     | Multiplier to implement fast
>> +                  |             |             | divide by Fpv
> 
> Here's kvmclock's struct
> 
>  struct pvclock_vcpu_time_info {
>         u32   version; 
>         u32   pad0;
>         u64   tsc_timestamp;
>         u64   system_time;
>         u32   tsc_to_system_mul;
>         s8    tsc_shift;
>         u8    flags;
>         u8    pad[2];
>  }
> 
>  Revision	 =>
>  Attributes	 =>
>  sequence_number => version
>  scale_mult	 => tsc_to_system_mul	(this is reversed, but OK)
>  shift		 => tsc_shift           (also reversed)
>  Reserved	 =>
>  Fn		 => (pvclock doesn't have, but does have system_time)
>  Fpv		 =>
>  div_by_fpv_mult =>
> 
> I haven't thought about this enough yet to be sure kvmclock's fields
> are sufficient, but several look close - although the 'tsc' naming
> isn't nice. Also, the pvclock struct could be extended by adding an
> 'extended' flag to 'flags', and then appending more fields.

One important thing is that this is not a KVM PV time implementation.
This is something generic for the ARM architecture. Any ARM hypervisor
should be able to implement this.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
