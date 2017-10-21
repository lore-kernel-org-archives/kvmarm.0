From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v4 09/11] KVM: arm/arm64: vgic-its: free caches when
 GITS_BASER Valid bit is cleared
Date: Sat, 21 Oct 2017 12:13:21 +0200
Message-ID: <5845e6bc-52a6-57ef-a5d3-5c5182b19e53@redhat.com>
References: <1508224209-15366-1-git-send-email-eric.auger@redhat.com>
 <1508224209-15366-10-git-send-email-eric.auger@redhat.com>
 <20171017223456.GI8326@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F86C49D1D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 21 Oct 2017 06:12:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 49G2VBJSFiGG for <kvmarm@lists.cs.columbia.edu>;
 Sat, 21 Oct 2017 06:12:20 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42BE349D09
 for <kvmarm@lists.cs.columbia.edu>; Sat, 21 Oct 2017 06:12:20 -0400 (EDT)
In-Reply-To: <20171017223456.GI8326@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 18/10/2017 00:34, Christoffer Dall wrote:
> On Tue, Oct 17, 2017 at 09:10:07AM +0200, Eric Auger wrote:
>> When the GITS_BASER<n>.Valid gets cleared, the data structures in
>> guest RAM are not valid anymore. The device, collection
>> and LPI lists stored in the in-kernel ITS represent the same
>> information in some form of cache. So let's void the cache.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v2 -> v3:
>> - add a comment and clear cache in if block
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 23 +++++++++++++++++++----
>>  1 file changed, 19 insertions(+), 4 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index f3f0026f..084239c 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -1471,8 +1471,9 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>>  				      unsigned long val)
>>  {
>>  	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
>> -	u64 entry_size, device_type;
>> +	u64 entry_size;
>>  	u64 reg, *regptr, clearbits = 0;
>> +	int type;
>>  
>>  	/* When GITS_CTLR.Enable is 1, we ignore write accesses. */
>>  	if (its->enabled)
>> @@ -1482,12 +1483,12 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>>  	case 0:
>>  		regptr = &its->baser_device_table;
>>  		entry_size = abi->dte_esz;
>> -		device_type = GITS_BASER_TYPE_DEVICE;
>> +		type = GITS_BASER_TYPE_DEVICE;
>>  		break;
>>  	case 1:
>>  		regptr = &its->baser_coll_table;
>>  		entry_size = abi->cte_esz;
>> -		device_type = GITS_BASER_TYPE_COLLECTION;
>> +		type = GITS_BASER_TYPE_COLLECTION;
>>  		clearbits = GITS_BASER_INDIRECT;
>>  		break;
>>  	default:
>> @@ -1499,10 +1500,24 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>>  	reg &= ~clearbits;
>>  
>>  	reg |= (entry_size - 1) << GITS_BASER_ENTRY_SIZE_SHIFT;
>> -	reg |= device_type << GITS_BASER_TYPE_SHIFT;
>> +	reg |= (u64)type << GITS_BASER_TYPE_SHIFT;
>>  	reg = vgic_sanitise_its_baser(reg);
>>  
>>  	*regptr = reg;
>> +
>> +	/* Table no longer valid: clear cached data */
>> +	if (!(reg & GITS_BASER_VALID)) {
>> +		switch (type) {
>> +		case GITS_BASER_TYPE_DEVICE:
>> +			vgic_its_free_device_list(kvm, its);
>> +			break;
>> +		case GITS_BASER_TYPE_COLLECTION:
>> +			vgic_its_free_collection_list(kvm, its);
>> +			break;
>> +		default:
>> +			break;
>> +		}
>> +	}
> 
> So we do this after setting the *regptr, which makes we worried about
> races.
> 
> How are guest writes to these registers synchronized with, for example
> trying to save the tables.  Perhaps we don't care because userspace
> should have stopped the VM before trying to save the ITS state?

Yes save & restore can happen only if all vcpus are locked. Same for
user space accesses.

Thanks

Eric

> 
> 
> 
>>  }
>>  
>>  static unsigned long vgic_mmio_read_its_ctlr(struct kvm *vcpu,
>> -- 
>> 2.5.5
>>
> 
> Otherwise looks good to me.
> -Christoffer
> 
