From: Itaru Kitayama <itaru.kitayama@riken.jp>
Subject: Re: Increase GICV size to 64KB so !4KB page-size kernels are able to
 initialize KVM
Date: Wed, 22 Jun 2016 20:02:37 +0900
Message-ID: <57f56525-119a-8566-8d9b-43b7bcb23a49@riken.jp>
References: <8b9c3e26-97b1-307f-8227-5ca3a4966c84@riken.jp>
 <576A630E.10800@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FF7749B2E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 06:57:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u6uxsBCVVkmV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2016 06:57:46 -0400 (EDT)
Received: from postman.riken.jp (postman2.riken.jp [134.160.33.84])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0722F49B1A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 06:57:45 -0400 (EDT)
In-Reply-To: <576A630E.10800@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

Thanks for your comments. I'm definitely interested in your patch set 
that makes KVM to work with large page sizes. I'll ask the vendor to 
update some ACPI tables. (I'm on Overdrive with recent F/W though I 
think the GICV physical address is aligned at 4KB boundary still)

Itaru

On 6/22/16 7:06 PM, Marc Zyngier wrote:
> On 22/06/16 07:48, Itaru Kitayama wrote:
>> Against the tag v4.7-rc2 in the kvmtree.
>>
>> ---
>>   drivers/irqchip/irq-gic.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>> index fbc4ae2..bd463a3 100644
>> --- a/drivers/irqchip/irq-gic.c
>> +++ b/drivers/irqchip/irq-gic.c
>> @@ -1425,7 +1425,7 @@ static bool __init gic_validate_dist(struct
>> acpi_subtable_header *header,
>>   #define ACPI_GICV2_DIST_MEM_SIZE       (SZ_4K)
>>   #define ACPI_GIC_CPU_IF_MEM_SIZE       (SZ_8K)
>>   #define ACPI_GICV2_VCTRL_MEM_SIZE      (SZ_4K)
>> -#define ACPI_GICV2_VCPU_MEM_SIZE       (SZ_8K)
>> +#define ACPI_GICV2_VCPU_MEM_SIZE       (SZ_64K)
>>
>>   static void __init gic_acpi_setup_kvm_info(void)
>>   {
>>
>
> I'm afraid this is the wrong approach. No matter how you look at it, the
> size of the GICV region is 8kB, and not 64kB. On some systems the GICV
> region is *aliased* over 128kB (first 4kB aliased over the first 64kB
> page, second 4kB aliased over the second 64kB page). The usable range
> for the GICV region is then the f000-10fff region in order to preserve
> the contiguity of the two 4kB blocks.
>
> In that case, ACPI ought to provide the base address of the usable
> range, not some dummy address. It would be different if the ACPI tables
> would provide the size of the region (where we could make an educated
> guess at what is happening, just like with DT), but the information is
> simply not available. So my advise here is to fix your ACPI tables (or
> get them fixed).
>
> What is actually missing in KVM is a way to describe the offset within a
> page at which the GICV region must be mapped. I have patches for that
> that I may revive if there is some interest.
>
> Thanks,
>
> 	M.
>
