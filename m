From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2] arm64: Add ASM modifier for xN register operands
Date: Fri, 28 Apr 2017 10:53:51 +0100
Message-ID: <20170428095349.GA22161@leverpostej>
References: <20170426214616.142580-1-mka@chromium.org>
 <20170427110256.GC31337@leverpostej>
 <20170427225221.GS128305@google.com>
 <CAKv+Gu9s2t+Nt7JCcTxkr5BYSN05f_zxYkKzfrD-4owWQLvF_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FF4940D77
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Apr 2017 05:51:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nDrPqXqSc9ms for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Apr 2017 05:51:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D65D40D76
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Apr 2017 05:51:32 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9s2t+Nt7JCcTxkr5BYSN05f_zxYkKzfrD-4owWQLvF_Q@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Greg Hackmann <ghackmann@google.com>, Michael Davidson <md@google.com>, Grant Grundler <grundler@chromium.org>, Matthias Kaehlcke <mka@chromium.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Lameter <cl@linux.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 28, 2017 at 08:18:52AM +0100, Ard Biesheuvel wrote:
> On 27 April 2017 at 23:52, Matthias Kaehlcke <mka@chromium.org> wrote:
> > El Thu, Apr 27, 2017 at 12:02:56PM +0100 Mark Rutland ha dit:
> >> On Wed, Apr 26, 2017 at 02:46:16PM -0700, Matthias Kaehlcke wrote:

> >> > -   asm volatile("strb %w0, [%1]" : : "rZ" (val), "r" (addr));
> >> > +   asm volatile("strb %w0, [%x1]" : : "rZ" (val), "r" (addr));
> >>
> >> In general, the '[%xN]' pattern looks *very* suspicious to me. Any
> >> address must be 64-bit, so this would mask a legitimate warning.
> >>
> >> Given the prototype of this function the code if fine either way, but
> >> were we to refactor things (e.g. making this a macro), that might not be
> >> true.
> >>
> >> ... so I'm not sure it make sense to alter instances used for addresses.
> >
> > Good point, I'll leave instances dealing with addresses untouched for now.
> >
> 
> OK, I am confused now. We started this thread under the assumption
> that all unqualified placeholders are warned about by Clang. Given
> that this appears not to be the case, could we please first find out
> what causes the warnings?

Yes please.

> Is it necessary at all to add the x modifiers for 64-bit types?

Having delved a little deeper, I think this is actively harmful, and
clang's warning indicates potential problems even when compiling with
GCC.

The below test simulates how we might write to control regs and so on,
with a mov in asm simulating something like an msr.

---->8----
#include <stdio.h>

static inline unsigned long generate_val(void)
{
        unsigned long val;

        /* hide value generation from GCC */
        asm (
                "movn %0, #0"
                : "=r" (val)
        );

        return val;
}

static inline unsigned long use_val_32(unsigned int in)
{
        unsigned long out;

	/* simulate what we might write to a sysreg */
        asm (
                "mov %x0, %x1"
                : "=r" (out)
                : "r" (in)
        );

        return out;
}

int main(int argc, char *argv)
{
        printf("32-bit val is: 0x%016lx\n", use_val_32(generate_val()));

        return 0;
}
---->8----

Depending on optimization level, bits that we do not expect can flow through:

$ gcc test.c -o test
$ ./test
32-bit val is: 0x00000000ffffffff
$ gcc test.c -O1 -o test
$ ./test
32-bit val is: 0xffffffffffffffff
$ gcc test.c -O2 -o test
$ ./test
32-bit val is: 0xffffffffffffffff

... that could be disastrous depending on how the result was used.

With "in" cast to an unsigned long, the compiler realises it needs to perform
any necessary truncation itself:

$ gcc test.c -o test
$ ./test
32-bit val is: 0x00000000ffffffff
$ gcc test.c -O1 -o test
$ ./test
32-bit val is: 0x00000000ffffffff
$ gcc test.c -O2 -o test
$ ./test
32-bit val is: 0x00000000ffffffff
$ gcc test.c -O3 -o test
$ ./test
32-bit val is: 0x00000000ffffffff

I think that the correct fix is to use intermediate 64-bit variables, or
casts, so that the compiler *must* use an x register, and consequently
guarantees that all 64-bits of the register are as we expect.

Thanks,
Mark.
