From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 0/3] KVM: arm64: single step emulation instructions
Date: Tue, 21 Nov 2017 13:10:50 +0000
Message-ID: <5fb5067a-7b94-1d87-5e4b-d162ddd28cd6@arm.com>
References: <20171116153921.21991-1-alex.bennee@linaro.org>
 <20171120154131.GO28855@cbox> <873757yf8f.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <873757yf8f.fsf@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, Christoffer Dall <cdall@linaro.org>
Cc: julien.thierry@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 21/11/17 12:43, Alex Bennée wrote:
> 
> Christoffer Dall <cdall@linaro.org> writes:
> 
>> Hi Alex,
>>
>> On Thu, Nov 16, 2017 at 03:39:18PM +0000, Alex Bennée wrote:
>>> Hi,
>>>
>>> This is rev 3 of the series, practically the same than rev 2 but fixed
>>> a return 1->0 in the kvm_run loop that Julien caught. I've added his
>>> r-b tags to the other patches.
>>>
>>> As usual revision details bellow the --- in each patch.
>>
>> Thanks for taking care of this.
>>
>> I have applied the series and slightly tweaked the commit messages and
>> commentary.
>>
>> Did we simply decide to not worry about exiting to userspace if we do
>> fast-path emulation, such as for the errata workaround and GIC
>> mashaling in switch.c ?
> 
> Compile tested only:
> 
> --8<---------------cut here---------------start------------->8---
> kvm: arm64: handle single-step of hyp emulated mmio
> 
> There is a fast-path of MMIO emulation inside hyp mode. The handling
> of single-step is broadly the same as kvm_arm_handle_step_debug()
> except we just setup ESR/HSR so handle_exit() does the correct thing
> as we exit.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  arch/arm64/kvm/hyp/switch.c | 26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 945e79c641c4..841dc79d11fd 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -263,7 +263,11 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
>  	return true;
>  }
> 
> -static void __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
> +/* Skip an instruction which has been emulated. Returns true if
> + * execution can continue or false if we need to exit hyp mode because
> + * single-step was in effect.
> + */
> +static bool __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
>  {
>  	*vcpu_pc(vcpu) = read_sysreg_el2(elr);
> 
> @@ -276,6 +280,14 @@ static void __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
>  	}
> 
>  	write_sysreg_el2(*vcpu_pc(vcpu), elr);
> +
> +	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
> +		vcpu->arch.fault.esr_el2 =
> +			(ESR_ELx_EC_SOFTSTP_LOW << ESR_ELx_EC_SHIFT) | 0x22;
> +		return false;
> +	} else {
> +		return true;
> +	}
>  }
> 
>  int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> @@ -336,8 +348,10 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  			int ret = __vgic_v2_perform_cpuif_access(vcpu);
> 
>  			if (ret == 1) {
> -				__skip_instr(vcpu);
> -				goto again;
> +				if (__skip_instr(vcpu))
> +					goto again;
> +				else
> +					exit_code = ARM_EXCEPTION_TRAP;
>  			}
> 
>  			if (ret == -1) {

Here (in the -1 case), we should still report the step to userspace (it
took place after all), and signal the SError to the guest (because it is
being stupid).

	M. (I really hate that part of the code base...)
-- 
Jazz is not dead. It just smells funny...
