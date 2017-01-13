From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 1/6] libcflat: add PRI(dux)32 format types
Date: Fri, 13 Jan 2017 19:03:41 +0100
Message-ID: <20170113180341.3hvo4ixs74kjgcmo@kamzik.brq.redhat.com>
References: <20170111162841.15569-1-alex.bennee@linaro.org>
 <20170111162841.15569-2-alex.bennee@linaro.org>
 <4286b719-ff75-d2cd-68b5-cb9d9bb89553@redhat.com>
 <20170112165629.nbczamlqlpsqaauh@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A674402EC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 13:02:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KxFu+UjzZJQE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Jan 2017 13:01:58 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C8C7B402AF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 13:01:58 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170112165629.nbczamlqlpsqaauh@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 12, 2017 at 05:56:29PM +0100, Andrew Jones wrote:
> On Thu, Jan 12, 2017 at 01:29:24PM +0100, Paolo Bonzini wrote:
> > =

> > =

> > On 11/01/2017 17:28, Alex Benn=E9e wrote:
> > > So we can have portable formatting of uint32_t types. However there is
> > > a catch. Different compilers can use legally subtly different types
> > > though so we need to probe the compiler defined intdef.h first.
> > =

> > Interesting, what platform has long uint32_t?  I thought the issue was
> > whether 64-bit is long or "long long".
> > =

> > Paolo
> > =

> > > Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> > > ---
> > >  Makefile       |  1 +
> > >  configure      | 13 +++++++++++++
> > >  lib/libcflat.h |  9 +++++++++
> > >  3 files changed, 23 insertions(+)
> > > =

> > > diff --git a/Makefile b/Makefile
> > > index a32333b..9822d9a 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -55,6 +55,7 @@ CFLAGS +=3D $(fomit_frame_pointer)
> > >  CFLAGS +=3D $(fno_stack_protector)
> > >  CFLAGS +=3D $(fno_stack_protector_all)
> > >  CFLAGS +=3D $(wno_frame_address)
> > > +CFLAGS +=3D $(if $(U32_LONG_FMT),-D__U32_LONG_FMT__,)
> > >  =

> > >  CXXFLAGS +=3D $(CFLAGS)
> > >  =

> > > diff --git a/configure b/configure
> > > index 995c8fa..127868c 100755
> > > --- a/configure
> > > +++ b/configure
> > > @@ -109,6 +109,18 @@ if [ -f $testdir/run ]; then
> > >      ln -fs $testdir/run $testdir-run
> > >  fi
> > >  =

> > > +# check if uint32_t needs a long format modifier
> > > +cat << EOF > lib_test.c
> > > +#include <inttypes.h>
> > > +EOF
> > > +
> > > +$cross_prefix$cc lib_test.c -E | grep "typedef" | grep "long" | grep=
 "uint32_t" &> /dev/null
> =

> This won't work with cross compilers that don't have inttypes.h in their
> path (like mine). How about something like

Paolo,

I see you merged the above. As I stated in this mail, that doesn't work
for my environment, neither arm nor powerpc cross-compile for me now...

Please replace with something like I proposed below. We can probably
replace the awk with a grep though.

Thanks,
drew


> =

>  cat << EOF > lib_test.c
>  __UINT32_TYPE__
>  EOF
>  u32_long=3D"`aarch64-linux-gnu-gcc lib_test.c -E | awk '/unsigned/ && $2=
 =3D=3D "long"'`"
> =

> Although I feel there should be a compiler macro way to do this without
> a need for configure/makefile trickery at all...
> =

> Thanks,
> drew
> =

> =

> > > +exit=3D$?
> > > +if [ $exit -eq 0 ]; then
> > > +    u32_long=3Dtrue
> > > +fi
> > > +rm -f lib_test.c
> > > +
> > >  # check for dependent 32 bit libraries
> > >  if [ "$arch" !=3D "arm" ]; then
> > >  cat << EOF > lib_test.c
> > > @@ -155,4 +167,5 @@ TEST_DIR=3D$testdir
> > >  FIRMWARE=3D$firmware
> > >  ENDIAN=3D$endian
> > >  PRETTY_PRINT_STACKS=3D$pretty_print_stacks
> > > +U32_LONG_FMT=3D$u32_long
> > >  EOF
> > > diff --git a/lib/libcflat.h b/lib/libcflat.h
> > > index 380395f..e80fc50 100644
> > > --- a/lib/libcflat.h
> > > +++ b/lib/libcflat.h
> > > @@ -58,12 +58,21 @@ typedef _Bool		bool;
> > >  #define true  1
> > >  =

> > >  #if __SIZEOF_LONG__ =3D=3D 8
> > > +#  define __PRI32_PREFIX
> > >  #  define __PRI64_PREFIX	"l"
> > >  #  define __PRIPTR_PREFIX	"l"
> > >  #else
> > > +#if defined(__U32_LONG_FMT__)
> > > +#  define __PRI32_PREFIX        "l"
> > > +#else
> > > +#  define __PRI32_PREFIX
> > > +#endif
> > >  #  define __PRI64_PREFIX	"ll"
> > >  #  define __PRIPTR_PREFIX
> > >  #endif
> > > +#define PRId32  __PRI32_PREFIX	"d"
> > > +#define PRIu32  __PRI32_PREFIX	"u"
> > > +#define PRIx32  __PRI32_PREFIX	"x"
> > >  #define PRId64  __PRI64_PREFIX	"d"
> > >  #define PRIu64  __PRI64_PREFIX	"u"
> > >  #define PRIx64  __PRI64_PREFIX	"x"
> > > =

> > --
> > To unsubscribe from this list: send the line "unsubscribe kvm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
