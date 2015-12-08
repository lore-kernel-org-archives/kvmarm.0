From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 06/21] KVM: ARM64: Add reset and access handlers for
 PMCEID0 and PMCEID1 register
Date: Tue, 08 Dec 2015 14:23:16 +0000
Message-ID: <5666E7D4.2070103@arm.com>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com> <1449578860-15808-7-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1449578860-15808-7-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 08/12/15 12:47, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Add reset handler which gets host value of PMCEID0 or PMCEID1. Since
> write action to PMCEID0 or PMCEID1 is ignored, add a new case for this.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index d81f7ac..1bcb2b7 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -452,6 +452,19 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	vcpu_sys_reg(vcpu, r->reg) = val;
>  }
>  
> +static void reset_pmceid(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +	u64 pmceid;
> +
> +	if (r->reg == PMCEID0_EL0)
> +		asm volatile("mrs %0, pmceid0_el0\n" : "=r" (pmceid));
> +	else
> +		/* PMCEID1_EL0 */
> +		asm volatile("mrs %0, pmceid1_el0\n" : "=r" (pmceid));
> +
> +	vcpu_sys_reg(vcpu, r->reg) = pmceid;
> +}
> +
>  /* PMU registers accessor. */
>  static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>  			    struct sys_reg_params *p,
> @@ -469,6 +482,9 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>  			vcpu_sys_reg(vcpu, r->reg) = val;
>  			break;
>  		}
> +		case PMCEID0_EL0:
> +		case PMCEID1_EL0:
> +			return ignore_write(vcpu, p);
>  		default:
>  			vcpu_sys_reg(vcpu, r->reg) = p->regval;
>  			break;
> @@ -693,10 +709,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  access_pmu_regs, reset_unknown, PMSELR_EL0 },
>  	/* PMCEID0_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b110),
> -	  trap_raz_wi },
> +	  access_pmu_regs, reset_pmceid, PMCEID0_EL0 },
>  	/* PMCEID1_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b111),
> -	  trap_raz_wi },
> +	  access_pmu_regs, reset_pmceid, PMCEID1_EL0 },
>  	/* PMCCNTR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b000),
>  	  trap_raz_wi },
> @@ -926,6 +942,9 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
>  			vcpu_cp15(vcpu, r->reg) = val;
>  			break;
>  		}
> +		case c9_PMCEID0:
> +		case c9_PMCEID1:
> +			return ignore_write(vcpu, p);
>  		default:
>  			vcpu_cp15(vcpu, r->reg) = p->regval;
>  			break;
> @@ -983,8 +1002,10 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmu_cp15_regs,
>  	  NULL, c9_PMSELR },
> -	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), trap_raz_wi },
> -	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), trap_raz_wi },
> +	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmu_cp15_regs,
> +	  NULL, c9_PMCEID0 },
> +	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmu_cp15_regs,
> +	  NULL, c9_PMCEID1 },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), trap_raz_wi },
> 

That's a lot of infrastructure for something that is essentially a
constant that doesn't need to be stored in the sysreg array.
I suggest you drop the constants for PMCEID{0,1}_EL0 and
c9_PMCEID{0,1}, and turn the code into something like this:

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 251d517..09c38d0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -453,17 +453,22 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_sys_reg(vcpu, r->reg) = val;
 }
 
-static void reset_pmceid(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+static bool access_pmceid(struct kvm_vcpu *vcpu,
+			  struct sys_reg_params *p,
+			  const struct sys_reg_desc *r)
 {
 	u64 pmceid;
 
-	if (r->reg == PMCEID0_EL0)
+	if (p->is_write)
+		return ignore_write(vcpu, p);
+
+	if (!(p->Op2 & 1))
 		asm volatile("mrs %0, pmceid0_el0\n" : "=r" (pmceid));
 	else
-		/* PMCEID1_EL0 */
 		asm volatile("mrs %0, pmceid1_el0\n" : "=r" (pmceid));
 
-	vcpu_sys_reg(vcpu, r->reg) = pmceid;
+	p->regval = pmceid;
+	return true;
 }
 
 static bool pmu_counter_idx_valid(u64 pmcr, u64 idx)
@@ -624,9 +629,6 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 			kvm_pmu_handle_pmcr(vcpu, val);
 			break;
 		}
-		case PMCEID0_EL0:
-		case PMCEID1_EL0:
-			return ignore_write(vcpu, p);
 		default:
 			vcpu_sys_reg(vcpu, r->reg) = p->regval;
 			break;
@@ -873,10 +875,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmu_regs, reset_unknown, PMSELR_EL0 },
 	/* PMCEID0_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b110),
-	  access_pmu_regs, reset_pmceid, PMCEID0_EL0 },
+	  access_pmceid },
 	/* PMCEID1_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b111),
-	  access_pmu_regs, reset_pmceid, PMCEID1_EL0 },
+	  access_pmceid },
 	/* PMCCNTR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b000),
 	  access_pmu_regs, reset_unknown, PMCCNTR_EL0 },
@@ -1223,9 +1225,6 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 			kvm_pmu_handle_pmcr(vcpu, val);
 			break;
 		}
-		case c9_PMCEID0:
-		case c9_PMCEID1:
-			return ignore_write(vcpu, p);
 		default:
 			vcpu_cp15(vcpu, r->reg) = p->regval;
 			break;
@@ -1310,10 +1309,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 	  NULL, c9_PMSWINC },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmu_cp15_regs,
 	  NULL, c9_PMSELR },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmu_cp15_regs,
-	  NULL, c9_PMCEID0 },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmu_cp15_regs,
-	  NULL, c9_PMCEID1 },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), access_pmu_cp15_regs,
 	  NULL, c9_PMCCNTR },
 	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_pmxevtyper },

All we need is an accessor, nothing else.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
