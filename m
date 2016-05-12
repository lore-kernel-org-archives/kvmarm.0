From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 35/55] KVM: arm/arm64: vgic-new: Add GICv3 IDREGS
 register handler
Date: Thu, 12 May 2016 13:37:10 +0100
Message-ID: <573478F6.5070103@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-36-git-send-email-andre.przywara@arm.com>
 <20160512121226.GF27623@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AB0449B2C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 08:33:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E13tLHD2-qop for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 May 2016 08:33:40 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4AC3412ED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 08:33:40 -0400 (EDT)
In-Reply-To: <20160512121226.GF27623@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 12/05/16 13:12, Christoffer Dall wrote:
> On Fri, May 06, 2016 at 11:45:48AM +0100, Andre Przywara wrote:
>> We implement the only one ID register that is required by the
>> architecture, also this is the one that Linux actually checks.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>> Changelog v1 .. v2:
>> - adapt to new MMIO framework
>>
>>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 20 ++++++++++++++++++--
>>  1 file changed, 18 insertions(+), 2 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index d137242..48fba9c 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -110,6 +110,22 @@ static unsigned long vgic_mmio_read_v3r_iidr(struct kvm_vcpu *vcpu,
>>  	return extract_bytes(value, addr & 3, len);
>>  }
>>  
>> +static unsigned long vgic_mmio_read_v3_idregs(struct kvm_vcpu *vcpu,
>> +					      gpa_t addr, unsigned int len)
>> +{
>> +	u32 regnr = (addr & 0x3f) - (GICD_IDREGS & 0x3f);
> 
> this regnr thing is confusing, because it's not an index, it's an
> address offset.
> 
> why can't you do:
> 
> 	switch (addr & 0xffff) {
> 	case GICD_PIDR2:
> 	}

Makes sense. This was a leftover from the time I had subtraction instead
of masking for the IRQ number determination.
Will fix it.

Thanks,
Andre.
