From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 27/28] ARM: KVM: Remove handling of
 ARM_EXCEPTION_DATA/PREF_ABORT
Date: Tue, 9 Feb 2016 19:39:17 +0100
Message-ID: <20160209183917.GD5171@cbox>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
 <1454583645-10144-28-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454583645-10144-28-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 04, 2016 at 11:00:44AM +0000, Marc Zyngier wrote:
> These are now handled as a panic, so there is little point in
> keeping them around.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kvm/handle_exit.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
> index 5377d753..3f1ef0d 100644
> --- a/arch/arm/kvm/handle_exit.c
> +++ b/arch/arm/kvm/handle_exit.c
> @@ -147,8 +147,6 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  	switch (exception_index) {
>  	case ARM_EXCEPTION_IRQ:
>  		return 1;
> -	case ARM_EXCEPTION_DATA_ABORT:
> -	case ARM_EXCEPTION_PREF_ABORT:
>  	case ARM_EXCEPTION_HVC:
>  		/*
>  		 * See ARM ARM B1.14.1: "Hyp traps on instructions
> -- 
> 2.1.4
> 

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
