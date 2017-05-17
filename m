From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 09/31] KVM: arm64: Make kvm_condition_valid32() accessible
 from EL2
Date: Wed, 17 May 2017 11:54:11 +0200
Message-ID: <877db426-38ee-9776-2ca7-29b727eb11b9@redhat.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-10-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63F4440C2D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 May 2017 05:50:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rf3MKeJy2Bvf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 May 2017 05:50:47 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB8D440BC4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 May 2017 05:50:46 -0400 (EDT)
In-Reply-To: <20170503104606.19342-10-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,
On 03/05/2017 12:45, Marc Zyngier wrote:
> As we're about to trap CP15 accesses and handle them at EL2, we
> need to evaluate whether or not the condition flags are valid,
> as an implementation is allowed to trap despite the condition
> not being met.
> 
> Tagging the function as __hyp_text allows this.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  virt/kvm/arm/aarch32.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
> index 528af4b2d09e..79c7c357804b 100644
> --- a/virt/kvm/arm/aarch32.c
> +++ b/virt/kvm/arm/aarch32.c
> @@ -60,7 +60,7 @@ static const unsigned short cc_map[16] = {
>  /*
>   * Check if a trapped instruction should have been executed or not.
>   */
> -bool kvm_condition_valid32(const struct kvm_vcpu *vcpu)
> +bool __hyp_text kvm_condition_valid32(const struct kvm_vcpu *vcpu)
>  {
>  	unsigned long cpsr;
>  	u32 cpsr_cond;
> 
