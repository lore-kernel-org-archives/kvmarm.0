From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [RFC PATCH 7/8] KVM: arm64: vgic-its: fix compatability with
 32-bit
Date: Fri, 21 Oct 2016 12:19:31 +0100
Message-ID: <5809F9C3.7020309@arm.com>
References: <1477042601-15227-1-git-send-email-vladimir.murzin@arm.com>
 <1477042601-15227-8-git-send-email-vladimir.murzin@arm.com>
 <5ea0ecc0-edb1-f770-16f3-7c48dbdb5c29@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A6E649B3D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 07:09:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0XCiXfbPL9JW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Oct 2016 07:09:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE12B49B32
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 07:09:12 -0400 (EDT)
In-Reply-To: <5ea0ecc0-edb1-f770-16f3-7c48dbdb5c29@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 21/10/16 10:49, Andre Przywara wrote:
> Hi,
> 
> On 21/10/16 10:36, Vladimir Murzin wrote:
>> Evaluate GITS_BASER_ENTRY_SIZE once as an int data (GITS_BASER<n>'s
>> Entry Size is 5-bit wide only), so when used as divider no reference
>> to __aeabi_uldivmod is generated when build for AArch32.
>>
>> Use unsigned long long for GITS_BASER_PAGE_SIZE_* since they are
>> used in conjunction with 64-bit data.
>>
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> 
> Looks good to me, thanks for fixing this!
> 
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Thanks!

Vladimir

> 
> Cheers,
> Andre.
> 
>> ---
>>  include/linux/irqchip/arm-gic-v3.h |    8 ++++----
>>  virt/kvm/arm/vgic/vgic-its.c       |   11 ++++++-----
>>  2 files changed, 10 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
>> index 5118d3a..e808f8a 100644
>> --- a/include/linux/irqchip/arm-gic-v3.h
>> +++ b/include/linux/irqchip/arm-gic-v3.h
>> @@ -295,10 +295,10 @@
>>  #define GITS_BASER_InnerShareable					\
>>  	GIC_BASER_SHAREABILITY(GITS_BASER, InnerShareable)
>>  #define GITS_BASER_PAGE_SIZE_SHIFT	(8)
>> -#define GITS_BASER_PAGE_SIZE_4K		(0UL << GITS_BASER_PAGE_SIZE_SHIFT)
>> -#define GITS_BASER_PAGE_SIZE_16K	(1UL << GITS_BASER_PAGE_SIZE_SHIFT)
>> -#define GITS_BASER_PAGE_SIZE_64K	(2UL << GITS_BASER_PAGE_SIZE_SHIFT)
>> -#define GITS_BASER_PAGE_SIZE_MASK	(3UL << GITS_BASER_PAGE_SIZE_SHIFT)
>> +#define GITS_BASER_PAGE_SIZE_4K		(0ULL << GITS_BASER_PAGE_SIZE_SHIFT)
>> +#define GITS_BASER_PAGE_SIZE_16K	(1ULL << GITS_BASER_PAGE_SIZE_SHIFT)
>> +#define GITS_BASER_PAGE_SIZE_64K	(2ULL << GITS_BASER_PAGE_SIZE_SHIFT)
>> +#define GITS_BASER_PAGE_SIZE_MASK	(3ULL << GITS_BASER_PAGE_SIZE_SHIFT)
>>  #define GITS_BASER_PAGES_MAX		256
>>  #define GITS_BASER_PAGES_SHIFT		(0)
>>  #define GITS_BASER_NR_PAGES(r)		(((r) & 0xff) + 1)
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 4660a7d..8c2b3cd 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -632,21 +632,22 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, int id)
>>  	int index;
>>  	u64 indirect_ptr;
>>  	gfn_t gfn;
>> +	int esz = GITS_BASER_ENTRY_SIZE(baser);
>>  
>>  	if (!(baser & GITS_BASER_INDIRECT)) {
>>  		phys_addr_t addr;
>>  
>> -		if (id >= (l1_tbl_size / GITS_BASER_ENTRY_SIZE(baser)))
>> +		if (id >= (l1_tbl_size / esz))
>>  			return false;
>>  
>> -		addr = BASER_ADDRESS(baser) + id * GITS_BASER_ENTRY_SIZE(baser);
>> +		addr = BASER_ADDRESS(baser) + id * esz;
>>  		gfn = addr >> PAGE_SHIFT;
>>  
>>  		return kvm_is_visible_gfn(its->dev->kvm, gfn);
>>  	}
>>  
>>  	/* calculate and check the index into the 1st level */
>> -	index = id / (SZ_64K / GITS_BASER_ENTRY_SIZE(baser));
>> +	index = id / (SZ_64K / esz);
>>  	if (index >= (l1_tbl_size / sizeof(u64)))
>>  		return false;
>>  
>> @@ -670,8 +671,8 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, int id)
>>  	indirect_ptr &= GENMASK_ULL(51, 16);
>>  
>>  	/* Find the address of the actual entry */
>> -	index = id % (SZ_64K / GITS_BASER_ENTRY_SIZE(baser));
>> -	indirect_ptr += index * GITS_BASER_ENTRY_SIZE(baser);
>> +	index = id % (SZ_64K / esz);
>> +	indirect_ptr += index * esz;
>>  	gfn = indirect_ptr >> PAGE_SHIFT;
>>  
>>  	return kvm_is_visible_gfn(its->dev->kvm, gfn);
>>
> 
