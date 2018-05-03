From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2 11/17] kvm: arm64: Configure VTCR per VM
Date: Thu, 3 May 2018 15:39:18 +0100
Message-ID: <1175bc06-14b1-63e4-7b99-55c22db1c451@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
 <1522156531-28348-12-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522156531-28348-12-git-send-email-suzuki.poulose@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, cdall@kernel.org, marc.zyngier@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, ard.biesheuvel@linaro.org, peter.maydell@linaro.org, kristina.martsenko@arm.com, mark.rutland@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

On 27/03/18 14:15, Suzuki K Poulose wrote:
> We set VTCR_EL2 very early during the stage2 init and don't
> touch it ever. This is fine as we had a fixed IPA size. This
> patch changes the behavior to set the VTCR for a given VM,
> depending on its stage2 table. The common configuration for
> VTCR is still performed during the early init as we have to
> retain the hardware access flag update bits (VTCR_EL2_HA)
> per CPU (as they are only set for the CPUs which are capabile).
> The bits defining the number of levels in the page table (SL0)
> and and the size of the Input address to the translation (T0SZ)
> are programmed for each VM upon entry to the guest.


> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 596f8e4..9f3c8b8 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -392,10 +392,12 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>  
>  static inline void __cpu_init_stage2(void)
>  {
> -	u32 parange = kvm_call_hyp(__init_stage2_translation);
> +	u32 ps;
>  
> -	WARN_ONCE(parange < 40,
> -		  "PARange is %d bits, unsupported configuration!", parange);
> +	kvm_call_hyp(__init_stage2_translation);
> +	ps = id_aa64mmfr0_parange_to_phys_shift(read_sysreg(id_aa64mmfr0_el1));

Doesn't id_aa64mmfr0_parange_to_phys_shift() expect you do to the mask and shift
for it? This will always hit the default case.


> +	WARN_ONCE(ps < 40,
> +		  "PARange is %d bits, unsupported configuration!", ps);
>  }



Thanks,

James
