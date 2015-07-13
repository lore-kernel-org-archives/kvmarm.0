From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Extensions for KVM MSI related ioctls
Date: Mon, 13 Jul 2015 14:35:28 +0200
Message-ID: <55A3B090.6090002@redhat.com>
References: <55A39231.4050904@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55A39231.4050904@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@linaro.org>, Pavel Fedin <p.fedin@samsung.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Gleb Natapov <gleb@kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>, Marcelo Tosatti <mtosatti@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 13/07/2015 12:25, Andre Przywara wrote:
> 
> For using MSIs in a guest when running on an ARM(64) system using a
> GICv3 interrupt controller we need to have a device ID available. On
> real hardware this information is sampled from the bus by the ITS part
> of the interrupt controller.
> To make this work for guests, we need to extend two ioctls which deal
> with MSIs: KVM_SIGNAL_MSI and KVM_SET_GSI_ROUTING.
> 
> The idea that we sketched so far in [1] and [2] is to use a new
> capability (KVM_CAP_MSI_DEVID) to advertise both a flag bit for
> KVM_SIGNAL_MSI and a new type for KVM_SET_GSI_ROUTING.
> 
> Since current kernels bail out on any flag value != 0 in KVM_SIGNAL_MSI,
> we need the new capability to tell userland about it in a reliable and
> portable way (to avoid hacks like #ifdef ARM && USES_IRQ_ROUTING in
> userland).
> 
> For KVM_SET_GSI_ROUTING there was the idea of using the very same flag
> value in it's own flag field, but I find it saner to use a new routing
> type instead (KVM_IRQ_ROUTING_EXTENDED_MSI). Both approaches would
> piggy-back on the existing struct kvm_irq_routing_msi and re-purpose the
> pad field in there.

I think I prefer the flag.  Offhand it sounds easier to add support for
it to non-ARM architectures, compared to KVM_IRQ_ROUTING_EXTENDED_MSI.

> Summarized:
> 1) Add a new KVM_CAP_MSI_DEVID to advertise the device ID extension.
> 2) Use a KVM_MSI_VALID_DEVID flag in KVM_SIGNAL_MSI to re-purpose part
>    of struct kvm_msi.

These two sounds good.

Paolo

> 3) Add a new routing type KVM_IRQ_ROUTING_EXTENDED_MSI for
>    KVM_SET_GSI_ROUTING to add device IDs in struct kvm_irq_routing_msi.
> 
> Is that a sensible way to extend the KVM API?
