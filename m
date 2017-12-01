From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v5 1/8] KVM: arm/arm64: Remove redundant preemptible
 checks
Date: Fri, 1 Dec 2017 18:04:00 +0000
Message-ID: <f51b02a1-1319-3f69-c17f-4ed4c78acd38@arm.com>
References: <20171120191649.17290-1-christoffer.dall@linaro.org>
 <20171120191649.17290-2-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171120191649.17290-2-christoffer.dall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 20/11/17 19:16, Christoffer Dall wrote:
> The __this_cpu_read() and __this_cpu_write() functions already implement
> checks for the required preemption levels when using
> CONFIG_DEBUG_PREEMPT which gives you nice error messages and such.
> Therefore there is no need to explicitly check this using a BUG_ON() in
> the code (which we don't do for other uses of per cpu variables either).
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>


> ---
>  virt/kvm/arm/arm.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index c13d74c083fe..28548aeaf164 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -71,7 +71,6 @@ static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
>  
>  static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
>  {
> -	BUG_ON(preemptible());
>  	__this_cpu_write(kvm_arm_running_vcpu, vcpu);
>  }
>  
> @@ -81,7 +80,6 @@ static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
>   */
>  struct kvm_vcpu *kvm_arm_get_running_vcpu(void)
>  {
> -	BUG_ON(preemptible());
>  	return __this_cpu_read(kvm_arm_running_vcpu);
>  }
>  
> 
