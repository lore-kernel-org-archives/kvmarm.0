From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 18/22] KVM: arm64: ITS: Collection table save/restore
Date: Tue, 11 Apr 2017 11:03:40 +0100
Message-ID: <02981ae1-5138-45fa-b1be-6fc96194d0d7@arm.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
 <1490607072-21610-19-git-send-email-eric.auger@redhat.com>
 <95a88e33-3cbc-9c4d-b76c-3cec5c4cc310@arm.com>
 <3d5f7230-e55b-44b8-bc37-021d1784ee0e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C7EC40C27
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Apr 2017 06:01:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SzNl4xcgXVQq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Apr 2017 06:01:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3263040C17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Apr 2017 06:01:20 -0400 (EDT)
In-Reply-To: <3d5f7230-e55b-44b8-bc37-021d1784ee0e@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, eric.auger.pro@gmail.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 11/04/17 10:57, Auger Eric wrote:
> Hi Marc,
> 
> On 10/04/2017 11:55, Marc Zyngier wrote:
>> On 27/03/17 10:31, Eric Auger wrote:
>>> The flush path copies the collection entries into guest RAM
>>> at the GPA specified in the BASER register. This obviously
>>> requires the BASER to be set. The last written element
>>> is a dummy collection table entry.
>>>
>>> We do not index by collection ID as the collection entry
>>> can fit into 8 bytes while containing the collection ID.
>>>
>>> On restore path we re-allocate the collection objects.
>>>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>
>>> ---
>>>
>>> v3 -> v4:
>>> - replaced u64 *ptr by gpa_t gpa
>>> - check the collection does not exist before allocating it
>>>
>>> v1 -> v2:
>>> - reword commit message and directly use 8 as entry size
>>> - no kvm parameter anymore
>>> - add helper for flush/restore cte
>>> - table size computed here
>>> - add le64/cpu conversions
>>> ---
>>>  virt/kvm/arm/vgic/vgic-its.c | 99 +++++++++++++++++++++++++++++++++++++++++++-
>>>  1 file changed, 97 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>> index 8eaeba4..df984b6 100644
>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>> @@ -1828,13 +1828,89 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
>>>  	return -ENXIO;
>>>  }
>>>  
>>> +static int vgic_its_flush_cte(struct vgic_its *its,
>>> +			      struct its_collection *collection, gpa_t gpa)
>>
>> Given that the pendent of this function is name ..._restore_..., should
>> this be called ..._save_... ?
>>
>>> +{
>>> +	u64 val;
>>> +	int ret;
>>> +
>>> +	val = ((u64)1 << 63 | ((u64)collection->target_addr << 16) |
>>> +	       collection->collection_id);
>>
>> Please provide some #defines that describe the encoding. This will be
>> specially useful if we need to export this to userspace (KVM/TCG
>> interoperability?).
>>
>>> +	val = cpu_to_le64(val);
>>> +	ret = kvm_write_guest(its->dev->kvm, gpa, &val, 8);
>>> +	return ret;
>>> +}
>>> +
>>> +static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, bool *valid)
>>> +{
>>> +	struct its_collection *collection;
>>> +	u32 target_addr;
>>> +	u32 coll_id;
>>> +	u64 val;
>>> +	int ret;
>>> +
>>> +	*valid = false;
>>> +
>>> +	ret = kvm_read_guest(its->dev->kvm, gpa, &val, 8);
>>> +	if (ret)
>>> +		return ret;
>>> +	val = le64_to_cpu(val);
>>> +	*valid = val & BIT_ULL(63);
>>> +
>>> +	if (!*valid)
>>> +		return 0;
>>> +
>>> +	target_addr = (u32)(val >> 16);
>>
>> u32?
> At the moment its_collection.target_addr is u32 and corresponds to the
> PE number. Only GITS_TYPER.PTA = 0 is supported.
> 
> Or do I miss something?

No, you're right. I'm getting confused between the model I'm working
with and the ITS emulation... Ignore me.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
