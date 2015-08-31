From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v2 05/15] KVM: arm/arm64: make GIC frame address initialization
 model specific
Date: Mon, 31 Aug 2015 11:31:37 +0200
Message-ID: <55E41EF9.6020901@linaro.org>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com> <1436538111-4294-6-git-send-email-andre.przywara@arm.com> <55CB43FB.4070400@linaro.org> <55DB534C.8040207@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55DB534C.8040207@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Pavel Fedin <p.fedin@samsung.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/24/2015 07:24 PM, Andre Przywara wrote:
> Hi,
> 
> On 12/08/15 14:02, Eric Auger wrote:
>> On 07/10/2015 04:21 PM, Andre Przywara wrote:
>>> Currently we initialize all the possible GIC frame addresses in one
>>> function, without looking at the specific GIC model we instantiate
>>> for the guest.
>>> As this gets confusing when adding another VGIC model later, lets
>>> move these initializations into the respective model's init 
>> nit: tobe more precise the init emulation function (not the
>> vgic_v2/v3_init_model model's init function). pfouh?! ;-)
>> functions.
> 
> OK, will try to find a wording that is not completely confusing.
> 
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>>  virt/kvm/arm/vgic-v2-emul.c | 3 +++
>>>  virt/kvm/arm/vgic-v3-emul.c | 3 +++
>>>  virt/kvm/arm/vgic.c         | 3 ---
>>>  3 files changed, 6 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
>>> index 1390797..8faa28c 100644
>>> --- a/virt/kvm/arm/vgic-v2-emul.c
>>> +++ b/virt/kvm/arm/vgic-v2-emul.c
>>> @@ -567,6 +567,9 @@ void vgic_v2_init_emulation(struct kvm *kvm)
>>>  	dist->vm_ops.init_model = vgic_v2_init_model;
>>>  	dist->vm_ops.map_resources = vgic_v2_map_resources;
>>>  
>>> +	dist->vgic_cpu_base = VGIC_ADDR_UNDEF;
>>> +	dist->vgic_dist_base = VGIC_ADDR_UNDEF;
>> Looks strange to see the common dist_base here. Why don't you leave it
>> in common part, kvm_vgic_create; all the more so you left
>> kvm->arch.vgic.vctrl_base = vgic->vctrl_base in kvm_vgic_create.
> 
> The idea behind this is that dist_base refers to similar, but not
> identical distributors (v2 vs. v3), so I found it a good idea to
> initialize it in here. Also vctrl_base is host facing and not set by
> userland, so this doesn't really compare here.
ok

Eric
> 
> Cheers,
> Andre.
> 
>>> +
>>>  	kvm->arch.max_vcpus = VGIC_V2_MAX_CPUS;
>>>  }
>>>  
>>> diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
>>> index d2eeb20..1f42348 100644
>>> --- a/virt/kvm/arm/vgic-v3-emul.c
>>> +++ b/virt/kvm/arm/vgic-v3-emul.c
>>> @@ -885,6 +885,9 @@ void vgic_v3_init_emulation(struct kvm *kvm)
>>>  	dist->vm_ops.destroy_model = vgic_v3_destroy_model;
>>>  	dist->vm_ops.map_resources = vgic_v3_map_resources;
>>>  
>>> +	dist->vgic_dist_base = VGIC_ADDR_UNDEF;
>>> +	dist->vgic_redist_base = VGIC_ADDR_UNDEF;
>>> +
>>>  	kvm->arch.max_vcpus = KVM_MAX_VCPUS;
>>>  }
>>>  
>>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
>>> index cc8f5ed..59f1801 100644
>>> --- a/virt/kvm/arm/vgic.c
>>> +++ b/virt/kvm/arm/vgic.c
>>> @@ -1830,9 +1830,6 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>>>  	kvm->arch.vgic.in_kernel = true;
>>>  	kvm->arch.vgic.vgic_model = type;
>>>  	kvm->arch.vgic.vctrl_base = vgic->vctrl_base;
>>> -	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
>>> -	kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
>>> -	kvm->arch.vgic.vgic_redist_base = VGIC_ADDR_UNDEF;
>>>  
>>>  out_unlock:
>>>  	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
>>>
>>

