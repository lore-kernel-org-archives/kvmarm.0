From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v6 08/24] KVM: arm64: vgic-its: Implement
 vgic_mmio_uaccess_write_its_creadr
Date: Thu, 4 May 2017 17:09:52 +0200
Message-ID: <ae1f4231-7b5d-cc69-bbf6-49e637e8d37c@redhat.com>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
 <1493898284-29504-9-git-send-email-eric.auger@redhat.com>
 <a58918e7-4e21-7783-28d2-c116e2b7a1e1@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 976CF40969
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 11:06:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h12eXbis2GMG for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 May 2017 11:06:52 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93CE1405DA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 11:06:52 -0400 (EDT)
In-Reply-To: <a58918e7-4e21-7783-28d2-c116e2b7a1e1@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, eric.auger.pro@gmail.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, bjsprakash.linux@gmail.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 04/05/2017 16:16, Marc Zyngier wrote:
> On 04/05/17 12:44, Eric Auger wrote:
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
> 
> nit: In general, and for alignments that aren't completely obvious, you
> can write something like IS_ALIGNED(cmd_offset, sizeof(struct its_cmd)).
> 
> Unfortunately, we don't have a struct its_cmd, and maybe we should fix
> that at a later time.
OK
> 
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	its->creadr = val;
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
>>
> 
> Otherwise:
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Thanks!

Eric
> 
> Thanks,
> 
> 	M.
> 
