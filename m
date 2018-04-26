From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v3 08/12] KVM: arm/arm64: Check vcpu redist base before
 registering an iodev
Date: Thu, 26 Apr 2018 11:25:06 +0200
Message-ID: <73b8e64b-3c14-b937-487a-78f3cc73fde5@redhat.com>
References: <1523607658-9166-1-git-send-email-eric.auger@redhat.com>
 <1523607658-9166-9-git-send-email-eric.auger@redhat.com>
 <20180424210759.GI4533@C02W217FHV2R.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180424210759.GI4533@C02W217FHV2R.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org, andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 04/24/2018 11:07 PM, Christoffer Dall wrote:
> On Fri, Apr 13, 2018 at 10:20:54AM +0200, Eric Auger wrote:
>> As we are going to register several redist regions,
>> vgic_register_all_redist_iodevs() may be called several times. We need
>> to register a redist_iodev for a given vcpu only once. 
> 
> Wouldn't it be more natural to change that caller to only register the
> iodevs for that region?

vgic_register_redist_iodev() is the place where we decide where we map a
given vcpu redist into a given redist region.

Calling vgic_register_redist_iodev for only the vcpus mapping to the
redist region would force to inverse the logic. I think it would bring
more upheavals in the code than bringing benefit?

This new check somehow corresponds to what we had before:
"
if (IS_VGIC_ADDR_UNDEF(vgic->vgic_redist_base))
                return 0;
"

Thanks

Eric
> 
> Thanks,
> -Christoffer
> 
>> So let's
>> check if the base address has already been set. Initialize this latter
>> in kvm_vgic_vcpu_early_init().
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-init.c    | 3 +++
>>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 3 +++
>>  2 files changed, 6 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
>> index 6456371..7e040e7 100644
>> --- a/virt/kvm/arm/vgic/vgic-init.c
>> +++ b/virt/kvm/arm/vgic/vgic-init.c
>> @@ -82,6 +82,9 @@ void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu)
>>  	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
>>  	spin_lock_init(&vgic_cpu->ap_list_lock);
>>  
>> +	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
>> +	vgic_cpu->sgi_iodev.base_addr = VGIC_ADDR_UNDEF;
>> +
>>  	/*
>>  	 * Enable and configure all SGIs to be edge-triggered and
>>  	 * configure all PPIs as level-triggered.
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index 5273fb8..df23e66 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -592,6 +592,9 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
>>  	gpa_t rd_base, sgi_base;
>>  	int ret;
>>  
>> +	if (!IS_VGIC_ADDR_UNDEF(vgic_cpu->rd_iodev.base_addr))
>> +		return 0;
>> +
>>  	/*
>>  	 * We may be creating VCPUs before having set the base address for the
>>  	 * redistributor region, in which case we will come back to this
>> -- 
>> 2.5.5
>>
> 
