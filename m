From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 17/25] KVM: arm64: Enable GICv3 Group-0 sysreg trapping
 via command-line
Date: Tue, 6 Jun 2017 16:15:45 +0100
Message-ID: <d8beffbd-f353-7019-daaf-0a53f1310065@arm.com>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-18-marc.zyngier@arm.com> <20170606124436.GP9464@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170606124436.GP9464@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/06/17 13:44, Christoffer Dall wrote:
> On Thu, Jun 01, 2017 at 11:21:09AM +0100, Marc Zyngier wrote:
>> Now that we're able to safely handle Group-0 sysreg access, let's
>> give the user the opportunity to enable it by passing a specific
>> command-line option (vgic_v3.group0_trap).
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-v3.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>> index 7525216ef988..1486ce25edcb 100644
>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>> @@ -419,6 +419,12 @@ int vgic_v3_map_resources(struct kvm *kvm)
>>  
>>  DEFINE_STATIC_KEY_FALSE(vgic_v3_cpuif_trap);
>>  
>> +static int __init early_group0_trap_cfg(char *buf)
>> +{
>> +	return strtobool(buf, &group0_trap);
>> +}
>> +early_param("vgic_v3.group0_trap", early_group0_trap_cfg);
>> +
> 
> same comment as before, if this should be called something with KVM.
> 
> Also, btw., what's the policy on adding new kernel parameters?  Should
> they be documented in kernel-parameters.txt or is that auto-generated
> these days?

I guess I should add something indeed.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
