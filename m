From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v2 3/3] kvm: arm64: handle single-step of userspace mmio
 instructions
Date: Mon, 13 Nov 2017 11:04:01 +0000
Message-ID: <b3f76167-50e4-5f25-9ec2-16f07de0fd32@arm.com>
References: <20171109170021.2984-1-alex.bennee@linaro.org>
 <20171109170021.2984-4-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171109170021.2984-4-alex.bennee@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,

On 09/11/17 17:00, Alex Bennée wrote:
> The system state of KVM when using userspace emulation is not complete
> until we return into KVM_RUN. To handle mmio related updates we wait
> until they have been committed and then schedule our KVM_EXIT_DEBUG.
> 
> The kvm_arm_handle_step_debug() helper tells us if we need to return
> and sets up the exit_reason for us.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> 
> ---
> v2
>    - call helper directly from kvm_arch_vcpu_ioctl_run
> ---
>   virt/kvm/arm/arm.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 95cba0799828..2991adfaca9d 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -625,6 +625,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>   		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
>   		if (ret)
>   			return ret;
> +		if (kvm_arm_handle_step_debug(vcpu, vcpu->run))
> +			return 1;
> +

In the previous patch, kvm_arch_vcpu_ioctl_run return 0 when telling 
userspace about a debug exception. Shouldn't this branch return 0 
instead of 1?

Returning on non-zero for kvm_handle_mmio_return is done because it 
means there was an error. This is not the case for 
kvm_arm_handle_step_debug.

The description in the comment of kvm_arch_vcpu_ioctl_run is not very 
clear whether non-zero result should be used for errors or if only the 
negative values are treated as such, and positive values seems to be 
generally used to keep the vcpu going. So, I thought it might make sense 
to always return the same value upon debug exceptions.

Cheers,

-- 
Julien Thierry
