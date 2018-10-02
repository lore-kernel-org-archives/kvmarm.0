From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Drop __cpu_init_stage2 on the VHE path
Date: Tue, 2 Oct 2018 10:41:11 +0200
Message-ID: <dd7708db-53e0-3048-4fdb-c1c8e7a09de5@redhat.com>
References: <20181001130656.36999-1-marc.zyngier@arm.com>
 <20181001130656.36999-3-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2BE949F86
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Oct 2018 04:41:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xmdae0HGA0wx for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Oct 2018 04:41:15 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B37E40A67
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Oct 2018 04:41:15 -0400 (EDT)
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
To: Marc Zyngier <marc.zyngier@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 10/1/18 3:06 PM, Marc Zyngier wrote:
> __cpu_init_stage2 doesn't do anything anymore on arm64, and is
> totally non-sensical if running VHE (as VHE is 64bit only).
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  virt/kvm/arm/arm.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 91c464c9cd21..4ce99bb223bc 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1310,16 +1310,10 @@ static void cpu_hyp_reinit(void)
>  {
>  	cpu_hyp_reset();
>  
> -	if (is_kernel_in_hyp_mode()) {
> -		/*
> -		 * __cpu_init_stage2() is safe to call even if the PM
> -		 * event was cancelled before the CPU was reset.
> -		 */
> -		__cpu_init_stage2();
> +	if (is_kernel_in_hyp_mode())
>  		kvm_timer_init_vhe();
> -	} else {
> +	else
>  		cpu_init_hyp_mode(NULL);
> -	}
>  
>  	if (vgic_present)
>  		kvm_vgic_init_cpu_hardware();
> 
