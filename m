From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 2/7] lib: arm: Remove warning about
 uart0_base mismatch
Date: Mon, 28 Jan 2019 17:31:01 +0100
Message-ID: <20190128163101.dajq6ofgmpctg3ne@kamzik.brq.redhat.com>
References: <20190124111634.4727-1-alexandru.elisei@arm.com>
 <20190124111634.4727-3-alexandru.elisei@arm.com>
 <20190124115943.12296810@donnerap.cambridge.arm.com>
 <20190124123740.v52nkbcki5dp2hpq@kamzik.brq.redhat.com>
 <ffcc5f60-c5a0-c7f1-7fb1-658d8eea6fc4@arm.com>
 <20190125164751.cdfip3kv63uonl7n@kamzik.brq.redhat.com>
 <42b3a17b-088b-b9b7-4dac-34f07aa09c8a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE1004A2F8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 11:31:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qww3yknkuGVC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Jan 2019 11:31:06 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC5414A2E9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 11:31:05 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <42b3a17b-088b-b9b7-4dac-34f07aa09c8a@arm.com>
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

On Mon, Jan 28, 2019 at 02:24:29PM +0000, Alexandru Elisei wrote:
> On 1/25/19 4:47 PM, Andrew Jones wrote:
> > On Fri, Jan 25, 2019 at 04:36:13PM +0000, Alexandru Elisei wrote:
> >> On 1/24/19 12:37 PM, Andrew Jones wrote:
> >>> On Thu, Jan 24, 2019 at 11:59:43AM +0000, Andre Przywara wrote:
> >>>> On Thu, 24 Jan 2019 11:16:29 +0000
> >>>> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >>>>
> >>>>> A warning is displayed if uart0_base is different from what the code
> >>>>> expects qemu to generate for the pl011 UART in the device tree.
> >>>>> However, now we support the ns16550a UART emulated by kvmtool, which
> >>>>> has a different address. This leads to the  warning being displayed
> >>>>> even though the UART is configured and working as expected.
> >>>>>
> >>>>> Now that we support multiple UARTs, the warning serves no purpose, =
so
> >>>>> remove it.
> >>>> Mmh, but we use that address before, right? So for anything not
> >>>> emulating an UART at this QEMU specific address we write to some ran=
dom
> >>>> (device) memory?
> >>>>
> >>>> Drew, how important is this early print feature for kvm-unit-tests?
> >>> The setup code passes through quite a few asserts before getting thro=
ugh
> >>> io_init() (including in uart0_init), so I think there's still value in
> >>> having a guessed UART address. Maybe we can provide guesses for both
> >>> QEMU and kvmtool, and some selection method, that would be used until
> >>> we've properly assigned uart0_base from DT?
> >>>
> >>>> Cheers,
> >>>> Andre.
> >>>>
> >>>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >>>>> ---
> >>>>>  lib/arm/io.c | 6 ------
> >>>>>  1 file changed, 6 deletions(-)
> >>>>>
> >>>>> diff --git a/lib/arm/io.c b/lib/arm/io.c
> >>>>> index 35fc05aeb4db..87435150f73e 100644
> >>>>> --- a/lib/arm/io.c
> >>>>> +++ b/lib/arm/io.c
> >>>>> @@ -61,12 +61,6 @@ static void uart0_init(void)
> >>>>>  	}
> >>>>>  =

> >>>>>  	uart0_base =3D ioremap(base.addr, base.size);
> >>>>> -
> >>>>> -	if (uart0_base !=3D (u8 *)UART_EARLY_BASE) {
> >>>>> -		printf("WARNING: early print support may not work. "
> >>>>> -		       "Found uart at %p, but early base is %p.\n",
> >>>>> -			uart0_base, (u8 *)UART_EARLY_BASE);
> >>>>> -	}
> >>>>>  }
> >>> This warning is doing what it should, which is pointing out that the
> >>> UART_EARLY_BASE guess appears to be wrong. If we can provide a way
> >>> to support more than one guess, then we should keep this warning but
> >>> adjust it to match one of any of the guesses.
> >>>
> >>> Thanks,
> >>> drew
> >> I'm not really sure how to implement a selection method. I've looked at
> >> splitting io_init() into uart0_init() and chr_testdev_init() and calli=
ng
> >> uart0_init() very early in the setup process, but uart0_init() itself =
uses
> >> printf() and assert().
> >>
> >> I've also thought about adding another function, something like
> >> uart0_early_init(), that is called very early in setup() and gets the =
base
> >> address from the dtb bootargs. But that means calling dt_init() and
> >> dt_get_bootargs(), which can fail.
> >>
> >> One other option that could work is to make it a compile-time configur=
ation.
> >>
> >> What do you think?
> >>
> > Compile-time is fine, which I guess will result in a new configure scri=
pt
> > option as well. I wonder if we shouldn't consider generating a config.h
> > file with stuff like this rather than adding another -D to the compile
> > line.
> >
> > drew =

> =

> I propose a new configuration option called --vmm, with possible values q=
emu and
> kvmtool, which defaults to qemu if not set.
> =

> Another possibility would be to have an --uart-base option, but that mean=
s we
> are expecting the user to be aware of the uart base address for the virtu=
al
> machine manager, which might be unreasonable.
> =

> This is a quick prototype of how using -D for conditional compilation wou=
ld look
> like (the configure changes are included too):
> =

> diff --git a/configure b/configure
> index df8581e3a906..7a56ba47707f 100755
> --- a/configure
> +++ b/configure
> @@ -70,6 +70,9 @@ while [[ "$1" =3D -* ]]; do
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ;;
> =A0=A0=A0=A0=A0=A0=A0 --ld)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ld=3D"$arg"
> +=A0=A0=A0=A0=A0=A0=A0 ;;
> +=A0=A0=A0 --vmm)
> +=A0=A0=A0=A0=A0=A0=A0 vmm=3D"$arg"
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ;;
> =A0=A0=A0=A0=A0=A0=A0 --enable-pretty-print-stacks)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pretty_print_stacks=3Dyes
> @@ -108,6 +111,14 @@ if [ "$arch" =3D "i386" ] || [ "$arch" =3D "x86_64" =
]; then
> =A0=A0=A0=A0 testdir=3Dx86
> =A0elif [ "$arch" =3D "arm" ] || [ "$arch" =3D "arm64" ]; then
> =A0=A0=A0=A0 testdir=3Darm
> +=A0=A0=A0 if [ -z "$vmm" ] || [ "$vmm" =3D "qemu" ]; then
> +=A0=A0=A0=A0=A0=A0=A0 uart_early_base=3D0x09000000UL

You can drop the 'UL'.

> +=A0=A0=A0 elif [ "$vmm" =3D "kvmtool" ]; then
> +=A0=A0=A0=A0=A0=A0=A0 uart_early_base=3D0x3f8
> +=A0=A0=A0 else
> +=A0=A0=A0=A0=A0=A0=A0 echo '--vmm must be one of "qemu" or "kvmtool"'
> +=A0=A0=A0=A0=A0=A0=A0 usage

You're outputting usage here, but you didn't add vmm to the help text.

> +=A0=A0=A0 fi
> =A0elif [ "$arch" =3D "ppc64" ]; then
> =A0=A0=A0=A0 testdir=3Dpowerpc
> =A0=A0=A0=A0 firmware=3D"$testdir/boot_rom.bin"
> @@ -197,4 +208,5 @@ PRETTY_PRINT_STACKS=3D$pretty_print_stacks
> =A0ENVIRON_DEFAULT=3D$environ_default
> =A0ERRATATXT=3Derrata.txt
> =A0U32_LONG_FMT=3D$u32_long
> +UART_EARLY_BASE=3D$uart_early_base
> =A0EOF
> diff --git a/Makefile b/Makefile
> index e9f02272e156..225c2a525cdf 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -72,6 +72,10 @@ COMMON_CFLAGS +=3D $(fno_pic) $(no_pie)
> =A0CFLAGS +=3D $(COMMON_CFLAGS)
> =A0CFLAGS +=3D -Wmissing-parameter-type -Wold-style-declaration -Woverrid=
e-init
> =A0
> +ifneq ($(UART_EARLY_BASE),)
> +CFLAGS +=3D -DUART_EARLY_BASE=3D$(UART_EARLY_BASE)
> +endif

This type of thing is what I would like to avoid by introducing a
config.h file. In the least we shouldn't add this -D to CFLAGS for
all architectures. It can be added to the %.elf rule in
arm/Makefile.common

> +
> =A0CXXFLAGS +=3D $(COMMON_CFLAGS)
> =A0
> =A0autodepend-flags =3D -MMD -MF $(dir $*).$(notdir $*).d
>

You'll also want to patch lib/arm/io.c with
 =

-/*
- * Use this guess for the pl011 base in order to make an attempt at
- * having earlier printf support. We'll overwrite it with the real
- * base address that we read from the device tree later. This is
- * the address we expect QEMU's mach-virt machine type to put in
- * its generated device tree.
- */
-#define UART_EARLY_BASE 0x09000000UL
-
 static struct spinlock uart_lock;
-static volatile u8 *uart0_base =3D (u8 *)UART_EARLY_BASE;
+static volatile u8 *uart0_base =3D (u8 *)(unsigned long)UART_EARLY_BASE;



This is all a bit on the ugly side, but I can't think of anything
better. =


Thanks,
drew
