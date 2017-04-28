From: Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [PATCH v2] arm64: Add ASM modifier for xN register operands
Date: Fri, 28 Apr 2017 12:08:15 -0700
Message-ID: <20170428190815.GT128305@google.com>
References: <20170426214616.142580-1-mka@chromium.org>
 <20170427110256.GC31337@leverpostej>
 <20170427225221.GS128305@google.com>
 <CAKv+Gu9s2t+Nt7JCcTxkr5BYSN05f_zxYkKzfrD-4owWQLvF_Q@mail.gmail.com>
 <20170428143333.GA5292@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3375D412A6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Apr 2017 15:05:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U48ESsR3epI1 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Apr 2017 15:05:22 -0400 (EDT)
Received: from mail-pg0-f52.google.com (mail-pg0-f52.google.com [74.125.83.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 16A1240DAC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Apr 2017 15:05:21 -0400 (EDT)
Received: by mail-pg0-f52.google.com with SMTP id y4so13821573pge.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Apr 2017 12:08:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170428143333.GA5292@leverpostej>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Greg Hackmann <ghackmann@google.com>, Michael Davidson <md@google.com>, Grant Grundler <grundler@chromium.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Lameter <cl@linux.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

El Fri, Apr 28, 2017 at 03:33:33PM +0100 Mark Rutland ha dit:

> On Fri, Apr 28, 2017 at 08:18:52AM +0100, Ard Biesheuvel wrote:
> > On 27 April 2017 at 23:52, Matthias Kaehlcke <mka@chromium.org> wrote:
> > > El Thu, Apr 27, 2017 at 12:02:56PM +0100 Mark Rutland ha dit:
> > >> On Wed, Apr 26, 2017 at 02:46:16PM -0700, Matthias Kaehlcke wrote:
> > >> > Many inline assembly statements don't include the 'x' modifier when
> > >> > using xN registers as operands. This is perfectly valid, however it
> > >> > causes clang to raise warnings like this:
> > >> >
> > >> > warning: value size does not match register size specified by the
> > >> >   constraint and modifier [-Wasm-operand-widths]
> 
> [...]
> 
> > >> > -   asm volatile("strb %w0, [%1]" : : "rZ" (val), "r" (addr));
> > >> > +   asm volatile("strb %w0, [%x1]" : : "rZ" (val), "r" (addr));
> > >>
> > >> In general, the '[%xN]' pattern looks *very* suspicious to me. Any
> > >> address must be 64-bit, so this would mask a legitimate warning.
> > >>
> > >> Given the prototype of this function the code if fine either way, but
> > >> were we to refactor things (e.g. making this a macro), that might not be
> > >> true.
> > >>
> > >> ... so I'm not sure it make sense to alter instances used for addresses.
> > >
> > > Good point, I'll leave instances dealing with addresses untouched for now.
> > >
> > 
> > OK, I am confused now. We started this thread under the assumption
> > that all unqualified placeholders are warned about by Clang. Given
> > that this appears not to be the case, could we please first find out
> > what causes the warnings? Is it necessary at all to add the x
> > modifiers for 64-bit types?
> 
> FWIW, I grabbed a clang 4.0.0 binary and had a play.
> 
> It looks like clang only warns when an operand is less than 64 bits
> wide, and there is no 'x' or 'w' modifier. Pointers a 64 bits wide, so
> never produce a warning.
> 
> As far as I can tell, applying to both integers and pointers:
> 
> * GCC and clang always treat %N as meaning xN for an r constraint, and
>   you need to use %wN to get wN.
> 
> * If an operand type is 64 bits in size, clang will not produce a warning
>   regarding the operand size.
> 
> * If an x or w modifier is used, clang will not produce a warning
>   regarding the operand size, regardless of whether it matches the
>   register size. Clang is happy for %wN to be used on a pointer type.
> 
> * If an operand type is less than 64 bits in size, and neither an x or
>   w modifier is used, clang will produce a warning as above.
> 
> * If an operand type is greater than 64 bits in size, clang encounters
>   an internal error.
> 
> Given that, I think we *should not* use the x modifier to suppress this
> warning, as I think for those cases we have a potential bug as outlined
> in my prior reply.
> 
> Instead, we should use a temporary 64-bit variable (or cast input
> operands to 64-bit), which avoids that and makes clang happy.
> 
> I've included my test below. Note that clang will produce other errors for
> invalid asm (e.g. for mov w0, x0).

Thanks for your investigation!

I apologize for the noise, my expertise with inline assembly is
extremely limited, and admittedly I need a bit of handholding in this
area. Not without reason changes like this or the prefetch code are at
the very top of my clang stack (i.e. postponed until the other less
scary issues were solved). Hopefully the discussion was still useful.

I'll prepare a short patch that only fixes the warnings encountered in
my build in the way you suggested.

Thanks

Matthias
