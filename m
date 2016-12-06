From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests RFC 05/15] arm/arm64: GICv3: add cpu
 count
Date: Tue, 6 Dec 2016 11:04:48 +0100
Message-ID: <aed4d5a3-a423-0e0f-654f-5969378efd9a@redhat.com>
References: <1480974406-29345-1-git-send-email-eric.auger@redhat.com>
 <1480974406-29345-6-git-send-email-eric.auger@redhat.com>
 <20161206092925.mk4gwx7jbomzxsfz@kamzik.brq.redhat.com>
 <b7ba4a79-0a8d-3520-ba19-1afd6f2de4c1@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4261540425
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 05:03:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6YLkCEXrsNCY for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2016 05:03:57 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1694F4022C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 05:03:56 -0500 (EST)
In-Reply-To: <b7ba4a79-0a8d-3520-ba19-1afd6f2de4c1@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre, Drew,

On 06/12/2016 10:32, Andre Przywara wrote:
> Hi,
> 
> On 06/12/16 09:29, Andrew Jones wrote:
>> On Mon, Dec 05, 2016 at 10:46:36PM +0100, Eric Auger wrote:
>>> Add a new cpu_count field in gicv3_data indicating the
>>> number of redistributors. This will be useful for enumeration
>>> of their resources such as LPI pending tables.
>>
>> I'm fine with the additional state, but just curious, will it
>> ever be possible for gicv3.cpu_count != nr_cpus?
> 
> If not you are in trouble, so that should in fact be one test.
> 
> Which brings me to my comment ...
> 
>>>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>> ---
>>>  lib/arm/asm/gic-v3.h | 1 +
>>>  lib/arm/gic-v3.c     | 2 ++
>>>  2 files changed, 3 insertions(+)
>>>
>>> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
>>> index ed330af..039b7c2 100644
>>> --- a/lib/arm/asm/gic-v3.h
>>> +++ b/lib/arm/asm/gic-v3.h
>>> @@ -58,6 +58,7 @@ struct gicv3_data {
>>>  	void *dist_base;
>>>  	void *redist_base[NR_CPUS];
>>>  	unsigned int irq_nr;
>>> +	unsigned int cpu_count;
> 
> Should that be called "nr_redists" or the like?
> Since this is what it counts in the code below.
> Later we can then compare this with nr_cpus to check for a match.

I fully agree with you suggestion.

Thanks

Eric
> 
> Cheers,
> Andre.
> 
>>>  };
>>>  extern struct gicv3_data gicv3_data;
>>>  
>>> diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
>>> index 6246221..9921f4d 100644
>>> --- a/lib/arm/gic-v3.c
>>> +++ b/lib/arm/gic-v3.c
>>> @@ -12,12 +12,14 @@ void gicv3_set_redist_base(size_t stride)
>>>  	void *ptr = gicv3_data.redist_base[0];
>>>  	u64 typer;
>>>  
>>> +	gicv3_data.cpu_count = 0;
>>>  	do {
>>>  		typer = gicv3_read_typer(ptr + GICR_TYPER);
>>>  		if ((typer >> 32) == aff) {
>>>  			gicv3_redist_base() = ptr;
>>>  			return;
>>>  		}
>>> +		gicv3_data.cpu_count++;
>>>  		ptr += stride; /* skip RD_base, SGI_base, etc. */
>>>  	} while (!(typer & GICR_TYPER_LAST));
>>>  
>>> -- 
>>> 2.5.5
>>>
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
