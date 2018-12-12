From: Paul Mackerras <paulus@ozlabs.org>
Subject: Re: [Resend PATCH V5 7/10] KVM: Make kvm_set_spte_hva() return int
Date: Wed, 12 Dec 2018 16:03:53 +1100
Message-ID: <20181212050353.GF22265@blackberry>
References: <20181206132113.2691-1-Tianyu.Lan@microsoft.com>
 <20181206132113.2691-8-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181206132113.2691-8-Tianyu.Lan@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: lantianyu1986@gmail.com
Cc: Lan Tianyu <Tianyu.Lan@microsoft.com>, christoffer.dall@arm.com, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, jhogan@kernel.org, ralf@linux-mips.org, paul.burton@mips.com, benh@kernel.crashing.org, mpe@ellerman.id.au, pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, michael.h.kelley@microsoft.com, kys@microsoft.com, vkuznets@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 06, 2018 at 09:21:10PM +0800, lantianyu1986@gmail.com wrote:
> From: Lan Tianyu <Tianyu.Lan@microsoft.com>
> 
> The patch is to make kvm_set_spte_hva() return int and caller can
> check return value to determine flush tlb or not.

It would be helpful if the patch description told the reader which
return value(s) mean that the caller should flush the tlb.  I would
guess that non-zero means to do the flush, but you should make that
explicit.

> Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>

For the powerpc bits:

Acked-by: Paul Mackerras <paulus@ozlabs.org>
