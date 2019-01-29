From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 1/5] KVM: arm/arm64: Reset the VCPU without preemption
 and vcpu state loaded
Date: Tue, 29 Jan 2019 16:48:58 +0100
Message-ID: <20190129154858.docsos3ncoyuld7m@kamzik.brq.redhat.com>
References: <20190125094656.5026-1-christoffer.dall@arm.com>
 <20190125094656.5026-2-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190125094656.5026-2-christoffer.dall@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On Fri, Jan 25, 2019 at 10:46:52AM +0100, Christoffer Dall wrote:
> Resetting the VCPU state modifies the system register state in memory,
> but this may interact with vcpu_load/vcpu_put if running with preemption
> disabled, which in turn may lead to corrupted system register state.
  ^ enabled
> 
> Address this by disabling preemption and doing put/load if required
> around the reset logic.

I'm having trouble understanding how disabling preemption helps here.
There shouldn't be an issue with the KVM_ARM_VCPU_INIT case, since the
target vcpu is guaranteed not to be loaded and therefore it doesn't
have preempt notifiers registered either. Also, KVM_ARM_VCPU_INIT holds
the vcpu mutex, so there's no chance for a load to occur until it's
complete.

For the PSCI case it makes sense to force a vcpu load after the reset,
otherwise the sleeping target vcpu won't have the correct state loaded.
The initial put also makes sense in case we're not resetting everything.
I don't understand how we're ensuring the target vcpu thread's preemption
is disabled though. This modified kvm_reset_vcpu would need to be run
from the target vcpu thread to work, but that's not how the PSCI code
currently does it.

> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/reset.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index b72a3dd56204..f21a2a575939 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -105,16 +105,33 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   * This function finds the right table above and sets the registers on
>   * the virtual CPU struct to their architecturally defined reset
>   * values.
> + *
> + * Note: This function can be called from two paths: The KVM_ARM_VCPU_INIT
> + * ioctl or as part of handling a request issued by another VCPU in the PSCI
> + * handling code.  In the first case, the VCPU will not be loaded, and in the
> + * second case the VCPU will be loaded.  Because this function operates purely
> + * on the memory-backed valus of system registers, we want to do a full put if
                           ^ values
> + * we were loaded (handling a request) and load the values back at the end of
> + * the function.  Otherwise we leave the state alone.  In both cases, we
> + * disable preemption around the vcpu reset as we would otherwise race with
> + * preempt notifiers which also call put/load.
>   */
>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  {
>  	const struct kvm_regs *cpu_reset;
> +	int ret = -EINVAL;
> +	bool loaded;
> +
> +	preempt_disable();
> +	loaded = (vcpu->cpu != -1);
> +	if (loaded)
> +		kvm_arch_vcpu_put(vcpu);
>  
>  	switch (vcpu->arch.target) {
>  	default:
>  		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
>  			if (!cpu_has_32bit_el1())
> -				return -EINVAL;
> +				goto out;
>  			cpu_reset = &default_regs_reset32;
>  		} else {
>  			cpu_reset = &default_regs_reset;
> @@ -137,7 +154,12 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  		vcpu->arch.workaround_flags |= VCPU_WORKAROUND_2_FLAG;
>  
>  	/* Reset timer */
> -	return kvm_timer_vcpu_reset(vcpu);
> +	ret = kvm_timer_vcpu_reset(vcpu);
> +out:
> +	if (loaded)
> +		kvm_arch_vcpu_load(vcpu, smp_processor_id());
> +	preempt_enable();
> +	return ret;
>  }
>  
>  void kvm_set_ipa_limit(void)
> -- 
> 2.18.0
>

Thanks,
drew 
