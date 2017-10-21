From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v4 09/11] KVM: arm/arm64: vgic-its: free caches when
 GITS_BASER Valid bit is cleared
Date: Sat, 21 Oct 2017 16:36:22 +0200
Message-ID: <fd2f211e-c5dc-9e63-b81a-07a7dc3a5108@redhat.com>
References: <1508224209-15366-1-git-send-email-eric.auger@redhat.com>
 <1508224209-15366-10-git-send-email-eric.auger@redhat.com>
 <20171017223456.GI8326@lvm> <5845e6bc-52a6-57ef-a5d3-5c5182b19e53@redhat.com>
 <20171021143149.GB12618@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171021143149.GB12618@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com, wu.wubin@huawei.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 21/10/2017 16:31, Christoffer Dall wrote:
> On Sat, Oct 21, 2017 at 12:13:21PM +0200, Auger Eric wrote:
>> Hi Christoffer,
>>
>> On 18/10/2017 00:34, Christoffer Dall wrote:
>>> On Tue, Oct 17, 2017 at 09:10:07AM +0200, Eric Auger wrote:
>>>> When the GITS_BASER<n>.Valid gets cleared, the data structures in
>>>> guest RAM are not valid anymore. The device, collection
>>>> and LPI lists stored in the in-kernel ITS represent the same
>>>> information in some form of cache. So let's void the cache.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>
>>>> ---
>>>>
>>>> v2 -> v3:
>>>> - add a comment and clear cache in if block
>>>> ---
>>>>  virt/kvm/arm/vgic/vgic-its.c | 23 +++++++++++++++++++----
>>>>  1 file changed, 19 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>>> index f3f0026f..084239c 100644
>>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>>> @@ -1471,8 +1471,9 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>>>>  				      unsigned long val)
>>>>  {
>>>>  	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
>>>> -	u64 entry_size, device_type;
>>>> +	u64 entry_size;
>>>>  	u64 reg, *regptr, clearbits = 0;
>>>> +	int type;
>>>>  
>>>>  	/* When GITS_CTLR.Enable is 1, we ignore write accesses. */
>>>>  	if (its->enabled)
>>>> @@ -1482,12 +1483,12 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>>>>  	case 0:
>>>>  		regptr = &its->baser_device_table;
>>>>  		entry_size = abi->dte_esz;
>>>> -		device_type = GITS_BASER_TYPE_DEVICE;
>>>> +		type = GITS_BASER_TYPE_DEVICE;
>>>>  		break;
>>>>  	case 1:
>>>>  		regptr = &its->baser_coll_table;
>>>>  		entry_size = abi->cte_esz;
>>>> -		device_type = GITS_BASER_TYPE_COLLECTION;
>>>> +		type = GITS_BASER_TYPE_COLLECTION;
>>>>  		clearbits = GITS_BASER_INDIRECT;
>>>>  		break;
>>>>  	default:
>>>> @@ -1499,10 +1500,24 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
>>>>  	reg &= ~clearbits;
>>>>  
>>>>  	reg |= (entry_size - 1) << GITS_BASER_ENTRY_SIZE_SHIFT;
>>>> -	reg |= device_type << GITS_BASER_TYPE_SHIFT;
>>>> +	reg |= (u64)type << GITS_BASER_TYPE_SHIFT;
>>>>  	reg = vgic_sanitise_its_baser(reg);
>>>>  
>>>>  	*regptr = reg;
>>>> +
>>>> +	/* Table no longer valid: clear cached data */
>>>> +	if (!(reg & GITS_BASER_VALID)) {
>>>> +		switch (type) {
>>>> +		case GITS_BASER_TYPE_DEVICE:
>>>> +			vgic_its_free_device_list(kvm, its);
>>>> +			break;
>>>> +		case GITS_BASER_TYPE_COLLECTION:
>>>> +			vgic_its_free_collection_list(kvm, its);
>>>> +			break;
>>>> +		default:
>>>> +			break;
>>>> +		}
>>>> +	}
>>>
>>> So we do this after setting the *regptr, which makes we worried about
>>> races.
>>>
>>> How are guest writes to these registers synchronized with, for example
>>> trying to save the tables.  Perhaps we don't care because userspace
>>> should have stopped the VM before trying to save the ITS state?
>>
>> Yes save & restore can happen only if all vcpus are locked. Same for
>> user space accesses.
>>
> 
> So this cannot happens, because the save/restore operation will fail to
> get the lock of an executing VCPU which is modifying this function?

Yes that's my understanding.

Thanks

Eric
> 
> Thanks,
> -Christoffer
> 
