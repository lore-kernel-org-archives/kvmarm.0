From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] KVM: Documentation: rename the capability of
 KVM_CAP_ARM_SET_SERROR_ESR
Date: Mon, 20 Aug 2018 16:29:25 +0200
Message-ID: <20180820142925.zw2vgplbutfcvvos@kamzik.brq.redhat.com>
References: <1534801165-41525-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1534801165-41525-1-git-send-email-gengdongjiu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: christoffer.dall@arm.com, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 20, 2018 at 05:39:25PM -0400, Dongjiu Geng wrote:
> In the documentation description, this capability's name is
> KVM_CAP_ARM_SET_SERROR_ESR, but in the header file this
> capability's name is KVM_CAP_ARM_INJECT_SERROR_ESR, so change
> the documentation description to make it same.
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> ---
> In the Documentation/virtual/kvm/api.txt:
> 
> +8.19 KVM_CAP_ARM_SET_SERROR_ESR
> 
> In the include/uapi/linux/kvm.h:
> +#define KVM_CAP_ARM_INJECT_SERROR_ESR 156
> 
> So in above two files, the capability's name is not same, it
> is better to use a same name.
> ---
>  Documentation/virtual/kvm/api.txt | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 0acdbac..c664064 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -909,10 +909,10 @@ Serviceability (RAS) Specification").
>  
>  SError exceptions always have an ESR value. Some CPUs have the ability to
>  specify what the virtual SError's ESR value should be. These systems will
> -advertise KVM_CAP_ARM_SET_SERROR_ESR. In this case exception.has_esr will
> +advertise KVM_CAP_ARM_INJECT_SERROR_ESR. In this case exception.has_esr will
>  always have a non-zero value when read, and the agent making an SError pending
>  should specify the ISS field in the lower 24 bits of exception.serror_esr. If
> -the system supports KVM_CAP_ARM_SET_SERROR_ESR, but user-space sets the events
> +the system supports KVM_CAP_ARM_INJECT_SERROR_ESR, but user-space sets the events
>  with exception.has_esr as zero, KVM will choose an ESR.
>  
>  Specifying exception.has_esr on a system that does not support it will return
> @@ -4749,7 +4749,7 @@ hypercalls:
>  HvFlushVirtualAddressSpace, HvFlushVirtualAddressSpaceEx,
>  HvFlushVirtualAddressList, HvFlushVirtualAddressListEx.
>  
> -8.19 KVM_CAP_ARM_SET_SERROR_ESR
> +8.19 KVM_CAP_ARM_INJECT_SERROR_ESR
>  
>  Architectures: arm, arm64
>  
> -- 
> 2.7.4
>

Reported-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew
