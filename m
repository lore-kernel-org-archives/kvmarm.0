From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v6 08/24] KVM: arm64: vgic-its: Implement
 vgic_mmio_uaccess_write_its_creadr
Date: Fri, 5 May 2017 10:06:42 +0200
Message-ID: <9e813cc0-1655-3b07-baaf-c348c7fc17f6@redhat.com>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
 <1493898284-29504-9-git-send-email-eric.auger@redhat.com>
 <20170504170939.GS5923@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170504170939.GS5923@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: peter.maydell@linaro.org, drjones@redhat.com, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 04/05/2017 19:09, Christoffer Dall wrote:
> On Thu, May 04, 2017 at 01:44:28PM +0200, Eric Auger wrote:
>> GITS_CREADR needs to be restored so let's implement the associated
>> uaccess_write_its callback. The write only is allowed if the its
>> is disabled.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v5 -> v6:
>> - remove usage of update_64bit_reg and check alignment of cmd offset
>>
>> v4 -> v5:
>> - keep Stalled bit
>> - vgic_mmio_uaccess_write_its_creadr can now return an error
>>
>> v3 -> v4:
>> - REGISTER_ITS_DESC_UACCESS now introduced in this patch
>> - we now check the its is disabled
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 43 +++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 41 insertions(+), 2 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 222fad5..18588ef 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -1213,6 +1213,34 @@ static unsigned long vgic_mmio_read_its_creadr(struct kvm *kvm,
>>  	return extract_bytes(its->creadr, addr & 0x7, len);
>>  }
>>  
>> +static int vgic_mmio_uaccess_write_its_creadr(struct kvm *kvm,
>> +					      struct vgic_its *its,
>> +					      gpa_t addr, unsigned int len,
>> +					      unsigned long val)
>> +{
>> +	u32 cmd_offset;
>> +	int ret = 0;
>> +
>> +	mutex_lock(&its->cmd_lock);
>> +
>> +	if (its->enabled) {
>> +		ret = -EBUSY;
>> +		goto out;
>> +	}
>> +
>> +	cmd_offset = ITS_CMD_OFFSET(val);
>> +	if ((cmd_offset >= ITS_CMD_BUFFER_SIZE(its->cbaser)) ||
>> +	    (cmd_offset & 0x1F)) {
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	its->creadr = val;
> 
> do we let userspace decide the stalled bit or should we use
> ITS_CMD_OFFSET() when assigning the field as well?
yes better to use cmd_offset.

Also the alignment check eventually can be removed as cmd_offset is
[19:5] of the offset and bits [4:0] are 0

Thanks

Eric
> 
>> +out:
>> +	mutex_unlock(&its->cmd_lock);
>> +	return ret;
>> +}
>> +
>>  #define BASER_INDEX(addr) (((addr) / sizeof(u64)) & 0x7)
>>  static unsigned long vgic_mmio_read_its_baser(struct kvm *kvm,
>>  					      struct vgic_its *its,
>> @@ -1317,6 +1345,16 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
>>  	.its_write = wr,					\
>>  }
>>  
>> +#define REGISTER_ITS_DESC_UACCESS(off, rd, wr, uwr, length, acc)\
>> +{								\
>> +	.reg_offset = off,					\
>> +	.len = length,						\
>> +	.access_flags = acc,					\
>> +	.its_read = rd,						\
>> +	.its_write = wr,					\
>> +	.uaccess_its_write = uwr,				\
>> +}
>> +
>>  static void its_mmio_write_wi(struct kvm *kvm, struct vgic_its *its,
>>  			      gpa_t addr, unsigned int len, unsigned long val)
>>  {
>> @@ -1339,8 +1377,9 @@ static struct vgic_register_region its_registers[] = {
>>  	REGISTER_ITS_DESC(GITS_CWRITER,
>>  		vgic_mmio_read_its_cwriter, vgic_mmio_write_its_cwriter, 8,
>>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>> -	REGISTER_ITS_DESC(GITS_CREADR,
>> -		vgic_mmio_read_its_creadr, its_mmio_write_wi, 8,
>> +	REGISTER_ITS_DESC_UACCESS(GITS_CREADR,
>> +		vgic_mmio_read_its_creadr, its_mmio_write_wi,
>> +		vgic_mmio_uaccess_write_its_creadr, 8,
>>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>>  	REGISTER_ITS_DESC(GITS_BASER,
>>  		vgic_mmio_read_its_baser, vgic_mmio_write_its_baser, 0x40,
>> -- 
>> 2.5.5
>>
> 
> Otherwise:
> 
> Reviewed-by: Christoffer Dall <cdall@linaro.org>
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
