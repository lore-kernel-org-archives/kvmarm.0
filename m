From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 1/7] KVM: api: introduce KVM_IRQ_ROUTING_EXTENDED_MSI
Date: Fri, 10 Jul 2015 23:42:58 +0100
Message-ID: <55A04A72.4010205@arm.com>
References: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
 <1436430137-24205-2-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BCFE58508
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 18:35:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U5pgQ+kNqj8k for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2015 18:35:09 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 274C858480
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 18:35:08 -0400 (EDT)
In-Reply-To: <1436430137-24205-2-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 09/07/15 09:22, Eric Auger wrote:
> On ARM, the MSI msg (address and data) comes along with
> out-of-band device ID information. The device ID encodes the
> device that writes the MSI msg. Let's convey the device id in
> kvm_irq_routing_msi and use a new routing entry type to
> indicate the devid is populated.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Just some forward looking statement: If this gets based on top of my ITS
emulation v2 series, the documentation should state that the new
KVM_CAP_MSI_DEVID capability tells userland about the need to provide
the device ID.

Cheers,
Andre.

> 
> ---
> 
> v1 -> v2:
> - devid id passed in kvm_irq_routing_msi instead of in
>   kvm_irq_routing_entry
> 
> RFC -> PATCH
> - remove kvm_irq_routing_extended_msi and use union instead
> ---
>  Documentation/virtual/kvm/api.txt | 10 +++++++++-
>  include/uapi/linux/kvm.h          |  6 +++++-
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index bea8de7..3d920cd 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -1453,6 +1453,7 @@ struct kvm_irq_routing_entry {
>  #define KVM_IRQ_ROUTING_IRQCHIP 1
>  #define KVM_IRQ_ROUTING_MSI 2
>  #define KVM_IRQ_ROUTING_S390_ADAPTER 3
> +#define KVM_IRQ_ROUTING_EXTENDED_MSI 4
>  
>  No flags are specified so far, the corresponding field must be set to zero.
>  
> @@ -1465,9 +1466,16 @@ struct kvm_irq_routing_msi {
>  	__u32 address_lo;
>  	__u32 address_hi;
>  	__u32 data;
> -	__u32 pad;
> +	union {
> +		__u32 pad;
> +		__u32 devid;
> +	};
>  };
>  
> +for KVM_IRQ_ROUTING_EXTENDED_MSI routing entry type, the kvm_irq_routing_msi
> +routing entry is used and devid is populated with the device ID that wrote
> +the MSI message. For PCI, this is usually a BFD identifier in the lower 16 bits.
> +
>  struct kvm_irq_routing_s390_adapter {
>  	__u64 ind_addr;
>  	__u64 summary_addr;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 9a261e5..39ec164 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -829,7 +829,10 @@ struct kvm_irq_routing_msi {
>  	__u32 address_lo;
>  	__u32 address_hi;
>  	__u32 data;
> -	__u32 pad;
> +	union {
> +		__u32 pad;
> +		__u32 devid;
> +	};
>  };
>  
>  struct kvm_irq_routing_s390_adapter {
> @@ -844,6 +847,7 @@ struct kvm_irq_routing_s390_adapter {
>  #define KVM_IRQ_ROUTING_IRQCHIP 1
>  #define KVM_IRQ_ROUTING_MSI 2
>  #define KVM_IRQ_ROUTING_S390_ADAPTER 3
> +#define KVM_IRQ_ROUTING_EXTENDED_MSI 4
>  
>  struct kvm_irq_routing_entry {
>  	__u32 gsi;
> 
