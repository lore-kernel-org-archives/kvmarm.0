From: Tianyu Lan <lantianyu1986@gmail.com>
Subject: Re: [Resend PATCH V5 7/10] KVM: Make kvm_set_spte_hva() return int
Date: Thu, 13 Dec 2018 15:47:31 +0800
Message-ID: <CAOLK0pyKsS2hLagZ6pumMdfRokPig2P+KJambVOq7p+NU-OqgA@mail.gmail.com>
References: <20181206132113.2691-1-Tianyu.Lan@microsoft.com>
 <20181206132113.2691-8-Tianyu.Lan@microsoft.com> <20181212050353.GF22265@blackberry>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181212050353.GF22265@blackberry>
Sender: linux-kernel-owner@vger.kernel.org
To: paulus@ozlabs.org
Cc: Tianyu Lan <Tianyu.Lan@microsoft.com>, christoffer.dall@arm.com, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, jhogan@kernel.org, ralf@linux-mips.org, paul.burton@mips.com, benh@kernel.crashing.org, mpe@ellerman.id.au, Paolo Bonzini <pbonzini@redhat.com>, Radim Krcmar <rkrcmar@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, bp@alien8.de, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm <kvm@vger.kernel.org>, michael.h.kelley@microsoft.com, kys@
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paul:
             Thanks for your review.
On Wed, Dec 12, 2018 at 1:03 PM Paul Mackerras <paulus@ozlabs.org> wrote:
>
> On Thu, Dec 06, 2018 at 09:21:10PM +0800, lantianyu1986@gmail.com wrote:
> > From: Lan Tianyu <Tianyu.Lan@microsoft.com>
> >
> > The patch is to make kvm_set_spte_hva() return int and caller can
> > check return value to determine flush tlb or not.
>
> It would be helpful if the patch description told the reader which
> return value(s) mean that the caller should flush the tlb.  I would
> guess that non-zero means to do the flush, but you should make that
> explicit.

OK. Thanks for suggestion and will update in the next version.

>
> > Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
>
> For the powerpc bits:
>
> Acked-by: Paul Mackerras <paulus@ozlabs.org>



-- 
Best regards
Tianyu Lan
