From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4] KVM: arm/arm64: fix the incompatible matching for
 external abort
Date: Mon, 30 Oct 2017 08:33:22 +0100
Message-ID: <20171030073322.GR2166@lvm>
References: <1509343518-27137-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1509343518-27137-1-git-send-email-gengdongjiu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: marc.zyngier@arm.com, christoffer.dall@linaro.org, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, huangshaoyu@huawei.com, wuquanming@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 30, 2017 at 02:05:18PM +0800, Dongjiu Geng wrote:
> kvm_vcpu_dabt_isextabt() tries to match a full fault syndrome, but
> calls kvm_vcpu_trap_get_fault_type() that only returns the fault class,
> thus reducing the scope of the check. This doesn't cause any observable
> bug yet as we end-up matching a closely related syndrome for which we
> return the same value.
> 
> Using kvm_vcpu_trap_get_fault() instead fixes it for good.
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Applied, thanks.
-Christoffer

> ---
>  arch/arm/include/asm/kvm_emulate.h   | 2 +-
>  arch/arm64/include/asm/kvm_emulate.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
> index 98089ff..7571b4e 100644
> --- a/arch/arm/include/asm/kvm_emulate.h
> +++ b/arch/arm/include/asm/kvm_emulate.h
> @@ -203,7 +203,7 @@ static inline u8 kvm_vcpu_trap_get_fault_type(struct kvm_vcpu *vcpu)
>  
>  static inline bool kvm_vcpu_dabt_isextabt(struct kvm_vcpu *vcpu)
>  {
> -	switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
> +	switch (kvm_vcpu_trap_get_fault(vcpu)) {
>  	case FSC_SEA:
>  	case FSC_SEA_TTW0:
>  	case FSC_SEA_TTW1:
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index e5df3fc..8c918c5 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -237,7 +237,7 @@ static inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vcpu)
>  
>  static inline bool kvm_vcpu_dabt_isextabt(const struct kvm_vcpu *vcpu)
>  {
> -	switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
> +	switch (kvm_vcpu_trap_get_fault(vcpu)) {
>  	case FSC_SEA:
>  	case FSC_SEA_TTW0:
>  	case FSC_SEA_TTW1:
> -- 
> 1.9.1
> 
