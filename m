From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm: KVM: force execution of HCPTR access on VM exit
Date: Wed, 8 Apr 2015 13:40:33 +0200
Message-ID: <20150408114033.GH4715@cbox>
References: <1426503583-8958-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 551B94BA5D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Apr 2015 07:33:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HzSlCJMP+i1B for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Apr 2015 07:33:02 -0400 (EDT)
Received: from mail-la0-f41.google.com (mail-la0-f41.google.com
 [209.85.215.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E53984B146
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Apr 2015 07:33:01 -0400 (EDT)
Received: by layy10 with SMTP id y10so63721603lay.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Apr 2015 04:40:34 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1426503583-8958-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 16, 2015 at 10:59:43AM +0000, Marc Zyngier wrote:
> On VM entry, we disable access to the VFP registers in order to
> perform a lazy save/restore of these registers.
> 
> On VM exit, we restore access, test if we did enable them before,
> and save/restore the guest/host registers if necessary. In this
> sequence, the FPEXC register is always accessed, irrespective
> of the trapping configuration.
> 
> If the guest didn't touch the VFP registers, then the HCPTR access
> has now enabled such access, but we're missing a barrier to ensure
> architectural execution of the new HCPTR configuration. If the HCPTR
> access has been delayed/reordered, the subsequent access to FPEXC
> will cause a trap, which we aren't prepared to handle at all.
> 
> The fix is to introduce a barrier that only takes place if the
> guest hasn't accessed its view of the VFP registers, making
> the access to FPEXC safe.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kvm/interrupts.S | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
> index 79caf79..3ac7aca 100644
> --- a/arch/arm/kvm/interrupts.S
> +++ b/arch/arm/kvm/interrupts.S
> @@ -175,10 +175,13 @@ __kvm_vcpu_return:
>  #ifdef CONFIG_VFPv3
>  	@ Save floating point registers we if let guest use them.
>  	tst	r2, #(HCPTR_TCP(10) | HCPTR_TCP(11))
> -	bne	after_vfp_restore
> +	beq	1f
> +
> +	isb	@ Force execution of HCPTR if we've just reenabled VFP access
> +	b	after_vfp_restore
>  
>  	@ Switch VFP/NEON hardware state to the host's
> -	add	r7, vcpu, #VCPU_VFP_GUEST
> +1:	add	r7, vcpu, #VCPU_VFP_GUEST
>  	store_vfp_state r7
>  	add	r7, vcpu, #VCPU_VFP_HOST
>  	ldr	r7, [r7]
> -- 
> 2.1.4
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
