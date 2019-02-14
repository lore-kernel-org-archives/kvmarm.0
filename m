From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH V2 3/10] KVM/MMU: Add last_level in the struct
 mmu_spte_page
Date: Thu, 14 Feb 2019 17:12:10 +0100
Message-ID: <34503144-fb31-8c02-9ac2-eedc1d95e80d@redhat.com>
References: <20190202013825.51261-1-Tianyu.Lan@microsoft.com>
 <20190202013825.51261-4-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190202013825.51261-4-Tianyu.Lan@microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: lantianyu1986@gmail.com
Cc: Lan Tianyu <Tianyu.Lan@microsoft.com>, christoffer.dall@arm.com, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, jhogan@kernel.org, ralf@linux-mips.org, paul.burton@mips.com, paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au, rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, michael.h.kelley@microsoft.com, kys@microsoft.com, vkuznets@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 02/02/19 02:38, lantianyu1986@gmail.com wrote:
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index ce770b446238..70cafd3f95ab 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2918,6 +2918,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  
>  	if (level > PT_PAGE_TABLE_LEVEL)
>  		spte |= PT_PAGE_SIZE_MASK;
> +
> +	sp->last_level = is_last_spte(spte, level);

sp->last_level is always true here.

Paolo

>  	if (tdp_enabled)
>  		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
>  			kvm_is_mmio_pfn(pfn));
