From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Drop __cpu_init_stage2 on the VHE path
Date: Mon, 1 Oct 2018 17:13:27 +0100
Message-ID: <22605c91-53f1-239d-e6bf-1d9cf617bdbb@arm.com>
References: <20181001130656.36999-1-marc.zyngier@arm.com>
 <20181001130656.36999-3-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 030724A1D8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Oct 2018 12:12:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IKJiNEWPOm88 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Oct 2018 12:12:27 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 272EB49F87
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Oct 2018 12:12:27 -0400 (EDT)
In-Reply-To: <20181001130656.36999-3-marc.zyngier@arm.com>
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
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Marc,

On 10/01/2018 02:06 PM, Marc Zyngier wrote:
> __cpu_init_stage2 doesn't do anything anymore on arm64, and is
> totally non-sensical if running VHE (as VHE is 64bit only).
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>   virt/kvm/arm/arm.c | 10 ++--------
>   1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 91c464c9cd21..4ce99bb223bc 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1310,16 +1310,10 @@ static void cpu_hyp_reinit(void)
>   {
>   	cpu_hyp_reset();
>   
> -	if (is_kernel_in_hyp_mode()) {
> -		/*
> -		 * __cpu_init_stage2() is safe to call even if the PM
> -		 * event was cancelled before the CPU was reset.
> -		 */
> -		__cpu_init_stage2();
> +	if (is_kernel_in_hyp_mode())
>   		kvm_timer_init_vhe();

The patch looks good to me. However, if we ever add something there in
the future, this caller site could be lost. Is it worth a comment ?

Besides,

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
