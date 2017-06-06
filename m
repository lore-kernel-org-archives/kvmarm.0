From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 12/25] KVM: arm64: Enable GICv3 Group-1 sysreg trapping
 via command-line
Date: Tue, 6 Jun 2017 14:59:34 +0100
Message-ID: <10aef5e3-706d-2e7b-17d2-0c3eb46095aa@arm.com>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-13-marc.zyngier@arm.com> <20170606120656.GN9464@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170606120656.GN9464@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/06/17 13:06, Christoffer Dall wrote:
> On Thu, Jun 01, 2017 at 11:21:04AM +0100, Marc Zyngier wrote:
>> Now that we're able to safely handle Group-1 sysreg access, let's
>> give the user the opportunity to enable it by passing a specific
>> command-line option (vgic_v3.group1_trap).
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  virt/kvm/arm/hyp/vgic-v3-sr.c |  6 +++++-
>>  virt/kvm/arm/vgic/vgic-v3.c   | 11 +++++++++++
>>  2 files changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
>> index 8973bad35748..42ac9ee7650a 100644
>> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
>> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
>> @@ -334,7 +334,11 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
>>  		for (i = 0; i < used_lrs; i++)
>>  			__gic_v3_set_lr(cpu_if->vgic_lr[i], i);
>>  	} else {
>> -		/* Always write ICH_HCR_EL2 to enable trapping */
>> +		/*
>> +                 * If we don't have any interrupt to inject, but that
>> +		 * trapping is enabled, write the ICH_HCR_EL2 config
>> +		 * anyway.
>> +		 */
> 
> nit: Whitespace and grammar issues, and maybe this hunk was supposed to
> be in the last patch?

Indeed, on both counts.

> 
>>  		if (static_branch_unlikely(&vgic_v3_cpuif_trap))
>>  			write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
>>  	}
>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>> index fbd678bc046d..a16769276efd 100644
>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>> @@ -416,6 +416,12 @@ int vgic_v3_map_resources(struct kvm *kvm)
>>  
>>  DEFINE_STATIC_KEY_FALSE(vgic_v3_cpuif_trap);
>>  
>> +static int __init early_group1_trap_cfg(char *buf)
>> +{
>> +	return strtobool(buf, &group1_trap);
>> +}
>> +early_param("vgic_v3.group1_trap", early_group1_trap_cfg);
>> +
> 
> this shouldn't be named something with KVM (we're not going to trap
> anything on the host somehow are we?)?

Good point. kvm_vgic_v3.whatever?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
