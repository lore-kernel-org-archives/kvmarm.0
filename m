From: Wei Huang <wei@redhat.com>
Subject: Re: [PATCH v3 15/20] KVM: ARM64: Add reset and access handlers for
 PMSWINC register
Date: Fri, 16 Oct 2015 10:25:54 -0500
Message-ID: <56211702.6060908@redhat.com>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
 <1443133885-3366-16-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1443133885-3366-16-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, will.deacon@arm.com, alex.bennee@linaro.org, peter.huangpeng@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 09/24/2015 05:31 PM, Shannon Zhao wrote:
> Add access handler which emulates writing and reading PMSWINC
> register and add support for creating software increment event.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 18 +++++++++++++++++-
>  include/kvm/arm_pmu.h     |  2 ++
>  virt/kvm/arm/pmu.c        | 33 +++++++++++++++++++++++++++++++++
>  3 files changed, 52 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 749e1e2..dd790c7 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -543,6 +543,11 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>  			vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= ~val;
>  			break;
>  		}
> +		case PMSWINC_EL0: {
> +			val = *vcpu_reg(vcpu, p->Rt);
> +			kvm_pmu_software_increment(vcpu, val);
> +			break;
> +		}
>  		case PMCR_EL0: {
>  			/* Only update writeable bits of PMCR */
>  			val = vcpu_sys_reg(vcpu, r->reg);
> @@ -572,6 +577,8 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>  			*vcpu_reg(vcpu, p->Rt) = val;
>  			break;
>  		}
> +		case PMSWINC_EL0:
> +			return read_zero(vcpu, p);
>  		default:
>  			*vcpu_reg(vcpu, p->Rt) = vcpu_sys_reg(vcpu, r->reg);
>  			break;
> @@ -784,7 +791,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  access_pmu_regs, reset_unknown, PMOVSCLR_EL0 },
>  	/* PMSWINC_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b100),
> -	  trap_raz_wi },
> +	  access_pmu_regs, reset_unknown, PMSWINC_EL0 },
>  	/* PMSELR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b101),
>  	  access_pmu_regs, reset_unknown, PMSELR_EL0 },
> @@ -1070,6 +1077,11 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
>  			vcpu_cp15(vcpu, c9_PMOVSSET) &= ~val;
>  			break;
>  		}
> +		case c9_PMSWINC: {
> +			val = *vcpu_reg(vcpu, p->Rt);
> +			kvm_pmu_software_increment(vcpu, val);
> +			break;
> +		}
>  		case c9_PMCR: {
>  			/* Only update writeable bits of PMCR */
>  			val = vcpu_cp15(vcpu, r->reg);
> @@ -1099,6 +1111,8 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
>  			*vcpu_reg(vcpu, p->Rt) = val;
>  			break;
>  		}
> +		case c9_PMSWINC:
> +			return read_zero(vcpu, p);
>  		default:
>  			*vcpu_reg(vcpu, p->Rt) = vcpu_cp15(vcpu, r->reg);
>  			break;
> @@ -1144,6 +1158,8 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	  reset_unknown_cp15, c9_PMCNTENCLR },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), access_pmu_cp15_regs,
>  	  reset_unknown_cp15, c9_PMOVSCLR },
> +	{ Op1( 0), CRn( 9), CRm(12), Op2( 4), access_pmu_cp15_regs,
> +	  reset_unknown_cp15, c9_PMSWINC },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmu_cp15_regs,
>  	  reset_unknown_cp15, c9_PMSELR },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmu_cp15_regs,
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 9b4ee5e..9293133 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -41,6 +41,7 @@ struct kvm_pmu {
>  unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx);
>  void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val);
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val);
> +void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u32 val);
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
>  				    u32 select_idx);
>  #else
> @@ -50,6 +51,7 @@ unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
>  }
>  void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val) {}
>  void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val) {}
> +void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u32 val) {}
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
>  				    u32 select_idx) {}
>  #endif
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 46145d1..18637c9 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -134,6 +134,35 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val)
>  }
>  
>  /**
> + * kvm_pmu_software_increment - do software increment
> + * @vcpu: The vcpu pointer
> + * @val: the value guest writes to PMSWINC register
> + */
> +void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u32 val)
> +{
> +	int i;
> +	u32 type, enable;
> +
> +	for (i = 0; i < 32; i++) {
> +		if ((val >> i) & 0x1) {
> +			if (!vcpu_mode_is_32bit(vcpu)) {
> +				type = vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i)
> +				       & ARMV8_EVTYPE_EVENT;
> +				enable = vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
> +				if ((type == 0) && ((enable >> i) & 0x1))
> +					vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i)++;

Most parts make sense here. I just wonder about the case of counter
overflow here. Should we trigger an interrupt and set Overflow Flag
status register when SW increment overflows here? I didn't find anything
in ARM document.

> +			} else {
> +				type = vcpu_cp15(vcpu, c14_PMEVTYPER0 + i)
> +				       & ARMV8_EVTYPE_EVENT;
> +				enable = vcpu_cp15(vcpu, c9_PMCNTENSET);
> +				if ((type == 0) && ((enable >> i) & 0x1))
> +					vcpu_cp15(vcpu, c14_PMEVCNTR0 + i)++;
> +			}
> +		}
> +	}
> +}
> +
> +/**
>   * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
>   * @vcpu: The vcpu pointer
>   * @data: The data guest writes to PMXEVTYPER_EL0
> @@ -165,6 +194,10 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
>  	kvm_pmu_stop_counter(vcpu, select_idx);
>  	kvm_pmu_set_evttyper(vcpu, select_idx, data);
>  
> +	/* For software increment event it does't need to create perf event */
> +	if (new_eventsel == 0)
> +		return;
> +
>  	memset(&attr, 0, sizeof(struct perf_event_attr));
>  	attr.type = PERF_TYPE_RAW;
>  	attr.size = sizeof(attr);
> 
