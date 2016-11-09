From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [kvm-unit-tests PATCH v4 03/11] arm/arm64: smp: support more than
 8 cpus
Date: Wed, 9 Nov 2016 12:01:42 +0000
Message-ID: <33e2c904-cea1-6d21-4be9-b3fbd037c563@arm.com>
References: <1478636499-14339-1-git-send-email-drjones@redhat.com>
 <1478636499-14339-4-git-send-email-drjones@redhat.com>
 <f5509dd7-594b-04c8-20b0-2986fe1bcc41@arm.com>
 <20161109115732.hpiaiigtgfgnrybt@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBF824025C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2016 07:00:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8-9Uxxj9u5HJ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2016 07:00:54 -0500 (EST)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E46A401C7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2016 07:00:52 -0500 (EST)
In-Reply-To: <20161109115732.hpiaiigtgfgnrybt@kamzik.brq.redhat.com>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 09/11/16 11:57, Andrew Jones wrote:
> On Wed, Nov 09, 2016 at 11:12:03AM +0000, Andre Przywara wrote:
> [...]
>>> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
>>> index 7e7b39f11dde..b6e2d5815e72 100644
>>> --- a/lib/arm/setup.c
>>> +++ b/lib/arm/setup.c
>>> @@ -24,12 +24,22 @@ extern unsigned long stacktop;
>>>  extern void io_init(void);
>>>  extern void setup_args_progname(const char *args);
>>>  
>>> -u32 cpus[NR_CPUS] = { [0 ... NR_CPUS-1] = (~0U) };
>>> +u64 cpus[NR_CPUS] = { [0 ... NR_CPUS-1] = (~0U) };
>>
>> This should be ~0UL.
> 
> Indeed. Thanks.
> 
>> Also I think the type should be unsigned long to match the types used
>> everywhere else.
> 
> I'll change mpidr_to_cpu to return u64 instead of unsigned long.

I am not sure this is the right direction. unsigned long is really the
natural type for MPIDR, since this is a system register with exactly the
native register size.
I think we use it this way in the kernel.

Cheers,
Andre

> Actually I think Alex suggested that. I'm not sure why I haven't
> done it...
> 
>>
>>>  int nr_cpus;
>>>  
>>>  struct mem_region mem_regions[NR_MEM_REGIONS];
>>>  phys_addr_t __phys_offset, __phys_end;
>>>  
>>> +int mpidr_to_cpu(unsigned long mpidr)
>>> +{
>>> +	int i;
>>> +
>>> +	for (i = 0; i < nr_cpus; ++i)
>>> +		if (cpus[i] == (mpidr & MPIDR_HWID_BITMASK))
>>> +			return i;
>>> +	return -1;
>>> +}
>>> +
>>>  static void cpu_set(int fdtnode __unused, u32 regval, void *info __unused)
>>
>> I guess this needs to be extended as well, including
>> dt_for_each_cpu_node() to cope with 64-bit reg properties in the CPU
>> node (where the upper word is not 0).
>> But this is not really crucial atm, so can be fixed in a follow-up patch.
> 
> Yeah, I'll do it as a followup series, because it'll affect powerpc too.
> 
> drew
> 
