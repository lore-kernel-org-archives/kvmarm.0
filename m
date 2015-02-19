From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC/RFT PATCH 3/3] arm64: KVM: keep trapping of VM sysreg writes
 enabled
Date: Thu, 19 Feb 2015 13:40:02 +0000
Message-ID: <54E5E7B2.2080501@arm.com>
References: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
 <1424343286-6792-4-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06AE545FFE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 08:34:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HyxsRzh6BV58 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Feb 2015 08:34:37 -0500 (EST)
Received: from usa-sjc-mx-foss1.foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C895345FDA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 08:34:37 -0500 (EST)
In-Reply-To: <1424343286-6792-4-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "lersek@redhat.com" <lersek@redhat.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 19/02/15 10:54, Ard Biesheuvel wrote:
> ---
>  arch/arm/kvm/mmu.c               | 2 +-
>  arch/arm64/include/asm/kvm_arm.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index 136662547ca6..fa8ec55220ea 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -1530,7 +1530,7 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
>  		stage2_flush_vm(vcpu->kvm);
>  
>  	/* Caches are now on, stop trapping VM ops (until a S/W op) */
> -	if (now_enabled)
> +	if (0)//now_enabled)
>  		vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) & ~HCR_TVM);
>  
>  	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 8afb863f5a9e..437e1ec17539 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -75,7 +75,7 @@
>   * FMO:		Override CPSR.F and enable signaling with VF
>   * SWIO:	Turn set/way invalidates into set/way clean+invalidate
>   */
> -#define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
> +#define HCR_GUEST_FLAGS (HCR_TSC | /* HCR_TSW | */ HCR_TWE | HCR_TWI | HCR_VM | \

Why do we stop to trap S/W ops here? We can't let the guest issue those
without doing anything, as this will break anything that expects the
data to make it to memory. Think of the 32bit kernel decompressor, for
example.

	M.
-- 
Jazz is not dead. It just smells funny...
