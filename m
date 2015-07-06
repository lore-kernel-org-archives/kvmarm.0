From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
Date: Mon, 06 Jul 2015 19:02:30 +0200
Message-ID: <559AB4A6.8050803@linaro.org>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org> <1435592237-17924-2-git-send-email-eric.auger@linaro.org> <011f01d0b498$6a17aeb0$3e470c10$@samsung.com> <5596503E.6040902@arm.com> <00fd01d0b7b6$f6cf3550$e46d9ff0$@samsung.com> <559A3C9C.6050302@arm.com> <20150706093026.GA11590@cbox> <559A52E6.5050402@arm.com> <20150706103755.GC11590@cbox> <559A6164.1000401@redhat.com> <559A6527.1040107@arm.com> <559A6BBC.2040901@redhat.com> <024301d0b7f0$2b13b410$813b1c30$@samsung.com> <559A9854.2090607@linaro.org> <559AA449.80705@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <559AA449.80705@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Pavel Fedin <p.fedin@samsung.com>, 'Paolo Bonzini' <pbonzini@redhat.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 07/06/2015 05:52 PM, Andre Przywara wrote:
> Salut Eric,
> 
> ....
> 
>>>  ITS code in qemu just does:
>>>
>>> ---cut ---
>>>     msi_supported = true;
>>>     kvm_msi_flags = KVM_MSI_VALID_DEVID;
>>>     kvm_msi_via_irqfd_allowed = kvm_has_gsi_routing();
>>>     kvm_gsi_routing_allowed = kvm_msi_via_irqfd_allowed;
>>> --- cut ---
>>>
>>>  I set KVM_MSI_VALID_DEVID unconditionally here just because it will never be checked if
>>> kvm_msi_via_irqfd_allowed is false, it's just qemu specifics. The more canonical form would perhaps
>>> be:
>>> --- cut ---
>>> if (kvm_has_gsi_routing()) {
>>>     kvm_msi_flags = KVM_MSI_VALID_DEVID;
>> Personally I prefer a capability rather than hardcoding a global
>> variable value in the qemu interrupt controller code. All the more so
>> typically there is KVM GSI routing cap that could/should? be queried
>> instead of hardcoding the value I think.
>>
>> So not sure whether we eventually concluded;-)
>> - introduce a KVM_CAP_MSI_DEVID capability? All OK except Pavel not
>> convinced?
> 
> OK for me.
> 
>> - userspaces puts the devid in struct kvm_irq_routing_msi pad field:
>> consensus (we do not intrduce a new kvm_irq_routing_ext_msi)
> 
> OK for me.
> 
>> - userspace tells it conveyed a devid by setting
>> A) the kvm_irq_routing_entry's field?
> 
> You mean kvm_irq_routing_entry's "flags" here?
yes!!
> 
>> B) the kvm_irq_routing_entry's type
> 
> So personally I don't like it so much to use the generic flags field to
> specify the meaning within one particular type only. Using a new type
> instead seems to be more consistent, reusing an existing struct for that
> sounds even better.
> As written before (and coded in my branch) we can collapse that into the
> existing MSI type while translating that into the kernel internal
> routing structure to make the kernel code changes minimal.
> 
>> no consensus. If there is a cap, does it really matter?
> 
> I guess not. But I prefer the new type anyway, as it also has a known
> error path for older kernels.
I am fine with the new type too.

Eric
> 
> Cheers,
> Andre.
> 
