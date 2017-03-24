From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v3 06/19] KVM: arm64: ITS: Implement
 vgic_mmio_uaccess_write_its_creadr
Date: Fri, 24 Mar 2017 11:38:33 +0100
Message-ID: <4057e9b7-db65-f1da-4213-6ebee8659b63@redhat.com>
References: <1488800074-21991-1-git-send-email-eric.auger@redhat.com>
 <1488800074-21991-7-git-send-email-eric.auger@redhat.com>
 <f5e4781d-3d13-e956-1056-2339a2fb2247@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85B6D40BBC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 06:36:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LsT3nT0PwmZh for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Mar 2017 06:36:51 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4ABA5405DA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Mar 2017 06:36:51 -0400 (EDT)
In-Reply-To: <f5e4781d-3d13-e956-1056-2339a2fb2247@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On 20/03/2017 19:14, Andre Przywara wrote:
> Hi Eric,
> 
> On 06/03/17 11:34, Eric Auger wrote:
>> GITS_CREADR needs to be restored so let's implement the associated
>> uaccess_write_its callback.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> Can you please rebase this (whole series) on the latest kernel? My patch
> to fix command processing with the ITS being disabled got merged just a
> few patches after -rc1. This will conflict here, but looks like a
> requirement anyway.
OK done
> 
>>
>> ---
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 22 +++++++++++++++++++++-
>>  1 file changed, 21 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index e9c8f9f..6120c6e 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -1225,6 +1225,25 @@ static unsigned long vgic_mmio_read_its_creadr(struct kvm *kvm,
>>  	return extract_bytes(its->creadr, addr & 0x7, len);
>>  }
>>  
>> +static void vgic_mmio_uaccess_write_its_creadr(struct kvm *kvm,
>> +					       struct vgic_its *its,
>> +					       gpa_t addr, unsigned int len,
>> +					       unsigned long val)
>> +{
>> +	u32 reg;
>> +
>> +	mutex_lock(&its->cmd_lock);
>> +	reg = update_64bit_reg(its->creadr, addr & 7, len, val);
>> +	reg = ITS_CMD_OFFSET(reg);
>> +	if (reg >= ITS_CMD_BUFFER_SIZE(its->cbaser)) {
>> +		mutex_unlock(&its->cmd_lock);
>> +		return;
>> +	}
> 
> So do we need to specify some register order here? I think since CREADR
> is RO in the spec this isn't covered there, but I see issues here otherwise:
> - If we write CREADR while the ITS is enabled, this will probably
> confuse the state machine, since only the ITS (emulation engine) is
> supposed to change CREADR. So we should forbid setting CREADR in this
> case (easily doable with the fix mentioned above).
Added a check for this
> - CBASER resets both CREADR (as said in the spec) and CWRITER (our
> implementation choice), so it should be restored before any of those get
> restored. I think that should be mentioned in arm-vgic-its.txt.
Added this in the documentation

Thanks

Eric
> 
> Cheers,
> Andre.
> 
>> +
>> +	its->creadr = reg;
>> +	mutex_unlock(&its->cmd_lock);
>> +}
>> +
>>  #define BASER_INDEX(addr) (((addr) / sizeof(u64)) & 0x7)
>>  static unsigned long vgic_mmio_read_its_baser(struct kvm *kvm,
>>  					      struct vgic_its *its,
>> @@ -1320,7 +1339,8 @@ static struct vgic_register_region its_registers[] = {
>>  		vgic_mmio_read_its_cwriter, vgic_mmio_write_its_cwriter, NULL,
>>  		8, VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>>  	REGISTER_ITS_DESC(GITS_CREADR,
>> -		vgic_mmio_read_its_creadr, its_mmio_write_wi, NULL, 8,
>> +		vgic_mmio_read_its_creadr, its_mmio_write_wi,
>> +		vgic_mmio_uaccess_write_its_creadr, 8,
>>  		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>>  	REGISTER_ITS_DESC(GITS_BASER,
>>  		vgic_mmio_read_its_baser, vgic_mmio_write_its_baser, NULL, 0x40,
>>
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
