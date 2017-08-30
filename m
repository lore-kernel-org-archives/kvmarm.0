From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 44/59] KVM: arm/arm64: GICv4: Handle MOVI applied to a
 VLPI
Date: Wed, 30 Aug 2017 15:08:01 +0100
Message-ID: <954a7441-c91e-5d1b-98b7-2978291c5259@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-45-marc.zyngier@arm.com> <20170828181817.GE24649@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170828181817.GE24649@cbox>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 28/08/17 19:18, Christoffer Dall wrote:
> On Mon, Jul 31, 2017 at 06:26:22PM +0100, Marc Zyngier wrote:
>> When the guest issues a MOVI, we need to tell the physical ITS
>> that we're now targetting a new vcpu. This is done by extracting
>> the current mapping, updating the target, and reapplying the
>> mapping. The core ITS code should do the right thing.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 79bac93d3e7d..aaad577ce328 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -706,6 +706,19 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
>>  	ite->irq->target_vcpu = vcpu;
>>  	spin_unlock(&ite->irq->irq_lock);
>>  
>> +	if (ite->irq->hw) {
>> +		struct its_vlpi_map map;
>> +		int ret;
>> +
>> +		ret = its_get_vlpi(ite->irq->host_irq, &map);
>> +		if (ret)
>> +			return ret;
>> +
>> +		map.vpe_idx = vcpu->vcpu_id;
>> +
>> +		return its_map_vlpi(ite->irq->host_irq, &map);
> 
> Since you're not holding the irq_lock across these two calls, would it
> be possible that the forwarding was removed through some other call path
> here, and could you end up passing an invalid host_irq to its_map_vlpi?
I believe we should be OK here, as we hold the ITS mutex during any
command processing, and both the forward/unforward paths take that same
mutex.

On a slightly different note, it looks like the MOVI code could benefit
from using vgic_its_resolve_lpi(), which has been introduce earlier in
this series.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
