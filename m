From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 2/7] lib: arm: Remove warning about
 uart0_base mismatch
Date: Tue, 29 Jan 2019 13:23:23 +0100
Message-ID: <20190129122323.bdevmczzyafnzhsl@kamzik.brq.redhat.com>
References: <20190124111634.4727-1-alexandru.elisei@arm.com>
 <20190124111634.4727-3-alexandru.elisei@arm.com>
 <20190124115943.12296810@donnerap.cambridge.arm.com>
 <20190124123740.v52nkbcki5dp2hpq@kamzik.brq.redhat.com>
 <ffcc5f60-c5a0-c7f1-7fb1-658d8eea6fc4@arm.com>
 <20190125164751.cdfip3kv63uonl7n@kamzik.brq.redhat.com>
 <42b3a17b-088b-b9b7-4dac-34f07aa09c8a@arm.com>
 <20190128163101.dajq6ofgmpctg3ne@kamzik.brq.redhat.com>
 <39bc7b61-ddac-3180-2cb8-410e1d400cb3@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 279EB4A36D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 07:23:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L+oQ8UgVFSl0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 07:23:28 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E2294A36B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 07:23:28 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <39bc7b61-ddac-3180-2cb8-410e1d400cb3@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 29, 2019 at 11:16:05AM +0000, Alexandru Elisei wrote:
> On 1/28/19 4:31 PM, Andrew Jones wrote:
> > On Mon, Jan 28, 2019 at 02:24:29PM +0000, Alexandru Elisei wrote:
> >> On 1/25/19 4:47 PM, Andrew Jones wrote:
> >>> On Fri, Jan 25, 2019 at 04:36:13PM +0000, Alexandru Elisei wrote:
> >>>> On 1/24/19 12:37 PM, Andrew Jones wrote:
> >>>>> On Thu, Jan 24, 2019 at 11:59:43AM +0000, Andre Przywara wrote:
> >>>>>> On Thu, 24 Jan 2019 11:16:29 +0000
> >>>>>> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >>>>>>
> >>>>>>> A warning is displayed if uart0_base is different from what the c=
ode
> >>>>>>> expects qemu to generate for the pl011 UART in the device tree.
> >>>>>>> However, now we support the ns16550a UART emulated by kvmtool, wh=
ich
> >>>>>>> has a different address. This leads to the  warning being display=
ed
> >>>>>>> even though the UART is configured and working as expected.
> >>>>>>>
> >>>>>>> Now that we support multiple UARTs, the warning serves no purpose=
, so
> >>>>>>> remove it.
> >>>>>> Mmh, but we use that address before, right? So for anything not
> >>>>>> emulating an UART at this QEMU specific address we write to some r=
andom
> >>>>>> (device) memory?
> >>>>>>
> >>>>>> Drew, how important is this early print feature for kvm-unit-tests?
> >>>>> The setup code passes through quite a few asserts before getting th=
rough
> >>>>> io_init() (including in uart0_init), so I think there's still value=
 in
> >>>>> having a guessed UART address. Maybe we can provide guesses for both
> >>>>> QEMU and kvmtool, and some selection method, that would be used unt=
il
> >>>>> we've properly assigned uart0_base from DT?
> >>>>>
> >>>>>> Cheers,
> >>>>>> Andre.
> >>>>>>
> >>>>>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >>>>>>> ---
> >>>>>>>  lib/arm/io.c | 6 ------
> >>>>>>>  1 file changed, 6 deletions(-)
> >>>>>>>
> >>>>>>> diff --git a/lib/arm/io.c b/lib/arm/io.c
> >>>>>>> index 35fc05aeb4db..87435150f73e 100644
> >>>>>>> --- a/lib/arm/io.c
> >>>>>>> +++ b/lib/arm/io.c
> >>>>>>> @@ -61,12 +61,6 @@ static void uart0_init(void)
> >>>>>>>  	}
> >>>>>>>  =

> >>>>>>>  	uart0_base =3D ioremap(base.addr, base.size);
> >>>>>>> -
> >>>>>>> -	if (uart0_base !=3D (u8 *)UART_EARLY_BASE) {
> >>>>>>> -		printf("WARNING: early print support may not work. "
> >>>>>>> -		       "Found uart at %p, but early base is %p.\n",
> >>>>>>> -			uart0_base, (u8 *)UART_EARLY_BASE);
> >>>>>>> -	}
> >>>>>>>  }
> >>>>> This warning is doing what it should, which is pointing out that the
> >>>>> UART_EARLY_BASE guess appears to be wrong. If we can provide a way
> >>>>> to support more than one guess, then we should keep this warning but
> >>>>> adjust it to match one of any of the guesses.
> >>>>>
> >>>>> Thanks,
> >>>>> drew
> >>>> I'm not really sure how to implement a selection method. I've looked=
 at
> >>>> splitting io_init() into uart0_init() and chr_testdev_init() and cal=
ling
> >>>> uart0_init() very early in the setup process, but uart0_init() itsel=
f uses
> >>>> printf() and assert().
> >>>>
> >>>> I've also thought about adding another function, something like
> >>>> uart0_early_init(), that is called very early in setup() and gets th=
e base
> >>>> address from the dtb bootargs. But that means calling dt_init() and
> >>>> dt_get_bootargs(), which can fail.
> >>>>
> >>>> One other option that could work is to make it a compile-time config=
uration.
> >>>>
> >>>> What do you think?
> >>>>
> >>> Compile-time is fine, which I guess will result in a new configure sc=
ript
> >>> option as well. I wonder if we shouldn't consider generating a config=
.h
> >>> file with stuff like this rather than adding another -D to the compile
> >>> line.
> >>>
> >>> drew =

> >> I propose a new configuration option called --vmm, with possible value=
s qemu and
> >> kvmtool, which defaults to qemu if not set.
> >>
> >> Another possibility would be to have an --uart-base option, but that m=
eans we
> >> are expecting the user to be aware of the uart base address for the vi=
rtual
> >> machine manager, which might be unreasonable.
> >>
> >> This is a quick prototype of how using -D for conditional compilation =
would look
> >> like (the configure changes are included too):
> >>
> >> diff --git a/configure b/configure
> >> index df8581e3a906..7a56ba47707f 100755
> >> --- a/configure
> >> +++ b/configure
> >> @@ -70,6 +70,9 @@ while [[ "$1" =3D -* ]]; do
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ;;
> >> =A0=A0=A0=A0=A0=A0=A0 --ld)
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ld=3D"$arg"
> >> +=A0=A0=A0=A0=A0=A0=A0 ;;
> >> +=A0=A0=A0 --vmm)
> >> +=A0=A0=A0=A0=A0=A0=A0 vmm=3D"$arg"
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ;;
> >> =A0=A0=A0=A0=A0=A0=A0 --enable-pretty-print-stacks)
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pretty_print_stacks=3Dyes
> >> @@ -108,6 +111,14 @@ if [ "$arch" =3D "i386" ] || [ "$arch" =3D "x86_6=
4" ]; then
> >> =A0=A0=A0=A0 testdir=3Dx86
> >> =A0elif [ "$arch" =3D "arm" ] || [ "$arch" =3D "arm64" ]; then
> >> =A0=A0=A0=A0 testdir=3Darm
> >> +=A0=A0=A0 if [ -z "$vmm" ] || [ "$vmm" =3D "qemu" ]; then
> >> +=A0=A0=A0=A0=A0=A0=A0 uart_early_base=3D0x09000000UL
> > You can drop the 'UL'.
> >
> >> +=A0=A0=A0 elif [ "$vmm" =3D "kvmtool" ]; then
> >> +=A0=A0=A0=A0=A0=A0=A0 uart_early_base=3D0x3f8
> >> +=A0=A0=A0 else
> >> +=A0=A0=A0=A0=A0=A0=A0 echo '--vmm must be one of "qemu" or "kvmtool"'
> >> +=A0=A0=A0=A0=A0=A0=A0 usage
> > You're outputting usage here, but you didn't add vmm to the help text.
> >
> >> +=A0=A0=A0 fi
> >> =A0elif [ "$arch" =3D "ppc64" ]; then
> >> =A0=A0=A0=A0 testdir=3Dpowerpc
> >> =A0=A0=A0=A0 firmware=3D"$testdir/boot_rom.bin"
> >> @@ -197,4 +208,5 @@ PRETTY_PRINT_STACKS=3D$pretty_print_stacks
> >> =A0ENVIRON_DEFAULT=3D$environ_default
> >> =A0ERRATATXT=3Derrata.txt
> >> =A0U32_LONG_FMT=3D$u32_long
> >> +UART_EARLY_BASE=3D$uart_early_base
> >> =A0EOF
> >> diff --git a/Makefile b/Makefile
> >> index e9f02272e156..225c2a525cdf 100644
> >> --- a/Makefile
> >> +++ b/Makefile
> >> @@ -72,6 +72,10 @@ COMMON_CFLAGS +=3D $(fno_pic) $(no_pie)
> >> =A0CFLAGS +=3D $(COMMON_CFLAGS)
> >> =A0CFLAGS +=3D -Wmissing-parameter-type -Wold-style-declaration -Wover=
ride-init
> >> =A0
> >> +ifneq ($(UART_EARLY_BASE),)
> >> +CFLAGS +=3D -DUART_EARLY_BASE=3D$(UART_EARLY_BASE)
> >> +endif
> > This type of thing is what I would like to avoid by introducing a
> > config.h file. In the least we shouldn't add this -D to CFLAGS for
> > all architectures. It can be added to the %.elf rule in
> > arm/Makefile.common
> >
> >> +
> >> =A0CXXFLAGS +=3D $(COMMON_CFLAGS)
> >> =A0
> >> =A0autodepend-flags =3D -MMD -MF $(dir $*).$(notdir $*).d
> >>
> > You'll also want to patch lib/arm/io.c with
> >  =

> > -/*
> > - * Use this guess for the pl011 base in order to make an attempt at
> > - * having earlier printf support. We'll overwrite it with the real
> > - * base address that we read from the device tree later. This is
> > - * the address we expect QEMU's mach-virt machine type to put in
> > - * its generated device tree.
> > - */
> > -#define UART_EARLY_BASE 0x09000000UL
> > -
> >  static struct spinlock uart_lock;
> > -static volatile u8 *uart0_base =3D (u8 *)UART_EARLY_BASE;
> > +static volatile u8 *uart0_base =3D (u8 *)(unsigned long)UART_EARLY_BAS=
E;
> >
> >
> >
> > This is all a bit on the ugly side, but I can't think of anything
> > better. =

> >
> > Thanks,
> > drew
> =

> I've also tried doing it by generating config.h This is what I came up wi=
th:
> =

> diff --git a/configure b/configure
> index df8581e3a906..d77b8b0d82fa 100755
> --- a/configure
> +++ b/configure
> @@ -16,6 +16,7 @@ endian=3D""
> =A0pretty_print_stacks=3Dyes
> =A0environ_default=3Dyes
> =A0u32_long=3D
> +vmm=3Dqemu
> =A0
> =A0usage() {
> =A0=A0=A0=A0 cat <<-EOF
> @@ -23,6 +24,8 @@ usage() {
> =A0
> =A0=A0=A0=A0=A0=A0=A0 Options include:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 --arch=3DARCH=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 architecture to compile for ($arch)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 --vmm=3DVMM=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 virtual machine monitor to compile for (qemu
> or kvmtool,

Long line?

> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 arm/arm64 only, default is qemu)

Why arm/arm64 only? No plans to use kvmtool for x86 tests?

> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 --processor=3DPROCESSOR=A0 processor to=
 compile for ($arch)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 --cross-prefix=3DPREFIX=A0 cross compil=
er prefix
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 --cc=3DCC=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 c compiler to use ($cc)
> @@ -71,6 +74,9 @@ while [[ "$1" =3D -* ]]; do
> =A0=A0=A0=A0=A0=A0=A0 --ld)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ld=3D"$arg"
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ;;
> +=A0=A0=A0=A0=A0=A0 --vmm)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vmm=3D"$arg"
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ;;
> =A0=A0=A0=A0=A0=A0=A0 --enable-pretty-print-stacks)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pretty_print_stacks=3Dyes
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ;;
> @@ -108,6 +114,14 @@ if [ "$arch" =3D "i386" ] || [ "$arch" =3D "x86_64" =
]; then
> =A0=A0=A0=A0 testdir=3Dx86
> =A0elif [ "$arch" =3D "arm" ] || [ "$arch" =3D "arm64" ]; then
> =A0=A0=A0=A0 testdir=3Darm
> +=A0=A0=A0 if [ "$vmm" =3D "qemu" ]; then
> +=A0=A0=A0=A0=A0=A0=A0 uart_early_base=3D0x09000000
> +=A0=A0=A0 elif [ "$vmm" =3D "kvmtool" ]; then
> +=A0=A0=A0=A0=A0=A0=A0 uart_early_base=3D0x3f8
> +=A0=A0=A0 else
> +=A0=A0=A0=A0=A0=A0=A0 echo '--vmm must be one of "qemu" or "kvmtool"'
> +=A0=A0=A0=A0=A0=A0=A0 usage

Checking the vmm is qemu or kvmtool can be moved out of the if-arm block
if we decide it can be for other architectures. If uart_early_base is only
and arm thing, then 'arm' should probably be in its name. Could also
rename 'base' to 'addr' to accommodate ioports.


> +=A0=A0=A0 fi
> =A0elif [ "$arch" =3D "ppc64" ]; then
> =A0=A0=A0=A0 testdir=3Dpowerpc
> =A0=A0=A0=A0 firmware=3D"$testdir/boot_rom.bin"
> @@ -198,3 +212,16 @@ ENVIRON_DEFAULT=3D$environ_default
> =A0ERRATATXT=3Derrata.txt
> =A0U32_LONG_FMT=3D$u32_long
> =A0EOF
> +
> +cat <<EOF > lib/config.h
> +#ifndef CONFIG_H
> +#define CONFIG_H 1

Should add a header stating this is a generated file like
make_asm_offsets has in scripts/asm-offsets.mak

> +EOF
> +if [ "$arch" =3D "arm" ] || [ "$arch" =3D "arm64" ]; then
> +cat <<EOF >> lib/config.h
> +#define UART_EARLY_BASE ${uart_early_base}UL

Drop the 'UL'. If somebody attempted to supply it themselves it'd end up
being ULUL. Just add another cast to where the value gets used to handle
the type.

> +EOF
> +fi
> +cat <<EOF >> lib/config.h
> +#endif
> +EOF

The one line appends could use 'echo' to take 2 less lines each.

> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index 9fe9bd0bf659..0a3e8f237ab8 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -11,6 +11,7 @@
> =A0#include <libcflat.h>
> =A0#include <devicetree.h>
> =A0#include <chr-testdev.h>
> +#include <config.h>
> =A0#include "arm/asm/psci.h"
> =A0#include <asm/spinlock.h>
> =A0#include <asm/io.h>
> @@ -21,15 +22,6 @@ extern void halt(int code);
> =A0
> =A0static bool testdev_enabled;
> =A0
> -/*
> - * Use this guess for the pl011 base in order to make an attempt at
> - * having earlier printf support. We'll overwrite it with the real
> - * base address that we read from the device tree later. This is
> - * the address we expect QEMU's mach-virt machine type to put in
> - * its generated device tree.
> - */
> -#define UART_EARLY_BASE 0x09000000UL
> -
> =A0static struct spinlock uart_lock;
> =A0static volatile u8 *uart0_base =3D (u8 *)UART_EARLY_BASE;
> =

> Putting config.h in lib makes it available for other architectures, in ca=
se they
> want to implement something similar. Please suggest another location if t=
here is
> a better one.
> =

> I think this looks better than using architecture-specific compile-time d=
efines
> buried in arm/Makefile.common, what do you think?
>

Yes, I agree this looks better. You'll probably want to add a
lib/.gitignore for the file too and also remove it when
'make distclean' is run.

Thanks,
drew
