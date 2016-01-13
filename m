From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/3] KVM: ARM64: Fix comments of the CP handler
Date: Wed, 13 Jan 2016 09:32:28 +0000
Message-ID: <569619AC.5040102@arm.com>
References: <1452676601-14796-1-git-send-email-zhaoshenglong@huawei.com>
 <1452676601-14796-3-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A6B849A80
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2016 04:28:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6VYUFIwyFlFm for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jan 2016 04:28:25 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9726B48531
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2016 04:28:25 -0500 (EST)
In-Reply-To: <1452676601-14796-3-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 13/01/16 09:16, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index eec3598..4048934 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1043,7 +1043,7 @@ static void unhandled_cp_access(struct kvm_vcpu *vcpu,
>  }
>  
>  /**
> - * kvm_handle_cp_64 -- handles a mrrc/mcrr trap on a guest CP15 access
> + * kvm_handle_cp_64 -- handles a mrrc/mcrr trap on a guest CP14/CP15 access
>   * @vcpu: The VCPU pointer
>   * @run:  The kvm_run struct
>   */
> @@ -1095,7 +1095,7 @@ out:
>  }
>  
>  /**
> - * kvm_handle_cp15_32 -- handles a mrc/mcr trap on a guest CP15 access
> + * kvm_handle_cp_32 -- handles a mrc/mcr trap on a guest CP14/CP15 access
>   * @vcpu: The VCPU pointer
>   * @run:  The kvm_run struct
>   */
> 

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
