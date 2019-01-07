From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 4/11] KVM/MMU: Introduce tlb flush with range list
Date: Mon, 7 Jan 2019 17:39:33 +0100
Message-ID: <2c6f7a11-b406-d4f1-c934-e6dedf5b07fd@redhat.com>
References: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
 <20190104085405.40356-5-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190104085405.40356-5-Tianyu.Lan@microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: lantianyu1986@gmail.com
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, paulus@ozlabs.org, hpa@zytor.com, kys@microsoft.com, kvmarm@lists.cs.columbia.edu, mpe@ellerman.id.au, x86@kernel.org, linux@armlinux.org.uk, michael.h.kelley@microsoft.com, mingo@redhat.com, benh@kernel.crashing.org, jhogan@kernel.org, linux-mips@vger.kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, kvm-ppc@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, ralf@linux-mips.org, paul.burton@mips.com, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/01/19 09:53, lantianyu1986@gmail.com wrote:
>  struct kvm_mmu_page {
>  	struct list_head link;
> +
> +	/*
> +	 * Tlb flush with range list uses struct kvm_mmu_page as list entry
> +	 * and all list operations should be under protection of mmu_lock.
> +	 */
> +	struct list_head flush_link;
>  	struct hlist_node hash_link;
>  	bool unsync;
>  
> @@ -443,6 +449,7 @@ struct kvm_mmu {

Again, it would be nice not to grow the struct too much, though I
understand that it's already relatively big (168 bytes).

Can you at least make this an hlist, so that it only takes a single word?

Paolo
