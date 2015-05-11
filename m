From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2] ARM: kvm: fix a bad BSYM() usage
Date: Mon, 11 May 2015 11:44:49 +0200
Message-ID: <CAKv+Gu9mbytGHZvi=tt9eGwngzRq0r_V6Cwvk0aDRTsH8JtRXQ@mail.gmail.com>
References: <E1YqkpO-0006zB-QJ@rmk-PC.arm.linux.org.uk>
	<20150509200717.GA30634@cbox>
	<CAKv+Gu922cZLGUJ3-g8CJiUCuL-5L=XHPfgXUMo-jrdPKAuokA@mail.gmail.com>
	<20150511090537.GA2009@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150511090537.GA2009@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, KVM devel mailing list <kvm@vger.kernel.org>, Nicolas Pitre <nico@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Dave P Martin <Dave.Martin@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 11 May 2015 at 11:05, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> On Sat, May 09, 2015 at 10:10:56PM +0200, Ard Biesheuvel wrote:
>> On 9 May 2015 at 22:07, Christoffer Dall <christoffer.dall@linaro.org> wrote:
>> > On Fri, May 08, 2015 at 05:08:42PM +0100, Russell King wrote:
>> >> BSYM() should only be used when refering to local symbols in the same
>> >> assembly file which are resolved by the assembler, and not for
>> >> linker-fixed up symbols.  The use of BSYM() with panic is incorrect as
>> >> the linker is involved in fixing up this relocation, and it knows
>> >> whether panic() is ARM or Thumb.
>> >>
>> >> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
>> >> ---
>> >>  arch/arm/kvm/interrupts.S | 2 +-
>> >>  1 file changed, 1 insertion(+), 1 deletion(-)
>> >>
>> >> diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
>> >> index 79caf79b304a..87847d2c5f99 100644
>> >> --- a/arch/arm/kvm/interrupts.S
>> >> +++ b/arch/arm/kvm/interrupts.S
>> >> @@ -309,7 +309,7 @@ ENTRY(kvm_call_hyp)
>> >>  THUMB(       orr     r2, r2, #PSR_T_BIT      )
>> >>       msr     spsr_cxsf, r2
>> >>       mrs     r1, ELR_hyp
>> >> -     ldr     r2, =BSYM(panic)
>> >> +     ldr     r2, =panic
>> >>       msr     ELR_hyp, r2
>> >>       ldr     r0, =\panic_str
>> >>       clrex                           @ Clear exclusive monitor
>> >> --
>> >> 1.8.3.1
>> >>
>> > Indeed, the linker figures it out as it should.  It does seem like the
>> > right result is produced with the BSYM() macro as well so not sure what
>> > the harm is.
>> >
>>
>> BSYM() is defined as 'sym + 1' not 'sym | 1', so if the symbol has the
>> thumb bit set already, the result is incorrect.
>>
> yeah, but the linker will look at the result of 'sym + 1', so on my
> system it ends up with 'sym + 1' after the linker has done its thing
> (verified by looking at the disassembly of vmlinux);

Hmm, I though had done the same when this was under discussion a
couple of weeks ago, and had arrived at the opposite conclusion, but
now I cannot reproduce anymore so apparently not.
Sorry for the noise.

> I assume the
> linker logic is that it's branching to a thumb function but the target
> is already the +1 so no action necessary, as opposed to just blindly
> adding 1.
>
> -Christoffer
