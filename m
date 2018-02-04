From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 09/18] arm/arm64: KVM: Advertise SMCCC v1.1
Date: Sun, 4 Feb 2018 19:38:48 +0100
Message-ID: <20180204183848.GM21802@cbox>
References: <20180201114657.7323-1-marc.zyngier@arm.com>
 <20180201114657.7323-10-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180201114657.7323-10-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Jones <drjones@redhat.com>, Hanjun Guo <guohanjun@huawei.com>, Jayachandran C <jnair@caviumnetworks.com>, Jon Masters <jcm@redhat.com>, Russell King - ARM Linux <linux@armlinux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 01, 2018 at 11:46:48AM +0000, Marc Zyngier wrote:
> The new SMC Calling Convention (v1.1) allows for a reduced overhead
> when calling into the firmware, and provides a new feature discovery
> mechanism.
> 
> Make it visible to KVM guests.
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kvm/handle_exit.c   |  2 +-
>  arch/arm64/kvm/handle_exit.c |  2 +-
>  include/kvm/arm_psci.h       |  2 +-
>  include/linux/arm-smccc.h    | 13 +++++++++++++
>  virt/kvm/arm/psci.c          | 24 +++++++++++++++++++++++-
>  5 files changed, 39 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
> index 230ae4079108..910bd8dabb3c 100644
> --- a/arch/arm/kvm/handle_exit.c
> +++ b/arch/arm/kvm/handle_exit.c
> @@ -36,7 +36,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		      kvm_vcpu_hvc_get_imm(vcpu));
>  	vcpu->stat.hvc_exit_stat++;
>  
> -	ret = kvm_psci_call(vcpu);
> +	ret = kvm_hvc_call_handler(vcpu);
>  	if (ret < 0) {
>  		vcpu_set_reg(vcpu, 0, ~0UL);
>  		return 1;
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 588f910632a7..e5e741bfffe1 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -52,7 +52,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  			    kvm_vcpu_hvc_get_imm(vcpu));
>  	vcpu->stat.hvc_exit_stat++;
>  
> -	ret = kvm_psci_call(vcpu);
> +	ret = kvm_hvc_call_handler(vcpu);
>  	if (ret < 0) {
>  		vcpu_set_reg(vcpu, 0, ~0UL);
>  		return 1;
> diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> index 4ee098c39e01..7b2e12697d4f 100644
> --- a/include/kvm/arm_psci.h
> +++ b/include/kvm/arm_psci.h
> @@ -27,7 +27,7 @@
>  #define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_0
>  
>  int kvm_psci_version(struct kvm_vcpu *vcpu);
> -int kvm_psci_call(struct kvm_vcpu *vcpu);
> +int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
>  
>  struct kvm_one_reg;
>  
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index 4c5bca38c653..dc68aa5a7261 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -60,6 +60,19 @@
>  #define ARM_SMCCC_QUIRK_NONE		0
>  #define ARM_SMCCC_QUIRK_QCOM_A6		1 /* Save/restore register a6 */
>  
> +#define ARM_SMCCC_VERSION_1_0		0x10000
> +#define ARM_SMCCC_VERSION_1_1		0x10001
> +
> +#define ARM_SMCCC_VERSION_FUNC_ID					\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_32,				\
> +			   0, 0)
> +
> +#define ARM_SMCCC_ARCH_FEATURES_FUNC_ID					\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_32,				\
> +			   0, 1)
> +
>  #ifndef __ASSEMBLY__
>  
>  #include <linux/linkage.h>
> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> index 5c8366b71639..53272e8e0d37 100644
> --- a/virt/kvm/arm/psci.c
> +++ b/virt/kvm/arm/psci.c
> @@ -15,6 +15,7 @@
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
>  
> +#include <linux/arm-smccc.h>
>  #include <linux/preempt.h>
>  #include <linux/kvm_host.h>
>  #include <linux/uaccess.h>
> @@ -351,6 +352,7 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
>  		case PSCI_0_2_FN_SYSTEM_OFF:
>  		case PSCI_0_2_FN_SYSTEM_RESET:
>  		case PSCI_1_0_FN_PSCI_FEATURES:
> +		case ARM_SMCCC_VERSION_FUNC_ID:
>  			val = 0;
>  			break;
>  		default:
> @@ -405,7 +407,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
>   * Errors:
>   * -EINVAL: Unrecognized PSCI function
>   */
> -int kvm_psci_call(struct kvm_vcpu *vcpu)
> +static int kvm_psci_call(struct kvm_vcpu *vcpu)
>  {
>  	switch (kvm_psci_version(vcpu)) {
>  	case KVM_ARM_PSCI_1_0:
> @@ -419,6 +421,26 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
>  	};
>  }
>  
> +int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> +{
> +	u32 func_id = smccc_get_function(vcpu);
> +	u32 val = PSCI_RET_NOT_SUPPORTED;
> +
> +	switch (func_id) {
> +	case ARM_SMCCC_VERSION_FUNC_ID:
> +		val = ARM_SMCCC_VERSION_1_1;
> +		break;
> +	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> +		/* Nothing supported yet */
> +		break;
> +	default:
> +		return kvm_psci_call(vcpu);
> +	}
> +
> +	smccc_set_retval(vcpu, val, 0, 0, 0);
> +	return 1;
> +}
> +
>  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
>  {
>  	return 1;		/* PSCI version */
> -- 
> 2.14.2
> 
