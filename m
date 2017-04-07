From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC kvm-unit-tests PATCH 1/8] configure: make it run-able from
 outside source tree
Date: Fri, 7 Apr 2017 13:40:53 +0200
Message-ID: <20170407114053.powj76325kjseqek@kamzik.brq.redhat.com>
References: <20170406190727.5624-1-alex.bennee@linaro.org>
 <20170406190727.5624-2-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69A2540C41
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Apr 2017 07:38:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NZz4tjJJOBSx for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Apr 2017 07:38:42 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 371E240BAC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Apr 2017 07:38:41 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170406190727.5624-2-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 06, 2017 at 08:07:20PM +0100, Alex Benn=E9e wrote:
> This is a first step to enabling out-of-tree builds for
> kvm-unit-tests. When you invoke configure like this:
> =

>   ../tree.git/configure [args]
> =

> It will detect we the case and:
> =

>   - link ../tree.git/Makefile to the build-dir
>   - ensure lib is created with a correct lib/asm
>   - set SRCDIR in the config.mk
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> ---
>  configure | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
> =

> diff --git a/configure b/configure
> index 8821f37..223809c 100755
> --- a/configure
> +++ b/configure
> @@ -1,5 +1,6 @@
>  #!/bin/bash
>  =

> +srcdir=3D$(cd "$(dirname "$0")"; pwd)

Why not just $(dirname "$0")? Any reason the path can't
be relative?  Also, could use realpath vs. the cd/pwd.

>  prefix=3D/usr/local
>  cc=3Dgcc
>  ld=3Dld
> @@ -102,12 +103,12 @@ elif [ "$arch" =3D "ppc64" ]; then
>  else
>      testdir=3D$arch
>  fi
> -if [ ! -d $testdir ]; then
> +if [ ! -d $srcdir/$testdir ]; then
>      echo "$testdir does not exist!"
>      exit 1
>  fi
> -if [ -f $testdir/run ]; then
> -    ln -fs $testdir/run $testdir-run
> +if [ -f $srcdir/$testdir/run ]; then
> +    ln -fs $srcdir/$testdir/run $testdir-run
>  fi

$srcdir could have spaces in it, so now we need "" on all these
references, e.g. [ -f "$srcdir/$testdir/run" ]

>  =

>  # check if uint32_t needs a long format modifier
> @@ -135,18 +136,27 @@ fi
>  rm -f lib_test.c
>  fi
>  =

> +# Are we in a separate build tree? If so, link the Makefile
> +# so that 'make' works.
> +if test ! -e Makefile; then

[ ! -e Makefile ]

> +    echo "linking Makefile..."
> +    ln -s "${srcdir}/Makefile" .

No need for the {}

> +fi
> +
>  # link lib/asm for the architecture
>  rm -f lib/asm
>  asm=3Dasm-generic
> -if [ -d lib/$arch/asm ]; then
> -	asm=3D$arch/asm
> -elif [ -d lib/$testdir/asm ]; then
> -	asm=3D$testdir/asm
> +if [ -d $srcdir/lib/$arch/asm ]; then
> +	asm=3D$srcdir/lib/$arch/asm
> +elif [ -d $srcdir/lib/$testdir/asm ]; then
> +	asm=3D$srcdir/lib/$testdir/asm

""'s

>  fi
> +mkdir -p lib
>  ln -s $asm lib/asm
>  =

>  # create the config
>  cat <<EOF > config.mak
> +SRCDIR=3D$srcdir
>  PREFIX=3D$prefix
>  HOST=3D$host
>  ARCH=3D$arch
> -- =

> 2.11.0
>

Thanks,
drew
