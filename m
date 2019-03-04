From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH 05/11] KVM: arm/arm64: Reset the VCPU without preemption
 and vcpu state loaded
Date: Mon, 4 Mar 2019 16:30:08 +0000
Message-ID: <f6928433-8ae6-6cae-d86d-b392f5b4fea6@arm.com>
References: <20190207131843.157210-1-marc.zyngier@arm.com>
 <20190207131843.157210-6-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3EE94A380
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Mar 2019 11:30:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FHz0mGQh8s+W for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Mar 2019 11:30:12 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E96F4A1DF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Mar 2019 11:30:12 -0500 (EST)
In-Reply-To: <20190207131843.157210-6-marc.zyngier@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Richard Henderson <richard.henderson@linaro.org>, Masami Hiramatsu <mhiramat@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

I noticed some issues with this patch when rebooting a guest after using perf.

[  577.513447] BUG: sleeping function called from invalid context at 
kernel/locking/mutex.c:908
[  577.521926] in_atomic(): 1, irqs_disabled(): 0, pid: 2323, name: qemu-system aar
[  577.529354] 1 lock held by qemu-system-aar/2323:
[  577.533998]  #0: 00000000f4f96804 (&vcpu->mutex){+.+.}, at: 
kvm_vcpu_ioctl+0x74/0xac0
[  577.541865] Preemption disabled at:
[  577.541871] [<ffff0000100cc82c>] kvm_reset_vcpu+0x1c/0x1d0
[  577.550882] CPU: 6 PID: 2323 Comm: qemu-system-aar Tainted: G        W  5.0.0 
#1277
[  577.559137] Hardware name: AMD Seattle (Rev.B0) Development Board (Overdrive) 
(DT)
[  577.566698] Call trace:
[  577.569138]  dump_backtrace+0x0/0x140
[  577.572793]  show_stack+0x14/0x20
[  577.576103]  dump_stack+0xa0/0xd4
[  577.579412]  ___might_sleep+0x1e4/0x2b0
[  577.583241]  __might_sleep+0x60/0xb8
[  577.586810]  __mutex_lock+0x58/0x860
[  577.590378]  mutex_lock_nested+0x1c/0x28
[  577.594294]  perf_event_ctx_lock_nested+0xf4/0x238
[  577.599078]  perf_event_read_value+0x24/0x60
[  577.603341]  kvm_pmu_get_counter_value+0x80/0xe8
[  577.607950]  kvm_pmu_stop_counter+0x2c/0x98
[  577.612126]  kvm_pmu_vcpu_reset+0x58/0xd0
[  577.616128]  kvm_reset_vcpu+0xec/0x1d0
[  577.619869]  kvm_arch_vcpu_ioctl+0x6b0/0x860
[  577.624131]  kvm_vcpu_ioctl+0xe0/0xac0
[  577.627876]  do_vfs_ioctl+0xbc/0x910
[  577.631443]  ksys_ioctl+0x78/0xa8
[  577.634751]  __arm64_sys_ioctl+0x1c/0x28
[  577.638667]  el0_svc_common+0x90/0x118
[  577.642408]  el0_svc_handler+0x2c/0x80
[  577.646150]  el0_svc+0x8/0xc

This is happening because the vCPU reset code is now running with preemption 
disable. However, the perf code cannot be called with preemption disabled as it 
is using mutex.

Do you have any suggestion on the way to fix this potential issue?

Cheers,

On 07/02/2019 13:18, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> We have two ways to reset a vcpu:
> - either through VCPU_INIT
> - or through a PSCI_ON call
> 
> The first one is easy to reason about. The second one is implemented
> in a more bizarre way, as it is the vcpu that handles PSCI_ON that
> resets the vcpu that is being powered-on. As we need to turn the logic
> around and have the target vcpu to reset itself, we must take some
> preliminary steps.
> 
> Resetting the VCPU state modifies the system register state in memory,
> but this may interact with vcpu_load/vcpu_put if running with preemption
> disabled, which in turn may lead to corrupted system register state.
> 
> Address this by disabling preemption and doing put/load if required
> around the reset logic.
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>   arch/arm64/kvm/reset.c | 26 ++++++++++++++++++++++++--
>   1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index b72a3dd56204..f21a2a575939 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -105,16 +105,33 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>    * This function finds the right table above and sets the registers on
>    * the virtual CPU struct to their architecturally defined reset
>    * values.
> + *
> + * Note: This function can be called from two paths: The KVM_ARM_VCPU_INIT
> + * ioctl or as part of handling a request issued by another VCPU in the PSCI
> + * handling code.  In the first case, the VCPU will not be loaded, and in the
> + * second case the VCPU will be loaded.  Because this function operates purely
> + * on the memory-backed valus of system registers, we want to do a full put if
> + * we were loaded (handling a request) and load the values back at the end of
> + * the function.  Otherwise we leave the state alone.  In both cases, we
> + * disable preemption around the vcpu reset as we would otherwise race with
> + * preempt notifiers which also call put/load.
>    */
>   int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>   {
>   	const struct kvm_regs *cpu_reset;
> +	int ret = -EINVAL;
> +	bool loaded;
> +
> +	preempt_disable();
> +	loaded = (vcpu->cpu != -1);
> +	if (loaded)
> +		kvm_arch_vcpu_put(vcpu);
>   
>   	switch (vcpu->arch.target) {
>   	default:
>   		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
>   			if (!cpu_has_32bit_el1())
> -				return -EINVAL;
> +				goto out;
>   			cpu_reset = &default_regs_reset32;
>   		} else {
>   			cpu_reset = &default_regs_reset;
> @@ -137,7 +154,12 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>   		vcpu->arch.workaround_flags |= VCPU_WORKAROUND_2_FLAG;
>   
>   	/* Reset timer */
> -	return kvm_timer_vcpu_reset(vcpu);
> +	ret = kvm_timer_vcpu_reset(vcpu);
> +out:
> +	if (loaded)
> +		kvm_arch_vcpu_load(vcpu, smp_processor_id());
> +	preempt_enable();
> +	return ret;
>   }
>   
>   void kvm_set_ipa_limit(void)
> 

-- 
Julien Grall
