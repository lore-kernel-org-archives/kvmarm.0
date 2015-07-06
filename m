From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC v2 1/6] KVM: arm/arm64: select IRQ_BYPASS_MANAGER
Date: Mon, 6 Jul 2015 14:24:50 +0200
Message-ID: <559A7392.9020002@redhat.com>
References: <1436184692-20927-1-git-send-email-eric.auger@linaro.org>
 <1436184692-20927-2-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1436184692-20927-2-git-send-email-eric.auger@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 06/07/2015 14:11, Eric Auger wrote:
> Select IRQ_BYPASS_MANAGER when CONFIG_KVM is set
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> ---
> v1 -> v2:
> - also set IRQ_BYPASS_MANAGER for arm64
> ---
>  arch/arm/kvm/Kconfig   | 1 +
>  arch/arm64/kvm/Kconfig | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> index bfb915d..7d38d25 100644
> --- a/arch/arm/kvm/Kconfig
> +++ b/arch/arm/kvm/Kconfig
> @@ -31,6 +31,7 @@ config KVM
>  	select KVM_VFIO
>  	select HAVE_KVM_EVENTFD
>  	select HAVE_KVM_IRQFD
> +	select IRQ_BYPASS_MANAGER
>  	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
>  	---help---
>  	  Support hosting virtualized guest machines.
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index bfffe8f..d1922b4 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -31,6 +31,7 @@ config KVM
>  	select KVM_VFIO
>  	select HAVE_KVM_EVENTFD
>  	select HAVE_KVM_IRQFD
> +	select HAVE_KVM_IRQFD

Obvious pasto. :)

Paolo

>  	---help---
>  	  Support hosting virtualized guest machines.
>  
> 
