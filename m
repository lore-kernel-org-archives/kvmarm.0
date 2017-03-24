From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 18/19] KVM: arm64: ITS: Device table save/restore
Date: Fri, 24 Mar 2017 11:12:48 +0000
Message-ID: <83e91a43-237f-2bce-574c-6a97ee66e8d2@arm.com>
References: <1488800074-21991-1-git-send-email-eric.auger@redhat.com>
 <1488800074-21991-19-git-send-email-eric.auger@redhat.com>
 <2c4841df-f7b3-ee03-16d3-7e32c9cbd936@arm.com>
 <728905ad-61a2-f510-b04f-5af178dfaade@redhat.com>
 <27cb5ad5-d43e-44f8-7311-c4d10de4e0ad@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F747408EB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 07:09:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SDOVpnXRFZ6I for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Mar 2017 07:09:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9BA7405DA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 07:08:59 -0400 (EDT)
In-Reply-To: <27cb5ad5-d43e-44f8-7311-c4d10de4e0ad@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 24/03/17 10:45, Auger Eric wrote:
> Hi Andre,
> 
> On 24/03/2017 11:38, Auger Eric wrote:
>> Hi Andre,
>>
>> On 22/03/2017 15:39, Andre Przywara wrote:
>>> Hi,
>>>
>>> On 06/03/17 11:34, Eric Auger wrote:
>>>> This patch flushes the device table entries into guest RAM.
>>>> Both flat table and 2 stage tables are supported.  DeviceId
>>>> indexing is used.
>>>>
>>>> For each device listed in the device table, we also flush
>>>> the translation table using the vgic_its_flush/restore_itt
>>>> routines.
>>>>
>>>> On restore, devices are re-allocated and their itte are
>>>> re-built.
>>>
>>> Some minor things below.
>>> In general I had quite some trouble to understand what's going on here,
>>> though I convinced myself that this is correct. So could you add a bit
>>> more comments here? For instance to explain that we have to explicitly
>>> handle the L1 table on restore, but not on flush.
>>
>> On flush vgic_its_check_id does the 2 stage handling and computes the
>> entry address from the devid:
>>
>> 		if (!vgic_its_check_id(its, baser,
>> 				       dev->device_id, &eaddr))
>>
>> Then you simply flush the entry at that address
>>
>> On restore, you need to scan the level1 and level2 tables for valid entries.
>>>
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>
>>>> ---
>>>> v2 -> v3:
>>>> - fix itt_addr bitmask in vgic_its_restore_dte
>>>> - addition of return 0 in vgic_its_restore_ite moved to
>>>>   the ITE related patch
>>>>
>>>> v1 -> v2:
>>>> - use 8 byte format for DTE and ITE
>>>> - support 2 stage format
>>>> - remove kvm parameter
>>>> - ITT flush/restore moved in a separate patch
>>>> - use deviceid indexing
>>>> ---
>>>>  virt/kvm/arm/vgic/vgic-its.c | 144 ++++++++++++++++++++++++++++++++++++++++++-
>>>>  1 file changed, 142 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>>> index a216849..27ebabd 100644
>>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>>> @@ -1849,12 +1849,137 @@ static int vgic_its_restore_itt(struct vgic_its *its,
>>>>  }
>>>>  
>>>>  /**
>>>> + * vgic_its_flush_dte - Flush a device table entry at a given GPA
>>>> + *
>>>> + * @its: ITS handle
>>>> + * @dev: ITS device
>>>> + * @ptr: GPA
>>>> + */
>>>> +static int vgic_its_flush_dte(struct vgic_its *its,
>>>> +			      struct its_device *dev, gpa_t ptr)
>>>> +{
>>>> +	struct kvm *kvm = its->dev->kvm;
>>>> +	u64 val, itt_addr_field;
>>>> +	int ret;
>>>> +	u32 next_offset;
>>>> +
>>>> +	itt_addr_field = dev->itt_addr >> 8;
>>>> +	next_offset = compute_next_devid_offset(&its->device_list, dev);
>>>> +	val = (((u64)next_offset << 45) | (itt_addr_field << 5) |
>>>
>>> So this gives you 19 bits for next_offset, but the value of
>>> VITS_DTE_MAX_DEVID_OFFSET suggests 20 bits. It should become more
>>> obvious what's happening here if use "BITS(x) - 1" at the definition as
>>> suggested before.
>> Yes this should be 19 bits
>>>
>>> Also you limit itt_addr here to 40 bits, where the actual limit seems to
>>> be 44 bits (52 - 8). Is that limited by KVM somewhere else?
>>
>> Those 40 bits match [47:8] of the itt_addr. I limited to 48 since I
>> found a comment saying
>> /*
>>  * We only implement 48 bits of PA at the moment, although the ITS
>>  * supports more. Let's be restrictive here.
>>  */
>>
>>
>> On the other hand there is
>> #define its_cmd_get_ittaddr(cmd) its_cmd_mask_field(cmd, 2,  8, 44)
>> To me this is wrong. I would have expected its_cmd_mask_field(cmd, 2,
>> 8, 47) instead as the other *_ADDRESS()
> Forget that. That's my own code which is wrong!

Ah, that would explain why I was just struggling to find it ;-)
Please note that the last parameters is a "size", which really means
"number of bits". That's different from GENMASK, which takes the last
valid bit.
Also there is "slight glitch" in the spec here:
The bit *diagram* for MAPD puts the last valid ITT address bit at 50,
but the text clearly speaks or [51:8], which also makes more sense.

Cheers,
Andre.
