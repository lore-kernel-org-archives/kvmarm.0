From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm/arm64: KVM: Check for properly initialized timer on
 init
Date: Tue, 6 Dec 2016 11:25:42 +0000
Message-ID: <1ed187ba-965b-6087-f74f-68627f0d0504@arm.com>
References: <20161205093211.11870-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5723A40598
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 06:24:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v1wQ9WlF7Ru3 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2016 06:24:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97A1940428
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 06:24:47 -0500 (EST)
In-Reply-To: <20161205093211.11870-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/12/16 09:32, Christoffer Dall wrote:
> When the arch timer code fails to initialize (for example because the
> memory mapped timer doesn't work, which is currently seen with the AEM
> model), then KVM just continues happily with a final result that KVM
> eventually does a NULL pointer dereference of the uninitialized cycle
> counter.
> 
> Check directly for this in the init path and give the user a reasonable
> error in this case.
> 
> Cc: Shih-Wei Li <shihwei@cs.columbia.edu>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  virt/kvm/arm/arch_timer.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 27a1f63..5c12f53 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -425,6 +425,11 @@ int kvm_timer_hyp_init(void)
>  	info = arch_timer_get_kvm_info();
>  	timecounter = &info->timecounter;
>  
> +	if (!timecounter->cc) {
> +		kvm_err("arch_timer: uninitialized timecounter\n");

For consistency, I'll change the error message to say "kvm_arch_timer",
just like the below case.

> +		return -ENODEV;
> +	}
> +
>  	if (info->virtual_irq <= 0) {
>  		kvm_err("kvm_arch_timer: invalid virtual timer IRQ: %d\n",
>  			info->virtual_irq);
> 

Otherwise looks good to me. I'll queue it now.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
