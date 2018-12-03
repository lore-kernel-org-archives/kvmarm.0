From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 01/12] KVM: arm64: Document PV-time interface
Date: Mon, 3 Dec 2018 15:23:41 +0000
Message-ID: <389b6206-1e29-16a3-1aa1-5a79b83683c5@arm.com>
References: <20181128144527.44710-1-steven.price@arm.com>
 <20181128144527.44710-2-steven.price@arm.com>
 <20181203135042.v52wawfz4nc27fna@kamzik.brq.redhat.com>
 <4ec62f53-9c3f-14cb-f1bb-c8b9aadb9bdd@arm.com>
 <20181203151636.scziollrzpulbdke@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AACB4A200
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 10:23:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4wnrnAwhfLjR for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Dec 2018 10:23:45 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2959A4A1DF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 10:23:45 -0500 (EST)
In-Reply-To: <20181203151636.scziollrzpulbdke@kamzik.brq.redhat.com>
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
To: Andrew Jones <drjones@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Steven Price <steven.price@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 03/12/2018 15:16, Andrew Jones wrote:
> On Mon, Dec 03, 2018 at 02:18:25PM +0000, Marc Zyngier wrote:
>> On 03/12/2018 13:50, Andrew Jones wrote:
>>> On Wed, Nov 28, 2018 at 02:45:16PM +0000, Steven Price wrote:
>>>> +The structure pointed to by the PV_TIME_LPT hypercall is as follows:
>>>> +
>>>> +  Field           | Byte Length | Byte Offset | Description
>>>> +  --------------- | ----------- | ----------- | -------------------------------
>>>> +  Revision        |      4      |      0      | Must be 0 for this revision
>>>> +  Attributes      |      4      |      4      | Must be 0
>>>> +  sequence_number |      8      |      8      | Bit 0: reserved
>>>> +                  |             |             | Bits 1:63 number of migrations
>>>> +  scale_mult      |      8      |      16     | Multiplier to scale from native
>>>> +                  |             |             | frequency to PV frequency
>>>> +  shift           |      4      |      24     | Shift applied before multiplier
>>>> +  Reserved        |      4      |      28     | Must be 0
>>>> +  Fn              |      8      |      32     | Native frequency
>>>> +  Fpv             |      8      |      40     | Paravirtualized frequency seen
>>>> +                  |             |             | by guest
>>>> +  div_by_fpv_mult |      8      |      48     | Multiplier to implement fast
>>>> +                  |             |             | divide by Fpv
>>>
>>> Here's kvmclock's struct
>>>
>>>  struct pvclock_vcpu_time_info {
>>>         u32   version; 
>>>         u32   pad0;
>>>         u64   tsc_timestamp;
>>>         u64   system_time;
>>>         u32   tsc_to_system_mul;
>>>         s8    tsc_shift;
>>>         u8    flags;
>>>         u8    pad[2];
>>>  }
>>>
>>>  Revision	 =>
>>>  Attributes	 =>
>>>  sequence_number => version
>>>  scale_mult	 => tsc_to_system_mul	(this is reversed, but OK)
>>>  shift		 => tsc_shift           (also reversed)
>>>  Reserved	 =>
>>>  Fn		 => (pvclock doesn't have, but does have system_time)
>>>  Fpv		 =>
>>>  div_by_fpv_mult =>
>>>
>>> I haven't thought about this enough yet to be sure kvmclock's fields
>>> are sufficient, but several look close - although the 'tsc' naming
>>> isn't nice. Also, the pvclock struct could be extended by adding an
>>> 'extended' flag to 'flags', and then appending more fields.
>>
>> One important thing is that this is not a KVM PV time implementation.
>> This is something generic for the ARM architecture. Any ARM hypervisor
>> should be able to implement this.
>>
> 
> I agree with that, but xen also uses the same pvclock structure on x86.

Which makes sense.

Each architecture has a way to express its PV time based on its own
requirements, and I'd expect Xen on arm64 to use the ARM data structure
(/me eyes the Xen/ARM maintainer...). I thought that what you were
advocating was to use the x86 layout on ARM, which didn't make complete
sense to me.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
