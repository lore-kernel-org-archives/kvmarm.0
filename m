From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 12/22] KVM: arm64: vgic-its: Interpret MAPD ITT_addr
 field
Date: Thu, 27 Apr 2017 19:44:25 +0200
Message-ID: <5f187dbf-6167-7bd3-4a8e-37545941d05c@redhat.com>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-13-git-send-email-eric.auger@redhat.com>
 <20170427164356.GP50776@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170427164356.GP50776@lvm>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: peter.maydell@linaro.org, drjones@redhat.com, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 27/04/2017 18:43, Christoffer Dall wrote:
> On Fri, Apr 14, 2017 at 12:15:24PM +0200, Eric Auger wrote:
>> Up to now the MAPD ITT_addr had been ignored. We will need it
>> for save/restore. Let's record it in the its_device struct.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v4 -> v5:
>> - its_cmd_get_ittaddr macro now returns the actual ITT GPA
>>
>> v3 -> v4:
>> - in vgic_its_cmd_handle_mapd, itt_addr directly is shifted
>> - correct ittaddr bitmask to support 48bit GPA
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 0f3c8f3..757598d 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -106,6 +106,7 @@ struct its_device {
>>  	/* the head for the list of ITTEs */
>>  	struct list_head itt_head;
>>  	u32 nb_eventid_bits;
>> +	gpa_t itt_addr;
>>  	u32 device_id;
>>  };
>>  
>> @@ -569,6 +570,7 @@ static u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size)
>>  #define its_cmd_get_id(cmd)		its_cmd_mask_field(cmd, 1,  0, 32)
>>  #define its_cmd_get_physical_id(cmd)	its_cmd_mask_field(cmd, 1, 32, 32)
>>  #define its_cmd_get_collection(cmd)	its_cmd_mask_field(cmd, 2,  0, 16)
>> +#define its_cmd_get_ittaddr(cmd)	(its_cmd_mask_field(cmd, 2,  8, 47) << 8)
> 
> Why 47?  The ITT_addr field is bits [51:8] unless I'm looking at
> something wrong?

Initially I limited to 48 bits since I found in the code:

/*
 * We only implement 48 bits of PA at the moment, although the ITS
 * supports more. Let's be restrictive here.
 */
#define BASER_ADDRESS(x)        ((x) & GENMASK_ULL(47, 16))
#define CBASER_ADDRESS(x)       ((x) & GENMASK_ULL(47, 12))

But practically as I encode the ITT addr field on 52 bits now in the DTE
there is no reason anymore.

Thanks

Eric
> 
>>  #define its_cmd_get_target_addr(cmd)	its_cmd_mask_field(cmd, 2, 16, 32)
>>  #define its_cmd_get_validbit(cmd)	its_cmd_mask_field(cmd, 2, 63,  1)
>>  
>> @@ -840,6 +842,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
>>  	u32 device_id = its_cmd_get_deviceid(its_cmd);
>>  	bool valid = its_cmd_get_validbit(its_cmd);
>>  	u8 nb_eventid_bits = its_cmd_get_size(its_cmd);
>> +	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
>>  	struct its_device *device;
>>  
>>  	if (!vgic_its_check_id(its, its->baser_device_table, device_id))
>> @@ -871,6 +874,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
>>  
>>  	device->device_id = device_id;
>>  	device->nb_eventid_bits = nb_eventid_bits;
>> +	device->itt_addr = itt_addr;
>>  
>>  	INIT_LIST_HEAD(&device->itt_head);
>>  
>> -- 
>> 2.5.5
>>
> 
> Thanks,
> -Christoffer
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
